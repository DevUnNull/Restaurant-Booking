package com.fpt.restaurantbooking.repositories;

import com.fpt.restaurantbooking.utils.DatabaseUtil;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CustomerReportRepository {

    private final DatabaseUtil db;

    public CustomerReportRepository() {
        this.db = new DatabaseUtil();
    }


    public int getTotalActiveCustomerCount() throws SQLException {
        String query = "SELECT COUNT(user_id) FROM Users WHERE role_id = 3;";
        try (Connection con = db.getConnection();
             PreparedStatement stm = con.prepareStatement(query)) {
            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
        return 0;
    }


    public long getGrandTotalSpending(String startDate, String endDate) throws SQLException {
        String query = """
            SELECT IFNULL(SUM(R.total_amount), 0) AS grand_total
            FROM Reservations R
            JOIN Users U ON R.user_id = U.user_id
            WHERE U.role_id = 3
            AND R.status = 'COMPLETED'
            AND R.reservation_date >= ?
            AND R.reservation_date <= ?;
        """;
        try (Connection con = db.getConnection();
             PreparedStatement stm = con.prepareStatement(query)) {

            stm.setString(1, startDate);
            stm.setString(2, endDate);

            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal("grand_total").longValue();
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
        return 0;
    }


    public int getNewCustomerCount(String startDate, String endDate) throws SQLException {
        int count = 0;

        String query = """
            SELECT COUNT(user_id)
            FROM Users
            WHERE role_id = 3
            AND DATE(CONVERT_TZ(created_at, '+00:00', '+07:00')) >= ?
            AND DATE(CONVERT_TZ(created_at, '+00:00', '+07:00')) <= ?;
        """;

        try (Connection con = db.getConnection();
             PreparedStatement stm = con.prepareStatement(query)) {

            stm.setString(1, startDate);
            stm.setString(2, endDate);

            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
        return 0;
    }


    public List<Map<String, Object>> getCustomerOverviewData(String startDate, String endDate, int limit, int offset) throws SQLException {
        List<Map<String, Object>> customerList = new ArrayList<>();
        String query = """
            SELECT
                U.user_id,
                U.full_name AS customer_name,
                U.email,
                U.phone_number,
                U.status AS customer_status,
                U.gender,
                U.date_of_birth,
                COUNT(R.reservation_id) AS total_reservations,
                IFNULL(SUM(R.total_amount), 0) AS total_spending
            FROM
                Users U
            LEFT JOIN
                Reservations R ON U.user_id = R.user_id
                AND R.reservation_date >= ?
                AND R.reservation_date <= ?
                AND R.status = 'COMPLETED'
            WHERE
                U.role_id = 3
            GROUP BY
                U.user_id, U.full_name, U.email, U.phone_number, U.status,
                U.gender, U.date_of_birth
            ORDER BY
                total_spending DESC, total_reservations DESC
            LIMIT ? OFFSET ?;
        """;

        try (Connection con = db.getConnection();
             PreparedStatement stm = con.prepareStatement(query)) {

            stm.setString(1, startDate);
            stm.setString(2, endDate);
            stm.setInt(3, limit);
            stm.setInt(4, offset);

            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("customerId", rs.getInt("user_id"));
                    row.put("customerName", rs.getString("customer_name"));
                    row.put("email", rs.getString("email"));
                    row.put("phoneNumber", rs.getString("phone_number"));
                    row.put("customerStatus", rs.getString("customer_status"));
                    row.put("gender", rs.getString("gender"));
                    row.put("dob", rs.getDate("date_of_birth"));
                    row.put("totalReservations", rs.getInt("total_reservations"));
                    BigDecimal totalSpending = rs.getBigDecimal("total_spending");
                    row.put("totalSpending", totalSpending.longValue());

                    customerList.add(row);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
        return customerList;
    }

    public Map<String, Object> getCustomerDetails(int userId) throws SQLException {
        Map<String, Object> customerDetail = new HashMap<>();
        String query = """
            SELECT full_name, email, phone_number, status, gender, date_of_birth 
            FROM Users WHERE user_id = ? AND role_id = 3
        """;
        try (Connection con = db.getConnection();
             PreparedStatement stm = con.prepareStatement(query)) {
            stm.setInt(1, userId);
            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    customerDetail.put("fullName", rs.getString("full_name"));
                    customerDetail.put("email", rs.getString("email"));
                    customerDetail.put("phoneNumber", rs.getString("phone_number"));
                    customerDetail.put("status", rs.getString("status"));
                    customerDetail.put("gender", rs.getString("gender"));
                    customerDetail.put("dob", rs.getDate("date_of_birth"));
                    return customerDetail;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
        return null;
    }

    public List<Map<String, Object>> getReservationsForCustomer(int userId, String startDate, String endDate) throws SQLException {
        List<Map<String, Object>> reservationList = new ArrayList<>();
        String query = """
            SELECT
                reservation_id,
                reservation_date,
                reservation_time,
                status,
                total_amount
            FROM
                Reservations
            WHERE
                user_id = ?
                AND reservation_date >= ?
                AND reservation_date <= ?
            ORDER BY
                reservation_date DESC, reservation_time DESC;
        """;

        try (Connection con = db.getConnection();
             PreparedStatement stm = con.prepareStatement(query)) {

            stm.setInt(1, userId);
            stm.setString(2, startDate);
            stm.setString(3, endDate);

            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("reservation_id", rs.getInt("reservation_id"));
                    row.put("reservation_date", rs.getDate("reservation_date"));
                    row.put("reservation_time", rs.getTime("reservation_time"));
                    row.put("status", rs.getString("status"));
                    row.put("total_amount", rs.getBigDecimal("total_amount"));
                    reservationList.add(row);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
        return reservationList;
    }

}