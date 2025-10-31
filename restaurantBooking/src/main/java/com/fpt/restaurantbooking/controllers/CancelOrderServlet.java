package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.models.Reservation;
import com.fpt.restaurantbooking.models.Payment;
import com.fpt.restaurantbooking.repositories.impl.ReservationDAO;
import com.fpt.restaurantbooking.repositories.impl.ReservationTableDAO;
import com.fpt.restaurantbooking.repositories.impl.TableDAO;
import com.fpt.restaurantbooking.repositories.impl.PaymentDAO;
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

            // Kiểm tra nếu hủy sau thời gian đặt bàn và có tiền cọc
            Payment payment = paymentDAO.getPaymentByReservationId(reservationId);
            boolean isCancellingAfterReservationTime = false;
            if (reservation.getReservationDate() != null && reservation.getReservationTime() != null) {
                LocalDateTime reservationDateTime = reservation.getReservationDate().atTime(reservation.getReservationTime());
                LocalDateTime now = LocalDateTime.now();
                isCancellingAfterReservationTime = now.isAfter(reservationDateTime);
            }

            // Nếu hủy sau thời gian đặt bàn và có tiền cọc, cập nhật notes trong payment
            if (isCancellingAfterReservationTime && payment != null &&
                    "CASH".equals(payment.getPaymentMethod())) {
                List<Integer> tableIds = reservationTableDAO.getTablesByReservationId(reservationId);
                int tableCount = tableIds != null ? tableIds.size() : 0;
                long depositAmount = tableCount * 20000L;

                if (depositAmount > 0 && payment.getPaymentId() != null) {
                    String notes = payment.getNotes();
                    if (notes == null) notes = "";
                    notes += String.format("\n[CANCELLED] Deposit %d VNĐ forfeited due to cancellation after reservation time.", depositAmount);
                    paymentDAO.updatePaymentNotes(payment.getPaymentId(), notes);
                    logger.warn("⚠️ Reservation {} cancelled after reservation time. Deposit {} VNĐ will be forfeited.",
                            reservationId, depositAmount);
                }
            }

            // Cancel reservation
            boolean cancelled = reservationDAO.cancelReservation(reservationId, reason);

            if (cancelled) {
                // Release tables
                List<Integer> tableIds = reservationTableDAO.getTablesByReservationId(reservationId);
                for (Integer tableId : tableIds) {
                    tableDAO.updateTableStatus(tableId, "AVAILABLE");
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

