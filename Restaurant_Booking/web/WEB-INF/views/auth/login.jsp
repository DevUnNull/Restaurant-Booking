<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập - Restaurant Booking</title>
    
    <!-- Common CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth.css">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=Roboto:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
</head>
<body>
    <!-- Header -->
    <jsp:include page="../common/header.jsp" />
    
    <!-- Main Content -->
    <main>
        <div class="auth-container">
            <div class="auth-card">
                <div class="auth-header">
                    <h1>Đăng Nhập</h1>
                    <p>Chào mừng quay trở lại! Vui lòng đăng nhập để tiếp tục</p>
                </div>

                <form id="loginForm" class="auth-form" method="post" action="${pageContext.request.contextPath}/login">
                    <!-- Redirect parameter -->
                    <input type="hidden" name="redirect" value="${param.redirect}">
                    
                    <!-- Email -->
                    <div class="form-group">
                        <label for="email" class="form-label">
                            Email <span class="required">*</span>
                        </label>
                        <input type="email" 
                               id="email" 
                               name="email" 
                               class="form-control" 
                               placeholder="Nhập email của bạn"
                               value="${param.email}"
                               required>
                        <div class="error-message" id="emailError"></div>
                    </div>

                    <!-- Password -->
                    <div class="form-group">
                        <label for="password" class="form-label">
                            Mật Khẩu <span class="required">*</span>
                        </label>
                        <div class="password-input-wrapper">
                            <input type="password" 
                                   id="password" 
                                   name="password" 
                                   class="form-control" 
                                   placeholder="Nhập mật khẩu"
                                   minlength="6"
                                   required>
                            <button type="button" class="password-toggle" onclick="togglePassword('password')">
                                <i class="fas fa-eye eye-icon"></i>
                            </button>
                        </div>
                        <div class="error-message" id="passwordError"></div>
                    </div>

                    <!-- Remember Me & Forgot Password -->
                    <div class="form-group form-row">
                        <label class="checkbox-label">
                            <input type="checkbox" id="rememberMe" name="rememberMe">
                            <span class="checkmark"></span>
                            Ghi nhớ đăng nhập
                        </label>
                        <a href="${pageContext.request.contextPath}/forgot-password" class="auth-link">Quên mật khẩu?</a>
                    </div>

                    <!-- Submit Button -->
                    <div class="form-group">
                        <button type="submit" class="btn btn-primary btn-full" id="loginBtn">
                            <span class="btn-text">Đăng Nhập</span>
                        </button>
                    </div>

                    <!-- Register Link -->
                    <div class="auth-footer">
                        <p>Chưa có tài khoản? 
                            <a href="${pageContext.request.contextPath}/register" class="auth-link">Đăng ký ngay</a>
                        </p>
                    </div>
                </form>
            </div>

            <!-- Login Benefits -->
            <div class="auth-benefits">
                <h3>Lợi ích khi đăng nhập</h3>
                <ul class="benefits-list">
                    <li>
                        <i class="fas fa-calendar-check benefit-icon"></i>
                        <span>Đặt bàn nhanh chóng và tiện lợi</span>
                    </li>
                    <li>
                        <i class="fas fa-history benefit-icon"></i>
                        <span>Xem lịch sử đặt bàn của bạn</span>
                    </li>
                    <li>
                        <i class="fas fa-bell benefit-icon"></i>
                        <span>Nhận thông báo về ưu đãi đặc biệt</span>
                    </li>
                    <li>
                        <i class="fas fa-user benefit-icon"></i>
                        <span>Quản lý thông tin cá nhân</span>
                    </li>
                </ul>
            </div>
        </div>
    </main>
    
    <!-- Footer -->
    <jsp:include page="../common/footer.jsp" />
    
    <!-- Alert Container for notifications -->
    <div id="alert-container" class="alert-container"></div>
    
    <!-- Toast Handler -->
    <jsp:include page="../common/toast-handler.jsp" />
    
    <!-- Login Form Validation Script -->
    <script src="${pageContext.request.contextPath}/js/login.js"></script>
</body>
</html>