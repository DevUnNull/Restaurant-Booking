package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.dto.OrderManagementDTO;
import com.fpt.restaurantbooking.repositories.impl.ReservationDAO;
import com.fpt.restaurantbooking.repositories.impl.PaymentDAO;
import com.fpt.restaurantbooking.repositories.impl.ReservationTableDAO;
import com.fpt.restaurantbooking.repositories.impl.TableDAO;
import com.fpt.restaurantbooking.repositories.impl.UserDao;
import com.fpt.restaurantbooking.models.Reservation;
import com.fpt.restaurantbooking.models.Payment;
import com.fpt.restaurantbooking.models.Table;
import com.fpt.restaurantbooking.models.User;
import com.fpt.restaurantbooking.services.EmailService;
import com.fpt.restaurantbooking.services.RefundService;
import java.time.LocalDateTime;
import java.time.LocalDate;
import java.time.LocalTime;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import com.fpt.restaurantbooking.utils.DatabaseUtil;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Servlet for managing orders/reservations - Role 2 (Booking Management)
 */
@WebServlet(name = "OrderManagementServlet", urlPatterns = {"/OrderManagement"})
@jakarta.servlet.annotation.MultipartConfig
public class OrderManagementServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(OrderManagementServlet.class);
    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();
    private final ReservationTableDAO reservationTableDAO = new ReservationTableDAO();
    private final TableDAO tableDAO = new TableDAO();
    private final UserDao userDao = new UserDao();
    private final Gson gson = new Gson();
    private final EmailService emailService = new EmailService();
    private final RefundService refundService = new RefundService();

    private static final int ITEMS_PER_PAGE = 20;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // Check authentication and role
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer userRole = (Integer) session.getAttribute("userRole");
        if (userRole == null || userRole != 2) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied. Booking Management role required.");
            return;
        }

        try {
            // Get filter and search parameters
            String statusFilter = request.getParameter("status");
            if (statusFilter == null || statusFilter.isEmpty()) {
                statusFilter = "ALL";
            }

            String searchQuery = request.getParameter("search");

            // Get pagination parameters
            int page = 1;
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    page = Integer.parseInt(pageParam);
                    if (page < 1) page = 1;
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }

            int offset = (page - 1) * ITEMS_PER_PAGE;

            // Get total count for pagination
            int totalOrders = reservationDAO.getTotalReservationsCount(statusFilter, searchQuery);
            int totalPages = (int) Math.ceil((double) totalOrders / ITEMS_PER_PAGE);

            logger.info("=== ORDER MANAGEMENT DEBUG ===");
            logger.info("Status Filter: {}", statusFilter);
            logger.info("Search Query: {}", searchQuery);
            logger.info("Page: {}, Offset: {}, Limit: {}", page, offset, ITEMS_PER_PAGE);
            logger.info("Total Orders Count: {}", totalOrders);
            logger.info("Total Pages: {}", totalPages);

            // Get orders list
            List<OrderManagementDTO> orders = reservationDAO.getAllReservationsWithDetails(
                    statusFilter, searchQuery, offset, ITEMS_PER_PAGE
            );

            logger.info("Loaded {} orders from query", orders != null ? orders.size() : 0);

            if (orders != null && !orders.isEmpty()) {
                logger.info("First order ID: {}", orders.get(0).getReservationId());
                logger.info("First order customer: {}", orders.get(0).getCustomerName());
            } else {
                logger.warn("⚠️ NO ORDERS RETURNED FROM QUERY!");
                logger.warn("This means either:");
                logger.warn("1. SQL query returned no results");
                logger.warn("2. SQLException occurred and was caught");
                logger.warn("3. Error parsing ResultSet");
                logger.warn("Check the logs above for SQL errors!");
            }

            // Load tables for create order form
            List<Table> allTables = tableDAO.getAllTables();

            // Set attributes
            request.setAttribute("orders", orders);
            request.setAttribute("statusFilter", statusFilter);
            request.setAttribute("searchQuery", searchQuery);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalOrders", totalOrders);
            request.setAttribute("allTables", allTables);

            // Forward to JSP
            request.getRequestDispatcher("/WEB-INF/views/management/orderManagement.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            logger.error("Error in OrderManagementServlet GET", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Error loading orders: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // Check authentication and role
        if (session == null || session.getAttribute("userId") == null) {
            sendJsonResponse(response, false, "Unauthorized");
            return;
        }

        Integer userRole = (Integer) session.getAttribute("userRole");
        if (userRole == null || userRole != 2) {
            sendJsonResponse(response, false, "Access denied");
            return;
        }

        try {
            // Log all parameters for debugging
            logger.info("=== POST REQUEST RECEIVED ===");
            logger.info("Content-Type: {}", request.getContentType());

            // Get all parameter names
            java.util.Enumeration<String> paramNames = request.getParameterNames();
            logger.info("All parameters:");
            while (paramNames.hasMoreElements()) {
                String paramName = paramNames.nextElement();
                String paramValue = request.getParameter(paramName);
                logger.info("  {} = {}", paramName, paramValue);
            }

            String action = request.getParameter("action");
            logger.info("Action parameter: '{}'", action);

            if (action == null || action.trim().isEmpty()) {
                logger.error("Action parameter is null or empty!");
                sendJsonResponse(response, false, "Thiếu action parameter. Vui lòng thử lại.");
                return;
            }

            if ("updateStatus".equals(action)) {
                logger.info("Handling updateStatus action");
                handleUpdateStatus(request, response);
            } else if ("createReservation".equals(action)) {
                logger.info("Handling createReservation action");
                handleCreateReservation(request, response);
            } else {
                logger.error("Unknown action: '{}'", action);
                sendJsonResponse(response, false, "Invalid action: '" + action + "'");
            }

        } catch (Exception e) {
            logger.error("Error in OrderManagementServlet POST", e);
            sendJsonResponse(response, false, "Error: " + e.getMessage());
        }
    }

    /**
     * Handle update reservation status
     */
    private void handleUpdateStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            String reservationIdStr = request.getParameter("reservationId");
            String newStatus = request.getParameter("status");

            if (reservationIdStr == null || newStatus == null) {
                sendJsonResponse(response, false, "Missing parameters");
                return;
            }

            int reservationId = Integer.parseInt(reservationIdStr);

            // Validate status
            String[] validStatuses = {"PENDING", "CONFIRMED", "CANCELLED", "COMPLETED", "NO_SHOW"};
            boolean isValidStatus = false;
            for (String status : validStatuses) {
                if (status.equals(newStatus)) {
                    isValidStatus = true;
                    break;
                }
            }

            if (!isValidStatus) {
                sendJsonResponse(response, false, "Invalid status");
                return;
            }

            // Update status
            boolean updated = reservationDAO.updateReservationStatus(reservationId, newStatus);

            if (updated) {
                logger.info("Updated reservation {} to status {}", reservationId, newStatus);

                // Get order details for email and refund calculation
                OrderManagementDTO orderDetails = reservationDAO.getReservationDetailsById(reservationId);
                Reservation reservation = reservationDAO.getReservationById(reservationId);
                Payment payment = paymentDAO.getPaymentByReservationId(reservationId);

                // Xử lý refund và gửi email theo quy định
                try {
                    if (orderDetails != null && orderDetails.getCustomerEmail() != null) {
                        // Case 1: Đơn bị hủy (CANCELLED) hoặc no-show (NO_SHOW)
                        if ("CANCELLED".equals(newStatus) || "NO_SHOW".equals(newStatus)) {
                            if (payment != null && reservation != null) {
                                LocalDateTime cancellationTime = LocalDateTime.now();
                                boolean isNoShow = "NO_SHOW".equals(newStatus);

                                RefundService.RefundResult refundResult = refundService.calculateRefund(
                                        reservation, payment, cancellationTime, isNoShow);

                                logger.info("💳 Refund calculation for {} reservation {}: Amount={}, Eligible={}, Reason={}",
                                        newStatus, reservationId, refundResult.getRefundAmount(),
                                        refundResult.isEligible(), refundResult.getReason());

                                // Gửi email refund nếu có
                                if (refundResult.isEligible() && refundResult.getRefundAmount().compareTo(java.math.BigDecimal.ZERO) > 0) {
                                    boolean isDepositRefund = "CASH".equals(payment.getPaymentMethod());
                                    boolean emailSent = emailService.sendRefundNotificationEmail(
                                            orderDetails,
                                            refundResult.getRefundAmount(),
                                            refundResult.getReason(),
                                            isDepositRefund
                                    );
                                    if (emailSent) {
                                        logger.info("✅ Refund notification email sent for {} reservation {}", newStatus, reservationId);
                                    }
                                } else {
                                    // Vẫn gửi email thông báo thay đổi trạng thái
                                    emailService.sendOrderStatusChangeEmail(orderDetails, newStatus);
                                }
                            } else {
                                // Gửi email thông báo thay đổi trạng thái thông thường
                                emailService.sendOrderStatusChangeEmail(orderDetails, newStatus);
                            }
                        }
                        // Case 2: Đơn hoàn thành (COMPLETED) - refund tiền cọc cho CASH
                        else if ("COMPLETED".equals(newStatus) && payment != null && "CASH".equals(payment.getPaymentMethod())) {
                            RefundService.RefundResult depositRefund = refundService.calculateDepositRefundForCompletedOrder(payment, reservation);

                            if (depositRefund.isEligible() && depositRefund.getRefundAmount().compareTo(java.math.BigDecimal.ZERO) > 0) {
                                logger.info("💳 Deposit refund for completed order {}: Amount={}",
                                        reservationId, depositRefund.getRefundAmount());

                                // Gửi email thông báo hoàn tiền cọc
                                boolean emailSent = emailService.sendRefundNotificationEmail(
                                        orderDetails,
                                        depositRefund.getRefundAmount(),
                                        depositRefund.getReason(),
                                        true // isDepositRefund = true
                                );
                                if (emailSent) {
                                    logger.info("✅ Deposit refund notification email sent for completed reservation {}", reservationId);
                                }
                            }

                            // Vẫn gửi email thông báo thay đổi trạng thái
                            emailService.sendOrderStatusChangeEmail(orderDetails, newStatus);
                        }
                        // Case 3: Các trạng thái khác - chỉ gửi email thông báo thay đổi trạng thái
                        else {
                            boolean emailSent = emailService.sendOrderStatusChangeEmail(orderDetails, newStatus);
                            if (emailSent) {
                                logger.info("Email notification sent successfully for reservation {} to {}",
                                        reservationId, orderDetails.getCustomerEmail());
                            } else {
                                logger.warn("Failed to send email notification for reservation {}", reservationId);
                            }
                        }
                    } else {
                        logger.warn("No customer email found for reservation {}, skipping email notification",
                                reservationId);
                    }
                } catch (Exception e) {
                    // Don't fail the status update if email sending fails
                    logger.error("Error sending email notification for reservation {}", reservationId, e);
                }

                sendJsonResponse(response, true, "Status updated successfully");
            } else {
                sendJsonResponse(response, false, "Failed to update status");
            }

        } catch (NumberFormatException e) {
            sendJsonResponse(response, false, "Invalid reservation ID");
        } catch (Exception e) {
            logger.error("Error updating status", e);
            sendJsonResponse(response, false, "Error: " + e.getMessage());
        }
    }

    /**
     * Handle create reservation (offline booking)
     */
    private void handleCreateReservation(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            logger.info("=== CREATE OFFLINE RESERVATION START ===");

            // Get parameters
            String customerName = request.getParameter("customerName");
            String customerPhone = request.getParameter("customerPhone");
            String customerEmail = request.getParameter("customerEmail");
            String reservationDateStr = request.getParameter("reservationDate");
            String slotStr = request.getParameter("slot"); // Slot: MORNING, AFTERNOON, EVENING
            String reservationTimeStr = request.getParameter("reservationTime"); // Time from slot
            String guestCountStr = request.getParameter("guestCount");
            String tableIdsStr = request.getParameter("tableIds");
            String specialRequests = request.getParameter("specialRequests");

            logger.info("Parameters: name={}, phone={}, email={}, date={}, slot={}, time={}, guests={}, tables={}",
                    customerName, customerPhone, customerEmail, reservationDateStr, slotStr, reservationTimeStr, guestCountStr, tableIdsStr);

            // Validate required fields
            logger.info("Validating parameters...");
            if (customerName == null || customerName.trim().isEmpty()) {
                logger.error("Missing customerName");
                sendJsonResponse(response, false, "Vui lòng nhập tên khách hàng");
                return;
            }
            if (customerPhone == null || customerPhone.trim().isEmpty()) {
                logger.error("Missing customerPhone");
                sendJsonResponse(response, false, "Vui lòng nhập số điện thoại");
                return;
            }
            if (reservationDateStr == null || reservationDateStr.trim().isEmpty()) {
                logger.error("Missing reservationDate");
                sendJsonResponse(response, false, "Vui lòng chọn ngày đặt");
                return;
            }
            if (slotStr == null || slotStr.trim().isEmpty()) {
                logger.error("Missing slot");
                sendJsonResponse(response, false, "Vui lòng chọn slot thời gian");
                return;
            }
            if (reservationTimeStr == null || reservationTimeStr.trim().isEmpty()) {
                logger.error("Missing reservationTime");
                sendJsonResponse(response, false, "Vui lòng chọn slot thời gian (time missing)");
                return;
            }
            if (guestCountStr == null || guestCountStr.trim().isEmpty()) {
                logger.error("Missing guestCount");
                sendJsonResponse(response, false, "Vui lòng nhập số lượng khách");
                return;
            }
            if (tableIdsStr == null || tableIdsStr.trim().isEmpty()) {
                logger.error("Missing tableIds");
                sendJsonResponse(response, false, "Vui lòng chọn ít nhất một bàn");
                return;
            }
            logger.info("All parameters validated successfully");

            // Parse data
            logger.info("Parsing data...");
            LocalDate reservationDate;
            LocalTime reservationTime;
            int guestCount;

            try {
                reservationDate = LocalDate.parse(reservationDateStr);
                logger.info("Parsed date: {}", reservationDate);
            } catch (Exception e) {
                logger.error("Error parsing date: {}", reservationDateStr, e);
                sendJsonResponse(response, false, "Ngày đặt không hợp lệ: " + reservationDateStr);
                return;
            }

            try {
                // Normalize time format: ensure it's HH:mm:ss format
                String normalizedTime = reservationTimeStr;
                if (normalizedTime.length() == 5) {
                    // If format is "08:00", convert to "08:00:00"
                    normalizedTime = normalizedTime + ":00";
                }
                reservationTime = LocalTime.parse(normalizedTime);
                logger.info("Parsed time: {} (from: {})", reservationTime, reservationTimeStr);
            } catch (Exception e) {
                logger.error("Error parsing time: {}", reservationTimeStr, e);
                sendJsonResponse(response, false, "Giờ đặt không hợp lệ: " + reservationTimeStr + ". Vui lòng chọn lại slot.");
                return;
            }

            try {
                guestCount = Integer.parseInt(guestCountStr);
                logger.info("Parsed guest count: {}", guestCount);
            } catch (NumberFormatException e) {
                logger.error("Error parsing guest count: {}", guestCountStr, e);
                sendJsonResponse(response, false, "Số lượng khách không hợp lệ: " + guestCountStr);
                return;
            }

            // Parse table IDs
            String[] tableIdArray = tableIdsStr.split(",");
            List<Integer> tableIds = new ArrayList<>();
            for (String tableIdStr : tableIdArray) {
                try {
                    tableIds.add(Integer.parseInt(tableIdStr.trim()));
                } catch (NumberFormatException e) {
                    logger.warn("Invalid table ID: {}", tableIdStr);
                }
            }

            if (tableIds.isEmpty()) {
                sendJsonResponse(response, false, "Vui lòng chọn ít nhất một bàn");
                return;
            }

            // Check if tables are available for this time slot
            // Use slot from parameter (MORNING/AFTERNOON/EVENING)
            List<Integer> bookedTableIds = reservationDAO.getBookedTableIdsForSlot(reservationDate, slotStr);

            for (Integer tableId : tableIds) {
                if (bookedTableIds.contains(tableId)) {
                    Table table = tableDAO.getTableById(tableId);
                    String tableName = table != null ? table.getTableName() : "Bàn " + tableId;
                    sendJsonResponse(response, false,
                            String.format("Bàn %s đã được đặt trong khung giờ này", tableName));
                    return;
                }
            }

            // Get or create user
            User user = getUserByPhone(customerPhone);
            int userId;

            if (user == null) {
                // Create new user for offline booking
                userId = createUserForOfflineBooking(customerName, customerPhone, customerEmail);
                if (userId <= 0) {
                    sendJsonResponse(response, false, "Không thể tạo tài khoản khách hàng");
                    return;
                }
                logger.info("Created new user for offline booking: {}", userId);
            } else {
                userId = user.getUserId();
                // Update user info if provided
                if (customerEmail != null && !customerEmail.trim().isEmpty() &&
                        (user.getEmail() == null || user.getEmail().isEmpty())) {
                    user.setEmail(customerEmail);
                    userDao.updateUser(user);
                }
            }

            // Create reservation
            Reservation reservation = new Reservation();
            reservation.setUserId(userId);
            reservation.setReservationDate(reservationDate);
            reservation.setReservationTime(reservationTime);
            reservation.setGuestCount(guestCount);
            reservation.setSpecialRequests(specialRequests != null ? specialRequests.trim() : null);
            reservation.setStatus("CONFIRMED"); // Offline booking is confirmed immediately
            reservation.setTotalAmount(BigDecimal.ZERO); // Can be updated later when ordering

            logger.info("Creating reservation: userId={}, date={}, time={}, guests={}, status={}",
                    userId, reservationDate, reservationTime, guestCount, reservation.getStatus());

            int reservationId = reservationDAO.createReservation(reservation);

            logger.info("Reservation created with ID: {}", reservationId);

            if (reservationId <= 0) {
                logger.error("Failed to create reservation - reservationId is {}", reservationId);
                sendJsonResponse(response, false, "Không thể tạo đơn đặt bàn. Vui lòng thử lại.");
                return;
            }

            // Add tables to reservation
            for (Integer tableId : tableIds) {
                reservationTableDAO.addTableToReservation(reservationId, tableId);
                tableDAO.updateTableStatus(tableId, "RESERVED");
            }

            logger.info("✅ Created offline reservation {} for customer {} with {} tables",
                    reservationId, customerName, tableIds.size());

            // Create Payment record for offline booking (CASH - thanh toán tại quán)
            Payment payment = new Payment();
            payment.setReservationId(reservationId);
            payment.setPaymentMethod("CASH"); // Thanh toán tại quán
            payment.setPaymentStatus("PENDING"); // Chưa thanh toán, sẽ thanh toán khi đến quán
            payment.setAmount(0L); // Chưa có số tiền, sẽ cập nhật khi đặt món
            payment.setNotes("Đơn đặt bàn offline - Thanh toán tại quán");
            payment.setTransactionId("OFFLINE-" + reservationId + "-" + System.currentTimeMillis());

            int paymentId = paymentDAO.createPayment(payment);
            if (paymentId > 0) {
                logger.info("✅ Created payment record {} for offline reservation {} (CASH)", paymentId, reservationId);
            } else {
                logger.warn("⚠️ Failed to create payment record for reservation {}", reservationId);
            }

            logger.info("=== CREATE OFFLINE RESERVATION SUCCESS ===");

            // Send email notification if email provided
            if (customerEmail != null && !customerEmail.trim().isEmpty()) {
                try {
                    OrderManagementDTO orderDetails = reservationDAO.getReservationDetailsById(reservationId);
                    if (orderDetails != null) {
                        emailService.sendOrderStatusChangeEmail(orderDetails, "CONFIRMED");
                    }
                } catch (Exception e) {
                    logger.warn("Failed to send email notification", e);
                }
            }

            sendJsonResponse(response, true,
                    String.format("Tạo đơn đặt bàn thành công! Mã đơn: #%d", reservationId));

        } catch (Exception e) {
            logger.error("❌ Error creating reservation", e);
            logger.error("Exception details: {}", e.getMessage(), e);
            sendJsonResponse(response, false, "Lỗi: " + e.getMessage() + ". Vui lòng kiểm tra log để biết chi tiết.");
        }
    }

    /**
     * Get user by phone number
     */
    private User getUserByPhone(String phone) {
        String sql = "SELECT * FROM users WHERE phone_number = ? AND status != 'DELETE' LIMIT 1";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, phone);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setFullName(rs.getString("full_name"));
                    user.setPhoneNumber(rs.getString("phone_number"));
                    user.setEmail(rs.getString("email"));
                    user.setRoleId(rs.getInt("role_id"));
                    user.setStatus(rs.getString("status"));
                    return user;
                }
            }
        } catch (SQLException e) {
            logger.error("Error getting user by phone", e);
        }
        return null;
    }

    /**
     * Create user for offline booking
     */
    private int createUserForOfflineBooking(String name, String phone, String email) {
        String sql = "INSERT INTO users (full_name, phone_number, email, role_id, status, created_at, updated_at) VALUES (?, ?, ?, 3, 'ACTIVE', NOW(), NOW())";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setString(1, name);
            pstmt.setString(2, phone);
            pstmt.setString(3, email != null && !email.trim().isEmpty() ? email : null);

            int affectedRows = pstmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = pstmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            logger.error("Error creating user for offline booking", e);
        }
        return -1;
    }


    /**
     * Send JSON response
     */
    private void sendJsonResponse(HttpServletResponse response, boolean success, String message)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        Map<String, Object> jsonResponse = new HashMap<>();
        jsonResponse.put("success", success);
        jsonResponse.put("message", message);

        PrintWriter out = response.getWriter();
        out.print(gson.toJson(jsonResponse));
        out.flush();
    }
}

