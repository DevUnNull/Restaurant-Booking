<%--
  Created by IntelliJ IDEA.
  User: Duong Quy Nhan
  Date: 10/30/2025
  Time: 10:04 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>Lịch làm việc</title>
    <link href="css/ServiceManage.css" rel="stylesheet" type="text/css" />
    <link href="css/Employee.css" rel="stylesheet" type="text/css" />
    <link href="css/WorkTimetable.css" rel="stylesheet" type="text/css"/>
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

        <div class="content">
            <h2>Danh sách nhân viên</h2>
            <div class="timetable-container">
                <!-- 🧭 Form chọn năm và tuần -->
                <form action="WorkTimetable" method="get" style="margin-bottom: 15px;">
                    <label for="year">YEAR</label>
                    <select id="year" name="year">
                        <c:forEach var="y" begin="2023" end="2026">
                            <option value="${y}" ${y == year ? 'selected' : ''}>${y}</option>
                        </c:forEach>
                    </select>

                    <label for="week">WEEK</label>
                    <select id="week" name="week">
                        <c:forEach var="weekOption" items="${weekOptions}">
                            <option value="${weekOption.value}" ${weekOption.value == selectedWeek ? 'selected' : ''}>
                                    ${weekOption.label}
                            </option>
                        </c:forEach>
                    </select>

                    <button type="submit">View</button>
                </form>

                <h3>Tuần ${monday} → ${sunday}</h3>

                <table class="timetable">
                    <thead>
                    <tr>
                        <th>Slot</th>
                        <th>Thứ 2</th>
                        <th>Thứ 3</th>
                        <th>Thứ 4</th>
                        <th>Thứ 5</th>
                        <th>Thứ 6</th>
                        <th>Thứ 7</th>
                        <th>Chủ nhật</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="slot" begin="1" end="1">
                        <tr>
                            <td>Ca ${slot}</td>
                            <c:forEach var="dateStr" items="${weekDates}">
                                <td>
                                        <%-- Lấy danh sách WorkSchedule cho ngày dateStr --%>
                                    <c:set var="list" value="${scheduleMap[dateStr]}" />
                                    <c:if test="${not empty list}">
                                        <c:forEach var="ws" items="${list}">
                                            <div class="shift-box ${ws.status}">
                                                <strong>${ws.user.fullName}</strong><br/>
                                                <small>${ws.shift} (${ws.startTime} - ${ws.endTime})</small><br/>
                                                <em>${ws.workPosition}</em>
                                            </div>
                                        </c:forEach>
                                    </c:if>
                                </td>
                            </c:forEach>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
</body>
</html>
