package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.models.User;
import com.fpt.restaurantbooking.repositories.UserRepository;
import com.fpt.restaurantbooking.repositories.impl.UserRepositoryImpl;
import com.fpt.restaurantbooking.services.UserService;
import com.fpt.restaurantbooking.services.impl.UserServiceImpl;
import com.fpt.restaurantbooking.utils.DatabaseUtil;
import com.fpt.restaurantbooking.utils.ToastHelper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;

@WebServlet(name = "ChangePasswordController", urlPatterns = {"/change-password"})
public class ChangePasswordController extends BaseController {

    private UserService userService;

    public void init() throws ServletException {
        try {
            // Initialize dependencies manually
            Connection connection = DatabaseUtil.getConnection();
            UserRepository userRepository = new UserRepositoryImpl(connection);
            
            this.userService = new UserServiceImpl(userRepository, null, null, null);
        } catch (Exception e) {
            throw new ServletException("Failed to initialize ChangePasswordController", e);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check if user is logged in
        User currentUser = (User) request.getSession().getAttribute("currentUser");
        if (currentUser == null) {
            ToastHelper.addErrorToast(request, "Vui lòng đăng nhập để thay đổi mật khẩu.");
            redirectTo(response, request.getContextPath() + "/login");
            return;
        }
        
        forwardToPage(request, response, "/WEB-INF/views/auth/change-password.jsp");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check if user is logged in
        User currentUser = (User) request.getSession().getAttribute("currentUser");
        if (currentUser == null) {
            ToastHelper.addErrorToast(request, "Vui lòng đăng nhập để thay đổi mật khẩu.");
            redirectTo(response, request.getContextPath() + "/login");
            return;
        }
        
        handleChangePassword(request, response);
    }

    /**
     * Handle change password form submission
     */
    private void handleChangePassword(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validate inputs
        if (currentPassword == null || currentPassword.trim().isEmpty()) {
            ToastHelper.addErrorToast(request, "Vui lòng nhập mật khẩu hiện tại.");
            redirectTo(response, request.getContextPath() + "/change-password");
            return;
        }
        
        if (newPassword == null || newPassword.trim().isEmpty()) {
            ToastHelper.addErrorToast(request, "Vui lòng nhập mật khẩu mới.");
            redirectTo(response, request.getContextPath() + "/change-password");
            return;
        }
        
        if (newPassword.length() < 6) {
            ToastHelper.addErrorToast(request, "Mật khẩu mới phải có ít nhất 6 ký tự.");
            redirectTo(response, request.getContextPath() + "/change-password");
            return;
        }
        
        if (!newPassword.equals(confirmPassword)) {
            ToastHelper.addErrorToast(request, "Mật khẩu xác nhận không khớp.");
            redirectTo(response, request.getContextPath() + "/change-password");
            return;
        }

        try {
            // Get current user from session
            User currentUser = (User) request.getSession().getAttribute("currentUser");
            
            // Verify current password
            if (!userService.verifyPassword(currentPassword, currentUser.getPassword())) {
                ToastHelper.addErrorToast(request, "Mật khẩu hiện tại không đúng.");
                redirectTo(response, request.getContextPath() + "/change-password");
                return;
            }
            
            // Update password using the service method that handles current password verification
            boolean passwordUpdated = userService.updatePassword(currentUser.getUserId().longValue(), currentPassword, newPassword);
            
            if (passwordUpdated) {
                ToastHelper.addSuccessToast(request, "Mật khẩu của bạn đã được thay đổi thành công!");
                redirectTo(response, request.getContextPath() + "/profile");
            } else {
                ToastHelper.addErrorToast(request, "Có lỗi xảy ra khi thay đổi mật khẩu.");
                redirectTo(response, request.getContextPath() + "/change-password");
            }
            
        } catch (Exception e) {
            ToastHelper.addErrorToast(request, "Có lỗi xảy ra khi thay đổi mật khẩu. Vui lòng thử lại sau.");
            redirectTo(response, request.getContextPath() + "/change-password");
        }
    }
}