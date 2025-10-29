<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Performance Report</title>

    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
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
            --booking-color: #2196F3;
            --revenue-color: #4CAF50;
            --cancellation-color: #E91E63;
            --rate-color: #FF9800;
            --staff-chart-color: #00897B;
            --staff-border-color: #00897B;
        }

        /* Base & Layout */
        body { font-family: Arial, sans-serif; padding: 0; margin: 0; background-color: #f4f4f4; padding-top: var(--top-nav-height); overflow-x: hidden; }
        .wrapper { display: flex; min-height: calc(100vh - var(--top-nav-height)); position: relative; }
        .top-nav { position: fixed; top: 0; left: 0; right: 0; height: var(--top-nav-height); background-color: var(--main-color); color: var(--text-light); display: flex; align-items: center; justify-content: space-between; padding: 0 15px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); z-index: 1000; }
        .top-nav .restaurant-group { display: flex; align-items: center; gap: 15px; flex-shrink: 0; }
        .top-nav .restaurant-name { font-size: 1.2em; font-weight: bold; color: white; white-space: nowrap; }
        .home-button { background-color: var(--main-color); color: white; border: 1px solid var(--main-color); padding: 5px 10px; border-radius: 4px; text-decoration: none; font-size: 0.85em; transition: all 0.2s; display: flex; align-items: center; box-shadow: 0 1px 3px rgba(0,0,0,0.2); }
        .home-button:hover { background-color: var(--dark-red); color: white; border-color: var(--dark-red); }
        .top-nav .user-info { display: flex; align-items: center; padding-right: 15px; font-size: 1em; font-weight: bold; }
        .sidebar { width: var(--sidebar-width); position: fixed; top: var(--top-nav-height); left: 0; bottom: 0; background-color: var(--menu-bg); color: var(--text-light); padding-top: 10px; box-shadow: 2px 0 5px rgba(0,0,0,0.1); z-index: 999; transition: transform 0.3s ease; }
        .sidebar ul { list-style: none; padding: 0; margin: 0; }
        .sidebar li a { display: block; padding: 15px 20px; text-decoration: none; color: var(--text-light); border-bottom: 1px solid rgba(255, 255, 255, 0.1); transition: background-color 0.3s; }
        .sidebar li a:hover, .sidebar li a.active { background-color: var(--menu-hover); color: white; }
        .main-content-body { margin-left: var(--sidebar-width); flex-grow: 1; padding: 20px; background-color: #f4f4f4; min-height: 100%; box-sizing: border-box; }
        .content-container { background-color: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 0 10px rgba(0, 0, 0, 0.05); width: 100%; max-width: 1200px; margin: 0 auto; box-sizing: border-box; }
        .fixed-width-wrapper { width: 100%; overflow: hidden; }

        /* Filter Section Styling */
        .filter-section {
            background-color: #fff;
            padding: 15px 20px;
            border: 1px solid #eee;
            border-radius: 6px;
            margin-bottom: 20px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }
        .filter-grid { display: flex; flex-wrap: wrap; gap: 15px; align-items: flex-end; }
        .filter-item { display: flex; flex-direction: column; min-width: 120px; }
        .filter-item label { font-size: 0.9em; color: #555; margin-bottom: 5px; font-weight: bold; }
        .filter-item input[type="date"], .filter-item select { padding: 8px 10px; border: 1px solid #ccc; border-radius: 4px; min-width: 120px; font-size: 1em; }
        .btn-apply { background-color: var(--main-color); color: white; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; font-weight: bold; transition: background-color 0.3s; }
        .btn-apply:hover { background-color: var(--dark-red); }

        h1, h2, h3 { color: var(--dark-red); }
        h1 { border-bottom: 2px solid var(--main-color); padding-bottom: 10px; }
        hr { border: none; height: 1px; background-color: var(--light-red); margin: 20px 0; }

        /* New/Adjusted Styles */
        .summary-cards-staff {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
        }
        .staff-info-card {
            flex: 1;
            padding: 15px;
            border-radius: 8px;
            background-color: #fff;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            border-left: 5px solid var(--staff-border-color);
        }
        .staff-info-card div { margin-bottom: 8px; font-size: 0.95em; }
        .staff-info-card strong { color: var(--dark-red); }
        .status-active { color: var(--revenue-color); font-weight: bold; }
        .status-inactive { color: var(--cancellation-color); font-weight: bold; }

        /* Table Style */
        .staff-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin-top: 20px;
        }
        .staff-table th, .staff-table td {
            padding: 12px;
            border-bottom: 1px solid #eee;
        }
        .staff-table th {
            background-color: #f8f8f8;
            color: var(--dark-red);
            font-weight: bold;
            text-transform: uppercase;
        }
        .staff-table tr:hover {
            background-color: #ffebee;
        }
        .staff-table td a {
            color: var(--booking-color);
            text-decoration: none;
            transition: color 0.2s;
        }
        .staff-table td a:hover {
            color: var(--dark-red);
            text-decoration: underline;
        }
        .text-center { text-align: center; }
        .text-right { text-align: right; }
        .text-warning { color: var(--rate-color); }
        .text-danger { color: var(--cancellation-color); }

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
        #employeeBookingsChart {
            width: 100%;
            height: 100%;
        }

        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1001;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0,0,0,0.4);
            padding-top: 60px;
        }
        .modal-content {
            background-color: #fefefe;
            margin: 5% auto;
            padding: 20px;
            border: 1px solid #888;
            width: 90%;
            max-width: 400px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }
        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
            margin-bottom: 15px;
        }
        .modal-header h3 {
            color: var(--dark-red);
            margin: 0;
        }
        .close {
            color: #aaa;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }
        .close:hover, .close:focus {
            color: #000;
            text-decoration: none;
            cursor: pointer;
        }
        .modal-form .filter-item {
            margin-bottom: 15px;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .sidebar { transform: translateX(-100%); }
            .main-content-body { margin-left: 0; }
            .staff-info-card { min-width: 100%; }
            .filter-grid { flex-direction: column; align-items: stretch; }
            .staff-table th, .staff-table td { padding: 8px; font-size: 0.9em; }
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
            <c:choose>
                <c:when test="${requestScope.isDetailMode && not empty requestScope.selectedEmployeeDetail}">
                    <a href="staff-report?startDate=${requestScope.startDateParam}&endDate=${requestScope.endDateParam}" class="home-button" style="margin-bottom: 15px; display: inline-flex; background-color: #555; border-color: #555;"><i class="fas fa-arrow-left"></i> Back to Overview</a>
                    <h1>Detailed Performance Report</h1>

                    <div class="summary-cards-staff">
                        <div class="staff-info-card">
                            <div><strong>Employee:</strong> ${requestScope.selectedEmployeeDetail.fullName} (${requestScope.selectedEmployeeId})</div>
                            <div><strong>Email:</strong> ${requestScope.selectedEmployeeDetail.email}</div>
                            <div><strong>Phone:</strong> ${requestScope.selectedEmployeeDetail.phoneNumber}</div>
                            <div><strong>Status:</strong>
                                <span class="${requestScope.selectedEmployeeDetail.status == 'ACTIVE' ? 'status-active' : 'status-inactive'}">
                                        ${requestScope.selectedEmployeeDetail.status}
                                </span>
                            </div>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <h1>Overview Performance Report</h1>
                </c:otherwise>
            </c:choose>

            <div class="fixed-width-wrapper">
                <div class="filter-section">
                    <h3 style="color: #555; margin-top: 0; margin-bottom: 15px;">Report Filters</h3>
                    <button type="button" class="btn-apply" onclick="openFilterModal()"><i class="fas fa-calendar"></i> Filter by Date</button>
                    <button type="button" class="btn-apply" onclick="openSearchModal()" style="background-color: #3f51b5; margin-left: 10px;">
                        <i class="fas fa-user-tag"></i> Search Employee
                    </button>
                </div>

                <%-- GET NOTIFICATIONS FROM SESSION AND REMOVE IMMEDIATELY --%>
                <c:if test="${not empty sessionScope.sessionWarningMessage}">
                    <div id="alertWarning" style="background-color: #fff3cd; color: #856404; padding: 15px; margin-bottom: 20px; border: 1px solid #ffeeba; border-radius: 4px;">
                        <i class="fas fa-exclamation-triangle"></i>
                        <strong></strong> ${sessionScope.sessionWarningMessage}
                    </div>
                    <c:remove var="sessionWarningMessage" scope="session"/>
                </c:if>

                <c:if test="${not empty sessionScope.sessionErrorMessage}">
                    <div id="alertError" style="background-color: #f8d7da; color: #721c24; padding: 15px; margin-bottom: 20px; border: 1px solid #f5c6cb; border-radius: 4px;">
                        <i class="fas fa-times-circle"></i>
                            ${sessionScope.sessionErrorMessage}
                    </div>
                    <c:remove var="sessionErrorMessage" scope="session"/>
                </c:if>
                <%-- END GET FROM SESSION AND REMOVE --%>

                <c:choose>
                    <c:when test="${requestScope.isDetailMode}">
                        <h2 style="color: var(--staff-border-color);">Trend of Employee Activity</h2>

                        <c:if test="${not empty requestScope.employeeTimeTrendJson}">
                            <div id="chartContainer">
                                <canvas id="employeeBookingsChart"></canvas>
                            </div>
                        </c:if>
                        <c:if test="${empty requestScope.employeeTimeTrendJson}">
                            <p>No activity (Serves or Shifts) was recorded for this employee in the selected period.</p>
                        </c:if>
                    </c:when>

                    <c:otherwise>
                        <h2>Staff Performance Summary (Based on Activity Log)</h2>
                        <c:choose>
                            <c:when test="${not empty requestScope.employeeData}">
                                <table class="staff-table">
                                    <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Employee Name</th>
                                        <th>Status</th>
                                        <th class="text-center">Total Serves</th>
                                        <th class="text-center">Total Shift Days</th>
                                        <th class="text-center text-warning">Serves/Shift Day</th>
                                        <th class="text-right">Total Working Hours</th>
                                        <th class="text-center">Action</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="employee" items="${requestScope.employeeData}">
                                        <tr>
                                            <td>${employee.employeeId}</td>
                                            <td>${employee.employeeName}</td>
                                            <td>
                                                    <span class="${employee.employeeStatus == 'ACTIVE' ? 'status-active' : 'status-inactive'}">
                                                            ${employee.employeeStatus}
                                                    </span>
                                            </td>
                                            <td class="text-center">${employee.totalServes}</td>
                                            <td class="text-center">${employee.totalShiftDays}</td>
                                            <td class="text-center text-warning" style="font-weight: bold;">
                                                <fmt:formatNumber value="${employee.servePerShiftRate}" pattern="#0.00"/>
                                            </td>
                                            <td class="text-right">
                                                <fmt:formatNumber value="${employee.totalWorkingHours}" pattern="#,##0.00"/> hours
                                            </td>
                                            <td class="text-center">
                                                <a href="staff-report?employeeId=${employee.employeeId}&startDate=${requestScope.startDateParam}&endDate=${requestScope.endDateParam}">
                                                    View Details & Chart
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </c:when>
                            <c:otherwise>
                                <p>No employee data or assigned bookings found for the selected period.</p>
                            </c:otherwise>
                        </c:choose>
                    </c:otherwise>
                </c:choose>

                <hr/>
            </div>
        </div>
    </div>
</div>

<div id="filterModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3>Report Filters (Date)</h3>
            <span class="close" onclick="closeFilterModal()">&times;</span>
        </div>
        <form id="modalForm" class="modal-form">
            <c:if test="${requestScope.isDetailMode}">
                <input type="hidden" id="modalEmployeeId" name="employeeId" value="${requestScope.selectedEmployeeId}">
            </c:if>
            <div class="filter-item">
                <label for="modalStartDate">From Date</label>
                <input type="date" id="modalStartDate" name="startDate" value="${requestScope.startDateParam}">
            </div>
            <div class="filter-item">
                <label for="modalEndDate">To Date</label>
                <input type="date" id="modalEndDate" name="endDate" value="${requestScope.endDateParam}">
            </div>
            <c:if test="${requestScope.isDetailMode}">
                <div class="filter-item">
                    <label for="modalChartUnit">Chart Unit</label>
                    <select id="modalChartUnit" name="chartUnit">
                        <option value="day" ${requestScope.chartUnitParam == 'day' ? 'selected' : ''}>Day</option>
                        <option value="week" ${requestScope.chartUnitParam == 'week' ? 'selected' : ''}>Week</option>
                        <option value="month" ${requestScope.chartUnitParam == 'month' ? 'selected' : ''}>Month</option>
                    </select>
                </div>
            </c:if>
            <button type="button" class="btn-apply" onclick="submitFilterForm()"><i class="fas fa-check"></i> Apply Filter</button>
        </form>
    </div>
</div>
<div id="searchStaffModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3>Search Employee (ID)</h3>
            <span class="close" onclick="closeSearchModal()">&times;</span>
        </div>
        <form id="searchForm" class="modal-form" method="GET" action="staff-report">
            <input type="hidden" name="startDate" value="${requestScope.startDateParam}">
            <input type="hidden" name="endDate" value="${requestScope.endDateParam}">

            <p>Enter an Employee ID to view their detailed performance chart.</p>

            <div class="filter-item">
                <label for="searchStaffId">Enter Employee ID:</label>
                <input type="number" id="searchStaffId" name="searchStaffId" placeholder="Example: 24" value="${requestScope.searchStaffIdParam}" required>
            </div>

            <button type="submit" class="btn-apply"><i class="fas fa-search"></i> Search & View Details</button>
        </form>

        <hr style="margin: 15px 0;">
        <p>Note: Active employees are listed in the Overview table.</p>
    </div>
</div>
<script>
    const isDetailMode = "${requestScope.isDetailMode}" === "true";
    const chartUnit = "${requestScope.chartUnitParam}" || "day";
    const chartContainer = document.getElementById('chartContainer');
    const START_OF_BUSINESS_DATE = "2025-01-01";
    let trendChart;

    // --- FUNCTION TO REFORMAT X-AXIS LABELS ---
    function formatChartLabel(label, unit) {
        if (!label) return 'N/A';
        if (unit === 'day') {
            const parts = label.split('-');
            if (parts.length === 3) {
                return parts[2] + '/' + parts[1];
            }
        } else if (unit === 'month') {
            return 'Month ' + label.replace('-', '/');
        } else if (unit === 'week') {
            const parts = label.split('-W');
            if (parts.length === 2) {
                return 'Week ' + parseInt(parts[1], 10) + '/' + parts[0];
            }
        }
        return label;
    }


    <c:if test="${requestScope.isDetailMode && not empty requestScope.employeeTimeTrendJson}">

    const trendDataJsonString = '<c:out value="${requestScope.employeeTimeTrendJson}" escapeXml="false" />';
    let trendData = [];
    try {
        const trendDataJson = JSON.parse(trendDataJsonString);
        trendData = trendDataJson.map(item => ({
            label: item.label,
            totalServes: item.totalServes,
            totalWorkingHours: item.totalWorkingHours
        }));
    } catch (e) {
        console.error("Error parsing JSON for employeeTimeTrend:", e);
    }

    const ctx = document.getElementById('employeeBookingsChart')?.getContext('2d');

    function updateDetailChart() {
        if (!ctx || trendData.length === 0) return;
        if (trendChart) { trendChart.destroy(); }

        const rawLabels = trendData.map(item => item.label);
        const formattedLabels = rawLabels.map(label => formatChartLabel(label, chartUnit));
        const serves = trendData.map(item => item.totalServes);
        const workingHours = trendData.map(item => item.totalWorkingHours);
        const dataPointSize = 70;
        const minRequiredWidth = formattedLabels.length * dataPointSize;
        const containerWidth = chartContainer.clientWidth;
        let canvasWidth = Math.max(containerWidth, minRequiredWidth);
        ctx.canvas.style.width = '100%';
        ctx.canvas.style.height = '100%';
        ctx.canvas.width = canvasWidth;
        ctx.canvas.height = 450;

        let chartOptions = {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { position: 'top' },
                title: {
                    display: true,
                    text: 'Employee Performance Trend by ' + (chartUnit === 'day' ? 'Day' : chartUnit === 'week' ? 'Week' : 'Month'),
                    font: { size: 16 }
                },
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            let label = context.dataset.label || '';
                            if (label) {
                                label += ': ';
                            }
                            if (context.parsed.y !== null) {
                                if (context.dataset.yAxisID === 'yWorkingHours') {
                                    label += context.parsed.y.toFixed(1) + ' hours';
                                } else {
                                    label += context.parsed.y;
                                }
                            }
                            return label;
                        }
                    }
                }
            },
            scales: {
                x: {
                    labels: formattedLabels,
                    title: {
                        display: true,
                        text: (chartUnit === 'day' ? 'Day (DD/MM)' : chartUnit === 'week' ? 'Week' : 'Month'),
                        color: 'var(--dark-red)',
                        font: { size: 14, weight: 'bold' }
                    },
                    ticks: { maxRotation: 45, minRotation: 45, color: '#333' },
                    grid: { display: false }
                },
                yServes: {
                    type: 'linear',
                    display: true,
                    position: 'left',
                    beginAtZero: true,
                    title: {
                        display: true,
                        text: 'Total Serves (RESERVATION_SERVE)',
                        color: 'var(--staff-chart-color)',
                        font: { size: 14, weight: 'bold' }
                    },
                    ticks: {
                        stepSize: 1,
                        callback: function(value) { if (value % 1 === 0) { return value; } }
                    }
                },
                yWorkingHours: {
                    type: 'linear',
                    display: true,
                    position: 'right',
                    grid: { drawOnChartArea: false },
                    title: {
                        display: true,
                        text: 'Total Working Hours',
                        color: 'var(--revenue-color)',
                        font: { size: 14, weight: 'bold' }
                    },
                    ticks: {
                        callback: function(value) {
                            return value.toFixed(1) + 'h';
                        }
                    }
                }
            }
        };

        trendChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: formattedLabels,
                datasets: [{

                    label: 'Total Working Hours',
                    data: workingHours,
                    backgroundColor: 'rgba(255, 99, 132, 0.8)',
                    borderColor: 'rgba(255, 99, 132, 1)',
                    borderWidth: 1,
                    yAxisID: 'yWorkingHours',
                    order: 1,
                    type: 'bar'
                },
                    {

                        label: 'Total Serves',
                        data: serves,
                        type: 'line',
                        fill: false,
                        borderColor: 'var(--staff-chart-color)',
                        backgroundColor: 'var(--staff-chart-color)',
                        pointStyle: 'circle',
                        pointRadius: 5,
                        pointHoverRadius: 7,
                        borderWidth: 3,
                        yAxisID: 'yServes',
                        order: 2
                    }]
            },
            options: chartOptions
        });
        if (chartContainer) chartContainer.scrollLeft = 0;
    }

    updateDetailChart();
    </c:if>

    // --- FUNCTIONS FOR DATE FILTER MODAL ---
    function openFilterModal() {
        const modalStartDateInput = document.getElementById('modalStartDate');
        modalStartDateInput.min = START_OF_BUSINESS_DATE;
        if (modalStartDateInput.value && modalStartDateInput.value < START_OF_BUSINESS_DATE) {
            modalStartDateInput.value = START_OF_BUSINESS_DATE;
        }
        document.getElementById('filterModal').style.display = 'block';
    }

    function closeFilterModal() {
        document.getElementById('filterModal').style.display = 'none';
    }

    function submitFilterForm() {
        const startDate = document.getElementById('modalStartDate').value;
        const endDate = document.getElementById('modalEndDate').value;
        let url = 'staff-report?startDate=' + startDate + '&endDate=' + endDate;

        if (isDetailMode) {
            const chartUnit = document.getElementById('modalChartUnit').value;
            const employeeId = "${requestScope.selectedEmployeeId}";
            url += '&employeeId=' + employeeId + '&chartUnit=' + chartUnit;
        }

        window.location.href = url;
        closeFilterModal();
    }

    // --- FUNCTIONS FOR EMPLOYEE SEARCH MODAL ---
    function openSearchModal() {
        const searchInput = document.getElementById('searchStaffId');
        if (isDetailMode) {
            const employeeId = "${requestScope.selectedEmployeeId}";
            if (employeeId && employeeId !== '0') {
                searchInput.value = employeeId;
            }
        } else {
            searchInput.value = '';
        }
        document.getElementById('searchStaffModal').style.display = 'block';
    }

    function closeSearchModal() {
        document.getElementById('searchStaffModal').style.display = 'none';
    }

    window.onclick = function(event) {
        const filterModal = document.getElementById('filterModal');
        const searchModal = document.getElementById('searchStaffModal');

        if (event.target == filterModal) {
            closeFilterModal();
        }
        if (event.target == searchModal) {
            closeSearchModal();
        }
    }
</script>
</body>
</html>