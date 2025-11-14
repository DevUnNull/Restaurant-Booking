package com.fpt.restaurantbooking.repositories;

import com.fpt.restaurantbooking.utils.DatabaseUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CancellationReportRepository {

    private final DatabaseUtil db = new DatabaseUtil();

    public CancellationReportRepository() {
    }

    // PHƯƠNG THỨC 1: Đếm tổng số bản ghi
    public int getTotalCancellationCount(String startDate, String endDate) throws SQLException {
        int count = 0;
        String query = """
            SELECT
                COUNT(R.reservation_id)
            FROM
                Reservations R
            WHERE
                R.reservation_date >= ?
                AND R.reservation_date <= ?
                AND R.status IN ('CANCELLED', 'NO_SHOW');
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
        return count;
    }


    // PHƯƠNG THỨC 2: Lấy dữ liệu CÓ PHÂN TRANG
    public List<Map<String, Object>> getCancellationData(String startDate, String endDate, int limit, int offset) throws SQLException {
        List<Map<String, Object>> cancellationList = new ArrayList<>();

        String query = """
            SELECT
                R.reservation_id,
                R.reservation_date,
                R.reservation_time,
                R.guest_count AS number_of_guests, 
                R.cancellation_reason,
                R.status AS reservation_status, 
                U.full_name AS customer_name,
                U.email AS customer_email,
                R.user_id AS customer_id,
                DATEDIFF(R.reservation_date, R.created_at) AS cancellation_lead_time_days
            FROM
                Reservations R
            LEFT JOIN
                Users U ON R.user_id = U.user_id 
            WHERE
                R.reservation_date >= ?
                AND R.reservation_date <= ?
                AND R.status IN ('CANCELLED', 'NO_SHOW')
            ORDER BY
                R.reservation_date DESC, R.reservation_time DESC
            LIMIT ? OFFSET ?; -- Thêm LIMIT và OFFSET cho phân trang
            """;

        try (Connection con = db.getConnection();
             PreparedStatement stm = con.prepareStatement(query)) {

            stm.setString(1, startDate);
            stm.setString(2, endDate);
            stm.setInt(3, limit);     // Tham số 3: LIMIT
            stm.setInt(4, offset);    // Tham số 4: OFFSET

            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();

                    row.put("reservationId", rs.getInt("reservation_id"));
                    row.put("reservationDate", rs.getString("reservation_date"));
                    row.put("reservationTime", rs.getString("reservation_time"));
                    row.put("numberOfGuests", rs.getInt("number_of_guests"));
                    row.put("cancellationReason", rs.getString("cancellation_reason"));
                    row.put("reservationStatus", rs.getString("reservation_status"));
                    row.put("customerEmail", rs.getString("customer_email") != null ? rs.getString("customer_email") : "N/A");
                    row.put("customerName", rs.getString("customer_name") != null ? rs.getString("customer_name") : "Khách vãng lai/Đã xóa");
                    row.put("customerId", rs.getObject("customer_id"));
                    row.put("leadTimeDays", rs.getInt("cancellation_lead_time_days"));

                    cancellationList.add(row);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
        return cancellationList;
    }
}