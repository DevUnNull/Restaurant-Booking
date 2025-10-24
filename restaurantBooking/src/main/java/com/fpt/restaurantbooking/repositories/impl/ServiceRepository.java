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
public class ServiceRepository   {

    PreparedStatement stm;
    ResultSet rs;
    DatabaseUtil db = new DatabaseUtil();

    public List<Service> getService() throws SQLException {
        List<Service> list = new ArrayList<>();
        String query = "select * from Services";
        try (Connection conn = db.getConnection();
             PreparedStatement stm = conn.prepareStatement(query);
             ResultSet rs = stm.executeQuery();){

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
        try(Connection conn = db.getConnection();
            PreparedStatement stm = conn.prepareStatement(query);
            ResultSet rs = stm.executeQuery();) {


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
    public List<Service> getServicesByPageShowList(int offset, int limit) throws SQLException {
    List<Service> list = new ArrayList<>();
   

    String query = "SELECT * FROM Services ORDER BY service_id DESC limit ?,  ?";
    try(Connection conn = db.getConnection();
        PreparedStatement stm = conn.prepareStatement(query);) {

        stm.setInt(1, offset);
        stm.setInt(2, limit);
       try( ResultSet rs = stm.executeQuery();){
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

   try(Connection conn = db.getConnection();
       PreparedStatement stm = conn.prepareStatement(sql);
        ){
       stm.setInt(1, offset);
       stm.setInt(2, limit);
       try(ResultSet rs = stm.executeQuery();){
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

    try(Connection conn = db.getConnection();
        PreparedStatement stm = conn.prepareStatement(sql);
        ResultSet rs = stm.executeQuery();){
        if (rs.next()) {
            return rs.getInt(1);
        }
    }




    return 0;
}


}
