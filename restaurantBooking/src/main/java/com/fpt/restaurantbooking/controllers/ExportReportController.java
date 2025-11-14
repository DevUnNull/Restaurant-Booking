package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.repositories.ServiceReportRepository;
import com.fpt.restaurantbooking.utils.ExcelGeneratorUtil;
import com.fpt.restaurantbooking.utils.PdfGeneratorUtil;
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
import java.util.List;
import java.util.Map;

@WebServlet("/ExportServiceReportServlet")
public class ExportReportController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final ServiceReportRepository serviceReportRepository = new ServiceReportRepository();

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
                fullReport.add(row != null ? row : createEmptyTrendRow(dateKey));
                currentDate = currentDate.plusDays(1);
            }
        } else if ("week".equals(timeGrouping)) {
            LocalDate currentDate = startDate.with(java.time.temporal.TemporalAdjusters.previousOrSame(java.time.DayOfWeek.MONDAY));
            LocalDate finalWeekStartDate = endDate.with(java.time.temporal.TemporalAdjusters.previousOrSame(java.time.DayOfWeek.MONDAY));
            while (!currentDate.isAfter(finalWeekStartDate)) {
                String dateKey = currentDate.format(dbFormatter);
                Map<String, Object> row = dataLookup.get(dateKey);
                fullReport.add(row != null ? row : createEmptyTrendRow(dateKey));
                currentDate = currentDate.plusWeeks(1);
            }
        } else if ("month".equals(timeGrouping)) {
            LocalDate currentDate = startDate.withDayOfMonth(1);
            LocalDate finalMonthStartDate = endDate.withDayOfMonth(1);
            while (!currentDate.isAfter(finalMonthStartDate)) {
                String dateKey = currentDate.format(dbFormatter);
                Map<String, Object> row = dataLookup.get(dateKey);
                fullReport.add(row != null ? row : createEmptyTrendRow(dateKey));
                currentDate = currentDate.plusMonths(1);
            }
        }
        return fullReport;
    }

    private Map<String, Object> createEmptyTrendRow(String dateKey) {
        Map<String, Object> emptyRow = new HashMap<>();
        emptyRow.put("report_date", dateKey);
        emptyRow.put("total_revenue", BigDecimal.ZERO);
        emptyRow.put("total_bookings", 0);
        emptyRow.put("completed_bookings", 0);
        emptyRow.put("cancelled_bookings", 0);
        emptyRow.put("no_show_bookings", 0);
        emptyRow.put("pending_bookings", 0);
        emptyRow.put("checked_in_bookings", 0);
        return emptyRow;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("[ExportReportController] Bắt đầu yêu cầu xuất file...");

        String type = request.getParameter("type");

        List<Map<String, Object>> topSellingData;
        List<Map<String, Object>> trendData;

        String serviceType = request.getParameter("serviceType");
        String status = request.getParameter("status");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String timeGrouping = request.getParameter("timeGrouping");

        if (serviceType != null && serviceType.trim().isEmpty()) serviceType = null;
        if (status != null && status.trim().isEmpty()) status = null;
        if (startDate != null && startDate.trim().isEmpty()) startDate = null;
        if (endDate != null && endDate.trim().isEmpty()) endDate = null;
        if (timeGrouping == null || timeGrouping.trim().isEmpty()) {
            timeGrouping = "day";
        }

        String serviceName = (serviceType != null) ? serviceType.replaceAll("\\s+", "_") : "Tat_Ca_Dich_Vu";
        String filenameBase = String.format("BaoCaoDichVu_%s", serviceName);

        try {
            topSellingData = serviceReportRepository.getTopSellingItems(serviceType, status, startDate, endDate, 500);
            trendData = serviceReportRepository.getServiceTrendReport(serviceType, status, startDate, endDate, timeGrouping);

            if (startDate != null && endDate != null && trendData != null) {
                LocalDate parsedStartDate = LocalDate.parse(startDate);
                LocalDate parsedEndDate = LocalDate.parse(endDate);
                trendData = padTrendData(trendData, parsedStartDate, parsedEndDate, timeGrouping);
                System.out.println("[ExportReportController] Đã pad dữ liệu trend.");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi Cơ sở dữ liệu khi lấy dữ liệu báo cáo: " + e.getMessage());
            return;
        } catch (DateTimeParseException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Định dạng ngày không hợp lệ, không thể pad dữ liệu: " + e.getMessage());
            return;
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Thất bại khi lấy dữ liệu báo cáo: " + e.getMessage());
            return;
        }

        try {
            if ("excel".equalsIgnoreCase(type)) {
                System.out.println("[ExportReportController] Đang tạo file Excel...");
                response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
                response.setHeader("Content-Disposition", String.format("attachment; filename=\"%s.xlsx\"", filenameBase));

                ExcelGeneratorUtil generator = new ExcelGeneratorUtil();
                generator.generateServiceReport(topSellingData, trendData, response.getOutputStream(),
                        serviceType, status, startDate, endDate);

                response.getOutputStream().flush();
                System.out.println("[ExportReportController] Xuất Excel thành công.");

            } else if ("pdf".equalsIgnoreCase(type)) {
                System.out.println("[ExportReportController] Đang tạo file PDF...");
                response.setContentType("application/pdf");
                response.setHeader("Content-Disposition", String.format("attachment; filename=\"%s.pdf\"", filenameBase));

                PdfGeneratorUtil generator = new PdfGeneratorUtil();
                generator.generateServiceReport(topSellingData, trendData, response.getOutputStream(),
                        serviceType, status, startDate, endDate);

                response.getOutputStream().flush();
                System.out.println("[ExportReportController] Xuất PDF thành công.");

            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Kiểu báo cáo không hợp lệ.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("!!!!!!!!!! [ExportReportController] LỖI KHI GHI FILE !!!!!!!!!!");
            if (!response.isCommitted()) {
                response.reset();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi tạo file báo cáo: " + e.getMessage());
            }
        }
    }
}