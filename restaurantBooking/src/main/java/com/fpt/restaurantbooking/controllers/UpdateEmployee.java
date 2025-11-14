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
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "UpdateEmployee", urlPatterns = {"/UpdateEmployee"})
public class UpdateEmployee extends HttpServlet{
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        List<User> employees = new ArrayList<>();
//        // Lấy dữ liệu từ form popup
//        String userIdStr = request.getParameter("userId");
//        String fullName = request.getParameter("fullName");
//        String email = request.getParameter("email");
//        String phone = request.getParameter("phoneNumber");
//        String status = request.getParameter("status");
//
//        if (userIdStr == null || userIdStr.isEmpty()) {
//            request.setAttribute("message", "Không tìm thấy ID nhân viên.");
//            request.getRequestDispatcher("/WEB-INF/StaffManage/EmployeeList.jsp").forward(request, response);
//            return;
//        }
//
//        int userId = Integer.parseInt(userIdStr);
//
//        try (Connection connection = DatabaseUtil.getConnection()) {
//            UserRepositoryImpl userRepo = new UserRepositoryImpl(connection);
//
//            // Lấy thông tin nhân viên hiện tại từ DB
//            User user = userRepo.findById((long) userId)
//                    .orElse(null);
//
//            if (user == null) {
//                request.setAttribute("message", "Không tìm thấy nhân viên có ID: " + userId);
//                request.getRequestDispatcher("/WEB-INF/StaffManage/EmployeeList.jsp").forward(request, response);
//                return;
//            }
//
//            // Cập nhật thông tin mới
//            user.setFullName(fullName);
//            user.setEmail(email);
//            user.setPhoneNumber(phone);
//            user.setStatus(status);
//
//            // Cập nhật DB
//            userRepo.update(user);
//
//            employees.addAll(userRepo.findByRole(User.UserRole.STAFF));
//            employees.addAll(userRepo.findByRole(User.UserRole.ADMIN));
//            request.setAttribute("employees", employees);
//
//            // Gửi thông báo và quay lại danh sách
//            request.setAttribute("successMessage", "Cập nhật thông tin nhân viên thành công!");
//            request.getRequestDispatcher("/WEB-INF/StaffManage/EmployeeList.jsp").forward(request, response);
//
//        } catch (Exception e) {
//            e.printStackTrace();
//            request.setAttribute("message", "Có lỗi xảy ra khi cập nhật: " + e.getMessage());
//            request.getRequestDispatcher("/WEB-INF/StaffManage/EmployeeList.jsp").forward(request, response);
//        }
//    }

    private static final int PAGE_SIZE = 10; // Số nhân viên mỗi trang

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

            response.sendRedirect(request.getContextPath() + "/EmployeeList");

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Đã xảy ra lỗi khi cập nhật nhân viên!");
            response.sendRedirect(request.getContextPath() + "/EmployeeList");
        }
    }
}
