<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Service Statistics Report Dashboard</title>

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

    <style>
        /* SỬ DỤNG CHÍNH XÁC CSS CỦA OVERVIEW REPORT */
        :root {
            /* Color Variables */
            --main-color: #D32F2F; /* Red - Primary Button, Top Nav, Headings border */
            --light-red: #FFCDD2; /* Light Red - HR, Table hover, Chart border */
            --dark-red: #B71C1C; /* Dark Red - Headings, Strong text */
            --menu-bg: #8B0000; /* Menu Background - Sidebar */
            --menu-hover: #A52A2A; /* Menu Hover */
            --text-light: #f8f8f8;
            --text-dark: #333;
            --sidebar-width: 250px;
            --top-nav-height: 60px;
            --booking-color: #2196F3; /* Blue */
            --revenue-color: #4CAF50; /* Green */
            --cancellation-color: #E91E63; /* Pink/Red */
            --rate-color: #FF9800; /* Orange/Warning */
            --staff-chart-color: #00897B; /* Teal */
            --staff-border-color: #00897B;
            --customer-color: #1976D2; /* Customer blue */
        }

        body {
            font-family: Arial, sans-serif;
            padding: 0;
            margin: 0;
            background-color: #f4f4f4;
            padding-top: var(--top-nav-height);
            overflow-x: hidden;
        }

        .wrapper {
            display: flex;
            min-height: calc(100vh - var(--top-nav-height));
            position: relative;
        }

        /* ============== TOP NAV ============== */
        .top-nav {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            height: var(--top-nav-height);
            background-color: var(--main-color);
            color: var(--text-light);
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 15px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            z-index: 1000;
        }
        .top-nav .restaurant-group {
            display: flex;
            align-items: center;
            gap: 15px;
            flex-shrink: 0;
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
        .top-nav .user-info {
            display: flex;
            align-items: center;
            padding-right: 15px;
            font-size: 1em;
            font-weight: bold;
        }

        /* ============== SIDEBAR ============== */
        .sidebar {
            width: var(--sidebar-width);
            position: fixed;
            top: var(--top-nav-height);
            left: 0;
            bottom: 0;
            background-color: var(--menu-bg);
            color: var(--text-light);
            padding-top: 10px;
            box-shadow: 2px 0 5px rgba(0,0,0,0.1);
            z-index: 999;
            transition: transform 0.3s ease;
        }
        .sidebar ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .sidebar li a {
            display: block;
            padding: 15px 20px;
            text-decoration: none;
            color: var(--text-light);
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            transition: background-color 0.3s;
        }
        .sidebar li a:hover, .sidebar li a.active {
            background-color: var(--menu-hover);
            color: white;
        }

        /* ============== MAIN CONTENT ============== */
        .main-content-body {
            margin-left: var(--sidebar-width);
            flex-grow: 1;
            padding: 20px;
            background-color: #f4f4f4;
            min-height: 100%;
            box-sizing: border-box;
        }

        .content-container {
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.05);
            width: 100%;
            max-width: 1200px;
            margin: 0 auto;
            box-sizing: border-box;
        }

        .fixed-width-wrapper {
            width: 100%;
            overflow: hidden;
        }

        /* ============== COMPONENTS ============== */
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
            min-width: 120px;
        }
        .filter-item label {
            font-size: 0.9em;
            color: #555;
            margin-bottom: 5px;
            font-weight: bold;
        }
        .filter-item input[type="date"], .filter-item select,
        .filter-item input[type="text"] { /* Thêm input[type="text"] cho search */
            padding: 8px 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            min-width: 120px;
            font-size: 1em;
        }

        .btn-apply {
            background-color: var(--main-color);
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: bold;
            transition: background-color 0.3s;
            white-space: nowrap;
        }
        .btn-apply:hover {
            background-color: var(--dark-red);
        }

        /* Style cho nút Export khi ở bên cạnh Search */
        .export-group button {
            background-color: #0F9D58;
            color: white;
            padding: 8px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-left: 10px;
            font-size: 0.95em;
            transition: background-color 0.3s;
        }

        #btnExportPDF {
            background-color: #DB4437;
        }
        #btnExportExcel:hover {
            background-color: #0c8045;
        }
        #btnExportPDF:hover {
            background-color: #a8352b;
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
        .chart-toggle-group button:first-child {
            border-radius: 4px 0 0 4px;
        }
        .chart-toggle-group button:last-child {
            border-radius: 0 4px 4px 0;
        }
        .chart-toggle-group button.active {
            background-color: var(--main-color);
            color: white;
        }

        .checkbox-option label {
            font-size: 0.9em;
            color: #555;
            margin-left: 5px;
        }

        /* Table CSS */
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

        .report-card {
            background-color: #ffffff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            border: 1px solid #e0e0e0;
            margin-top: 20px;
        }

        .table-controls {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 15px;
            margin-bottom: 15px; /* Tăng khoảng cách dưới table controls */
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


        h1, h2, h3 {
            color: var(--dark-red);
        }
        h1 {
            border-bottom: 2px solid var(--main-color);
            padding-bottom: 10px;
        }
        hr {
            border: none;
            height: 1px;
            background-color: var(--light-red);
            margin: 20px 0;
        }

        /* Chart Container */
        #chartContainer {
            width: 100%;
            max-width: 100%;
            margin: 20px 0;
            padding: 15px;
            border: 1px solid var(--light-red);
            border-radius: 8px;
            background-color: #fffafa;
            display: flex;
            justify-content: center;
            min-height: 400px;
            overflow-x: auto;
        }
        #categoryChart {
            width: 100%;
            height: 100%;
        }

        /* Modal Popup Styles */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            z-index: 1001;
            align-items: center;
            justify-content: center;
        }

        .modal-content {
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            width: 90%;
            max-width: 450px; /* Tăng max-width để chứa 4 filter */
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }

        .modal-header h3 {
            margin: 0;
            color: var(--dark-red);
        }

        .close {
            font-size: 1.5em;
            cursor: pointer;
            color: #555;
        }

        .close:hover {
            color: var(--main-color);
        }

        .modal-form .filter-item {
            margin-bottom: 15px;
        }

        .modal-form .btn-apply {
            width: 100%;
        }

        /* NEW POPUP STYLE - Đã chỉnh sửa VỊ TRÍ (Top & Center) và MÀU SẮC */
        #missingDateAlert {
            position: fixed;
            /* Vị trí: Trên cùng (cách 20px) */
            top: 20px;
            left: 50%;
            /* Căn giữa theo chiều ngang */
            transform: translateX(-50%);

            padding: 20px 30px;
            min-width: 300px;
            max-width: 90%;

            /* Màu sắc bớt chói: Cam đậm/Đất sét */
            background-color: #E65100; /* Deep Orange/Rust */
            color: white; /* Giữ màu chữ trắng để dễ đọc */

            border-radius: 8px;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.25);
            z-index: 1002;
            display: none;
            opacity: 0;
            transition: opacity 0.3s ease-in-out; /* Dùng 0.3s cho mượt mà */
            font-weight: bold;
            text-align: center;
            font-size: 1.1em;
        }

        /* Cần thiết để đảm bảo style cột cố định không bị ảnh hưởng bởi logic JS */
        table th:nth-child(1), table td:nth-child(1) { width: 10%; min-width: 60px; text-align: center; }
        table th:nth-child(2), table td:nth-child(2) { width: 40%; min-width: 200px; max-width: 400px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        table th:nth-child(3), table td:nth-child(3) { width: 25%; min-width: 120px; text-align: right; }
        table th:nth-child(4), table td:nth-child(4) { width: 25%; min-width: 150px; text-align: right; }

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
            <c:when test="${not empty sessionScope.currentUser}">
                ${sessionScope.currentUser.fullName}
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
            <li><a href="<%= request.getContextPath() %>/user-report" ${request.getRequestURI().contains("user-report") ? "class=\"active\"" : ""}>Customer Report</a></li>
            <li><a href="<%= request.getContextPath() %>/cancel-report" ${request.getRequestURI().contains("cancel-report") ? "class=\"active\"" : ""}>Cancellation Report</a></li>
        </ul>
    </div>

    <div class="main-content-body">
        <div class="content-container">
            <h1>Service Statistics Report</h1>

            <div class="fixed-width-wrapper">
                <div class="filter-section">
                    <h3 style="color: #555; margin-top: 0; margin-bottom: 15px;">Report Filters</h3>

                    <div class="filter-grid" style="margin-bottom: 20px;">
                        <div class="filter-item" style="min-width: unset;">
                            <button class="btn-apply" onclick="openModal()"><i class="fas fa-filter"></i> Open Filter Popup</button>
                        </div>

                        <%-- XUẤT FILE ĐÃ ĐƯỢC CHUYỂN XUỐNG DƯỚI KHỐI TABLE-CONTROLS --%>
                    </div>

                    <%-- HIDDEN FORM DÙNG ĐỂ SUBMIT KHI ÁP DỤNG FILTER TỪ MODAL --%>
                    <form action="service-report" method="GET" id="filterForm" style="display: none;">
                        <input type="hidden" name="serviceType" id="hiddenServiceType" value="${requestScope.selectedServiceType}">
                        <input type="hidden" name="status" id="hiddenStatus" value="${requestScope.selectedStatus}">
                        <input type="hidden" name="startDate" id="hiddenStartDate" value="${requestScope.startDate}">
                        <input type="hidden" name="endDate" id="hiddenEndDate" value="${requestScope.endDate}">
                    </form>
                    <%-- KẾT THÚC HIDDEN FORM --%>


                    <%-- HIỂN THỊ CẢNH BÁO LỖI HỆ THỐNG --%>
                    <c:if test="${not empty requestScope.errorMessage}">
                        <div id="alertError" style="background-color: #f8d7da; color: #721c24; padding: 15px; margin-bottom: 20px; border: 1px solid #f5c6cb; border-radius: 4px;">
                            <i class="fas fa-times-circle"></i>
                            <strong>Lỗi Hệ thống:</strong> ${requestScope.errorMessage}
                        </div>
                    </c:if>

                    <%-- HIỂN THỊ CẢNH BÁO NGHIỆP VỤ (Validation, No Data) --%>
                    <c:if test="${not empty requestScope.warningMessage}">
                        <div id="alertWarning" style="background-color: #fff3cd; color: #856404; padding: 15px; margin-bottom: 20px; border: 1px solid #ffeeba; border-radius: 4px;">
                            <strong>Cảnh báo Dữ liệu:</strong> ${requestScope.warningMessage}
                        </div>
                    </c:if>
                    <%-- KẾT THÚC KHỐI CẢNH BÁO --%>

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
                                        <%-- VỊ TRÍ MỚI CỦA NÚT EXPORT (ĐƯỢC KHÔI PHỤC THEO YÊU CẦU CỦA BẠN) --%>
                                    <button type="button" id="btnExportExcel"><i class="fas fa-file-excel"></i> Export Excel</button>
                                    <button type="button" id="btnExportPDF" style="background-color: #DB4437;"><i class="fas fa-file-pdf"></i> Export PDF</button>
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
                                <c:if test="${empty requestScope.topSellingItems}">
                                    <tr id="noDataRow"><td colspan="4" style="text-align: center; color: #999;">No detailed data available.</td></tr>
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
                <hr/>
            </div>
        </div>
    </div>
</div>

<%-- MODAL LỌC ĐỒNG BỘ VỚI OVERVIEW REPORT --%>
<div id="filterModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3>Filter Report</h3>
            <span class="close" onclick="closeModal()">&times;</span>
        </div>
        <form id="modalForm" class="modal-form">
            <div class="filter-item">
                <label for="modalServiceType">Service Type</label>
                <select id="modalServiceType" name="serviceType" style="box-sizing: border-box;">
                    <option value="" ${requestScope.selectedServiceType eq null or requestScope.selectedServiceType eq '' ? 'selected' : ''}>--All Service Type --</option>
                    <c:forEach var="type" items="${requestScope.serviceTypesList}">
                        <option value="${type}" ${type eq requestScope.selectedServiceType ? 'selected' : ''}>${type}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="filter-item">
                <label for="modalStatus">Status</label>
                <select id="modalStatus" name="status" style="box-sizing: border-box;">
                    <option value="" ${requestScope.selectedStatus eq null or requestScope.selectedStatus eq '' ? 'selected' : ''}>-- All Statuses --</option>
                    <c:forEach var="stat" items="${requestScope.statusesList}">
                        <option value="${stat}" ${stat eq requestScope.selectedStatus ? 'selected' : ''}>${stat}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="filter-item">
                <label for="modalStartDate">Start Date</label>
                <input type="date" id="modalStartDate" name="startDate" value="${requestScope.startDate}" min="2025-09-01" max="2025-10-31" style="box-sizing: border-box;">
            </div>
            <div class="filter-item">
                <label for="modalEndDate">End Date</label>
                <input type="date" id="modalEndDate" name="endDate" value="${requestScope.endDate}" min="2025-09-01" max="2025-10-31" style="box-sizing: border-box;">
            </div>

            <button type="button" class="btn-apply" onclick="submitModalForm()">Apply Filter</button>
        </form>
    </div>
</div>

<div id="missingDateAlert">
    <i class="fas fa-exclamation-triangle"></i>
    Vui lòng chọn đầy đủ Ngày Bắt đầu và Ngày Kết thúc!
</div>

<script>
    const hasWarning = "${requestScope.warningMessage}" !== "";
    const ctx = document.getElementById('categoryChart')?.getContext('2d');
    let categoryChart;
    const chartContainer = document.getElementById('chartContainer');

    const reportData = [
        <c:forEach var="item" items="${requestScope.categoryReport}" varStatus="loop">
        {
            category: "${item.service_category}",
            quantity: ${item.total_quantity_sold},
            revenue: ${item.total_category_revenue}
        }<c:if test="${!loop.last}">,</c:if>
        </c:forEach>
    ];

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


    // ==================== PAGINATION & SEARCH JAVASCRIPT (FIXED) ====================

    // Chỉ khởi tạo JS cho bảng khi có dữ liệu (để tránh lỗi)
    if (!hasWarning && document.querySelector('table tbody')) {
        const tableBody = document.querySelector('table tbody');
        const paginationContainer = document.querySelector('.pagination');
        const searchInput = document.getElementById('searchInput');
        const btnSearch = document.getElementById('btnSearch');

        // Filter ra các hàng dữ liệu thực tế (loại bỏ hàng "No detailed data available" nếu có)
        const dataRows = Array.from(tableBody.querySelectorAll('tr')).filter(row => row.id !== 'noDataRow');

        // Tìm dòng NoDataRow Container (sử dụng ID 'noDataRow')
        const noDataRowContainer = document.getElementById('noDataRow');


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
                    // Cập nhật Rank dựa trên chỉ mục trong filteredRows + 1
                    rankCell.textContent = i + 1;
                }
            }

            if (noDataRowContainer) {
                if (filteredRows.length === 0) {
                    noDataRowContainer.style.display = 'table-row';
                    noDataRowContainer.querySelector('td').textContent = "No dishes found matching your search criteria.";
                } else {
                    // Ẩn dòng noDataRow nếu có dữ liệu
                    noDataRowContainer.style.display = 'none';
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

            // Logic hiển thị nút số trang (tối đa 5 nút)
            let startPage = 1;
            let endPage = pageCount;
            if (pageCount > 5) {
                startPage = Math.max(1, currentPage - 2);
                endPage = Math.min(pageCount, currentPage + 2);

                if (startPage === 1) endPage = Math.min(pageCount, 5);
                if (endPage === pageCount) startPage = Math.max(1, pageCount - 4);
            }


            for (let i = startPage; i <= endPage; i++) {
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


    // ==================== EXPORT LOGIC (FIXED) ====================

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
            // ✅ ĐÃ SỬA: Sử dụng lại tên Servlet ban đầu của bạn: ExportReportServlet
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

    // ==================== MODAL FUNCTIONS (FIXED) ====================

    // Modal Functions
    function openModal() {
        document.getElementById('filterModal').style.display = 'flex'; // Dùng 'flex' để căn giữa
        // Đồng bộ dữ liệu hiện tại
        document.getElementById('modalServiceType').value = "${requestScope.selectedServiceType}";
        document.getElementById('modalStatus').value = "${requestScope.selectedStatus}";
        document.getElementById('modalStartDate').value = "${requestScope.startDate}";
        document.getElementById('modalEndDate').value = "${requestScope.endDate}";
    }

    function closeModal() {
        document.getElementById('filterModal').style.display = 'none';
    }

    function submitModalForm() {
        const startDate = document.getElementById('modalStartDate').value;
        const endDate = document.getElementById('modalEndDate').value;
        const serviceType = document.getElementById('modalServiceType').value;
        const status = document.getElementById('modalStatus').value;
        const missingDateAlert = document.getElementById('missingDateAlert');

        // ✅ LOGIC CẢNH BÁO POPUP TỰ ĐỘNG MẤT
        if (!startDate || !endDate) {
            // 1. Hiển thị Popup
            missingDateAlert.style.display = 'block';
            setTimeout(() => {
                missingDateAlert.style.opacity = '1';
            }, 10);

            // 2. Tự động ẩn Popup sau 5 giây (5000ms)
            setTimeout(() => {
                missingDateAlert.style.opacity = '0';
                // Ẩn hoàn toàn sau khi transition (0.3s) kết thúc
                setTimeout(() => {
                    missingDateAlert.style.display = 'none';
                }, 300); // 300ms = 0.3 giây
            }, 5000); // 5 giây

            return; // Dừng submit
        }
        // -----------------------------------------------------------------

        // Validation logic Ngày Bắt đầu > Ngày Kết thúc
        if (new Date(startDate) > new Date(endDate)) {
            alert("Lỗi: Ngày Bắt đầu không được lớn hơn Ngày Kết thúc.");
            return; // Dừng submit
        }

        // Update hidden form values
        document.getElementById('hiddenServiceType').value = serviceType;
        document.getElementById('hiddenStatus').value = status;
        document.getElementById('hiddenStartDate').value = startDate;
        document.getElementById('hiddenEndDate').value = endDate;

        // Submit the hidden form
        document.getElementById('filterForm').submit();
        closeModal();
    }

    // Close modal if clicking outside
    window.onclick = function(event) {
        const modal = document.getElementById('filterModal');
        if (event.target == modal) {
            closeModal();
        }
    }
</script>
</body>
</html>