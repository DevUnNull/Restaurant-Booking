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

    /**
     * Retrieves the total count of active staff members (role_id = 2).
     */
    public int getTotalActiveEmployees() throws SQLException {
        String query = "SELECT COUNT(user_id) FROM Users WHERE role_id = 2 AND status = 'ACTIVE'";
        int count = 0;
        try (Connection con = db.getConnection();
             PreparedStatement stm = con.prepareStatement(query);
             ResultSet rs = stm.executeQuery()) {
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
        return count;
    }

    /**
     * Retrieves the performance overview for all active employees within a specified date range.
     * Includes LIMIT and OFFSET for pagination.
     */
    public List<Map<String, Object>> getEmployeeOverviewData(
            String startDate,
            String endDate,
            String limitDate,
            int offset,
            int pageSize) throws SQLException {
        List<Map<String, Object>> employeeList = new ArrayList<>();

        String query = """
            SELECT
                U.user_id,
                U.full_name AS employee_name,
                U.status AS employee_status,
                
                COUNT(CASE WHEN R.status = 'COMPLETED' AND R.reservation_date BETWEEN ? AND ? THEN R.reservation_id END) AS total_serves,
                COUNT(DISTINCT CASE WHEN R.status = 'COMPLETED' AND R.reservation_date BETWEEN ? AND ? THEN R.reservation_date END) AS total_shift_days,
                (COUNT(DISTINCT CASE WHEN R.status = 'COMPLETED' AND R.reservation_date BETWEEN ? AND ? THEN R.reservation_date END) * 450) AS total_shift_minutes
                
            FROM
                Users U
            LEFT JOIN
                Reservation_Staff_Assignments RSA ON U.user_id = RSA.staff_user_id
            LEFT JOIN
                Reservations R ON RSA.reservation_id = R.reservation_id
            WHERE
                U.role_id = 2 
                AND U.status = 'ACTIVE' 
            GROUP BY
                U.user_id, U.full_name, U.status
            ORDER BY
                total_serves DESC
            LIMIT ? OFFSET ?;
        """;

        try (Connection con = db.getConnection();
             PreparedStatement stm = con.prepareStatement(query)) {

            int index = 1;

            stm.setString(index++, startDate); stm.setString(index++, endDate);
            stm.setString(index++, startDate); stm.setString(index++, endDate);
            stm.setString(index++, startDate); stm.setString(index++, endDate);

            // Tham số phân trang
            stm.setInt(index++, pageSize);
            stm.setInt(index++, offset);

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

    // ... (Giữ nguyên các phương thức khác: getEmployeeTimeTrend, getEmployeeDetailById, findEmployeeIdByName)

    /**
     * Retrieves the performance time trend for a specific employee.
     * ... (Giữ nguyên phương thức này)
     */
    public List<Map<String, Object>> getEmployeeTimeTrend(int employeeId, String startDate, String nextDayParam, String unit) throws SQLException {
        // ... (Code không đổi)
        List<Map<String, Object>> trendList = new ArrayList<>();
        String groupByColumn;

        switch (unit.toLowerCase()) {
            case "week":
                groupByColumn = "CONCAT(YEAR(R.reservation_date), '-W', LPAD(WEEK(R.reservation_date, 3), 2, '0'))";
                break;
            case "month":
                groupByColumn = "DATE_FORMAT(R.reservation_date, '%Y-%m')";
                break;
            case "day":
            default:
                groupByColumn = "DATE(R.reservation_date)";
                break;
        }

        String query = String.format("""
            SELECT
                %s AS label,
                COUNT(R.reservation_id) AS total_serves,
                (COUNT(DISTINCT R.reservation_date) * 450) AS total_shift_minutes
            FROM
                Reservation_Staff_Assignments RSA
            JOIN
                Reservations R ON RSA.reservation_id = R.reservation_id
            WHERE
                RSA.staff_user_id = ?
                AND R.status = 'COMPLETED'
                AND R.reservation_date >= ?
                AND R.reservation_date < ?
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
        // ... (Code không đổi)
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

    public Integer findEmployeeIdByName(String fullName) throws SQLException {
        // ... (Code không đổi)
        String query = "SELECT user_id FROM Users WHERE full_name LIKE ? AND role_id = 2 AND status = 'ACTIVE' LIMIT 1";

        try (Connection con = db.getConnection();
             PreparedStatement stm = con.prepareStatement(query)) {

            stm.setString(1, "%" + fullName + "%");

            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("user_id");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
        return null;
    }
}