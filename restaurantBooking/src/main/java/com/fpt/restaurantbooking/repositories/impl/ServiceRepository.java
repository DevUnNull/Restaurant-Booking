/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.fpt.restaurantbooking.repositories.impl;


import com.fpt.restaurantbooking.models.MenuItem;
import com.fpt.restaurantbooking.models.Service;
import com.fpt.restaurantbooking.utils.DatabaseUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * @author Quandxnunxi28
 */
public class ServiceRepository {

    PreparedStatement stm;
    ResultSet rs;
    DatabaseUtil db = new DatabaseUtil();

    public List<Service> getService() throws SQLException {
        List<Service> list = new ArrayList<>();
        String query = "select * from Services";
        try (Connection conn = db.getConnection();
             PreparedStatement stm = conn.prepareStatement(query);
             ResultSet rs = stm.executeQuery();) {

            while (rs.next()) {
                list.add(new Service(rs.getInt("service_id"), rs.getString("service_name"), rs.getString("service_code"), rs.getString("description"), rs.getString("price"),
                        rs.getString("promotion_info"), rs.getString("start_date"), rs.getString("end_date"), rs.getString("status")));
            }
        } catch (Exception e) {
        }

        return list;
    }

    public List<Service> getAllService() throws SQLException {
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

        try (Connection conn = db.getConnection();
             PreparedStatement stm = conn.prepareStatement(query);
             ResultSet rs = stm.executeQuery();) {


            while (rs.next()) {
                list.add(new Service(rs.getInt("service_id"), rs.getString("service_name"), rs.getString("service_code"), rs.getString("description"), rs.getString("price"),
                        rs.getString("promotion_info"), rs.getString("start_date"), rs.getString("end_date"), rs.getString("status"), rs.getString("created_by_name"), // đổi sang name

                        rs.getString("updated_by_name"))); // đổi sang name));

            }
        } catch (Exception e) {
        }

        return list;
    }

    public void updateService(String serviceName, String description, String price, String status, String startDate, String endDate, String service_id) throws SQLException {
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

    public void addService(String serviceName, String serviceCode, String description, String price, String status, String startDate, String endDate, int id) throws SQLException {
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

    public int getIdService(String serviceCode) throws SQLException {
        String query = "SELECT service_id FROM Services WHERE service_code = ?";

        try (Connection conn = db.getConnection();
             PreparedStatement stm = conn.prepareStatement(query)) {

            stm.setString(1, serviceCode);

            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("service_id"); // chỉ lấy id thôi
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return -1; // hoặc 0 nếu muốn mặc định là không tìm thấy
    }

    public void insertComboItems(int serviceId, List<Integer> menuItemIds) throws SQLException {
        String query = "INSERT INTO service_menu_items (service_id, item_id) VALUES (?, ?)";

        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            int i = 0;
            while (i < menuItemIds.size()) {
                ps.setInt(1, serviceId);
                ps.setInt(2, menuItemIds.get(i));
                ps.addBatch();
                i++;
            }

            ps.executeBatch();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Integer> getMenuItemByServiceId(int service_id) throws SQLException {
        List<Integer> list = new ArrayList<>();


        String query = " SELECT * FROM service_menu_items where service_id = ? ";

        try (Connection conn = db.getConnection();
             PreparedStatement stm = conn.prepareStatement(query);) {
            stm.setInt(1, service_id);
            try (ResultSet rs = stm.executeQuery();) {

                while (rs.next()) {
                    list.add(
                            rs.getInt("item_id"
                            ));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public void addItemToCombo(String serviceId, int itemId) {
        String query = " INSERT INTO service_menu_items (service_id, item_id) VALUES (?, ?) ";
        try (Connection conn = db.getConnection();
             PreparedStatement stm = conn.prepareStatement(query);) {
            stm.setString(1, serviceId);
            stm.setInt(2, itemId);
            stm.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }


    }
    public void deleteItemCombo(String serviceId, int itemId) {
        String query = " DELETE FROM service_menu_items \n" +
                "WHERE service_id = ? AND item_id = ?; ";
        try (Connection conn = db.getConnection();
             PreparedStatement stm = conn.prepareStatement(query);) {
            stm.setString(1, serviceId);
            stm.setInt(2, itemId);
            stm.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<MenuItem> getMenuItemsExcluding(List<Integer> excludedIds) throws SQLException {
        String sql = "SELECT * FROM menu_items";

        if (!excludedIds.isEmpty()) {
            String placeholders = excludedIds.stream()
                    .map(x -> "?")
                    .collect(Collectors.joining(","));
            sql += " WHERE item_id NOT IN (" + placeholders + ")";
        }

        try (Connection conn = db.getConnection();
             PreparedStatement stm = conn.prepareStatement(sql);) {

            for (int i = 0; i < excludedIds.size(); i++) {
                stm.setInt(i + 1, excludedIds.get(i));
            }

            ResultSet rs = stm.executeQuery();
            List<MenuItem> result = new ArrayList<>();
            while (rs.next()) {
                result.add(new MenuItem(
                        rs.getInt("item_id"),
                        rs.getString("item_name")

                ));
            }
            return result;
        }
    }

    public List<Service> getServicesByPageShowList(int offset, int limit) throws SQLException {
        List<Service> list = new ArrayList<>();


        String query = "SELECT * FROM Services ORDER BY service_id DESC limit ?,  ?";

        try (Connection conn = db.getConnection();
             PreparedStatement stm = conn.prepareStatement(query);) {

            stm.setInt(1, offset);
            stm.setInt(2, limit);
            try (ResultSet rs = stm.executeQuery();) {

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


        try (Connection conn = db.getConnection();
             PreparedStatement stm = conn.prepareStatement(sql);
        ) {
            stm.setInt(1, offset);
            stm.setInt(2, limit);
            try (ResultSet rs = stm.executeQuery();) {

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

            }
        }


        return list;
    }

    public int getTotalServiceCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM services ";

        try (Connection conn = db.getConnection();
             PreparedStatement stm = conn.prepareStatement(sql);
             ResultSet rs = stm.executeQuery();) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }


        return 0;
    }

    // Get active services for customer booking
    public List<Service> getActiveServices() throws SQLException {
        List<Service> list = new ArrayList<>();
        String query = "SELECT service_id, service_name, service_code, description, price, " +
                "promotion_info, start_date, end_date, status " +
                "FROM Services " +
                "WHERE UPPER(status) = 'ACTIVE' " +
                "ORDER BY service_name ASC";

        try (Connection conn = db.getConnection();
             PreparedStatement stm = conn.prepareStatement(query);
             ResultSet rs = stm.executeQuery()) {

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

    // Get service by ID
    public Service getServiceById(int serviceId) throws SQLException {
        String query = "SELECT service_id, service_name, service_code, description, price, " +
                "promotion_info, start_date, end_date, status " +
                "FROM Services " +
                "WHERE service_id = ?";

        try (Connection conn = db.getConnection();
             PreparedStatement stm = conn.prepareStatement(query)) {

            stm.setInt(1, serviceId);
            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    return new Service(
                            rs.getInt("service_id"),
                            rs.getString("service_name"),
                            rs.getString("service_code"),
                            rs.getString("description"),
                            rs.getString("price"),
                            rs.getString("promotion_info"),
                            rs.getString("start_date"),
                            rs.getString("end_date"),
                            rs.getString("status")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }


    public List<MenuItem> getMenuItemsByService(int id) throws SQLException {
        List<MenuItem> list = new ArrayList<>();
        String sql = " SELECT\n" +
                "m.item_id, m.item_name\n" +
                "        FROM\n" +
                "service_menu_items smi \n" +
                " JOIN\n" +
                "menu_items m ON smi.item_id = m.item_id\n" +
                "        WHERE\n" +
                "smi.service_id = ? ";

        try (Connection conn = db.getConnection();
             PreparedStatement stm = conn.prepareStatement(sql);
        ) {
            stm.setInt(1, id);

            try (ResultSet rs = stm.executeQuery();) {
                while (rs.next()) {
                    list.add(new MenuItem(
                            rs.getInt("item_id"),
                            rs.getString("item_name")

                    ));
                }
            }
        }


        return list;
    }



}
