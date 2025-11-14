<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Thông Tin Cá Nhân</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        /* Định dạng chung cho profile section */
        .profile-section {
            background-color: #ffffff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }

        .profile-section h3 {
            font-size: 18px;
            color: #333;
            margin-bottom: 15px;
            border-bottom: 1px solid #eee;
            padding-bottom: 5px;
        }

        /* Định dạng form group */
        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            font-size: 14px;
            color: #555;
            margin-bottom: 5px;
            font-weight: 500;
        }

        .form-group input[type="text"],
        .form-group input[type="email"],
        .form-group input[type="date"] {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #ccc;
            border-radius: 8px;
            font-size: 15px;
            color: #333;
            transition: border-color 0.2s, box-shadow 0.2s;
        }

        .form-group input[type="text"]:focus,
        .form-group input[type="email"]:focus,
        .form-group input[type="date"]:focus {
            border-color: #007bff;
            box-shadow: 0 0 4px rgba(0, 123, 255, 0.4);
            outline: none;
        }

        .form-group input[readonly] {
            background-color: #f5f5f5;
            cursor: not-allowed;
        }

        /* Định dạng nút submit */
        button[type="submit"] {
            width: 100%;
            padding: 10px;
            background-color: #007bff;
            color: #fff;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        button[type="submit"]:hover {
            background-color: #0056b3;
        }

        /* Định dạng avatar section */
        .avatar-section img {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            object-fit: cover;
            margin-bottom: 15px;
            border: 2px solid #ddd;
        }

        #avatar-input-label {
            display: inline-block;
            padding: 8px 15px;
            background-color: #007bff;
            color: #fff;
            border-radius: 5px;
            cursor: pointer;
            margin-right: 10px;
            margin-bottom: 20px;
        }

        #avatar-input {
            display: none; /* Ẩn input file thực sự */
        }

        /* Căn chỉnh layout chính */
        .main-container {
            max-width: 600px;
            margin: 0 auto;
        }
    </style>
</head>
<body>
<jsp:include page="../common/header.jsp"/>

<div class="main-container" style="padding: 100px 20px;">
    <h2>Thông Tin Cá Nhân</h2>



    <div class="profile-section avatar-section">
        <h3>Ảnh Đại Diện</h3>
        <form action="${pageContext.request.contextPath}/profile" method="post">
            <input type="hidden" name="action" value="updateAvatar">

            <%-- Ảnh xem trước --%>
            <img id="avatar-preview"
                 src="${not empty user.avatar ? user.avatar : 'https://ui-avatars.com/api/?name=U&size=150'}"
                 alt="Avatar">

            <%-- Nút chọn file tùy chỉnh --%>
            <label for="avatar-input" id="avatar-input-label">Chọn ảnh mới</label>

            <%-- Input chọn file thật, được ẩn đi --%>
            <input type="file" id="avatar-input" accept="image/*">

            <%-- Input ẩn để lưu trữ chuỗi Base64 --%>
            <input type="hidden" name="avatarBase64" id="avatar-base64-input">

            <button type="submit">Lưu Ảnh</button>
        </form>
    </div>
    <hr>

    <div class="profile-section">
        <h3>Thông Tin Cơ Bản</h3>
        <form action="${pageContext.request.contextPath}/profile" method="post">
            <input type="hidden" name="action" value="updateInfo">
            <div class="form-group">
                <label for="email">Email:</label>
                <input type="email" id="email" name="email" value="${user.email}" readonly>
            </div>
            <div class="form-group">
                <label for="fullName">Họ và tên:</label>
                <input type="text" id="fullName" name="fullName" value="${user.fullName}">
            </div>
            <div class="form-group">
                <label for="phone">Số điện thoại:</label>
                <input type="text" id="phone" name="phone" value="${user.phoneNumber}">
            </div>

            <div class="form-group">
                <label for="dateOfBirth">Ngày sinh:</label>
                <input type="date" id="dateOfBirth" name="dateOfBirth"
                       value="${user.dateOfBirth}">
            </div>
            <div class="form-group" >
                <label>
                    <input type="radio" name="gender" value="MALE"
                           <c:if test="${fn:toUpperCase(user.gender) eq 'MALE'}">checked="checked"</c:if>> Nam
                </label>
                <label>
                    <input type="radio" name="gender" value="FEMALE"
                           <c:if test="${fn:toUpperCase(user.gender) eq 'FEMALE'}">checked="checked"</c:if>> Nữ
                </label>
                <label>
                    <input type="radio" name="gender" value="OTHER"
                           <c:if test="${fn:toUpperCase(user.gender) eq 'OTHER'}">checked="checked"</c:if>> Khác
                </label>
            </div>



            <button type="submit">Lưu thay đổi</button>
        </form>
    </div>

</div>

<jsp:include page="../common/footer.jsp"/>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const avatarInput = document.getElementById('avatar-input');
        const avatarPreview = document.getElementById('avatar-preview');
        const avatarBase64Input = document.getElementById('avatar-base64-input');

        avatarInput.addEventListener('change', function(event) {
            const file = event.target.files[0];
            if (file) {
                const reader = new FileReader();

                reader.onload = function(e) {
                    // e.target.result chứa chuỗi Base64
                    const base64String = e.target.result;

                    avatarPreview.src = base64String;

                    avatarBase64Input.value = base64String;
                };

                reader.readAsDataURL(file);
            }
        });
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