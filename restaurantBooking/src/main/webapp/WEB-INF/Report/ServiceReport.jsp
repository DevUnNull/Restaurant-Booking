<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Báo cáo thống kê dịch vụ</title>
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

        /* ==================== LAYOUT CHÍNH ==================== */
        .wrapper {
            display: flex;
            min-height: calc(100vh - var(--top-nav-height));
            position: relative;
        }

        /* TOP NAV  */
        .top-nav {
            position: fixed; top: 0; left: 0; right: 0; height: var(--top-nav-height);
            background-color: var(--main-color); color: var(--text-light);
            display: flex; align-items: center; justify-content: space-between;
            padding: 0; box-shadow: 0 2px 4px rgba(0,0,0,0.1); z-index: 1000;
        }

        /* Tên nhà hàng ở góc trái, trùng với chiều rộng sidebar */
        .top-nav .restaurant-name {
            height: 100%; width: var(--sidebar-width); background-color: var(--dark-red);
            display: flex; align-items: center; justify-content: center;
            font-size: 1.4em; font-weight: bold; color: white; flex-shrink: 0;
        }

        /* Thông tin người dùng đăng nhập */
        .user-info {
            display: flex; align-items: center; padding-right: 20px;
        }
        .user-info span { margin-right: 15px; font-weight: 500; }
        .user-info .btn-logout {
            padding: 8px 12px; background-color: var(--dark-red); border-radius: 4px;
            color: var(--text-light); text-decoration: none; transition: background-color 0.3s;
        }
        .user-info .btn-logout:hover { background-color: #A52A2A; }

        /* SIDEBAR MENU */
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

        /* CONTENT BODY */
        .content {
            flex-grow: 1;
            margin-left: var(--sidebar-width); /* Đẩy nội dung ra khỏi sidebar */
            padding: 20px;
            background-color: #fff;
            min-height: 100%;
        }

        /* ==================== UI ELEMENTS ==================== */

        /* Khu vực Bộ lọc */
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

        /* Nút Áp dụng */
        .btn-apply {
            background-color: var(--main-color);
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

        /* Xuất file */
        .export-group button {
            background-color: #1E88E5; /* Xanh dương cho Export */
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

        /* Biểu đồ và Tùy chọn hiển thị */
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

        /* Phân trang và Tìm kiếm */
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

        .pagination button {
            background: none;
            border: 1px solid #ccc;
            padding: 8px 12px;
            margin: 0 5px;
            border-radius: 4px;
            cursor: pointer;
        }
        .pagination button:hover:not(:disabled) { background-color: #f0f0f0; }

        /* Tiêu đề, Bảng và Container Biểu đồ (Màu đỏ chủ đạo) */
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
    <div class="restaurant-name">Restaurant Booking</div>
</div>

<div class="sidebar">
    <ul>
        <li><a href="#">Dashboard</a></li>
        <li><a href="#">Danh sách dịch vụ</a></li>
    </ul>
</div>

<div class="wrapper">
    <div class="content">
        <h1>Báo cáo thống kê dịch vụ</h1>

        <div class="filter-section">
            <h3 style="color: #555; margin-top: 0; margin-bottom: 15px;">Bộ lọc báo cáo</h3>
            <div class="filter-grid">

                <div class="filter-item">
                    <label for="date-from">Từ ngày</label>
                    <input type="date" id="date-from" value="2024-01-01">
                </div>
                <div class="filter-item">
                    <label for="date-to">Đến ngày</label>
                    <input type="date" id="date-to" value="2024-12-31">
                </div>

                <div class="filter-item">
                    <label for="month-year">Tháng/Năm</label>
                    <input type="month" id="month-year">
                </div>

                <div class="filter-item">
                    <label for="service-type">Loại Dịch vụ</label>
                    <select id="service-type">
                        <option value="all">Tất cả</option>
                        <option value="breakfast">Ăn sáng</option>
                        <option value="lunch">Ăn trưa</option>
                        <option value="dinner">Ăn tối</option>
                        <option value="party">Tiệc/Khác</option>
                    </select>
                </div>

                <div class="filter-item">
                    <label for="status">Trạng thái</label>
                    <select id="status">
                        <option value="all">Tất cả</option>
                        <option value="completed">Thành công</option>
                        <option value="cancelled">Hủy</option>
                        <option value="pending">Đang chờ</option>
                    </select>
                </div>

                <div class="filter-item" style="padding-top: 5px;">
                    <button class="btn-apply"><i class="fas fa-check"></i> Áp dụng</button>
                </div>
            </div>
        </div>

        <div class="chart-options">
            <h2 style="margin: 0; color: var(--main-color);">Báo cáo Doanh thu & Số lượng</h2>

            <div style="display: flex; align-items: center; gap: 20px;">

                <div class="chart-toggle-group">
                    <label style="font-size: 0.9em; color: #555; margin-right: 5px;">Loại biểu đồ:</label>
                    <button class="active" data-type="bar"><i class="fas fa-chart-bar"></i> Cột</button>
                    <button data-type="line"><i class="fas fa-chart-line"></i> Đường</button>
                    <button data-type="pie"><i class="fas fa-chart-pie"></i> Tròn</button>
                    <button data-type="doughnut"><i class="fas fa-chart-area"></i> Vòng</button>
                    <button data-type="polarArea"><i class="fas fa-compass"></i> Vùng Cực</button>
                </div>

                <div class="checkbox-option">
                    <input type="checkbox" id="display-revenue">
                    <label for="display-revenue">Hiển thị theo Doanh thu</label>
                </div>
            </div>
        </div>

        <div id="chartContainer">
            <canvas id="categoryChart"></canvas>
        </div>

        <hr/>

        <h2>Chi tiết: Top Món Bán Chạy Nhất</h2>

        <div class="table-controls">
            <div class="search-box">
                <input type="text" placeholder="🔎 Tìm kiếm tên món/dịch vụ...">
            </div>

            <div class="export-group">
                <button><i class="fas fa-file-excel"></i> Xuất Excel</button>
                <button><i class="fas fa-file-pdf"></i> Xuất PDF</button>
            </div>
        </div>

        <table border="1">
            <thead>
            <tr>
                <th>Hạng</th>
                <th>Tên Món</th>
                <th>Số lượng đã bán</th>
                <th>Doanh thu</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="item" items="${requestScope.topSellingItems}" varStatus="loop">
                <tr>
                    <td>${loop.index + 1}</td>
                    <td>${item.item_name}</td>
                    <td>${item.total_quantity_sold}</td>
                    <td><fmt:formatNumber value="${item.total_revenue_from_item}" type="currency" currencySymbol="VNĐ" maxFractionDigits="0"/></td>
                </tr>
            </c:forEach>
            <c:if test="${empty requestScope.topSellingItems}">
                <tr><td colspan="4" style="text-align: center; color: #999;">Không có dữ liệu chi tiết.</td></tr>
            </c:if>
            </tbody>
        </table>

        <div class="table-controls" style="justify-content: flex-end;">
            <div class="pagination">
                <button disabled>Prev</button>
                <button class="active">1</button>
                <button>2</button>
                <button>3</button>
                <button>Next</button>
            </div>
        </div>

    </div>
</div>

<script>
    // ==================== JAVASCRIPT CHO BIỂU ĐỒ ====================
    // Dữ liệu mẫu (Cần lấy từ biến requestScope.categoryReport trong JSP)
    const reportData = [
        <c:forEach var="item" items="${requestScope.categoryReport}">
        {
            category: "${item.service_category}",
            quantity: ${item.total_quantity_sold},
            revenue: ${item.total_category_revenue}
        },
        </c:forEach>
        // Dữ liệu giả lập nếu requestScope.categoryReport trống (để test)
        <c:if test="${empty requestScope.categoryReport}">
        { category: "Đặt Bàn Trước", quantity: 50, revenue: 9500000 },
        { category: "Tiệc Cưới", quantity: 5, revenue: 50000000 },
        { category: "Cocktail", quantity: 35, revenue: 7000000 }
        </c:if>
    ];

    const ctx = document.getElementById('categoryChart').getContext('2d');
    let categoryChart;

    const redPalette = [
        'rgba(211, 47, 47, 0.7)', 'rgba(255, 99, 132, 0.7)', 'rgba(239, 83, 80, 0.7)',
        'rgba(183, 28, 28, 0.7)', 'rgba(255, 138, 128, 0.7)', 'rgba(121, 85, 72, 0.7)'
    ];
    const redBorderPalette = redPalette.map(color => color.replace('0.7', '1'));

    function updateChart(chartType, isRevenue) {
        if (categoryChart) {
            categoryChart.destroy();
        }

        const labels = reportData.map(item => item.category);
        const dataValues = reportData.map(item => isRevenue ? item.revenue : item.quantity);
        const dataLabel = isRevenue ? 'Tổng Doanh thu (VNĐ)' : 'Tổng Số Lượng Đã Bán';

        let chartOptions = {
            responsive: true,
            plugins: {
                legend: { position: 'top' }
            }
        };

        // Cấu hình trục (scales) cho Bar và Line
        if (chartType === 'bar' || chartType === 'line') {
            chartOptions.scales = {
                y: {
                    beginAtZero: true,
                    title: {
                        display: true,
                        text: dataLabel,
                        color: '#B71C1C'
                    }
                }
            };
        }

        // Cấu hình Dataset
        let datasetConfig = {
            label: dataLabel,
            data: dataValues,
            // Sử dụng nhiều màu cho Radial, một màu cố định cho Bar/Line
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

    // Khởi tạo biểu đồ ban đầu
    updateChart('bar', false);

    // Logic chuyển đổi loại biểu đồ
    document.querySelectorAll('.chart-toggle-group button').forEach(button => {
        button.addEventListener('click', function() {
            document.querySelector('.chart-toggle-group .active').classList.remove('active');
            this.classList.add('active');

            const chartType = this.getAttribute('data-type');
            const isRevenue = document.getElementById('display-revenue').checked;
            updateChart(chartType, isRevenue);
        });
    });

    // Logic chuyển đổi hiển thị Doanh thu/Số lượng
    document.getElementById('display-revenue').addEventListener('change', function() {
        const isRevenue = this.checked;
        const chartType = document.querySelector('.chart-toggle-group .active').getAttribute('data-type');
        updateChart(chartType, isRevenue);
    });
</script>
</body>
</html>