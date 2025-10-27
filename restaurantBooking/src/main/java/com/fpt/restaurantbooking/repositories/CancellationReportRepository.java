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

    public List<Map<String, Object>> getCancellationData(String startDate, String endDate) throws SQLException {
        List<Map<String, Object>> cancellationList = new ArrayList<>();

        String query = """
            SELECT
                R.reservation_id,
                R.reservation_date,
                R.reservation_time,
                R.guest_count AS number_of_guests, 
                R.cancellation_reason,
                R.reservation_status, 
                R.customer_name,
                R.customer_email,
                R.user_id AS customer_id,
                R.cancellation_lead_time_days
            FROM
                Report_Cancellation_Details R
            WHERE
                R.reservation_date >= ?
                AND R.reservation_date <= ?
                AND R.reservation_status IN ('CANCELLED', 'NO_SHOW')
            ORDER BY
                R.reservation_date DESC, R.reservation_time DESC;
            """;

        try (Connection con = db.getConnection();
             PreparedStatement stm = con.prepareStatement(query)) {

            stm.setString(1, startDate);
            stm.setString(2, endDate);

            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("reservationId", rs.getInt("reservation_id"));
                    row.put("reservationDate", rs.getString("reservation_date"));
                    row.put("reservationTime", rs.getString("reservation_time"));
                    row.put("numberOfGuests", rs.getInt("number_of_guests"));
                    row.put("cancellationReason", rs.getString("cancellation_reason"));
                    row.put("reservationStatus", rs.getString("reservation_status"));
                    row.put("customerEmail", rs.getString("customer_email"));
                    row.put("customerId", rs.getInt("customer_id"));
                    row.put("customerName", rs.getString("customer_name"));
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