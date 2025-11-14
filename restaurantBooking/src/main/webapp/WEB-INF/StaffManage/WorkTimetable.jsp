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
            <div class="timetable-container">
                <!-- Form chọn năm và tuần -->
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

                <div class="status-note">
                    <strong>Chú thích:</strong>
                    <div class="legend-item">
                        <div class="legend-box confirmed"> </div>
                        <span>Đã xác nhận (CONFIRMED)</span>
                    </div>
                    <div class="legend-item">
                        <div class="legend-box tentative"> </div>
                        <span>Tạm thời (TENTATIVE)</span>
                    </div>
                    <div class="legend-item">
                        <div class="legend-box cancelled"> </div>
                        <span>Đã hủy (CANCELLED)</span>
                    </div>
                </div>

                <table class="timetable">
                    <thead>
                    <tr>
                        <th>CA</th>
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
                    <c:set var="shifts" value="${['Sáng', 'Tối']}" />

                    <c:forEach var="shiftName" items="${shifts}">
                        <tr>
                            <td><strong>${shiftName}</strong></td>
                            <c:forEach var="dateStr" items="${weekDates}">
                                <td>
                                    <c:set var="list" value="${scheduleMap[dateStr]}" />
                                    <c:if test="${not empty list}">
                                        <c:forEach var="ws" items="${list}">
                                            <c:if test="${ws.shift eq shiftName}">
                                                <div class="shift-box ${ws.status}"
                                                    onclick="showDetailPopup('${ws.user.fullName}', '${ws.shift}', '${ws.startTime}', '${ws.endTime}', '${ws.workPosition}', '${ws.status}', '${ws.notes}')">
                                                    <strong>${ws.user.fullName}</strong><br/>
                                                    <small>(${ws.startTime} - ${ws.endTime})</small><br/>
                                                    <em>${ws.workPosition}</em>
                                                </div>
                                            </c:if>
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

<!-- Popup chi tiết lịch -->
<div id="scheduleDetailPopup" class="modal" style="display:none;">
    <div class="modal-content">
        <h3>Chi tiết lịch làm việc</h3>
        <p><strong>Nhân viên:</strong> <span id="popupFullName"></span></p>
        <p><strong>Ca:</strong> <span id="popupShift"></span></p>
        <p><strong>Thời gian:</strong> <span id="popupTime"></span></p>
        <p><strong>Vị trí:</strong> <span id="popupPosition"></span></p>
        <p><strong>Trạng thái:</strong> <span id="popupStatus"></span></p>
        <p><strong>Ghi chú:</strong> <span id="popupNotes"></span></p>
        <button onclick="closeDetailPopup()">Đóng</button>
    </div>
</div>

<script>
    function showDetailPopup(fullName, shift, startTime, endTime, position, status, notes) {
        document.getElementById("popupFullName").textContent = fullName;
        document.getElementById("popupShift").textContent = shift;
        document.getElementById("popupTime").textContent = startTime + " - " + endTime;
        document.getElementById("popupPosition").textContent = position || "(Không có)";
        document.getElementById("popupStatus").textContent = status;
        document.getElementById("popupNotes").textContent = notes || "(Không có)";
        document.getElementById("scheduleDetailPopup").style.display = "flex";
    }

    function closeDetailPopup() {
        document.getElementById("scheduleDetailPopup").style.display = "none";
    }
</script>

</body>
</html>
