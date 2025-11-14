package com.fpt.restaurantbooking.repositories;

import com.fpt.restaurantbooking.utils.DatabaseUtil;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.time.temporal.IsoFields;
import java.time.temporal.TemporalAdjusters;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.HashSet;
import java.util.Set;

public class OverviewReportRepository {

    private final DatabaseUtil db = new DatabaseUtil();

    private static final String TBL_RESERVATIONS = "Reservations";
    private static final String COL_DATE = "reservation_date";
    private static final String COL_ID = "reservation_id";
    private static final String COL_STATUS = "status";
    private static final String COL_PRICE = "total_amount";
    private static final String STATUS_COMPLETED = "COMPLETED";
    private static final String STATUS_CANCELLED = "CANCELLED";
    private static final String STATUS_NO_SHOW = "NO_SHOW";

    public OverviewReportRepository() {}

    public Map<String, Object> getSummaryData(String startDate, String endDate) throws SQLException {
        Map<String, Object> summary = new HashMap<>();

        String query = String.format("""
        SELECT
            COUNT(%s) AS total_bookings,
            IFNULL(SUM(CASE WHEN %s = ? THEN %s ELSE 0 END), 0) AS total_revenue,
            COUNT(CASE WHEN %s = ? OR %s = ? THEN 1 ELSE NULL END) AS total_cancellations
        FROM
            %s B
        WHERE 1=1
        """, COL_ID, COL_STATUS, COL_PRICE, COL_STATUS, COL_STATUS, TBL_RESERVATIONS);

        List<Object> params = new ArrayList<>();
        params.add(STATUS_COMPLETED);
        params.add(STATUS_CANCELLED);
        params.add(STATUS_NO_SHOW);

        if (startDate != null && !startDate.isEmpty()) {
            query += String.format(" AND B.%s >= ? ", COL_DATE);
            params.add(startDate);
        }
        if (endDate != null && !endDate.isEmpty()) {
            query += String.format(" AND B.%s <= ? ", COL_DATE);
            params.add(endDate);
        }

        try (Connection con = db.getConnection();
             PreparedStatement stm = con.prepareStatement(query)) {

            for (int i = 0; i < params.size(); i++) {
                stm.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    int totalBookings = rs.getInt("total_bookings");
                    BigDecimal totalRevenue = rs.getBigDecimal("total_revenue");
                    int totalCancellations = rs.getInt("total_cancellations");

                    double cancellationRate = 0.0;
                    if (totalBookings > 0) {
                        cancellationRate = ((double) totalCancellations / totalBookings) * 100.0;
                    }

                    summary.put("totalBookings", totalBookings);
                    summary.put("totalRevenue", totalRevenue);
                    summary.put("totalCancellations", totalCancellations);
                    summary.put("cancellationRate", cancellationRate);

                    return summary;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }

        return new HashMap<String, Object>() {{
            put("totalBookings", 0);
            put("totalRevenue", BigDecimal.ZERO);
            put("totalCancellations", 0);
            put("cancellationRate", 0.0);
        }};
    }

    public List<Map<String, Object>> getTimeTrendData(String startDateStr, String endDateStr, String unit) throws SQLException {

        DateTimeFormatter dbFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        Map<String, Map<String, Object>> dbDataMap = new HashMap<>();

        String query = createTimeTrendQuery(unit, startDateStr, endDateStr);
        List<Object> params = new ArrayList<>();

        params.add(STATUS_COMPLETED);
        params.add(STATUS_CANCELLED);
        params.add(STATUS_NO_SHOW);
        params.add(startDateStr);
        params.add(endDateStr);
        try (Connection con = db.getConnection();
             PreparedStatement stm = con.prepareStatement(query)) {

            for (int i = 0; i < params.size(); i++) {
                stm.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    String dateKey = rs.getString("date");
                    row.put("totalRevenue", rs.getBigDecimal("total_revenue"));
                    row.put("totalBookings", rs.getInt("total_bookings"));
                    row.put("totalCancellations", rs.getInt("total_cancellations"));
                    dbDataMap.put(dateKey, row);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }

        List<Map<String, Object>> finalTrendList = new ArrayList<>();
        LocalDate startDate = LocalDate.parse(startDateStr, dbFormatter);
        LocalDate endDate = LocalDate.parse(endDateStr, dbFormatter);

        Set<String> addedKeys = new HashSet<>();
        long daysBetween = ChronoUnit.DAYS.between(startDate, endDate) + 1;

        for (int i = 0; i < daysBetween; i++) {
            LocalDate currentDay = startDate.plusDays(i);
            String dateKey = generateDateKey(currentDay, unit);

            if (addedKeys.contains(dateKey)) {
                continue;
            }

            Map<String, Object> data = dbDataMap.getOrDefault(dateKey, createZeroData(dateKey));
            data.put("date", dateKey);
            finalTrendList.add(data);
            addedKeys.add(dateKey);

            if (unit.equalsIgnoreCase("month")) {
                LocalDate lastDayOfMonth = currentDay.with(TemporalAdjusters.lastDayOfMonth());
                i = (int) ChronoUnit.DAYS.between(startDate, lastDayOfMonth);
            } else if (unit.equalsIgnoreCase("week")) {
                LocalDate endOfWeek = currentDay.with(TemporalAdjusters.nextOrSame(DayOfWeek.SUNDAY));
                if (endOfWeek.isAfter(endDate)) {
                    endOfWeek = endDate;
                }
                i = (int) ChronoUnit.DAYS.between(startDate, endOfWeek);
            }
        }

        return finalTrendList;
    }


    private Map<String, Object> createZeroData(String dateKey) {
        Map<String, Object> zeroData = new HashMap<>();
        zeroData.put("totalRevenue", BigDecimal.ZERO);
        zeroData.put("totalBookings", 0);
        zeroData.put("totalCancellations", 0);
        return zeroData;
    }

    private String generateDateKey(LocalDate date, String unit) {
        switch (unit.toLowerCase()) {
            case "week":
                int year = date.get(IsoFields.WEEK_BASED_YEAR);
                int week = date.get(IsoFields.WEEK_OF_WEEK_BASED_YEAR);
                return String.format("%d-W%02d", year, week);
            case "month":
                return date.format(DateTimeFormatter.ofPattern("yyyy-MM"));
            case "day":
            default:
                return date.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        }
    }

    private String createTimeTrendQuery(String unit, String startDate, String endDate) {
        String groupByColumn;
        String dateColumn = "B." + COL_DATE;

        switch (unit.toLowerCase()) {
            case "week":
                groupByColumn = String.format("CONCAT(YEAR(%s), '-W', LPAD(WEEK(%s, 3), 2, '0'))", dateColumn, dateColumn);
                break;
            case "month":
                groupByColumn = String.format("DATE_FORMAT(%s, '%%Y-%%m')", dateColumn);
                break;
            case "day":
            default:
                groupByColumn = String.format("DATE_FORMAT(%s, '%%Y-%%m-%%d')", dateColumn);
                break;
        }

        String query = String.format("""
            SELECT
                %s AS date,
                COUNT(B.%s) AS total_bookings,
                IFNULL(SUM(CASE WHEN B.%s = ? THEN B.%s ELSE 0 END), 0) AS total_revenue,
                COUNT(CASE WHEN B.%s = ? OR B.%s = ? THEN 1 ELSE NULL END) AS total_cancellations
            FROM
                %s B
            WHERE 1=1
            AND %s >= ?
            AND %s <= ?
            GROUP BY
                %s
            ORDER BY
                date ASC;
        """, groupByColumn, COL_ID,
                COL_STATUS, COL_PRICE,
                COL_STATUS, COL_STATUS,
                TBL_RESERVATIONS,
                dateColumn, dateColumn, groupByColumn);

        return query;
    }
}