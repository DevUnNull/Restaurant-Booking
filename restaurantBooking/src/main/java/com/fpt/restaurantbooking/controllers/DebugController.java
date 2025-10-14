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

@WebServlet(name = "Debug", urlPatterns = {"/Debug"})
public class DebugController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/StaffManage/Debug.jsp").forward(request, response);
    }
}
