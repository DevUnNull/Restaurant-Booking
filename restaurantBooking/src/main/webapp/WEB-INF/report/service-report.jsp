<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Service Report Dashboard</title>

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

    <style>
        /* CSS KHÔNG THAY ĐỔI: Sử dụng lại CSS từ code cũ của bạn */
        :root {
            --main-color: #D32F2F;
            --light-red: #FFCDD2;
            --dark-red: #B71C1C;
            --menu-bg: #8B0000;
            --menu-hover: #A52A2A;
            --text-light: #f8f8f8;
            --text-dark: #333;
            --sidebar-width: 250px;
            --top-nav-height: 60px;
        }

        body {
            font-family: Arial, sans-serif;
            padding: 0;
            margin: 0;
            background-color: #f4f4f4;
            padding-top: var(--top-nav-height);
        }

        .wrapper {
            display: flex;
            min-height: calc(100vh - var(--top-nav-height));
            position: relative;
        }

        /* --- NAVBAR & HEADER  --- */
        .top-nav {
            position: fixed; top: 0; left: 0; right: 0; height: var(--top-nav-height);
            background-color: var(--main-color); color: var(--text-light);
            display: flex; align-items: center; justify-content: space-between;
            padding: 0; box-shadow: 0 4px 6px rgba(0,0,0,0.1); z-index: 1000;
        }

        .top-nav .restaurant-group {
            height: 100%;
            width: var(--sidebar-width);
            background-color: var(--main-color);
            display: flex;
            align-items: center;
            justify-content: flex-start;
            flex-shrink: 0;
            padding: 0 15px;
            gap: 15px;
        }

        .top-nav .restaurant-name {
            font-size: 1.2em;
            font-weight: bold;
            color: white;
            white-space: nowrap;
        }

        .home-button {
            background-color: var(--main-color);
            color: white;
            border: 1px solid var(--main-color);
            padding: 5px 10px;
            border-radius: 4px;
            text-decoration: none;
            font-size: 0.85em;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            box-shadow: 0 1px 3px rgba(0,0,0,0.2);
        }

        .home-button:hover {
            background-color: var(--dark-red);
            color: white;
            border-color: var(--dark-red);
        }

        .home-button i {
            margin-right: 5px;
        }

        .top-nav .user-info {
            display: flex;
            align-items: center;
            height: var(--top-nav-height);
            padding-right: 25px;
            font-size: 1em;
            font-weight: bold;
        }

        .sidebar {
            width: var(--sidebar-width); position: fixed; top: var(--top-nav-height);
            left: 0; bottom: 0; background-color: var(--menu-bg); color: var(--text-light);
            padding-top: 0; box-shadow: 2px 0 5px rgba(0,0,0,0.1); z-index: 999; overflow-y: auto;
        }
        .sidebar ul { list-style: none; padding: 0; margin: 0; }
        .sidebar li a {
            display: block; padding: 15px 20px; text-decoration: none; color: var(--text-light);
            border-bottom: 1px solid rgba(255, 255, 255, 0.1); transition: background-color 0.3s;
        }
        .sidebar li a:hover, .sidebar li a.active { background-color: var(--menu-hover); color: white; }

        .content {
            flex-grow: 1;
            margin-left: var(--sidebar-width);
            padding: 20px;
            background-color: #fff;
            min-height: 100%;
        }

        .filter-section {
            background-color: #fff;
            padding: 15px 20px;
            border: 1px solid #eee;
            border-radius: 6px;
            margin-bottom: 20px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }

        .filter-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            align-items: flex-end;
        }

        .filter-item {
            display: flex;
            flex-direction: column;
        }

        .filter-item label {
            font-size: 0.9em;
            color: #555;
            margin-bottom: 5px;
            font-weight: bold;
        }

        .filter-item input[type="date"],
        .filter-item select,
        .filter-item input[type="text"],
        .filter-item input[type="month"] {
            padding: 8px 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            min-width: 150px;
            font-size: 1em;
        }

        /* Bổ sung style cho nút trigger mới */
        .popup-trigger {
            padding: 8px 15px;
            border: 1px solid #ccc;
            border-radius: 4px;
            background-color: white;
            cursor: pointer;
            font-size: 1em;
            min-width: 200px;
            text-align: left;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .btn-apply {
            background-color: #D32F2F;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: bold;
            transition: background-color 0.3s;
        }

        .btn-apply:hover {
            background-color: var(--dark-red);
        }

        .export-group button {
            background-color: #1E88E5;
            color: white;
            padding: 8px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-left: 10px;
            font-size: 0.95em;
            transition: background-color 0.3s;
        }

        .export-group button:hover {
            background-color: #1565C0;
        }

        .chart-options {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            padding: 10px 0;
            border-bottom: 1px solid #eee;
        }

        .chart-toggle-group button {
            padding: 5px 10px;
            border: 1px solid var(--main-color);
            background-color: white;
            color: var(--main-color);
            cursor: pointer;
            transition: all 0.2s;
        }

        .chart-toggle-group button:first-child { border-radius: 4px 0 0 4px; }
        .chart-toggle-group button:last-child { border-radius: 0 4px 4px 0; }

        .chart-toggle-group button.active {
            background-color: var(--main-color);
            color: white;
        }

        .checkbox-option label {
            font-size: 0.9em;
            color: #555;
            margin-left: 5px;
        }

        .table-controls {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 15px;
        }

        .search-box input {
            padding: 8px 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            min-width: 250px;
            font-size: 1em;
        }

        .search-box {
            display: flex;
            align-items: center;
        }
        .search-box button {
            padding: 8px 15px;
            margin-left: 10px;
            height: 38px;
        }

        .pagination button {
            background: none;
            border: 1px solid #ccc;
            padding: 8px 12px;
            margin: 0 5px;
            border-radius: 4px;
            cursor: pointer;
        }
        .pagination button:hover:not(:disabled) { background-color: #f0f0f0; }

        .report-card {
            background-color: #ffffff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            border: 1px solid #e0e0e0;
            margin-top: 20px;
        }
        .pagination button.active {
            background-color: var(--main-color);
            color: white;
            border-color: var(--main-color);
            font-weight: bold;
        }
        .pagination button:disabled {
            background-color: #f8f8f8;
            color: #bbb;
            cursor: not-allowed;
        }

        table td {
            min-height: 50px;
            height: 50px;
            padding: 10px;
            vertical-align: middle;
            box-sizing: border-box;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 30px;
        }

        th, td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: left;
        }

        th {
            background-color: var(--light-red);
            color: var(--dark-red);
            font-weight: bold;
        }

        tbody tr:hover {
            background-color: #fce4ec;
        }

        #chartContainer {
            width: 100%;
            max-width: 800px;
            margin: 20px auto;
            padding: 15px;
            border: 1px solid var(--light-red);
            border-radius: 8px;
            background-color: #fffafa;
        }

        table th:nth-child(1),
        table td:nth-child(1) {
            width: 10%;
            min-width: 60px;
            text-align: center;
        }

        table th:nth-child(2),
        table td:nth-child(2) {
            width: 40%;
            min-width: 200px;
            max-width: 400px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        table th:nth-child(3),
        table td:nth-child(3) {
            width: 25%;
            min-width: 120px;
            text-align: right;
        }

        table th:nth-child(4),
        table td:nth-child(4) {
            width: 25%;
            min-width: 150px;
            text-align: right;
        }

        /* Popup Modal Styles */
        .popup-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            z-index: 1001;
            justify-content: center;
            align-items: center;
        }

        .popup-content {
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            width: 300px; /* Tăng chiều rộng cho 4 trường */
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            position: relative;
        }

        .popup-content h3 {
            margin: 0 0 15px 0;
            color: #555;
            font-size: 1.1em;
        }

        .popup-options {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .popup-options li {
            padding: 10px;
            cursor: pointer;
            border-bottom: 1px solid #eee;
        }

        .popup-options li:hover {
            background-color: #f4f4f4;
        }

        .popup-options li.selected {
            background-color: var(--light-red);
            font-weight: bold;
        }

        .close-popup {
            position: absolute;
            top: 10px;
            right: 10px;
            border: none;
            background: none;
            font-size: 1.2em;
            cursor: pointer;
            color: #721c24;
        }

        .popup-trigger i {
            margin-right: 10px;
        }

        h1, h2, h3 { color: var(--dark-red); }
        h1 { border-bottom: 2px solid var(--main-color); padding-bottom: 10px; }
        hr { border: none; height: 1px; background-color: var(--light-red); margin: 20px 0; }
    </style>
</head>
<body>

<div class="top-nav">
    <div class="restaurant-group">
        <a href="<%= request.getContextPath() %>/" class="home-button">
            <i class="fas fa-home"></i> Home
        </a>
        <span class="restaurant-name">Restaurant Booking</span>
    </div>
    <div class="user-info">
        <span>User:
            <c:choose>
                <c:when test="${not empty sessionScope.userName}">
                    ${sessionScope.userName}
                </c:when>
                <c:otherwise>
                    Guest
                </c:otherwise>
            </c:choose>
        </span>
    </div>
</div>

<div class="wrapper">
    <div class="sidebar">
        <ul>
            <li><a href="<%= request.getContextPath() %>/overview-report" ${request.getRequestURI().contains("overview-report") ? "class=\"active\"" : ""}>Overview Report</a></li>
            <li><a href="<%= request.getContextPath() %>/service-report" ${request.getRequestURI().contains("service-report") ? "class=\"active\"" : ""}>Service Report</a></li>
            <li><a href="<%= request.getContextPath() %>/staff-report" ${request.getRequestURI().contains("staff-report") ? "class=\"active\"" : ""}>Staff Report</a></li>
            <li><a href="<%= request.getContextPath() %>/user-report" ${request.getRequestURI().contains("customer-report") ? "class=\"active\"" : ""}>Customer Report</a></li>
            <li><a href="<%= request.getContextPath() %>/cancel-report" ${request.getRequestURI().contains("cancellation-report") ? "class=\"active\"" : ""}>Cancellation Report</a></li>
        </ul>
    </div>
    <div class="content">
        <h1>Service Statistics Report</h1>

        <div class="filter-section">
            <h3 style="color: #555; margin-top: 0; margin-bottom: 15px;">Report Filters</h3>
            <form action="service-report" method="GET" id="filterForm">
                <div class="filter-grid">

                    <div class="filter-item">
                        <button type="button" class="btn-apply popup-trigger" id="fullFilterTrigger" style="min-width: 200px; height: 38px;">
                            <i class="fas fa-filter"></i> <span id="selectedFiltersText">Apply Filters</span>
                        </button>
                    </div>

                    <div class="filter-item" style="padding-top: 5px;">
                        <button type="submit" class="btn-apply" style="display: none;"><i class="fas fa-check"></i> Apply</button>
                    </div>
                </div>

                <input type="hidden" name="serviceType" id="hiddenServiceType" value="${requestScope.selectedServiceType}">
                <input type="hidden" name="status" id="hiddenStatus" value="${requestScope.selectedStatus}">
                <input type="hidden" name="startDate" id="hiddenStartDate" value="${requestScope.startDate}">
                <input type="hidden" name="endDate" id="hiddenEndDate" value="${requestScope.endDate}">
            </form>
        </div>

        <div id="fullFilterPopup" class="popup-overlay">
            <div class="popup-content" style="width: 400px;">
                <h3><i class="fas fa-search"></i> Select Report Filters</h3>
                <button class="close-popup" id="closeFullFilter">&times;</button>

                <div style="margin-bottom: 15px;">
                    <label style="font-weight: bold; margin-bottom: 5px; display: block;">Service Type</label>
                    <select id="selectServiceType"
                            style="width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box;">
                        <option value="" ${requestScope.selectedServiceType eq null or requestScope.selectedServiceType eq '' ? 'selected' : ''}>--All Service Type --</option>
                        <c:forEach var="type" items="${requestScope.serviceTypesList}">
                            <option value="${type}" ${type eq requestScope.selectedServiceType ? 'selected' : ''}>${type}</option>
                        </c:forEach>
                    </select>
                </div>

                <div style="margin-bottom: 15px;">
                    <label style="font-weight: bold; margin-bottom: 5px; display: block;">Status</label>
                    <select id="selectStatus"
                            style="width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box;">

                        <option value="" ${requestScope.selectedStatus eq null or requestScope.selectedStatus eq '' ? 'selected' : ''}>-- All Statuses --</option>
                        <c:forEach var="stat" items="${requestScope.statusesList}">
                            <option value="${stat}" ${stat eq requestScope.selectedStatus ? 'selected' : ''}>${stat}</option>
                        </c:forEach>
                    </select>
                </div>

                <div style="margin-bottom: 15px;">
                    <label style="font-weight: bold; margin-bottom: 5px; display: block;">Start Date </label>
                    <input type="date"
                           id="inputStartDate"
                           value="${requestScope.startDate}"
                           style="width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box;"
                           min="2025-09-01"
                           max="2025-10-31"
                    >
                </div>

                <div style="margin-bottom: 20px;">
                    <label style="font-weight: bold; margin-bottom: 5px; display: block;">End Date </label>
                    <input type="date"
                           id="inputEndDate"
                           value="${requestScope.endDate}"
                           style="width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box;"
                           min="2025-09-01"
                           max="2025-10-31"
                    >
                </div>

                <button type="button" class="btn-apply" id="applyFiltersBtn" style="width: 100%; padding: 10px 0;">
                    <i class="fas fa-check"></i> Apply and View Report
                </button>
            </div>
        </div>

        <%-- ========================================================= --%>
        <%-- LOGIC HIỂN THỊ CẢNH BÁO VÀ ẨN BÁO CÁO (Đã tích hợp) --%>
        <%-- ========================================================= --%>
        <c:if test="${not empty requestScope.errorMessage}">
            <div id="alertError" style="background-color: #f8d7da; color: #721c24; padding: 15px; margin-bottom: 20px; border: 1px solid #f5c6cb; border-radius: 4px;">
                <i class="fas fa-times-circle"></i>
                <strong>System Error:</strong> ${requestScope.errorMessage}
            </div>
        </c:if>

        <c:if test="${not empty requestScope.warningMessage}">
            <div id="alertWarning" style="background-color: #fff3cd; color: #856404; padding: 15px; margin-bottom: 20px; border: 1px solid #ffeeba; border-radius: 4px;">
                <strong>Cảnh báo Dữ liệu:</strong> ${requestScope.warningMessage}
            </div>
        </c:if>

        <%-- BẮT ĐẦU KHỐI HIỂN THỊ BIỂU ĐỒ VÀ BẢNG (CHỈ KHI KHÔNG CÓ LỖI/CẢNH BÁO) --%>
        <c:if test="${empty requestScope.errorMessage and empty requestScope.warningMessage}">

            <div class="chart-options">
                <h2 style="margin: 0; color: var(--main-color);">Revenue & Quantity Report</h2>
                <div style="display: flex; align-items: center; gap: 20px;">
                    <div class="chart-toggle-group">
                        <label style="font-size: 0.9em; color: #555; margin-right: 5px;">Chart Type:</label>
                        <button class="active" data-type="bar"><i class="fas fa-chart-bar"></i> Bar</button>
                        <button data-type="line"><i class="fas fa-chart-line"></i> Line</button>
                        <button data-type="pie"><i class="fas fa-chart-pie"></i> Pie</button>
                        <button data-type="doughnut"><i class="fas fa-chart-area"></i> Doughnut</button>
                        <button data-type="polarArea"><i class="fas fa-compass"></i> Polar Area</button>
                    </div>
                    <div class="checkbox-option">
                        <input type="checkbox" id="display-revenue">
                        <label for="display-revenue">Show Revenue</label>
                    </div>
                </div>
            </div>

            <div id="chartContainer">
                <canvas id="categoryChart"></canvas>
            </div>

            <hr/>

            <div class="report-card">
                <h2>Details: Top Best-Selling Dishes</h2>
                <div class="table-controls">
                    <div class="search-box">
                        <input type="text" id="searchInput" placeholder="🔎 Search by dish name or Rank number...">
                        <button id="btnSearch" class="btn-apply" style="padding: 8px 15px; margin-left: 10px; height: 38px;">
                            <i class="fas fa-search"></i> Search
                        </button>
                    </div>
                    <div class="export-group">
                        <button type="button" id="btnExportExcel"><i class="fas fa-file-excel"></i> Export Excel</button>
                        <button type="button" id="btnExportPDF"><i class="fas fa-file-pdf"></i> Export PDF</button>
                    </div>
                </div>
                <table border="1">
                    <thead>
                    <tr>
                        <th>Rank</th>
                        <th>Dish Name</th>
                        <th>Total Quantity Sold</th>
                        <th>Revenue</th>
                    </tr>
                    </thead>
                    <tbody>
                        <%-- Real data from Controller --%>
                    <c:forEach var="item" items="${requestScope.topSellingItems}" varStatus="loop">
                        <tr>
                            <td>${loop.index + 1}</td>
                            <td>${item.item_name}</td>
                            <td>${item.total_quantity_sold}</td>
                            <td><fmt:formatNumber value="${item.total_revenue_from_item}" type="currency" currencySymbol="VND" maxFractionDigits="0"/></td>
                        </tr>
                    </c:forEach>
                        <%-- Dòng này đã được xử lý bởi logic JS/Controller: Nếu có warningMessage, khối này sẽ không chạy --%>
                    <c:if test="${empty requestScope.topSellingItems}">
                        <tr><td colspan="4" style="text-align: center; color: #999;">No detailed data available.</td></tr>
                    </c:if>
                    </tbody>
                </table>
                <div class="table-controls" style="justify-content: flex-end;">
                    <div class="pagination"></div>
                </div>
            </div>

        </c:if>
        <%-- KẾT THÚC KHỐI HIỂN THỊ BÁO CÁO --%>
    </div>
</div>

<script>
    const hasWarning = "${requestScope.warningMessage}" !== "";

    // ==================== POPUP LỌC TỔNG HỢP JAVASCRIPT (ĐÃ SỬA LỖI VỊ TRÍ) ====================
    document.addEventListener('DOMContentLoaded', function () {
        // --- Khai báo các phần tử DOM cho Pop-up mới ---
        const fullFilterTrigger = document.getElementById('fullFilterTrigger');
        const fullFilterPopup = document.getElementById('fullFilterPopup');
        const closeFullFilter = document.getElementById('closeFullFilter');
        const applyFiltersBtn = document.getElementById('applyFiltersBtn');
        const filterForm = document.getElementById('filterForm');

        // Select/Input controls trong Popup
        const selectServiceType = document.getElementById('selectServiceType');
        const selectStatus = document.getElementById('selectStatus');
        const inputStartDate = document.getElementById('inputStartDate');
        const inputEndDate = document.getElementById('inputEndDate');

        // Hidden inputs trong form
        const hiddenServiceType = document.getElementById('hiddenServiceType');
        const hiddenStatus = document.getElementById('hiddenStatus');
        const hiddenStartDate = document.getElementById('hiddenStartDate');
        const hiddenEndDate = document.getElementById('hiddenEndDate');
        const filtersTextSpan = document.getElementById('selectedFiltersText');

        // Hàm cập nhật text trên nút Trigger
        function updateFilterText() {
            // Đếm số lượng filters đang được áp dụng (giá trị không rỗng/null)
            const selectedCount = [hiddenServiceType.value, hiddenStatus.value, hiddenStartDate.value, hiddenEndDate.value].filter(v => v).length;
            filtersTextSpan.textContent = selectedCount > 0 ? `Filters Applied ` : 'Apply Filters';
        }

        // Khởi tạo text
        updateFilterText();

        // --- 1. Sự kiện mở/đóng Pop-up ---
        if (fullFilterTrigger) {
            fullFilterTrigger.addEventListener('click', function () {
                fullFilterPopup.style.display = 'flex';
                // Đồng bộ dữ liệu hiện tại (từ URL/Hidden fields) vào Popup
                selectServiceType.value = hiddenServiceType.value;
                selectStatus.value = hiddenStatus.value;
                inputStartDate.value = hiddenStartDate.value;
                inputEndDate.value = hiddenEndDate.value;
            });
        }


        if (closeFullFilter) {
            closeFullFilter.addEventListener('click', function () {
                fullFilterPopup.style.display = 'none';
            });
        }

        // Đóng Popup khi click bên ngoài
        document.addEventListener('click', function (e) {
            if (fullFilterPopup.style.display === 'flex' &&
                !fullFilterPopup.contains(e.target) &&
                e.target !== fullFilterTrigger &&
                !fullFilterTrigger.contains(e.target)) { // Kiểm tra cả element con của trigger
                fullFilterPopup.style.display = 'none';
            }
        });

        // --- 2. Sự kiện Apply Filters (Chuyển dữ liệu và Submit) ---
        if (applyFiltersBtn) {
            applyFiltersBtn.addEventListener('click', function () {
                const startDate = inputStartDate.value;
                const endDate = inputEndDate.value;

                // KIỂM TRA VALIDATION NGÀY BẮT ĐẦU VÀ KẾT THÚC (Chuyển logic bắt buộc nhập sang Controller)
                // Giữ lại: Validation logic Ngày Bắt đầu > Ngày Kết thúc (chỉ để tối ưu UX)
                if (startDate && endDate && new Date(startDate) > new Date(endDate)) {
                    alert("Lỗi: Ngày Bắt đầu không được lớn hơn Ngày Kết thúc.");
                    return;
                }

                // 1. Cập nhật các trường ẩn (Hidden Fields)
                hiddenServiceType.value = selectServiceType.value;
                hiddenStatus.value = selectStatus.value;
                hiddenStartDate.value = startDate;
                hiddenEndDate.value = endDate;

                // 2. Cập nhật text trên nút Trigger (Tùy chọn)
                updateFilterText();

                // 3. Đóng Popup và Submit Form
                fullFilterPopup.style.display = 'none';
                filterForm.submit();
            });
        }
    });

    // ==================== CHART JAVASCRIPT ====================
    const reportData = [
        <c:forEach var="item" items="${requestScope.categoryReport}" varStatus="loop">
        {
            category: "${item.service_category}",
            quantity: ${item.total_quantity_sold},
            revenue: ${item.total_category_revenue}
        }<c:if test="${!loop.last}">,</c:if>
        </c:forEach>
    ];

    const ctx = document.getElementById('categoryChart')?.getContext('2d');
    let categoryChart;
    const chartContainer = document.getElementById('chartContainer');

    const redPalette = [
        'rgba(211, 47, 47, 0.7)', 'rgba(255, 99, 132, 0.7)', 'rgba(239, 83, 80, 0.7)',
        'rgba(183, 28, 28, 0.7)', 'rgba(255, 138, 128, 0.7)', 'rgba(121, 85, 72, 0.7)',
        'rgba(197, 17, 98, 0.7)', 'rgba(255, 61, 0, 0.7)', 'rgba(255, 179, 0, 0.7)',
        'rgba(230, 74, 25, 0.7)', 'rgba(207, 102, 121, 0.7)', 'rgba(216, 27, 96, 0.7)'
    ];
    const redBorderPalette = redPalette.map(color => color.replace('0.7', '1'));

    function updateChart(chartType, isRevenue) {
        if (!ctx) return;

        if (categoryChart) {
            categoryChart.destroy();
        }

        if (reportData.length === 0) {
            return;
        }

        const labels = reportData.map(item => item.category);
        const dataValues = reportData.map(item => isRevenue ? item.revenue : item.quantity);
        const dataLabel = isRevenue ? 'Total Revenue (VND)' : 'Total Quantity Sold';

        let chartOptions = {
            responsive: true,
            plugins: {
                legend: { position: 'top' },
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            let label = context.dataset.label || '';
                            if (label) {
                                label += ': ';
                            }
                            if (context.parsed.y !== null) {
                                // Format cho Bar/Line
                                label += new Intl.NumberFormat('vi-VN', { style: isRevenue ? 'currency' : 'decimal', currency: 'VND', minimumFractionDigits: 0 }).format(context.parsed.y);
                            } else if (context.parsed !== null) {
                                // Format cho Pie/Doughnut/PolarArea
                                label += new Intl.NumberFormat('vi-VN', { style: isRevenue ? 'currency' : 'decimal', currency: 'VND', minimumFractionDigits: 0 }).format(context.parsed);
                            }
                            return label;
                        }
                    }
                }
            }
        };

        if (chartType === 'bar' || chartType === 'line') {
            chartOptions.scales = {
                y: {
                    beginAtZero: true,
                    suggestedMax: dataValues.every(val => val === 0) ? 1 : Math.max(...dataValues) * 1.1,
                    title: {
                        display: true,
                        text: dataLabel,
                        color: '#B71C1C'
                    },
                    ticks: isRevenue ? {
                        callback: function(value, index, ticks) {
                            return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND', maximumFractionDigits: 0 }).format(value);
                        }
                    } : {}
                }
            };
        }

        let datasetConfig = {
            label: dataLabel,
            data: dataValues,
            backgroundColor: (chartType === 'pie' || chartType === 'doughnut' || chartType === 'polarArea')
                ? redPalette
                : 'rgba(211, 47, 47, 0.7)',
            borderColor: (chartType === 'pie' || chartType === 'doughnut' || chartType === 'polarArea')
                ? redBorderPalette
                : redBorderPalette[0],
            borderWidth: (chartType === 'line' || chartType === 'polarArea') ? 2 : 1,
            tension: chartType === 'line' ? 0.3 : 0,
            fill: chartType === 'line'
        };

        categoryChart = new Chart(ctx, {
            type: chartType,
            data: {
                labels: labels,
                datasets: [datasetConfig]
            },
            options: chartOptions
        });
    }

    if (ctx) {
        updateChart('bar', false);
    }

    document.querySelectorAll('.chart-toggle-group button').forEach(button => {
        button.addEventListener('click', function() {
            document.querySelector('.chart-toggle-group .active').classList.remove('active');
            this.classList.add('active');
            const chartType = this.getAttribute('data-type');
            const isRevenue = document.getElementById('display-revenue').checked;
            updateChart(chartType, isRevenue);
        });
    });

    document.getElementById('display-revenue')?.addEventListener('change', function() {
        const isRevenue = this.checked;
        const chartType = document.querySelector('.chart-toggle-group .active')?.getAttribute('data-type') || 'bar';
        updateChart(chartType, isRevenue);
    });


    // ==================== PAGINATION & SEARCH JAVASCRIPT ====================
    // LƯU Ý: Nếu không có dữ liệu, code JS này sẽ không chạy được

    // Chỉ khởi tạo JS cho bảng khi có dữ liệu (để tránh lỗi)
    if (!hasWarning) {
        const tableBody = document.querySelector('table tbody');
        const paginationContainer = document.querySelector('.pagination');
        const searchInput = document.getElementById('searchInput');
        const btnSearch = document.getElementById('btnSearch');
        const dataRows = Array.from(tableBody.querySelectorAll('tr')).filter(row => row.querySelector('td:not([colspan="4"])'));
        const noDataRowContainer = tableBody.querySelector('tr td[colspan="4"]')?.parentElement;

        if (noDataRowContainer && dataRows.length > 0) {
            noDataRowContainer.style.display = 'none';
        }

        let filteredRows = [...dataRows];
        const rowsPerPage = 5;
        let currentPage = 1;

        function displayPage(page) {
            const start = (page - 1) * rowsPerPage;
            const end = start + rowsPerPage;

            dataRows.forEach(row => row.style.display = 'none');

            for (let i = start; i < end && i < filteredRows.length; i++) {
                filteredRows[i].style.display = 'table-row';
            }

            // Cập nhật lại cột Rank dựa trên filteredRows
            for (let i = 0; i < filteredRows.length; i++) {
                const rankCell = filteredRows[i].querySelector('td:first-child');
                if (rankCell && rankCell.getAttribute('data-fixed-rank') !== 'true') {
                    rankCell.textContent = i + 1;
                }
            }

            if (noDataRowContainer) {
                if (filteredRows.length === 0) {
                    noDataRowContainer.style.display = 'table-row';
                    noDataRowContainer.querySelector('td').textContent = "No dishes found matching your search criteria.";
                } else {
                    noDataRowContainer.style.display = 'none';
                    noDataRowContainer.querySelector('td').textContent = "No detailed data available.";
                }
            }
        }

        function setupPagination() {
            paginationContainer.innerHTML = '';
            const pageCount = Math.ceil(filteredRows.length / rowsPerPage);

            if (pageCount <= 1 && filteredRows.length === 0) {
                return;
            }
            if (pageCount <= 1 && filteredRows.length > 0) {
                displayPage(1);
                return;
            }

            const prevButton = document.createElement('button');
            prevButton.textContent = 'Prev';
            prevButton.disabled = currentPage === 1;
            prevButton.addEventListener('click', () => {
                if (currentPage > 1) {
                    currentPage--;
                    displayPage(currentPage);
                    setupPagination();
                }
            });
            paginationContainer.appendChild(prevButton);

            for (let i = 1; i <= pageCount; i++) {
                const pageButton = document.createElement('button');
                pageButton.textContent = i;
                pageButton.classList.toggle('active', i === currentPage);
                pageButton.addEventListener('click', () => {
                    currentPage = i;
                    displayPage(currentPage);
                    setupPagination();
                });
                paginationContainer.appendChild(pageButton);
            }

            const nextButton = document.createElement('button');
            nextButton.textContent = 'Next';
            nextButton.disabled = currentPage === pageCount;
            nextButton.addEventListener('click', () => {
                if (currentPage < pageCount) {
                    currentPage++;
                    displayPage(currentPage);
                    setupPagination();
                }
            });
            paginationContainer.appendChild(nextButton);
        }

        function handleSearch() {
            const searchTerm = searchInput.value.toLowerCase().trim();

            dataRows.forEach(row => {
                const rankCell = row.querySelector('td:first-child');
                if (rankCell) rankCell.removeAttribute('data-fixed-rank');
            });

            if (searchTerm === "") {
                filteredRows = [...dataRows];
            } else {
                const searchRank = parseInt(searchTerm);
                const isRankSearch = !isNaN(searchRank) && searchRank.toString() === searchTerm && searchRank > 0;

                if (isRankSearch) {
                    const row = dataRows[searchRank - 1];
                    if (row) {
                        filteredRows = [row];
                        const rankCell = row.querySelector('td:first-child');
                        if (rankCell) {
                            rankCell.textContent = searchRank;
                            rankCell.setAttribute('data-fixed-rank', 'true');
                        }
                    } else {
                        filteredRows = [];
                    }
                } else {
                    const standardizedSearch = searchTerm.replace(/\s/g, '');
                    filteredRows = dataRows.filter(row => {
                        const dishNameCell = row.querySelector('td:nth-child(2)');
                        if (!dishNameCell) return false;
                        const standardizedDishName = dishNameCell.textContent.toLowerCase().replace(/\s/g, '');
                        return standardizedDishName.includes(standardizedSearch);
                    });
                }
            }

            currentPage = 1;
            setupPagination();
            displayPage(currentPage);
        }

        btnSearch?.addEventListener('click', handleSearch);

        searchInput?.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                handleSearch();
                e.preventDefault();
            }
        });

        setupPagination();
        displayPage(currentPage);
    }


    // ==================== EXPORT LOGIC ====================

    // Hàm lấy tham số lọc
    function getFilterParams() {
        const urlParams = new URLSearchParams(window.location.search);
        let params = '';
        const startDate = urlParams.get('startDate') || '';
        const endDate = urlParams.get('endDate') || '';
        const serviceType = urlParams.get('serviceType') || '';
        const status = urlParams.get('status') || '';
        const timeRange = urlParams.get('timeRange') || '';

        if (startDate) params += '&startDate=' + startDate;
        if (endDate) params += '&endDate=' + endDate;
        if (serviceType) params += '&serviceType=' + serviceType;
        if (status) params += '&status=' + status;
        if (timeRange) params += '&timeRange=' + timeRange;

        return params;
    }

    const btnExportExcel = document.getElementById('btnExportExcel');
    const btnExportPDF = document.getElementById('btnExportPDF');

    // Hàm xử lý việc Export (áp dụng Pop-up xác nhận)
    function handleExport(type) {
        // KIỂM TRA NGHIỆP VỤ: Không cho export nếu đang có cảnh báo (không có dữ liệu)
        if (hasWarning) {
            alert("Không thể Export. Vui lòng điều chỉnh bộ lọc để có dữ liệu báo cáo.");
            return;
        }

        const params = getFilterParams();
        let message;

        if (type === 'excel') {
            message = "Bạn có chắc chắn muốn tải xuống báo cáo dưới dạng tệp Excel không?";
        } else if (type === 'pdf') {
            message = "Bạn có chắc chắn muốn tải xuống báo cáo dưới dạng tệp PDF không?";
        } else {
            return;
        }

        const userConfirmed = confirm(message);

        if (userConfirmed) {
            // Giả định bạn có Servlet ExportReportServlet để xử lý export
            window.location.href = "ExportReportServlet?type=" + type + params;
        }
    }

    // Gắn sự kiện click vào các nút Export
    btnExportExcel?.addEventListener('click', function () {
        handleExport('excel');
    });

    btnExportPDF?.addEventListener('click', function () {
        handleExport('pdf');
    });
</script>
</body>
</html>