package com.fpt.restaurantbooking.repositories.impl;

import com.fpt.restaurantbooking.models.JobRequest;
import com.fpt.restaurantbooking.utils.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class JobRequestDAO {
    PreparedStatement stm;
    ResultSet rs;
    DatabaseUtil db = new DatabaseUtil();

    // Thêm đơn xin việc mới
    public void insertJobRequest(int userId) throws SQLException {
        String sql = "INSERT INTO Job_Requests (user_id) VALUES (?)";
        try (Connection conn = db.getConnection()) {
            stm = conn.prepareStatement(sql);
            stm.setInt(1, userId);
            stm.executeUpdate();
        }
    }

    // Lấy danh sách đơn xin việc (cho manager)
    public List<JobRequest> getAllRequests() throws SQLException {
        List<JobRequest> list = new ArrayList<>();
        String sql = "SELECT * FROM Job_Requests ORDER BY request_date DESC";
        try (Connection conn = db.getConnection()) {
            stm = conn.prepareStatement(sql);
            rs = stm.executeQuery();
            while (rs.next()) {
                JobRequest jr = new JobRequest();
                jr.setRequestId(rs.getInt("request_id"));
                jr.setUserId(rs.getInt("user_id"));
                jr.setRequestDate(rs.getTimestamp("request_date"));
                jr.setStatus(rs.getString("status"));
                jr.setReviewedBy((Integer) rs.getObject("reviewed_by"));
                jr.setReviewedDate(rs.getTimestamp("reviewed_date"));
                jr.setNotes(rs.getString("notes"));
                list.add(jr);
            }
        }
        return list;
    }

    // Cập nhật trạng thái (manager duyệt hoặc từ chối)
    public void updateStatus(int requestId, String status, int managerId, String notes) throws SQLException {
        String sql = "UPDATE Job_Requests SET status = ?, reviewed_by = ?, reviewed_date = NOW(), notes = ? WHERE request_id = ?";
        try (Connection conn = db.getConnection()) {
            stm = conn.prepareStatement(sql);
            stm.setString(1, status);
            stm.setInt(2, managerId);
            stm.setString(3, notes);
            stm.setInt(4, requestId);
            stm.executeUpdate();
        }
    }
}

