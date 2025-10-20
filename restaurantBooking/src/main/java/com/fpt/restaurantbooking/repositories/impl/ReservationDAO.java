package com.fpt.restaurantbooking.repositories.impl;

import com.fpt.restaurantbooking.models.Reservation;
import com.fpt.restaurantbooking.utils.DatabaseUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;

public class ReservationDAO {
    private static final Logger logger = LoggerFactory.getLogger(ReservationDAO.class);

    // Create a new reservation
    public int createReservation(Reservation reservation) {
        String sql = "INSERT INTO Reservations (user_id, table_id, reservation_date, reservation_time, guest_count, special_requests, status, total_amount, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            // Gán dữ liệu
            pstmt.setInt(1, reservation.getUserId());
            pstmt.setInt(2, reservation.getTableId() != null ? reservation.getTableId() : 0);
            pstmt.setDate(3, Date.valueOf(reservation.getReservationDate()));
            pstmt.setTime(4, Time.valueOf(reservation.getReservationTime()));
            pstmt.setInt(5, reservation.getGuestCount());
            pstmt.setString(6, reservation.getSpecialRequests());
            pstmt.setString(7, reservation.getStatus());
            pstmt.setBigDecimal(8, reservation.getTotalAmount() != null ? reservation.getTotalAmount() : BigDecimal.ZERO);

            // Debug log
            System.out.println("==== DEBUG INSERT RESERVATION ====");
            System.out.println("userId: " + reservation.getUserId());
            System.out.println("tableId: " + reservation.getTableId());
            System.out.println("date: " + reservation.getReservationDate());
            System.out.println("time: " + reservation.getReservationTime());
            System.out.println("guestCount: " + reservation.getGuestCount());
            System.out.println("specialRequests: " + reservation.getSpecialRequests());
            System.out.println("status: " + reservation.getStatus());
            System.out.println("totalAmount: " + reservation.getTotalAmount());
            System.out.println("==================================");

            int affectedRows = pstmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = pstmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }

        } catch (SQLException e) {
            logger.error("❌ SQL Error while creating reservation: {}", e.getMessage());
            e.printStackTrace();  // In stacktrace đầy đủ
        } catch (Exception e) {
            logger.error("❌ General Error while creating reservation: {}", e.getMessage());
            e.printStackTrace();
        }

        return -1;
    }


    // Get reservation by ID
    public Reservation getReservationById(int reservationId) {
        String sql = "SELECT * FROM Reservations WHERE reservation_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, reservationId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToReservation(rs);
                }
            }
        } catch (SQLException e) {
            logger.error("Error getting reservation by ID: " + reservationId, e);
        }
        return null;
    }

    // Get all reservations by user ID
    public List<Reservation> getReservationsByUserId(int userId) {
        String sql = "SELECT * FROM Reservations WHERE user_id = ? ORDER BY reservation_date DESC, reservation_time DESC";
        List<Reservation> reservations = new ArrayList<>();

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    reservations.add(mapResultSetToReservation(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error getting reservations by user ID: " + userId, e);
        }
        return reservations;
    }

    // Get available tables
    public List<Integer> getAvailableTables(LocalDate date, LocalTime time, int guestCount, int floor) {
        String sql = "SELECT t.table_id FROM Tables t " +
                "WHERE t.floor = ? AND t.capacity >= ? AND t.status = 'AVAILABLE' " +
                "AND NOT EXISTS (SELECT 1 FROM Reservations r WHERE r.table_id = t.table_id AND r.reservation_date = ? AND r.reservation_time = ? AND r.status IN ('CONFIRMED', 'CHECKED_IN'))";

        List<Integer> tableIds = new ArrayList<>();

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, floor);
            pstmt.setInt(2, guestCount);
            pstmt.setDate(3, Date.valueOf(date));
            pstmt.setTime(4, Time.valueOf(time));

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    tableIds.add(rs.getInt("table_id"));
                }
            }
        } catch (SQLException e) {
            logger.error("Error getting available tables", e);
        }
        return tableIds;
    }

    // Update reservation status
    public boolean updateReservationStatus(int reservationId, String status) {
        String sql = "UPDATE Reservations SET status = ?, updated_at = NOW() WHERE reservation_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, status);
            pstmt.setInt(2, reservationId);

            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            logger.error("Error updating reservation status", e);
        }
        return false;
    }

    // Update reservation total amount
    public boolean updateTotalAmount(int reservationId, BigDecimal amount) {
        String sql = "UPDATE Reservations SET total_amount = ?, updated_at = NOW() WHERE reservation_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setBigDecimal(1, amount);
            pstmt.setInt(2, reservationId);

            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            logger.error("Error updating total amount", e);
        }
        return false;
    }

    // Cancel reservation
    public boolean cancelReservation(int reservationId, String reason) {
        String sql = "UPDATE Reservations SET status = 'CANCELLED', cancellation_reason = ?, updated_at = NOW() WHERE reservation_id = ? AND status = 'PENDING'";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, reason);
            pstmt.setInt(2, reservationId);

            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            logger.error("Error cancelling reservation", e);
        }
        return false;
    }

    private Reservation mapResultSetToReservation(ResultSet rs) throws SQLException {
        Reservation reservation = new Reservation(
                rs.getInt("reservation_id"),
                rs.getInt("user_id"),
                rs.getInt("table_id"),
                rs.getInt("guest_count"),
                rs.getTimestamp("created_at").toLocalDateTime(),
                rs.getString("status"),
                rs.getInt("guest_count")
        );

        reservation.setReservationId(rs.getInt("reservation_id"));
        reservation.setReservationDate(rs.getDate("reservation_date").toLocalDate());
        reservation.setReservationTime(rs.getTime("reservation_time").toLocalTime());
        reservation.setSpecialRequests(rs.getString("special_requests"));
        reservation.setTotalAmount(rs.getBigDecimal("total_amount"));
        reservation.setCancellationReason(rs.getString("cancellation_reason"));

        return reservation;
    }
}