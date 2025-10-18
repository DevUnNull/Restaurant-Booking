package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.models.User;
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

        String userIdStr = request.getParameter("userId");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phoneNumber");
        String gender = request.getParameter("gender");
        String dateOfBirthStr = request.getParameter("dateOfBirth");
        String status = request.getParameter("status");

        String search = request.getParameter("search");
        String pageStr = request.getParameter("page");
        int page = (pageStr != null && !pageStr.isEmpty()) ? Integer.parseInt(pageStr) : 1;
        int offset = (page - 1) * PAGE_SIZE;

        if (userIdStr == null || userIdStr.isEmpty()) {
            request.setAttribute("message", "Không tìm thấy ID nhân viên.");
            request.getRequestDispatcher("/WEB-INF/StaffManage/EmployeeList.jsp").forward(request, response);
            return;
        }

        int userId = Integer.parseInt(userIdStr);

        try (Connection connection = DatabaseUtil.getConnection()) {
            UserRepositoryImpl userRepo = new UserRepositoryImpl(connection);

            User user = userRepo.findById((long) userId).orElse(null);
            if (user == null) {
                request.setAttribute("message", "Không tìm thấy nhân viên có ID: " + userId);
                request.getRequestDispatcher("/WEB-INF/StaffManage/EmployeeList.jsp").forward(request, response);
                return;
            }

            user.setFullName(fullName);
            user.setEmail(email);
            user.setPhoneNumber(phone);
            user.setGender(gender);
            user.setStatus(status);

            if (dateOfBirthStr != null && !dateOfBirthStr.isEmpty()) {
                try {
                    LocalDate dateOfBirth = LocalDate.parse(dateOfBirthStr);
                    user.setDateOfBirth(dateOfBirth);
                } catch (Exception e) {
                    System.out.println("⚠️ Lỗi định dạng ngày sinh: " + e.getMessage());
                }
            }

            userRepo.update1(user);

            List<User> employees;
            long totalEmployees;

            if (search != null && !search.trim().isEmpty()) {
                employees = userRepo.searchEmployees(search, offset, PAGE_SIZE);
                totalEmployees = userRepo.countSearchEmployees(search);
            } else {
                employees = userRepo.findEmployeesByPage(offset, PAGE_SIZE);
                totalEmployees = userRepo.count();
            }

            int totalPages = (int) Math.ceil((double) totalEmployees / PAGE_SIZE);

            request.setAttribute("employees", employees);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("search", search);
            request.setAttribute("successMessage", "Cập nhật thông tin nhân viên thành công!");

            request.getRequestDispatcher("/WEB-INF/StaffManage/EmployeeList.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Có lỗi xảy ra khi cập nhật: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/StaffManage/EmployeeList.jsp").forward(request, response);
        }
    }
}
