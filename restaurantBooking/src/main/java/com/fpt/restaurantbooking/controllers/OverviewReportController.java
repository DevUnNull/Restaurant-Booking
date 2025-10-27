package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.repositories.OverviewReportRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.math.BigDecimal;

@WebServlet(name="OverviewReportController", urlPatterns={"/overview-report"})
public class OverviewReportController extends HttpServlet {

    private final OverviewReportRepository reportRepository = new OverviewReportRepository();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        response.setContentType("text/html;charset=UTF-8");

        if (session == null || session.getAttribute("userRole") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String startDateParam = request.getParameter("startDate");
        String endDateParam = request.getParameter("endDate");
        String chartUnitParam = request.getParameter("chartUnit");

        boolean isInitialLoad = (startDateParam == null || startDateParam.isEmpty())
                && (endDateParam == null || endDateParam.isEmpty());

        if (chartUnitParam == null || chartUnitParam.isEmpty()) {
            chartUnitParam = "month";
        }

        LocalDate currentDate = LocalDate.now();
        LocalDate minDate = LocalDate.of(2025, 1, 1);
        LocalDate maxDate = LocalDate.of(2025, 10, 31);

        Map<String, Object> summaryData = new HashMap<>();
        List<Map<String, Object>> timeTrendData = null;
        String warningMessage = null;
        String errorMessage = null;

        if (isInitialLoad) {
            startDateParam = currentDate.minusMonths(1).toString();
            endDateParam = currentDate.toString();
        }


        try {
            startDateParam = (startDateParam == null || startDateParam.isEmpty()) ? currentDate.minusYears(1).toString() : startDateParam;
            endDateParam = (endDateParam == null || endDateParam.isEmpty()) ? currentDate.toString() : endDateParam;

            LocalDate startDate = LocalDate.parse(startDateParam);
            LocalDate endDate = LocalDate.parse(endDateParam);

            if (startDate.isBefore(minDate)) {
                startDate = minDate;
                startDateParam = minDate.toString();
            }
            if (endDate.isAfter(maxDate)) {
                endDate = maxDate;
                endDateParam = maxDate.toString();
            }

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

            Integer totalBookings = (Integer) summaryData.getOrDefault("totalBookings", 0);

            if (totalBookings == 0) {
                warningMessage = "No booking data found for the selected period (" + startDateParam + " to " + endDateParam + ").";
            } else if (isInitialLoad) {
                warningMessage = "Showing report for default period (" + startDateParam + " to " + endDateParam + "). Please use Filter Popup to customize the date range.";
            }


        } catch (SQLException e) {
            e.printStackTrace();
            errorMessage = "Database query error: " + e.getMessage();
        } catch (Exception e) {
            e.printStackTrace();
            errorMessage = "Unknown error: " + e.getMessage();
        }

        request.setAttribute("isInitialLoad", isInitialLoad);
        request.setAttribute("warningMessage", warningMessage);
        request.setAttribute("errorMessage", errorMessage);
        request.setAttribute("startDateParam", startDateParam);
        request.setAttribute("endDateParam", endDateParam);
        request.setAttribute("chartUnitParam", chartUnitParam);
        request.setAttribute("currentDate", currentDate.toString());

        request.setAttribute("summaryData", summaryData);
        request.setAttribute("timeTrendData", timeTrendData);

        request.getRequestDispatcher("/WEB-INF/report/overview-report.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}