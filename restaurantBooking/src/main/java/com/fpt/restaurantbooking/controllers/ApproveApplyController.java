package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.models.Review;
import com.fpt.restaurantbooking.models.User;
import com.fpt.restaurantbooking.repositories.impl.ReviewRepositoryImpl;
import com.fpt.restaurantbooking.utils.DatabaseUtil;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet(name = "ApproveApply", urlPatterns = {"/approve-application"})
public class ApproveApplyController extends HttpServlet{
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int reviewId = Integer.parseInt(request.getParameter("id"));
        String action = request.getParameter("action");

        try (Connection conn = DatabaseUtil.getConnection()) {
            ReviewRepositoryImpl repo = new ReviewRepositoryImpl(conn);

            if ("approve".equals(action)) {
                int userId = Integer.parseInt(request.getParameter("userId"));
                try (PreparedStatement ps = conn.prepareStatement("UPDATE Users SET role = 'staff' WHERE user_id = ?")) {
                    ps.setInt(1, userId);
                    ps.executeUpdate();
                }
                // cập nhật trạng thái review
                repo.findById(reviewId).ifPresent(r -> {
                    r.setStatus("APPROVED");
                    repo.update(r);
                });
            } else if ("reject".equals(action)) {
                repo.findById(reviewId).ifPresent(r -> {
                    r.setStatus("REJECTED");
                    repo.update(r);
                });
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/apply-job-list");
    }
}
