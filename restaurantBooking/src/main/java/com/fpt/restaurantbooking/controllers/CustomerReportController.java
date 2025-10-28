package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.repositories.CustomerReportRepository;
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

@WebServlet(name="CustomerReportController", urlPatterns={"/user-report"})
public class CustomerReportController extends HttpServlet {

    private final CustomerReportRepository reportRepository = new CustomerReportRepository();
    private static final LocalDate START_OF_BUSINESS = LocalDate.of(2025, 1, 1);

    private static final int PAGE_SIZE = 10;

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

        if (startDate.isBefore(START_OF_BUSINESS)) {
            warningMessage = "Warning: The start date (" + startDate.toString() + ") was adjusted to the business start date (" + START_OF_BUSINESS.toString() + ").";
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

        if (endDate.isAfter(currentDate)) {
            String futureWarning = "Note: Data for completed (COMPLETED) bookings after the current date (" + currentDate.toString() + ") may not exist, as future transactions haven't occurred yet.";
            if (warningMessage != null) {
                warningMessage += "<br/>" + futureWarning;
            } else {
                warningMessage = futureWarning;
            }
        }

        startDateParam = startDate.toString();
        endDateParam = endDate.toString();

        int currentPage = 1;
        try {
            String pageParam = request.getParameter("page");
            if (pageParam != null) {
                currentPage = Integer.parseInt(pageParam);
            }
        } catch (NumberFormatException e) {
            currentPage = 1;
        }
        if (currentPage < 1) currentPage = 1;

        int offset = (currentPage - 1) * PAGE_SIZE;

        String errorMessage = null;
        List<Map<String, Object>> customerData = null;
        int newCustomerCount = 0;
        int totalCustomerCount = 0;
        long grandTotalSpending = 0;
        int totalPages = 0;

        try {
            totalCustomerCount = reportRepository.getTotalActiveCustomerCount();
            newCustomerCount = reportRepository.getNewCustomerCount(startDateParam, endDateParam);
            grandTotalSpending = reportRepository.getGrandTotalSpending(startDateParam, endDateParam);

            customerData = reportRepository.getCustomerOverviewData(startDateParam, endDateParam, PAGE_SIZE, offset);

            totalPages = (int) Math.ceil((double) totalCustomerCount / PAGE_SIZE);

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
        request.setAttribute("customerData", customerData);
        request.setAttribute("newCustomerCount", newCustomerCount);
        request.setAttribute("totalCustomerCount", totalCustomerCount);
        request.setAttribute("grandTotalSpending", grandTotalSpending);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("/WEB-INF/report/user-report.jsp").forward(request, response);
    }

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
}