<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Service Report Dashboard</title>

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

        /* --- NAVBAR & HEADER  --- */
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

        table td:nth-child(2) {
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            max-width: 250px;
        }

        table tbody tr {
            height: 50px;
        }


        h1, h2, h3 { color: var(--dark-red); }
        h1 { border-bottom: 2px solid var(--main-color); padding-bottom: 10px; }
        hr { border: none; height: 1px; background-color: var(--light-red); margin: 20px 0; }
        table { width: 100%; border-collapse: collapse; margin-bottom: 30px; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: left; }
        th { background-color: var(--light-red); color: var(--dark-red); font-weight: bold; }
        tbody tr:hover { background-color: #fce4ec; }
        #chartContainer {
            width: 100%; max-width: 800px; margin: 20px auto; padding: 15px;
            border: 1px solid var(--light-red); border-radius: 8px; background-color: #fffafa;
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

<div class="sidebar">
    <ul>
        <li><a href="#" class="active">Service Statistics Report</a></li>

    </ul>
</div>

<div class="wrapper">
    <div class="content">
        <h1>Service Statistics Report</h1>

        <div class="filter-section">
            <h3 style="color: #555; margin-top: 0; margin-bottom: 15px;">Report Filters</h3>

            <form action="ServiceReport" method="GET">
                <div class="filter-grid">

                    <div class="filter-item">
                        <label for="serviceType">Service Type</label>
                        <select id="serviceType" name="serviceType">
                            <option value="" ${requestScope.selectedServiceType == '' ? 'selected' : ''}>-- Service Type --</option>
                            <option value="breakfast" ${requestScope.selectedServiceType == 'breakfast' ? 'selected' : ''}>Breakfast</option>
                            <option value="lunch" ${requestScope.selectedServiceType == 'lunch' ? 'selected' : ''}>Lunch</option>
                            <option value="dinner" ${requestScope.selectedServiceType == 'dinner' ? 'selected' : ''}>Dinner</option>
                            <option value="party" ${requestScope.selectedServiceType == 'party' ? 'selected' : ''}>Party/Other</option>
                        </select>
                    </div>

                    <div class="filter-item">
                        <label for="status">Status</label>
                        <select id="status" name="status">
                            <option value="" ${requestScope.selectedStatus == '' || requestScope.selectedStatus == null ? 'selected' : ''}>-- Status --</option>
                            <option value="COMPLETED" ${requestScope.selectedStatus == 'COMPLETED' ? 'selected' : ''}>Completed</option>
                            <option value="CANCELLED" ${requestScope.selectedStatus == 'CANCELLED' ? 'selected' : ''}>Cancelled</option>
                            <option value="PENDING" ${requestScope.selectedStatus == 'PENDING' ? 'selected' : ''}>Pending</option>
                            <option value="NO_SHOW" ${requestScope.selectedStatus == 'NO_SHOW' ? 'selected' : ''}>No Show</option>
                        </select>
                    </div>

                    <div class="filter-item" style="padding-top: 5px;">
                        <button type="submit" class="btn-apply"><i class="fas fa-check"></i> Apply</button>
                    </div>
                </div>
            </form>
        </div>

        <c:if test="${not empty requestScope.warningMessage}">
            <div id="alertWarning" style="background-color: #fff3cd; color: #856404; padding: 15px; margin-bottom: 20px; border: 1px solid #ffeeba; border-radius: 4px;">
                <i class="fas fa-exclamation-triangle"></i>
                <strong>Warning:</strong> ${requestScope.warningMessage}
            </div>
        </c:if>

        <c:if test="${not empty requestScope.errorMessage}">
            <div id="alertError" style="background-color: #f8d7da; color: #721c24; padding: 15px; margin-bottom: 20px; border: 1px solid #f5c6cb; border-radius: 4px;">
                <i class="fas fa-times-circle"></i>
                <strong>System Error:</strong> ${requestScope.errorMessage}
            </div>
        </c:if>


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

                <%-- Dữ liệu thật từ Controller --%>
                <c:forEach var="item" items="${requestScope.topSellingItems}" varStatus="loop">
                    <tr>
                        <td>${loop.index + 1}</td>
                        <td>${item.item_name}</td>
                        <td>${item.total_quantity_sold}</td>
                        <td><fmt:formatNumber value="${item.total_revenue_from_item}" type="currency" currencySymbol="VND" maxFractionDigits="0"/></td>
                    </tr>
                </c:forEach>

                <%-- Trường hợp không có dữ liệu ban đầu --%>
                <c:if test="${empty requestScope.topSellingItems}">
                    <tr><td colspan="4" style="text-align: center; color: #999;">No detailed data available.</td></tr>
                </c:if>
                </tbody>
            </table>

            <div class="table-controls" style="justify-content: flex-end;">
                <div class="pagination">
                </div>
            </div>
        </div>

    </div>
</div>

<script>

    const hasWarning = "${requestScope.warningMessage}" !== "";

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

    const ctx = document.getElementById('categoryChart').getContext('2d');
    let categoryChart;
    const chartContainer = document.getElementById('chartContainer');

    const redPalette = [
        'rgba(211, 47, 47, 0.7)', 'rgba(255, 99, 132, 0.7)', 'rgba(239, 83, 80, 0.7)',
        'rgba(183, 28, 28, 0.7)', 'rgba(255, 138, 128, 0.7)', 'rgba(121, 85, 72, 0.7)'
    ];
    const redBorderPalette = redPalette.map(color => color.replace('0.7', '1'));

    function updateChart(chartType, isRevenue) {
        if (categoryChart) {
            categoryChart.destroy();
        }

        if (hasWarning || reportData.length === 0) {
            chartContainer.style.display = 'none';
            return;
        }

        chartContainer.style.display = 'block';

        const labels = reportData.map(item => item.category);

        const dataValues = reportData.map(item => isRevenue ? item.revenue : item.quantity);

        const dataLabel = isRevenue ? 'Total Revenue (VND)' : 'Total Quantity Sold';

        let chartOptions = {
            responsive: true,
            plugins: {
                legend: { position: 'top' }
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
                    }
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

    updateChart('bar', false);

    document.querySelectorAll('.chart-toggle-group button').forEach(button => {
        button.addEventListener('click', function() {
            document.querySelector('.chart-toggle-group .active').classList.remove('active');
            this.classList.add('active');

            const chartType = this.getAttribute('data-type');
            const isRevenue = document.getElementById('display-revenue').checked;
            updateChart(chartType, isRevenue);
        });
    });

    document.getElementById('display-revenue').addEventListener('change', function() {
        const isRevenue = this.checked;
        const chartType = document.querySelector('.chart-toggle-group .active').getAttribute('data-type');
        updateChart(chartType, isRevenue);
    });

    // ==================== PAGINATION & SEARCH JAVASCRIPT ====================

    const tableBody = document.querySelector('table tbody');
    const paginationContainer = document.querySelector('.pagination');
    const searchInput = document.getElementById('searchInput');
    const btnSearch = document.getElementById('btnSearch');

    // Lấy tất cả các hàng dữ liệu ban đầu
    const dataRows = Array.from(tableBody.querySelectorAll('tr'))
        .filter(row => row.querySelector('td:not([colspan="4"])')); // Lọc bỏ hàng "No detailed data available"

    // Xử lý trường hợp không có dữ liệu thật
    const noDataRowContainer = tableBody.querySelector('tr td[colspan="4"]')?.parentElement;
    if (noDataRowContainer && dataRows.length > 0) {
        noDataRowContainer.style.display = 'none';
    }

    let filteredRows = [...dataRows];
    const rowsPerPage = 5;
    let currentPage = 1;

    /**
     * Hiển thị các hàng cho trang hiện tại từ danh sách filteredRows
     */
    function displayPage(page) {
        const start = (page - 1) * rowsPerPage;
        const end = start + rowsPerPage;

        dataRows.forEach(row => row.style.display = 'none');

        for (let i = start; i < end && i < filteredRows.length; i++) {
            filteredRows[i].style.display = 'table-row';
        }

        for (let i = 0; i < filteredRows.length; i++) {
            const rankCell = filteredRows[i].querySelector('td:first-child');
            if(rankCell && rankCell.getAttribute('data-fixed-rank') !== 'true') {
                rankCell.textContent = i + 1;
            }
        }

        // Xử lý trường hợp không có dữ liệu
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

    /**
     * Tạo và hiển thị các nút phân trang
     */
    function setupPagination() {
        paginationContainer.innerHTML = '';
        const pageCount = Math.ceil(filteredRows.length / rowsPerPage);

        if (pageCount <= 1) {
            if (filteredRows.length === 1 && filteredRows[0].querySelector('td:first-child').getAttribute('data-fixed-rank') === 'true') {
                dataRows.forEach(row => row.style.display = 'none');
                filteredRows[0].style.display = 'table-row';
            } else {
                displayPage(1);
            }
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


    /**
     * Xử lý sự kiện tìm kiếm
     */
    function handleSearch() {
        const searchTerm = searchInput.value.toLowerCase().trim();

        dataRows.forEach(row => {
            const rankCell = row.querySelector('td:first-child');
            if(rankCell) rankCell.removeAttribute('data-fixed-rank');
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
                    if(rankCell) {
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

    btnSearch.addEventListener('click', handleSearch);

    searchInput.addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            handleSearch();
            e.preventDefault();
        }
    });

    setupPagination();
    displayPage(currentPage);

    // ==================== LOGIC EXPORT ====================

    // Hàm lấy tất cả các tham số lọc hiện tại từ URL
    function getFilterParams() {
        const urlParams = new URLSearchParams(window.location.search);
        let params = '';

        // Lấy các tham số lọc chính
        const startDate = urlParams.get('startDate') || '';
        const endDate = urlParams.get('endDate') || '';
        const serviceType = urlParams.get('serviceType') || '';
        const status = urlParams.get('status') || '';

        if (startDate) params += '&startDate=' + startDate;
        if (endDate) params += '&endDate=' + endDate;
        if (serviceType) params += '&serviceType=' + serviceType;
        if (status) params += '&status=' + status;

        return params;
    }


    const btnExportExcel = document.getElementById('btnExportExcel');
    const btnExportPDF = document.getElementById('btnExportPDF');

    btnExportExcel.addEventListener('click', function() {
        const params = getFilterParams();
        window.location.href = "ExportReportServlet?type=excel" + params;
        alert("Đang tải file Excel...");
    });

    btnExportPDF.addEventListener('click', function() {
        const params = getFilterParams();
        window.location.href = "ExportReportServlet?type=pdf" + params;
        alert("Đang tải file PDF...");
    });
</script>
</body>
</html>