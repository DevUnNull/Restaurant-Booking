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

public class ReportRepository {

    DatabaseUtil db = new DatabaseUtil();

    public List<Map<String, Object>> getServiceCategoryReportByStatus(String status) throws SQLException {
        List<Map<String, Object>> reportList = new ArrayList<>();

        String query = """
            SELECT
                mc.name AS category_name,
                -- Tổng số lượng (lấy từ Order_Items theo status được lọc)
                SUM(oi.quantity) AS total_quantity_sold,
                -- CHỈ tính doanh thu nếu trạng thái đặt bàn là COMPLETED
                IFNULL(SUM(CASE WHEN r.status = 'COMPLETED' THEN oi.quantity * oi.unit_price ELSE 0 END), 0) AS total_category_revenue
            FROM
                Order_Items oi
                JOIN Menu_Items mi ON oi.item_id = mi.item_id
                JOIN menu_category mc ON mi.category_id = mc.id
                JOIN Reservations r ON oi.reservation_id = r.reservation_id
            WHERE 1=1
        """;

        List<Object> params = new ArrayList<>();

        // Lọc theo Trạng thái (Status)
        if (status != null && !status.trim().isEmpty() && !status.equalsIgnoreCase("All")) {
            query += " AND r.status = ? ";
            params.add(status);
        } else {
            // Mặc định CHỈ hiển thị COMPLETED
            query += " AND r.status = 'COMPLETED' ";
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


    public List<Map<String, Object>> getTopSellingItems(int limit) throws SQLException {
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
               WHERE 1=1
                 AND R.status = 'COMPLETED'
               """;

        List<Object> params = new ArrayList<>();
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
