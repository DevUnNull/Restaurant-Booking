package com.fpt.restaurantbooking.repositories.impl;

import com.fpt.restaurantbooking.models.Table;
import com.fpt.restaurantbooking.utils.DatabaseUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TableDAO {
    private static final Logger logger = LoggerFactory.getLogger(TableDAO.class);

    // Get table by ID
    public Table getTableById(int tableId) {
        String sql = "SELECT * FROM Tables WHERE table_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, tableId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToTable(rs);
                }
            }
        } catch (SQLException e) {
            logger.error("Error getting table by ID: " + tableId, e);
        }
        return null;
    }

    // Get all tables by floor
    public List<Table> getTablesByFloor(int floor) {
        String sql = "SELECT * FROM Tables WHERE floor = ? ORDER BY table_id ASC";
        List<Table> tables = new ArrayList<>();

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, floor);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    tables.add(mapResultSetToTable(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error getting tables by floor: " + floor, e);
        }
        return tables;
    }

    // Get available tables by capacity and floor
    public List<Table> getAvailableTablesByCapacity(int capacity, int floor) {
        String sql = "SELECT * FROM Tables WHERE floor = ? AND capacity >= ? AND status = 'AVAILABLE' ORDER BY capacity ASC, table_id ASC";
        List<Table> tables = new ArrayList<>();

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, floor);
            pstmt.setInt(2, capacity);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    tables.add(mapResultSetToTable(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error getting available tables", e);
        }
        return tables;
    }

    // Get all available tables
    public List<Table> getAllAvailableTables() {
        String sql = "SELECT * FROM Tables WHERE status = 'AVAILABLE' ORDER BY floor ASC, table_id ASC";
        List<Table> tables = new ArrayList<>();

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    tables.add(mapResultSetToTable(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error getting all available tables", e);
        }
        return tables;
    }

    // Update table status
    public boolean updateTableStatus(int tableId, String status) {
        String sql = "UPDATE Tables SET status = ?, updated_at = NOW() WHERE table_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, status);
            pstmt.setInt(2, tableId);

            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            logger.error("Error updating table status", e);
        }
        return false;
    }

    // Get all tables
    public List<Table> getAllTables() {
        String sql = "SELECT * FROM Tables ORDER BY floor ASC, table_id ASC";
        List<Table> tables = new ArrayList<>();

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    tables.add(mapResultSetToTable(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error getting all tables", e);
        }
        return tables;
    }

    private Table mapResultSetToTable(ResultSet rs) throws SQLException {
        Table table = new Table();
        table.setTableId(rs.getInt("table_id"));
        table.setTableName(rs.getString("table_name"));
        table.setCapacity(rs.getInt("capacity"));
        table.setFloor(rs.getInt("floor"));
        table.setTableType(rs.getString("table_type"));
        table.setStatus(rs.getString("status"));
        return table;
    }
}