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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <style>
        /* ---------- layout giống voucher page ---------- */
        body {
            margin: 0;
            font-family: "Helvetica Neue", Arial, sans-serif;
            background: #f6f6f6;
        }
        .top-header {
            background: #a92e28; /* đỏ chủ đạo */
            color: #fff;
            padding: 18px 24px;
            position: fixed;
            left: 0;
            right: 0;
            top: 0;
            z-index: 1000;
        }
        .top-header .brand {
            font-weight: 700;
            font-size: 28px;
        }
        .sidebar {
            width: 230px;
            background: #7b1c1c;
            color: #fff;
            position: fixed;
            top: 68px; /* dưới header */
            bottom: 0;
            padding: 20px 12px;
            overflow-y: auto;
        }
        .sidebar .nav-item {
            padding: 8px 6px;
            border-radius: 4px;
            margin-bottom: 6px;
        }
        .sidebar .nav-item:hover { background: rgba(255,255,255,0.06); cursor: pointer; }



        /* banner (khoanh đỏ) */
        .banner {
            margin-top: 18px;
            background: url('https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=1600&q=60') center/cover no-repeat;
            border-radius: 6px;
            padding: 28px 20px;
            color: #fff;
            box-shadow: 0 2px 6px rgba(0,0,0,0.08);
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: relative;      /* QUAN TRỌNG: để overlay nằm đúng */
            overflow: hidden;
        }
        /* overlay thêm vào */
        .banner::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.45);   /* chỉnh độ tối: 0.3 - 0.6 tuỳ bạn */
            z-index: 1;
        }

        /* để nội dung nổi lên trên overlay */
        .banner > * {
            position: relative;
            z-index: 2;
        }
        .banner .title {
            font-size: 26px;
            font-weight: 700;
            text-shadow: 0 1px 2px rgba(0,0,0,0.4);
        }
        .banner .actions { /* phần nút bên phải giống voucher */ }
        .banner .actions .btn {
            background: rgba(255,255,255,0.9);
            color: #7b1c1c;
            border: none;
            margin-left: 8px;
            border-radius: 6px;
        }

        /* legend + month selector */
        .controls {
            margin-top: 18px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .legend {
            display:flex;
            align-items:center;
            gap:18px;
            color:#333;
            font-weight:500;
        }
        .legend .dot {
            width:14px; height:14px; display:inline-block; margin-right:6px; border-radius:3px;
        }

        /* month selector centered */
        .month-selector {
            text-align: center;
            flex: 1;
        }
        .month-selector .nav {
            display:inline-flex;
            align-items:center;
            gap:10px;
            background:#d9cdcd;
            padding:6px 12px;
            border-radius:8px;
            box-shadow:0 1px 3px rgba(0,0,0,0.08);
        }
        .month-selector a {
            color:#7b1c1c;
            font-weight:700;
            text-decoration:none;
            padding:6px 10px;
            border-radius:6px;
        }
        .month-selector .label {
            display: flex;
            justify-content: center;
            align-items: center;
            min-width: 160px;
            text-align: center;
            flex: 1 0 auto;   /* QUAN TRỌNG: không cho flex co về 0 */
            font-weight: 700;
            font-size: 16px;
            color: #7b1c1c;
            white-space: nowrap;
        }

        /* calendar table */
        .calendar-wrap {
            margin-top: 18px;
            background: #fff;
            padding: 18px;
            border-radius: 6px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.04);
        }
        table.calendar {
            width:100%;
            border-collapse: collapse;
        }
        table.calendar thead th {
            background:#e9e9e9;
            padding:10px 6px;
            text-align:center;
            font-weight:700;
        }
        table.calendar td {
            border: 1px solid #eee;
            height: 86px;
            vertical-align: middle;
            text-align: center;
            font-size:18px;
            font-weight:600;
            padding:0;
            cursor:pointer;
        }


        .day-cell { color:#fff; display:flex; align-items:center; justify-content:center; height:100%; }
        .normal-day { background:#28a745; }       /* xanh */
        .special-day { background:#dc3545; }      /* đỏ */
        .maintenance-day { background:#111; }    /* đen */


        .empty-cell { background:transparent; cursor:default; }


        @media (max-width: 900px) {
            .sidebar { display:none; }

        }
    </style>

</head>
<body>

<!-- Header -->
<jsp:include page="/WEB-INF/views/common/header.jsp" />


<!-- Sidebar -->


<!-- Content -->
<div class="content">

    <!-- Banner -->
    <div class="banner">
        <div class="title">Khung Thời Gian Nhà Hàng</div>

    </div>

    <!-- Controls: legend + month selector -->
    <div class="controls">
        <div class="legend">
            <span class="dot" style="background:#28a745"></span> Ngày thường
            <span class="dot" style="background:#dc3545; margin-left:10px;"></span> Ngày đặc biệt
            <span class="dot" style="background:#111; margin-left:10px;"></span> Bảo trì
        </div>

        <!-- FIXED -->
        <div class="month-selector">
            <div class="nav">
                <a href="javascript:void(0)" onclick="changeMonth(-1)">&lt;</a>
                <div id="monthLabel" class="label"></div>
                <a href="javascript:void(0)" onclick="changeMonth(1)">&gt;</a>
            </div>
        </div>
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
