<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.time.*, java.time.format.TextStyle, java.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Quản lý khung thời gian</title>

  <!-- Bootstrap (optional) -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/css/bootstrap.min.css">
  <link href="css/TimeManage.css" rel="stylesheet" type="text/css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
<style>
  .fancy-btn {
    background-color: #c0392b; /* đỏ đậm chủ đạo */
    color: #fff;
    border: none;
    padding: 17px 5px;
    font-size: 16px;
    font-weight: bold;
    border-radius: 10px;
    cursor: pointer;
    box-shadow: 0 4px 12px rgba(192, 57, 43, 0.3);
    transition: all 0.3s ease;
    letter-spacing: 0.5px;
  }

  /* Hiệu ứng hover */
  .fancy-btn:hover {
    background-color: #e74c3c;
    transform: translateY(-2px);
    box-shadow: 0 6px 14px rgba(231, 76, 60, 0.4);
  }

  /* Khi nhấn giữ */
  .fancy-btn:active {
    background-color: #a93226;
    transform: translateY(0);
    box-shadow: 0 3px 6px rgba(0, 0, 0, 0.2);
  }

  /* Canh giữa hoặc thêm khoảng cách nếu cần */
  .month-selector .nav {
    position: relative;
    top: -8px;
    left: 118px;
    right: 10px;
    bottom: 10px;
    padding: 10px 10px 10px 10px;
    display: flex;
    justify-content: center;
    margin-top: 20px;
    width: 297px;
  }
  .sidebar {
    width: 220px;
    background-color: #7a1c1c; /* màu nền đỏ đậm */
    padding: 20px 10px;
    border-top: 3px solid #c0392b; /* viền trên nhẹ màu đỏ sáng hơn */
    min-height: 100vh;
  }

  .sidebar ul {
    list-style: none;
    margin: 6px;
    padding: 5px;
  }

  .sidebar ul li {
    margin-bottom: 20px; /* khoảng cách giữa các dòng */
  }

  .sidebar ul li a {
    text-decoration: none;
    color: #ffffff; /* chữ trắng */
    font-size: 16px;
    font-weight: 500;
    display: block;
    transition: color 0.3s ease, padding-left 0.3s ease;
  }

  .sidebar ul li a:hover {
    color: #ffcc99; /* khi hover chuyển sang màu cam nhạt */
    padding-left: 10px; /* dịch nhẹ sang phải khi hover */
  }

</style>
</head>
<body>

<!-- Header -->
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<!-- Sidebar -->
<div class="sidebar">
  <ul>

    <li><a href="ServiceManage">Quản lý dịch vụ</a></li>
    <li><a href="Menu_manage">Quản lý Menu</a></li>
    <li><a href="Voucher">Quản lý Voucher khuyến mãi </a></li>
    <li><a href="Promotion_level">Quản lý khách hàng thân thiết </a></li>
    <li><a href="Timedirect">Quản lý khung giờ </a></li>
  </ul>
<%--  <div class="nav-item">Quản lý khách hàng thân thiết</div>--%>
</div>

<!-- Content -->
<div class="content">

  <!-- Banner -->
  <div class="banner">
    <div class="title">Quản lý khung thời gian</div>

  </div>

  <!-- Controls: legend + month selector -->
  <div class="controls">
    <div class="legend">
      <span class="dot" style="background:#28a745"></span> Ngày thường
      <span class="dot" style="background:#dc3545; margin-left:10px;"></span> Ngày đặc biệt
      <span class="dot" style="background:#111; margin-left:10px;"></span> Bảo trì
    </div>

    <!-- FIXED -->
    <div class="month-selector kakaku">
      <div class="nav">
        <a href="javascript:void(0)" onclick="changeMonth(-1)">&lt;</a>
        <div id="monthLabel" class="label"></div>
        <a href="javascript:void(0)" onclick="changeMonth(1)">&gt;</a>
      </div>
    </div>
    <c:if test="${sessionScope.userRole == 2}">
      <div class="month-selectorr goku">
        <div class="nav">
          <button class="fancy-btn" onclick="window.location.href='ManageTime'">
            Quản lý khung thời gian
          </button>
        </div>
      </div>
    </c:if>

    <!-- /FIXED -->

    <div style="width:140px;"></div>
  </div>

  <!-- Calendar -->
  <div class="calendar-wrap">
    <table class="calendar">
      <thead>
      <tr>
        <th>CN</th>
        <th>T2</th>
        <th>T3</th>
        <th>T4</th>
        <th>T5</th>
        <th>T6</th>
        <th>T7</th>
      </tr>
      </thead>
      <tbody id="calendarBody"></tbody>
    </table>
  </div>

    <%
  java.time.LocalDate today = java.time.LocalDate.now();
  java.time.YearMonth ym = java.time.YearMonth.of(today.getYear(), today.getMonthValue());
%>
</body>
<script>
  let dbDays = [];
  <c:forEach var="ts" items="${listTime}">
  dbDays.push({
    date: '${ts.applicableDate}',   // dạng yyyy-MM-dd
    category: ${ts.category_id}      // 2 hoặc 3
  });
  </c:forEach>
</script>
<script>
  let currentYear = <%= ym.getYear() %>;
  let currentMonth = <%= ym.getMonthValue() %>;

  document.addEventListener("DOMContentLoaded", function() {
    renderCalendar(currentYear, currentMonth);
  });

  function changeMonth(offset) {
    currentMonth += offset;
    if (currentMonth < 1) { currentMonth = 12; currentYear--; }
    else if (currentMonth > 12) { currentMonth = 1; currentYear++; }
    renderCalendar(currentYear, currentMonth);
  }

  function renderCalendar(year, month) {
    console.log("renderCalendar chạy với", year, month);
    const monthLabel = document.getElementById("monthLabel");
    const MONTHS = [
      "Tháng Một","Tháng Hai","Tháng Ba","Tháng Tư","Tháng Năm","Tháng Sáu",
      "Tháng Bảy","Tháng Tám","Tháng Chín","Tháng Mười","Tháng Mười Một","Tháng Mười Hai"
    ];
    monthLabel.innerText = MONTHS[month - 1] + " / " + year;

    const date = new Date(year, month - 1, 1);
    const tbody = document.getElementById("calendarBody");
    tbody.innerHTML = "";

    // CHỈNH STARTINDEX CHUẨN
    let startIndex = date.getDay() - 1;
    const lastDay = new Date(year, month, 0).getDate();

    let day = 1;
    for (let week = 0; week < 6; week++) {
      let row = document.createElement("tr");
      for (let dow = 0; dow < 7; dow++) {
        let cell = document.createElement("td");
        let cellIndex = week * 7 + dow;

        if (cellIndex >= startIndex && day <= lastDay) {
          const link = document.createElement("a");
          link.href = "Time?day=" + day + "&month=" + month + "&year=" + year;
          link.style.textDecoration = "none";
          link.style.color = "inherit"; // giữ nguyên màu

// Tạo phần hiển thị ngày
          const div = document.createElement("div");
          div.innerText = day;
          const thisDate = year + "-" + String(month).padStart(2, '0') + "-" + String(day).padStart(2, '0');
          const found = dbDays.find(d => d.date === thisDate);
          // mặc định
          let css = "normal-day";

          // nếu có category 2 → màu đỏ
// category 3 → màu đen
          if (found) {
            if (found.category === 2) css = "special-day";
            if (found.category === 3) css = "maintenance-day";
          }

          div.className = "day-cell " + css;
// Gắn div vào link, rồi link vào ô
          link.appendChild(div);
          cell.appendChild(link);

          day++;
        } else {
          cell.className = "empty-cell";
        }
        row.appendChild(cell);
      }
      tbody.appendChild(row);
    }
  }
</script>
</html>
