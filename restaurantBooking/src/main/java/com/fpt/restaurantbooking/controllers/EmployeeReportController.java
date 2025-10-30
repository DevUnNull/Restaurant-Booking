package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.repositories.EmployeeReportRepository;
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.math.BigDecimal;
import java.time.temporal.WeekFields;
import java.util.Locale;

@WebServlet(name="EmployeeReportController", urlPatterns={"/staff-report"})
public class EmployeeReportController extends HttpServlet {

    private final EmployeeReportRepository reportRepository = new EmployeeReportRepository();
    private static final LocalDate START_OF_BUSINESS = LocalDate.of(2025, 9, 1);

    // Khai báo hằng số phân trang
    private final int PAGE_SIZE = 10;

    private LocalDate safeParseDate(String dateStr, LocalDate defaultValue) {
        if (dateStr == null || dateStr.isEmpty()) {
            return defaultValue;
        }
        try {
            return LocalDate.parse(dateStr);
        } catch (Exception e) {
            return defaultValue;
        }
    }

    private List<Map<String, Object>> zeroFillTimeTrend(
            List<Map<String, Object>> rawData,
            LocalDate startDate,
            LocalDate endDate,
            String unit) {
        // ... (Code không đổi)
        Map<String, Map<String, Object>> dataMap = new HashMap<>();
        for (Map<String, Object> item : rawData) {
            dataMap.put((String) item.get("label"), item);
        }

        List<Map<String, Object>> filledData = new ArrayList<>();
        LocalDate current = startDate;
        WeekFields weekFields = WeekFields.of(Locale.getDefault());
        if ("week".equals(unit)) {
            weekFields = WeekFields.of(DayOfWeek.MONDAY, 4);
        }

        while (!current.isAfter(endDate)) {
            String label;

            if ("month".equals(unit)) {
                label = current.format(DateTimeFormatter.ofPattern("yyyy-MM"));
            } else if ("week".equals(unit)) {
                int weekOfYear = current.get(weekFields.weekOfWeekBasedYear());
                int year = current.get(weekFields.weekBasedYear());
                label = String.format("%d-W%02d", year, weekOfYear);
            } else {
                label = current.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
            }

            Map<String, Object> existingData = dataMap.get(label);

            if (existingData != null) {
                filledData.add(existingData);
            } else {
                Map<String, Object> zeroRow = new HashMap<>();
                zeroRow.put("label", label);
                zeroRow.put("totalServes", 0);
                zeroRow.put("totalWorkingHours", 0.0f); // Sử dụng 0.0f (Float) cho biểu đồ
                filledData.add(zeroRow);
            }

            if ("month".equals(unit)) {
                current = current.plusMonths(1).withDayOfMonth(1);
            } else if ("week".equals(unit)) {
                current = current.with(weekFields.dayOfWeek(), 1).plusWeeks(1);
            } else {
                current = current.plusDays(1);
            }

            if ("month".equals(unit) && current.isAfter(endDate.plusMonths(1).withDayOfMonth(1))) break;
            if ("week".equals(unit) && current.isAfter(endDate.plusWeeks(1))) break;
            if (ChronoUnit.DAYS.between(startDate, current) > ChronoUnit.DAYS.between(startDate, endDate) + 365) break;
        }

        return filledData;
    }


    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(true);
        response.setContentType("text/html;charset=UTF-8");

        String startDateParam = request.getParameter("startDate");
        String endDateParam = request.getParameter("endDate");
        String employeeIdParam = request.getParameter("employeeId");
        String chartUnitParam = request.getParameter("chartUnit");
        String searchStaffNameParam = request.getParameter("searchStaffName");

        // Xử lý tham số phân trang
        int currentPage = 1;
        int totalRecords = 0;
        int totalPages = 0;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                currentPage = Math.max(1, Integer.parseInt(pageParam));
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }
        int offset = (currentPage - 1) * PAGE_SIZE;

        String currentWarningMessage = null;
        String currentErrorMessage = null;

        LocalDate currentDate = LocalDate.now();

        LocalDate endDate = safeParseDate(endDateParam, currentDate);
        LocalDate startDate = safeParseDate(startDateParam, START_OF_BUSINESS);

        if (startDate.isBefore(START_OF_BUSINESS)) {
            currentWarningMessage = ": The start date (" + startDate.toString() + ") has been adjusted to the opening date (" + START_OF_BUSINESS.toString() + ").";
            startDate = START_OF_BUSINESS;
        }

        if (startDate.isAfter(endDate)) {
            LocalDate originalStartDate = startDate;
            LocalDate originalEndDate = endDate;

            LocalDate tempDate = startDate;
            startDate = endDate;
            endDate = tempDate;

            String swapMessage = ": The start date (" + originalStartDate.toString() + ") is after the end date (" + originalEndDate.toString() + "). The system has automatically **swapped** the two dates (From " + startDate.toString() + " to " + endDate.toString() + ") to display valid data.";

            if (currentWarningMessage != null) {
                currentWarningMessage += "<br/>" + swapMessage;
            } else {
                currentWarningMessage = swapMessage;
            }
        }

        if (endDate.isAfter(currentDate)) {
            String futureWarning = String.format(
                    ": The end date you selected (%s) is in the future. " +
                            "The metrics are calculated based on Log data up to today (%s).",
                    endDate.toString(), currentDate.toString()
            );

            if (currentWarningMessage != null) {
                currentWarningMessage += "<br/>" + futureWarning;
            } else {
                currentWarningMessage = futureWarning;
            }
        }

        if (currentWarningMessage != null) {
            session.setAttribute("sessionWarningMessage", currentWarningMessage);
        } else {
            session.removeAttribute("sessionWarningMessage");
        }

        startDateParam = startDate.toString();
        endDateParam = endDate.toString();

        if (chartUnitParam == null || chartUnitParam.isEmpty()) {
            chartUnitParam = "month";
        }

        List<Map<String, Object>> employeeData = null;
        List<Map<String, Object>> employeeTimeTrend = null;
        Map<String, Object> selectedEmployeeDetail = null;

        String employeeTimeTrendJson = null;

        try {
            if (searchStaffNameParam != null && !searchStaffNameParam.isEmpty()) {
                Integer foundEmployeeId = reportRepository.findEmployeeIdByName(searchStaffNameParam);

                if (foundEmployeeId != null) {
                    employeeIdParam = String.valueOf(foundEmployeeId);
                } else {
                    currentErrorMessage = ": Employee with name containing '" + searchStaffNameParam + "' not found or is not a staff member (role_id != 2). Displaying Overview.";
                    employeeIdParam = null;
                }
            }

            if (employeeIdParam == null || employeeIdParam.isEmpty()) {
                // Chế độ Tổng quan (có phân trang)

                // 1. Lấy tổng số bản ghi và tính tổng số trang
                totalRecords = reportRepository.getTotalActiveEmployees();
                totalPages = (int) Math.ceil((double) totalRecords / PAGE_SIZE);

                // Điều chỉnh trang hiện tại và offset
                if (currentPage > totalPages && totalPages > 0) {
                    currentPage = totalPages;
                    offset = (currentPage - 1) * PAGE_SIZE;
                } else if (totalPages == 0) {
                    currentPage = 1;
                    offset = 0;
                }

                // 2. Lấy dữ liệu phân trang
                employeeData = reportRepository.getEmployeeOverviewData(
                        startDateParam,
                        endDateParam,
                        currentDate.toString(),
                        offset,
                        PAGE_SIZE
                );

                if (employeeData != null) {
                    for (Map<String, Object> item : employeeData) {

                        BigDecimal servePerShiftRate = (BigDecimal) item.getOrDefault("servePerShiftRate", BigDecimal.ZERO);
                        item.put("servePerShiftRate", servePerShiftRate.floatValue());
                        item.put("totalServes", (Integer) item.getOrDefault("totalServes", 0));
                        item.put("totalShiftDays", (Integer) item.getOrDefault("totalShiftDays", 0));

                        BigDecimal totalWorkingHours = (BigDecimal) item.getOrDefault("totalWorkingHours", BigDecimal.ZERO);
                        item.put("totalWorkingHours", totalWorkingHours);
                    }
                }

            } else {
                // Chế độ Chi tiết (không phân trang)
                int employeeId = Integer.parseInt(employeeIdParam);

                selectedEmployeeDetail = reportRepository.getEmployeeDetailById(employeeId);

                if (selectedEmployeeDetail != null) {

                    LocalDate parsedEnd = LocalDate.parse(endDateParam);

                    String nextDayParam = parsedEnd.plusDays(1).toString();

                    employeeTimeTrend = reportRepository.getEmployeeTimeTrend(employeeId, startDateParam, nextDayParam, chartUnitParam);

                    if (employeeTimeTrend != null) {

                        LocalDate parsedStart = LocalDate.parse(startDateParam);

                        for(Map<String, Object> item : employeeTimeTrend) {
                            Double hours = (Double) item.getOrDefault("totalWorkingHours", 0.0);
                            item.put("totalWorkingHours", hours.floatValue());
                        }

                        employeeTimeTrend = zeroFillTimeTrend(employeeTimeTrend, parsedStart, parsedEnd, chartUnitParam);

                        if (!employeeTimeTrend.isEmpty()) {
                            ObjectMapper mapper = new ObjectMapper();
                            employeeTimeTrendJson = mapper.writeValueAsString(employeeTimeTrend);
                        }
                    }

                    request.setAttribute("selectedEmployeeDetail", selectedEmployeeDetail);
                } else {
                    currentErrorMessage = ": Employee with ID " + employeeId + " not found or is not a staff member (role_id != 2).";
                }

                request.setAttribute("selectedEmployeeId", employeeId);
            }

        } catch (NumberFormatException e) {
            currentErrorMessage = ": Invalid employee ID format.";
            e.printStackTrace();
        } catch (SQLException e) {
            currentErrorMessage = "Error querying the database: " + e.getMessage();
            e.printStackTrace();
        } catch (Exception e) {
            currentErrorMessage = "An unknown error occurred: " + e.getMessage();
            e.printStackTrace();
        }

        if (currentErrorMessage != null) {
            session.setAttribute("sessionErrorMessage", currentErrorMessage);
        } else {
            session.removeAttribute("sessionErrorMessage");
        }

        request.setAttribute("startDateParam", startDateParam);
        request.setAttribute("endDateParam", endDateParam);
        request.setAttribute("chartUnitParam", chartUnitParam);
        request.setAttribute("employeeData", employeeData);
        request.setAttribute("employeeTimeTrend", employeeTimeTrend);
        request.setAttribute("employeeTimeTrendJson", employeeTimeTrendJson);
        request.setAttribute("searchStaffNameParam", searchStaffNameParam);

        // Thuộc tính phân trang
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("pageSize", PAGE_SIZE);

        request.setAttribute("isDetailMode", employeeIdParam != null && !employeeIdParam.isEmpty());

        request.getRequestDispatcher("/WEB-INF/report/staff-report.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}