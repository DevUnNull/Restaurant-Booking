<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đổi Mật Khẩu</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/profile.css">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=Roboto:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        /* CSS cho các thành phần mới */
        .password-input-wrapper { position: relative; display: flex; align-items: center; }
        .password-input-wrapper .form-control { padding-right: 40px; width: 100%; }
        .password-toggle { position: absolute; right: 1px; top: 1px; bottom: 1px; border: none; background: transparent; cursor: pointer; padding: 0 12px; color: #888; }
        .password-toggle i.fa-eye-slash { color: var(--primary-color); }
        .password-strength { height: 5px; margin-top: 5px; background-color: #eee; border-radius: 5px; transition: width 0.3s, background-color 0.3s; }
        .password-strength::before { content: attr(data-strength); font-size: 0.8rem; display: block; text-align: right; margin-top: 8px; color: #555; }
        .password-strength.weak { width: 25%; background-color: #e74c3c; }
        .password-strength.medium { width: 50%; background-color: #f39c12; }
        .password-strength.strong { width: 75%; background-color: #27ae60; }
        .password-strength.very-strong { width: 100%; background-color: #2980b9; }
        .error-message { font-size: 0.9rem; margin-top: 5px; }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

</head>
<body>
<jsp:include page="../common/header.jsp"/>

<div class="profile-container">
    <h2>Đổi Mật Khẩu</h2>



    <div class="profile-section">
        <form id="changePasswordForm" action="${pageContext.request.contextPath}/change-password" method="post">
            <div class="form-group">
                <label for="currentPassword">Mật khẩu hiện tại:</label>
                <input type="password" id="currentPassword" name="currentPassword" class="form-control" required>
            </div>
            <div class="form-group">
                <label for="newPassword">Mật khẩu mới:</label>
                <div class="password-input-wrapper">
                    <input type="password" id="newPassword" name="newPassword" class="form-control" placeholder="Tối thiểu 8 ký tự..." required>
                    <button type="button" class="password-toggle" onclick="togglePassword('newPassword')"><i class="fas fa-eye"></i></button>
                </div>
                <div class="password-strength" id="passwordStrength"></div>
            </div>
            <div class="form-group">
                <label for="confirmPassword">Xác nhận mật khẩu mới:</label>
                <div class="password-input-wrapper">
                    <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" placeholder="Nhập lại mật khẩu mới" required>
                    <button type="button" class="password-toggle" onclick="togglePassword('confirmPassword')"><i class="fas fa-eye"></i></button>
                </div>
                <div class="error-message" id="confirmPasswordError"></div>
            </div>
            <button style="width: 100%; padding: 10px; margin: 10px 0; border: 1px solid #ccc; border-radius: 5px; background-color: #f9f9f9; font-size: 16px; color: #333; cursor: pointer; transition: background-color 0.3s;">
                Xác nhận mật khẩu mới
            </button>
        </form>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>

<script>
    function togglePassword(fieldId) {
        const field = document.getElementById(fieldId);
        const icon = field.parentElement.querySelector('i');
        if (field.type === "password") {
            field.type = "text";
            icon.classList.remove('fa-eye');
            icon.classList.add('fa-eye-slash');
        } else {
            field.type = "password";
            icon.classList.remove('fa-eye-slash');
            icon.classList.add('fa-eye');
        }
    }

    document.addEventListener('DOMContentLoaded', function () {
        const newPasswordField = document.getElementById('newPassword');
        const strengthBar = document.getElementById('passwordStrength');
        const confirmPasswordField = document.getElementById('confirmPassword');
        const confirmPasswordError = document.getElementById('confirmPasswordError');

        newPasswordField.addEventListener('input', function () {
            const password = this.value;
            let score = 0;
            let strengthText = '';
            if (password.length >= 8) score++;
            if (password.match(/[a-z]/)) score++;
            if (password.match(/[A-Z]/)) score++;
            if (password.match(/[0-9]/)) score++;
            if (password.match(/[^a-zA-Z0-9]/)) score++;
            strengthBar.className = 'password-strength';
            switch (score) {
                case 1: case 2: strengthBar.classList.add('weak'); strengthText = 'Yếu'; break;
                case 3: strengthBar.classList.add('medium'); strengthText = 'Trung bình'; break;
                case 4: strengthBar.classList.add('strong'); strengthText = 'Mạnh'; break;
                case 5: strengthBar.classList.add('very-strong'); strengthText = 'Rất mạnh'; break;
            }
            strengthBar.setAttribute('data-strength', strengthText);
        });

        function validateConfirmPassword() {
            const newPassword = newPasswordField.value;
            const confirmPassword = confirmPasswordField.value;
            if (confirmPassword.length > 0) {
                if (newPassword === confirmPassword) {
                    confirmPasswordError.innerText = 'Mật khẩu khớp.';
                    confirmPasswordError.style.color = 'green';
                } else {
                    confirmPasswordError.innerText = 'Mật khẩu không khớp.';
                    confirmPasswordError.style.color = 'red';
                }
            } else {
                confirmPasswordError.innerText = '';
            }
        }
        newPasswordField.addEventListener('input', validateConfirmPassword);
        confirmPasswordField.addEventListener('input', validateConfirmPassword);

        <c:if test="${not empty message}">
        Swal.fire({
            title: '${success ? "Thành công!" : "Có lỗi xảy ra!"}',
            text: '${message}',
            icon: '${success ? "success" : "error"}',
            confirmButtonColor: '#3085d6',
            confirmButtonText: 'OK'
        });
        </c:if>
    });

</script>
</body>
</html>