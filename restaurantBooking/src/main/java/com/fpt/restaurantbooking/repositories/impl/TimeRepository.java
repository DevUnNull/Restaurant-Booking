package com.fpt.restaurantbooking.repositories.impl;

import com.fpt.restaurantbooking.models.Promotions;
import com.fpt.restaurantbooking.models.TimeSlot;
import com.fpt.restaurantbooking.utils.DatabaseUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class TimeRepository {
    DatabaseUtil db = new DatabaseUtil();


    public List<TimeSlot> getAll() throws SQLException {
        List<TimeSlot> list = new ArrayList<>();
        String sql = " SELECT applicable_date, category_id FROM Time_Slots " ;
        try (Connection conn = db.getConnection();
             PreparedStatement stm = conn.prepareStatement(sql);
             ResultSet rs = stm.executeQuery() ) {
            while (rs.next()) {
                list.add(new TimeSlot(rs.getDate("applicable_date").toLocalDate(), rs.getInt("category_id")));
            }

        }catch (SQLException e){
            e.printStackTrace();
        }
        return list;
    }
    public TimeSlot getDate(int year, int month, int day) throws SQLException {
        TimeSlot timeSlot = null;
        String sql = " SELECT * \n" +
                "                FROM Time_Slots \n" +
                "                WHERE YEAR(applicable_date) = ? AND MONTH(applicable_date) = ? AND DAY(applicable_date) = ? \n" ;
        try (Connection conn = db.getConnection();
             PreparedStatement stm = conn.prepareStatement(sql);)  {
            stm.setInt(1, year);
            stm.setInt(2, month);
            stm.setInt(3, day);
            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                      timeSlot = new TimeSlot(
                            rs.getInt("slot_id"),
                              rs.getDate("applicable_date").toLocalDate(),
                            rs.getInt("category_id"),
                            rs.getString("morning_start_time"),
                            rs.getString("morning_end_time"),
                            rs.getString("afternoon_start_time"),
                            rs.getString("evening_start_time"),
                            rs.getString("afternoon_end_time"),
                            rs.getString("evening_end_time"),
                            rs.getString("slot_description")

                    );
                }
            }
        }catch (SQLException e){
            e.printStackTrace();
        }
        return  timeSlot;
    }
    public List<TimeSlot> getAllTimeSlot() throws SQLException {
        List<TimeSlot> list = new ArrayList<>();
        String sql = "SELECT \n" +
                "    ts.slot_id,\n" +
                "    ts.applicable_date,\n" +
                "    ts.updated_at,\n" +
                "    ts.updated_by,\n" +
                "    u.full_name AS updated_by_name,\n" +   // 👈 Lấy tên người cập nhật
                "    ts.category_id,\n" +
                "    dc.name AS category_name,\n" +
                "    ts.slot_description,\n" +
                "    ts.morning_start_time,\n" +
                "    ts.morning_end_time,\n" +
                "    ts.afternoon_start_time,\n" +
                "    ts.afternoon_end_time,\n" +
                "    ts.evening_start_time,\n" +
                "    ts.evening_end_time\n" +
                "FROM time_slots ts\n" +
                "JOIN day_category dc ON ts.category_id = dc.id\n" +
                "LEFT JOIN users u ON ts.updated_by = u.user_id;";
        try (Connection conn = db.getConnection();
             PreparedStatement stm = conn.prepareStatement(sql);
             ResultSet rs = stm.executeQuery() ) {
            while (rs.next()) {
                list.add(new TimeSlot(rs.getInt("slot_id"),
                        rs.getDate("applicable_date").toLocalDate(),
                        rs.getInt("category_id"),
                        rs.getString("morning_start_time"),
                        rs.getString("morning_end_time"),
                        rs.getString("afternoon_start_time"),
                        rs.getString("evening_start_time"),
                        rs.getString("afternoon_end_time"),
                        rs.getString("evening_end_time"),
                        rs.getString("slot_description"), rs.getString("updated_at"), rs.getString("updated_by"),
                        rs.getString("category_name"), rs.getString("updated_by_name")));
            }

        }catch (SQLException e){
            e.printStackTrace();
        }
        return list;
    }

    public void insertBlockTime(String mysqlDate , String description)throws SQLException {
        String sql = " INSERT INTO time_slots \n" +
                "(applicable_date,updated_at,  category_id, slot_description)\n" +
                "VALUES\n" +
                "(?,NOW(), ?, ?)" ;
        try (Connection conn = db.getConnection();
             PreparedStatement stm = conn.prepareStatement(sql);) {

            stm.setString(1, mysqlDate);
            stm.setString(2, "3");
            stm.setString(3, description);

            stm.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }


    }
    public void insertEditTime(String mysqlDate , String description, String morning1, String morning2, String afternoon1, String afternoon2, String evening1, String evening2)throws SQLException {
        String sql = " INSERT INTO time_slots\n" +
                "        (applicable_date, category_id, slot_description,\n" +
                "         morning_start_time, morning_end_time,\n" +
                "         afternoon_start_time, afternoon_end_time,\n" +
                "         evening_start_time, evening_end_time)\n" +
                "VALUES\n" +
                "        (?, 2, ?,\n" +
                "                 ?, ?,\n" +
                "                 ?, ?,\n" +
                "                ?, ?) ; " ;
        try (Connection conn = db.getConnection();
             PreparedStatement stm = conn.prepareStatement(sql);) {

            stm.setString(1, mysqlDate);
            stm.setString(2, description);
            stm.setString(3, morning1);
            stm.setString(4, morning2);
            stm.setString(5, afternoon1);
            stm.setString(6, afternoon2);
            stm.setString(7, evening1);
            stm.setString(8, evening2);

            stm.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }


    }
    public TimeSlot getTime(String mysqlDate )throws SQLException {
        TimeSlot timeSlot = null;
        String sql = " select * from time_slots where applicable_date = ? " ;
        try (Connection conn = db.getConnection();
             PreparedStatement stm = conn.prepareStatement(sql);) {

            stm.setString(1, mysqlDate);


            try(ResultSet rs = stm.executeQuery();){
                if (rs.next()) {
                    timeSlot = new TimeSlot(
                            rs.getInt("slot_id"),
                            rs.getDate("applicable_date").toLocalDate(),
                            rs.getInt("category_id"),
                            rs.getString("morning_start_time"),
                            rs.getString("morning_end_time"),
                            rs.getString("afternoon_start_time"),
                            rs.getString("evening_start_time"),
                            rs.getString("afternoon_end_time"),
                            rs.getString("evening_end_time"),
                            rs.getString("slot_description")

                    );
                }
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

return timeSlot;
    }
}
