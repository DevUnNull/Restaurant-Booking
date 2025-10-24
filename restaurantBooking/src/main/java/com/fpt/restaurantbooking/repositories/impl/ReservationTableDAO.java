package com.fpt.restaurantbooking.repositories.impl;

import com.fpt.restaurantbooking.utils.DatabaseUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReservationTableDAO {
    private static final Logger logger = LoggerFactory.getLogger(ReservationTableDAO.class);

    // Add table to reservation
    public boolean addTableToReservation(int reservationId, int tableId) {
        String sql = "INSERT INTO Reservation_Tables (reservation_id, table_id, created_at) VALUES (?, ?, NOW())";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, reservationId);
            pstmt.setInt(2, tableId);

            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            logger.error("Error adding table to reservation", e);
        }
        return false;
    }

    // Get all tables for a reservation
    public List<Integer> getTablesByReservationId(int reservationId) {
        String sql = "SELECT table_id FROM Reservation_Tables WHERE reservation_id = ? ORDER BY created_at ASC";
        List<Integer> tableIds = new ArrayList<>();

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, reservationId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    tableIds.add(rs.getInt("table_id"));
                }
            }
        } catch (SQLException e) {
            logger.error("Error getting tables for reservation", e);
        }
        return tableIds;
    }

    // Remove table from reservation
    public boolean removeTableFromReservation(int reservationId, int tableId) {
        String sql = "DELETE FROM Reservation_Tables WHERE reservation_id = ? AND table_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, reservationId);
            pstmt.setInt(2, tableId);

            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            logger.error("Error removing table from reservation", e);
        }
        return false;
    }

    // Remove all tables for a reservation
    public boolean removeAllTablesFromReservation(int reservationId) {
        String sql = "DELETE FROM Reservation_Tables WHERE reservation_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, reservationId);
            pstmt.executeUpdate();
            return true;
        } catch (SQLException e) {
            logger.error("Error removing all tables from reservation", e);
        }
        return false;
    }

    // Check if table is already in reservation
    public boolean isTableInReservation(int reservationId, int tableId) {
        String sql = "SELECT 1 FROM Reservation_Tables WHERE reservation_id = ? AND table_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, reservationId);
            pstmt.setInt(2, tableId);

            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            logger.error("Error checking if table in reservation", e);
        }
        return false;
    }
}