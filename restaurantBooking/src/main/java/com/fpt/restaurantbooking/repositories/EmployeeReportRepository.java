package com.fpt.restaurantbooking.repositories;

import com.fpt.restaurantbooking.utils.DatabaseUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.math.BigDecimal;
import java.math.RoundingMode;

public class EmployeeReportRepository {

    private final DatabaseUtil db = new DatabaseUtil();

    public EmployeeReportRepository() {
    }

    public int getTotalFilteredEmployees(String startDate, String endDate) throws SQLException {
        String subQuery = "SELECT U.user_id FROM Users U WHERE U.role_id = 2 AND U.status = 'ACTIVE' AND (EXISTS (SELECT 1 FROM Reservation_Staff_Assignments RSA JOIN Reservations R ON RSA.reservation_id = R.reservation_id WHERE RSA.staff_user_id = U.user_id AND R.status = 'COMPLETED' AND R.reservation_date BETWEEN ? AND ?) OR EXISTS (SELECT 1 FROM Work_Schedules WS WHERE WS.user_id = U.user_id AND WS.status = 'CONFIRMED' AND WS.work_date BETWEEN ? AND ?))";
        String countQuery = "SELECT COUNT(*) FROM (" + subQuery + ") AS FilteredStaff";
        int count = 0;
        try (Connection con = db.getConnection(); PreparedStatement stm = con.prepareStatement(countQuery)) {
            int index = 1;
            stm.setString(index++, startDate); stm.setString(index++, endDate);
            stm.setString(index++, startDate); stm.setString(index++, endDate);
            try (ResultSet rs = stm.executeQuery()) { if (rs.next()) count = rs.getInt(1); }
        } catch (SQLException e) { e.printStackTrace(); throw e; }
        return count;
    }

    public List<Map<String, Object>> getEmployeeOverviewData(String startDate, String endDate, String limitDate, int offset, int pageSize) throws SQLException {
        List<Map<String, Object>> employeeList = new ArrayList<>();
        String query = "SELECT U.user_id, U.full_name AS employee_name, U.status AS employee_status, COALESCE(Stat_Serves.total_serves, 0) AS total_serves, COALESCE(Stat_Shifts.total_shift_days, 0) AS total_shift_days, COALESCE(Stat_Shifts.total_working_minutes, 0) AS total_working_minutes FROM Users U LEFT JOIN (SELECT RSA.staff_user_id, COUNT(R.reservation_id) AS total_serves FROM Reservation_Staff_Assignments RSA JOIN Reservations R ON RSA.reservation_id = R.reservation_id WHERE R.status = 'COMPLETED' AND R.reservation_date BETWEEN ? AND ? GROUP BY RSA.staff_user_id) AS Stat_Serves ON U.user_id = Stat_Serves.staff_user_id LEFT JOIN (SELECT WS.user_id, COUNT(DISTINCT WS.work_date) AS total_shift_days, SUM(TIMESTAMPDIFF(MINUTE, WS.start_time, WS.end_time)) AS total_working_minutes FROM Work_Schedules WS WHERE WS.status = 'CONFIRMED' AND WS.work_date BETWEEN ? AND ? GROUP BY WS.user_id) AS Stat_Shifts ON U.user_id = Stat_Shifts.user_id WHERE U.role_id = 2 AND U.status = 'ACTIVE' AND (COALESCE(Stat_Serves.total_serves, 0) > 0 OR COALESCE(Stat_Shifts.total_shift_days, 0) > 0) ORDER BY total_serves DESC LIMIT ? OFFSET ?";
        try (Connection con = db.getConnection(); PreparedStatement stm = con.prepareStatement(query)) {
            int index = 1;
            stm.setString(index++, startDate); stm.setString(index++, endDate);
            stm.setString(index++, startDate); stm.setString(index++, endDate);
            stm.setInt(index++, pageSize); stm.setInt(index++, offset);
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("employeeId", rs.getInt("user_id"));
                    row.put("employeeName", rs.getString("employee_name"));
                    row.put("employeeStatus", rs.getString("employee_status"));
                    int totalServes = rs.getInt("total_serves");
                    int totalShiftDays = rs.getInt("total_shift_days");
                    long totalWorkingMinutes = rs.getLong("total_working_minutes");
                    row.put("totalServes", totalServes);
                    row.put("totalShiftDays", totalShiftDays);
                    BigDecimal servePerShiftRate = BigDecimal.ZERO;
                    if (totalShiftDays > 0) servePerShiftRate = BigDecimal.valueOf(totalServes).divide(BigDecimal.valueOf(totalShiftDays), 2, RoundingMode.HALF_UP);
                    row.put("servePerShiftRate", servePerShiftRate);
                    BigDecimal totalWorkingHours = BigDecimal.valueOf(totalWorkingMinutes).divide(BigDecimal.valueOf(60), 2, RoundingMode.HALF_UP);
                    row.put("totalWorkingHours", totalWorkingHours);
                    employeeList.add(row);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); throw e; }
        return employeeList;
    }

    // --- [HÀM ĐÃ SỬA: Loại bỏ logic đếm lượt phục vụ] ---
    public List<Map<String, Object>> getEmployeeTimeTrend(int employeeId, String startDate, String nextDayParam, String unit) throws SQLException {
        Map<String, Map<String, Object>> mergedData = new HashMap<>();
        String groupByColumnW; // Chỉ cần Work_Schedules để nhóm

        switch (unit.toLowerCase()) {
            case "week":
                groupByColumnW = "CONCAT(YEAR(WS.work_date), '-W', LPAD(WEEK(WS.work_date, 3), 2, '0'))";
                break;
            case "month":
                groupByColumnW = "DATE_FORMAT(WS.work_date, '%Y-%m')";
                break;
            case "day":
            default:
                groupByColumnW = "DATE(WS.work_date)";
                break;
        }

        // QUERY: Giờ làm việc (Shifts) - Giờ đây là truy vấn duy nhất
        String shiftsSql = String.format("""
            SELECT %s AS label, SUM(TIMESTAMPDIFF(MINUTE, WS.start_time, WS.end_time)) AS total_working_minutes
            FROM Work_Schedules WS
            WHERE WS.user_id = ? AND WS.status = 'CONFIRMED' AND WS.work_date >= ? AND WS.work_date < ?
            GROUP BY label
        """, groupByColumnW);

        try (Connection con = db.getConnection(); PreparedStatement stm = con.prepareStatement(shiftsSql)) {
            stm.setInt(1, employeeId);
            stm.setString(2, startDate);
            stm.setString(3, nextDayParam);
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("label", rs.getString("label"));
                    long minutes = rs.getLong("total_working_minutes");
                    double hours = minutes / 60.0;

                    row.put("totalWorkingHours", (float)hours);
                    // Giả lập totalServes = 0 để tránh lỗi trong Controller/JSP
                    row.put("totalServes", 0);

                    mergedData.put(rs.getString("label"), row);
                }
            }
        }

        return new ArrayList<>(mergedData.values());
    }

    public Map<String, Object> getEmployeeDetailById(int employeeId) throws SQLException {
        Map<String, Object> employeeDetail = new HashMap<>();
        String query = "SELECT full_name, email, phone_number, status FROM Users WHERE user_id = ? AND role_id = 2";
        try (Connection con = db.getConnection(); PreparedStatement stm = con.prepareStatement(query)) {
            stm.setInt(1, employeeId);
            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    employeeDetail.put("fullName", rs.getString("full_name"));
                    employeeDetail.put("email", rs.getString("email"));
                    employeeDetail.put("phoneNumber", rs.getString("phone_number"));
                    employeeDetail.put("status", rs.getString("status"));
                    return employeeDetail;
                }
            }
        } catch (SQLException e) { e.printStackTrace(); throw e; }
        return null;
    }

    public Integer findEmployeeIdByName(String fullName) throws SQLException {
        String query = "SELECT user_id FROM Users WHERE full_name LIKE ? AND role_id = 2 AND status = 'ACTIVE' LIMIT 1";
        try (Connection con = db.getConnection(); PreparedStatement stm = con.prepareStatement(query)) {
            stm.setString(1, "%" + fullName + "%");
            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) return rs.getInt("user_id");
            }
        } catch (SQLException e) { e.printStackTrace(); throw e; }
        return null;
    }
}