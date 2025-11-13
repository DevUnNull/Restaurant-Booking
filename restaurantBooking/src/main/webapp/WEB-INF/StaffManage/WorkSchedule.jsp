<%--
  Created by IntelliJ IDEA.
  User: Duong Quy Nhan
  Date: 10/26/2025
  Time: 10:46 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
    <title>Phân lịch làm việc</title>
    <link href="css/ServiceManage.css" rel="stylesheet" type="text/css" />
    <link href="css/Employee.css" rel="stylesheet" type="text/css" />
    <link href="css/WorkShedule.css" rel="stylesheet" type="text/css" />
</head>
<body>
<div class="main">
<%--    <div class="header">--%>
<%--        <div class="logo">Quản Lý Nhân Sự</div>--%>
<%--    </div>--%>
    <div class="header">
        <div class="logo">Quản Lý Nhân Sự</div>
        <nav>
            <ul>
                <li><a href="#">Trang chủ</a></li>
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

        <!-- Content -->
        <div class="content">
            <h2>Phân lịch làm việc</h2>
            <c:if test="${empty schedules}">
                <div class="no-data">Không có dữ liệu lịch làm việc.</div>
            </c:if>

            <!-- Nút mở popup -->
            <button id="openModalBtn">+ Thêm lịch làm việc</button>

            <!-- Bộ lọc -->
            <form method="get" action="WorkSchedule" class="filter-form">
                <label>Sắp xếp theo Mã lịch:</label>
                <select name="sortOrder">
                    <option value="">-- Không sắp xếp --</option>
                    <option value="asc" ${param.sortOrder == 'asc' ? 'selected' : ''}>Tăng dần</option>
                    <option value="desc" ${param.sortOrder == 'desc' ? 'selected' : ''}>Giảm dần</option>
                </select>

                <label>Nhân viên:</label>
                <select name="userId">
                    <option value="">-- Tất cả --</option>
                    <c:forEach var="u" items="${staffList}">
                        <option value="${u.userId}" ${param.userId == u.userId ? 'selected' : ''}>${u.fullName}</option>
                    </c:forEach>
                </select>

                <label>Từ ngày:</label>
                <input type="date" name="startDate" value="${param.startDate}">

                <label>Đến ngày:</label>
                <input type="date" name="endDate" value="${param.endDate}">

                <button type="submit">Lọc</button>
                <a href="WorkSchedule" class="reset-btn">Xóa lọc</a>
            </form>

            <c:if test="${not empty schedules}">
                <table>
                    <thead>
                    <tr>
                        <th>Mã lịch</th>
                        <th>Họ tên nhân viên</th>
                        <th>Ngày làm việc</th>
                        <th>Ca làm</th>
                        <th>Giờ bắt đầu</th>
                        <th>Giờ kết thúc</th>
                        <th>Vị trí</th>
                        <th>Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="ws" items="${schedules}">
                        <tr>
                            <td>${ws.scheduleId}</td>
                            <td>${ws.user.fullName}</td>
                            <td>${ws.workDate}</td>
                            <td>${ws.shift}</td>
                            <td>${ws.startTime}</td>
                            <td>${ws.endTime}</td>
                            <td>${ws.workPosition}</td>
                            <td>
                                <a href="#"
                                   onclick="editSchedule(
                                       ${ws.scheduleId},
                                           '${ws.user.userId}',
                                           '${ws.workDate}',
                                           '${ws.shift}',
                                           '${ws.startTime}',
                                           '${ws.endTime}',
                                           '${ws.workPosition}',
                                           '${ws.notes}',
                                       ${currentPage}
                                           ); return false;"
                                   class="linkWS1">Sửa</a>
                                <form action="WorkSchedule" method="post" style="display:inline;"
                                      onsubmit="return confirm('Bạn có chắc muốn xóa lịch làm việc này không?');">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="scheduleId" value="${ws.scheduleId}">
                                    <button type="submit" class="linkWS2" style="background:none; border:none; color:#007bff; cursor:pointer;">
                                        Xóa
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:if>

            <%--phân trang--%>
            <div class="pagination">
                <c:if test="${totalPages > 1}">
                    <c:forEach var="i" begin="1" end="${totalPages}">
                        <a href="WorkSchedule?page=${i}"
                           class="${i == currentPage ? 'active' : ''}">
                                ${i}
                        </a>
                    </c:forEach>
                </c:if>
            </div>

            <%-- Popup thêm/sửa lịch làm việc --%>
            <div id="addModal" class="modal">

                <div class="modal-content">
                    <span id="closeModal" class="close">&times;</span> <form id="scheduleForm" action="WorkSchedule" method="post">
                    <input type="hidden" name="action" value="add"/>
                    <input type="hidden" name="scheduleId" value=""/>

                    <div class="form-fields">
                        <label>Nhân viên:</label>
                        <select name="userId" required>
                            <option value="">-- Chọn nhân viên --</option>
                            <c:forEach var="u" items="${staffList}">
                                <option value="${u.userId}">${u.fullName}</option>
                            </c:forEach>
                        </select><br/>

                        <label>Ngày làm:</label>
                        <input type="date" name="workDate" required><br/>

                        <label>Ca làm:</label>
                        <input type="text" name="shift" placeholder="Sáng/Chiều/Tối" required><br/>

                        <label>Giờ bắt đầu:</label>
                        <input type="time" name="startTime" required><br/>

                        <label>Giờ kết thúc:</label>
                        <input type="time" name="endTime" required><br/>

                        <label>Vị trí:</label>
                        <input type="text" name="workPosition" required><br/>

                        <label>Ghi chú:</label>
                        <textarea name="notes"></textarea><br/>
                    </div>

                    <button type="submit" id="submitBtn">Thêm lịch</button>
                </form>
                </div>
            </div>

        </div>
    </div>
</div>

<script>
    // Mở popup thêm mới
    document.getElementById("openModalBtn").onclick = function() {
        resetForm();
        // Sửa: Đặt tiêu đề cho modal (tùy chọn)
        document.getElementById("submitBtn").textContent = "Thêm lịch";
        document.getElementById("addModal").style.display = "block";
    };

    // Đóng popup
    document.getElementById("closeModal").onclick = function() {
        document.getElementById("addModal").style.display = "none";
    };
    window.onclick = function(event) {
        if (event.target === document.getElementById("addModal")) {
            document.getElementById("addModal").style.display = "none";
        }
    };

    // Hàm reset form
    function resetForm() {
        const form = document.getElementById("scheduleForm");
        form.reset();
        // Sửa: Truy cập input bằng 'name'
        form.elements['action'].value = "add";
        form.elements['scheduleId'].value = "";
    }

    // === Hàm mở popup sửa lịch làm việc ===
    function editSchedule(id, userId, workDate, shift, startTime, endTime, position, notes, page) {
        const form = document.getElementById("scheduleForm");

        // Sửa: Truy cập các trường bằng 'name'
        form.elements['action'].value = "edit";
        form.elements['scheduleId'].value = id;
        form.elements['userId'].value = userId;
        form.elements['workDate'].value = workDate;
        form.elements['shift'].value = shift;
        form.elements['startTime'].value = startTime;
        form.elements['endTime'].value = endTime;
        form.elements['workPosition'].value = position;
        form.elements['notes'].value = notes || "";

        document.getElementById("submitBtn").textContent = "Cập nhật";
        document.getElementById("addModal").style.display = "block";

        // Lưu lại trang hiện tại để giữ phân trang sau khi sửa
        sessionStorage.setItem("currentPage", page);
    }

    // === Giữ phân trang sau khi xóa hoặc sửa ===
    window.addEventListener("DOMContentLoaded", function() {
        const savedPage = sessionStorage.getItem("currentPage");
        const currentUrl = new URL(window.location.href);
        const currentPage = currentUrl.searchParams.get("page");

        if (savedPage && !currentPage) {
            // Tạm thời vô hiệu hóa việc tự động chuyển trang khi tải
            // Bạn có thể kích hoạt lại nếu muốn
            // window.location.href = "WorkSchedule?page=" + savedPage;
        }
        // Xóa trang đã lưu sau khi tải xong để tránh chuyển hướng lặp lại
        // sessionStorage.removeItem("currentPage");
    });
</script>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        const filterElements = document.querySelectorAll("#userFilter, #startDateFilter, #endDateFilter, #sortFilter");
        const clearBtn = document.getElementById("clearFilterBtn");

        // Khi thay đổi bất kỳ bộ lọc nào
        filterElements.forEach(el => {
            el.addEventListener("change", applyFilters);
        });

        // Nút xóa lọc
        clearBtn.addEventListener("click", function() {
            sessionStorage.removeItem("workScheduleFilters");
            window.location.href = "WorkSchedule";
        });

        // Khi tải lại trang, giữ nguyên các bộ lọc
        const savedFilters = JSON.parse(sessionStorage.getItem("workScheduleFilters") || "{}");
        for (const key in savedFilters) {
            const element = document.getElementById(key);
            if (element) element.value = savedFilters[key];
        }

        // Tự động áp dụng lại nếu đang có bộ lọc
        if (Object.keys(savedFilters).length > 0) {
            applyFilters(false);
        }

        function applyFilters(shouldSave = true) {
            const userId = document.getElementById("userFilter").value;
            const startDate = document.getElementById("startDateFilter").value;
            const endDate = document.getElementById("endDateFilter").value;
            const sort = document.getElementById("sortFilter").value;

            const params = new URLSearchParams(window.location.search);
            if (userId) params.set("userId", userId); else params.delete("userId");
            if (startDate) params.set("startDate", startDate); else params.delete("startDate");
            if (endDate) params.set("endDate", endDate); else params.delete("endDate");
            if (sort) params.set("sort", sort); else params.delete("sort");

            params.set("page", 1); // Reset về trang đầu khi lọc

            // Lưu bộ lọc vào sessionStorage
            if (shouldSave) {
                const filtersToSave = { userFilter: userId, startDateFilter: startDate, endDateFilter: endDate, sortFilter: sort };
                sessionStorage.setItem("workScheduleFilters", JSON.stringify(filtersToSave));
            }

            // Chuyển trang với các bộ lọc mới
            window.location.href = "WorkSchedule?" + params.toString();
        }
    });
</script>



</body>
</html>