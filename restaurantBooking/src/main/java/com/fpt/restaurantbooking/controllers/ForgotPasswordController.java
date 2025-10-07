package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.models.EmailVerification;
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
import com.fpt.restaurantbooking.utils.EmailUtil;
import com.fpt.restaurantbooking.utils.ToastHelper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.util.Optional;
import java.util.UUID;

@WebServlet(name = "ForgotPasswordController", urlPatterns = {"/forgot-password", "/reset-password"})
public class ForgotPasswordController extends BaseController {

    private UserService userService;
    private EmailService emailService;
    private EmailVerificationRepository emailVerificationRepository;

    @Override
    public void init() throws ServletException {
        try {
            // Initialize dependencies manually
            Connection connection = DatabaseUtil.getConnection();
            UserRepository userRepository = new UserRepositoryImpl(connection);
            EmailVerificationRepository emailVerificationRepository = new EmailVerificationRepositoryImpl(connection);
            OTPService otpService = new OTPService(emailVerificationRepository);
            EmailService emailService = new EmailService();
            
            this.userService = new UserServiceImpl(userRepository, emailVerificationRepository, otpService, emailService);
            this.emailService = emailService;
            this.emailVerificationRepository = emailVerificationRepository;
        } catch (Exception e) {
            throw new ServletException("Failed to initialize ForgotPasswordController", e);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String path = request.getServletPath();
        
        switch (path) {
            case "/forgot-password":
                showForgotPasswordPage(request, response);
                break;
            case "/reset-password":
                showResetPasswordPage(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String path = request.getServletPath();
        
        switch (path) {
            case "/forgot-password":
                handleForgotPassword(request, response);
                break;
            case "/reset-password":
                handleResetPassword(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    /**
     * Show forgot password page
     */
    private void showForgotPasswordPage(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        forwardToPage(request, response, "/WEB-INF/views/auth/forgot-password.jsp");
    }

    /**
     * Show reset password page with token validation
     */
    private void showResetPasswordPage(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String token = request.getParameter("token");
        
        if (token == null || token.trim().isEmpty()) {
            ToastHelper.addErrorToast(request, "Liên kết đặt lại mật khẩu không hợp lệ.");
            redirectTo(response, request.getContextPath() + "/forgot-password");
            return;
        }

        try {
            // Find email verification by reset token
            Optional<EmailVerification> verificationOpt = emailVerificationRepository.findByResetToken(token);
            
            if (verificationOpt.isPresent()) {
                EmailVerification verification = verificationOpt.get();
                
                // Check if verification is still valid (not expired)
                if (verification.isExpired()) {
                    ToastHelper.addErrorToast(request, "Liên kết đặt lại mật khẩu đã hết hạn.");
                    redirectTo(response, request.getContextPath() + "/forgot-password");
                    return;
                }
                
                // Find user by user ID from verification
                Optional<User> userOpt = userService.findById(verification.getUserId().longValue());
                
                if (userOpt.isPresent()) {
                    User user = userOpt.get();
                    request.setAttribute("token", token);
                    request.setAttribute("email", user.getEmail());
                    forwardToPage(request, response, "/WEB-INF/views/auth/reset-password.jsp");
                } else {
                    ToastHelper.addErrorToast(request, "Không tìm thấy người dùng.");
                    redirectTo(response, request.getContextPath() + "/forgot-password");
                }
            } else {
                ToastHelper.addErrorToast(request, "Liên kết đặt lại mật khẩu đã hết hạn hoặc không hợp lệ.");
                redirectTo(response, request.getContextPath() + "/forgot-password");
            }
        } catch (Exception e) {
            ToastHelper.addErrorToast(request, "Có lỗi xảy ra khi xác thực liên kết đặt lại mật khẩu.");
            redirectTo(response, request.getContextPath() + "/forgot-password");
        }
    }

    /**
     * Handle forgot password form submission
     */
    private void handleForgotPassword(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        
        // Validate email
        if (email == null || email.trim().isEmpty()) {
            ToastHelper.addErrorToast(request, "Vui lòng nhập địa chỉ email.");
            redirectTo(response, request.getContextPath() + "/forgot-password");
            return;
        }
        
        // Basic email format validation
        if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
            ToastHelper.addErrorToast(request, "Địa chỉ email không hợp lệ.");
            redirectTo(response, request.getContextPath() + "/forgot-password");
            return;
        }

        try {
            // Check if user exists
            Optional<User> userOpt = userService.findByEmail(email);
            
            if (userOpt.isPresent()) {
                User user = userOpt.get();
                
                // Generate password reset token
                String resetToken = UUID.randomUUID().toString();
                
                // Create EmailVerification record with reset token
                EmailVerification verification = new EmailVerification();
                verification.setUserId(user.getUserId().longValue());
                verification.setResetToken(resetToken);
                verification.setOtpCode("RESET"); // Set a default OTP code for password reset
                verification.setStatus("PENDING");
                verification.setExpirationTime(java.time.LocalDateTime.now().plusHours(24)); // 24 hours expiration
                
                // Save the verification record
                EmailVerification savedVerification = emailVerificationRepository.save(verification);
                
                if (savedVerification != null) {
                    // Send password reset email
                    boolean emailSent = EmailUtil.sendPasswordResetEmail(
                        user.getEmail(), 
                        user.getFullName(), 
                        resetToken
                    );
                    
                    if (emailSent) {
                        // Show success message but don't reveal if email exists
                        ToastHelper.addSuccessToast(request, "Chúng tôi đã gửi liên kết đặt lại mật khẩu đến địa chỉ email của bạn nếu tài khoản tồn tại.");
                    } else {
                        ToastHelper.addErrorToast(request, "Có lỗi xảy ra khi gửi email. Vui lòng thử lại sau.");
                    }
                } else {
                    ToastHelper.addErrorToast(request, "Có lỗi xảy ra khi tạo liên kết đặt lại mật khẩu.");
                }
            } else {
                // Don't reveal that email doesn't exist - show same message
                ToastHelper.addSuccessToast(request, "Chúng tôi đã gửi liên kết đặt lại mật khẩu đến địa chỉ email của bạn nếu tài khoản tồn tại.");
            }
            
            // Redirect to login page
            redirectTo(response, request.getContextPath() + "/login");
            
        } catch (Exception e) {
            ToastHelper.addErrorToast(request, "Có lỗi xảy ra khi xử lý yêu cầu. Vui lòng thử lại sau.");
            redirectTo(response, request.getContextPath() + "/forgot-password");
        }
    }

    /**
     * Handle reset password form submission
     */
    private void handleResetPassword(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String token = request.getParameter("token");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validate inputs
        if (token == null || token.trim().isEmpty()) {
            ToastHelper.addErrorToast(request, "Liên kết đặt lại mật khẩu không hợp lệ.");
            redirectTo(response, request.getContextPath() + "/forgot-password");
            return;
        }
        
        if (newPassword == null || newPassword.trim().isEmpty()) {
            ToastHelper.addErrorToast(request, "Vui lòng nhập mật khẩu mới.");
            redirectTo(response, request.getContextPath() + "/reset-password?token=" + token);
            return;
        }
        
        if (newPassword.length() < 6) {
            ToastHelper.addErrorToast(request, "Mật khẩu phải có ít nhất 6 ký tự.");
            redirectTo(response, request.getContextPath() + "/reset-password?token=" + token);
            return;
        }
        
        if (!newPassword.equals(confirmPassword)) {
            ToastHelper.addErrorToast(request, "Mật khẩu xác nhận không khớp.");
            redirectTo(response, request.getContextPath() + "/reset-password?token=" + token);
            return;
        }

        try {
            // Find email verification by reset token
            Optional<EmailVerification> verificationOpt = emailVerificationRepository.findByResetToken(token);
            
            if (verificationOpt.isPresent()) {
                EmailVerification verification = verificationOpt.get();
                
                // Check if verification is still valid (not expired)
                if (verification.isExpired()) {
                    ToastHelper.addErrorToast(request, "Liên kết đặt lại mật khẩu đã hết hạn.");
                    redirectTo(response, request.getContextPath() + "/forgot-password");
                    return;
                }
                
                // Find user by user ID from verification
                Optional<User> userOpt = userService.findById(verification.getUserId().longValue());
                
                if (userOpt.isPresent()) {
                    User user = userOpt.get();
                    
                    // Update password using the new password from the form
                    String hashedPassword = userService.hashPassword(newPassword);
                    boolean passwordUpdated = userService.getUserRepository().updatePassword(user.getUserId().longValue(), hashedPassword);
                    
                    if (passwordUpdated) {
                        // Mark verification as completed
                        verification.setStatus("COMPLETED");
                        emailVerificationRepository.update(verification);
                        
                        ToastHelper.addSuccessToast(request, "Mật khẩu của bạn đã được đặt lại thành công!");
                        redirectTo(response, request.getContextPath() + "/login");
                    } else {
                        ToastHelper.addErrorToast(request, "Có lỗi xảy ra khi đặt lại mật khẩu.");
                        redirectTo(response, request.getContextPath() + "/reset-password?token=" + token);
                    }
                } else {
                    ToastHelper.addErrorToast(request, "Không tìm thấy người dùng.");
                    redirectTo(response, request.getContextPath() + "/forgot-password");
                }
            } else {
                ToastHelper.addErrorToast(request, "Liên kết đặt lại mật khẩu đã hết hạn hoặc không hợp lệ.");
                redirectTo(response, request.getContextPath() + "/forgot-password");
            }
            
        } catch (Exception e) {
            ToastHelper.addErrorToast(request, "Có lỗi xảy ra khi đặt lại mật khẩu.");
            redirectTo(response, request.getContextPath() + "/reset-password?token=" + token);
        }
    }

    /**
     * Update user's verification token in database
     */
    private boolean updateUserVerificationToken(Long userId, String token) {
        try {
            // This would typically be implemented in UserRepository
            // For now, we'll use a placeholder implementation
            // In a real implementation, you would add this method to UserRepository
            return true; // Placeholder
        } catch (Exception e) {
            return false;
        }
    }
}