package com.fpt.restaurantbooking.controllers.api;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * API cung cấp dữ liệu doanh thu cho biểu đồ (Chart.js)
 */
@WebServlet(name = "DashboardRevenueServlet", urlPatterns = {"/api/dashboard/revenue"})
public class DashboardRevenueServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(DashboardRevenueServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");

        JsonObject json = new JsonObject();
        JsonArray labels = new JsonArray();
        JsonArray values = new JsonArray();

        // Giả lập dữ liệu doanh thu theo tháng
        String[] months = {"Jan", "Feb", "Mar", "Apr", "May", "Jun"};
        long[] revenues = {10000000, 12000000, 18000000, 25000000, 20000000, 30000000};

        for (int i = 0; i < months.length; i++) {
            labels.add(months[i]);
            values.add(revenues[i]);
        }

        json.add("labels", labels);
        json.add("values", values);

        // Gửi JSON về frontend (xử lý IOException chuẩn)
        try (PrintWriter out = response.getWriter()) {
            out.write(json.toString());
            out.flush();
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error writing JSON response", e);
            try {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error writing response");
            } catch (IOException ioEx) {
                LOGGER.log(Level.SEVERE, "Error sending error response", ioEx);
            }
        }
    }
}
