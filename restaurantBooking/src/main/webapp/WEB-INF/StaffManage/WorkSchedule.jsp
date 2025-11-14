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
<%
    String message = (String) session.getAttribute("successMessage");
    String error = (String) session.getAttribute("errorMessage");
    if (message != null) {
%>
<div class="alert alert-success">
    <span class="close-btn" onclick="closeAlert(this)">×</span>
    <%= message %>
</div>
<%
    session.removeAttribute("successMessage");
} else if (error != null) {
%>
<div class="alert alert-danger">
    <span class="close-btn" onclick="closeAlert(this)">×</span>
    <%= error %>
</div>
<%
        session.removeAttribute("errorMessage");
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

        <!-- Content -->
        <div class="content">
            <h2>Phân lịch làm việc</h2>

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

                <label>Ca làm:</label>
                <select name="shift">
                    <option value="">-- Tất cả --</option>
                    <option value="Sáng" ${param.shift == 'Sáng' ? 'selected' : ''}>Sáng</option>
                    <option value="Tối" ${param.shift == 'Tối' ? 'selected' : ''}>Tối</option>
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
                                    <input type="hidden" name="action" value="cancel">
                                    <input type="hidden" name="scheduleId" value="${ws.scheduleId}">
                                    <button type="submit" class="linkWS2">
                                        Hủy
                                    </button>
                                </form>
                                <form action="WorkSchedule" method="post" style="display:inline;"
                                      onsubmit="return confirm('Bạn có muốn xác nhận lịch làm việc này không?');">
                                    <input type="hidden" name="action" value="confirm">
                                    <input type="hidden" name="scheduleId" value="${ws.scheduleId}">
                                    <button type="submit" class="linkWS3">
                                        Xác nhận
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:if>

            <!-- Tạo query giữ filter -->
            <c:set var="queryString" value="" />
            <c:if test="${not empty param.userId}">
                <c:set var="queryString" value="${queryString}&userId=${param.userId}" />
            </c:if>
            <c:if test="${not empty param.startDate}">
                <c:set var="queryString" value="${queryString}&startDate=${param.startDate}" />
            </c:if>
            <c:if test="${not empty param.endDate}">
                <c:set var="queryString" value="${queryString}&endDate=${param.endDate}" />
            </c:if>
            <c:if test="${not empty param.sortOrder}">
                <c:set var="queryString" value="${queryString}&sortOrder=${param.sortOrder}" />
            </c:if>

            <!-- PHÂN TRANG -->
            <div class="pagination">
                <c:if test="${totalPages > 1}">
                    <c:if test="${currentPage > 1}">
                        <a href="WorkSchedule?page=1${queryString}">&laquo;</a>
                        <a href="WorkSchedule?page=${currentPage - 1}${queryString}">&lt;</a>
                    </c:if>

                    <c:if test="${currentPage > 4}">
                        <a href="WorkSchedule?page=1${queryString}">1</a>
                        <span>...</span>
                    </c:if>

                    <c:set var="start" value="${currentPage - 2}" />
                    <c:set var="end" value="${currentPage + 2}" />

                    <c:if test="${start < 1}">
                        <c:set var="end" value="${end + (1 - start)}" />
                        <c:set var="start" value="1" />
                    </c:if>

                    <c:if test="${end > totalPages}">
                        <c:set var="start" value="${start - (end - totalPages)}" />
                        <c:set var="end" value="${totalPages}" />
                    </c:if>

                    <c:forEach var="i" begin="${start}" end="${end}">
                        <c:if test="${i >= 1 && i <= totalPages}">
                            <a href="WorkSchedule?page=${i}${queryString}"
                               class="${i == currentPage ? 'active' : ''}">
                                    ${i}
                            </a>
                        </c:if>
                    </c:forEach>

                    <c:if test="${currentPage < totalPages - 3}">
                        <span>...</span>
                        <a href="WorkSchedule?page=${totalPages}${queryString}">${totalPages}</a>
                    </c:if>

                    <c:if test="${currentPage < totalPages}">
                        <a href="WorkSchedule?page=${currentPage + 1}${queryString}">&gt;</a>
                        <a href="WorkSchedule?page=${totalPages}${queryString}">&raquo;</a>
                    </c:if>
                </c:if>
            </div>

            <c:if test="${empty schedules}">
                <div style="color: red; text-align: center;">Không có dữ liệu lịch làm việc.</div>
            </c:if>

            <%-- Popup thêm/sửa lịch làm việc --%>
            <div id="addModal" class="modal">

                <div class="modal-content">
                    <span id="closeModal" class="close">&times;</span>
                    <form id="scheduleForm" action="${pageContext.request.contextPath}/WorkSchedule" method="post">
                    <input type="hidden" name="action" value="add"/>
                    <input type="hidden" name="scheduleId" value=""/>

                    <div class="form-fields">
                        <label>Nhân viên:</label>
                        <select name="userId">
                            <option value="">-- Chọn nhân viên --</option>
                            <c:forEach var="u" items="${staffList}">
                                <option value="${u.userId}">${u.fullName}</option>
                            </c:forEach>
                        </select><br/>

                        <label>Ngày làm:</label>
                        <input type="date" name="workDate"><br/>

                        <label>Ca làm:</label>
                        <select name="shift">
                            <option value="">-- Chọn ca làm --</option>
                            <option value="Sáng">Sáng</option>
                            <option value="Tối">Tối</option>
                        </select><br/>

                        <label>Giờ bắt đầu:</label>
                        <input type="time" name="startTime"><br/>

                        <label>Giờ kết thúc:</label>
                        <input type="time" name="endTime"><br/>

                        <label>Vị trí:</label>
                        <input type="text" name="workPosition"><br/>

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

    // Tự động điền giờ khi chọn ca làm
    document.addEventListener("DOMContentLoaded", function () {
        const form = document.getElementById("scheduleForm");
        const shiftSelect = form.querySelector("select[name='shift']");
        const startTimeInput = form.querySelector("input[name='startTime']");
        const endTimeInput = form.querySelector("input[name='endTime']");

        shiftSelect.addEventListener("change", function () {
            const shift = this.value;
            if (shift === "Sáng") {
                startTimeInput.value = "09:00";
                endTimeInput.value = "17:00";
            } else if (shift === "Tối") {
                startTimeInput.value = "15:00";
                endTimeInput.value = "23:00";
            } else {
                startTimeInput.value = "";
                endTimeInput.value = "";
            }
        });
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

<%--Validate--%>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const form = document.getElementById("scheduleForm");
        const modal = document.getElementById("addModal");
        const closeModal = document.getElementById("closeModal");
        const openModalBtn = document.getElementById("openModalBtn");
        const submitBtn = document.getElementById("submitBtn");

        // === Xóa thông báo lỗi ===
        function clearErrors() {
            form.querySelectorAll(".error-message").forEach(e => e.remove());
        }

        // === Hiển thị lỗi ngay dưới input/select ===
        function showError(input, message) {
            const error = document.createElement("div");
            error.className = "error-message";
            error.style.color = "red";
            error.style.fontSize = "13px";
            error.style.marginTop = "3px";
            error.textContent = message;
            input.insertAdjacentElement("afterend", error);
        }

        // === Hiển thị lỗi dưới nút submit ===
        function showSubmitError(message) {
            const error = document.createElement("div");
            error.className = "error-message";
            error.style.color = "red";
            error.style.fontSize = "14px";
            error.style.marginTop = "8px";
            error.textContent = message;
            submitBtn.insertAdjacentElement("afterend", error);
        }

        // === Reset form khi mở popup thêm mới ===
        openModalBtn.onclick = function () {
            form.reset();
            form.elements["action"].value = "add";
            form.elements["scheduleId"].value = "";
            clearErrors();
            submitBtn.textContent = "Thêm lịch";
            modal.style.display = "block";
        };

        // === Đóng popup ===
        closeModal.onclick = function () {
            modal.style.display = "none";
            clearErrors();
        };

        window.onclick = function (event) {
            if (event.target === modal) {
                modal.style.display = "none";
                clearErrors();
            }
        };

        // === Validate khi submit ===
        form.addEventListener("submit", function (event) {
            clearErrors();
            let isValid = true;

            const userId = form.elements["userId"];
            const workDate = form.elements["workDate"];
            const shift = form.elements["shift"];
            const position = form.elements["workPosition"];
            const start = form.elements["startTime"];
            const end = form.elements["endTime"];

            if (!userId.value.trim()) {
                showError(userId, "Vui lòng chọn nhân viên.");
                isValid = false;
            }

            if (!workDate.value.trim()) {
                showError(workDate, "Vui lòng chọn ngày làm việc.");
                isValid = false;
            }

            if (!shift.value.trim()) {
                showError(shift, "Vui lòng chọn ca làm.");
                isValid = false;
            }

            if (!position.value.trim()) {
                showError(position, "Vui lòng nhập vị trí làm việc.");
                isValid = false;
            }

            // === Kiểm tra trùng lịch ===
            if (isValid && typeof existingSchedules !== "undefined") {
                const currentScheduleId = form.elements["scheduleId"].value; // id của lịch đang edit
                const exists = existingSchedules.some(s =>
                    s.userId === userId.value &&
                    s.workDate === workDate.value &&
                    s.shift === shift.value &&
                    s.scheduleId !== currentScheduleId // bỏ qua lịch đang edit
                );

                if (exists) {
                    showSubmitError("Lịch làm việc này đã tồn tại.");
                    isValid = false;
                }
            }

            // === Kiểm tra giờ hợp lệ ===
            if (start.value && end.value && start.value >= end.value) {
                showError(end, "Giờ kết thúc phải lớn hơn giờ bắt đầu.");
                isValid = false;
            }

            if (!isValid) {
                event.preventDefault();
            }
        });
    });
</script>
<script>
    const existingSchedules = [
        <c:forEach var="ws" items="${schedules}" varStatus="loop">
        {
            scheduleId: '${ws.scheduleId}',
            userId: '${ws.user.userId}',
            workDate: '${ws.workDate}',
            shift: '${ws.shift}'
        }${!loop.last ? ',' : ''}
        </c:forEach>
    ];
</script>
<script>
    // Truyền danh sách lịch làm việc từ server sang JS
    const existingSchedules = [
        <c:forEach var="ws" items="${schedules}" varStatus="loop">
        {
            userId: '${ws.user.userId}',
            workDate: '${ws.workDate}',
            shift: '${ws.shift}'
        }${!loop.last ? ',' : ''}
        </c:forEach>
    ];
</script>

<!-- in thông báo thêm lịch thành công-->
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

</body>
</html>