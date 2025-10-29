<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Service Overview Report Dashboard</title>

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
        #timeTrendChart {
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
        }

        .modal-content {
            background-color: #fff;
            margin: 15% auto;
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

    <div class="main-content-body">
        <div class="content-container">
            <h1>Overview Statistics Report</h1>

            <div class="fixed-width-wrapper">
                <div class="filter-section">
                    <h3 style="color: #555; margin-top: 0; margin-bottom: 15px;">Report Filters</h3>

                    <div class="filter-grid" style="margin-bottom: 20px;">

                        <div class="filter-item" style="min-width: unset;">
                            <button class="btn-apply" onclick="openModal()"><i class="fas fa-filter"></i> Open Filter Popup</button>
                        </div>

                        <c:if test="${empty requestScope.errorMessage and empty requestScope.warningMessage}">

                            <div class="filter-item" style="min-width: unset;">
                                <button type="button" id="btnExportExcel" class="btn-apply" style="background-color: #0F9D58;"><i class="fas fa-file-excel"></i> Export to Excel</button>
                            </div>

                            <div class="filter-item" style="min-width: unset;">
                                <button type="button" id="btnExportPDF" class="btn-apply" style="background-color: #DB4437;"><i class="fas fa-file-pdf"></i> Export to PDF</button>
                            </div>
                        </c:if>
                    </div>
                    <form action="overview-report" method="GET" id="filterForm" style="display: none;">
                        <div class="filter-grid">
                            <div class="filter-item">
                                <label for="startDate">Start Date</label>
                                <input type="date" id="startDate" name="startDate" value="${requestScope.startDateParam}" max="${requestScope.currentDate}">
                            </div>
                            <div class="filter-item">
                                <label for="endDate">End Date</label>
                                <input type="date" id="endDate" name="endDate" value="${requestScope.endDateParam}" max="${requestScope.currentDate}">
                            </div>
                            <div class="filter-item">
                                <label for="chartUnit">Chart Unit</label>
                                <select id="chartUnit" name="chartUnit">
                                    <option value="day" ${requestScope.chartUnitParam == 'day' ? 'selected' : ''}>Daily</option>
                                    <option value="week" ${requestScope.chartUnitParam == 'week' ? 'selected' : ''}>Weekly</option>
                                    <option value="month" ${requestScope.chartUnitParam == 'month' ? 'selected' : ''}>Monthly</option>
                                </select>
                            </div>
                            <div class="filter-item" style="padding-top: 5px; display:none;">
                                <button type="submit" class="btn-apply"><i class="fas fa-check"></i> Apply Filter (Hidden)</button>
                            </div>
                        </div>
                    </form>

                    <c:if test="${not empty requestScope.warningMessage}">
                        <div id="alertWarning" style="background-color: #fff3cd; color: #856404; padding: 15px; margin-bottom: 20px; border: 1px solid #ffeeba; border-radius: 4px;">
                            ${requestScope.warningMessage}
                        </div>
                    </c:if>

                    <c:if test="${not empty requestScope.errorMessage}">
                        <div id="alertError" style="background-color: #f8d7da; color: #721c24; padding: 15px; margin-bottom: 20px; border: 1px solid #f5c6cb; border-radius: 4px;">
                            <i class="fas fa-times-circle"></i>
                            <strong>System Error:</strong> ${requestScope.errorMessage}
                        </div>
                    </c:if>

                    <%-- Dữ liệu Summary và Chart luôn được hiển thị --%>
                    <c:set var="summaryData" value="${requestScope.summaryData}"/>
                    <div class="summary-cards">
                        <div class="summary-card booking">
                            <div class="summary-card-title">Total Bookings</div>
                            <div class="summary-card-value">
                                <i class="fas fa-calendar-check summary-card-icon" style="color: var(--booking-color);"></i>
                                ${summaryData.totalBookings != null ? summaryData.totalBookings : 0}
                            </div>
                        </div>
                        <div class="summary-card revenue">
                            <div class="summary-card-title">Total Revenue</div>
                            <div class="summary-card-value">
                                <i class="fas fa-dollar-sign summary-card-icon" style="color: var(--revenue-color);"></i>
                                <c:choose>
                                    <c:when test="${summaryData.totalRevenue != null}">
                                        <c:set var="revenue" value="${summaryData.totalRevenue / 1000000}"/>
                                        <c:choose>
                                            <c:when test="${revenue >= 1000}">
                                                <fmt:formatNumber value="${revenue / 1000}" pattern="#0.0"/> B VND
                                            </c:when>
                                            <c:otherwise>
                                                <fmt:formatNumber value="${revenue}" pattern="#0.0"/> M VND
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>
                                    <c:otherwise>
                                        0 M VND
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="summary-card cancellation">
                            <div class="summary-card-title">Total Cancellations</div>
                            <div class="summary-card-value">
                                <i class="fas fa-ban summary-card-icon" style="color: var(--cancellation-color);"></i>
                                ${summaryData.totalCancellations != null ? summaryData.totalCancellations : 0}
                            </div>
                        </div>
                        <div class="summary-card rate">
                            <div class="summary-card-title">Cancellation Rate</div>
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
                        <h2 style="margin: 0; color: var(--main-color);">Revenue & Booking Trend (<c:out value="${requestScope.chartUnitParam eq 'day' ? 'Daily' : (requestScope.chartUnitParam eq 'week' ? 'Weekly' : 'Monthly')}"/>)</h2>
                        <div style="display: flex; align-items: center; gap: 20px;">
                            <div class="chart-toggle-group">
                                <label style="font-size: 0.9em; color: #555; margin-right: 5px;">Chart Type:</label>
                                <button data-type="line"><i class="fas fa-chart-line"></i> Line</button>
                                <button class="active" data-type="bar"><i class="fas fa-chart-bar"></i> Bar</button>
                            </div>
                            <div class="checkbox-option">
                                <input type="checkbox" id="display-cancellations">
                                <label for="display-cancellations">Show Cancellations</label>
                            </div>
                        </div>
                    </div>

                    <div id="chartContainer">
                        <canvas id="timeTrendChart"></canvas>
                    </div>

                </div>
                <hr/>
            </div>
        </div>
    </div>
</div>

<div id="filterModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3>Filter Report</h3>
            <span class="close" onclick="closeModal()">&times;</span>
        </div>
        <form id="modalForm" class="modal-form">
            <div class="filter-item">
                <label for="modalStartDate">Start Date</label>
                <input type="date" id="modalStartDate" name="startDate" value="${requestScope.startDateParam}" min="2025-01-01" max="2025-10-31">
            </div>
            <div class="filter-item">
                <label for="modalEndDate">End Date</label>
                <input type="date" id="modalEndDate" name="endDate" value="${requestScope.endDateParam}" min="2025-01-01" max="2025-10-31">
            </div>
            <div class="filter-item">
                <label for="modalChartUnit">Chart Unit</label>
                <select id="modalChartUnit" name="chartUnit">
                    <option value="day" ${requestScope.chartUnitParam == 'day' ? 'selected' : ''}>Daily</option>
                    <option value="week" ${requestScope.chartUnitParam == 'week' ? 'selected' : ''}>Weekly</option>
                    <option value="month" ${requestScope.chartUnitParam == 'month' ? 'selected' : ''}>Monthly</option>
                </select>
            </div>
            <button type="button" class="btn-apply" onclick="submitModalForm()">Apply Filter</button>
        </form>
    </div>
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
            label: "${item.label}",
            revenue: ${item.totalRevenue},
            bookings: ${item.totalBookings},
            cancellations: ${item.totalCancellations}
        }<c:if test="${!loop.last}">,</c:if>
        </c:forEach>
    ];

    function updateTrendChart(chartType, showCancellations) {
        if (!ctx) return;

        if (trendChart) {
            trendChart.destroy();
        }

        // Vẫn ẩn chart nếu có warning (tức là totalBookings == 0) hoặc lỗi DB
        if (hasWarning || trendData.length === 0) {
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
            label: 'Total Revenue (VND)',
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
            label: 'Total Bookings',
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
                label: 'Total Cancellations',
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
                                        label += new Intl.NumberFormat('en-US', { style: 'currency', currency: 'VND', maximumFractionDigits: 0 }).format(context.parsed.y / 1000000000) + ' B';
                                    } else if (context.parsed.y >= 1000000) {
                                        label += new Intl.NumberFormat('en-US', { style: 'currency', currency: 'VND', maximumFractionDigits: 0 }).format(context.parsed.y / 1000000) + ' M';
                                    } else {
                                        label += new Intl.NumberFormat('en-US', { style: 'currency', currency: 'VND', maximumFractionDigits: 0 }).format(context.parsed.y);
                                    }
                                } else {
                                    label += context.parsed.y.toLocaleString('en-US') + ' count';
                                }
                            }
                            return label;
                        }
                    }
                }
            },
            scales: {
                x: {
                    title: { display: true, text: chartUnit === 'day' ? 'Day' : (chartUnit === 'week' ? 'Week' : 'Month'), color: '#B71C1C', font: { size: 14, weight: 'bold' } },
                    ticks: { maxRotation: 45, minRotation: 45, color: '#333' },
                    grid: { display: false }
                },
                yRevenue: {
                    type: 'linear',
                    position: 'left',
                    title: { display: true, text: 'Total Revenue (VND)', color: 'rgba(2, 119, 189, 1)', font: { size: 14, weight: 'bold' } },
                    grid: { drawOnChartArea: true, color: 'rgba(0, 0, 0, 0.05)' },
                    ticks: {
                        callback: function(value, index, ticks) {
                            if (value >= 1000000000) return (value / 1000000000).toFixed(1) + ' B';
                            if (value >= 1000000) return (value / 1000000).toFixed(0) + ' M';
                            return value.toLocaleString('en-US');
                        }
                    },
                    beginAtZero: true
                },
                yBookings: {
                    type: 'linear',
                    position: 'right',
                    title: { display: true, text: 'Bookings/Cancellations (Count)', color: 'rgba(211, 47, 47, 1)', font: { size: 12, weight: 'bold' } },
                    grid: { drawOnChartArea: false },
                    ticks: { color: 'rgba(211, 47, 47, 1)', stepSize: 1, callback: function(value, index, ticks) { return value.toLocaleString('en-US'); } },
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
        const chartUnit = urlParams.get('chartUnit') || '';
        if (startDate) params += '&startDate=' + startDate;
        if (endDate) params += '&endDate=' + endDate;
        if (chartUnit) params += '&chartUnit=' + chartUnit;
        return params;
    }

    // Attach event listeners to export buttons
    document.addEventListener('DOMContentLoaded', function() {
        const btnExportExcel = document.getElementById('btnExportExcel');
        const btnExportPDF = document.getElementById('btnExportPDF');

        if (btnExportExcel) {
            btnExportExcel.addEventListener('click', function() {
                const params = getFilterParams();
                window.location.href = "ExportOverviewReportServlet?type=excel" + params;
                alert("Downloading Excel file...");
            });
        }

        if (btnExportPDF) {
            btnExportPDF.addEventListener('click', function() {
                const params = getFilterParams();
                window.location.href = "ExportOverviewReportServlet?type=pdf" + params;
                alert("Downloading PDF file...");
            });
        }
    });

    // Modal Functions
    function openModal() {
        document.getElementById('filterModal').style.display = 'block';
        document.getElementById('modalStartDate').value = "${requestScope.startDateParam}";
        document.getElementById('modalEndDate').value = "${requestScope.endDateParam}";
        document.getElementById('modalChartUnit').value = "${requestScope.chartUnitParam}";
    }

    function closeModal() {
        document.getElementById('filterModal').style.display = 'none';
    }

    function submitModalForm() {
        const startDate = document.getElementById('modalStartDate').value;
        const endDate = document.getElementById('modalEndDate').value;
        const chartUnit = document.getElementById('modalChartUnit').value;

        // Adjust dates if outside valid range
        const minDate = new Date('2025-01-01');
        const maxDate = new Date('2025-10-31');
        let start = new Date(startDate);
        let end = new Date(endDate);

        if (start < minDate) start = minDate;
        if (end > maxDate) end = maxDate;

        // Update form values
        document.getElementById('startDate').value = start.toISOString().split('T')[0];
        document.getElementById('endDate').value = end.toISOString().split('T')[0];
        document.getElementById('chartUnit').value = chartUnit;

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