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
import java.math.BigDecimal;
import java.time.LocalDate;

public class ServiceReportRepository {

    DatabaseUtil db = new DatabaseUtil();

    // === Hàm getAvailableServiceTypes (Giữ nguyên) ===
    public List<String> getAvailableServiceTypes() throws SQLException {
        List<String> serviceTypes = new ArrayList<>();
        String query = "SELECT DISTINCT service_name FROM Services WHERE status = 'ACTIVE' ORDER BY service_name;";

        try (Connection con = db.getConnection();
             PreparedStatement stm = con.prepareStatement(query);
             ResultSet rs = stm.executeQuery()) {

            while (rs.next()) {
                serviceTypes.add(rs.getString("service_name"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
        return serviceTypes;
    }

    // === Hàm getTopSellingItems (Giữ nguyên) ===
    public List<Map<String, Object>> getTopSellingItems(String serviceType, String status, String startDate, String endDate, int limit) throws SQLException {
        List<Map<String, Object>> reportList = new ArrayList<>();

        String query = """
                SELECT
                    MI.item_name,
                    SUM(OI.quantity) AS total_quantity_sold,
                    IFNULL(SUM(OI.quantity * OI.unit_price), 0) AS total_revenue_from_item
                FROM
                    Order_Items OI
                        JOIN
                    Menu_Items MI ON OI.item_id = MI.item_id
                        JOIN
                    Reservations R ON OI.reservation_id = R.reservation_id
                        LEFT JOIN 
                    Services s ON R.service_id = s.service_id
                WHERE 1=1
                """;

        List<Object> params = new ArrayList<>();

        if (serviceType != null && !serviceType.trim().isEmpty()) {
            query += " AND s.service_name = ? ";
            params.add(serviceType);
        }

        if (status != null && !status.trim().isEmpty()) {
            if (!status.equalsIgnoreCase("All")) {
                query += " AND R.status = ? ";
                params.add(status.toUpperCase().replace(" ", "_"));
            }
        }

        if (startDate != null && !startDate.trim().isEmpty()) {
            query += " AND R.reservation_date >= ? ";
            params.add(startDate);
        }


        if (endDate != null && !endDate.trim().isEmpty()) {
            query += " AND R.reservation_date <= ? ";
            params.add(endDate);
        }

        query += """
                 GROUP BY
                     MI.item_id, MI.item_name
                 ORDER BY
                     total_quantity_sold DESC, total_revenue_from_item DESC
                 LIMIT ?;
                 """;

        params.add(limit);

        try (Connection con = db.getConnection();
             PreparedStatement stm = con.prepareStatement(query)) {

            for (int i = 0; i < params.size(); i++) {
                stm.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("item_name", rs.getString("item_name"));
                    row.put("total_quantity_sold", rs.getInt("total_quantity_sold"));
                    row.put("total_revenue_from_item", rs.getBigDecimal("total_revenue_from_item"));
                    reportList.add(row);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
        return reportList;
    }

    // === SỬA ĐỔI HÀM getServiceTrendReport ===
    public List<Map<String, Object>> getServiceTrendReport(String serviceType, String status, String startDate, String endDate, String timeGrouping) throws SQLException {
        List<Map<String, Object>> trendList = new ArrayList<>();

        String dateGroupingSelect;
        String dateGroupingColumn;

        switch (timeGrouping) {
            case "month":
                String dateGroupingFormat = "'%Y-%m-01'";
                dateGroupingSelect = String.format("DATE_FORMAT(R.reservation_date, %s) AS report_date", dateGroupingFormat);
                dateGroupingColumn = String.format("DATE_FORMAT(R.reservation_date, %s)", dateGroupingFormat);
                break;
            case "week":
                dateGroupingSelect = "DATE(R.reservation_date) - INTERVAL (WEEKDAY(R.reservation_date)) DAY AS report_date";
                dateGroupingColumn = "DATE(R.reservation_date) - INTERVAL (WEEKDAY(R.reservation_date)) DAY";
                break;
            case "day":
            default:
                dateGroupingSelect = "DATE(R.reservation_date) AS report_date";
                dateGroupingColumn = "DATE(R.reservation_date)";
                break;
        }

        // === SỬA ĐỔI CÂU TRUY VẤN SQL ===
        // Thêm 6 cột COUNT(DISTINCT CASE...) để lấy dữ liệu cho KPI
        String query = """
            SELECT
                %s,
                IFNULL(SUM(
                    CASE
                        WHEN R.status = 'COMPLETED' THEN R.total_amount
                        ELSE T_OI.oi_revenue
                    END
                ), 0) AS total_revenue,
                
                -- BẮT ĐẦU PHẦN MỚI: Đếm chi tiết
                COUNT(DISTINCT R.reservation_id) AS total_bookings,
                COUNT(DISTINCT CASE WHEN R.status = 'COMPLETED' THEN R.reservation_id END) AS completed_bookings,
                COUNT(DISTINCT CASE WHEN R.status = 'CANCELLED' THEN R.reservation_id END) AS cancelled_bookings,
                COUNT(DISTINCT CASE WHEN R.status = 'NO_SHOW' THEN R.reservation_id END) AS no_show_bookings,
                COUNT(DISTINCT CASE WHEN R.status = 'PENDING' THEN R.reservation_id END) AS pending_bookings,
                COUNT(DISTINCT CASE WHEN R.status = 'CONFIRMED' THEN R.reservation_id END) AS checked_in_bookings
                -- KẾT THÚC PHẦN MỚI
                
            FROM
                Reservations R
                LEFT JOIN (
                    SELECT 
                        reservation_id, 
                        SUM(quantity * unit_price) AS oi_revenue
                    FROM Order_Items
                    GROUP BY reservation_id
                ) T_OI ON R.reservation_id = T_OI.reservation_id
                LEFT JOIN Services S ON R.service_id = S.service_id
            WHERE 1=1
        """.formatted(dateGroupingSelect);

        List<Object> params = new ArrayList<>();

        if (serviceType != null && !serviceType.trim().isEmpty()) {
            query += " AND S.service_name = ? ";
            params.add(serviceType);
        }

        if (status != null && !status.trim().isEmpty()) {
            if (!status.equalsIgnoreCase("All")) {
                query += " AND R.status = ? ";
                params.add(status.toUpperCase().replace(" ", "_"));
            }
        }

        query += " AND R.reservation_date >= ? ";
        params.add(startDate);

        query += " AND R.reservation_date <= ? ";
        params.add(endDate);

        query += """
            GROUP BY
                %s
            ORDER BY
                report_date ASC;
        """.formatted(dateGroupingColumn);

        try (Connection con = db.getConnection();
             PreparedStatement stm = con.prepareStatement(query)) {

            for (int i = 0; i < params.size(); i++) {
                stm.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("report_date", LocalDate.parse(rs.getString("report_date")).toString());
                    row.put("total_revenue", rs.getBigDecimal("total_revenue"));

                    // === SỬA ĐỔI: Lấy tất cả các cột đếm mới ===
                    row.put("total_bookings", rs.getInt("total_bookings"));
                    row.put("completed_bookings", rs.getInt("completed_bookings"));
                    row.put("cancelled_bookings", rs.getInt("cancelled_bookings"));
                    row.put("no_show_bookings", rs.getInt("no_show_bookings"));
                    row.put("pending_bookings", rs.getInt("pending_bookings"));
                    row.put("checked_in_bookings", rs.getInt("checked_in_bookings"));

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