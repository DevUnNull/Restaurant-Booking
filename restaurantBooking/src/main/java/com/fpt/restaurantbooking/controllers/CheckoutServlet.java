package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.models.OrderItem;
import com.fpt.restaurantbooking.models.Payment;
import com.fpt.restaurantbooking.models.Reservation;
import com.fpt.restaurantbooking.repositories.impl.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(CheckoutServlet.class);
    private ReservationDAO reservationDAO = new ReservationDAO();
    private PaymentDAO paymentDAO = new PaymentDAO();
    private TableDAO tableDAO = new TableDAO();
    private ReservationTableDAO reservationTableDAO = new ReservationTableDAO();
    private OrderItemDAO orderItemDAO = new OrderItemDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer reservationId = (Integer) session.getAttribute("reservationId");

        logger.info(">>> [CHECKOUT GET] reservationId: {}", reservationId);

        if (reservationId == null) {
            logger.warn("⚠️ No reservationId in session, redirecting to findTable");
            response.sendRedirect("findTable");
            return;
        }

        try {
            // ✅ Lấy thông tin reservation
            Reservation reservation = reservationDAO.getReservationById(reservationId);

            if (reservation == null) {
                logger.error("❌ Reservation not found: {}", reservationId);
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy đơn đặt bàn");
                return;
            }

            // ✅ Lấy danh sách order items
            List<OrderItem> orderItems = orderItemDAO.getOrderItemsByReservationId(reservationId);

            logger.info("✅ Found {} order items for reservation {}", orderItems.size(), reservationId);
            logger.info("✅ Total amount: {}", reservation.getTotalAmount());

            // ✅ Set cả 2 attributes
            request.setAttribute("reservation", reservation);
            request.setAttribute("currentItems", orderItems);

            request.getRequestDispatcher("/WEB-INF/BookTable/cartCheckout.jsp").forward(request, response);

        } catch (Exception e) {
            logger.error("❌ Error in CheckoutServlet GET", e);
            request.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/BookTable/cartCheckout.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer reservationId = (Integer) session.getAttribute("reservationId");

        logger.info(">>> [CHECKOUT POST] reservationId: {}", reservationId);

        if (reservationId == null) {
            response.sendRedirect("findTable");
            return;
        }

        try {
            String action = request.getParameter("action");
            logger.info(">>> action: {}", action);

            if ("confirm".equals(action)) {
                // ✅ Lấy payment method từ form
                String paymentMethod = request.getParameter("paymentMethod");
                if (paymentMethod == null || paymentMethod.isEmpty()) {
                    paymentMethod = "CASH";
                }

                logger.info(">>> paymentMethod: {}", paymentMethod);

                // ✅ Lấy thông tin reservation
                Reservation reservation = reservationDAO.getReservationById(reservationId);
                if (reservation == null) {
                    logger.error("❌ Reservation not found: {}", reservationId);
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy đơn đặt bàn");
                    return;
                }

                // ✅ Kiểm tra có order items không
                List<OrderItem> orderItems = orderItemDAO.getOrderItemsByReservationId(reservationId);
                if (orderItems.isEmpty()) {
                    logger.warn("⚠️ No order items for reservation {}", reservationId);
                    request.setAttribute("errorMessage", "Vui lòng chọn ít nhất 1 món ăn trước khi thanh toán");
                    request.setAttribute("reservation", reservation);
                    request.setAttribute("currentItems", orderItems);
                    request.getRequestDispatcher("/WEB-INF/BookTable/cartCheckout.jsp").forward(request, response);
                    return;
                }

                logger.info("✅ Processing payment for reservation {} with {} items", reservationId, orderItems.size());

                // ✅ Tạo payment record
                Payment payment = new Payment(reservationId, paymentMethod,
                        reservation.getTotalAmount().longValue());
                payment.setPaymentStatus("COMPLETED");
                payment.setTransactionId(UUID.randomUUID().toString());

                int paymentId = paymentDAO.createPayment(payment);

                if (paymentId > 0) {
                    logger.info("✅ Payment created with ID: {}", paymentId);

                    // ✅ Update reservation status to CONFIRMED
                    reservationDAO.updateReservationStatus(reservationId, "CONFIRMED");

                    // ✅ Update all table statuses to RESERVED
                    List<Integer> tableIds = reservationTableDAO.getTablesByReservationId(reservationId);
                    for (Integer tableId : tableIds) {
                        tableDAO.updateTableStatus(tableId, "RESERVED");
                        logger.info("✅ Updated table {} status to RESERVED", tableId);
                    }

                    // ✅ Clear session
                    session.removeAttribute("reservationId");
                    session.removeAttribute("requiredDate");
                    session.removeAttribute("requiredTime");
                    session.removeAttribute("guestCount");
                    session.removeAttribute("selectedTables");

                    logger.info("✅ Checkout completed successfully for reservation {}", reservationId);

                    // ✅ Redirect to success page
                    response.sendRedirect("orderHistory?success=true");
                } else {
                    logger.error("❌ Failed to create payment");
                    request.setAttribute("errorMessage", "Lỗi khi xử lý thanh toán");
                    request.setAttribute("reservation", reservation);
                    request.setAttribute("currentItems", orderItems);
                    request.getRequestDispatcher("/WEB-INF/BookTable/cartCheckout.jsp").forward(request, response);
                }
            }

        } catch (Exception e) {
            logger.error("❌ Error in CheckoutServlet POST", e);
            request.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());

            // ✅ Load lại data để hiển thị
            try {
                Reservation reservation = reservationDAO.getReservationById(reservationId);
                List<OrderItem> orderItems = orderItemDAO.getOrderItemsByReservationId(reservationId);
                request.setAttribute("reservation", reservation);
                request.setAttribute("currentItems", orderItems);
            } catch (Exception ex) {
                logger.error("❌ Error loading data for error page", ex);
            }

            request.getRequestDispatcher("/WEB-INF/BookTable/cartCheckout.jsp").forward(request, response);
        }
    }
}