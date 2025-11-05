package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.repositories.impl.UserDao;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
@WebServlet(name = "AddEmployeeController", value = "/AddEmployee")
public class AddEmployeeController extends HttpServlet {

    private final UserDao dao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam != null) {
            int userId = Integer.parseInt(idParam);
            boolean success = addEmployee(userId);

            if (success) {
                request.getSession().setAttribute("message", "Thêm nhân viên thành công!");
            } else {
                request.getSession().setAttribute("message", "Thêm nhân viên thất bại!");
            }
        }

        // Quay lại trang danh sách khách hàng
        response.sendRedirect(request.getContextPath() + "/CustomerList");
    }

    private boolean addEmployee(int userId) {
        try {
            dao.updateRole(userId, 2); // 2 = STAFF
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}

