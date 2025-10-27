package com.fpt.restaurantbooking.repositories.impl;

import com.fpt.restaurantbooking.models.User;
import com.fpt.restaurantbooking.models.WorkSchedule;
import com.fpt.restaurantbooking.utils.DatabaseUtil;
import java.sql.*;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

public class WorkScheduleDAO {
    PreparedStatement stm;
    ResultSet rs;
    DatabaseUtil db = new DatabaseUtil();

    public List<WorkSchedule> getAllWorkSchedules() {
        List<WorkSchedule> list = new ArrayList<>();
        String sql = "SELECT ws.schedule_id, ws.user_id, u.full_name, " +
                "ws.work_date, ws.shift, ws.start_time, ws.end_time, " +
                "ws.work_position, ws.notes " +
                "FROM work_schedules ws " +
                "JOIN users u ON ws.user_id = u.user_id";

        try {
            Connection conn = db.getConnection();
            stm = conn.prepareStatement(sql);
            rs = stm.executeQuery();

            while (rs.next()) {
                WorkSchedule ws = mapResultSetToWorkSchedule(rs);
                list.add(ws);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private WorkSchedule mapResultSetToWorkSchedule(ResultSet rs) throws SQLException {
        // Tạo đối tượng User
        User user = new User(
                rs.getInt("user_id"),
                rs.getString("full_name")
        );

        // Trả về WorkSchedule thông qua constructor của bạn
        return new WorkSchedule(
                rs.getInt("schedule_id"),
                user,
                rs.getDate("work_date").toLocalDate(),
                rs.getString("shift"),
                rs.getTime("start_time").toLocalTime(),
                rs.getTime("end_time").toLocalTime(),
                rs.getString("work_position"),
                rs.getString("notes")
        );
    }
}
