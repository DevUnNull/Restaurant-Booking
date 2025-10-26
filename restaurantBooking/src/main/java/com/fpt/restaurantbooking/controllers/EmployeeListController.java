package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.models.User;
import com.fpt.restaurantbooking.repositories.impl.UserRepositoryImpl;
import com.fpt.restaurantbooking.utils.DatabaseUtil;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "EmployeeList", urlPatterns = {"/EmployeeList"})
public class EmployeeListController extends HttpServlet {

    private static final int PAGE_SIZE = 10; // số nhân viên mỗi trang

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("search");
        int page = 1;

        // Lấy số trang từ request (nếu có)
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException ignored) {}
        }

        List<User> employees = new ArrayList<>();
        long totalEmployees = 0;

        try (Connection connection = DatabaseUtil.getConnection()) {
            UserRepositoryImpl userRepo = new UserRepositoryImpl(connection);
            int offset = (page - 1) * PAGE_SIZE;

            if (keyword != null && !keyword.trim().isEmpty()) {
                // Nếu có từ khóa tìm kiếm
//                employees = userRepo.searchEmployees(keyword.trim(), offset, PAGE_SIZE);
//                totalEmployees = userRepo.countSearchEmployees(keyword.trim());
            } else {
                // Nếu không có từ khóa lấy toàn bộ nhân viên
                employees.addAll(userRepo.findByRole(User.UserRole.STAFF));
                employees.addAll(userRepo.findByRole(User.UserRole.ADMIN));
                totalEmployees = employees.size();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        // Kiểm tra nếu không có kết quả
        if (employees.isEmpty()) {
            request.setAttribute("message", "Không tìm thấy nhân viên nào phù hợp!");
        }

        int totalPages = (int) Math.ceil((double) totalEmployees / PAGE_SIZE);

        // Gửi dữ liệu sang JSP
        request.setAttribute("employees", employees);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("search", keyword);

        request.getRequestDispatcher("/WEB-INF/StaffManage/EmployeeList.jsp").forward(request, response);
    }
}


