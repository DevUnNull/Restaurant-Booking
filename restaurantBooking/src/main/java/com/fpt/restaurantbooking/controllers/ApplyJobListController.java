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
import java.time.LocalDateTime;
import java.util.List;

// admin nhận đơn từ customer

@WebServlet(name = "apply-job-list", urlPatterns = {"/apply-job-list"})
public class ApplyJobListController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try (Connection conn = DatabaseUtil.getConnection()) {
            ReviewRepositoryImpl repo = new ReviewRepositoryImpl(conn);
            List<Review> pendingList = repo.findByStatus("PENDING");

            request.setAttribute("applications", pendingList);
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("/WEB-INF/StaffManage/applyJobList.jsp").forward(request, response);
    }
}
