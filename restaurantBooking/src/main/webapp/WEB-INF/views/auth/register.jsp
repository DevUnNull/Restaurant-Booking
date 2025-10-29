<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Ký Tài Khoản - Restaurant Booking</title>
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
                <h1>Đăng Ký Tài Khoản</h1>
                <p>Tạo tài khoản để trải nghiệm dịch vụ đặt bàn của chúng tôi</p>
            </div>

            <form id="registerForm" class="auth-form" method="post" action="${pageContext.request.contextPath}/register">
                <input type="hidden" name="action" value="register">

                <!-- Full Name -->
                <div class="form-group">
                    <label for="fullName" class="form-label">
                        Họ và Tên <span class="required">*</span>
                    </label>
                    <input type="text"
                           id="fullName"
                           name="fullName"
                           class="form-control"
                           placeholder="Nhập họ và tên của bạn"
                           value="${param.fullName}"
                           required
                           minlength="2"
                           maxlength="100"
                           pattern="[a-zA-ZÀ-ỹ\s]+">
                    <div class="error-message" id="fullNameError"></div>
                </div>

                <!-- Email -->
                <div class="form-group">
                    <label for="email" class="form-label">
                        Email <span class="required">*</span>
                    </label>
                    <input type="email"
                           id="email"
                           name="email"
                           class="form-control"
                           placeholder="Nhập địa chỉ email"
                           value="${param.email}"
                           required>
                    <div class="error-message" id="emailError"></div>
                </div>

                <!-- Phone Number -->
                <div class="form-group">
                    <label for="phoneNumber" class="form-label">
                        Số Điện Thoại <span class="required">*</span>
                    </label>
                    <input type="tel"
                           id="phoneNumber"
                           name="phoneNumber"
                           class="form-control"
                           placeholder="Nhập số điện thoại (VD: 0901234567)"
                           value="${param.phoneNumber}"
                           pattern="0[35789][0-9]{8}"
                           required>
                    <div class="error-message" id="phoneNumberError"></div>
                </div>

                <div class="form-group">
                    <label for="dateOfBirth" class="form-label">Ngày sinh:</label>
                    <input type="date"
                           id="dateOfBirth"
                           name="dateOfBirth"
                           class="form-control"
                           value="${param.dateOfBirth}">
                </div>

                <div class="form-group">
                    <label class="form-label">Giới tính:</label>
                    <div class="radio-group" style="display: flex; gap: 20px; padding: 10px 0;">
                        <label><input type="radio" name="gender" value="MALE" ${param.gender == 'MALE' ? 'checked' : ''}> Nam</label>
                        <label><input type="radio" name="gender" value="FEMALE" ${param.gender == 'FEMALE' ? 'checked' : ''}> Nữ</label>
                        <label><input type="radio" name="gender" value="OTHER" ${param.gender == 'OTHER' ? 'checked' : ''}> Khác</label>
                    </div>
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
                               placeholder="Nhập mật khẩu (tối thiểu 6 ký tự)"
                               minlength="6"
                               required>
                        <button type="button" class="password-toggle" onclick="togglePassword('password')">
                            <i class="fas fa-eye eye-icon"></i>
                        </button>
                    </div>
                    <div class="password-strength" id="passwordStrength"></div>
                    <div class="error-message" id="passwordError"></div>
                </div>

                <!-- Confirm Password -->
                <div class="form-group">
                    <label for="confirmPassword" class="form-label">
                        Xác Nhận Mật Khẩu <span class="required">*</span>
                    </label>
                    <div class="password-input-wrapper">
                        <input type="password"
                               id="confirmPassword"
                               name="confirmPassword"
                               class="form-control"
                               placeholder="Nhập lại mật khẩu"
                               minlength="6"
                               required>
                        <button type="button" class="password-toggle" onclick="togglePassword('confirmPassword')">
                            <i class="fas fa-eye eye-icon"></i>
                        </button>
                    </div>
                    <div class="error-message" id="confirmPasswordError"></div>
                </div>

                <!-- Terms and Conditions -->
                <div class="form-group checkbox-group">
                    <label class="checkbox-label">
                        <input type="checkbox" id="agreeTerms" name="agreeTerms" required>
                        <span class="checkmark"></span>
                        Tôi đồng ý với <a href="${pageContext.request.contextPath}/terms" target="_blank">Điều khoản sử dụng</a>
                        và <a href="${pageContext.request.contextPath}/privacy" target="_blank">Chính sách bảo mật</a>
                    </label>
                    <div class="error-message" id="agreeTermsError"></div>
                </div>

                <!-- Submit Button -->
                <div class="form-group">
                    <button type="submit" class="btn btn-primary btn-full" id="registerBtn">
                        <span class="btn-text">Đăng Ký</span>
                    </button>
                </div>

                <!-- Login Link -->
                <div class="auth-footer">
                    <p>Đã có tài khoản?
                        <a href="${pageContext.request.contextPath}/login" class="auth-link">Đăng nhập ngay</a>
                    </p>
                </div>
            </form>
        </div>

        <!-- Registration Benefits -->
        <div class="auth-benefits">
            <h3>Lợi ích khi đăng ký</h3>
            <ul class="benefits-list">
                <li>
                    <i class="fas fa-utensils benefit-icon"></i>
                    <span>Đặt bàn nhanh chóng và tiện lợi</span>
                </li>
                <li>
                    <i class="fas fa-gift benefit-icon"></i>
                    <span>Nhận ưu đãi và khuyến mãi đặc biệt</span>
                </li>
                <li>
                    <i class="fas fa-mobile-alt benefit-icon"></i>
                    <span>Quản lý lịch sử đặt bàn dễ dàng</span>
                </li>
                <li>
                    <i class="fas fa-star benefit-icon"></i>
                    <span>Tích điểm và nhận phần thưởng</span>
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



<!-- Register Form Validation Script -->
<script src="${pageContext.request.contextPath}/js/register.js"></script>
</body>
</html>