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

public class OverviewReportRepository {

    private final DatabaseUtil db = new DatabaseUtil();

    public OverviewReportRepository() {
        // Constructor mặc định (Non-Singleton)
    }

    // PHƯƠNG THỨC 1: LẤY DỮ LIỆU TÓM TẮT (Summary Data)
    public Map<String, Object> getSummaryData(String startDate, String endDate) throws SQLException {
        Map<String, Object> summary = new HashMap<>();

        String query = """
        SELECT
            IFNULL(SUM(RS.total_bookings), 0) AS total_bookings,
            IFNULL(SUM(RS.total_revenue), 0) AS total_revenue,
            IFNULL(SUM(RS.cancelled_bookings), 0) AS total_cancellations
        FROM
            Report_Statistics RS
        WHERE 1=1
        """;
        List<Object> params = new ArrayList<>();

        if (startDate != null && !startDate.isEmpty()) {
            query += " AND RS.report_date >= ? ";
            params.add(startDate);
        }
        if (endDate != null && !endDate.isEmpty()) {
            query += " AND RS.report_date <= ? ";
            params.add(endDate);
        }

        try (Connection con = db.getConnection();
             PreparedStatement stm = con.prepareStatement(query)) {

            for (int i = 0; i < params.size(); i++) {
                stm.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    int totalBookings = rs.getInt("total_bookings");
                    BigDecimal totalRevenue = rs.getBigDecimal("total_revenue");
                    int totalCancellations = rs.getInt("total_cancellations");

                    double cancellationRate = 0.0;
                    if (totalBookings > 0) {
                        cancellationRate = ((double) totalCancellations / totalBookings) * 100.0;
                    }

                    summary.put("totalBookings", totalBookings);
                    summary.put("totalRevenue", totalRevenue);
                    summary.put("totalCancellations", totalCancellations);
                    summary.put("cancellationRate", cancellationRate);

                    return summary;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
        return new HashMap<String, Object>() {{
            put("totalBookings", 0);
            put("totalRevenue", BigDecimal.ZERO);
            put("totalCancellations", 0);
            put("cancellationRate", 0.0);
        }};
    }

    // PHƯƠNG THỨC 2: LẤY DỮ LIỆU XU HƯỚNG THEO THỜI GIAN (Time Trend Data)
    public List<Map<String, Object>> getTimeTrendData(String startDate, String endDate, String unit) throws SQLException {
        List<Map<String, Object>> trendList = new ArrayList<>();
        String groupByColumn;

        // Xác định cột nhóm
        switch (unit.toLowerCase()) {
            case "week":
                groupByColumn = "CONCAT(RS.year, '-W', LPAD(WEEK(RS.report_date, 3), 2, '0'))";
                break;
            case "month":
                groupByColumn = "DATE_FORMAT(RS.report_date, '%Y-%m')";
                break;
            case "day":
            default:
                groupByColumn = "DATE(RS.report_date)";
                break;
        }

        String query = String.format("""
            SELECT
                %s AS label,
                SUM(RS.total_bookings) AS total_bookings,
                SUM(RS.total_revenue) AS total_revenue,
                SUM(RS.cancelled_bookings) AS total_cancellations
            FROM
                Report_Statistics RS
            WHERE 1=1
        """, groupByColumn);
        List<Object> params = new ArrayList<>();

        // Lọc theo report_date
        if (startDate != null && !startDate.isEmpty()) {
            query += " AND RS.report_date >= ? ";
            params.add(startDate);
        }
        if (endDate != null && !endDate.isEmpty()) {
            query += " AND RS.report_date <= ? ";
            params.add(endDate);
        }

        query += String.format("""
            GROUP BY
                %s
            ORDER BY
                label ASC;
        """, groupByColumn);

        try (Connection con = db.getConnection();
             PreparedStatement stm = con.prepareStatement(query)) {

            for (int i = 0; i < params.size(); i++) {
                stm.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("label", rs.getString("label"));
                    row.put("totalRevenue", rs.getBigDecimal("total_revenue"));
                    row.put("totalBookings", rs.getInt("total_bookings"));
                    row.put("totalCancellations", rs.getInt("total_cancellations"));
                    trendList.add(row);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
        return trendList;
    }


}