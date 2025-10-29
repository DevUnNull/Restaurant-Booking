package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.models.User;
import com.fpt.restaurantbooking.repositories.impl.UserDao;
import com.fpt.restaurantbooking.repositories.impl.UserRepositoryImpl;
import com.fpt.restaurantbooking.utils.DatabaseUtil;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "UpdateEmployee", urlPatterns = {"/UpdateEmployee"})
public class UpdateEmployee extends HttpServlet{
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            String fullName = request.getParameter("fullName");
            String gender = request.getParameter("gender");
            String email = request.getParameter("email");
            String phoneNumber = request.getParameter("phoneNumber");
            String status = request.getParameter("status");

            // Tạo đối tượng user để cập nhật
            User user = new User();
            user.setUserId(userId);
            user.setFullName(fullName);
            user.setGender(gender);
            user.setEmail(email);
            user.setPhoneNumber(phoneNumber);
            user.setStatus(status);

            UserDao userDao = new UserDao();
            boolean updated = userDao.updateUser(user);

            if (updated) {
                request.getSession().setAttribute("message", "Cập nhật nhân viên thành công!");
            } else {
                request.getSession().setAttribute("error", "Không thể cập nhật nhân viên!");
            }

            // Quay lại trang danh sách
            response.sendRedirect(request.getContextPath() + "/EmployeeList");

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Đã xảy ra lỗi khi cập nhật nhân viên!");
            response.sendRedirect(request.getContextPath() + "/EmployeeList");
        }
    }
}
