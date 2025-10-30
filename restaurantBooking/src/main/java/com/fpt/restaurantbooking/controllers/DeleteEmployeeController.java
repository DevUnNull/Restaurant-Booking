package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.repositories.impl.UserDao;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(name = "DeleteEmployee", urlPatterns = {"/DeleteEmployee"})
public class DeleteEmployeeController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userIdStr = request.getParameter("userId");
        UserDao userDao = new UserDao();

        try {
            int userId = Integer.parseInt(userIdStr);
            boolean success = userDao.softDeleteUser(userId);

            if (success) {
                request.getSession().setAttribute("message", "Đã xóa nhân viên thành công.");
            } else {
                request.getSession().setAttribute("error", "Không thể xóa nhân viên này.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Lỗi khi xóa nhân viên.");
        }

        response.sendRedirect(request.getContextPath() + "/EmployeeList");
    }
}
