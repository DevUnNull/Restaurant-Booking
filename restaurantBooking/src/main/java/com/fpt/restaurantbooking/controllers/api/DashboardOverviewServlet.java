package com.fpt.restaurantbooking.controllers.api;

import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;

public class DashboardOverviewServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");

        // Tạo dữ liệu giả (mock data)
        JsonObject json = new JsonObject();
        json.addProperty("totalReservations", 120);
        json.addProperty("totalRevenue", 55000000);
        json.addProperty("totalCanceled", 8);

        // Ghi dữ liệu ra response, xử lý IOException đúng chuẩn
        try (PrintWriter out = response.getWriter()) {
            out.write(json.toString());
            out.flush();
        } catch (IOException e) {
            // Ghi log lỗi (có thể thay bằng logger chuyên nghiệp)
            e.printStackTrace();
            try {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error writing response");
            } catch (IOException ioException) {
                ioException.printStackTrace();
            }
        }
    }
}
