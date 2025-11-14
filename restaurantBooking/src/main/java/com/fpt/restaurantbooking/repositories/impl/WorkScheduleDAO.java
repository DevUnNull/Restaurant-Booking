package com.fpt.restaurantbooking.repositories.impl;

import com.fpt.restaurantbooking.models.User;
import com.fpt.restaurantbooking.models.WorkSchedule;
import com.fpt.restaurantbooking.utils.DatabaseUtil;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class WorkScheduleDAO {
    DatabaseUtil db = new DatabaseUtil();

    // Lấy toàn bộ lịch làm việc
    public List<WorkSchedule> getAllWorkSchedules() {
        List<WorkSchedule> list = new ArrayList<>();
        String sql = """
            SELECT ws.schedule_id, ws.user_id, u.full_name,
                   ws.work_date, ws.shift, ws.start_time, ws.end_time,
                   ws.work_position, ws.notes, ws.status
            FROM work_schedules ws
            JOIN users u ON ws.user_id = u.user_id
        """;

        try (Connection conn = db.getConnection();
             PreparedStatement stm = conn.prepareStatement(sql);
             ResultSet rs = stm.executeQuery()) {

            while (rs.next()) {
                list.add(mapResultSetToWorkSchedule(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Map ResultSet sang WorkSchedule
    private WorkSchedule mapResultSetToWorkSchedule(ResultSet rs) throws SQLException {
        User user = new User(
                rs.getInt("user_id"),
                rs.getString("full_name")
        );

        return new WorkSchedule(
                rs.getInt("schedule_id"),
                user,
                rs.getDate("work_date").toLocalDate(),
                rs.getString("shift"),
                rs.getTime("start_time").toLocalTime(),
                rs.getTime("end_time").toLocalTime(),
                rs.getString("work_position"),
                rs.getString("notes"),
                rs.getString("status")
        );
    }

    // Thêm lịch làm việc
    public boolean addWorkSchedule(WorkSchedule ws) {
        String sql = """
            INSERT INTO work_schedules (user_id, work_date, shift, start_time, end_time, work_position, notes)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        """;

        try (Connection conn = db.getConnection();
             PreparedStatement stm = conn.prepareStatement(sql)) {

            stm.setInt(1, ws.getUser().getUserId());
            stm.setDate(2, Date.valueOf(ws.getWorkDate()));
            stm.setString(3, ws.getShift());
            stm.setTime(4, Time.valueOf(ws.getStartTime()));
            stm.setTime(5, Time.valueOf(ws.getEndTime()));
            stm.setString(6, ws.getWorkPosition());
            stm.setString(7, ws.getNotes());

            return stm.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Cập nhật trạng thái
    public void updateStatus(int scheduleId, String status) {
        String sql = "UPDATE work_schedules SET status = ? WHERE schedule_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            stmt.setInt(2, scheduleId);
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Cập nhật thông tin lịch làm việc
    public boolean updateWorkSchedule(WorkSchedule ws) {
        String sql = """
            UPDATE work_schedules
            SET user_id = ?, work_date = ?, shift = ?, start_time = ?, end_time = ?,
                work_position = ?, notes = ?
            WHERE schedule_id = ?
        """;

        try (Connection conn = db.getConnection();
             PreparedStatement stm = conn.prepareStatement(sql)) {

            stm.setInt(1, ws.getUser().getUserId());
            stm.setDate(2, Date.valueOf(ws.getWorkDate()));
            stm.setString(3, ws.getShift());
            stm.setTime(4, Time.valueOf(ws.getStartTime()));
            stm.setTime(5, Time.valueOf(ws.getEndTime()));
            stm.setString(6, ws.getWorkPosition());
            stm.setString(7, ws.getNotes());
            stm.setInt(8, ws.getScheduleId());

            return stm.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Lấy lịch làm việc theo ID
    public WorkSchedule getWorkScheduleById(int scheduleId) {
        String sql = """
            SELECT ws.schedule_id, ws.user_id, ws.work_date, ws.shift, ws.start_time, ws.end_time,
                   ws.work_position, ws.notes, ws.status, u.full_name
            FROM work_schedules ws
            JOIN users u ON ws.user_id = u.user_id
            WHERE ws.schedule_id = ?
        """;

        try (Connection conn = db.getConnection();
             PreparedStatement stm = conn.prepareStatement(sql)) {

            stm.setInt(1, scheduleId);

            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    User user = new User(
                            rs.getInt("user_id"),
                            rs.getString("full_name")
                    );

                    return new WorkSchedule(
                            rs.getInt("schedule_id"),
                            user,
                            rs.getDate("work_date").toLocalDate(),
                            rs.getString("shift"),
                            rs.getTime("start_time").toLocalTime(),
                            rs.getTime("end_time").toLocalTime(),
                            rs.getString("work_position"),
                            rs.getString("notes"),
                            rs.getString("status")
                    );
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    // Lấy tất cả lịch (giống getAllWorkSchedules)
    public List<WorkSchedule> getAllSchedules() {
        List<WorkSchedule> list = new ArrayList<>();
        String sql = """
            SELECT ws.schedule_id, ws.work_date, ws.shift, ws.start_time, ws.end_time,
                   ws.work_position, ws.notes, ws.status, ws.user_id, u.full_name
            FROM work_schedules ws
            JOIN users u ON ws.user_id = u.user_id
        """;

        try (Connection con = db.getConnection();
             PreparedStatement stm = con.prepareStatement(sql);
             ResultSet rs = stm.executeQuery()) {

            while (rs.next()) {
                list.add(mapResultSetToWorkSchedule(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // Lấy lịch theo tuần
    public List<WorkSchedule> getSchedulesByWeek(LocalDate startDate, LocalDate endDate) {
        List<WorkSchedule> list = new ArrayList<>();

        String sql = """
            SELECT ws.*, u.full_name
            FROM work_schedules ws
            JOIN users u ON ws.user_id = u.user_id
            WHERE ws.work_date BETWEEN ? AND ?
            ORDER BY ws.work_date, ws.start_time
        """;

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setDate(1, Date.valueOf(startDate));
            ps.setDate(2, Date.valueOf(endDate));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToWorkSchedule(rs));
                }
            }

            System.out.println("DEBUG: fetched " + list.size() + " schedules between " + startDate + " and " + endDate);

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // Lấy lịch theo ngày
    public List<WorkSchedule> getSchedulesByDate(LocalDate date) {
        List<WorkSchedule> list = new ArrayList<>();

        String sql = """
            SELECT ws.*, u.full_name
            FROM work_schedules ws
            JOIN users u ON ws.user_id = u.user_id
            WHERE ws.work_date = ?
            ORDER BY ws.start_time
        """;

        try (Connection connection = db.getConnection();
             PreparedStatement stm = connection.prepareStatement(sql)) {

            stm.setDate(1, Date.valueOf(date));

            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToWorkSchedule(rs));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
}
