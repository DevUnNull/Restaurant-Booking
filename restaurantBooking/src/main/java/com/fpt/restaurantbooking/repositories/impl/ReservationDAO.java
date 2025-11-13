package com.fpt.restaurantbooking.repositories.impl;

import com.fpt.restaurantbooking.models.Reservation;
import com.fpt.restaurantbooking.dto.OrderManagementDTO;
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
            if (reservation.getTableId() != null && reservation.getTableId() > 0) {
                pstmt.setInt(2, reservation.getTableId());
            } else {
                pstmt.setNull(2, java.sql.Types.INTEGER);
            }

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

    // Get booked table IDs for a specific date and time slot
    // slot can be "MORNING", "AFTERNOON", or "EVENING"
    public List<Integer> getBookedTableIdsForSlot(LocalDate date, String slot) {
        String sql = "SELECT DISTINCT rt.table_id " +
                "FROM Reservation_Tables rt " +
                "INNER JOIN Reservations r ON rt.reservation_id = r.reservation_id " +
                "WHERE r.reservation_date = ? " +
                "AND r.status IN ('CONFIRMED', 'COMPLETED') " +
                "AND (";

        // Determine time range based on slot
        String timeCondition = "";
        if ("MORNING".equalsIgnoreCase(slot)) {
            timeCondition = "TIME(r.reservation_time) >= TIME('08:00:00') AND TIME(r.reservation_time) < TIME('12:00:00')";
        } else if ("AFTERNOON".equalsIgnoreCase(slot)) {
            timeCondition = "TIME(r.reservation_time) >= TIME('12:00:00') AND TIME(r.reservation_time) < TIME('18:00:00')";
        } else if ("EVENING".equalsIgnoreCase(slot)) {
            timeCondition = "TIME(r.reservation_time) >= TIME('18:00:00') AND TIME(r.reservation_time) <= TIME('23:59:59')";
        } else {
            // If slot is not recognized, return empty list
            return new ArrayList<>();
        }

        sql += timeCondition + ")";

        List<Integer> tableIds = new ArrayList<>();

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setDate(1, Date.valueOf(date));

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    tableIds.add(rs.getInt("table_id"));
                }
            }
        } catch (SQLException e) {
            logger.error("Error getting booked tables for slot: " + slot + " on date: " + date, e);
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

    // Update reservation core fields (date, time, guests, special requests, total)
    public boolean updateReservationDetails(int reservationId, LocalDate date, LocalTime time,
                                            int guestCount, String specialRequests, BigDecimal totalAmount) {
        String sql = "UPDATE Reservations SET reservation_date = ?, reservation_time = ?, guest_count = ?, special_requests = ?, total_amount = ?, updated_at = NOW() WHERE reservation_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setDate(1, Date.valueOf(date));
            pstmt.setTime(2, Time.valueOf(time));
            pstmt.setInt(3, guestCount);
            pstmt.setString(4, specialRequests);
            pstmt.setBigDecimal(5, totalAmount != null ? totalAmount : BigDecimal.ZERO);
            pstmt.setInt(6, reservationId);

            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            logger.error("Error updating reservation details", e);
        }
        return false;
    }

    // Cancel reservation
    public boolean cancelReservation(int reservationId, String reason) {
        String sql = "UPDATE Reservations SET status = 'CANCELLED', cancellation_reason = ?, updated_at = NOW() WHERE reservation_id = ? AND status IN ('PENDING', 'CONFIRMED')";

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

    // Get all reservations with detailed information (for management)
    public List<OrderManagementDTO> getAllReservationsWithDetails(String statusFilter, String searchQuery, int offset, int limit) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT r.reservation_id, r.reservation_date, r.reservation_time, r.guest_count, ");
        sql.append("r.status, r.total_amount, r.special_requests, r.created_at, r.updated_at, ");
        sql.append("u.user_id, u.full_name, u.phone_number, u.email, ");
        sql.append("(SELECT p1.payment_method FROM Payments p1 WHERE p1.reservation_id = r.reservation_id ");
        sql.append(" ORDER BY CASE WHEN p1.payment_status = 'COMPLETED' THEN 0 ELSE 1 END, p1.payment_id DESC LIMIT 1) as payment_method, ");
        sql.append("(SELECT p1.payment_status FROM Payments p1 WHERE p1.reservation_id = r.reservation_id ");
        sql.append(" ORDER BY CASE WHEN p1.payment_status = 'COMPLETED' THEN 0 ELSE 1 END, p1.payment_id DESC LIMIT 1) as payment_status, ");
        sql.append("GROUP_CONCAT(DISTINCT t.table_name ORDER BY t.table_name SEPARATOR ', ') as table_names, ");
        sql.append("COUNT(DISTINCT oi.order_item_id) as item_count ");
        sql.append("FROM Reservations r ");
        sql.append("LEFT JOIN Users u ON r.user_id = u.user_id ");
        sql.append("LEFT JOIN Reservation_Tables rt ON r.reservation_id = rt.reservation_id ");
        sql.append("LEFT JOIN Tables t ON rt.table_id = t.table_id ");
        sql.append("LEFT JOIN Order_Items oi ON r.reservation_id = oi.reservation_id ");
        sql.append("WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        // Filter by status
        if (statusFilter != null && !statusFilter.isEmpty() && !"ALL".equals(statusFilter)) {
            sql.append("AND r.status = ? ");
            params.add(statusFilter);
        }

        // Search query (customer name, phone, email, reservation ID)
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            sql.append("AND (u.full_name LIKE ? OR u.phone_number LIKE ? OR u.email LIKE ? OR r.reservation_id = ?) ");
            String searchPattern = "%" + searchQuery.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
            try {
                params.add(Integer.parseInt(searchQuery.trim()));
            } catch (NumberFormatException e) {
                params.add(-1); // Invalid ID
            }
        }

        // MySQL ONLY_FULL_GROUP_BY requires all non-aggregated columns in GROUP BY
        sql.append("GROUP BY r.reservation_id, r.reservation_date, r.reservation_time, ");
        sql.append("r.guest_count, r.status, r.total_amount, r.special_requests, ");
        sql.append("r.created_at, r.updated_at, u.user_id, u.full_name, u.phone_number, u.email ");
        sql.append("ORDER BY r.created_at DESC ");
        sql.append("LIMIT ? OFFSET ?");
        params.add(limit);
        params.add(offset);

        List<OrderManagementDTO> orders = new ArrayList<>();

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {

            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    try {
                        OrderManagementDTO dto = new OrderManagementDTO();

                        // Reservation info
                        dto.setReservationId(rs.getInt("reservation_id"));

                        // Safe handling for dates
                        java.sql.Date sqlDate = rs.getDate("reservation_date");
                        if (sqlDate != null) {
                            dto.setReservationDate(sqlDate.toLocalDate());
                        }

                        java.sql.Time sqlTime = rs.getTime("reservation_time");
                        if (sqlTime != null) {
                            dto.setReservationTime(sqlTime.toLocalTime());
                        }

                        dto.setGuestCount(rs.getInt("guest_count"));
                        dto.setStatus(rs.getString("status"));
                        dto.setTotalAmount(rs.getBigDecimal("total_amount"));
                        dto.setSpecialRequests(rs.getString("special_requests"));

                        Timestamp createdAt = rs.getTimestamp("created_at");
                        if (createdAt != null) {
                            dto.setCreatedAt(createdAt.toLocalDateTime());
                        }

                        Timestamp updatedAt = rs.getTimestamp("updated_at");
                        if (updatedAt != null) {
                            dto.setUpdatedAt(updatedAt.toLocalDateTime());
                        }

                        // Customer info
                        dto.setUserId(rs.getInt("user_id"));
                        dto.setCustomerName(rs.getString("full_name"));
                        dto.setCustomerPhone(rs.getString("phone_number"));
                        dto.setCustomerEmail(rs.getString("email"));

                        // Table info
                        dto.setTableNames(rs.getString("table_names"));

                        // Order items count
                        dto.setItemCount(rs.getInt("item_count"));

                        // Payment info
                        dto.setPaymentMethod(rs.getString("payment_method"));
                        dto.setPaymentStatus(rs.getString("payment_status"));

                        orders.add(dto);
                    } catch (Exception e) {
                        logger.error("Error parsing reservation row: " + rs.getInt("reservation_id"), e);
                        // Continue to next row instead of failing entire query
                    }
                }
            }
        } catch (SQLException e) {
            logger.error("Error getting all reservations with details", e);
            logger.error("SQL Query: " + sql.toString());
            e.printStackTrace(); // Print full stack trace
        }

        return orders;
    }

    // Get total count of reservations (for pagination)
    // Get service ID by reservation ID
    public Integer getServiceIdByReservationId(int reservationId) {
        String sql = "SELECT service_id FROM Reservations WHERE reservation_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, reservationId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    int serviceId = rs.getInt("service_id");
                    return rs.wasNull() ? null : serviceId;
                }
            }
        } catch (SQLException e) {
            logger.error("Error getting service ID for reservation {}", reservationId, e);
        }
        return null;
    }

    // Get reservation details by ID (for email notification)
    public OrderManagementDTO getReservationDetailsById(int reservationId) {
        String sql = "SELECT r.reservation_id, r.reservation_date, r.reservation_time, r.guest_count, " +
                "r.status, r.total_amount, r.special_requests, r.created_at, r.updated_at, " +
                "u.user_id, u.full_name, u.phone_number, u.email, " +
                "p.payment_method, p.payment_status, " +
                "GROUP_CONCAT(DISTINCT t.table_name ORDER BY t.table_name SEPARATOR ', ') as table_names, " +
                "COUNT(DISTINCT oi.order_item_id) as item_count " +
                "FROM Reservations r " +
                "LEFT JOIN Users u ON r.user_id = u.user_id " +
                "LEFT JOIN Payments p ON r.reservation_id = p.reservation_id " +
                "LEFT JOIN Reservation_Tables rt ON r.reservation_id = rt.reservation_id " +
                "LEFT JOIN Tables t ON rt.table_id = t.table_id " +
                "LEFT JOIN Order_Items oi ON r.reservation_id = oi.reservation_id " +
                "WHERE r.reservation_id = ? " +
                "GROUP BY r.reservation_id, r.reservation_date, r.reservation_time, " +
                "r.guest_count, r.status, r.total_amount, r.special_requests, " +
                "r.created_at, r.updated_at, u.user_id, u.full_name, u.phone_number, " +
                "u.email, p.payment_method, p.payment_status";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, reservationId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    OrderManagementDTO dto = new OrderManagementDTO();

                    // Reservation info
                    dto.setReservationId(rs.getInt("reservation_id"));

                    // Safe handling for dates
                    java.sql.Date sqlDate = rs.getDate("reservation_date");
                    if (sqlDate != null) {
                        dto.setReservationDate(sqlDate.toLocalDate());
                    }

                    java.sql.Time sqlTime = rs.getTime("reservation_time");
                    if (sqlTime != null) {
                        dto.setReservationTime(sqlTime.toLocalTime());
                    }

                    dto.setGuestCount(rs.getInt("guest_count"));
                    dto.setStatus(rs.getString("status"));
                    dto.setTotalAmount(rs.getBigDecimal("total_amount"));
                    dto.setSpecialRequests(rs.getString("special_requests"));

                    Timestamp createdAt = rs.getTimestamp("created_at");
                    if (createdAt != null) {
                        dto.setCreatedAt(createdAt.toLocalDateTime());
                    }

                    Timestamp updatedAt = rs.getTimestamp("updated_at");
                    if (updatedAt != null) {
                        dto.setUpdatedAt(updatedAt.toLocalDateTime());
                    }

                    // Customer info
                    dto.setUserId(rs.getInt("user_id"));
                    dto.setCustomerName(rs.getString("full_name"));
                    dto.setCustomerPhone(rs.getString("phone_number"));
                    dto.setCustomerEmail(rs.getString("email"));

                    // Table info
                    dto.setTableNames(rs.getString("table_names"));

                    // Order items count
                    dto.setItemCount(rs.getInt("item_count"));

                    // Payment info
                    dto.setPaymentMethod(rs.getString("payment_method"));
                    dto.setPaymentStatus(rs.getString("payment_status"));

                    return dto;
                }
            }
        } catch (SQLException e) {
            logger.error("Error getting reservation details by ID: {}", reservationId, e);
        }

        return null;
    }

    public int getTotalReservationsCount(String statusFilter, String searchQuery) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(DISTINCT r.reservation_id) as total ");
        sql.append("FROM Reservations r ");
        sql.append("LEFT JOIN Users u ON r.user_id = u.user_id ");
        sql.append("WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        if (statusFilter != null && !statusFilter.isEmpty() && !"ALL".equals(statusFilter)) {
            sql.append("AND r.status = ? ");
            params.add(statusFilter);
        }

        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            sql.append("AND (u.full_name LIKE ? OR u.phone_number LIKE ? OR u.email LIKE ? OR r.reservation_id = ?) ");
            String searchPattern = "%" + searchQuery.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
            try {
                params.add(Integer.parseInt(searchQuery.trim()));
            } catch (NumberFormatException e) {
                params.add(-1);
            }
        }

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }
        } catch (SQLException e) {
            logger.error("Error getting total reservations count", e);
        }

        return 0;
    }

    private Reservation mapResultSetToReservation(ResultSet rs) throws SQLException {
        // Lấy created_at từ DB trước
        Timestamp createdAt = rs.getTimestamp("created_at");
        Timestamp updatedAt = rs.getTimestamp("updated_at");

        Reservation reservation = new Reservation(
                rs.getInt("reservation_id"),
                rs.getInt("user_id"),
                rs.getInt("table_id"),
                rs.getInt("guest_count"),
                createdAt != null ? createdAt.toLocalDateTime() : null,
                rs.getString("status"),
                rs.getInt("guest_count")
        );

        reservation.setReservationId(rs.getInt("reservation_id"));
        reservation.setReservationDate(rs.getDate("reservation_date").toLocalDate());
        reservation.setReservationTime(rs.getTime("reservation_time").toLocalTime());
        reservation.setSpecialRequests(rs.getString("special_requests"));
        reservation.setTotalAmount(rs.getBigDecimal("total_amount"));
        reservation.setCancellationReason(rs.getString("cancellation_reason"));

        // Lấy updated_at từ DB, nếu null thì dùng created_at
        if (updatedAt != null) {
            reservation.setUpdatedAt(updatedAt.toLocalDateTime());
        } else if (createdAt != null) {
            reservation.setUpdatedAt(createdAt.toLocalDateTime());
        }

        return reservation;
    }
}