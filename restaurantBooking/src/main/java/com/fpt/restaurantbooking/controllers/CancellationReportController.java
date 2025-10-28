package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.repositories.CancellationReportRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@WebServlet(name="CancellationReportController", urlPatterns={"/cancel-report"})
public class CancellationReportController extends HttpServlet {

    private final CancellationReportRepository reportRepository = new CancellationReportRepository();
    private static final LocalDate START_OF_BUSINESS = LocalDate.of(2025, 1, 1);

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

        String warningMessage = null;

        LocalDate currentDate = LocalDate.now();

        LocalDate endDate = safeParseDate(endDateParam, currentDate);
        LocalDate startDate = safeParseDate(startDateParam, START_OF_BUSINESS);

        if (endDate.isAfter(currentDate)) {
            String futureWarning = "Warning: The end date (" + endDate.toString() + ") cannot exceed the current date. The system has adjusted the end date to **" + currentDate.toString() + "**.";
            if (warningMessage != null) {
                warningMessage += "<br/>" + futureWarning;
            } else {
                warningMessage = futureWarning;
            }
            endDate = currentDate;
        }

        if (startDate.isBefore(START_OF_BUSINESS)) {
            String pastWarning = "Warning: The start date (" + startDate.toString() + ") was adjusted to the business start date (" + START_OF_BUSINESS.toString() + ").";
            if (warningMessage != null) {
                warningMessage += "<br/>" + pastWarning;
            } else {
                warningMessage = pastWarning;
            }
            startDate = START_OF_BUSINESS;
        }

        if (startDate.isAfter(endDate)) {
            LocalDate originalStartDate = startDate;
            LocalDate originalEndDate = endDate;

            LocalDate tempDate = startDate;
            startDate = endDate;
            endDate = tempDate;

            String swapMessage = "Warning: The start date (" + originalStartDate.toString() + ") was later than the end date (" + originalEndDate.toString() + "). The system automatically **swapped** the two dates (From " + startDate.toString() + " to " + endDate.toString() + ") to display valid data.";

            if (warningMessage != null) {
                warningMessage += "<br/>" + swapMessage;
            } else {
                warningMessage = swapMessage;
            }
        }

        startDateParam = startDate.toString();
        endDateParam = endDate.toString();

        String errorMessage = null;
        List<Map<String, Object>> cancellationData = null;

        try {
            cancellationData = reportRepository.getCancellationData(startDateParam, endDateParam);

        } catch (SQLException e) {
            errorMessage = "Database query error: " + e.getMessage();
            e.printStackTrace();
        } catch (Exception e) {
            errorMessage = "Unknown error: " + e.getMessage();
            e.printStackTrace();
        }

        request.setAttribute("warningMessage", warningMessage);
        request.setAttribute("errorMessage", errorMessage);
        request.setAttribute("startDateParam", startDateParam);
        request.setAttribute("endDateParam", endDateParam);
        request.setAttribute("cancellationData", cancellationData);

        request.getRequestDispatcher("/WEB-INF/report/cancel-report.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}