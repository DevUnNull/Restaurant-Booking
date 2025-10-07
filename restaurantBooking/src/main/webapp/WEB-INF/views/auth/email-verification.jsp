<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác Thực Email - Hệ Thống Đặt Bàn Nhà Hàng</title>
    
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
        <div class="verification-container">
            <div class="verification-header">
                <i class="fas fa-envelope" style="font-size: 48px; color: var(--primary-color, #FFD700); margin-bottom: 20px;"></i>
                <h2>Xác Thực Email</h2>
                <p>Vui lòng nhập mã OTP 6 chữ số đã được gửi đến email của bạn để hoàn tất quá trình đăng ký.</p>
            </div>
            
            <div class="email-info">
                <i class="fas fa-info-circle"></i>
                <strong>Email:</strong> ${not empty user ? user.email : userEmail}
            </div>
            
            <div class="verification-status" id="verificationStatus"></div>
            
            <form id="otpForm" class="otp-form">
                <div class="otp-input-group">
                    <input type="text" class="otp-input" maxlength="1" pattern="[0-9]" required>
                    <input type="text" class="otp-input" maxlength="1" pattern="[0-9]" required>
                    <input type="text" class="otp-input" maxlength="1" pattern="[0-9]" required>
                    <input type="text" class="otp-input" maxlength="1" pattern="[0-9]" required>
                    <input type="text" class="otp-input" maxlength="1" pattern="[0-9]" required>
                    <input type="text" class="otp-input" maxlength="1" pattern="[0-9]" required>
                </div>
                
                <button type="submit" class="btn-verify" id="verifyBtn">
                    <i class="fas fa-check"></i> Xác Thực Email
                </button>
            </form>
            
            <div class="loading" id="loadingIndicator">
                <div class="spinner"></div>
                <p>Đang xử lý...</p>
            </div>
            
            <div class="resend-section">
                <div class="resend-timer" id="resendTimer">
                    <c:choose>
                        <c:when test="${hasPendingOTP && remainingTime > 0}">
                            Có thể gửi lại mã sau <span id="timerDisplay">${remainingTime}</span> giây
                        </c:when>
                        <c:otherwise>
                            Bạn chưa nhận được mã?
                        </c:otherwise>
                    </c:choose>
                </div>
                
                <button type="button" class="btn-resend" id="resendBtn" 
                        <c:if test="${hasPendingOTP && remainingTime > 0}">disabled</c:if>>
                    <i class="fas fa-redo"></i> Gửi Lại Mã OTP
                </button>
            </div>
            
            <div style="margin-top: 30px; text-align: center;">
                <a href="${pageContext.request.contextPath}/dashboard" class="auth-link">
                    <i class="fas fa-arrow-left"></i> Quay lại trang chính
                </a>
            </div>
        </div>
    </main>
    
    <!-- Footer -->
    <jsp:include page="../common/footer.jsp" />
    
    <!-- Toast Handler -->
    <jsp:include page="../common/toast-handler.jsp" />
    
    <!-- Email Verification JavaScript -->
    <script src="${pageContext.request.contextPath}/js/email-verification.js"></script>
    
    <!-- Timer initialization data -->
    <c:if test="${hasPendingOTP && remainingTime > 0}">
        <div data-has-pending-otp="true" data-remaining-time="${remainingTime}" style="display: none;"></div>
    </c:if>
</body>
</html>