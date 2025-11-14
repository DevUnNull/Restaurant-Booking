package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.repositories.EmailVerificationRepository;
import com.fpt.restaurantbooking.repositories.UserRepository;
import com.fpt.restaurantbooking.repositories.impl.EmailVerificationRepositoryImpl;
import com.fpt.restaurantbooking.repositories.impl.UserRepositoryImpl;
import com.fpt.restaurantbooking.services.EmailService;
import com.fpt.restaurantbooking.services.OTPService;
import com.fpt.restaurantbooking.services.UserService;
import com.fpt.restaurantbooking.services.impl.UserServiceImpl;
import com.fpt.restaurantbooking.utils.DatabaseUtil;
import com.fpt.restaurantbooking.utils.ToastHelper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;


@WebServlet(name = "LoginController", urlPatterns = {"/login", "/logout"})
public class LoginController extends BaseController {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        try {
            // Initialize dependencies manually
            UserRepository userRepository = new UserRepositoryImpl(DatabaseUtil.getConnection());
            EmailVerificationRepository emailVerificationRepository = new EmailVerificationRepositoryImpl(DatabaseUtil.getConnection());
            OTPService otpService = new OTPService(emailVerificationRepository);
            EmailService emailService = new EmailService();
            this.userService = new UserServiceImpl(userRepository, emailVerificationRepository, otpService, emailService);
        } catch (SQLException e) {
            throw new ServletException("Failed to initialize LoginController", e);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        if ("/login".equals(path)) {
            // Forward to login page using BaseController method
            forwardToPage(request, response, "/WEB-INF/views/auth/login.jsp");
        } else if ("/logout".equals(path)) {
            handleLogout(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        if ("/login".equals(path)) {
            handleLogin(request, response);
        }
    }

    /**
     * Handle login form submission
     * This demonstrates the pattern you want: show toast after redirect
     */
    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("rememberMe");
        String redirect = request.getParameter("redirect");

        try {
            // Authenticate user by email only
            var userOptional = userService.authenticate(email, password);

            if (userOptional.isPresent()) {
                var user = userOptional.get();

                // Check user status
                if ("PENDING".equals(user.getStatus())) {
                    // Store user info in session for OTP verification
                    HttpSession session = request.getSession();
                    session.setAttribute("userId", user.getUserId());
                    session.setAttribute("userEmail", user.getEmail());

                    // Redirect to OTP verification page using BaseController method
                    redirectTo(response, request.getContextPath() + "/email-verification?email=" + user.getEmail() + "&fromRegister=true");
                    return;
                } else if ("INACTIVE".equals(user.getStatus())) {
                    // Account is inactive
                    ToastHelper.addErrorToast(request, "Tài khoản của bạn đã bị khóa. Vui lòng liên hệ hỗ trợ.");
                    redirectTo(response, request.getContextPath() + "/login");
                    return;
                }

                // Active user - proceed with normal login
                HttpSession session = request.getSession();
                // Set the current user for header display
                setCurrentUser(request, user);
                session.setAttribute("userId", user.getUserId());
                session.setAttribute("userRole", user.getRoleId());

                // Add success toast
                ToastHelper.addSuccessToast(request, "Đăng nhập thành công!");

                // Handle redirect after successful login
                if (redirect != null && !redirect.trim().isEmpty()) {
                    try {
                        // URL decode the redirect parameter
                        String decodedRedirect = URLDecoder.decode(redirect, StandardCharsets.UTF_8.name());
                        // Ensure the redirect path starts with /
                        if (!decodedRedirect.startsWith("/")) {
                            decodedRedirect = "/" + decodedRedirect;
                        }
                        redirectTo(response, request.getContextPath() + decodedRedirect);
                    } catch (Exception e) {
                        // If decoding fails, redirect to home page
                        redirectTo(response, request.getContextPath() + "/");
                    }
                } else {
                    // No redirect parameter, go to home page
                    redirectTo(response, request.getContextPath() + "/");
                }
            } else {
                // Invalid credentials
                ToastHelper.addErrorToast(request, "Tên đăng nhập hoặc mật khẩu không đúng!");
                redirectTo(response, request.getContextPath() + "/login");
            }
        } catch (Exception e) {
            ToastHelper.addErrorToast(request, "Đã xảy ra lỗi khi đăng nhập. Vui lòng thử lại!");
            redirectTo(response, request.getContextPath() + "/login");
        }
    }

    /**
     * Handle logout
     * Another example of toast after redirect
     */
    private void handleLogout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        redirectTo(response, request.getContextPath() + "/login");
    }

    /**
     * Simulate login validation
     * In real application, this would check against database
     */
    private boolean isValidLogin(String username, String password) {
        // Simple validation for demo
        return username != null && password != null &&
                username.length() > 0 && password.length() > 0 &&
                !username.equals("invalid");
    }
}