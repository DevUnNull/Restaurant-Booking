<%--
  Created by IntelliJ IDEA.
  User: Duong Quy Nhan
  Date: 10/11/2025
  Time: 4:19 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<html>
<head>
    <title>Danh sách nhân viên</title>
    <link href="css/ServiceManage.css" rel="stylesheet" type="text/css" />
</head>

<body>

<div class="main">
    <div class="header">
        <div class="logo">Quản Lý Nhân Sự</div>
    </div>
    <div class="main-wrapper">
        <!-- Sidebar -->
        <div class="sidebar">
            <ul>
                <li><a href="EmployeeList">Danh sách nhân viên</a></li>
                <li><a href="#">Phân lịch làm việc</a></li>
                <li><a href="#">Lịch làm việc</a></li>
                <li><a href="#">Trạng thái nhân sự</a></li>
                <li><a href="apply-job-list">Đơn xin việc</a></li>
            </ul>
        </div>

        <div class="content">
            <h2>Danh sách nhân viên</h2>
            <div class="search-container">
                <form action="${pageContext.request.contextPath}/EmployeeList" method="get">
                    <input type="text" name="search"
                           placeholder="Tìm theo tên hoặc mã nhân viên"
                           value="${search != null ? search : ''}" class="search-input">
                    <button type="submit" class="search-button">Tìm kiếm</button>
                </form>
            </div>
            <table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Họ và tên</th>
                    <th>Giới tính</th>
                    <th>Ngày sinh</th>
                    <th>Email</th>
                    <th>Số điện thoại</th>
                    <th>Chức vụ</th>
                    <th>Trạng thái</th>
                    <th>Ngày tạo</th>
                    <th>Ngày cập nhật</th>
                    <th>Hành động</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="u" items="${employees}">
                    <tr>
                        <td>${u.userId}</td>
                        <td>${u.fullName}</td>
                        <td>${u.gender}</td>
                        <td>${u.dateOfBirth}</td>
                        <td>${u.email}</td>
                        <td>${u.phoneNumber}</td>
                        <td>
                            <c:choose>
                                <c:when test="${u.roleId == 1}">Admin</c:when>
<%--                                <c:when test="${u.roleId == 2}">Customer</c:when>--%>
                                <c:when test="${u.roleId == 3}">Staff</c:when>
                                <c:when test="${u.roleId == 4}">Manager</c:when>
                                <c:otherwise>Unknown</c:otherwise>
                            </c:choose>
                        </td>
                        <td>${u.status}</td>
                        <td>${u.createdAt}</td>
                        <td>${u.updatedAt}</td>
                        <td>
                            <a href="#" class="link1"
                               onclick="openEditModal('${u.userId}', '${u.fullName}', '${u.email}', '${u.phoneNumber}','${u.gender}','${u.dateOfBirth}', '${u.status}')">
                                Sửa
                            </a>

                            <a href="#" class="link2">Xóa</a>
                            <a href="#" class="link3">Chi Tiết</a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>

            <!-- Popup form sửa nhân viên -->
            <div id="editModal" class="modal" style="display:none;">
                <div class="modal-content">
                    <span class="close" onclick="closeModal()">&times;</span>
                    <h3 style="text-align:center; color:#b23627;">Chỉnh sửa nhân viên</h3>

                    <form id="editForm" method="post" action="${pageContext.request.contextPath}/UpdateEmployee">
                        <input type="hidden" name="userId" id="editUserId">

                        <label>Họ và tên:</label>
                        <input type="text" name="fullName" id="editFullName" required>

                        <label>Email:</label>
                        <input type="email" name="email" id="editEmail" required>

                        <label>Số điện thoại:</label>
                        <input type="text" name="phoneNumber" id="editPhone" required>

                        <label>Giới tính:</label>
                        <select name="gender" id="editGender" required>
                            <option value="Male">Nam</option>
                            <option value="Female">Nữ</option>
                            <option value="Other">Khác</option>
                        </select>

                        <label>Ngày sinh:</label>
                        <input type="date" name="dateOfBirth" id="editDateOfBirth" required>

                        <label>Trạng thái:</label>
                        <select name="status" id="editStatus">
                            <option value="ACTIVE">Active</option>
                            <option value="INACTIVE">Inactive</option>
                            <option value="BANNED">Banned</option>
                        </select>

                        <div style="text-align:center; margin-top:20px;">
                            <button type="submit" class="save-btn">Lưu</button>
                            <button type="button" class="cancel-btn" onclick="closeModal()">Hủy</button>
                        </div>
                    </form>
                </div>
            </div>


            <!-- Phân trang -->
            <div style="text-align: center; margin-top: 20px;">
                <c:if test="${totalPages > 1}">
                    <c:forEach var="i" begin="1" end="${totalPages}">
                        <c:choose>
                            <c:when test="${i == currentPage}">
                                <span style="font-weight:bold; color:#8b3a3a;">${i}</span>
                            </c:when>
                            <c:otherwise>
                                <a href="?page=${i}${not empty search ? '&search=' : ''}${not empty search ? search : ''}">
                                        ${i}
                                </a>
                            </c:otherwise>
                        </c:choose>
                        &nbsp;
                    </c:forEach>
                </c:if>
            </div>

            <c:if test="${not empty message}">
                <p style="color: red; text-align: center;">${message}</p>
            </c:if>
        </div>

    </div>
</div>

<!-- JS điều khiển popup -->
<script>
    // Mở popup và đổ dữ liệu vào form
    function openEditModal(id, fullName, email, phone, gender, dateOfBirth, status) {
        document.getElementById("editUserId").value = id;
        document.getElementById("editFullName").value = fullName;
        document.getElementById("editEmail").value = email;
        document.getElementById("editPhone").value = phone;
        document.getElementById("editGender").value = gender;
        document.getElementById("editDateOfBirth").value = dateOfBirth;
        document.getElementById("editStatus").value = status;

        document.getElementById("editModal").style.display = "flex";
    }

    // Đóng popup
    function closeModal() {
        document.getElementById("editModal").style.display = "none";
    }
</script>

<!-- in thông báo update thành công-->
<c:if test="${not empty successMessage}">
    <div id="toast">${successMessage}</div>
    <script>
        const toast = document.getElementById('toast');
        if (toast) {
            setTimeout(() => {
                toast.classList.add('hide');
                setTimeout(() => toast.remove(), 1000);
            }, 3000); // 3s sau mới ẩn dần
        }
    </script>
    <%-- Style cho toast --%>
    <style>
        #toast {
            position: fixed;
            bottom: 20px;
            right: 20px;
            background-color: #4CAF50; /* xanh lá thành công */
            color: white;
            padding: 14px 22px;
            border-radius: 8px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.3);
            font-size: 16px;
            opacity: 1;
            transition: opacity 1s ease, transform 1s ease;
            z-index: 9999;
        }

        #toast.hide {
            opacity: 0;
            transform: translateY(20px);
        }
    </style>
</c:if>

</body>

<style>
    /* Container chứa thanh tìm kiếm */
    .search-container {
        display: flex;
        justify-content: center;  /* căn giữa theo chiều ngang */
        align-items: center;
        margin: 20px 0;           /* tạo khoảng cách trên dưới */
        gap: 10px;                /* cách đều input và nút */
    }

    /* Ô nhập từ khóa */
    .search-input {
        padding: 10px 14px;
        width: 250px;
        border: 1px solid #ccc;
        border-radius: 25px;      /* bo tròn đẹp */
        font-size: 15px;
        outline: none;
        transition: all 0.3s ease;
    }

    .search-input:focus {
        border-color: #b23627;
        box-shadow: 0 0 5px #b23627;
    }

    /* Nút Search */
    .search-button {
        background-color: #b23627;
        color: white;
        border: none;
        padding: 10px 20px;
        border-radius: 25px;
        font-size: 15px;
        cursor: pointer;
        transition: all 0.3s ease;
    }

    .search-button:hover {
        background-color: #922c1f;
        transform: translateY(-2px);
    }

    .action-btn {
        margin-right: 6px; /* tạo khoảng cách giữa 2 nút */
    }
    /* Nút thêm dịch vụ */
    .add-btn {
        background-color: #c0392b; /* Đỏ đậm sang trọng */
        color: #fff; /* Chữ trắng */
        border: none;
        padding: 10px 22px;
        font-size: 16px;
        font-weight: bold;
        border-radius: 8px;
        cursor: pointer;
        float: right; /* Đưa sang phải */
        margin-bottom: 15px;
        box-shadow: 0 4px 10px rgba(192, 57, 43, 0.3);
        transition: all 0.3s ease;
        text-decoration: none;
    }

    /* Hiệu ứng hover */
    .add-btn:hover {
        background-color: #e74c3c;
        box-shadow: 0 6px 12px rgba(231, 76, 60, 0.4);
        transform: translateY(-2px);
        text-decoration: none;
    }

    /* Khi bấm giữ */
    .add-btn:active {
        background-color: #a93226;
        transform: translateY(0);
        text-decoration: none;
    }
    a {
        text-decoration: none;
        font-weight: bold;
        padding: 8px 16px;
        border-radius: 20px;
        margin-right: 10px;
        display: inline-block;
        transition: all 0.3s ease;
    }

    .link1 {
        background-color: #b23627; /* đỏ nâu */
        color: white;
    }
    .link2 {
        background-color: #1e90ff; /* xanh dương */
        color: white;
    }
    .link3 {
        background-color: #28a745; /* xanh lá */
        color: white;
    }

    a:hover {
        opacity: 0.8;
    }

    /* Popup (modal) nền mờ */
    .modal {
        position: fixed;
        top: 0; left: 0;
        width: 100%; height: 100%;
        background-color: rgba(0,0,0,0.5);
        display: flex;
        align-items: center;
        justify-content: center;
        z-index: 999;
    }

    /* Hộp nội dung popup */
    .modal-content {
        background: #fff;
        padding: 25px;
        border-radius: 12px;
        width: 400px;
        box-shadow: 0 5px 15px rgba(0,0,0,0.3);
        position: relative;
    }

    /* Nút đóng (X) */
    .close {
        position: absolute;
        right: 15px;
        top: 10px;
        font-size: 22px;
        cursor: pointer;
    }

    /* Form trong popup */
    .modal-content input, .modal-content select {
        width: 100%;
        padding: 10px;
        margin: 8px 0;
        border: 1px solid #ccc;
        border-radius: 8px;
        font-size: 14px;
    }

    /* Nút Lưu & Hủy */
    .save-btn {
        background-color: #28a745;
        color: white;
        border: none;
        padding: 10px 18px;
        border-radius: 8px;
        cursor: pointer;
        margin-right: 10px;
        transition: all 0.3s ease;
    }
    .save-btn:hover { background-color: #218838; }

    .cancel-btn {
        background-color: #b23627;
        color: white;
        border: none;
        padding: 10px 18px;
        border-radius: 8px;
        cursor: pointer;
        transition: all 0.3s ease;
    }
    .cancel-btn:hover { background-color: #922c1f; }

</style>

</html>
