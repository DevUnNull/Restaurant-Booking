<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Báo Cáo Hiệu Suất Nhân Viên</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
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
            --staff-chart-color: #00897B;
            --staff-border-color: #00897B;
            --revenue-color: #4CAF50;
            --cancellation-color: #E91E63;
            --rate-color: #FF9800;
            --booking-color: #2196F3;
        }

        body { font-family: Arial, sans-serif; padding: 0; margin: 0; background-color: #f4f4f4; padding-top: var(--top-nav-height); overflow-x: hidden; }
        .wrapper { display: flex; min-height: calc(100vh - var(--top-nav-height)); position: relative; }

        /* Top Nav */
        .top-nav { position: fixed; top: 0; left: 0; right: 0; height: var(--top-nav-height); background-color: var(--main-color); color: var(--text-light); display: flex; align-items: center; justify-content: space-between; padding: 0 15px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); z-index: 1000; }
        .top-nav .restaurant-group { display: flex; align-items: center; gap: 15px; flex-shrink: 0; }
        .home-button { background-color: var(--main-color); color: white; border: 1px solid white; padding: 5px 10px; border-radius: 4px; text-decoration: none; font-size: 0.9em; font-weight: bold; display: flex; align-items: center; }
        .home-button:hover { background-color: #b71c1c; }
        .top-nav .user-info { display: flex; align-items: center; padding-right: 15px; font-size: 1em; font-weight: bold; color: white; }

        /* Sidebar */
        .sidebar { width: var(--sidebar-width); position: fixed; top: var(--top-nav-height); left: 0; bottom: 0; background-color: var(--menu-bg); color: var(--text-light); padding-top: 10px; box-shadow: 2px 0 5px rgba(0,0,0,0.1); z-index: 999; transition: transform 0.3s ease; }
        .sidebar ul { list-style: none; padding: 0; margin: 0; }
        .sidebar li a { display: block; padding: 15px 20px; text-decoration: none; color: var(--text-light); border-bottom: 1px solid rgba(255, 255, 255, 0.1); transition: background-color 0.3s; }
        .sidebar li a:hover, .sidebar li a.active { background-color: var(--menu-hover); color: white; }

        /* Main Content */
        .main-content-body { margin-left: var(--sidebar-width); flex-grow: 1; padding: 20px; background-color: #f4f4f4; min-height: 100%; box-sizing: border-box; }

        /* CONTAINER FULL WIDTH */
        .content-container {
            background-color: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.05);
            width: 100%;
            max-width: 100%;
            margin: 0 auto;
            box-sizing: border-box;
            min-height: 500px;
        }

        h1 { color: #cc0000; border-bottom: 2px solid #cc0000; padding-bottom: 10px; margin-top: 0; margin-bottom: 25px; font-size: 1.8em; }

        /* Filter Styles */
        .filter-container-styled { border: 1px solid #e0e0e0; border-radius: 4px; padding: 20px; margin-bottom: 20px; background-color: #fff; }
        .filter-header-text { font-weight: bold; color: #555; font-size: 1.1em; margin-bottom: 15px; }
        .btn-apply { background-color: #cc0000; color: white; padding: 8px 15px; border: none; border-radius: 4px; cursor: pointer; font-weight: bold; font-size: 0.95em; transition: background-color 0.3s; display: inline-flex; align-items: center; gap: 5px; }
        .btn-apply:hover { background-color: #a00000; }
        .warning-box-yellow { background-color: #fff9c4; color: #5d4037; padding: 15px; border: 1px solid #fff59d; border-radius: 4px; margin-top: 20px; }

        /* Tables */
        .staff-table { width: 100%; border-collapse: collapse; margin-top: 20px; border: 1px solid #ddd; }
        .staff-table th, .staff-table td { padding: 12px; border: 1px solid #ddd; }
        .staff-table th { background-color: #f8f8f8; color: var(--dark-red); font-weight: bold; text-transform: uppercase; }
        .staff-table tr:hover { background-color: #ffebee; }
        .staff-table td a { color: var(--booking-color); text-decoration: none; transition: color 0.2s; }
        .staff-table td a:hover { color: var(--dark-red); text-decoration: underline; }
        .text-center { text-align: center; }
        .text-right { text-align: right; }
        .text-warning { color: var(--rate-color); }

        /* Info Card */
        .summary-cards-staff { display: flex; gap: 20px; margin-bottom: 20px; flex-wrap: wrap; }
        .staff-info-card { flex: 1; padding: 15px; border-radius: 8px; background-color: #fff; box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1); border-left: 5px solid var(--staff-border-color); min-width: 250px; }
        .staff-info-card strong { color: var(--dark-red); }
        .status-active { color: var(--revenue-color); font-weight: bold; }
        .status-inactive { color: var(--cancellation-color); font-weight: bold; }

        #chartContainer {
            position: relative;
            display: block;
            width: 100%;
            max-width: 100%;
            height: 450px;
            margin: 20px 0;
            padding: 10px;
            border: 1px solid var(--light-red);
            background-color: #fffafa;
            overflow-y: hidden;
            box-sizing: border-box;
        }
        #employeeBookingsChart {
            display: block;
        }

        /* Buttons Chart */
        .chart-toolbar { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid var(--staff-border-color); padding-bottom: 10px; margin-bottom: 15px; flex-wrap: wrap; gap: 10px; }
        .btn-filter-small { background-color: #fff; border: 1px solid #D32F2F; color: #D32F2F; padding: 8px 12px; border-radius: 4px; cursor: pointer; font-weight: bold; display: flex; align-items: center; gap: 5px; }
        .chart-mode-buttons { display: flex; gap: 10px; }
        .btn-mode { padding: 8px 15px; background-color: #fff; border: 1px solid #ccc; border-radius: 4px; cursor: pointer; font-weight: bold; color: #555; }
        .btn-mode.active { background-color: var(--staff-chart-color); color: white; border-color: var(--staff-chart-color); }

        /* Modal & Alert */
        .modal { display: none; position: fixed; z-index: 1001; left: 0; top: 0; width: 100%; height: 100%; overflow: auto; background-color: rgba(0,0,0,0.4); padding-top: 60px; }
        .modal-content { background-color: #fefefe; margin: 5% auto; padding: 20px; border: 1px solid #888; width: 90%; max-width: 400px; border-radius: 8px; }
        .modal-header { display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #eee; padding-bottom: 10px; margin-bottom: 15px; }
        .close { font-size: 28px; font-weight: bold; cursor: pointer; color: #aaa; }
        .filter-item { display: flex; flex-direction: column; margin-bottom: 15px; }
        .filter-item label { font-weight: bold; margin-bottom: 5px; color: #555; }
        .filter-item input { padding: 8px; border: 1px solid #ccc; border-radius: 4px; }
        .pagination-container { display: flex; justify-content: flex-end; margin-top: 25px; }
        .pagination { list-style: none; padding: 0; margin: 0; display: flex; border: 1px solid #ddd; border-radius: 4px; }
        .pagination li a, .pagination li span { display: block; padding: 10px 15px; text-decoration: none; color: #555; border-right: 1px solid #ddd; }
        .pagination li:last-child a { border-right: none; }
        .pagination li.active span { background-color: var(--main-color); color: white; }
        .pagination li.disabled span { color: #ccc; }
        #missingDateAlert { position: fixed; top: 20px; left: 50%; transform: translateX(-50%); padding: 20px 30px; min-width: 300px; background-color: #fff3e0; color: #D32F2F; border-radius: 8px; border: 1px solid #FF9800; display: none; z-index: 1002; font-weight: bold; text-align: center; box-shadow: 0 8px 16px rgba(0,0,0,0.2); }

        @media (max-width: 768px) {
            .sidebar { transform: translateX(-100%); }
            .main-content-body { margin-left: 0; }
        }
    </style>
</head>
<body>
<c:set var="pageSize" value="7" scope="request"/>
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
            <c:otherwise>Khách</c:otherwise>
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
            <c:if test="${not empty sessionScope.sessionWarningMessage}">
                <div id="alertWarning" style="background-color: #fff3cd; color: #856404; padding: 15px; margin-bottom: 20px; border: 1px solid #ffeeba; border-radius: 4px;">${sessionScope.sessionWarningMessage}</div>
                <c:remove var="sessionWarningMessage" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.sessionErrorMessage}">
                <div id="alertError" style="background-color: #f8d7da; color: #721c24; padding: 15px; margin-bottom: 20px; border: 1px solid #f5c6cb; border-radius: 4px;">${sessionScope.sessionErrorMessage}</div>
                <c:remove var="sessionErrorMessage" scope="session"/>
            </c:if>

            <c:choose>
                <c:when test="${requestScope.isDetailMode && not empty requestScope.selectedEmployeeDetail}">
                    <a href="staff-report?startDate=${requestScope.startDateParam}&endDate=${requestScope.endDateParam}" class="home-button" style="margin-bottom: 15px; display: inline-flex; background-color: #555; border-color: #555; font-weight: normal;"><i class="fas fa-arrow-left"></i> Quay lại Tổng quan</a>
                    <h1>Báo Cáo Hiệu Suất Chi Tiết</h1>

                    <form action="staff-report" method="GET" style="margin-bottom: 20px; display: flex; gap: 10px; background: #f9f9f9; padding: 15px; border-radius: 6px; border: 1px solid #eee;">
                        <input type="hidden" name="startDate" value="${requestScope.startDateParam}">
                        <input type="hidden" name="endDate" value="${requestScope.endDateParam}">
                        <input type="hidden" name="pageSize" value="7">
                        <div style="flex-grow: 1;">
                            <input type="text" name="searchStaffName" placeholder="Tìm kiếm nhân viên khác..." style="width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box;" required>
                        </div>
                        <button type="submit" class="btn-apply" style="white-space: nowrap; background-color: #00897B;"><i class="fas fa-search"></i> Tìm kiếm</button>
                    </form>

                    <div class="summary-cards-staff">
                        <div class="staff-info-card">
                            <div><strong>Nhân viên:</strong> ${requestScope.selectedEmployeeDetail.fullName} (${requestScope.selectedEmployeeId})</div>
                            <div><strong>Email:</strong> ${requestScope.selectedEmployeeDetail.email}</div>
                            <div><strong>Điện thoại:</strong> ${requestScope.selectedEmployeeDetail.phoneNumber}</div>
                            <div><strong>Trạng thái:</strong> <span class="${requestScope.selectedEmployeeDetail.status == 'ACTIVE' ? 'status-active' : 'status-inactive'}">${requestScope.selectedEmployeeDetail.status == 'ACTIVE' ? 'ĐANG HOẠT ĐỘNG' : 'KHÔNG HOẠT ĐỘNG'}</span></div>
                        </div>
                    </div>

                    <div class="chart-toolbar">
                        <div style="display: flex; align-items: center; gap: 15px;">
                            <h2 style="color: var(--staff-border-color); margin: 0; border-bottom: none; font-size: 1.5em;">Xu Hướng Hoạt Động</h2>
                            <button type="button" class="btn-filter-small" onclick="openFilterModal()"><i class="fas fa-calendar-alt"></i> Chọn khoảng ngày</button>
                        </div>
                        <div class="chart-mode-buttons">
                            <button type="button" class="btn-mode ${empty requestScope.chartUnitParam || requestScope.chartUnitParam == 'day' ? 'active' : ''}" onclick="changeChartUnit('day')">Ngày</button>
                            <button type="button" class="btn-mode ${requestScope.chartUnitParam == 'week' ? 'active' : ''}" onclick="changeChartUnit('week')">Tuần</button>
                            <button type="button" class="btn-mode ${requestScope.chartUnitParam == 'month' ? 'active' : ''}" onclick="changeChartUnit('month')">Tháng</button>
                        </div>
                    </div>

                    <div id="chartContainer">
                        <canvas id="employeeBookingsChart"></canvas>
                    </div>
                </c:when>

                <c:otherwise>
                    <h1>Báo cáo hiệu suất làm việc của nhân viên</h1>
                    <div class="filter-container-styled">
                        <div class="filter-header-text">Bộ Lọc Báo Cáo</div>
                        <button type="button" class="btn-apply" onclick="openFilterModal()"><i class="fas fa-filter"></i> Mở Bộ Lọc</button>
                        <c:if test="${empty requestScope.employeeData && (empty requestScope.startDateParam || empty requestScope.endDateParam)}">
                            <div class="warning-box-yellow">Vui lòng chọn cả ngày bắt đầu và ngày kết thúc để xem báo cáo chi tiết.</div>
                        </c:if>
                    </div>

                    <c:if test="${not empty requestScope.employeeData}">
                        <table class="staff-table">
                            <thead>
                            <tr>
                                <th>ID</th>
                                <th>Tên</th>
                                <th>Trạng thái</th>
                                <th>Ngày Ca</th>
                                <th>Tổng Giờ</th>
                                <th>Hành động</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="emp" items="${requestScope.employeeData}">
                                <tr>
                                    <td>${emp.employeeId}</td>
                                    <td>${emp.employeeName}</td>
                                    <td>
                                        <span class="${emp.employeeStatus == 'ACTIVE' ? 'status-active' : 'status-inactive'}">${emp.employeeStatus == 'ACTIVE' ? 'ĐANG HOẠT ĐỘNG' : 'KHÔNG HOẠT ĐỘNG'}</span>
                                    </td>
                                    <td class="text-center">${emp.totalShiftDays}</td>
                                    <td class="text-right"><fmt:formatNumber value="${emp.totalWorkingHours}" pattern="#,##0.00"/> giờ</td>
                                    <td class="text-center"><a href="staff-report?employeeId=${emp.employeeId}&startDate=${requestScope.startDateParam}&endDate=${requestScope.endDateParam}">Xem Chi Tiết</a></td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                        <c:set var="currentPage" value="${requestScope.currentPage}"/>
                        <c:set var="totalPages" value="${requestScope.totalPages}"/>
                        <c:if test="${totalPages > 1}">
                            <div class="pagination-container">
                                <ul class="pagination">
                                    <c:url var="prevUrl" value="staff-report"><c:param name="page" value="${currentPage - 1}"/><c:param name="pageSize" value="7"/><c:param name="startDate" value="${requestScope.startDateParam}"/><c:param name="endDate" value="${requestScope.endDateParam}"/></c:url>
                                    <c:choose><c:when test="${currentPage > 1}"><li><a href="${prevUrl}">Trước</a></li></c:when><c:otherwise><li class="disabled"><span>Trước</span></li></c:otherwise></c:choose>
                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                        <c:url var="pageUrl" value="staff-report"><c:param name="page" value="${i}"/><c:param name="pageSize" value="7"/><c:param name="startDate" value="${requestScope.startDateParam}"/><c:param name="endDate" value="${requestScope.endDateParam}"/></c:url>
                                        <li class="${i == currentPage ? 'active' : ''}"><a href="${pageUrl}">${i}</a></li>
                                    </c:forEach>
                                    <c:url var="nextUrl" value="staff-report"><c:param name="page" value="${currentPage + 1}"/><c:param name="pageSize" value="7"/><c:param name="startDate" value="${requestScope.startDateParam}"/><c:param name="endDate" value="${requestScope.endDateParam}"/></c:url>
                                    <c:choose><c:when test="${currentPage < totalPages}"><li><a href="${nextUrl}">Sau</a></li></c:when><c:otherwise><li class="disabled"><span>Sau</span></li></c:otherwise></c:choose>
                                </ul>
                            </div>
                        </c:if>
                    </c:if>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <div id="filterModal" class="modal">
        <div class="modal-content">
            <div class="modal-header"><h3>Bộ Lọc Báo Cáo</h3><span class="close" onclick="closeFilterModal()">&times;</span></div>
            <form id="modalForm" class="modal-form">
                <div class="filter-item"><label>Từ Ngày</label><input type="date" id="modalStartDate" value="${requestScope.startDateParam}"></div>
                <div class="filter-item"><label>Đến Ngày</label><input type="date" id="modalEndDate" value="${requestScope.endDateParam}"></div>
                <button type="button" class="btn-apply" onclick="submitFilterForm()"><i class="fas fa-check"></i> Áp Dụng</button>
            </form>
        </div>
    </div>
</div>

<div id="missingDateAlert"><i class="fas fa-exclamation-triangle"></i> <span id="missingDateAlertText">Thông báo</span></div>

<script>
    const isDetailMode = "${requestScope.isDetailMode}" === "true";
    const chartUnit = "${requestScope.chartUnitParam}" || "day";
    const START_OF_BUSINESS_DATE = "2025-09-01";
    let trendChart = null;

    const alertBox = document.getElementById('missingDateAlert');
    const alertText = document.getElementById('missingDateAlertText');
    function showAlert(msg) {
        if(!alertBox) return;
        alertText.textContent = msg;
        alertBox.style.display = 'block';
        setTimeout(()=> alertBox.style.opacity = '1', 10);
        setTimeout(()=> { alertBox.style.opacity = '0'; setTimeout(()=> alertBox.style.display='none', 300); }, 3000);
    }

    function changeChartUnit(unit) {
        const url = new URL(window.location.href);
        url.searchParams.set('chartUnit', unit);
        window.location.href = url.toString();
    }

    function formatChartLabel(label, unit) {
        if (!label) return 'N/A';
        try {
            if (unit === 'day') {
                const p = label.split('-');
                return p.length === 3 ? p[2] + '/' + p[1] : label;
            } else if (unit === 'month') return 'Tháng ' + label.replace('-', '/');
            else if (unit === 'week') {
                const p = label.split('-W');
                return p.length === 2 ? 'Tuần ' + parseInt(p[1], 10) + '/' + p[0] : label;
            }
        } catch (e) { return label; }
        return label;
    }

    <c:if test="${requestScope.isDetailMode}">
    function initChart() {
        const chartCanvas = document.getElementById('employeeBookingsChart');
        const chartContainer = document.getElementById('chartContainer');
        if (!chartCanvas) return;

        const labels = [];
        const hoursData = [];
        <c:if test="${not empty requestScope.employeeTimeTrend}">
        <c:forEach var="item" items="${requestScope.employeeTimeTrend}">
        labels.push("${item.label}");
        hoursData.push(${item.totalWorkingHours});
        </c:forEach>
        </c:if>

        if (labels.length === 0) {
            if(chartContainer) chartContainer.innerHTML = '<div style="text-align:center; padding:40px; color:#777;">Không có dữ liệu.</div>';
            return;
        }

        const formattedLabels = labels.map(l => formatChartLabel(l, chartUnit));
        const ctx = chartCanvas.getContext('2d');

        if (trendChart) trendChart.destroy();

        trendChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: formattedLabels,
                datasets: [
                    {
                        label: 'Tổng Giờ Làm',
                        data: hoursData,
                        backgroundColor: 'rgba(255, 99, 132, 0.8)',
                        borderWidth: 1,
                        yAxisID: 'yWorkingHours'
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                animation: false,
                layout: { padding: { right: 20, left: 10 } },
                plugins: {
                    legend: { position: 'top' },
                    title: { display: true, text: 'Biểu đồ Giờ Làm Việc', font: { size: 16 } }
                },
                scales: {
                    x: {
                        grid: { display: false },
                        ticks: {
                            autoSkip: true,
                            maxRotation: 0
                        }
                    },
                    yWorkingHours: {
                        type: 'linear',
                        position: 'left',
                        beginAtZero: true,
                        title: { display: true, text: 'Giờ làm (h)' },
                        grid: { drawOnChartArea: true }
                    }
                }

            }
        });
    }
    document.addEventListener('DOMContentLoaded', initChart);
    </c:if>

    function openFilterModal() {
        const m = document.getElementById('filterModal');
        const d = document.getElementById('modalStartDate');
        if(d) d.min = START_OF_BUSINESS_DATE;
        if(m) m.style.display = 'block';
    }
    function closeFilterModal() {
        const m = document.getElementById('filterModal');
        if(m) m.style.display = 'none';
    }
    function submitFilterForm() {
        let s = document.getElementById('modalStartDate').value;
        let e = document.getElementById('modalEndDate').value;
        if(!s || !e) { showAlert("Vui lòng chọn đủ ngày."); return; }

        let url = 'staff-report?startDate=' + s + '&endDate=' + e + '&page=1&pageSize=7';
        if (isDetailMode) {
            const currentUnit = "${requestScope.chartUnitParam}" || 'day';
            const employeeId = "${requestScope.selectedEmployeeId}";
            url += '&employeeId=' + employeeId + '&chartUnit=' + currentUnit;
        }
        window.location.href = url;
    }
    window.onclick = e => {
        const m = document.getElementById('filterModal');
        if(m && e.target == m) closeFilterModal();
    }

</script>
</body>
</html>