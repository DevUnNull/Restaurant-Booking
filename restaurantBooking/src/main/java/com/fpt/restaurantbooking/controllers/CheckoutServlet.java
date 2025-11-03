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
    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();
    private final TableDAO tableDAO = new TableDAO();
    private final ReservationTableDAO reservationTableDAO = new ReservationTableDAO();
    private final OrderItemDAO orderItemDAO = new OrderItemDAO();
    private final MenuItemDAO menuItemDAO = new MenuItemDAO();

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

            // ✅ Load service combo items (nếu có)
            Integer selectedServiceId = (Integer) session.getAttribute("selectedServiceId");
            List<MenuItem> serviceComboItems = new ArrayList<>();
            java.util.Set<Integer> comboItemIds = new java.util.HashSet<>();
            if (selectedServiceId != null && selectedServiceId > 0) {
                serviceComboItems = menuItemDAO.getMenuItemsByServiceId(selectedServiceId);
                for (MenuItem item : serviceComboItems) {
                    comboItemIds.add(item.getItemId());
                }
                logger.info("✅ Loaded {} combo items for service {}", serviceComboItems.size(), selectedServiceId);
            }

            // 🔄 SẮP XẾP: Món combo lên đầu, món thường ở sau
            if (orderItems != null && !orderItems.isEmpty() && !comboItemIds.isEmpty()) {
                List<OrderItem> sortedItems = new ArrayList<>();
                List<OrderItem> comboItems = new ArrayList<>();
                List<OrderItem> regularItems = new ArrayList<>();

                for (OrderItem item : orderItems) {
                    if (comboItemIds.contains(item.getItemId())) {
                        comboItems.add(item);
                    } else {
                        regularItems.add(item);
                    }
                }

                sortedItems.addAll(comboItems);  // Combo items trước
                sortedItems.addAll(regularItems); // Món thường sau
                orderItems = sortedItems;
                logger.info("✅ Sorted items: {} combo + {} regular", comboItems.size(), regularItems.size());
            }

            // ✅ Set các attributes
            request.setAttribute("reservation", reservation);
            request.setAttribute("currentItems", orderItems != null ? orderItems : new ArrayList<>());
            request.setAttribute("selectedTables", selectedTables);
            request.setAttribute("serviceComboItems", serviceComboItems);
            request.setAttribute("selectedServiceId", selectedServiceId);

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

                // Tính phí đặt cọc nếu thanh toán tại quán (CASH)
                BigDecimal depositAmount = BigDecimal.ZERO;
                int tableCount = selectedTableIds != null ? selectedTableIds.size() : 0;
                if ("CASH".equals(paymentMethod) && tableCount > 0) {
                    depositAmount = new BigDecimal(tableCount).multiply(new BigDecimal(20000)); // 20,000 VNĐ per table
                    logger.info("💳 Deposit calculated: {} tables × 20,000 = {} VNĐ", tableCount, depositAmount);
                }

                // Tổng tiền bao gồm cả tiền cọc
                BigDecimal finalAmount = totalAmount.add(depositAmount);
                reservation.setTotalAmount(finalAmount);

                int reservationId;
                boolean isEditing = false;
                if (editingReservationId != null && editingReservationId > 0) {
                    // ✅ Chế độ chỉnh sửa: cập nhật đơn cũ
                    reservationId = editingReservationId;
                    isEditing = true;
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
                Payment payment = new Payment(reservationId, paymentMethod, finalAmount.longValue());

                // Tất cả đơn đặt bàn online đều bắt đầu ở trạng thái PENDING
                // Payment status: PENDING vì chưa thanh toán
                payment.setPaymentStatus("PENDING");

                // Đối với CASH: sẽ thanh toán khi đến nhà hàng
                // Đối với CREDIT_CARD/E_WALLET: sẽ xử lý thanh toán online (có thể kết hợp gateway)
                // Tạm thời tất cả đều set PENDING

                // Lưu thông tin deposit trong notes
                if (depositAmount.compareTo(BigDecimal.ZERO) > 0) {
                    payment.setNotes(String.format("Deposit: %s VNĐ (%d tables × 20,000 VNĐ). " +
                                    "Deposit will be refunded when customer arrives and pays in full.",
                            depositAmount, tableCount));
                    logger.info("💳 Deposit saved in payment notes: {} VNĐ", depositAmount);
                }

                logger.info("💳 Payment method: {} - Total: {} VNĐ (Items: {} + Deposit: {}) - Status: PENDING",
                        paymentMethod, finalAmount, totalAmount, depositAmount);

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

                    // ✅ Redirect based on payment method
                    if ("VNPAY".equals(paymentMethod)) {
                        // Redirect to VNPay payment gateway
                        String vnpayUrl = request.getContextPath() + "/vnpay-payment?reservationId="
                                + reservationId + "&amount=" + finalAmount.longValue();
                        logger.info("Redirecting to VNPay: {}", vnpayUrl);
                        response.sendRedirect(vnpayUrl);
                    } else {
                        // Redirect to details page for edited or new reservation
                        if (isEditing) {
                            response.sendRedirect("orderDetails?id=" + reservationId + "&updated=true");
                        } else {
                            response.sendRedirect("orderDetails?id=" + reservationId + "&success=true");
                        }
                    }
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