package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.repositories.ServiceReportRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "ServiceReportController", urlPatterns = {"/service-report"})
public class ServiceReportController extends HttpServlet {

    private final ServiceReportRepository serviceReportRepository = new ServiceReportRepository();

    // === PHƯƠNG THỨC padTrendData (Giữ nguyên) ===
    private List<Map<String, Object>> padTrendData(List<Map<String, Object>> sparseReport,
                                                   LocalDate startDate,
                                                   LocalDate endDate,
                                                   String timeGrouping) {

        Map<String, Map<String, Object>> dataLookup = new HashMap<>();
        for (Map<String, Object> row : sparseReport) {
            dataLookup.put((String) row.get("report_date"), row);
        }

        List<Map<String, Object>> fullReport = new ArrayList<>();
        DateTimeFormatter dbFormatter = DateTimeFormatter.ISO_LOCAL_DATE;

        if ("day".equals(timeGrouping)) {
            LocalDate currentDate = startDate;
            while (!currentDate.isAfter(endDate)) {
                String dateKey = currentDate.format(dbFormatter);
                Map<String, Object> row = dataLookup.get(dateKey);

                if (row != null) {
                    fullReport.add(row);
                } else {
                    fullReport.add(createEmptyTrendRow(dateKey)); // Sửa đổi ở hàm này
                }
                currentDate = currentDate.plusDays(1);
            }
        } else if ("week".equals(timeGrouping)) {
            LocalDate currentDate = startDate.with(java.time.temporal.TemporalAdjusters.previousOrSame(java.time.DayOfWeek.MONDAY));
            LocalDate finalWeekStartDate = endDate.with(java.time.temporal.TemporalAdjusters.previousOrSame(java.time.DayOfWeek.MONDAY));

            while (!currentDate.isAfter(finalWeekStartDate)) {
                String dateKey = currentDate.format(dbFormatter);
                Map<String, Object> row = dataLookup.get(dateKey);

                if (row != null) {
                    fullReport.add(row);
                } else {
                    fullReport.add(createEmptyTrendRow(dateKey)); // Sửa đổi ở hàm này
                }
                currentDate = currentDate.plusWeeks(1);
            }
        } else if ("month".equals(timeGrouping)) {
            LocalDate currentDate = startDate.withDayOfMonth(1);
            LocalDate finalMonthStartDate = endDate.withDayOfMonth(1);

            while (!currentDate.isAfter(finalMonthStartDate)) {
                String dateKey = currentDate.format(dbFormatter);
                Map<String, Object> row = dataLookup.get(dateKey);

                if (row != null) {
                    fullReport.add(row);
                } else {
                    fullReport.add(createEmptyTrendRow(dateKey)); // Sửa đổi ở hàm này
                }
                currentDate = currentDate.plusMonths(1);
            }
        }

        return fullReport;
    }

    // === SỬA ĐỔI HÀM createEmptyTrendRow ===
    private Map<String, Object> createEmptyTrendRow(String dateKey) {
        Map<String, Object> emptyRow = new HashMap<>();
        emptyRow.put("report_date", dateKey);
        emptyRow.put("total_revenue", BigDecimal.ZERO);

        // Thêm tất cả các trường đếm mới với giá trị 0
        emptyRow.put("total_bookings", 0);
        emptyRow.put("completed_bookings", 0);
        emptyRow.put("cancelled_bookings", 0);
        emptyRow.put("no_show_bookings", 0);
        emptyRow.put("pending_bookings", 0);
        emptyRow.put("checked_in_bookings", 0);

        return emptyRow;
    }

    // === HÀM processRequest (Giữ nguyên) ===
    // (Toàn bộ logic của processRequest không thay đổi so với code bạn cung cấp)
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        String serviceType = request.getParameter("serviceType");
        String status = request.getParameter("status");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String timeGrouping = request.getParameter("timeGrouping");

        if (serviceType != null && serviceType.trim().isEmpty()) serviceType = null;
        if (status == null || status.trim().isEmpty()) {
            status = "All";
        }
        if (timeGrouping == null || timeGrouping.trim().isEmpty()) {
            timeGrouping = "day";
        }

        final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy");

        List<Map<String, Object>> topSellingItems = new ArrayList<>();
        List<Map<String, Object>> trendReport = new ArrayList<>();

        String warningMessage = null;
        String errorMessage = null;

        List<String> serviceTypesList = null;
        Map<String, String> statusesMap = null;

        boolean hasData = false;
        boolean reportRunAttempted = false;

        try {
            serviceTypesList = serviceReportRepository.getAvailableServiceTypes();
            statusesMap = new LinkedHashMap<>();
            statusesMap.put("All", "Tất cả");
            statusesMap.put("PENDING", "Chờ xác nhận");
            statusesMap.put("CONFIRMED", "Đã xác nhận");
            statusesMap.put("COMPLETED", "Hoàn thành");
            statusesMap.put("CANCELLED", "Đã hủy");
            statusesMap.put("NO_SHOW", "Không đến");


            LocalDate parsedStartDate = null;
            LocalDate parsedEndDate = null;

            if (startDate == null || startDate.trim().isEmpty() || endDate == null || endDate.trim().isEmpty()) {
                warningMessage = "Vui lòng chọn cả ngày bắt đầu và ngày kết thúc để xem báo cáo chi tiết.";
            } else {
                reportRunAttempted = true;

                try {
                    parsedStartDate = LocalDate.parse(startDate);
                    parsedEndDate = LocalDate.parse(endDate);
                } catch (DateTimeParseException e) {
                    errorMessage = "Định dạng ngày không hợp lệ. Vui lòng chọn lại.";
                    request.setAttribute("errorMessage", errorMessage);
                    request.setAttribute("statusesMap", statusesMap);
                    request.setAttribute("serviceTypesList", serviceTypesList);
                    request.getRequestDispatcher("/WEB-INF/report/service-report.jsp").forward(request, response);
                    return;
                }

                topSellingItems = serviceReportRepository.getTopSellingItems(serviceType, status, parsedStartDate.toString(), parsedEndDate.toString(), 500);
                // Hàm này giờ sẽ trả về dữ liệu chi tiết
                trendReport = serviceReportRepository.getServiceTrendReport(serviceType, status, parsedStartDate.toString(), parsedEndDate.toString(), timeGrouping);

                if (trendReport != null && !trendReport.isEmpty()) {
                    // Hàm này giờ sẽ chèn 0 cho các trường chi tiết
                    trendReport = padTrendData(trendReport, parsedStartDate, parsedEndDate, timeGrouping);
                }

                boolean hasTopSellingData = topSellingItems != null && !topSellingItems.isEmpty();
                boolean hasTrendData = trendReport != null && !trendReport.isEmpty();

                hasData = hasTopSellingData || hasTrendData;

                if (!hasData) {
                    StringBuilder filterDetail = new StringBuilder();
                    String displayStatus = statusesMap.get(status);

                    filterDetail.append("Status: ").append(displayStatus);
                    if (serviceType != null) {
                        filterDetail.append(", Service Type: ").append(serviceType);
                    }
                    filterDetail.append(", Date Range: ")
                            .append(parsedStartDate.format(DATE_FORMATTER))
                            .append(" to ")
                            .append(parsedEndDate.format(DATE_FORMATTER));

                    warningMessage = "Không tìm thấy dữ liệu báo cáo nào phù hợp với điều kiện lọc. Lọc: " + filterDetail.toString();
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            errorMessage = "Lỗi truy vấn cơ sở dữ liệu: " + e.getMessage();
            topSellingItems.clear();
            trendReport.clear();
        } catch (Exception e) {
            e.printStackTrace();
            errorMessage = "Lỗi không xác định: " + e.getMessage();
            topSellingItems.clear();
            trendReport.clear();
        }

        request.setAttribute("warningMessage", warningMessage);
        request.setAttribute("errorMessage", errorMessage);
        request.setAttribute("selectedServiceType", serviceType);
        request.setAttribute("selectedStatus", status);
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);
        request.setAttribute("selectedTimeGrouping", timeGrouping);
        request.setAttribute("hasData", hasData);
        request.setAttribute("reportRunAttempted", reportRunAttempted);

        request.setAttribute("topSellingItems", topSellingItems);
        // trendReport này giờ đã chứa dữ liệu chi tiết mà JSP cần
        request.setAttribute("trendReport", trendReport);

        request.setAttribute("serviceTypesList", serviceTypesList);
        request.setAttribute("statusesMap", statusesMap);

        request.getRequestDispatcher("/WEB-INF/report/service-report.jsp").forward(request, response);
    }

    // === doGet, doPost, getServletInfo (Giữ nguyên) ===
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Service Statistics Report Controller";
    }
}