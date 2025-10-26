package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.models.User;
import com.fpt.restaurantbooking.services.UserService;
import com.fpt.restaurantbooking.repositories.impl.UserRepositoryImpl;
import com.fpt.restaurantbooking.repositories.UserRepository;

import com.fpt.restaurantbooking.services.impl.UserServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "ChangePasswordController", urlPatterns = {"/change-password"})
public class ChangePasswordController extends BaseController {

    private final UserService userService;

    public ChangePasswordController() {
        UserRepository userRepository = new UserRepositoryImpl();
        this.userService = new UserServiceImpl(userRepository);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        forwardToPage(request, response, "/WEB-INF/views/customer/change-password.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User currentUser = (User) session.getAttribute("currentUser");
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        String message;
        boolean success;

        try {
            if (!newPassword.equals(confirmPassword)) {
                throw new Exception("Mật khẩu mới không khớp!");
            }

            boolean changed = userService.changePassword(currentUser.getUserId(), currentPassword, newPassword);

            if (changed) {
                message = "Đổi mật khẩu thành công!";
                success = true;
            } else {
                throw new Exception("Mật khẩu hiện tại không đúng!");
            }
        } catch (Exception e) {
            message = "Lỗi: " + e.getMessage();
            success = false;
        }

        request.setAttribute("message", message);
        request.setAttribute("success", success);
        doGet(request, response);
    }
}