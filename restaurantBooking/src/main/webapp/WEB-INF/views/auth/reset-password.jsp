<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt lại mật khẩu - Restaurant Booking</title>
    
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
                    <h1>Đặt lại mật khẩu</h1>
                    <p>Nhập mật khẩu mới cho tài khoản của bạn</p>
                </div>

                <!-- Display toast messages -->
                <jsp:include page="../common/toast-handler.jsp" />

                <!-- Display email -->
                <div class="email-display">
                    <i class="fas fa-envelope"></i> ${email}
                </div>

                <form action="${pageContext.request.contextPath}/reset-password" method="post" id="resetPasswordForm" class="auth-form">
                    <input type="hidden" name="token" value="${token}">
                    
                    <!-- New Password -->
                    <div class="form-group">
                        <label for="newPassword" class="form-label">
                            Mật khẩu mới <span class="required">*</span>
                        </label>
                        <div class="password-input-wrapper">
                            <input type="password" 
                                   class="form-control ${not empty requestScope.newPasswordError ? 'is-invalid' : ''}" 
                                   id="newPassword" 
                                   name="newPassword" 
                                   placeholder="Nhập mật khẩu mới"
                                   required
                                   minlength="6">
                            <button type="button" class="password-toggle" onclick="togglePassword('newPassword')">
                                <i class="fas fa-eye eye-icon"></i>
                            </button>
                        </div>
                        <div class="error-message" id="newPasswordError">${requestScope.newPasswordError}</div>
                        <div id="passwordStrength" class="password-strength"></div>
                    </div>

                    <!-- Confirm Password -->
                    <div class="form-group">
                        <label for="confirmPassword" class="form-label">
                            Xác nhận mật khẩu <span class="required">*</span>
                        </label>
                        <div class="password-input-wrapper">
                            <input type="password" 
                                   class="form-control ${not empty requestScope.confirmPasswordError ? 'is-invalid' : ''}" 
                                   id="confirmPassword" 
                                   name="confirmPassword" 
                                   placeholder="Nhập lại mật khẩu mới"
                                   required>
                            <button type="button" class="password-toggle" onclick="togglePassword('confirmPassword')">
                                <i class="fas fa-eye eye-icon"></i>
                            </button>
                        </div>
                        <div class="error-message" id="confirmPasswordError">${requestScope.confirmPasswordError}</div>
                    </div>

                    <!-- Submit Button -->
                    <div class="form-group">
                        <button type="submit" class="btn btn-primary btn-full" id="submitBtn">
                            <span class="btn-text">Đặt lại mật khẩu</span>
                        </button>
                    </div>

                    <!-- Back to Login Link -->
                    <div class="auth-footer">
                        <p>
                            <a href="${pageContext.request.contextPath}/login" class="auth-link">
                                <i class="fas fa-arrow-left"></i> Quay lại trang đăng nhập
                            </a>
                        </p>
                    </div>
                </form>
            </div>

            <!-- Reset Password Benefits -->
            <div class="auth-benefits">
                <h3>Lợi ích khi đặt lại mật khẩu</h3>
                <ul class="benefits-list">
                    <li>
                        <i class="fas fa-shield-alt benefit-icon"></i>
                        <span>Tăng cường bảo mật cho tài khoản của bạn</span>
                    </li>
                    <li>
                        <i class="fas fa-key benefit-icon"></i>
                        <span>Truy cập lại vào tài khoản của bạn</span>
                    </li>
                    <li>
                        <i class="fas fa-user-shield benefit-icon"></i>
                        <span>Bảo vệ thông tin cá nhân</span>
                    </li>
                    <li>
                        <i class="fas fa-check-circle benefit-icon"></i>
                        <span>Đảm bảo quyền riêng tư và an toàn</span>
                    </li>
                </ul>
            </div>
        </div>
    </main>
    
    <!-- Footer -->
    <jsp:include page="../common/footer.jsp" />
    
    <!-- Alert Container for notifications -->
    <div id="alert-container" class="alert-container"></div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.getElementById('resetPasswordForm');
            const submitBtn = document.getElementById('submitBtn');
            const newPasswordInput = document.getElementById('newPassword');
            const confirmPasswordInput = document.getElementById('confirmPassword');
            const passwordStrength = document.getElementById('passwordStrength');

            // Password strength checker
            function checkPasswordStrength(password) {
                let strength = 0;
                
                if (password.length >= 6) strength++;
                if (password.length >= 8) strength++;
                if (/[A-Z]/.test(password)) strength++;
                if (/[0-9]/.test(password)) strength++;
                if (/[^A-Za-z0-9]/.test(password)) strength++;

                let strengthText = '';
                let strengthClass = '';

                if (strength <= 2) {
                    strengthText = 'Yếu';
                    strengthClass = 'weak';
                } else if (strength <= 3) {
                    strengthText = 'Trung bình';
                    strengthClass = 'medium';
                } else {
                    strengthText = 'Mạnh';
                    strengthClass = 'strong';
                }

                passwordStrength.textContent = `Độ mạnh mật khẩu: ${strengthText}`;
                passwordStrength.className = `password-strength ${strengthClass}`;
            }

            // Form validation
            form.addEventListener('submit', function(e) {
                let isValid = true;
                
                // Reset previous validation states
                newPasswordInput.classList.remove('is-invalid');
                confirmPasswordInput.classList.remove('is-invalid');
                
                // Validate new password
                const newPassword = newPasswordInput.value.trim();
                if (newPassword === '') {
                    newPasswordInput.classList.add('is-invalid');
                    newPasswordInput.nextElementSibling.nextElementSibling.textContent = 'Vui lòng nhập mật khẩu mới.';
                    isValid = false;
                } else if (newPassword.length < 6) {
                    newPasswordInput.classList.add('is-invalid');
                    newPasswordInput.nextElementSibling.nextElementSibling.textContent = 'Mật khẩu phải có ít nhất 6 ký tự.';
                    isValid = false;
                }

                // Validate confirm password
                const confirmPassword = confirmPasswordInput.value.trim();
                if (confirmPassword === '') {
                    confirmPasswordInput.classList.add('is-invalid');
                    confirmPasswordInput.nextElementSibling.nextElementSibling.textContent = 'Vui lòng xác nhận mật khẩu.';
                    isValid = false;
                } else if (newPassword !== confirmPassword) {
                    confirmPasswordInput.classList.add('is-invalid');
                    confirmPasswordInput.nextElementSibling.nextElementSibling.textContent = 'Mật khẩu xác nhận không khớp.';
                    isValid = false;
                }

                if (!isValid) {
                    e.preventDefault();
                    return;
                }

                // Show loading state
                submitBtn.disabled = true;
                submitBtn.innerHTML = '<span class="btn-text">Đang xử lý...</span>';
            });

            // Real-time password strength checker
            newPasswordInput.addEventListener('input', function() {
                checkPasswordStrength(this.value);
                this.classList.remove('is-invalid');
            });

            // Real-time validation
            confirmPasswordInput.addEventListener('input', function() {
                this.classList.remove('is-invalid');
            });

            // Auto-hide alerts after 5 seconds
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                setTimeout(function() {
                    const bsAlert = new bootstrap.Alert(alert);
                    bsAlert.close();
                }, 5000);
            });
        });

        // Toggle password visibility
        function togglePassword(inputId) {
            const input = document.getElementById(inputId);
            const toggleBtn = input.nextElementSibling;
            const icon = toggleBtn.querySelector('.eye-icon');
            
            if (input.type === 'password') {
                input.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                input.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        }
    </script>
</body>
</html>