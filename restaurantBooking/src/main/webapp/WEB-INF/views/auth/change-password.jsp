<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thay Đổi Mật Khẩu - Restaurant Booking</title>
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
                <h1>Thay Đổi Mật Khẩu</h1>
                <p>Cập nhật mật khẩu của bạn để bảo mật tài khoản</p>
            </div>

            <form id="changePasswordForm" class="auth-form" method="post" action="${pageContext.request.contextPath}/change-password">

                <!-- Current Password -->
                <div class="form-group">
                    <label for="currentPassword" class="form-label">
                        Mật Khẩu Hiện Tại <span class="required">*</span>
                    </label>
                    <div class="password-input-wrapper">
                        <input type="password"
                               id="currentPassword"
                               name="currentPassword"
                               class="form-control"
                               placeholder="Nhập mật khẩu hiện tại"
                               minlength="6"
                               required>
                        <button type="button" class="password-toggle" onclick="togglePassword('currentPassword')">
                            <i class="fas fa-eye eye-icon"></i>
                        </button>
                    </div>
                    <div class="error-message" id="currentPasswordError"></div>
                </div>

                <!-- New Password -->
                <div class="form-group">
                    <label for="newPassword" class="form-label">
                        Mật Khẩu Mới <span class="required">*</span>
                    </label>
                    <div class="password-input-wrapper">
                        <input type="password"
                               id="newPassword"
                               name="newPassword"
                               class="form-control"
                               placeholder="Nhập mật khẩu mới (tối thiểu 6 ký tự)"
                               minlength="6"
                               required>
                        <button type="button" class="password-toggle" onclick="togglePassword('newPassword')">
                            <i class="fas fa-eye eye-icon"></i>
                        </button>
                    </div>
                    <div class="password-strength" id="passwordStrength"></div>
                    <div class="error-message" id="newPasswordError"></div>
                </div>

                <!-- Confirm New Password -->
                <div class="form-group">
                    <label for="confirmPassword" class="form-label">
                        Xác Nhận Mật Khẩu Mới <span class="required">*</span>
                    </label>
                    <div class="password-input-wrapper">
                        <input type="password"
                               id="confirmPassword"
                               name="confirmPassword"
                               class="form-control"
                               placeholder="Nhập lại mật khẩu mới"
                               minlength="6"
                               required>
                        <button type="button" class="password-toggle" onclick="togglePassword('confirmPassword')">
                            <i class="fas fa-eye eye-icon"></i>
                        </button>
                    </div>
                    <div class="error-message" id="confirmPasswordError"></div>
                </div>

                <!-- Submit Button -->
                <div class="form-group">
                    <button type="submit" class="btn btn-primary btn-full" id="changePasswordBtn">
                        <span class="btn-text">Cập Nhật Mật Khẩu</span>
                    </button>
                </div>

                <!-- Back to Profile Link -->
                <div class="auth-footer">
                    <p>
                        <a href="${pageContext.request.contextPath}/profile" class="auth-link">Quay lại trang cá nhân</a>
                    </p>
                </div>
            </form>
        </div>

        <!-- Password Security Tips -->
        <div class="auth-benefits">
            <h3>Mẹo bảo mật mật khẩu</h3>
            <ul class="benefits-list">
                <li>
                    <i class="fas fa-shield-alt benefit-icon"></i>
                    <span>Sử dụng ít nhất 6 ký tự</span>
                </li>
                <li>
                    <i class="fas fa-key benefit-icon"></i>
                    <span>Kết hợp chữ hoa, chữ thường và số</span>
                </li>
                <li>
                    <i class="fas fa-lock benefit-icon"></i>
                    <span>Không sử dụng thông tin cá nhân</span>
                </li>
                <li>
                    <i class="fas fa-sync-alt benefit-icon"></i>
                    <span>Thay đổi mật khẩu định kỳ</span>
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

<!-- Change Password Form Validation Script -->
<script src="${pageContext.request.contextPath}/js/change-password.js"></script>
</body>
</html>