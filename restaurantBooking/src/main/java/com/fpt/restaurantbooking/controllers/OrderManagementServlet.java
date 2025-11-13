package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.dto.OrderManagementDTO;
import com.fpt.restaurantbooking.repositories.impl.ReservationDAO;
import com.fpt.restaurantbooking.repositories.impl.PaymentDAO;
import com.fpt.restaurantbooking.repositories.impl.ReservationTableDAO;
import com.fpt.restaurantbooking.models.Reservation;
import com.fpt.restaurantbooking.models.Payment;
import com.fpt.restaurantbooking.services.EmailService;
import com.fpt.restaurantbooking.services.RefundService;
import java.time.LocalDateTime;
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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Servlet for managing orders/reservations - Role 2 (Booking Management)
 */
@WebServlet(name = "OrderManagementServlet", urlPatterns = {"/OrderManagement"})
public class OrderManagementServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(OrderManagementServlet.class);
    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();
    private final ReservationTableDAO reservationTableDAO = new ReservationTableDAO();
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

            // Set attributes
            request.setAttribute("orders", orders);
            request.setAttribute("statusFilter", statusFilter);
            request.setAttribute("searchQuery", searchQuery);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalOrders", totalOrders);

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
            String action = request.getParameter("action");

            if ("updateStatus".equals(action)) {
                handleUpdateStatus(request, response);
            } else {
                sendJsonResponse(response, false, "Invalid action");
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

