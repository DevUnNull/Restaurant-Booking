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
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.util.Optional;

@WebServlet(name = "EmailVerificationController", urlPatterns = {
        "/email-verification",
        "/verify-otp",
        "/resend-otp",
        "/check-verification-status"
})
public class EmailVerificationController extends BaseController {

    private UserService userService;
    private Gson gson;

    public void init() throws ServletException {
        try {
            // Initialize dependencies manually
            Connection connection = DatabaseUtil.getConnection();
            UserRepository userRepository = new UserRepositoryImpl(connection);
            EmailVerificationRepository emailVerificationRepository = new EmailVerificationRepositoryImpl(connection);
            OTPService otpService = new OTPService(emailVerificationRepository);
            EmailService emailService = new EmailService();

            this.userService = new UserServiceImpl(userRepository, emailVerificationRepository, otpService, emailService);
            this.gson = new Gson();
        } catch (Exception e) {
            throw new ServletException("Failed to initialize EmailVerificationController", e);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        switch (path) {
            case "/email-verification":
                showEmailVerificationPage(request, response);
                break;
            case "/check-verification-status":
                checkVerificationStatus(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        switch (path) {
            case "/verify-otp":
                handleOTPVerification(request, response);
                break;
            case "/resend-otp":
                handleOTPResend(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    /**
     * Show email verification page
     */
    private void showEmailVerificationPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String fromRegister = request.getParameter("fromRegister");

        // Handle registration flow - user not logged in yet
        if ("true".equals(fromRegister) && email != null && !email.trim().isEmpty()) {
            // Registration flow - user not logged in yet
            // Find user by email to get user info
            Optional<User> userOpt = userService.findByEmail(email);
            if (userOpt.isPresent()) {
                User user = userOpt.get();

                // Check if user is already verified
                if (userService.isEmailVerified(user.getUserId().longValue())) {
                    ToastHelper.addSuccessToast(request, "Email của bạn đã được xác thực.", "Đã Xác Thực");
                    response.sendRedirect(request.getContextPath() + "/dashboard");
                    return;
                }

                // Check if user has pending OTP
                boolean hasPendingOTP = userService.hasPendingOTPVerification(user.getUserId().longValue());
                long remainingTime = userService.getOTPRemainingTime(user.getUserId().longValue());

                request.setAttribute("user", user);
                request.setAttribute("fromRegister", true);
                request.setAttribute("hasPendingOTP", hasPendingOTP);
                request.setAttribute("remainingTime", remainingTime);

                forwardToPage(request, response, "/WEB-INF/views/auth/email-verification.jsp");
                return;
            } else {
                // User not found, redirect to login
                ToastHelper.addErrorToast(request, "Không tìm thấy người dùng. Vui lòng đăng ký lại.");
                response.sendRedirect(request.getContextPath() + "/register");
                return;
            }
        }

        // Normal flow for logged-in users
        User currentUser = getCurrentUser(request);
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Check if user is already verified
        if (userService.isEmailVerified(currentUser.getUserId().longValue())) {
            ToastHelper.addSuccessToast(request, "Email của bạn đã được xác thực.", "Đã Xác Thực");
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        // Check if user has pending OTP
        boolean hasPendingOTP = userService.hasPendingOTPVerification(currentUser.getUserId().longValue());
        long remainingTime = userService.getOTPRemainingTime(currentUser.getUserId().longValue());

        request.setAttribute("user", currentUser);
        request.setAttribute("hasPendingOTP", hasPendingOTP);
        request.setAttribute("remainingTime", remainingTime);

        forwardToPage(request, response, "/WEB-INF/views/auth/email-verification.jsp");
    }

    /**
     * Handle OTP verification
     */
    private void handleOTPVerification(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String otpCode = getParameter(request, "otpCode");
        String email = getParameter(request, "email");
        String fromRegister = getParameter(request, "fromRegister");

        if (otpCode == null || otpCode.trim().isEmpty()) {
            sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, "Vui lòng nhập mã OTP");
            return;
        }

        // Validate OTP format (6 digits)
        if (!otpCode.matches("\\d{6}")) {
            sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, "Mã OTP không hợp lệ. Vui lòng nhập 6 chữ số.");
            return;
        }

        try {
            // Handle registration flow - user not logged in yet
            if ("true".equals(fromRegister)) {
                if (email == null || email.trim().isEmpty()) {
                    sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, "Email là bắt buộc");
                    return;
                }

                Optional<User> userOpt = userService.findByEmail(email);
                if (userOpt.isPresent()) {
                    boolean isValid = userService.verifyOTPCode(userOpt.get().getUserId().longValue(), otpCode);

                    if (isValid) {
                        // Return JSON response for AJAX call, client will handle redirect
                        ToastHelper.addSuccessToast(request, "Xác thực thành công!", "Email Verified");
                        sendSuccessResponse(response, "Xác thực email thành công!", null);
                        return;
                    } else {
                        sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, "Mã OTP không hợp lệ hoặc đã hết hạn");
                        return;
                    }
                } else {
                    sendErrorResponse(response, HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy người dùng");
                    return;
                }
            }

            // Original flow for logged-in users
            User currentUser = getCurrentUser(request);
            if (currentUser == null) {
                sendErrorResponse(response, HttpServletResponse.SC_UNAUTHORIZED, "Yêu cầu xác thực");
                return;
            }

            boolean isValid = userService.verifyOTPCode(currentUser.getUserId().longValue(), otpCode);

            if (isValid) {
                // Update user in session
                Optional<User> updatedUserOpt = userService.findById(currentUser.getUserId().longValue());
                if (updatedUserOpt.isPresent()) {
                    setCurrentUser(request, updatedUserOpt.get());
                }

                ToastHelper.addSuccessToast(request, "Email của bạn đã được xác thực thành công!", "Email Đã Xác Thực");
                sendSuccessResponse(response, "Email đã được xác thực thành công", null);
            } else {
                sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, "Mã OTP không hợp lệ hoặc đã hết hạn");
            }
        } catch (Exception e) {
            sendErrorResponse(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Đã xảy ra lỗi trong quá trình xác thực");
        }
    }

    /**
     * Handle OTP resend
     */
    private void handleOTPResend(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String email = getParameter(request, "email");
        String fromRegister = getParameter(request, "fromRegister");

        // Handle registration flow - user not logged in yet
        if ("true".equals(fromRegister) && email != null && !email.trim().isEmpty()) {
            Optional<User> userOpt = userService.findByEmail(email);
            if (userOpt.isPresent()) {
                User user = userOpt.get();

                // Check if user is already verified
                if (userService.isEmailVerified(user.getUserId().longValue())) {
                    sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, "Email đã được xác thực");
                    return;
                }

                try {
                    boolean sent = userService.resendOTPVerificationEmail(user.getUserId().longValue());

                    if (sent) {
                        long remainingTime = userService.getOTPRemainingTime(user.getUserId().longValue());

                        ToastHelper.addSuccessToast(request, "Mã OTP mới đã được gửi đến email của bạn.", "OTP Đã Gửi");
                        sendSuccessResponse(response, "Gửi lại OTP thành công",
                                new ResendResponse(remainingTime));
                    } else {
                        sendErrorResponse(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Không thể gửi lại OTP");
                    }
                } catch (Exception e) {
                    sendErrorResponse(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Đã xảy ra lỗi khi gửi lại OTP");
                }
                return;
            } else {
                sendErrorResponse(response, HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy người dùng");
                return;
            }
        }

        // Normal flow for logged-in users
        User currentUser = getCurrentUser(request);
        if (currentUser == null) {
            sendErrorResponse(response, HttpServletResponse.SC_UNAUTHORIZED, "Yêu cầu xác thực");
            return;
        }

        // Check if user is already verified
        if (userService.isEmailVerified(currentUser.getUserId().longValue())) {
            sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, "Email đã được xác thực");
            return;
        }

        try {
            boolean sent = userService.resendOTPVerificationEmail(currentUser.getUserId().longValue());

            if (sent) {
                long remainingTime = userService.getOTPRemainingTime(currentUser.getUserId().longValue());

                ToastHelper.addSuccessToast(request, "Mã OTP mới đã được gửi đến email của bạn.", "OTP Đã Gửi");
                sendSuccessResponse(response, "Gửi lại OTP thành công",
                        new ResendResponse(remainingTime));
            } else {
                sendErrorResponse(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Không thể gửi lại OTP");
            }
        } catch (Exception e) {
            sendErrorResponse(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Đã xảy ra lỗi khi gửi lại OTP");
        }
    }

    /**
     * Check verification status (AJAX endpoint)
     */
    private void checkVerificationStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String email = getParameter(request, "email");
        String fromRegister = getParameter(request, "fromRegister");

        // Handle registration flow - user not logged in yet
        if ("true".equals(fromRegister) && email != null && !email.trim().isEmpty()) {
            Optional<User> userOpt = userService.findByEmail(email);
            if (userOpt.isPresent()) {
                User user = userOpt.get();
                boolean isVerified = userService.isEmailVerified(user.getUserId().longValue());
                boolean hasPendingOTP = userService.hasPendingOTPVerification(user.getUserId().longValue());
                long remainingTime = userService.getOTPRemainingTime(user.getUserId().longValue());

                VerificationStatusResponse statusResponse = new VerificationStatusResponse(
                        isVerified, hasPendingOTP, remainingTime
                );

                sendJsonResponse(response, statusResponse);
                return;
            } else {
                sendErrorResponse(response, HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy người dùng");
                return;
            }
        }

        // Normal flow for logged-in users
        User currentUser = getCurrentUser(request);
        if (currentUser == null) {
            sendErrorResponse(response, HttpServletResponse.SC_UNAUTHORIZED, "Yêu cầu xác thực");
            return;
        }

        boolean isVerified = userService.isEmailVerified(currentUser.getUserId().longValue());
        boolean hasPendingOTP = userService.hasPendingOTPVerification(currentUser.getUserId().longValue());
        long remainingTime = userService.getOTPRemainingTime(currentUser.getUserId().longValue());

        VerificationStatusResponse statusResponse = new VerificationStatusResponse(
                isVerified, hasPendingOTP, remainingTime
        );

        sendJsonResponse(response, statusResponse);
    }
    public static class ResendResponse {
        private long remainingTime;

        public ResendResponse(long remainingTime) {
            this.remainingTime = remainingTime;
        }

        public long getRemainingTime() {
            return remainingTime;
        }

        public void setRemainingTime(long remainingTime) {
            this.remainingTime = remainingTime;
        }
    }

    /**
     * Response class for verification status
     */
    public static class VerificationStatusResponse {
        private final boolean verified;
        private final boolean hasPendingOTP;
        private final long remainingTime;

        public VerificationStatusResponse(boolean verified) {
            this.verified = verified;
            this.hasPendingOTP = false;
            this.remainingTime = 0;
        }

        public VerificationStatusResponse(boolean verified, boolean hasPendingOTP, long remainingTime) {
            this.verified = verified;
            this.hasPendingOTP = hasPendingOTP;
            this.remainingTime = remainingTime;
        }

        public boolean isVerified() {
            return verified;
        }

        public boolean isHasPendingOTP() {
            return hasPendingOTP;
        }

        public long getRemainingTime() {
            return remainingTime;
        }
    }
}