package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.repositories.EmployeeReportRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.time.temporal.WeekFields;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

@WebServlet(name="EmployeeReportController", urlPatterns={"/staff-report"})
public class EmployeeReportController extends HttpServlet {

    private final EmployeeReportRepository reportRepository = new EmployeeReportRepository();

    private LocalDate safeParseDate(String dateStr) {
        if (dateStr == null || dateStr.trim().isEmpty()) return null;
        try { return LocalDate.parse(dateStr); } catch (Exception e) { return null; }
    }

    private List<Map<String, Object>> zeroFillTimeTrend(List<Map<String, Object>> rawData, LocalDate startDate, LocalDate endDate, String unit) {
        Map<String, Map<String, Object>> dataMap = new HashMap<>();
        for (Map<String, Object> item : rawData) {
            dataMap.put((String) item.get("label"), item);
        }

        List<Map<String, Object>> filledData = new ArrayList<>();
        LocalDate current = startDate;
        WeekFields weekFields = WeekFields.of(Locale.getDefault());
        if ("week".equals(unit)) weekFields = WeekFields.of(DayOfWeek.MONDAY, 4);

        int maxIterations = (int) ChronoUnit.DAYS.between(startDate, endDate) + 730;
        int count = 0;

        while (!current.isAfter(endDate) && count < maxIterations) {
            String label;
            LocalDate labelDate = current;

            if ("month".equals(unit)) {
                label = current.format(DateTimeFormatter.ofPattern("yyyy-MM"));
                labelDate = current.withDayOfMonth(1);
            } else if ("week".equals(unit)) {
                int week = current.get(weekFields.weekOfWeekBasedYear());
                int year = current.get(weekFields.weekBasedYear());
                label = String.format("%d-W%02d", year, week);
                labelDate = current.with(weekFields.dayOfWeek(), 1);
            } else {
                label = current.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
            }

            if (dataMap.containsKey(label)) {
                filledData.add(dataMap.get(label));
            } else {
                Map<String, Object> zeroRow = new HashMap<>();
                zeroRow.put("label", label);
                zeroRow.put("totalServes", 0);
                zeroRow.put("totalWorkingHours", 0.0f);
                filledData.add(zeroRow);
                dataMap.put(label, zeroRow);
            }

            if ("month".equals(unit)) current = labelDate.plusMonths(1);
            else if ("week".equals(unit)) current = labelDate.plusWeeks(1);
            else current = current.plusDays(1);
            count++;
        }
        return filledData;
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(true);

        String startDateParam = request.getParameter("startDate");
        String endDateParam = request.getParameter("endDate");
        String employeeIdParam = request.getParameter("employeeId");
        String searchStaffNameParam = request.getParameter("searchStaffName");

        String chartUnitParam = request.getParameter("chartUnit");
        if (chartUnitParam == null || chartUnitParam.isEmpty()) chartUnitParam = "day";
        request.setAttribute("chartUnitParam", chartUnitParam);

        LocalDate startDate = safeParseDate(startDateParam);
        LocalDate endDate = safeParseDate(endDateParam);

        if (startDate == null || endDate == null) {
            request.setAttribute("isDetailMode", false);
            request.getRequestDispatcher("/WEB-INF/report/staff-report.jsp").forward(request, response);
            return;
        }

        if (startDate.isAfter(endDate)) {
            LocalDate temp = startDate; startDate = endDate; endDate = temp;
            session.setAttribute("sessionWarningMessage", "Ngày bắt đầu lớn hơn ngày kết thúc. Đã tự động đảo lại.");
        }

        request.setAttribute("startDateParam", startDate.toString());
        request.setAttribute("endDateParam", endDate.toString());

        int pageSize = 7;
        int currentPage = 1;
        try { currentPage = Integer.parseInt(request.getParameter("page")); } catch (NumberFormatException e) {}
        int offset = (currentPage - 1) * pageSize;

        try {
            if (searchStaffNameParam != null && !searchStaffNameParam.trim().isEmpty()) {
                Integer foundId = reportRepository.findEmployeeIdByName(searchStaffNameParam);
                if (foundId != null) {
                    employeeIdParam = String.valueOf(foundId);
                } else {
                    session.setAttribute("sessionErrorMessage", "Không tìm thấy nhân viên: " + searchStaffNameParam);
                    employeeIdParam = null;
                }
            }

            if (employeeIdParam != null && !employeeIdParam.isEmpty()) {
                int empId = Integer.parseInt(employeeIdParam);
                Map<String, Object> detail = reportRepository.getEmployeeDetailById(empId);

                if (detail != null) {
                    String nextDay = endDate.plusDays(1).toString();
                    List<Map<String, Object>> trendData = reportRepository.getEmployeeTimeTrend(
                            empId, startDate.toString(), nextDay, chartUnitParam);

                    if (trendData != null) {
                        for(Map<String, Object> item : trendData) {
                            Object val = item.get("totalWorkingHours");
                            if (val instanceof Double) item.put("totalWorkingHours", ((Double) val).floatValue());
                        }
                        trendData = zeroFillTimeTrend(trendData, startDate, endDate, chartUnitParam);
                        request.setAttribute("employeeTimeTrend", trendData);
                    }
                    request.setAttribute("selectedEmployeeDetail", detail);
                    request.setAttribute("selectedEmployeeId", empId);
                    request.setAttribute("isDetailMode", true);
                } else {
                    request.setAttribute("isDetailMode", false);
                }
            }
            else {
                int totalRecords = reportRepository.getTotalFilteredEmployees(startDate.toString(), endDate.toString());
                int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
                List<Map<String, Object>> list = reportRepository.getEmployeeOverviewData(
                        startDate.toString(), endDate.toString(), null, offset, pageSize);

                if(list != null) {
                    for(Map<String, Object> i : list) {
                        if(i.get("totalServes") == null) i.put("totalServes", 0);
                        if(i.get("totalShiftDays") == null) i.put("totalShiftDays", 0);
                    }
                }

                request.setAttribute("employeeData", list);
                request.setAttribute("currentPage", currentPage);
                request.setAttribute("totalPages", totalPages);
                request.setAttribute("isDetailMode", false);
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("sessionErrorMessage", "Lỗi hệ thống: " + e.getMessage());
        }

        request.setAttribute("searchStaffNameParam", searchStaffNameParam);
        request.getRequestDispatcher("/WEB-INF/report/staff-report.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        processRequest(req, resp);
    }
}