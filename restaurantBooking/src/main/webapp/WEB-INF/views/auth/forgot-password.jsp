<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quên mật khẩu - Restaurant Booking</title>
    
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
                    <h1>Quên mật khẩu</h1>
                    <p>Nhập địa chỉ email của bạn và chúng tôi sẽ gửi cho bạn hướng dẫn để đặt lại mật khẩu.</p>
                </div>

                <form action="${pageContext.request.contextPath}/forgot-password" method="post" id="forgotPasswordForm" class="auth-form">
                    <!-- Email -->
                    <div class="form-group">
                        <label for="email" class="form-label">
                            Email <span class="required">*</span>
                        </label>
                        <input type="email" 
                               class="form-control ${not empty requestScope.emailError ? 'error' : ''}" 
                               id="email" 
                               name="email" 
                               placeholder="Nhập email của bạn"
                               value="${param.email}"
                               required>
                        <div class="error-message" id="emailError">${requestScope.emailError}</div>
                    </div>

                    <!-- Submit Button -->
                    <div class="form-group">
                        <button type="submit" class="btn btn-primary btn-full" id="submitBtn">
                            <span class="btn-text">Gửi yêu cầu đặt lại mật khẩu</span>
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

            <!-- Forgot Password Benefits -->
            <div class="auth-benefits">
                <h3>Cần giúp đỡ?</h3>
                <ul class="benefits-list">
                    <li>
                        <i class="fas fa-envelope benefit-icon"></i>
                        <span>Kiểm tra email của bạn sau khi gửi yêu cầu</span>
                    </li>
                    <li>
                        <i class="fas fa-clock benefit-icon"></i>
                        <span>Liên kết đặt lại mật khẩu có hiệu lực trong 24 giờ</span>
                    </li>
                    <li>
                        <i class="fas fa-shield-alt benefit-icon"></i>
                        <span>Đảm bảo kiểm tra thư mục spam nếu không thấy email</span>
                    </li>
                    <li>
                        <i class="fas fa-headset benefit-icon"></i>
                        <span>Liên hệ hỗ trợ nếu cần thêm trợ giúp</span>
                    </li>
                </ul>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.getElementById('forgotPasswordForm');
            const submitBtn = document.getElementById('submitBtn');
            const emailInput = document.getElementById('email');
            
            // Form validation
            form.addEventListener('submit', function(e) {
                if (!form.checkValidity()) {
                    e.preventDefault();
                    form.classList.add('was-validated');
                    return;
                }
                
                // Show loading state
                submitBtn.disabled = true;
                submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang gửi...';
            });
            
            // Real-time email validation
            emailInput.addEventListener('input', function() {
                if (this.value.trim() !== '') {
                    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                    if (!emailRegex.test(this.value)) {
                        this.classList.add('error');
                        document.getElementById('emailError').textContent = 'Vui lòng nhập địa chỉ email hợp lệ';
                        this.setCustomValidity('Vui lòng nhập địa chỉ email hợp lệ');
                    } else {
                        this.classList.remove('error');
                        document.getElementById('emailError').textContent = '';
                        this.setCustomValidity('');
                    }
                } else {
                    this.classList.remove('error');
                    document.getElementById('emailError').textContent = '';
                    this.setCustomValidity('');
                }
            });
            
            // Clear validation state when typing
            emailInput.addEventListener('focus', function() {
                this.classList.remove('error');
                document.getElementById('emailError').textContent = '';
            });
        });
    </script>
</body>
</html>