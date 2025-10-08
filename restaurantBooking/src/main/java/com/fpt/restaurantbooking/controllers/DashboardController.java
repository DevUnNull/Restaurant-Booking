package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.services.DashboardService;
import com.fpt.restaurantbooking.services.impl.DashboardServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "DashboardController", urlPatterns = {"/dashboard"})
public class DashboardController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(DashboardController.class.getName());
    private DashboardService dashBoardService;

    @Override
    public void init() {
        this.dashBoardService = new DashboardServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) {
        Map<String, Object> overviewStats = dashBoardService.getOverviewStats();
        String dailyRevenueJson = dashBoardService.getDailyRevenueForChart();

        request.setAttribute("overviewStats", overviewStats);
        request.setAttribute("dailyRevenueJson", dailyRevenueJson);

        try {
            request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
        } catch (ServletException e) {
            LOGGER.log(Level.SEVERE, "Servlet exception while forwarding to dashboard.jsp", e);
            try {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Servlet error while forwarding");
            } catch (IOException ioEx) {
                LOGGER.log(Level.SEVERE, "Failed to send error response", ioEx);
            }
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "I/O exception while forwarding to dashboard.jsp", e);
            try {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "I/O error while forwarding");
            } catch (IOException ioEx) {
                LOGGER.log(Level.SEVERE, "Failed to send error response", ioEx);
            }
        }
    }
}
