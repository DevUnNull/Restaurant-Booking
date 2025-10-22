<%--
  Created by IntelliJ IDEA.
  User: Duong Quy Nhan
  Date: 10/19/2025
  Time: 8:52 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
    <title>Phân Lịch Làm Việc</title>
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
                <li><a href="WorkSchedule">Phân lịch làm việc</a></li>
                <li><a href="#">Lịch làm việc</a></li>
                <li><a href="#">Trạng thái nhân sự</a></li>
                <li><a href="apply-job-list">Đơn xin việc</a></li>
            </ul>
        </div>

        <!-- Content -->
        <div class="content">
            <h2>Phân Lịch Làm Việc</h2>

            <button class="add-btn" onclick="openAddModal()">+ Thêm Lịch Làm Việc</button>

            <table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Tên nhân viên</th>
                    <th>Ngày làm</th>
                    <th>Ca</th>
                    <th>Giờ bắt đầu</th>
                    <th>Giờ kết thúc</th>
                    <th>Vị trí</th>
                    <th>Ghi chú</th>
                    <th>Trạng thái</th>
                    <th>Hành động</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="schedule" items="${schedules}">
                    <tr>
                        <td>${schedule.scheduleId}</td>
                        <td>${schedule.employeeName}</td>
                        <td>${schedule.workDate}</td>
                        <td>${schedule.shift}</td>
                        <td>${schedule.startTime}</td>
                        <td>${schedule.endTime}</td>
                        <td>${schedule.workPosition}</td>
                        <td>${schedule.notes}</td>
                        <td>${schedule.status}</td>
                        <td>
                            <button class="action-btn btn-update"
                                    onclick="openEditModal(${schedule.scheduleId},
                                            '${schedule.employeeName}',
                                            '${schedule.workDate}',
                                            '${schedule.shift}',
                                            '${schedule.startTime}',
                                            '${schedule.endTime}',
                                            '${schedule.workPosition}',
                                            '${schedule.notes}',
                                            '${schedule.status}')">Sửa</button>
                            <form action="DeleteWorkSchedule" method="post" style="display:inline;">
                                <input type="hidden" name="scheduleId" value="${schedule.scheduleId}">
                                <button type="submit" class="action-btn btn-delete"
                                        onclick="return confirm('Bạn có chắc muốn xóa lịch này?')">Xóa</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Modal thêm mới DONE-->
<div id="addModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeAddModal()">&times;</span>
        <h2>Thêm Lịch Làm Việc</h2>
        <form action="AddWorkSchedule" method="post">
            <label>Nhân viên:</label>
            <select name="userId" required>
                <option value="">-- Chọn nhân viên --</option>
                <c:forEach var="s" items="${schedules}">
                    <option value="${s.userId}">${s.employeeName}</option>
                </c:forEach>
            </select>

            <label>Ngày làm việc:</label>
            <input type="date" name="workDate" required>

            <label>Ca làm việc:</label>
            <select name="shift" required>
                <option value="Sáng">Sáng</option>
                <option value="Chiều">Chiều</option>
                <option value="Tối">Tối</option>
            </select>

            <label>Giờ bắt đầu:</label>
            <input type="time" name="startTime" required>

            <label>Giờ kết thúc:</label>
            <input type="time" name="endTime" required>

            <label>Vị trí:</label>
            <input type="text" name="workPosition" required>

            <label>Ghi chú:</label>
            <textarea name="notes"></textarea>

            <button type="submit" class="add-btn">Lưu</button>
        </form>
    </div>
</div>

<!-- Modal chỉnh sửa -->
<div id="editModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeEditModal()">&times;</span>
        <h2>Chỉnh Sửa Lịch Làm Việc</h2>
        <form action="UpdateWorkSchedule" method="post">
            <input type="hidden" id="editScheduleId" name="scheduleId">

            <label>Tên nhân viên:</label>
            <input type="text" id="editEmployeeName" disabled>

            <label>Ngày làm:</label>
            <input type="date" id="editWorkDate" name="workDate" required>

            <label>Ca làm việc:</label>
            <input type="text" id="editShift" name="shift" required>

            <label>Giờ bắt đầu:</label>
            <input type="time" id="editStartTime" name="startTime" required>

            <label>Giờ kết thúc:</label>
            <input type="time" id="editEndTime" name="endTime" required>

            <label>Vị trí:</label>
            <input type="text" id="editWorkPosition" name="workPosition" required>

            <label>Ghi chú:</label>
            <textarea id="editNotes" name="notes"></textarea>

            <label>Trạng thái:</label>
            <select id="editStatus" name="status">
                <option value="ACTIVE">Hoạt động</option>
                <option value="INACTIVE">Không hoạt động</option>
            </select>

            <button type="submit" class="add-btn">Cập nhật</button>
        </form>
    </div>
</div>

<script>
    function openAddModal() {
        document.getElementById('addModal').style.display = 'block';
    }
    function closeAddModal() {
        document.getElementById('addModal').style.display = 'none';
    }

    function openEditModal(id, employeeName, workDate, shift, startTime, endTime, workPosition, notes, status) {
        document.getElementById('editScheduleId').value = id;
        document.getElementById('editEmployeeName').value = employeeName;
        document.getElementById('editWorkDate').value = workDate;
        document.getElementById('editShift').value = shift;
        document.getElementById('editStartTime').value = startTime;
        document.getElementById('editEndTime').value = endTime;
        document.getElementById('editWorkPosition').value = workPosition;
        document.getElementById('editNotes').value = notes;
        document.getElementById('editStatus').value = status;

        document.getElementById('editModal').style.display = 'block';
    }
    function closeEditModal() {
        document.getElementById('editModal').style.display = 'none';
    }

    window.onclick = function(event) {
        if (event.target === document.getElementById('addModal')) closeAddModal();
        if (event.target === document.getElementById('editModal')) closeEditModal();
    }
</script>

</body>
</html>
