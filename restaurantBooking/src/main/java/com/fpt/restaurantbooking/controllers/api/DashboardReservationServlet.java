package com.fpt.restaurantbooking.controllers.api;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;

public class DashboardReservationServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");

        JsonObject json = new JsonObject();
        JsonArray labels = new JsonArray();
        JsonArray values = new JsonArray();

        String[] months = {"Jan", "Feb", "Mar", "Apr", "May", "Jun"};
        int[] counts = {45, 50, 60, 70, 80, 100};

        for (int i = 0; i < months.length; i++) {
            labels.add(months[i]);
            values.add(counts[i]);
        }

        json.add("labels", labels);
        json.add("values", values);

        // Xử lý IOException đúng cách khi dùng getWriter()
        try (PrintWriter out = response.getWriter()) {
            out.write(json.toString());
            out.flush();
        } catch (IOException e) {
            e.printStackTrace();
            try {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error writing response");
            } catch (IOException ioException) {
                ioException.printStackTrace();
            }
        }
    }
}
