<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Báo Cáo Thống Kê Tổng Quan</title>

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

    <style>
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
            --booking-color: #2196F3;
            --revenue-color: #4CAF50;
            --cancellation-color: #E91E63;
            --rate-color: #FF9800;
            --staff-chart-color: #00897B;
            --staff-border-color: #00897B;
            --customer-color: #1976D2;
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
        /*missingDateAlert*/
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
        .filter-item input[type="date"], .filter-item select {
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

        .chart-options {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            padding: 10px 0;
            border-bottom: 1px solid #eee;
            flex-wrap: wrap;
            gap: 10px;
        }

        .chart-toggle-group button {
            padding: 5px 10px;
            border: 1px solid var(--main-color);
            background-color: white;
            color: var(--main-color);
            cursor: pointer;
            transition: all 0.2s;
        }
        .chart-toggle-group button:first-of-type {
            border-radius: 4px 0 0 4px;
        }
        .chart-toggle-group button:last-of-type {
            border-radius: 0 4px 4px 0;
        }
        .chart-toggle-group button.active {
            background-color: var(--main-color);
            color: white;
        }

        .chart-toggle-group a.btn-toggle-unit {
            padding: 5px 10px;
            border: 1px solid var(--main-color);
            background-color: white;
            color: var(--main-color);
            cursor: pointer;
            transition: all 0.2s;
            text-decoration: none;
            font-size: 0.9em;
            display: inline-block;
        }
        .chart-toggle-group a.btn-toggle-unit:first-of-type {
            border-radius: 4px 0 0 4px;
        }
        .chart-toggle-group a.btn-toggle-unit:last-of-type {
            border-radius: 0 4px 4px 0;
        }
        .chart-toggle-group a.btn-toggle-unit.active {
            background-color: var(--main-color);
            color: white;
        }

        .checkbox-option label {
            font-size: 0.9em;
            color: #555;
            margin-left: 5px;
        }

        .summary-cards {
            display: flex;
            gap: 15px;
            margin-bottom: 30px;
            justify-content: flex-start;
        }

        .summary-card {
            flex: 1;
            padding: 15px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            transition: transform 0.3s;
            min-width: 150px;
            max-width: 300px;
            overflow: hidden;
        }

        .summary-card-value {
            font-size: 1.8em;
            color: var(--dark-red);
            font-weight: bold;
            display: flex;
            align-items: center;
            white-space: nowrap;
            overflow-x: auto;
            max-width: 100%;
            padding-right: 10px;
            scroll-behavior: smooth;
        }

        .summary-card-icon {
            font-size: 1.5em;
            margin-right: 10px;
            color: var(--main-color);
        }
        .summary-card:hover {
            transform: translateY(-5px);
        }
        .summary-card-title {
            font-size: 0.9em;
            color: #555;
            margin-bottom: 10px;
            font-weight: bold;
        }

        .cancellation {
            background-color: #fce4ec;
            border-left: 5px solid var(--cancellation-color);
        }
        .revenue {
            background-color: #e8f5e9;
            border-left: 5px solid var(--revenue-color);
        }
        .booking {
            background-color: #e3f2fd;
            border-left: 5px solid var(--booking-color);
        }
        .rate {
            background-color: #fff3e0;
            border-left: 5px solid var(--rate-color);
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
        #timeTrendChart {
            width: 100%;
            height: 100%;
        }

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
            max-width: 400px;
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
            .top-nav .restaurant-group {
                width: auto;
            }
            .summary-cards {
                flex-wrap: wrap;
            }
            .summary-card {
                flex: 0 0 calc(50% - 7.5px);
                padding: 15px;
                background-color: white;
                border-radius: 8px;
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
                display: flex;
                flex-direction: column;
                justify-content: space-between;
                transition: transform 0.3s;
                min-width: 0;
                overflow: hidden;
            }
            .filter-grid {
                flex-direction: column;
                align-items: stretch;
            }
            .filter-grid > .filter-item {
                width: 100%;
            }
            .filter-item input[type="date"], .filter-item select {
                width: 100%;
            }

            .chart-options {
                justify-content: flex-start;
            }
            .chart-options > div {
                flex-basis: 100%;
                display: flex;
                flex-wrap: wrap;
                gap: 10px;
            }
            .chart-toggle-group {
                margin-bottom: 5px;
            }
        }

        @media (min-width: 769px) {
            .sidebar {
                transform: translateX(0);
            }
            .summary-cards {
                flex-wrap: nowrap;
            }
        }
    </style>
</head>
<body>

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

<div class="wrapper">
    <div class="sidebar">
        <ul>
            <li><a href="<%= request.getContextPath() %>/overview-report" ${request.getRequestURI().contains("overview-report") ? "class=\"active\"" : ""}>Báo Cáo Tổng Quan</a></li>
            <li><a href="<%= request.getContextPath() %>/service-report" ${request.getRequestURI().contains("service-report") ? "class=\"active\"" : ""}>Báo Cáo Dịch Vụ</a></li>
            <li><a href="<%= request.getContextPath() %>/staff-report" ${request.getRequestURI().contains("staff-report") ? "class=\"active\"" : ""}>Báo Cáo Nhân Viên</a></li>
            <li><a href="<%= request.getContextPath() %>/user-report" ${request.getRequestURI().contains("user-report") ? "class=\"active\"" : ""}>Báo Cáo Khách Hàng</a></li>
            <li><a href="<%= request.getContextPath() %>/cancel-report" ${request.getRequestURI().contains("cancel-report") ? "class=\"active\"" : ""}>Báo Cáo Hủy Đặt Bàn</a></li>
        </ul>
    </div>

    <div class="main-content-body">
        <div class="content-container">
            <h1>Báo Cáo Thống Kê Tổng Quan</h1>

            <div class="fixed-width-wrapper">
                <div class="filter-section">
                    <h3 style="color: #555; margin-top: 0; margin-bottom: 15px;">Bộ Lọc Báo Cáo</h3>

                    <div class="filter-grid" style="margin-bottom: 20px;">

                        <div class="filter-item" style="min-width: unset;">
                            <button class="btn-apply" onclick="openModal()"><i class="fas fa-filter"></i> Lọc Theo Ngày</button>
                        </div>

                        <c:set var="isSevereError" value="${fn:startsWith(requestScope.warningMessage, 'Lỗi:') || fn:startsWith(requestScope.warningMessage, 'Hãy chọn Ngày Bắt đầu')}"/>

                        <c:if test="${empty requestScope.errorMessage and !isSevereError}">
                            <div class="filter-item" style="min-width: unset;">
                                <button type="button" id="btnExportExcel" class="btn-apply" style="background-color: #0F9D58;"><i class="fas fa-file-excel"></i> Xuất Excel</button>
                            </div>

                            <div class="filter-item" style="min-width: unset;">
                                <button type="button" id="btnExportPDF" class="btn-apply" style="background-color: #DB4437;"><i class="fas fa-file-pdf"></i> Xuất PDF</button>
                            </div>
                        </c:if>
                    </div>

                    <form action="overview-report" method="GET" id="filterForm" style="display: none;">
                        <div class="filter-grid">
                            <div class="filter-item">
                                <label for="startDate">Ngày Bắt Đầu</label>
                                <input type="date" id="startDate" name="startDate" value="${requestScope.startDateParam}" max="${requestScope.currentDate}">
                            </div>
                            <div class="filter-item">
                                <label for="endDate">Ngày Kết Thúc</label>
                                <input type="date" id="endDate" name="endDate" value="${requestScope.endDateParam}" max="${requestScope.currentDate}">
                            </div>

                            <div class="filter-item" style="display:none;">
                                <label for="chartUnit">Đơn Vị Biểu Đồ (Ẩn)</label>
                                <select id="chartUnit" name="chartUnit">
                                    <option value="day" ${requestScope.chartUnitParam == 'day' ? 'selected' : ''}>Theo Ngày</option>
                                    <option value="week" ${requestScope.chartUnitParam == 'week' ? 'selected' : ''}>Theo Tuần</option>
                                    <option value="month" ${requestScope.chartUnitParam == 'month' ? 'selected' : ''}>Theo Tháng</option>
                                </select>
                            </div>

                            <div class="filter-item" style="padding-top: 5px; display:none;">
                                <button type="submit" class="btn-apply"><i class="fas fa-check"></i> Áp Dụng Bộ Lọc (Ẩn)</button>
                            </div>
                        </div>
                    </form>

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

                    <c:if test="${empty requestScope.errorMessage and !isSevereError}">
                        <c:set var="summaryData" value="${requestScope.summaryData}"/>
                        <div class="summary-cards">
                            <div class="summary-card booking">
                                <div class="summary-card-title">Tổng Số Lượt Đặt Bàn</div>
                                <div class="summary-card-value">
                                    <i class="fas fa-calendar-check summary-card-icon" style="color: var(--booking-color);"></i>
                                        ${summaryData.totalBookings != null ? summaryData.totalBookings : 0}
                                </div>
                            </div>
                            <div class="summary-card revenue">
                                <div class="summary-card-title">Tổng Doanh Thu</div>
                                <div class="summary-card-value">
                                    <i class="fas fa-dollar-sign summary-card-icon" style="color: var(--revenue-color);"></i>
                                    <c:choose>
                                        <c:when test="${summaryData.totalRevenue != null}">
                                            <c:set var="revenue" value="${summaryData.totalRevenue / 1000000}"/>
                                            <c:choose>
                                                <c:when test="${revenue >= 1000}">
                                                    <fmt:formatNumber value="${revenue / 1000}" pattern="#0.0"/> T VND
                                                </c:when>
                                                <c:otherwise>
                                                    <fmt:formatNumber value="${revenue}" pattern="#0.g"/> Tr VND
                                                </c:otherwise>
                                            </c:choose>
                                        </c:when>
                                        <c:otherwise>
                                            0 Tr VND
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="summary-card cancellation">
                                <div class="summary-card-title">Tổng Số Lượt Hủy</div>
                                <div class="summary-card-value">
                                    <i class="fas fa-ban summary-card-icon" style="color: var(--cancellation-color);"></i>
                                        ${summaryData.totalCancellations != null ? summaryData.totalCancellations : 0}
                                </div>
                            </div>
                            <div class="summary-card rate">
                                <div class="summary-card-title">Tỷ Lệ Hủy</div>
                                <div class="summary-card-value">
                                    <i class="fas fa-percentage summary-card-icon" style="color: var(--rate-color);"></i>
                                    <c:choose>
                                        <c:when test="${summaryData.cancellationRate != null}">
                                            <fmt:formatNumber value="${summaryData.cancellationRate}" pattern="#0.00"/>%
                                        </c:when>
                                        <c:otherwise>
                                            0.00%
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>

                        <div class="chart-options">
                            <h2 style="margin: 0; color: var(--main-color); flex-basis: 100%;">Xu Hướng Doanh Thu & Đặt Bàn</h2>

                            <div style="display: flex; align-items: center; gap: 20px; flex-wrap: wrap;">

                                <div class="chart-toggle-group">
                                    <label style="font-size: 0.9em; color: #555; margin-right: 5px;">Xem theo:</label>

                                    <c:url var="urlDay" value="overview-report">
                                        <c:param name="startDate" value="${requestScope.startDateParam}" />
                                        <c:param name="endDate" value="${requestScope.endDateParam}" />
                                        <c:param name="chartUnit" value="day" />
                                    </c:url>
                                    <c:url var="urlWeek" value="overview-report">
                                        <c:param name="startDate" value="${requestScope.startDateParam}" />
                                        <c:param name="endDate" value="${requestScope.endDateParam}" />
                                        <c:param name="chartUnit" value="week" />
                                    </c:url>
                                    <c:url var="urlMonth" value="overview-report">
                                        <c:param name="startDate" value="${requestScope.startDateParam}" />
                                        <c:param name="endDate" value="${requestScope.endDateParam}" />
                                        <c:param name="chartUnit" value="month" />
                                    </c:url>

                                    <a href="${urlDay}" class="btn-toggle-unit ${requestScope.chartUnitParam == 'day' ? 'active' : ''}">Ngày</a>
                                    <a href="${urlWeek}" class="btn-toggle-unit ${requestScope.chartUnitParam == 'week' ? 'active' : ''}">Tuần</a>
                                    <a href="${urlMonth}" class="btn-toggle-unit ${requestScope.chartUnitParam == 'month' ? 'active' : ''}">Tháng</a>
                                </div>

                                <div class="chart-toggle-group">
                                    <label style="font-size: 0.9em; color: #555; margin-right: 5px;">Loại Biểu Đồ:</label>
                                    <button data-type="line"><i class="fas fa-chart-line"></i> Đường</button>
                                    <button class="active" data-type="bar"><i class="fas fa-chart-bar"></i> Cột</button>
                                </div>

                                <div class="checkbox-option">
                                    <input type="checkbox" id="display-cancellations">
                                    <label for="display-cancellations">Hiển thị Hủy Đặt Bàn</label>
                                </div>
                            </div>
                        </div>
                        <div id="chartContainer">
                            <canvas id="timeTrendChart"></canvas>
                        </div>
                    </c:if>

                </div>
                <hr/>
            </div>
        </div>
    </div>
</div>

<div id="filterModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3>Lọc Báo Cáo Theo Ngày</h3>
            <span class="close" onclick="closeModal()">&times;</span>
        </div>
        <form id="modalForm" class="modal-form">
            <div class="filter-item">
                <label for="modalStartDate">Ngày Bắt Đầu</label>
                <input type="date" id="modalStartDate" name="startDate" value="${requestScope.startDateParam}" style="box-sizing: border-box;">
            </div>
            <div class="filter-item">
                <label for="modalEndDate">Ngày Kết Thúc</label>
                <input type="date" id="modalEndDate" name="endDate" value="${requestScope.endDateParam}" style="box-sizing: border-box;">
            </div>

            <button type="button" class="btn-apply" onclick="submitModalForm()">Áp Dụng Bộ Lọc</button>
        </form>
    </div>
</div>

<div id="missingDateAlert">
    <i class="fas fa-exclamation-triangle"></i>
    Vui lòng chọn đầy đủ Ngày Bắt đầu và Ngày Kết thúc
</div>

<script>
    const isInitialLoad = "${requestScope.isInitialLoad}" === "true";
    const hasWarning = "${requestScope.warningMessage}" !== "";
    const chartUnit = "${requestScope.chartUnitParam}" || "day";
    const ctx = document.getElementById('timeTrendChart')?.getContext('2d');
    let trendChart;
    const chartContainer = document.getElementById('chartContainer');

    const trendData = [
        <c:forEach var="item" items="${requestScope.timeTrendData}" varStatus="loop">
        {
            label: "${item.date}",
            revenue: ${item.totalRevenue},
            bookings: ${item.totalBookings},
            cancellations: ${item.totalCancellations}
        }<c:if test="${!loop.last}">,</c:if>
        </c:forEach>
    ];

    const missingDateAlert = document.getElementById('missingDateAlert');

    function showAlert(message) {
        missingDateAlert.textContent = '⚠️ ' + message;
        missingDateAlert.style.display = 'block';

        setTimeout(() => {
            missingDateAlert.style.opacity = '1';
        }, 10);

        setTimeout(() => {
            missingDateAlert.style.opacity = '0';
            setTimeout(() => {
                missingDateAlert.style.display = 'none';
            }, 300);
        }, 5000);
    }

    function updateTrendChart(chartType, showCancellations) {
        if (!ctx) return;

        if (trendChart) {
            trendChart.destroy();
        }

        if (trendData.length === 0) {
            if (chartContainer) chartContainer.style.display = 'none';
            return;
        }

        if (chartContainer) chartContainer.style.display = 'flex';

        const labels = trendData.map(item => item.label);
        const datasets = [];

        const dataPointSize = chartUnit === 'day' ? 50 : 70;
        const minRequiredWidth = labels.length * dataPointSize;
        const containerWidth = chartContainer.clientWidth;
        let canvasWidth = Math.max(containerWidth, minRequiredWidth);

        ctx.canvas.style.width = '100%';
        ctx.canvas.style.height = '100%';
        ctx.canvas.width = canvasWidth;
        ctx.canvas.height = 400;

        datasets.push({
            label: 'Tổng Doanh Thu (VND)',
            data: trendData.map(item => item.revenue),
            type: 'line',
            borderColor: 'rgba(2, 119, 189, 1)',
            backgroundColor: 'rgba(2, 119, 189, 0.2)',
            fill: true,
            yAxisID: 'yRevenue',
            tension: 0.4,
            pointRadius: 3,
            borderWidth: 3,
            order: 1
        });

        datasets.push({
            label: 'Tổng Số Lượt Đặt Bàn',
            data: trendData.map(item => item.bookings),
            type: chartType,
            backgroundColor: 'rgba(211, 47, 47, 0.9)',
            borderColor: 'rgba(211, 47, 47, 1)',
            yAxisID: 'yBookings',
            borderWidth: chartType === 'bar' ? 0 : 2,
            tension: chartType === 'line' ? 0.4 : 0,
            pointRadius: chartType === 'line' ? 3 : 0,
            order: 2
        });

        if (showCancellations) {
            datasets.push({
                label: 'Tổng Số Lượt Hủy',
                data: trendData.map(item => item.cancellations),
                type: chartType,
                backgroundColor: 'rgba(96, 96, 96, 0.7)',
                borderColor: 'rgba(96, 96, 96, 1)',
                yAxisID: 'yBookings',
                borderWidth: chartType === 'bar' ? 0 : 2,
                tension: chartType === 'line' ? 0.4 : 0,
                pointRadius: chartType === 'line' ? 3 : 0,
                order: 3
            });
        }

        let chartOptions = {
            responsive: true,
            maintainAspectRatio: false,
            layout: {
                padding: { right: 20 }
            },
            plugins: {
                legend: { position: 'top', labels: { usePointStyle: true, padding: 20 } },
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            let label = context.dataset.label || '';
                            if (label) label += ': ';
                            if (context.parsed.y !== null) {
                                if (context.dataset.yAxisID === 'yRevenue') {
                                    if (context.parsed.y >= 1000000000) {
                                        label += new Intl.NumberFormat('vi-VN', { style: 'decimal', maximumFractionDigits: 1 }).format(context.parsed.y / 1000000000) + ' Tỷ VND';
                                    } else if (context.parsed.y >= 1000000) {
                                        label += new Intl.NumberFormat('vi-VN', { style: 'decimal', maximumFractionDigits: 0 }).format(context.parsed.y / 1000000) + ' Triệu VND';
                                    } else {
                                        label += new Intl.NumberFormat('vi-VN', { style: 'decimal', maximumFractionDigits: 0 }).format(context.parsed.y) + ' VND';
                                    }
                                } else {
                                    label += context.parsed.y.toLocaleString('vi-VN') + ' lượt';
                                }
                            }
                            return label;
                        }
                    }
                }
            },
            scales: {
                x: {
                    title: { display: true, text: chartUnit === 'day' ? 'Ngày' : (chartUnit === 'week' ? 'Tuần' : 'Tháng'), color: '#B71C1C', font: { size: 14, weight: 'bold' } },
                    ticks: { maxRotation: 45, minRotation: 45, color: '#333' },
                    grid: { display: false }
                },
                yRevenue: {
                    type: 'linear',
                    position: 'left',
                    title: { display: true, text: 'Tổng Doanh Thu (VND)', color: 'rgba(2, 119, 189, 1)', font: { size: 14, weight: 'bold' } },
                    grid: { drawOnChartArea: true, color: 'rgba(0, 0, 0, 0.05)' },
                    ticks: {
                        callback: function(value, index, ticks) {
                            if (value >= 1000000000) return (value / 1000000000).toFixed(1) + ' Tỷ';
                            if (value >= 1000000) return (value / 1000000).toFixed(0) + ' Tr';
                            return value.toLocaleString('vi-VN');
                        }
                    },
                    beginAtZero: true
                },
                yBookings: {
                    type: 'linear',
                    position: 'right',
                    title: { display: true, text: 'Đặt Bàn/Hủy (Lượt)', color: 'rgba(211, 47, 47, 1)', font: { size: 12, weight: 'bold' } },
                    grid: { drawOnChartArea: false },
                    ticks: { color: 'rgba(211, 47, 47, 1)', stepSize: 1, callback: function(value, index, ticks) { return value.toLocaleString('vi-VN'); } },
                    beginAtZero: true
                }
            }
        };

        trendChart = new Chart(ctx, { type: 'bar', data: { labels: labels, datasets: datasets }, options: chartOptions });
        if (chartContainer) chartContainer.scrollLeft = 0;
    }


    updateTrendChart('bar', false);

    if (chartContainer) {
        document.querySelectorAll('.chart-toggle-group button').forEach(button => {
            button.addEventListener('click', function() {
                const activeBtn = document.querySelector('.chart-toggle-group .active');
                if (activeBtn) activeBtn.classList.remove('active');
                this.classList.add('active');
                const chartType = this.getAttribute('data-type');
                const showCancellations = document.getElementById('display-cancellations').checked;
                updateTrendChart(chartType, showCancellations);
            });
        });

        document.getElementById('display-cancellations').addEventListener('change', function() {
            const showCancellations = this.checked;
            const chartType = document.querySelector('.chart-toggle-group .active').getAttribute('data-type');
            updateTrendChart(chartType, showCancellations);
        });
    }

    function getFilterParams() {
        const urlParams = new URLSearchParams(window.location.search);
        let params = '';
        const startDate = urlParams.get('startDate') || '';
        const endDate = urlParams.get('endDate') || '';
        // (CHỈNH SỬA) Lấy chartUnit từ requestScope (đã có sẵn trong JS)
        const chartUnitParam = "${requestScope.chartUnitParam}" || 'day';

        if (startDate) params += '&startDate=' + startDate;
        if (endDate) params += '&endDate=' + endDate;
        if (chartUnitParam) params += '&chartUnit=' + chartUnitParam;
        return params;
    }

    document.addEventListener('DOMContentLoaded', function() {
        const btnExportExcel = document.getElementById('btnExportExcel');
        const btnExportPDF = document.getElementById('btnExportPDF');

        const isSevereErrorInJs = () => {
            const warningMsg = "${requestScope.warningMessage}";
            return warningMsg.startsWith('Lỗi:') || warningMsg.startsWith('Hãy chọn Ngày Bắt đầu');
        };

        const handleExport = (type) => {
            if ("${requestScope.errorMessage}" !== "" || isSevereErrorInJs()) {
                alert("Lỗi: Không thể xuất báo cáo khi chưa có dữ liệu hoặc bộ lọc bị thiếu. Vui lòng kiểm tra lại cảnh báo.");
                return;
            }
            if (window.confirm("Bạn có chắc chắn muốn xuất file " + type.toUpperCase() + " này không?")) {
                const params = getFilterParams();
                window.location.href = "ExportOverviewReportServlet?type=" + type + params;
            }
        };

        if (btnExportExcel) {
            btnExportExcel.addEventListener('click', function() {
                handleExport('excel');
            });
        }

        if (btnExportPDF) {
            btnExportPDF.addEventListener('click', function() {
                handleExport('pdf');
            });
        }
    });

    function openModal() {
        document.getElementById('filterModal').style.display = 'flex';
        document.getElementById('modalStartDate').value = "${requestScope.startDateParam}";
        document.getElementById('modalEndDate').value = "${requestScope.endDateParam}";
        // (ĐÃ XÓA) Không cần set giá trị cho modalChartUnit nữa
    }

    function closeModal() {
        document.getElementById('filterModal').style.display = 'none';
    }

    // (CHỈNH SỬA) Hàm submitModalForm
    function submitModalForm() {
        const modalStartDateInput = document.getElementById('modalStartDate');
        const modalEndDateInput = document.getElementById('modalEndDate');
        const startDate = modalStartDateInput.value;
        const endDate = modalEndDateInput.value;
        // (ĐÃ XÓA) Không lấy chartUnit từ modal

        if (!startDate || !endDate) {
            showAlert("Vui lòng chọn đầy đủ Ngày Bắt đầu và Ngày Kết thúc.");
            return;
        }

        let start = new Date(startDate);
        let end = new Date(endDate);

        if (start.getTime() > end.getTime()) {
            showAlert("Lỗi: Ngày Bắt đầu không được lớn hơn Ngày Kết thúc.");
            return;
        }

        // Cập nhật giá trị vào form ẩn
        document.getElementById('startDate').value = startDate;
        document.getElementById('endDate').value = endDate;
        // (ĐÃ XÓA) Không cập nhật chartUnit, vì nó đã có giá trị đúng từ requestScope

        // Submit form ẩn
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