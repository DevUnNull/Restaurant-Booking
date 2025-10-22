package com.fpt.restaurantbooking.repositories.impl;

import com.fpt.restaurantbooking.models.WorkSchedule;
import com.fpt.restaurantbooking.utils.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.time.LocalDate;
import java.time.LocalTime;

public class WorkScheduleRepositoryImpl {

    PreparedStatement stm;
    ResultSet rs;
    DatabaseUtil db = new DatabaseUtil();

    /**
     * Lấy tất cả lịch làm việc cùng tên nhân viên
     */
    public List<WorkSchedule> findAll() {
        List<WorkSchedule> list = new ArrayList<>();
        String sql = """
            SELECT ws.*, u.full_name AS employee_name
            FROM Work_Schedules ws
            JOIN Users u ON ws.user_id = u.user_id
            ORDER BY ws.work_date DESC
        """;

        try (Connection con = db.getConnection()) {
            stm = con.prepareStatement(sql);
            rs = stm.executeQuery();

            while (rs.next()) {
                WorkSchedule w = new WorkSchedule();
                w.setScheduleId(rs.getInt("schedule_id"));
                w.setUserId(rs.getInt("user_id"));
                Date workDate = rs.getDate("work_date");
                if (workDate != null) w.setWorkDate(workDate.toLocalDate());

                w.setShift(rs.getString("shift"));

                Time startTime = rs.getTime("start_time");
                if (startTime != null) w.setStartTime(startTime.toLocalTime());

                Time endTime = rs.getTime("end_time");
                if (endTime != null) w.setEndTime(endTime.toLocalTime());

                w.setWorkPosition(rs.getString("work_position"));
                w.setNotes(rs.getString("notes"));
                w.setStatus(rs.getString("status"));
                w.setAssignedBy(rs.getInt("assigned_by"));
                w.setEmployeeName(rs.getString("employee_name"));

                list.add(w);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Thêm mới lịch làm việc
     */
    public boolean insert(WorkSchedule w) {
        String sql = """
            INSERT INTO Work_Schedules (user_id, work_date, shift, start_time, end_time, work_position, notes, status, assigned_by)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        """;

        try (Connection con = db.getConnection()) {
            stm = con.prepareStatement(sql);
            stm.setInt(1, w.getUserId());
            stm.setDate(2, Date.valueOf(w.getWorkDate()));
            stm.setString(3, w.getShift());
            stm.setTime(4, Time.valueOf(w.getStartTime()));
            stm.setTime(5, Time.valueOf(w.getEndTime()));
            stm.setString(6, w.getWorkPosition());
            stm.setString(7, w.getNotes());
            stm.setString(8, w.getStatus());
            stm.setInt(9, w.getAssignedBy());

            return stm.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
