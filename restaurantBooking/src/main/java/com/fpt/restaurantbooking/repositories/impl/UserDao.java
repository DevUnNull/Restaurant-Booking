package com.fpt.restaurantbooking.repositories.impl;

import com.fpt.restaurantbooking.models.User;
import com.fpt.restaurantbooking.models.WorkSchedule;
import com.fpt.restaurantbooking.utils.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDao {
    PreparedStatement stm;
    ResultSet rs;
    DatabaseUtil db = new DatabaseUtil();

    public List<User> findAllStaff() {
        String sql = "SELECT * FROM users WHERE role_id = 2 AND status != 'DELETE'";
        List<User> users = new ArrayList<>();

        try (Connection conn = db.getConnection()) {
            stm = conn.prepareStatement(sql);
            rs = stm.executeQuery();

            while (rs.next()) {
                users.add(mapResultSetToStaff(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error finding all staff", e);
        }

        return users;
    }

    public List<User> searchEmployees(String search, String gender, String status) throws SQLException {
        List<User> users = new ArrayList<>();

        StringBuilder sql = new StringBuilder("SELECT * FROM users WHERE role_id = 2 AND status != 'DELETE'");

        // Ghép điều kiện
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (full_name LIKE ? OR user_id LIKE ?)");
        }
        if (gender != null && !gender.equalsIgnoreCase("all") && !gender.isEmpty()) {
            sql.append(" AND gender = ?");
        }
        if (status != null && !status.equalsIgnoreCase("all") && !status.isEmpty()) {
            sql.append(" AND status = ?");
        }

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int index = 1;
            if (search != null && !search.trim().isEmpty()) {
                ps.setString(index++, "%" + search + "%");
                ps.setString(index++, "%" + search + "%");
            }
            if (gender != null && !gender.equalsIgnoreCase("all") && !gender.isEmpty()) {
                ps.setString(index++, gender);
            }
            if (status != null && !status.equalsIgnoreCase("all") && !status.isEmpty()) {
                ps.setString(index++, status);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                users.add(mapResultSetToStaff(rs));
            }
        }

        return users;
    }
    public int countFilteredEmployees(String search, String gender, String status) {
        String sql = "SELECT COUNT(*) FROM users WHERE role_id = 2 AND status != 'DELETE'";
        if (search != null && !search.trim().isEmpty()) {
            sql += " AND (full_name LIKE ? OR user_id LIKE ?)";
        }
        if (gender != null && !gender.isEmpty()) {
            sql += " AND gender = ?";
        }
        if (status != null && !status.isEmpty()) {
            sql += " AND status = ?";
        }

        try (Connection conn = db.getConnection();
             PreparedStatement stm = conn.prepareStatement(sql)) {

            int index = 1;
            if (search != null && !search.trim().isEmpty()) {
                stm.setString(index++, "%" + search + "%");
                stm.setString(index++, "%" + search + "%");
            }
            if (gender != null && !gender.isEmpty()) {
                stm.setString(index++, gender);
            }
            if (status != null && !status.isEmpty()) {
                stm.setString(index++, status);
            }

            ResultSet rs = stm.executeQuery();
            if (rs.next()) return rs.getInt(1);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    public List<User> getFilteredEmployees(String search, String gender, String status, int limit, int offset) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role_id = 2 AND status != 'DELETE'";

        if (search != null && !search.trim().isEmpty()) {
            sql += " AND (full_name LIKE ? OR user_id LIKE ?)";
        }
        if (gender != null && !gender.isEmpty()) {
            sql += " AND gender = ?";
        }
        if (status != null && !status.isEmpty()) {
            sql += " AND status = ?";
        }

        sql += " ORDER BY user_id LIMIT ? OFFSET ?";

        try (Connection conn = db.getConnection();
             PreparedStatement stm = conn.prepareStatement(sql)) {

            int index = 1;
            if (search != null && !search.trim().isEmpty()) {
                stm.setString(index++, "%" + search + "%");
                stm.setString(index++, "%" + search + "%");
            }
            if (gender != null && !gender.isEmpty()) {
                stm.setString(index++, gender);
            }
            if (status != null && !status.isEmpty()) {
                stm.setString(index++, status);
            }

            stm.setInt(index++, limit);
            stm.setInt(index, offset);

            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToStaff(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    private User mapResultSetToStaff(ResultSet rs) throws SQLException {
        User user = new User(
                rs.getInt("user_id"),
                rs.getInt("role_id"),
                rs.getString("full_name"),
                rs.getString("gender"),
                rs.getString("email"),
                rs.getString("phone_number"),
                rs.getString("status")
        );

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            user.setCreatedAt(createdAt.toLocalDateTime());
        }

        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            user.setUpdatedAt(updatedAt.toLocalDateTime());
        }

        return user;
    }

    public boolean updateUser(User user) {
        String sql = "UPDATE users SET full_name = ?, gender = ?, email = ?, phone_number = ?, status = ?, updated_at = CURRENT_TIMESTAMP WHERE user_id = ?";

        try (Connection con = db.getConnection();
             PreparedStatement stm = con.prepareStatement(sql)) {

            stm.setString(1, user.getFullName());
            stm.setString(2, user.getGender());
            stm.setString(3, user.getEmail());
            stm.setString(4, user.getPhoneNumber());
            stm.setString(5, user.getStatus());
            stm.setInt(6, user.getUserId());

            int rows = stm.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean softDeleteUser(int userId) {
        String sql = "UPDATE users SET status = 'DELETE', updated_at = CURRENT_TIMESTAMP WHERE user_id = ?";

        try (Connection con = db.getConnection();
             PreparedStatement stm = con.prepareStatement(sql)) {

            stm.setInt(1, userId);
            int rows = stm.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public void updateRole(int userId, int newRoleId) throws SQLException {
        String sql = "UPDATE Users SET role_id = ? WHERE user_id = ?";
        try (Connection conn = db.getConnection()) {
            stm = conn.prepareStatement(sql);
            stm.setInt(1, newRoleId);
            stm.setInt(2, userId);
            stm.executeUpdate();
        }
    }

}
