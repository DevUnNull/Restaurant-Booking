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
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<html>
<head>
    <title>Danh sách nhân viên</title>
    <link href="css/ServiceManage.css" rel="stylesheet" type="text/css" />
    <link href="css/Employee.css" rel="stylesheet" type="text/css" />
</head>

<body>
<%
    String message = (String) session.getAttribute("message");
    String error = (String) session.getAttribute("error");
    if (message != null) {
%>
<div class="alert alert-success">
    <span class="close-btn" onclick="closeAlert(this)">×</span>
    <%= message %>
</div>
<%
    session.removeAttribute("message");
} else if (error != null) {
%>
<div class="alert alert-danger">
    <span class="close-btn" onclick="closeAlert(this)">×</span>
    <%= error %>
</div>
<%
        session.removeAttribute("error");
    }
%>

<div class="main">
    <div class="header">
        <div class="logo">Quản Lý Nhân Sự</div>
        <nav>
            <ul>
                <li><a href="home">Trang chủ</a></li>
            </ul>
        </nav>
    </div>
    <div class="main-wrapper">
        <!-- Sidebar -->
        <div class="sidebar">
            <ul>
                <li><a href="EmployeeList">Danh sách nhân viên</a></li>
                <li><a href="WorkSchedule">Phân lịch làm việc</a></li>
                <li><a href="WorkTimetable">Lịch làm việc</a></li>
                <li><a href="CustomerList">Thêm nhân viên</a></li>
            </ul>
        </div>

        <div class="content">
            <h2>Danh sách nhân viên</h2>
            <div class="search-container">
                <form action="${pageContext.request.contextPath}/EmployeeList" method="get">
                        <input type="text" name="search"
                               placeholder="Tìm theo tên hoặc mã nhân viên"
                               value="${search != null ? search : ''}" class="search-input">

                    <select name="gender">
                        <option value="all" ${gender == 'all' ? 'selected' : ''}>Giới tính</option>
                        <option value="male" ${gender == 'male' ? 'selected' : ''}>Nam</option>
                        <option value="female" ${gender == 'female' ? 'selected' : ''}>Nữ</option>
                    </select>

                    <select name="status">
                        <option value="all" ${status == 'all' ? 'selected' : ''}>Trạng thái</option>
                        <option value="active" ${status == 'active' ? 'selected' : ''}>Đang hoạt động</option>
                        <option value="inactive" ${status == 'inactive' ? 'selected' : ''}>Ngừng hoạt động</option>
                    </select>

                    <!-- hidden page input: giữ trang hiện tại khi submit -->
                    <input type="hidden" name="page" id="pageInput" value="${currentPage != null ? currentPage : 1}"/>

                    <button type="submit" class="search-button">Tìm kiếm</button>
                </form>
                <span class="search-error"></span>
            </div>
            <table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Họ và tên</th>
                    <th>Giới tính</th>
                    <th>Email</th>
                    <th>Số điện thoại</th>
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
                        <td>${u.gender == 'Male' ? 'Nam' : 'Nữ'}</td>
                        <td>${u.email}</td>
                        <td>${u.phoneNumber}</td>
                        <td>${u.status == 'ACTIVE' ? 'Đang hoạt động' : 'Ngừng hoạt động'}</td>
                        <td>${u.createdAtString}</td>
                        <td>${u.updatedAtString}</td>
                        <td>
                            <a href="#" class="link1"
                               onclick="openEditModal('${u.userId}', '${u.fullName}', '${u.gender}', '${u.email}', '${u.phoneNumber}', '${u.status}')">
                                Sửa
                            </a>
                            <a href="#" class="link2" onclick="confirmDelete(${u.userId}, '${u.status}')">Khóa</a>
                            <a href="#" class="link3" onclick="showDetail(${u.userId})">Chi Tiết</a>
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
                        <input type="text" name="fullName" id="editFullName">

                        <label>Giới tính</label>
                        <select name="gender" id="editGender">
                            <option value="Male">Nam</option>
                            <option value="Female">Nữ</option>
                        </select>

                        <label>Email:</label>
                        <input type="email" name="email" id="editEmail">

                        <label>Số điện thoại:</label>
                        <input type="text" name="phoneNumber" id="editPhone">

                        <label>Trạng thái:</label>
                        <select name="status" id="editStatus">
                            <option value="ACTIVE">Hoạt động</option>
                            <option value="INACTIVE">Ngừng hoạt động</option>
                        </select>

                        <div style="text-align:center; margin-top:20px;">
                            <button type="submit" class="save-btn">Lưu</button>
                            <button type="button" class="cancel-btn" onclick="closeModal()">Hủy</button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Popup hiển thị chi tiết -->
            <div id="detailModal" class="modal" style="display:none;">
                <div class="modal-content">
                    <span class="close" onclick="closeDetailModal()">&times;</span>
                    <h2>Chi tiết nhân viên</h2>
                    <div id="detailContent" class="detail-info"></div>
                </div>
            </div>

            <!-- Phân trang -->
            <div class="pagination">
                <c:if test="${totalPages > 1}">
                    <c:forEach var="i" begin="1" end="${totalPages}">
                        <c:url var="pageUrl" value="/EmployeeList">
                            <c:param name="page" value="${i}" />
                            <c:if test="${not empty search}">
                                <c:param name="search" value="${search}" />
                            </c:if>
                            <c:if test="${not empty gender}">
                                <c:param name="gender" value="${gender}" />
                            </c:if>
                            <c:if test="${not empty status}">
                                <c:param name="status" value="${status}" />
                            </c:if>
                        </c:url>

                        <a href="${pageUrl}" class="${i == currentPage ? 'active' : ''}">${i}</a>

                    </c:forEach>
                </c:if>
            </div>

            <c:if test="${not empty message}">
                <p style="color: red; text-align: center;">${message}</p>
            </c:if>
        </div>

    </div>
</div>

<!-- popup-->
<script>
    function openEditModal(id, fullName, gender, email, phone, status) {
        document.getElementById("editUserId").value = id;
        document.getElementById("editFullName").value = fullName;
        document.getElementById("editGender").value = gender;
        document.getElementById("editEmail").value = email;
        document.getElementById("editPhone").value = phone;
        document.getElementById("editStatus").value = status;
        document.getElementById("editModal").style.display = "flex";
    }

    function closeModal() {
        document.getElementById("editModal").style.display = "none";
    }
</script>

<!-- in thông báo update thành công-->
<script>
    // Hàm đóng khi bấm nút X
    function closeAlert(element) {
        const alertBox = element.parentElement;
        alertBox.classList.add('hide');
        setTimeout(() => alertBox.remove(), 500);
    }

    // Tự động ẩn sau 4 giây
    window.addEventListener('DOMContentLoaded', () => {
        const alertBox = document.querySelector('.alert');
        if (alertBox) {
            setTimeout(() => {
                alertBox.classList.add('hide');
                setTimeout(() => alertBox.remove(), 500);
            }, 4000);
        }
    });
</script>
<%--Khóa Staff--%>
<script>
    function confirmDelete(userId, status) {
        if (status === 'INACTIVE') {
            alert("Tài khoản này đã bị khóa.");
            return;
        }

        if (confirm("Bạn có chắc chắn muốn khóa tài khoản của nhân viên này không?")) {
            window.location.href = "${pageContext.request.contextPath}/DeleteEmployee?userId=" + userId;
        }
    }
</script>

<script>
    // Tự động submit form khi người dùng thay đổi giới tính hoặc trạng thái
    document.addEventListener("DOMContentLoaded", function () {
        const genderSelect = document.querySelector("select[name='gender']");
        const statusSelect = document.querySelector("select[name='status']");
        const searchForm = document.querySelector(".search-container form");

        if (genderSelect) {
            genderSelect.addEventListener("change", function () {
                searchForm.submit();
            });
        }

        if (statusSelect) {
            statusSelect.addEventListener("change", function () {
                searchForm.submit();
            });
        }
    });
</script>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const genderSelect = document.querySelector("select[name='gender']");
        const statusSelect = document.querySelector("select[name='status']");
        const searchForm = document.querySelector(".filter-form");
        const pageInput = document.getElementById("pageInput");

        // Nếu muốn khi thay đổi filter vẫn ở trang hiện tại thì không set pageInput.value
        // Chỉ submit trực tiếp
        if (genderSelect) {
            genderSelect.addEventListener("change", function () {
                // submit with existing page value
                searchForm.submit();
            });
        }

        if (statusSelect) {
            statusSelect.addEventListener("change", function () {
                searchForm.submit();
            });
        }
    });
</script>

<script>
    function showDetail(id) {
        // Gửi yêu cầu tới servlet để lấy HTML chi tiết
        fetch('view-employee-detail?id=' + id)
            .then(response => response.text())
            .then(html => {
                // Đổ nội dung vào phần popup
                document.getElementById("detailContent").innerHTML = html;
                document.getElementById("detailModal").style.display = "flex";
            })
            .catch(err => console.error('Error loading detail:', err));
    }

    function closeDetailModal() {
        document.getElementById("detailModal").style.display = "none";
    }
</script>

<%--validate--%>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const editForm = document.getElementById("editForm");

        // Tạo các span chứa lỗi cho từng input
        const fields = ["editFullName", "editEmail", "editPhone"];
        fields.forEach(id => {
            const input = document.getElementById(id);
            let errorSpan = document.createElement("span");
            errorSpan.className = "error-msg";
            errorSpan.style.color = "red";
            errorSpan.style.fontSize = "12px";
            errorSpan.style.display = "block";
            input.parentNode.insertBefore(errorSpan, input.nextSibling);
        });

        editForm.addEventListener("submit", function (e) {
            let isValid = true;

            // Xóa lỗi cũ
            document.querySelectorAll(".error-msg").forEach(span => span.textContent = "");

            // Validate tên
            const fullName = document.getElementById("editFullName").value.trim();
            if (fullName === "") {
                document.getElementById("editFullName").nextElementSibling.textContent = "Tên nhân viên không được để trống.";
                isValid = false;
            }

            // Validate email
            const email = document.getElementById("editEmail").value.trim();
            if (email === "") {
                document.getElementById("editEmail").nextElementSibling.textContent = "Email không được để trống.";
                isValid = false;
            } else {
                // Regex đơn giản kiểm tra email
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailRegex.test(email)) {
                    document.getElementById("editEmail").nextElementSibling.textContent = "Email không hợp lệ.";
                    isValid = false;
                }
            }

            // Validate số điện thoại
            const phone = document.getElementById("editPhone").value.trim();
            if (phone === "") {
                document.getElementById("editPhone").nextElementSibling.textContent = "Số điện thoại không được để trống.";
                isValid = false;
            } else if (!/^\d{10}$/.test(phone)) {
                document.getElementById("editPhone").nextElementSibling.textContent = "Số điện thoại phải đúng 10 chữ số.";
                isValid = false;
            }

            if (!isValid) {
                e.preventDefault(); // Ngăn submit form nếu có lỗi
            }
        });

        // Tìm kiếm
        const searchForm = document.querySelector(".search-container form");
        const searchInput = searchForm.querySelector("input[name='search']");

        // Tạo span hiển thị lỗi
        let errorSpan = document.createElement("span");
        errorSpan.className = "search-error";
        searchForm.appendChild(errorSpan);

        searchForm.addEventListener("submit", function (e) {
            // Xóa lỗi cũ
            errorSpan.textContent = "";

            if (searchInput.value.trim() === "") {
                e.preventDefault(); // ngăn form submit
                errorSpan.textContent = "Vui lòng nhập tên hoặc mã nhân viên để tìm kiếm.";
                searchInput.focus();
            }
        });
    });
</script>

</body>

</html>
