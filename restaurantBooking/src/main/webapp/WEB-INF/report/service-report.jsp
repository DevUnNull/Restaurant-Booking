<%-- File: service-report.jsp (Đã cập nhật) --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bảng Điều Khiển Báo Cáo Thống Kê Dịch Vụ</title>

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

    <style>
        :root {
            /* Color Variables */
            --main-color: #D32F2F;
            --light-red: #FFCDD2;
            --dark-red: #B71C1C;
            --menu-bg: #8B0000;
            --menu-hover: #A52A2A;
            --text-light: #f8f8f8;
            --text-dark: #333;
            --sidebar-width: 250px;
            --top-nav-height: 60px;
            --booking-color: #2196F3; /* Blue */
            --revenue-color: #4CAF50; /* Green */

            /* THÊM MÀU MỚI CHO KPI */
            --completed-color: #4CAF50;
            --cancelled-color: #F44336;
            --noshow-color: #FF9800;
            --pending-color: #2196F3;
            --checkedin-color: #9C27B0;
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

        /* ============== TOP NAV (Giữ nguyên) ============== */
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

        /* ============== SIDEBAR (Giữ nguyên) ============== */
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

        /* ============== MAIN CONTENT (Giữ nguyên) ============== */
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

        /* ============== COMPONENTS (Giữ nguyên) ============== */
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
        .filter-item input[type="text"] {
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

        .checkbox-option {
            display: flex;
            align-items: center;
        }
        .checkbox-option label {
            font-size: 0.9em;
            color: #555;
            margin-left: 5px;
        }

        /* Table CSS (Giữ nguyên) */
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
            margin-bottom: 15px;
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

        /* Chart Container (Giữ nguyên) */
        #trendChartContainer {
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
        #trendChart {
            width: 100%;
            height: 100%;
        }

        /* === THÊM CSS CHO KPI CARDS === */
        .kpi-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 15px;
            margin-top: 20px;
            margin-bottom: 20px;
        }
        .kpi-card {
            background-color: #fff;
            border-radius: 8px;
            padding: 15px;
            text-align: center;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            border-left: 5px solid var(--main-color);
        }
        .kpi-card h4 {
            margin: 0 0 10px 0;
            font-size: 1em;
            color: #555;
        }
        .kpi-card .kpi-value {
            font-size: 2em;
            font-weight: bold;
            color: var(--main-color);
        }
        .kpi-card.completed { border-color: var(--completed-color); }
        .kpi-card.completed .kpi-value { color: var(--completed-color); }
        .kpi-card.cancelled { border-color: var(--cancelled-color); }
        .kpi-card.cancelled .kpi-value { color: var(--cancelled-color); }
        .kpi-card.no_show { border-color: var(--noshow-color); }
        .kpi-card.no_show .kpi-value { color: var(--noshow-color); }
        .kpi-card.pending { border-color: var(--pending-color); }
        .kpi-card.pending .kpi-value { color: var(--pending-color); }
        .kpi-card.checked_in { border-color: var(--checkedin-color); }
        .kpi-card.checked_in .kpi-value { color: var(--checkedin-color); }


        /* Modal Popup Styles (Giữ nguyên) */
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
            max-width: 450px;
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

        /* Popup Cảnh Báo (Giữ nguyên) */
        #missingDateAlert {
            position: fixed;
            top: 20px;
            left: 50%;
            transform: translateX(-50%);
            padding: 20px 30px;
            min-width: 300px;
            max-width: 90%;
            background-color: #fff3e0;
            color: #D32F2F;
            border-radius: 8px;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.25);
            z-index: 1002;
            display: none;
            opacity: 0;
            transition: opacity 0.3s ease-in-out;
            font-weight: bold;
            text-align: center;
            font-size: 1.1em;
            border: 1px solid #FF9800;
        }

        /* Table Widths (Giữ nguyên) */
        table th:nth-child(1), table td:nth-child(1) { width: 10%; min-width: 60px; text-align: center; }
        table th:nth-child(2), table td:nth-child(2) { width: 40%; min-width: 200px; max-width: 400px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        table th:nth-child(3), table td:nth-child(3) { width: 25%; min-width: 120px; text-align: right; }
        table th:nth-child(4), table td:nth-child(4) { width: 25%; min-width: 150px; text-align: right; }

        @media (max-width: 768px) {
            .sidebar {
                transform: translateX(-100%);
            }
            .sidebar.active {
                transform: translateX(0);
            }
            .main-content-body {
                margin-left: 0;
            }
            .filter-grid {
                flex-direction: column;
                align-items: stretch;
            }
            .filter-grid > .filter-item {
                width: 100%;
            }
            .filter-item input[type="date"], .filter-item select, .filter-item input[type="text"] {
                width: 100%;
            }
            .table-controls {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
            .search-box {
                width: 100%;
            }
            .search-box input {
                min-width: 0;
                flex-grow: 1;
            }
            .export-group {
                align-self: flex-end;
            }
            .chart-options {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
                border-bottom: none;
            }
            .chart-toggle-group {
                display: inline-flex;
            }
            .checkbox-option {
                padding-left: 5px;
            }
            /* THÊM: Cho KPI cards xuống 2 cột trên di động */
            .kpi-container {
                grid-template-columns: repeat(2, 1fr);
            }
        }
    </style>
</head>
<body>

<%-- TOP NAV (Giữ nguyên) --%>
<div class="top-nav">
    <div class="restaurant-group">
        <a href="<%= request.getContextPath() %>/" class="home-button">
            <i class="fas fa-home"></i> Trang Chủ
        </a>
    </div>
    <div class="user-info">
    <span>Người dùng:
        <c:choose>
            <c:when test="${not empty sessionScope.currentUser}">
                ${sessionScope.currentUser.fullName}
            </c:when>
            <c:otherwise>
                Khách
            </c:otherwise>
        </c:choose>
    </span>
    </div>
</div>

<%-- WRAPPER VÀ SIDEBAR (Giữ nguyên) --%>
<div class="wrapper">
    <div class="sidebar">
        <ul>
            <li><a href="<%= request.getContextPath() %>/overview-report" ${request.getRequestURI().contains("overview-report") ? "class=\"active\"" : ""}>Báo Cáo Tổng Quan</a></li>
            <li><a href="<%= request.getContextPath() %>/service-report" ${request.getRequestURI().contains("service-report") ? "class=\"active\"" : ""}>Báo Cáo Dịch Vụ</a></li>
            <li><a href="<%= request.getContextPath() %>/staff-report" ${request.getRequestURI().contains("staff-report") ? "class=\"active\"" : ""}>Báo Cáo Nhân Viên</a></li>
            <li><a href="<%= request.getContextPath() %>/user-report" ${request.getRequestURI().contains("user-report") ? "class=\"active\"" : ""}>Báo Cáo Khách Hàng</a></li>
            <li><a href="<%= request.getContextPath() %>/cancel-report" ${request.getRequestURI().contains("cancel-report") ? "class=\"active\"" : ""}>Báo Cáo Hủy</a></li>
        </ul>
    </div>

    <div class="main-content-body">
        <div class="content-container">
            <h1>Báo Cáo Thống Kê Dịch Vụ</h1>

            <div class="fixed-width-wrapper">
                <div class="filter-section">
                    <h3 style="color: #555; margin-top: 0; margin-bottom: 15px;">Bộ Lọc Báo Cáo</h3>

                    <%-- KHU VỰC NÚT LỌC VÀ FORM (Giữ nguyên) --%>
                    <div class="filter-grid" style="margin-bottom: 20px;">
                        <div class="filter-item" style="min-width: unset;">
                            <button class="btn-apply" onclick="openModal()"><i class="fas fa-filter"></i> Mở Bộ Lọc</button>
                        </div>
                        <c:if test="${empty requestScope.errorMessage and requestScope.hasData}">
                            <div class="filter-item" style="min-width: unset;">
                                <button type="button" id="btnExportExcel_Top" class="btn-apply" style="background-color: #0F9D58;"><i class="fas fa-file-excel"></i> Xuất Excel</button>
                            </div>
                            <div class="filter-item" style="min-width: unset;">
                                <button type="button" id="btnExportPDF_Top" class="btn-apply" style="background-color: #DB4437;"><i class="fas fa-file-pdf"></i> Xuất PDF</button>
                            </div>
                        </c:if>
                    </div>

                    <form action="service-report" method="GET" id="filterForm" style="display: none;">
                        <input type="hidden" name="serviceType" id="hiddenServiceType" value="${requestScope.selectedServiceType}">
                        <input type="hidden" name="status" id="hiddenStatus" value="${requestScope.selectedStatus}">
                        <input type="hidden" name="startDate" id="hiddenStartDate" value="${requestScope.startDate}">
                        <input type="hidden" name="endDate" id="hiddenEndDate" value="${requestScope.endDate}">
                        <input type="hidden" name="timeGrouping" id="hiddenTimeGrouping" value="${requestScope.selectedTimeGrouping}">
                    </form>

                    <%-- KHU VỰC HIỂN THỊ LỖI VÀ CẢNH BÁO (Giữ nguyên) --%>
                    <c:if test="${not empty requestScope.errorMessage}">
                        <div id="alertError" style="background-color: #f8d7da; color: #721c24; padding: 15px; margin-bottom: 20px; border: 1px solid #f5c6cb; border-radius: 4px;">
                            <i class="fas fa-times-circle"></i>
                            <strong>Lỗi Hệ thống:</strong> ${requestScope.errorMessage}
                        </div>
                    </c:if>
                    <c:if test="${not empty requestScope.warningMessage}">
                        <div id="alertWarning" style="background-color: #fff3cd; color: #856404; padding: 15px; margin-bottom: 20px; border: 1px solid #ffeeba; border-radius: 4px;">
                                ${requestScope.warningMessage}
                        </div>
                    </c:if>


                    <%-- KHỐI HIỂN THỊ BÁO CÁO (Logic <c:if> giữ nguyên) --%>
                    <c:if test="${empty requestScope.errorMessage and requestScope.reportRunAttempted}">

                        <%-- KHU VỰC BIỂU ĐỒ (Layout HTML giữ nguyên) --%>
                        <div class="chart-options">
                            <h2 style="margin: 0; color: var(--main-color);">Xu Hướng Doanh Thu & Đặt Bàn</h2>
                            <div style="display: flex; flex-wrap: wrap; align-items: center; gap: 20px;">
                                <div class="chart-toggle-group" id="timeGroupingToggle">
                                    <button data-group="day" class="${requestScope.selectedTimeGrouping eq 'day' ? 'active' : ''}">Ngày</button>
                                    <button data-group="week" class="${requestScope.selectedTimeGrouping eq 'week' ? 'active' : ''}">Tuần</button>
                                    <button data-group="month" class="${requestScope.selectedTimeGrouping eq 'month' ? 'active' : ''}">Tháng</button>
                                </div>
                                <div class="chart-toggle-group" id="trendChartToggle">
                                    <button data-type="line" class="active"><i class="fas fa-chart-line"></i> Đường</button>
                                    <button data-type="bar"><i class="fas fa-chart-bar"></i> Cột</button>
                                </div>
                                <div class="checkbox-option" style="margin-left: 10px;">
                                    <input type="checkbox" id="trend-show-bookings" checked>
                                    <label for="trend-show-bookings">Hiển Thị Lượt Đặt</label>
                                </div>
                            </div>
                        </div>

                        <div id="trendChartContainer">
                            <canvas id="trendChart"></canvas>
                        </div>

                        <%-- === THÊM KHU VỰC KPI CARDS === --%>
                        <%-- Chỉ hiển thị các thẻ này nếu đang lọc "All" --%>
                        <c:if test="${requestScope.selectedStatus eq 'All'}">
                            <div class="kpi-container">
                                <div class="kpi-card completed">
                                    <h4>Hoàn thành</h4>
                                    <div class="kpi-value" id="kpi-completed">0</div>
                                </div>
                                <div class="kpi-card pending">
                                    <h4>Chờ xác nhận</h4>
                                    <div class="kpi-value" id="kpi-pending">0</div>
                                </div>
                                <div class="kpi-card checked_in">
                                    <h4>Đã xác nhận</h4>
                                    <div class="kpi-value" id="kpi-checked_in">0</div>
                                </div>
                                <div class="kpi-card cancelled">
                                    <h4>Đã hủy</h4>
                                    <div class="kpi-value" id="kpi-cancelled">0</div>
                                </div>
                                <div class="kpi-card no_show">
                                    <h4>Không đến</h4>
                                    <div class="kpi-value" id="kpi-no_show">0</div>
                                </div>
                            </div>
                        </c:if>

                        <hr/>

                        <%-- KHU VỰC BẢNG (Giữ nguyên) --%>
                        <div class="report-card">
                            <h2>Chi Tiết: Các Món Bán Chạy Nhất</h2>
                            <div class="table-controls">
                                <div class="search-box">
                                    <input type="text" id="searchInput" placeholder="Tìm kiếm theo tên món hoặc số Hạng...">
                                    <button id="btnSearch" class="btn-apply" style="padding: 8px 15px; margin-left: 10px; height: 38px;">
                                        <i class="fas fa-search"></i> Tìm Kiếm
                                    </button>
                                </div>
                            </div>
                            <table border="1">
                                <thead>
                                <tr>
                                    <th>Hạng</th>
                                    <th>Tên Món</th>
                                    <th>Tổng Số Lượng Bán</th>
                                    <th>Doanh Thu</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="item" items="${requestScope.topSellingItems}" varStatus="loop">
                                    <tr>
                                        <td>${loop.index + 1}</td>
                                        <td>${item.item_name}</td>
                                        <td>${item.total_quantity_sold}</td>
                                        <td><fmt:formatNumber value="${item.total_revenue_from_item}" type="currency" currencySymbol="VND" maxFractionDigits="0"/></td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty requestScope.topSellingItems}">
                                    <tr id="noDataRow"><td colspan="4" style="text-align: center; color: #999;">Không có dữ liệu chi tiết.</td></tr>
                                </c:if>
                                </tbody>
                            </table>
                            <div class="table-controls" style="justify-content: flex-end;">
                                <div class="pagination"></div>
                            </div>
                        </div>

                    </c:if>
                    <%-- === KẾT THÚC KHỐI <c:if> === --%>
                </div>
                <hr/>
            </div>
        </div>
    </div>
</div>

<%-- MODAL LỌC (Giữ nguyên) --%>
<div id="filterModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3>Lọc Báo Cáo</h3>
            <span class="close" onclick="closeModal()">&times;</span>
        </div>
        <form id="modalForm" class="modal-form">
            <div class="filter-item">
                <label for="modalServiceType">Loại Dịch Vụ</label>
                <select id="modalServiceType" name="serviceType" style="box-sizing: border-box;">
                    <option value="" ${requestScope.selectedServiceType eq null or requestScope.selectedServiceType eq '' ? 'selected' : ''}>--Tất cả Loại Dịch Vụ --</option>
                    <c:forEach var="type" items="${requestScope.serviceTypesList}">
                        <option value="${type}" ${type eq requestScope.selectedServiceType ? 'selected' : ''}>${type}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="filter-item">
                <label for="modalStatus">Trạng Thái</label>
                <select id="modalStatus" name="status" style="box-sizing: border-box;">
                    <c:forEach var="entry" items="${requestScope.statusesMap}">
                        <option value="${entry.key}" ${entry.key eq requestScope.selectedStatus ? 'selected' : ''}>
                                ${entry.value}
                        </option>
                    </c:forEach>
                </select>
            </div>
            <div class="filter-item">
                <label for="modalStartDate">Ngày Bắt Đầu</label>
                <input type="date" id="modalStartDate" name="startDate" value="${requestScope.startDate}" style="box-sizing: border-box;">
            </div>
            <div class="filter-item">
                <label for="modalEndDate">Ngày Kết Thúc</label>
                <input type="date" id="modalEndDate" name="endDate" value="${requestScope.endDate}" style="box-sizing: border-box;">
            </div>
            <button type="button" class="btn-apply" onclick="submitModalForm()">Áp Dụng Bộ Lọc</button>
        </form>
    </div>
</div>

<%-- POPUP CẢNH BÁO (Giữ nguyên) --%>
<div id="missingDateAlert">
    <i class="fas fa-exclamation-triangle"></i>
    Vui lòng chọn đầy đủ Ngày Bắt đầu và Ngày Kết thúc!
</div>

<%-- ================================================= --%>
<%--                PHẦN JAVASCRIPT (Đã sửa)           --%>
<%-- ================================================= --%>
<script>
    // === SỬA ĐỔI 1: Lấy TOÀN BỘ dữ liệu chi tiết ===
    // ĐÃ SỬA LỖI: Ánh xạ đúng các trường từ Java (requestScope.trendReport)
    const trendData = [
        <c:forEach var="item" items="${requestScope.trendReport}" varStatus="loop">
        {
            date: "${item.report_date}",
            revenue: ${item.total_revenue},
            total_bookings: ${item.total_bookings}, // Dùng cho biểu đồ cột

            // Dữ liệu chi tiết cho KPI cards (ĐÃ SỬA)
            completed: ${item.completed_bookings},
            cancelled: ${item.cancelled_bookings},
            no_show: ${item.no_show_bookings},
            pending: ${item.pending_bookings},
            checked_in: ${item.checked_in_bookings}

        }<c:if test="${!loop.last}">,</c:if>
        </c:forEach>
    ];

    const ctxTrend = document.getElementById('trendChart')?.getContext('2d');
    let trendChart;

    // Màu cho biểu đồ
    const REVENUE_COLOR = 'rgba(211, 47, 47, 0.9)'; // Đỏ đậm
    const BOOKING_COLOR = 'rgba(33, 150, 243, 0.7)'; // Xanh (Booking)
    const BOOKING_BORDER_COLOR = 'rgba(33, 150, 243, 1)';


    // ===================================
    // HÀM VẼ BIỂU ĐỒ XU HƯỚNG
    // ===================================
    function updateTrendChart(revenueChartType = 'line', showBookings = true) {
        if (!ctxTrend) return;
        if (trendChart) trendChart.destroy();

        const labels = trendData.map(item => item.date);
        const revenueValues = trendData.map(item => item.revenue);

        // Lấy 'total_bookings' cho biểu đồ
        const bookingValues = trendData.map(item => item.total_bookings);

        // Chỉ còn 2 datasets
        let datasets = [
            // 1. Dataset Doanh thu (Y-axis 1)
            {
                type: revenueChartType,
                label: 'Tổng Doanh Thu (VND)',
                data: revenueValues,
                backgroundColor: revenueChartType === 'line' ? 'transparent' : REVENUE_COLOR,
                borderColor: REVENUE_COLOR,
                borderWidth: 2,
                yAxisID: 'yRevenue',
                tension: 0.1,
                fill: revenueChartType === 'line'
            },
            // 2. Dataset Lượt đặt (Y-axis 2)
            {
                type: 'bar',
                label: 'Tổng Lượt Đặt',
                data: bookingValues,
                backgroundColor: BOOKING_COLOR,
                borderColor: BOOKING_BORDER_COLOR,
                borderWidth: 1,
                yAxisID: 'yBookings',
                hidden: !showBookings
            }
        ];

        trendChart = new Chart(ctxTrend, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: datasets
            },
            options: {
                responsive: true,
                plugins: {
                    legend: { position: 'top' },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                let label = context.dataset.label || '';
                                if (label) { label += ': '; }
                                const isRevenue = context.dataset.yAxisID === 'yRevenue';
                                const style = isRevenue ? 'currency' : 'decimal';
                                label += new Intl.NumberFormat('vi-VN', { style: style, currency: 'VND', minimumFractionDigits: 0 }).format(context.parsed.y);
                                return label;
                            }
                        }
                    }
                },
                scales: {
                    yRevenue: {
                        type: 'linear',
                        position: 'left',
                        beginAtZero: true,
                        title: { display: true, text: 'Doanh Thu (VND)', color: REVENUE_COLOR },
                        ticks: {
                            callback: function(value) {
                                return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND', maximumFractionDigits: 0 }).format(value);
                            }
                        }
                    },
                    yBookings: {
                        type: 'linear',
                        position: 'right',
                        beginAtZero: true,
                        title: { display: true, text: 'Lượt Đặt', color: BOOKING_BORDER_COLOR },
                        grid: {
                            drawOnChartArea: false,
                        },
                        ticks: {
                            callback: function(value) {
                                if (Number.isInteger(value)) return value;
                            }
                        }
                    },
                    x: {
                        title: { display: true, text: 'Ngày' }
                    }
                }
            }
        });
    }

    // === HÀM MỚI: Tính toán và cập nhật KPI Cards ===
    function updateKPICards() {
        // Chỉ chạy nếu các thẻ KPI tồn tại (tức là đang lọc "All")
        const kpiElement = document.getElementById('kpi-completed');
        if (!kpiElement) return;

        // Tính tổng
        const totalCompleted = trendData.reduce((acc, item) => acc + item.completed, 0);
        const totalCancelled = trendData.reduce((acc, item) => acc + item.cancelled, 0);
        const totalNoShow = trendData.reduce((acc, item) => acc + item.no_show, 0);
        const totalPending = trendData.reduce((acc, item) => acc + item.pending, 0);
        const totalCheckedIn = trendData.reduce((acc, item) => acc + item.checked_in, 0);

        // Cập nhật DOM
        kpiElement.textContent = totalCompleted;
        document.getElementById('kpi-cancelled').textContent = totalCancelled;
        document.getElementById('kpi-no_show').textContent = totalNoShow;
        document.getElementById('kpi-pending').textContent = totalPending;
        document.getElementById('kpi-checked_in').textContent = totalCheckedIn;
    }


    // ===================================
    // KHỞI TẠO VÀ GẮN SỰ KIỆN
    // ===================================
    document.addEventListener('DOMContentLoaded', () => {
        // Chỉ khởi tạo nếu biểu đồ tồn tại (reportRunAttempted == true)
        if (ctxTrend) {
            updateTrendChart('line', true);
            updateKPICards(); // <<< Chạy hàm KPI
        }

        // Sự kiện cho Biểu đồ XU HƯỚNG
        document.querySelectorAll('#trendChartToggle button').forEach(button => {
            button.addEventListener('click', function() {
                document.querySelector('#trendChartToggle .active').classList.remove('active');
                this.classList.add('active');
                const chartType = this.getAttribute('data-type');
                const showBookings = document.getElementById('trend-show-bookings').checked;
                updateTrendChart(chartType, showBookings);
            });
        });

        document.getElementById('trend-show-bookings')?.addEventListener('change', function() {
            const chartType = document.querySelector('#trendChartToggle .active')?.getAttribute('data-type') || 'line';
            updateTrendChart(chartType, this.checked);
        });

        // Sự kiện cho Nút Ngày/Tuần/Tháng
        document.querySelectorAll('#timeGroupingToggle button').forEach(button => {
            button.addEventListener('click', function() {
                if (this.classList.contains('active')) return;
                const currentActive = document.querySelector('#timeGroupingToggle .active');
                if(currentActive) {
                    currentActive.classList.remove('active');
                }
                this.classList.add('active');
                submitModalForm(true);
            });
        });

        // ==================== PAGINATION & SEARCH ====================
        const tableBody = document.querySelector('table tbody');
        const paginationContainer = document.querySelector('.pagination');
        const searchInput = document.getElementById('searchInput');
        const btnSearch = document.getElementById('btnSearch');

        let allDataRows = [];
        let filteredRows = [];
        const noDataRow = document.getElementById('noDataRow');
        const ROWS_PER_PAGE = 5;
        let currentPage = 1;

        if (tableBody) {
            allDataRows = Array.from(tableBody.querySelectorAll('tr')).filter(row => row.id !== 'noDataRow');
            filteredRows = [...allDataRows];
        }

        function displayPage(page) {
            if (!tableBody) return;
            const start = (page - 1) * ROWS_PER_PAGE;
            const end = start + ROWS_PER_PAGE;
            allDataRows.forEach(row => row.style.display = 'none');
            filteredRows.slice(start, end).forEach(row => {
                row.style.display = 'table-row';
            });

            if (noDataRow) {
                if (filteredRows.length === 0) {
                    noDataRow.style.display = 'table-row';
                    noDataRow.querySelector('td').textContent = "Không tìm thấy món ăn nào phù hợp.";
                } else {
                    noDataRow.style.display = 'none';
                }
            }
        }

        function handleSearch() {
            if (!tableBody) return;
            const term = searchInput.value.trim().toLowerCase().replace(/\s+/g, ' ');
            if (term === '') {
                filteredRows = [...allDataRows];
            } else {
                const isRankSearch = /^\d+$/.test(term);
                filteredRows = allDataRows.filter(row => {
                    const rankText = row.cells[0]?.textContent || '';
                    const dishName = row.cells[1]?.textContent || '';
                    if (isRankSearch) {
                        return rankText === term;
                    } else {
                        return dishName.toLowerCase().includes(term);
                    }
                });
            }
            currentPage = 1;
            displayPage(currentPage);
            setupPagination();
        }

        function setupPagination() {
            if (!paginationContainer) return;
            paginationContainer.innerHTML = '';
            const pageCount = Math.ceil(filteredRows.length / ROWS_PER_PAGE);
            if (pageCount <= 1) return;

            const prevBtn = document.createElement('button');
            prevBtn.textContent = 'Trước';
            prevBtn.disabled = currentPage === 1;
            prevBtn.addEventListener('click', () => {
                if (currentPage > 1) {
                    currentPage--;
                    displayPage(currentPage);
                    setupPagination();
                }
            });
            paginationContainer.appendChild(prevBtn);

            let startPage = Math.max(1, currentPage - 2);
            let endPage = Math.min(pageCount, currentPage + 2);
            if (endPage - startPage < 4) {
                if (currentPage <= 3) endPage = Math.min(5, pageCount);
                else startPage = Math.max(pageCount - 4, 1);
            }

            for (let i = startPage; i <= endPage; i++) {
                const pageBtn = document.createElement('button');
                pageBtn.textContent = i;
                pageBtn.classList.toggle('active', i === currentPage);
                pageBtn.addEventListener('click', () => {
                    currentPage = i;
                    displayPage(currentPage);
                    setupPagination();
                });
                paginationContainer.appendChild(pageBtn);
            }

            const nextBtn = document.createElement('button');
            nextBtn.textContent = 'Sau';
            nextBtn.disabled = currentPage === pageCount;
            nextBtn.addEventListener('click', () => {
                if (currentPage < pageCount) {
                    currentPage++;
                    displayPage(currentPage);
                    setupPagination();
                }
            });
            paginationContainer.appendChild(nextBtn);
        }

        if (btnSearch) btnSearch.addEventListener('click', handleSearch);
        if (searchInput) {
            searchInput.addEventListener('keypress', e => {
                if (e.key === 'Enter') {
                    handleSearch();
                    e.preventDefault();
                }
            });
        }

        if (tableBody && (allDataRows.length > 0 || noDataRow)) {
            allDataRows.sort((a, b) => {
                const rankA = parseInt(a.cells[0]?.textContent || '0');
                const rankB = parseInt(b.cells[0]?.textContent || '0');
                return rankA - rankB;
            });
            filteredRows = [...allDataRows];
            displayPage(1);
            setupPagination();
        }

        // ==================== EXPORT LOGIC ====================
        const btnExportExcel_Top = document.getElementById('btnExportExcel_Top');
        const btnExportPDF_Top = document.getElementById('btnExportPDF_Top');
        function getFilterParams() {
            const startDate = document.getElementById('hiddenStartDate').value;
            const endDate = document.getElementById('hiddenEndDate').value;
            const serviceType = document.getElementById('hiddenServiceType').value;
            const status = document.getElementById('hiddenStatus').value;
            const timeGrouping = document.getElementById('hiddenTimeGrouping').value;
            let params = '';
            if (startDate) params += '&startDate=' + startDate;
            if (endDate) params += '&endDate=' + endDate;
            if (serviceType) params += '&serviceType=' + serviceType;
            if (status) params += '&status=' + status;
            if (timeGrouping) params += '&timeGrouping=' + timeGrouping;
            return params;
        }

        function handleExport(type) {
            if (!${requestScope.hasData}) {
                alert("Không thể xuất báo cáo khi chưa có dữ liệu. Vui lòng kiểm tra lại bộ lọc.");
                return;
            }
            const params = getFilterParams();
            let message;
            if (type === 'excel') message = "Bạn có chắc chắn muốn tải xuống báo cáo dưới dạng tệp Excel không?";
            else if (type === 'pdf') message = "Bạn có chắc chắn muốn tải xuống báo cáo dưới dạng tệp PDF không?";
            else return;
            const userConfirmed = confirm(message);
            if (userConfirmed) {
                window.location.href = "ExportServiceReportServlet?type=" + type + params;
            }
        }
        btnExportExcel_Top?.addEventListener('click', () => handleExport('excel'));
        btnExportPDF_Top?.addEventListener('click', () => handleExport('pdf'));
    });

    // ==================== MODAL FUNCTIONS ====================
    // Đặt các hàm này bên ngoài DOMContentLoaded để onclick="" có thể thấy chúng
    function openModal() {
        document.getElementById('filterModal').style.display = 'flex';
        document.getElementById('modalServiceType').value = document.getElementById('hiddenServiceType').value;
        document.getElementById('modalStatus').value = document.getElementById('hiddenStatus').value;
        document.getElementById('modalStartDate').value = document.getElementById('hiddenStartDate').value;
        document.getElementById('modalEndDate').value = document.getElementById('hiddenEndDate').value;
    }

    function closeModal() {
        document.getElementById('filterModal').style.display = 'none';
    }

    function submitModalForm(autoSubmit = false) {
        const startDate = document.getElementById('modalStartDate').value;
        const endDate = document.getElementById('modalEndDate').value;
        const serviceType = document.getElementById('modalServiceType').value;
        const status = document.getElementById('modalStatus').value;
        const timeGrouping = document.querySelector('#timeGroupingToggle .active')?.dataset.group || 'day';
        const missingDateAlert = document.getElementById('missingDateAlert');
        if (!startDate || !endDate) {
            if (autoSubmit) {
                document.querySelectorAll('#timeGroupingToggle button').forEach(btn => {
                    btn.classList.toggle('active', btn.dataset.group === '${requestScope.selectedTimeGrouping}');
                });
                return;
            }
            missingDateAlert.textContent = '⚠️ Vui lòng chọn đầy đủ Ngày Bắt đầu và Ngày Kết thúc!';
            missingDateAlert.style.display = 'block';
            setTimeout(() => { missingDateAlert.style.opacity = '1'; }, 10);
            setTimeout(() => {
                missingDateAlert.style.opacity = '0';
                setTimeout(() => { missingDateAlert.style.display = 'none'; }, 300);
            }, 5000);
            return;
        }
        if (new Date(startDate) > new Date(endDate)) {
            if (autoSubmit) {
                document.querySelectorAll('#timeGroupingToggle button').forEach(btn => {
                    btn.classList.toggle('active', btn.dataset.group === '${requestScope.selectedTimeGrouping}');
                });
                return;
            }
            missingDateAlert.textContent = '⚠️ Lỗi: Ngày Bắt đầu không được lớn hơn Ngày Kết thúc.';
            missingDateAlert.style.display = 'block';
            setTimeout(() => { missingDateAlert.style.opacity = '1'; }, 10);
            setTimeout(() => {
                missingDateAlert.style.opacity = '0';
                setTimeout(() => { missingDateAlert.style.display = 'none'; }, 300);
            }, 5000);
            return;
        }
        document.getElementById('hiddenServiceType').value = serviceType;
        document.getElementById('hiddenStatus').value = status;
        document.getElementById('hiddenStartDate').value = startDate;
        document.getElementById('hiddenEndDate').value = endDate;
        document.getElementById('hiddenTimeGrouping').value = timeGrouping;
        document.getElementById('filterForm').submit();
        closeModal();
    }

    window.onclick = function(event) {
        const modal = document.getElementById('filterModal');
        if (event.target == modal) {
            closeModal();
        }
    }
</script>
</body>
</html>