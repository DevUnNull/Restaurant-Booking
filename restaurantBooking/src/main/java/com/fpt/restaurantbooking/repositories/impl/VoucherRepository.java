package com.fpt.restaurantbooking.repositories.impl;

import com.fpt.restaurantbooking.models.Promotions;
import com.fpt.restaurantbooking.models.User;
import com.fpt.restaurantbooking.utils.DatabaseUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class VoucherRepository {


    PreparedStatement stm;
    ResultSet rs;
    DatabaseUtil db = new DatabaseUtil();

    public List<Promotions> getVouchersByPage(int levelId, int start, int end) throws SQLException {
        List<Promotions> promotions = new ArrayList<Promotions>();
        String sql = " SELECT * FROM promotions \n" +
                "WHERE promotion_level_id = ? \n" +
                "ORDER BY promotion_id DESC \n" +
                "LIMIT ?, ?  ";

        try (Connection conn = db.getConnection();
             PreparedStatement stm = conn.prepareStatement(sql);) {
            stm.setInt(1, levelId);   // truyền levelId vào câu query
            stm.setInt(2, start);   // truyền levelId vào câu query
            stm.setInt(3, end);   // truyền levelId vào câu query
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    promotions.add(new Promotions(rs.getInt("promotion_id"), rs.getString("promotion_name"),
                            rs.getString("description"),
                            rs.getDouble("discount_percentage"),
                            rs.getDouble("discount_amount"),
                            rs.getString("start_date"),
                            rs.getString("end_date"),
                            rs.getString("status"),
                            rs.getString("created_by"),
                            rs.getString("updated_by"),
                            rs.getString("created_at"),
                            rs.getString("updated_at"),
                            rs.getInt("promotion_level_id")));
                }
            }
        }


        return promotions;
    }

    public List<Promotions> getAllPromotions(int levelId) throws SQLException {
        List<Promotions> promotions = new ArrayList<Promotions>();
        String sql = " select * from promotions where promotion_level_id= ?  ";

        try (Connection conn = db.getConnection();
             PreparedStatement stm = conn.prepareStatement(sql);) {
            stm.setInt(1, levelId);
            try (ResultSet rs = stm.executeQuery();) {
                while (rs.next()) {
                    promotions.add(new Promotions(rs.getInt("promotion_id"), rs.getString("promotion_name"),
                            rs.getString("description"),
                            rs.getDouble("discount_percentage"),
                            rs.getDouble("discount_amount"),
                            rs.getString("start_date"),
                            rs.getString("end_date"),
                            rs.getString("status"),
                            rs.getString("created_by"),
                            rs.getString("updated_by"),
                            rs.getString("created_at"),
                            rs.getString("updated_at"),
                            rs.getInt("promotion_level_id")));
                }
            }

        }

        // truyền levelId vào câu query


        return promotions;
    }

    public Promotions getIdWithUpdate(int id) throws SQLException {
        Promotions promotion = null;
        String sql = " select * from promotions where promotion_id = ?  ";
        try (Connection conn = db.getConnection();
             PreparedStatement stm = conn.prepareStatement(sql);) {
            stm.setInt(1, id);
            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    promotion = new Promotions(
                            rs.getInt("promotion_id"),
                            rs.getString("promotion_name"),
                            rs.getString("description"),
                            rs.getDouble("discount_percentage"),
                            rs.getDouble("discount_amount"),
                            rs.getString("start_date"),
                            rs.getString("end_date"),
                            rs.getString("status"),
                            rs.getString("created_by"),
                            rs.getString("updated_by"),
                            rs.getString("created_at"),
                            rs.getString("updated_at"),
                            rs.getInt("promotion_level_id")
                    );
                }
            }

        }


        return promotion;
    }

    public void UpdatePromotion(String id, String name, String des, String discount_p, String start_date, String end_Date, String updated_by,String promotion_level_id) throws SQLException {
        String sql = "UPDATE promotions \n " +
                " SET \n " +
                "    promotion_name = ?,\n " +
                "    description = ?,\n " +
                "    discount_percentage = ?,\n " +
                "    start_date = ?,\n " +
                "    end_date = ?\n , " +
                " updated_by = ? ,\n  " +
                " promotion_level_id = ? " +
                " WHERE promotion_id = ? ";
        try (Connection conn = db.getConnection();
             PreparedStatement stm = conn.prepareStatement(sql);) {

            stm.setString(1, name);
            stm.setString(2, des);
            stm.setString(3, discount_p);
            stm.setString(4, start_date);
            stm.setString(5, end_Date);
            stm.setString(6, updated_by);
            stm.setString(7, promotion_level_id);
            stm.setString(8, id);
            stm.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }


    }

    public void DeletePromotion(String id) throws SQLException {
        String sql = " DELETE FROM promotions \n" +
                " WHERE promotion_id = ? ";

        try (Connection conn = db.getConnection();
             PreparedStatement stm = conn.prepareStatement(sql);
        ) {

            stm.setString(1, id);

            stm.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }


    }

    public void addVoucher(String promotionName, String description, String discount_percentage, String discount_amount, String start_date, String end_date, String status, String promotion_level_id, String created_by) throws SQLException {
        String sql = " INSERT INTO promotions  \n" +
                " ( promotion_name, description, discount_percentage, discount_amount, start_date, end_date, status,created_by,   promotion_level_id)\n" +
                " VALUES (?, ?, ?, ?, ?, ?, ?, ?,?)  ";
        try (Connection con = db.getConnection(); PreparedStatement stm = con.prepareStatement(sql)) {

            stm.setString(1, promotionName);
            stm.setString(2, description);

            stm.setString(3, discount_percentage);
            stm.setString(4, discount_amount);
            stm.setString(5, start_date);
            stm.setString(6, end_date);
            stm.setString(7, status);
            stm.setString(8, created_by);

            stm.setString(9, promotion_level_id);

            stm.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }

    }

    public List<User> getAllUsertoPromotion_level_id() throws SQLException {
        List<User> userList = new ArrayList<User>();
        String sql = " select * from users where role_id = 3 ";

        try (Connection conn = db.getConnection();
             PreparedStatement stm = conn.prepareStatement(sql);
             ResultSet rs = stm.executeQuery();) {


            while (rs.next()) {
                userList.add(new User(rs.getInt("user_id"), rs.getInt("role_id"),
                        rs.getString("full_name"),
                        rs.getString("email"),
                        rs.getString("phone_number"),
                        rs.getString("promotion_level_id"),rs.getDate("date_of_birth").toLocalDate(), rs.getString("gender")));

            }

        }

        return userList;
    }
    public int getAllUsertoPromotion_level_idd() throws SQLException {
        int count = 0;
        String sql = " SELECT COUNT(*) FROM Users where role_id = 3 ";

        try (Connection conn = db.getConnection();
             PreparedStatement stm = conn.prepareStatement(sql);
             ResultSet rs = stm.executeQuery();) {
            if (rs.next()) count = rs.getInt(1);



        }

        return count;
    }
    public List<User> getUsersByPagee(int start, int total) {
        List<User> userList = new ArrayList<>();
        String sql = "SELECT * FROM Users where role_id = 3  LIMIT ?, ?";
        try(Connection conn = db.getConnection();
            PreparedStatement stm = conn.prepareStatement(sql);
            ) {


            stm.setInt(1, start);
            stm.setInt(2, total);
            try(ResultSet rs = stm.executeQuery();){
                while (rs.next()) {
                    userList.add(new User(rs.getInt("user_id"), rs.getInt("role_id"),
                            rs.getString("full_name"),
                            rs.getString("email"),
                            rs.getString("phone_number"),
                            rs.getString("promotion_level_id"),rs.getDate("date_of_birth").toLocalDate(), rs.getString("gender")));

                }
            }


        } catch (Exception e) {
            e.printStackTrace();
        }
        return userList;
    }
}


