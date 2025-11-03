package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.repositories.impl.PaymentDAO;
import com.fpt.restaurantbooking.services.VNPayService;
import com.fpt.restaurantbooking.utils.VNPayConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

/**
 * VNPay Payment Controller
 * Handles VNPay payment flow: create payment and process callback
 */
@WebServlet(name = "VNPayController", urlPatterns = {"/vnpay-payment", "/vnpay-return", "/vnpay-ipn"})
public class VNPayController extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(VNPayController.class);

    private final VNPayService vnPayService = new VNPayService();
    private final PaymentDAO paymentDAO = new PaymentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();
        logger.info("VNPay request path: {}", path);

        if ("/vnpay-payment".equals(path)) {
            handlePaymentRequest(request, response);
        } else if ("/vnpay-return".equals(path)) {
            handleReturn(request, response);
        } else if ("/vnpay-ipn".equals(path)) {
            handleIPN(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        logger.info("VNPay POST request path: {}", path);

        if ("/vnpay-ipn".equals(path)) {
            handleIPN(request, response);
        } else {
            doGet(request, response);
        }
    }

    /**
     * Handle payment request - create VNPay payment URL and redirect
     */
    private void handlePaymentRequest(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            String reservationIdStr = request.getParameter("reservationId");
            String amountStr = request.getParameter("amount");

            if (reservationIdStr == null || amountStr == null) {
                logger.error("Missing reservationId or amount in payment request");
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required parameters");
                return;
            }

            int reservationId = Integer.parseInt(reservationIdStr);
            long amount = Long.parseLong(amountStr);

            logger.info("Creating VNPay payment for reservation {} with amount {}", reservationId, amount);

            // Create payment URL
            String orderDescription = "Thanh toán đơn đặt bàn #" + reservationId;
            String paymentUrl = vnPayService.createPaymentUrl(reservationId, amount, orderDescription, "restaurant_booking");

            if (paymentUrl != null && !paymentUrl.isEmpty()) {
                logger.info("Redirecting to VNPay: {}", paymentUrl);
                response.sendRedirect(paymentUrl);
            } else {
                logger.error("Failed to create VNPay payment URL");
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to create payment URL");
            }

        } catch (NumberFormatException e) {
            logger.error("Invalid reservation ID or amount", e);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid parameters");
        } catch (Exception e) {
            logger.error("Error in payment request", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Payment error");
        }
    }

    /**
     * Handle return from VNPay after payment
     */
    private void handleReturn(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        logger.info("VNPay return callback received");

        try {
            // Get all parameters from request
            Map<String, String> allParams = extractVNPayParams(request);

            // Extract reservationId first (this is our custom param, not from VNPay)
            String reservationIdStr = request.getParameter("reservationId");
            int reservationId = (reservationIdStr != null) ? Integer.parseInt(reservationIdStr) : 0;

            // Remove non-VNPay parameters before signature verification
            Map<String, String> params = new HashMap<>(allParams);
            params.remove("reservationId");

            // Log received parameters
            logger.info("VNPay return params: {}", params);

            // Verify signature
            boolean isValidSignature = VNPayConfig.verifySignature(params);

            // Get response code
            String responseCode = params.get("vnp_ResponseCode");
            String transactionStatus = params.get("vnp_TransactionStatus");
            String txnRef = params.get("vnp_TxnRef");

            logger.info("Payment result - Reservation: {}, ResponseCode: {}, TransactionStatus: {}, ValidSignature: {}",
                    reservationId, responseCode, transactionStatus, isValidSignature);

            // Check payment result
            // 00: Success
            boolean isSuccess = "00".equals(responseCode) ||
                    ("00".equals(transactionStatus) && isValidSignature);

            if (isSuccess) {
                // Update payment status to COMPLETED
                if (reservationId > 0) {
                    paymentDAO.updatePaymentStatusByReservation(reservationId, "COMPLETED");
                    logger.info("Updated payment status to COMPLETED for reservation {}", reservationId);
                }

                // Forward to success page
                request.setAttribute("reservationId", reservationId);
                request.setAttribute("success", true);
                request.setAttribute("message", "Thanh toán thành công!");
                request.setAttribute("txnRef", txnRef);

                request.getRequestDispatcher("/WEB-INF/BookTable/vnpay-result.jsp")
                        .forward(request, response);
            } else {
                // Payment failed
                if (reservationId > 0) {
                    paymentDAO.updatePaymentStatusByReservation(reservationId, "FAILED");
                    logger.info("Updated payment status to FAILED for reservation {}", reservationId);
                }

                request.setAttribute("reservationId", reservationId);
                request.setAttribute("success", false);
                request.setAttribute("message", "Thanh toán thất bại. Vui lòng thử lại.");
                request.setAttribute("errorCode", responseCode);

                request.getRequestDispatcher("/WEB-INF/BookTable/vnpay-result.jsp")
                        .forward(request, response);
            }

        } catch (Exception e) {
            logger.error("Error in handleReturn", e);
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error processing return: " + e.getMessage());
        }
    }

    /**
     * Handle IPN (Instant Payment Notification) from VNPay
     */
    private void handleIPN(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        logger.info("VNPay IPN callback received");

        try {
            // Get all parameters from VNPay
            Map<String, String> params = extractVNPayParams(request);

            // Verify signature
            boolean isValidSignature = VNPayConfig.verifySignature(params);

            String transactionStatus = params.get("vnp_TransactionStatus");
            String responseCode = params.get("vnp_ResponseCode");

            logger.info("IPN - TransactionStatus: {}, ResponseCode: {}, ValidSignature: {}",
                    transactionStatus, responseCode, isValidSignature);

            // Respond to VNPay
            if (isValidSignature) {
                response.getWriter().write("{\"RspCode\":\"00\",\"Message\":\"Confirm Success\"}");
            } else {
                response.getWriter().write("{\"RspCode\":\"97\",\"Message\":\"Checksum failed\"}");
            }

            response.setContentType("application/json");
            response.getWriter().flush();

        } catch (Exception e) {
            logger.error("Error in handleIPN", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    /**
     * Extract VNPay parameters from request
     */
    private Map<String, String> extractVNPayParams(HttpServletRequest request) {
        Map<String, String> params = new HashMap<>();

        Enumeration<String> paramNames = request.getParameterNames();
        while (paramNames.hasMoreElements()) {
            String paramName = paramNames.nextElement();
            String paramValue = request.getParameter(paramName);
            params.put(paramName, paramValue);
        }

        return params;
    }
}

