package com.fpt.restaurantbooking.repositories.impl;

import com.fpt.restaurantbooking.models.Payment;
import com.fpt.restaurantbooking.utils.DatabaseUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;

public class PaymentDAO {
    private static final Logger logger = LoggerFactory.getLogger(PaymentDAO.class);

    // Create payment
    public int createPayment(Payment payment) {
        String sql = "INSERT INTO Payments (reservation_id, payment_method, payment_status, amount, promotion_id, transaction_id, notes, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, NOW(), NOW())";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setInt(1, payment.getReservationId());
            pstmt.setString(2, payment.getPaymentMethod());
            pstmt.setString(3, payment.getPaymentStatus());
            pstmt.setLong(4, payment.getAmount());
            pstmt.setObject(5, payment.getPromotionId());
            pstmt.setString(6, payment.getTransactionId());
            pstmt.setString(7, payment.getNotes());

            int affectedRows = pstmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = pstmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            logger.error("Error creating payment", e);
        }
        return -1;
    }

    // Get payment by ID
    public Payment getPaymentById(int paymentId) {
        String sql = "SELECT * FROM Payments WHERE payment_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, paymentId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToPayment(rs);
                }
            }
        } catch (SQLException e) {
            logger.error("Error getting payment by ID", e);
        }
        return null;
    }

    // Get payment by reservation ID
    public Payment getPaymentByReservationId(int reservationId) {
        String sql = "SELECT * FROM Payments WHERE reservation_id = ? ORDER BY created_at DESC LIMIT 1";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, reservationId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToPayment(rs);
                }
            }
        } catch (SQLException e) {
            logger.error("Error getting payment by reservation ID", e);
        }
        return null;
    }

    // Update payment status
    public boolean updatePaymentStatus(int paymentId, String status, String transactionId) {
        String sql = "UPDATE Payments SET payment_status = ?, transaction_id = ?, updated_at = NOW() WHERE payment_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, status);
            pstmt.setString(2, transactionId);
            pstmt.setInt(3, paymentId);

            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            logger.error("Error updating payment status", e);
        }
        return false;
    }

    // Get all payments by user
    public List<Payment> getPaymentsByUserId(int userId) {
        String sql = "SELECT p.* FROM Payments p " +
                "JOIN Reservations r ON p.reservation_id = r.reservation_id " +
                "WHERE r.user_id = ? ORDER BY p.created_at DESC";
        List<Payment> payments = new ArrayList<>();

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    payments.add(mapResultSetToPayment(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error getting payments by user ID", e);
        }
        return payments;
    }

    // Refund payment
    public boolean refundPayment(int paymentId) {
        String sql = "UPDATE Payments SET payment_status = 'REFUNDED', updated_at = NOW() WHERE payment_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, paymentId);
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            logger.error("Error refunding payment", e);
        }
        return false;
    }

    // Update payment notes
    public boolean updatePaymentNotes(int paymentId, String notes) {
        String sql = "UPDATE Payments SET notes = ?, updated_at = NOW() WHERE payment_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, notes);
            pstmt.setInt(2, paymentId);
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            logger.error("Error updating payment notes", e);
        }
        return false;
    }

    private Payment mapResultSetToPayment(ResultSet rs) throws SQLException {
        Payment payment = new Payment();
        payment.setPaymentId(rs.getInt("payment_id"));
        payment.setReservationId(rs.getInt("reservation_id"));
        payment.setPaymentMethod(rs.getString("payment_method"));
        payment.setPaymentStatus(rs.getString("payment_status"));
        payment.setAmount(rs.getLong("amount"));
        payment.setPromotionId((Integer) rs.getObject("promotion_id"));
        payment.setTransactionId(rs.getString("transaction_id"));
        payment.setNotes(rs.getString("notes"));
        if (rs.getTimestamp("payment_date") != null) {
            payment.setPaymentDate(rs.getTimestamp("payment_date").toLocalDateTime());
        }
        return payment;
    }
}