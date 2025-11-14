package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.models.Reservation;
import com.fpt.restaurantbooking.models.Payment;
import com.fpt.restaurantbooking.repositories.impl.ReservationDAO;
import com.fpt.restaurantbooking.repositories.impl.ReservationTableDAO;
import com.fpt.restaurantbooking.repositories.impl.TableDAO;
import com.fpt.restaurantbooking.repositories.impl.PaymentDAO;
import com.fpt.restaurantbooking.services.RefundService;
import com.fpt.restaurantbooking.services.EmailService;
import com.fpt.restaurantbooking.dto.OrderManagementDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet("/cancelOrder")
public class CancelOrderServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(CancelOrderServlet.class);

    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final ReservationTableDAO reservationTableDAO = new ReservationTableDAO();
    private final TableDAO tableDAO = new TableDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();
    private final RefundService refundService = new RefundService();
    private final EmailService emailService = new EmailService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect("login");
            return;
        }

        String reservationIdParam = request.getParameter("reservationId");
        if (reservationIdParam == null) {
            response.sendRedirect("orderHistory");
            return;
        }

        try {
            int reservationId = Integer.parseInt(reservationIdParam);
            Reservation reservation = reservationDAO.getReservationById(reservationId);

            if (reservation == null) {
                request.setAttribute("errorMessage", "Không tìm thấy đơn đặt bàn.");
                request.getRequestDispatcher("/WEB-INF/BookTable/cancelOrder.jsp").forward(request, response);
                return;
            }

            // Verify ownership
            if (!reservation.getUserId().equals(userId)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }

            // Check if can be cancelled
            if (!"PENDING".equals(reservation.getStatus()) && !"CONFIRMED".equals(reservation.getStatus())) {
                request.setAttribute("errorMessage", "Chỉ có thể hủy đơn đang chờ hoặc đã xác nhận.");
                request.getRequestDispatcher("/WEB-INF/BookTable/cancelOrder.jsp").forward(request, response);
                return;
            }

            // Get tables for this reservation
            List<Integer> tableIds = reservationTableDAO.getTablesByReservationId(reservationId);

            // Get payment information to check for deposit
            Payment payment = paymentDAO.getPaymentByReservationId(reservationId);

            request.setAttribute("reservation", reservation);
            request.setAttribute("tableIds", tableIds);
            request.setAttribute("payment", payment);
            request.getRequestDispatcher("/WEB-INF/BookTable/cancelOrder.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("orderHistory");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect("login");
            return;
        }

        try {
            String reservationIdParam = request.getParameter("reservationId");
            String reason = request.getParameter("reason");

            if (reservationIdParam == null || reason == null || reason.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Vui lòng cung cấp lý do hủy.");
                doGet(request, response);
                return;
            }

            int reservationId = Integer.parseInt(reservationIdParam);
            Reservation reservation = reservationDAO.getReservationById(reservationId);

            if (reservation == null || !reservation.getUserId().equals(userId)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }

            // Tính toán refund dựa trên quy định mới
            Payment payment = paymentDAO.getPaymentByReservationId(reservationId);
            LocalDateTime cancellationTime = LocalDateTime.now();
            boolean isNoShow = false; // Hủy bởi khách, không phải no-show
            
            // Tính toán refund
            RefundService.RefundResult refundResult = null;
            if (payment != null) {
                refundResult = refundService.calculateRefund(reservation, payment, cancellationTime, isNoShow);
                logger.info("💳 Refund calculation for reservation {}: Amount={}, Eligible={}, Reason={}",
                        reservationId, refundResult.getRefundAmount(), refundResult.isEligible(), refundResult.getReason());
            }

            // Cancel reservation
            boolean cancelled = reservationDAO.cancelReservation(reservationId, reason);

            if (cancelled) {
                // Release tables
                List<Integer> tableIds = reservationTableDAO.getTablesByReservationId(reservationId);
                for (Integer tableId : tableIds) {
                    tableDAO.updateTableStatus(tableId, "AVAILABLE");
                }

                // Gửi email thông báo refund nếu có
                if (refundResult != null && refundResult.isEligible() && refundResult.getRefundAmount().compareTo(java.math.BigDecimal.ZERO) > 0) {
                    try {
                        OrderManagementDTO orderDetails = reservationDAO.getReservationDetailsById(reservationId);
                        if (orderDetails != null && orderDetails.getCustomerEmail() != null) {
                            boolean isDepositRefund = "CASH".equals(payment.getPaymentMethod());
                            boolean emailSent = emailService.sendRefundNotificationEmail(
                                    orderDetails, 
                                    refundResult.getRefundAmount(), 
                                    refundResult.getReason(),
                                    isDepositRefund
                            );
                            if (emailSent) {
                                logger.info("✅ Refund notification email sent for reservation {}", reservationId);
                            } else {
                                logger.warn("⚠️ Failed to send refund notification email for reservation {}", reservationId);
                            }
                        }
                    } catch (Exception e) {
                        logger.error("Error sending refund notification email for reservation {}", reservationId, e);
                    }
                }

                logger.info("✅ Cancelled reservation {} by user {}", reservationId, userId);
                response.sendRedirect("orderHistory?cancelled=true");
            } else {
                request.setAttribute("errorMessage", "Không thể hủy đơn. Vui lòng thử lại.");
                doGet(request, response);
            }

        } catch (Exception e) {
            logger.error("❌ Error cancelling order", e);
            request.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            doGet(request, response);
        }
    }
}

