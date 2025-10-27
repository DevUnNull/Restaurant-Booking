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
            <h2>Phân lịch làm việc</h2>
            <c:if test="${empty schedules}">
                <div class="no-data">Không có dữ liệu lịch làm việc.</div>
            </c:if>

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
                        <th>Ghi chú</th>
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
                            <td>${ws.notes}</td>
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

        </div>
    </div>
</div>
</body>
</html>
