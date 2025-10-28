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

    public List<Map<String, Object>> getEmployeeOverviewData(String startDate, String endDate, String limitDate) throws SQLException {
        List<Map<String, Object>> employeeList = new ArrayList<>();

        String query = """
            SELECT
                U.user_id,
                U.full_name AS employee_name,
                U.status AS employee_status,
                -- GIẢ LẬP DỮ LIỆU: 450 phút/ngày * Tổng số ngày SHIFT_WORK
                (COUNT(DISTINCT CASE WHEN SAL.activity_type = 'SHIFT_WORK' AND SAL.activity_date BETWEEN ? AND ? THEN SAL.activity_date END) * 450) AS total_shift_minutes,
                
                SUM(CASE WHEN SAL.activity_type = 'RESERVATION_SERVE' AND SAL.activity_date BETWEEN ? AND ? THEN 1 ELSE 0 END) AS total_serves,
                
                COUNT(DISTINCT CASE WHEN SAL.activity_type = 'SHIFT_WORK' AND SAL.activity_date BETWEEN ? AND ? THEN SAL.activity_date END) AS total_shift_days
                
            FROM
                Users U
            LEFT JOIN
                Staff_Activity_Log SAL ON U.user_id = SAL.staff_user_id
            WHERE
                U.role_id = 2 
                AND U.status = 'ACTIVE' 
            GROUP BY
                U.user_id, U.full_name, U.status
            ORDER BY
                total_serves DESC;
        """;

        try (Connection con = db.getConnection();
             PreparedStatement stm = con.prepareStatement(query)) {

            int index = 1;

            stm.setString(index++, startDate); stm.setString(index++, endDate);
            stm.setString(index++, startDate); stm.setString(index++, endDate);
            stm.setString(index++, startDate); stm.setString(index++, endDate);

            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("employeeId", rs.getInt("user_id"));
                    row.put("employeeName", rs.getString("employee_name"));
                    row.put("employeeStatus", rs.getString("employee_status"));

                    int totalServes = rs.getInt("total_serves");
                    int totalShiftDays = rs.getInt("total_shift_days");
                    long totalShiftMinutes = rs.getLong("total_shift_minutes");

                    row.put("totalServes", totalServes);
                    row.put("totalShiftDays", totalShiftDays);

                    BigDecimal servePerShiftRate = BigDecimal.ZERO;
                    if (totalShiftDays > 0) {
                        servePerShiftRate = BigDecimal.valueOf(totalServes)
                                .divide(BigDecimal.valueOf(totalShiftDays), 2, RoundingMode.HALF_UP);
                    }
                    row.put("servePerShiftRate", servePerShiftRate);
                    BigDecimal totalWorkingHours = BigDecimal.valueOf(totalShiftMinutes)
                            .divide(BigDecimal.valueOf(60), 2, RoundingMode.HALF_UP);
                    row.put("totalWorkingHours", totalWorkingHours);

                    employeeList.add(row);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
        return employeeList;
    }

    public List<Map<String, Object>> getEmployeeTimeTrend(int employeeId, String startDate, String nextDayParam, String unit) throws SQLException {
        List<Map<String, Object>> trendList = new ArrayList<>();
        String groupByColumn;

        switch (unit.toLowerCase()) {
            case "week":
                groupByColumn = "CONCAT(YEAR(SAL.activity_date), '-W', LPAD(WEEK(SAL.activity_date, 3), 2, '0'))";
                break;
            case "month":
                groupByColumn = "DATE_FORMAT(SAL.activity_date, '%Y-%m')";
                break;
            case "day":
            default:
                groupByColumn = "DATE(SAL.activity_date)";
                break;
        }

        String query = String.format("""
            SELECT
                %s AS label,
                COUNT(CASE WHEN SAL.activity_type = 'RESERVATION_SERVE' THEN SAL.log_id END) AS total_serves,
                (COUNT(DISTINCT CASE WHEN SAL.activity_type = 'SHIFT_WORK' THEN SAL.activity_date END) * 450) AS total_shift_minutes
            FROM
                Staff_Activity_Log SAL
            WHERE
                SAL.staff_user_id = ?
                AND SAL.activity_date >= ?
                AND SAL.activity_date < ?
            GROUP BY
                label
            ORDER BY
                label ASC;
        """, groupByColumn);

        try (Connection con = db.getConnection();
             PreparedStatement stm = con.prepareStatement(query)) {

            stm.setInt(1, employeeId);
            stm.setString(2, startDate);
            stm.setString(3, nextDayParam);

            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("label", rs.getString("label"));
                    row.put("totalServes", rs.getInt("total_serves"));
                    long totalShiftMinutes = rs.getLong("total_shift_minutes");
                    double totalWorkingHours = totalShiftMinutes / 60.0;
                    row.put("totalWorkingHours", totalWorkingHours);

                    trendList.add(row);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
        return trendList;
    }

    public Map<String, Object> getEmployeeDetailById(int employeeId) throws SQLException {
        Map<String, Object> employeeDetail = new HashMap<>();
        String query = "SELECT full_name, email, phone_number, status FROM Users WHERE user_id = ? AND role_id = 2";
        try (Connection con = db.getConnection();
             PreparedStatement stm = con.prepareStatement(query)) {
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
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
        return null;
    }
}