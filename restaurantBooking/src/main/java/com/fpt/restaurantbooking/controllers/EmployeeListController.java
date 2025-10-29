package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.models.User;
import com.fpt.restaurantbooking.repositories.impl.UserDao;
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

    private static final int PAGE_SIZE = 10; // Số nhân viên mỗi trang

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Nhận các tham số từ form
        String search = request.getParameter("search");
        String gender = request.getParameter("gender");
        String status = request.getParameter("status");

        // Xử lý phân trang
        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        // Kết nối DB và lấy danh sách nhân viên
        DatabaseUtil db = new DatabaseUtil();
        List<User> employees = new ArrayList<>();
        int totalPages = 1;

        try (Connection conn = db.getConnection()) {
            UserDao userDao = new UserDao();

            // Gọi hàm tìm kiếm (lọc theo search, gender, status)
            List<User> allStaff = userDao.searchEmployees(search, gender, status);

            int totalRecords = allStaff.size();
            totalPages = (int) Math.ceil((double) Math.max(totalRecords, 1) / PAGE_SIZE);

            // Clamp page trong giới hạn [1, totalPages]
            if (page < 1) page = 1;
            if (page > totalPages) page = totalPages;

            // Tính fromIndex/toIndex an toàn
            int fromIndex = (page - 1) * PAGE_SIZE;
            if (fromIndex < 0) fromIndex = 0;
            int toIndex = Math.min(fromIndex + PAGE_SIZE, totalRecords);

            // Lấy sublist nếu có phần tử, ngược lại trả list rỗng
            if (totalRecords == 0) {
                employees = new ArrayList<>();
            } else {
                employees = allStaff.subList(fromIndex, toIndex);
            }

            // Exception khi ko tìm thấy
            if (employees == null || employees.isEmpty()) {
                request.setAttribute("message", "Không tìm thấy nhân viên phù hợp.");
            }

            // Gửi dữ liệu sang JSP
            request.setAttribute("employees", employees);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("search", search);
            request.setAttribute("gender", gender);
            request.setAttribute("status", status);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể tải danh sách nhân viên.");
        }

        // Forward đến trang JSP
        request.getRequestDispatcher("/WEB-INF/StaffManage/EmployeeList.jsp").forward(request, response);
    }
}
