package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.models.User;
import com.fpt.restaurantbooking.repositories.impl.UserDao;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/view-employee-detail")
public class ViewEmployeeDetailController extends HttpServlet {
    private UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int userId = Integer.parseInt(req.getParameter("id"));
        User user = userDao.getUserById(userId);

        System.out.println("DEBUG userId: " + userId);

        req.setAttribute("userDetail", user);
        req.getRequestDispatcher("WEB-INF/StaffManage/employeeDetail.jsp").forward(req, resp);
    }

}

