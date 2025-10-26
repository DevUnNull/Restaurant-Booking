package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.models.User;
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

import java.io.IOException;
import java.sql.SQLException;

import java.util.logging.Logger;


/**
 * Controller for handling user registration
 */
@WebServlet(name = "RegisterController", urlPatterns = {"/register"})
public class RegisterController extends BaseController {
    private UserService userService;
    private static final Logger logger = Logger.getLogger(RegisterController.class.getName());
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
            throw new ServletException("Failed to initialize RegisterController", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Forward to registration page using BaseController method
        forwardToPage(request, response, "/WEB-INF/views/auth/register.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        action = (action != null) ? action : "register";

        switch (action) {
            case "register":
                handleRegistration(request, response);
                break;
            default:
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\": false, \"message\": \"Invalid action\"}");
                break;
        }
    }

    /**
     * Handle user registration
     */
    private void handleRegistration(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Get registration parameters
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phoneNumber = request.getParameter("phoneNumber");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");
            String dateOfBirthStr = request.getParameter("dateOfBirth");
            String gender = request.getParameter("gender");

            // Set default values if null
            fullName = (fullName != null) ? fullName : "";
            email = (email != null) ? email : "";
            phoneNumber = (phoneNumber != null) ? phoneNumber : "";
            password = (password != null) ? password : "";
            confirmPassword = (confirmPassword != null) ? confirmPassword : "";

            // Validate input
            if (fullName.trim().isEmpty() || email.trim().isEmpty() ||
                    phoneNumber.trim().isEmpty() || password.trim().isEmpty()) {
                ToastHelper.addErrorToast(request, "Vui lòng điền đầy đủ thông tin");
                forwardToPage(request, response, "/WEB-INF/views/auth/register.jsp");
                return;
            }

            // Check password confirmation
            if (!password.equals(confirmPassword)) {
                ToastHelper.addErrorToast(request, "Mật khẩu xác nhận không khớp");
                forwardToPage(request, response, "/WEB-INF/views/auth/register.jsp");
                return;
            }

            // Check if email already exists
            if (userService.findByEmail(email).isPresent()) {
                ToastHelper.addErrorToast(request, "Email đã được sử dụng");
                forwardToPage(request, response, "/WEB-INF/views/auth/register.jsp");
                return;
            }

            // Create new user

            newUser.setFullName(fullName);
            newUser.setEmail(email);
            newUser.setPhoneNumber(phoneNumber);
            // Password will be hashed in service layer
            newUser.setRoleId(3); // Default role for customer
            newUser.setStatus("PENDING"); // Pending email verification

            if (dateOfBirthStr != null && !dateOfBirthStr.isEmpty()) {
                newUser.setDateOfBirth(java.time.LocalDate.parse(dateOfBirthStr));
            }
            newUser.setGender(gender);

            // Register user (OTP đã được gửi trong service.register)

            User registeredUser = userService.register(newUser, password);

            if (registeredUser != null) {
                // Redirect directly to OTP verification page with email parameter
                redirectTo(response, request.getContextPath() + "/email-verification?email=" + email + "&fromRegister=true");
            } else {
                ToastHelper.addErrorToast(request, "Đăng ký thất bại. Vui lòng thử lại.");
                forwardToPage(request, response, "/WEB-INF/views/auth/register.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            ToastHelper.addErrorToast(request, "Có lỗi xảy ra. Vui lòng thử lại. + "+ newUser.toString());
            forwardToPage(request, response, "/WEB-INF/views/auth/register.jsp");
        }
    }
}