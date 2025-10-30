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

public class ServiceReportRepository {

    DatabaseUtil db = new DatabaseUtil();

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

    public List<Map<String, Object>> getServiceCategoryReport(String serviceType, String status, String startDate, String endDate) throws SQLException {
        List<Map<String, Object>> reportList = new ArrayList<>();

        String query = """
            SELECT
                mc.name AS category_name,
                SUM(oi.quantity) AS total_quantity_sold,
                IFNULL(SUM(CASE WHEN r.status = 'COMPLETED' THEN oi.quantity * oi.unit_price ELSE 0 END), 0) AS total_category_revenue
            FROM
                Order_Items oi
                JOIN Menu_Items mi ON oi.item_id = mi.item_id
                JOIN menu_category mc ON mi.category_id = mc.id
                JOIN Reservations r ON oi.reservation_id = r.reservation_id
                JOIN Services s ON r.service_id = s.service_id
            WHERE 1=1
        """;

        List<Object> params = new ArrayList<>();

        if (serviceType != null && !serviceType.trim().isEmpty()) {
            query += " AND s.service_name = ? ";
            params.add(serviceType);
        }

        if (status != null && !status.trim().isEmpty()) {
            if (!status.equalsIgnoreCase("All")) {
                query += " AND r.status = ? ";
                params.add(status.toUpperCase().replace(" ", "_"));
            }
        } else {
            query += " AND r.status = 'COMPLETED' ";
        }

        if (startDate != null && !startDate.trim().isEmpty()) {
            query += " AND r.reservation_date >= ? ";
            params.add(startDate);
        }

        if (endDate != null && !endDate.trim().isEmpty()) {
            query += " AND r.reservation_date <= ? ";
            params.add(endDate);
        }

        query += """
            GROUP BY
                mc.name
            ORDER BY
                total_category_revenue DESC;
        """;

        try (Connection con = db.getConnection();
             PreparedStatement stm = con.prepareStatement(query)) {

            for (int i = 0; i < params.size(); i++) {
                stm.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("service_category", rs.getString("category_name"));
                    row.put("total_quantity_sold", rs.getInt("total_quantity_sold"));
                    row.put("total_category_revenue", rs.getBigDecimal("total_category_revenue"));
                    reportList.add(row);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
        return reportList;
    }


    /**
     * Sửa: Phương thức này giờ nhận đầy đủ 4 tham số lọc
     */
    public List<Map<String, Object>> getTopSellingItems(String serviceType, String status, String startDate, String endDate, int limit) throws SQLException {
        List<Map<String, Object>> reportList = new ArrayList<>();

        String query = """
                SELECT
                    MI.item_name,
                    SUM(OI.quantity) AS total_quantity_sold,
                    IFNULL(SUM(CASE WHEN R.status = 'COMPLETED' THEN OI.quantity * OI.unit_price ELSE 0 END), 0) AS total_revenue_from_item
                FROM
                    Order_Items OI
                        JOIN
                    Menu_Items MI ON OI.item_id = MI.item_id
                        JOIN
                    Reservations R ON OI.reservation_id = R.reservation_id
                        JOIN 
                    Services s ON R.service_id = s.service_id
                WHERE 1=1
                """;

        List<Object> params = new ArrayList<>();

        // 1. Lọc theo Loại dịch vụ (Service Type)
        if (serviceType != null && !serviceType.trim().isEmpty()) {
            query += " AND s.service_name = ? ";
            params.add(serviceType);
        }

        // 2. Lọc theo Trạng thái (Status)
        if (status != null && !status.trim().isEmpty()) {
            if (!status.equalsIgnoreCase("All")) {
                query += " AND R.status = ? ";
                params.add(status.toUpperCase().replace(" ", "_"));
            }
        } else {
            query += " AND R.status = 'COMPLETED' ";
        }

        // 3. Lọc theo Ngày bắt đầu (Start Date) - Cột reservation_date
        if (startDate != null && !startDate.trim().isEmpty()) {
            query += " AND R.reservation_date >= ? ";
            params.add(startDate);
        }

        // 4. Lọc theo Ngày kết thúc (End Date) - Cột reservation_date
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
}