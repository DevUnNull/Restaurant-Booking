/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.fpt.restaurantbooking.repositories.impl;


import com.fpt.restaurantbooking.models.Service;
import com.fpt.restaurantbooking.utils.DatabaseUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Quandxnunxi28
 */
public class ServiceRepository {

    PreparedStatement stm;
    ResultSet rs;
    DatabaseUtil db = new DatabaseUtil();

    public List<Service> getService() {
        List<Service> list = new ArrayList<>();
        String query = "select * from Services";
        try {
            stm = db.getConnection().prepareStatement(query);
            rs = stm.executeQuery();
            while (rs.next()) {
                list.add(new Service(rs.getInt("service_id"), rs.getString("service_name"), rs.getString("service_code"), rs.getString("description"), rs.getString("price"),
                         rs.getString("promotion_info"), rs.getString("start_date"), rs.getString("end_date"), rs.getString("status")));
            }
        } catch (Exception e) {
        }
        return list;
    }

    public List<Service> getAllService() {
        List<Service> list = new ArrayList<>();
        String query = "SELECT \n" +
"    s.service_id,\n" +
"    s.service_name, s.service_code, s.description, \n" +
"    s.price, s.promotion_info, s.start_date, s.end_date, s.status,\n" +
"    uc.full_name AS created_by_name,\n" +
"    uu.full_name AS updated_by_name\n" +
" FROM Services s\n" +
" LEFT JOIN Users uc ON s.created_by = uc.user_id\n" +
" LEFT JOIN Users uu ON s.updated_by = uu.user_id";
        try {
            stm = db.getConnection().prepareStatement(query);
            rs = stm.executeQuery();
            while (rs.next()) {
                list.add(new Service(rs.getInt("service_id"), rs.getString("service_name"), rs.getString("service_code"), rs.getString("description"), rs.getString("price"),
                         rs.getString("promotion_info"), rs.getString("start_date"), rs.getString("end_date"), rs.getString("status"), rs.getString("created_by_name"), // đổi sang name
    rs.getString("updated_by_name") )); // đổi sang name));
            }
        } catch (Exception e) {
        }
        return list;
    }

    public void updateService   (String serviceName, String description, String price, String status, String startDate, String endDate, String service_id) throws SQLException {
        String sql = "UPDATE Services SET service_name = ?, description = ? ,   price = ? , status= ?, start_date= ? , end_date=?  WHERE service_id = ?";
        try (Connection con = db.getConnection(); PreparedStatement stm = con.prepareStatement(sql)) {
            stm.setString(1, serviceName);
            stm.setString(2, description);
            stm.setString(3, price);
            stm.setString(4, status);
            stm.setString(5, startDate);
            stm.setString(6, endDate);
            stm.setString(7, service_id);

            stm.executeUpdate();
        } catch (SQLException e) {
            throw e;
        }
    }

    public void deleteService(String service_id) throws SQLException {
        String sql = "Delete From Services  WHERE service_id = ? ";
        try (Connection con = db.getConnection(); PreparedStatement stm = con.prepareStatement(sql)) {

            stm.setString(1, service_id);

            stm.executeUpdate();
        } catch (SQLException e) {
            throw e;
        }
    }

    public void addService(String serviceName,String serviceCode, String description, String price, String status, String startDate, String endDate, int id) throws SQLException {
        String sql = " INSERT INTO Services (service_name,service_code, description, price, status, start_date, end_date, created_by, updated_by ) \n"
                + " VALUES (?,?, ?, ?, ?, ?, ?,?,?);";
        try (Connection con = db.getConnection(); PreparedStatement stm = con.prepareStatement(sql)) {

            stm.setString(1, serviceName);
                        stm.setString(2, serviceCode);

            stm.setString(3, description);
            stm.setString(4, price);
            stm.setString(5, status);
            stm.setString(6, startDate);
            stm.setString(7, endDate);
                        stm.setInt(8, id);
                        stm.setInt(9, id);

            stm.executeUpdate();
        } catch (SQLException e) {
            throw e;
        }
    }
    public List<Service> getServicesByPageShowList(int offset, int limit) {
    List<Service> list = new ArrayList<>();
   

    String query = "SELECT * FROM Services ORDER BY service_id DESC limit ?,  ?";
    try {
        stm = db.getConnection().prepareStatement(query);
        stm.setInt(1, offset);
        stm.setInt(2, limit);
        rs = stm.executeQuery();
        while (rs.next()) {
            list.add(new Service(
                rs.getInt("service_id"),
                rs.getString("service_name"),
                rs.getString("service_code"),
                rs.getString("description"),
                rs.getString("price"),
                rs.getString("promotion_info"),
                rs.getString("start_date"),
                rs.getString("end_date"),
                rs.getString("status")
            ));
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}
    public List<Service> getServicesByPage(int offset, int limit) throws SQLException {
    List<Service> list = new ArrayList<>();
   String sql = " SELECT  " +
            " s.service_id, s.service_name, s.service_code, s.description,  " +
            " s.price, s.promotion_info, s.start_date, s.end_date, s.status,  " +
            " uc.full_name AS created_by_name,  " +
            " uu.full_name AS updated_by_name  " +
            " FROM Services s  " +
            " LEFT JOIN Users uc ON s.created_by = uc.user_id  " +
            " LEFT JOIN Users uu ON s.updated_by = uu.user_id  " +
            " ORDER BY s.service_id DESC " +
            " LIMIT ?, ? ";
    PreparedStatement ps = db.getConnection().prepareStatement(sql);
    ps.setInt(1, offset);
    ps.setInt(2, limit);
    ResultSet rs = ps.executeQuery();
    while (rs.next()) {
        list.add(new Service(
                rs.getInt("service_id"),
                rs.getString("service_name"),
                rs.getString("service_code"),
                rs.getString("description"),
                rs.getString("price"),
                rs.getString("promotion_info"),
                rs.getString("start_date"),
                rs.getString("end_date"),
                rs.getString("status"),
                rs.getString("created_by_name"),
                rs.getString("updated_by_name")
        ));
    }
    return list;
}

public int getTotalServiceCount() throws SQLException {
    String sql = "SELECT COUNT(*) FROM services ";
    PreparedStatement ps = db.getConnection().prepareStatement(sql);
    ResultSet rs = ps.executeQuery();
    if (rs.next()) {
        return rs.getInt(1);
    }
    return 0;
}


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
