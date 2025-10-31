package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.repositories.impl.PaymentDAO;
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
import java.util.Map;

/**
 * Servlet to confirm deposit received
 */
@WebServlet("/confirmDeposit")
public class ConfirmDepositServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(ConfirmDepositServlet.class);
    private final PaymentDAO paymentDAO = new PaymentDAO();
    private final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // Check authentication and role
        if (session == null || session.getAttribute("userId") == null) {
            sendErrorResponse(response, "Unauthorized", HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        Integer userRole = (Integer) session.getAttribute("userRole");
        if (userRole == null || userRole != 2) {
            sendErrorResponse(response, "Access denied. Booking Management role required.",
                    HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        try {
            String reservationIdParam = request.getParameter("reservationId");
            String depositAmountParam = request.getParameter("depositAmount");

            if (reservationIdParam == null || depositAmountParam == null) {
                sendErrorResponse(response, "Missing reservationId or depositAmount", 400);
                return;
            }

            int reservationId = Integer.parseInt(reservationIdParam);
            long depositAmount = Long.parseLong(depositAmountParam);

            // Get payment for this reservation
            com.fpt.restaurantbooking.models.Payment payment = paymentDAO.getPaymentByReservationId(reservationId);

            if (payment == null) {
                sendErrorResponse(response, "Payment not found for reservation " + reservationId, 404);
                return;
            }

            // Update payment notes to mark deposit as received
            String notes = payment.getNotes();
            if (notes == null) notes = "";

            // Check if already marked as received
            if (notes.contains("[DEPOSIT_RECEIVED]")) {
                sendSuccessResponse(response, "Deposit already confirmed");
                return;
            }

            // Add deposit received marker
            if (!notes.isEmpty()) notes += "\n";
            notes += String.format("[DEPOSIT_RECEIVED] Deposit %s VNĐ received on %s",
                    depositAmount,
                    java.time.LocalDateTime.now().format(java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));

            boolean updated = paymentDAO.updatePaymentNotes(payment.getPaymentId(), notes);

            if (updated) {
                logger.info("✅ Deposit confirmed for reservation {}: {} VNĐ", reservationId, depositAmount);
                sendSuccessResponse(response, "Deposit confirmed successfully");
            } else {
                sendErrorResponse(response, "Failed to update payment notes", 500);
            }

        } catch (NumberFormatException e) {
            sendErrorResponse(response, "Invalid reservationId or depositAmount format", 400);
        } catch (Exception e) {
            logger.error("Error confirming deposit", e);
            sendErrorResponse(response, "Internal server error: " + e.getMessage(), 500);
        }
    }

    private void sendSuccessResponse(HttpServletResponse response, String message) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setStatus(HttpServletResponse.SC_OK);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", message);

        try (PrintWriter out = response.getWriter()) {
            out.print(gson.toJson(result));
            out.flush();
        }
    }

    private void sendErrorResponse(HttpServletResponse response, String message, int statusCode) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setStatus(statusCode);

        Map<String, Object> result = new HashMap<>();
        result.put("success", false);
        result.put("message", message);

        try (PrintWriter out = response.getWriter()) {
            out.print(gson.toJson(result));
            out.flush();
        }
    }
}

