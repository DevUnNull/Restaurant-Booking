package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.repositories.OverviewReportRepository;
import com.fpt.restaurantbooking.utils.ExcelGeneratorUtil;
import com.fpt.restaurantbooking.utils.PdfGeneratorUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.sql.SQLException;
import java.math.BigDecimal;
import java.time.LocalDate;

@WebServlet("/ExportOverviewReportServlet")
public class ExportOverviewReportController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final OverviewReportRepository reportRepository = new OverviewReportRepository();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String type = request.getParameter("type");
        String startDateParam = request.getParameter("startDate");
        String endDateParam = request.getParameter("endDate");
        String chartUnitParam = request.getParameter("chartUnit");

        if (chartUnitParam == null || chartUnitParam.isEmpty()) {
            chartUnitParam = "month";
        }

        LocalDate currentDate = LocalDate.now();

        startDateParam = (startDateParam == null || startDateParam.isEmpty()) ? currentDate.minusYears(1).toString() : startDateParam;
        endDateParam = (endDateParam == null || endDateParam.isEmpty()) ? currentDate.toString() : endDateParam;


        Map<String, Object> summaryData;
        List<Map<String, Object>> timeTrendData;

        try {
            summaryData = reportRepository.getSummaryData(startDateParam, endDateParam);
            timeTrendData = reportRepository.getTimeTrendData(startDateParam, endDateParam, chartUnitParam);

            BigDecimal revenueSummary = (BigDecimal) summaryData.getOrDefault("totalRevenue", BigDecimal.ZERO);
            summaryData.put("totalRevenue", revenueSummary.longValue());

            if (timeTrendData != null) {
                for (Map<String, Object> item : timeTrendData) {
                    BigDecimal itemRevenue = (BigDecimal) item.getOrDefault("totalRevenue", BigDecimal.ZERO);
                    item.put("totalRevenue", itemRevenue.longValue());
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database Error retrieving Overview Report data: " + e.getMessage());
            return;
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to retrieve Overview Report data: " + e.getMessage());
            return;
        }

        try {
            if ("excel".equalsIgnoreCase(type)) {

                response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
                response.setHeader("Content-Disposition", String.format("attachment; filename=\"OverviewReport_%s_to_%s.xlsx\"", startDateParam, endDateParam));

                ExcelGeneratorUtil generator = new ExcelGeneratorUtil();
                generator.generateOverviewReport(summaryData, timeTrendData, response.getOutputStream());

            } else if ("pdf".equalsIgnoreCase(type)) {

                response.setContentType("application/pdf");
                response.setHeader("Content-Disposition", String.format("attachment; filename=\"OverviewReport_%s_to_%s.pdf\"", startDateParam, endDateParam));

                PdfGeneratorUtil generator = new PdfGeneratorUtil();
                generator.generateOverviewReport(summaryData, timeTrendData, response.getOutputStream());

            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid or missing report type. Must be 'excel' or 'pdf'.");
            }

        } catch (IOException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Export failed (IO Error): " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Unknown error during report generation: " + e.getMessage());
        }
    }
}