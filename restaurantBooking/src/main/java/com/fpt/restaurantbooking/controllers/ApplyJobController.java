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

import static java.lang.System.out;

//servlet customer gửi đơn xin đến cho admin

@WebServlet(name = "apply-job", urlPatterns = {"/apply-job"})
public class ApplyJobController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/StaffManage/applyJob.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

//        User currentUser = (User) request.getSession().getAttribute("currentUser");
//        if (currentUser == null || !"CUSTOMER".equalsIgnoreCase(currentUser.getRole())) {
//            response.sendRedirect("home.jsp");
//            return;
//        }

//        String comment = request.getParameter("comment");
//
//        try (Connection conn = DatabaseUtil.getConnection()) {
//            ReviewRepositoryImpl repo = new ReviewRepositoryImpl(conn);
//
//            Review review = new Review();
//            review.setUserId(currentUser.getUserId());
//            review.setReservationId(0); // không dùng đặt bàn, chỉ để tạm
//            review.setRating(0);
//            review.setComment(comment);
//            review.setStatus("PENDING");
//            review.setCreatedAt(LocalDateTime.now());
//            review.setUpdatedAt(null);
//
//            repo.save(review);
//
//            request.setAttribute("message", "Đơn xin việc của bạn đã được gửi thành công!");
//        } catch (Exception e) {
//            e.printStackTrace();
//            request.setAttribute("message", "Có lỗi xảy ra khi gửi đơn!");
//        }
//
//        request.getRequestDispatcher("/WEB-INF/StaffManage/applyJob.jsp").forward(request, response);
    }
}
