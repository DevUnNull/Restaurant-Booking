package com.fpt.restaurantbooking.repositories.impl;

import com.fpt.restaurantbooking.models.Table;
import com.fpt.restaurantbooking.utils.DatabaseUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TableDAO {

    private static final Logger logger = LoggerFactory.getLogger(TableDAO.class);

    /**
     * Lấy tất cả bàn theo tầng
     */
    public List<Table> getTablesByFloor(int floor) {
        List<Table> tables = new ArrayList<>();
        String sql = "SELECT * FROM Tables WHERE floor = ? AND status != 'MAINTENANCE' ORDER BY table_id";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, floor);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                tables.add(mapResultSetToTable(rs));
            }

        } catch (SQLException e) {
            logger.error("Error getting tables by floor: " + floor, e);
        }

        return tables;
    }

    /**
     * Lấy tất cả bàn
     */
    public List<Table> getAllTables() {
        List<Table> tables = new ArrayList<>();
        String sql = "SELECT * FROM Tables WHERE status != 'MAINTENANCE' ORDER BY floor, table_id";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                tables.add(mapResultSetToTable(rs));
            }

        } catch (SQLException e) {
            logger.error("Error getting all tables", e);
        }

        return tables;
    }

    /**
     * Kiểm tra trạng thái bàn theo ngày và giờ
     */
    public Map<Integer, Map<String, Object>> getTableStatusMap(String date, String time, Integer guestCount, String selectedFloor) {
        Map<Integer, Map<String, Object>> tableStatusMap = new HashMap<>();

        String sql = "SELECT t.table_id, t.table_name, t.capacity, t.floor, t.table_type, " +
                "CASE WHEN EXISTS ( " +
                "  SELECT 1 FROM Reservations r " +
                "  INNER JOIN Reservation_Tables rt ON r.reservation_id = rt.reservation_id " +
                "  WHERE rt.table_id = t.table_id " +
                "  AND r.reservation_date = ? " +
                "  AND r.reservation_time = ? " +
                "  AND r.status IN ('PENDING', 'CONFIRMED', 'CHECKED_IN') " +
                ") THEN 'booked' ELSE 'available' END AS status " +
                "FROM Tables t " +
                "WHERE t.status != 'MAINTENANCE'";

        // Thêm điều kiện lọc theo tầng nếu có
        if (selectedFloor != null && !selectedFloor.equals("all")) {
            sql += " AND t.floor = ?";
        }

        sql += " ORDER BY t.table_id";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, date);
            ps.setString(2, time);

            if (selectedFloor != null && !selectedFloor.equals("all")) {
                ps.setInt(3, Integer.parseInt(selectedFloor));
            }

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                int tableId = rs.getInt("table_id");
                int capacity = rs.getInt("capacity");
                int floor = rs.getInt("floor");
                String status = rs.getString("status");

                Map<String, Object> tableDetails = new HashMap<>();
                tableDetails.put("capacity", capacity);
                tableDetails.put("floor", floor);
                tableDetails.put("status", status);

                // Kiểm tra xem bàn có phù hợp với số người không
                boolean match = false;
                if ("available".equals(status) && guestCount != null && guestCount > 0) {
                    match = (capacity >= guestCount && capacity <= guestCount + 2);
                }
                tableDetails.put("match", match);

                tableStatusMap.put(tableId, tableDetails);
            }

        } catch (SQLException e) {
            logger.error("Error getting table status map", e);
        }

        return tableStatusMap;
    }

    /**
     * Lấy thông tin bàn theo ID
     */
    public Table getTableById(int tableId) {
        String sql = "SELECT * FROM Tables WHERE table_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, tableId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapResultSetToTable(rs);
            }

        } catch (SQLException e) {
            logger.error("Error getting table by ID: " + tableId, e);
        }

        return null;
    }

    /**
     * Map ResultSet to Tables object
     */
    private Table mapResultSetToTable(ResultSet rs) throws SQLException {
        Table table = new Table();
        table.setTableId(rs.getInt("table_id"));
        table.setTableName(rs.getString("table_name"));
        table.setCapacity(rs.getInt("capacity"));
        table.setFloor(rs.getInt("floor"));
        table.setTableType(rs.getString("table_type"));
        table.setStatus(rs.getString("status"));
        table.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        table.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
        return table;
    }
}