package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.models.User;
import com.fpt.restaurantbooking.repositories.impl.UserDao;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "CustomerListController", value = "/CustomerList")
public class CustomerListController extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserDao dao = new UserDao();

        // Nhận tham số tìm kiếm
        String keyword = request.getParameter("keyword");
        if (keyword == null) keyword = "";

        // Nhận tham số trang hiện tại
        int page = 1;
        int recordsPerPage = 10; // số bản ghi mỗi trang
        if (request.getParameter("page") != null) {
            page = Integer.parseInt(request.getParameter("page"));
        }

        // Lấy danh sách user có phân trang và tìm kiếm
        List<User> list = dao.getUsersByRoleWithPagination(3, keyword, (page - 1) * recordsPerPage, recordsPerPage);
        int totalRecords = dao.countUsersByRole(3, keyword);
        int totalPages = (int) Math.ceil(totalRecords * 1.0 / recordsPerPage);

        request.setAttribute("customer", list);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("keyword", keyword);

        request.getRequestDispatcher("/WEB-INF/StaffManage/AddEmployee.jsp").forward(request, response);
    }
}

