package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.models.*;
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
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.UUID;
import java.util.ArrayList;

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

        logger.info(">>> [CHECKOUT GET] Loading checkout page from session");

        try {
            // ✅ Lấy dữ liệu từ SESSION (không phải DB)
            @SuppressWarnings("unchecked")
            List<Integer> selectedTableIds = (List<Integer>) session.getAttribute("selectedTableIds");

            @SuppressWarnings("unchecked")
            List<OrderItem> orderItems = (List<OrderItem>) session.getAttribute("cartItems");

            String dateStr = (String) session.getAttribute("requiredDate");
            String timeStr = (String) session.getAttribute("requiredTime");
            Integer guestCount = (Integer) session.getAttribute("guestCount");
            String specialRequest = (String) session.getAttribute("specialRequest");

            // Kiểm tra dữ liệu
            if (selectedTableIds == null || selectedTableIds.isEmpty()) {
                logger.warn("⚠️ No tables in session, redirecting to findTable");
                response.sendRedirect("findTable");
                return;
            }

            // Lấy thông tin bàn chi tiết
            List<Table> selectedTables = new ArrayList<>();
            for (Integer tableId : selectedTableIds) {
                Table table = tableDAO.getTableById(tableId);
                if (table != null) {
                    selectedTables.add(table);
                }
            }

            // Tạo Reservation object tạm để hiển thị (chưa lưu DB)
            Reservation reservation = new Reservation(
                    0,
                    (Integer) session.getAttribute("userId"),
                    0,
                    guestCount != null ? guestCount : 0,
                    null,
                    "PENDING",
                    guestCount != null ? guestCount : 0
            );
            if (dateStr != null && !dateStr.isEmpty()) {
                reservation.setReservationDate(LocalDate.parse(dateStr));
            }
            if (timeStr != null && !timeStr.isEmpty()) {
                reservation.setReservationTime(LocalTime.parse(timeStr));
            }
            reservation.setSpecialRequests(specialRequest);

            // Tính tổng tiền
            BigDecimal totalAmount = BigDecimal.ZERO;
            if (orderItems != null && !orderItems.isEmpty()) {
                for (OrderItem item : orderItems) {
                    totalAmount = totalAmount.add(
                            item.getUnitPrice().multiply(new BigDecimal(item.getQuantity()))
                    );
                }
            }
            reservation.setTotalAmount(totalAmount);

            logger.info("✅ Loaded {} order items and {} tables from session",
                    orderItems != null ? orderItems.size() : 0,
                    selectedTables.size());

            // ✅ Set các attributes
            request.setAttribute("reservation", reservation);
            request.setAttribute("currentItems", orderItems != null ? orderItems : new ArrayList<>());
            request.setAttribute("selectedTables", selectedTables);

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

        logger.info(">>> [CHECKOUT POST] Confirming reservation");

        try {
            String action = request.getParameter("action");
            logger.info(">>> action: {}", action);

            if ("confirm".equals(action)) {
                // ✅ Lấy dữ liệu từ SESSION
                @SuppressWarnings("unchecked")
                List<Integer> selectedTableIds = (List<Integer>) session.getAttribute("selectedTableIds");

                @SuppressWarnings("unchecked")
                List<OrderItem> orderItems = (List<OrderItem>) session.getAttribute("cartItems");

                String dateStr = (String) session.getAttribute("requiredDate");
                String timeStr = (String) session.getAttribute("requiredTime");
                Integer guestCount = (Integer) session.getAttribute("guestCount");
                String specialRequest = (String) session.getAttribute("specialRequest");
                Integer userId = (Integer) session.getAttribute("userId");

                // Kiểm tra dữ liệu
                if (selectedTableIds == null || selectedTableIds.isEmpty()) {
                    logger.error("❌ No tables in session");
                    response.sendRedirect("findTable");
                    return;
                }

                if (userId == null || dateStr == null || timeStr == null || guestCount == null) {
                    logger.error("❌ Missing required data in session");
                    response.sendRedirect("findTable");
                    return;
                }

                // ✅ Lấy payment method từ form
                String paymentMethod = request.getParameter("paymentMethod");
                if (paymentMethod == null || paymentMethod.isEmpty()) {
                    paymentMethod = "CASH";
                }

                logger.info(">>> paymentMethod: {}", paymentMethod);

                Integer editingReservationId = (Integer) session.getAttribute("editingReservationId");

                // ✅ Chuẩn bị dữ liệu Reservation
                Reservation reservation = new Reservation(
                        0,
                        userId,
                        0,
                        guestCount,
                        null,
                        "PENDING",
                        guestCount
                );
                reservation.setReservationDate(LocalDate.parse(dateStr));
                reservation.setReservationTime(LocalTime.parse(timeStr));
                reservation.setSpecialRequests(specialRequest);

                // Tính tổng tiền
                BigDecimal totalAmount = BigDecimal.ZERO;
                if (orderItems != null && !orderItems.isEmpty()) {
                    for (OrderItem item : orderItems) {
                        totalAmount = totalAmount.add(
                                item.getUnitPrice().multiply(new BigDecimal(item.getQuantity()))
                        );
                    }
                }
                reservation.setTotalAmount(totalAmount);

                int reservationId;
                if (editingReservationId != null && editingReservationId > 0) {
                    // ✅ Chế độ chỉnh sửa: cập nhật đơn cũ
                    reservationId = editingReservationId;
                    boolean updated = reservationDAO.updateReservationDetails(
                            reservationId,
                            reservation.getReservationDate(),
                            reservation.getReservationTime(),
                            reservation.getGuestCount(),
                            reservation.getSpecialRequests(),
                            totalAmount
                    );
                    if (!updated) {
                        logger.error("❌ Failed to update reservation {}", reservationId);
                        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Không thể cập nhật đơn đặt bàn");
                        return;
                    }

                    // Ghi đè tables và items
                    reservationTableDAO.removeAllTablesFromReservation(reservationId);
                    orderItemDAO.deleteAllOrderItemsForReservation(reservationId);
                } else {
                    // ✅ Tạo mới
                    reservation.setTotalAmount(totalAmount);
                    reservationId = reservationDAO.createReservation(reservation);
                    if (reservationId <= 0) {
                        logger.error("❌ Failed to create reservation");
                        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Không thể tạo đơn đặt bàn");
                        return;
                    }
                }

                if (reservationId <= 0) {
                    logger.error("❌ Failed to create reservation");
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Không thể tạo đơn đặt bàn");
                    return;
                }

                logger.info("✅ Created reservation with ID: {}", reservationId);

                // ✅ Ghi Order_Items
                if (orderItems != null && !orderItems.isEmpty()) {
                    for (OrderItem item : orderItems) {
                        OrderItem dbItem = new OrderItem(reservationId, item.getItemId(), item.getQuantity(), item.getUnitPrice());
                        dbItem.setSpecialInstructions(item.getSpecialInstructions());
                        dbItem.setStatus(item.getStatus());
                        orderItemDAO.addOrderItem(dbItem);
                    }
                    logger.info("✅ Created {} order items", orderItems.size());
                }

                // ✅ Ghi Reservation_Tables
                for (Integer tableId : selectedTableIds) {
                    reservationTableDAO.addTableToReservation(reservationId, tableId);
                    tableDAO.updateTableStatus(tableId, "RESERVED");
                }
                logger.info("✅ Added {} tables to reservation", selectedTableIds.size());

                // ✅ Kiểm tra có order items không
                if (orderItems == null || orderItems.isEmpty()) {
                    logger.warn("⚠️ No order items for reservation {}", reservationId);
                }

                logger.info("✅ Processing payment for reservation {} with {} items",
                        reservationId, orderItems != null ? orderItems.size() : 0);

                // ✅ TẠO PAYMENT record
                Payment payment = new Payment(reservationId, paymentMethod, totalAmount.longValue());

                // Tất cả đơn đặt bàn online đều bắt đầu ở trạng thái PENDING
                // Payment status: PENDING vì chưa thanh toán
                payment.setPaymentStatus("PENDING");

                // Đối với CASH: sẽ thanh toán khi đến nhà hàng
                // Đối với CREDIT_CARD/E_WALLET: sẽ xử lý thanh toán online (có thể kết hợp gateway)
                // Tạm thời tất cả đều set PENDING

                logger.info("💳 Payment method: {} - Status: PENDING", paymentMethod);

                payment.setTransactionId(UUID.randomUUID().toString());

                int paymentId = paymentDAO.createPayment(payment);

                if (paymentId > 0) {
                    logger.info("✅ Payment created with ID: {}", paymentId);

                    // ✅ Reservation status vẫn giữ PENDING (đã set khi tạo reservation ở trên)
                    logger.info("✅ Reservation status: PENDING - awaiting confirmation");

                    // ✅ Clear session
                    session.removeAttribute("selectedTableIds");
                    session.removeAttribute("cartItems");
                    session.removeAttribute("requiredDate");
                    session.removeAttribute("requiredTime");
                    session.removeAttribute("guestCount");
                    session.removeAttribute("specialRequest");
                    session.removeAttribute("editingReservationId");

                    logger.info("✅ Checkout completed successfully for reservation {}", reservationId);

                    // ✅ Redirect to details page for edited or new reservation
                    response.sendRedirect("orderDetails?id=" + reservationId);
                } else {
                    logger.error("❌ Failed to create payment");
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi xử lý thanh toán");
                }
            }

        } catch (Exception e) {
            logger.error("❌ Error in CheckoutServlet POST", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Có lỗi xảy ra: " + e.getMessage());
        }
    }
}