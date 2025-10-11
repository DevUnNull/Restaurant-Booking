package com.fpt.restaurantbooking.repositories.impl;

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

    PreparedStatement stm;
    ResultSet rs;
    DatabaseUtil db = new DatabaseUtil();

    /**
     *  Báo cáo Doanh thu và Số lượng đặt theo Category (Loại Dịch vụ/Món ăn)
     * @return List of Map<String, Object> chứa service_category, total_quantity_sold, total_category_revenue
     * @throws SQLException
     */
    public List<Map<String, Object>> getServiceCategoryReport() throws SQLException {
        List<Map<String, Object>> reportList = new ArrayList<>();

        // Truy vấn SQL để thống kê Doanh thu và Số lượng theo Category
        String query = "SELECT " +
                "    MI.category AS service_category, " +
                "    SUM(OI.quantity) AS total_quantity_sold, " +
                "    IFNULL(SUM(OI.quantity * OI.unit_price), 0) AS total_category_revenue " +
                "FROM " +
                "    Order_Items OI " +
                "JOIN " +
                "    Menu_Items MI ON OI.item_id = MI.item_id " +
                "JOIN " +
                "    Reservations R ON OI.reservation_id = R.reservation_id " +
                "WHERE " +
                "    R.status = 'COMPLETED' " +
                "GROUP BY " +
                "    MI.category " +
                "ORDER BY " +
                "    total_category_revenue DESC";

        try (Connection con = db.getConnection();
             PreparedStatement stm = con.prepareStatement(query);
             ResultSet rs = stm.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                // Lưu trữ kết quả theo tên cột định nghĩa trong truy vấn SQL
                row.put("service_category", rs.getString("service_category"));
                row.put("total_quantity_sold", rs.getInt("total_quantity_sold"));
                row.put("total_category_revenue", rs.getBigDecimal("total_category_revenue"));
                reportList.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
        return reportList;
    }

    /**
     * Phương thức 2: Top Món Bán Chạy Nhất (Theo số lượng)
     * @param limit Số lượng món muốn hiển thị (ví dụ: 10)
     * @return List of Map<String, Object> chứa item_name, total_quantity_sold, total_revenue_from_item
     * @throws SQLException
     */
    public List<Map<String, Object>> getTopSellingItems(int limit) throws SQLException {
        List<Map<String, Object>> reportList = new ArrayList<>();

        // Truy vấn SQL để thống kê Top món bán chạy nhất
        String query = "SELECT " +
                "    MI.item_name, " +
                "    SUM(OI.quantity) AS total_quantity_sold, " +
                "    IFNULL(SUM(OI.quantity * OI.unit_price), 0) AS total_revenue_from_item " +
                "FROM " +
                "    Order_Items OI " +
                "JOIN " +
                "    Menu_Items MI ON OI.item_id = MI.item_id " +
                "GROUP BY " +
                "    MI.item_id, MI.item_name " +
                "ORDER BY " +
                "    total_quantity_sold DESC, total_revenue_from_item DESC " +
                "LIMIT ?";

        try (Connection con = db.getConnection();
             PreparedStatement stm = con.prepareStatement(query)) {

            stm.setInt(1, limit);

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
