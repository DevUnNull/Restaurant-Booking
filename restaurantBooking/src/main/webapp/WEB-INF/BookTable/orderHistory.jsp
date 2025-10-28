<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.fpt.restaurantbooking.models.Reservation" %>
<%@ page import="com.fpt.restaurantbooking.models.Table" %>
<%@ page import="com.fpt.restaurantbooking.controllers.OrderHistoryServlet" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Danh sách bàn đã đặt</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

    <style>
        /* --- General Reset & Body Styling --- */
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body, html {
            font-family: 'Montserrat', sans-serif;
            background-image: linear-gradient(rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.6)), url('https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?q=80&w=2070&auto=format&fit=crop');
            background-position: center;
            background-size: cover;
            background-attachment: fixed;
            color: #f0f0f0;
            min-height: 100vh;
        }

        .container {
            width: 90%;
            max-width: 1000px;
            margin: 40px auto;
            background-color: rgba(20, 10, 10, 0.75);
            backdrop-filter: blur(8px);
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.37);
            border: 1px solid rgba(255, 255, 255, 0.18);
        }

        h2 {
            text-align: center;
            margin-bottom: 30px;
            color: #fff;
            font-size: 2.5em;
            font-weight: 700;
            letter-spacing: 2px;
            text-transform: uppercase;
            text-shadow: 2px 2px 8px rgba(0,0,0,0.5);
        }

        /* --- Messages --- */
        .message {
            margin-bottom: 25px;
            padding: 15px;
            border-radius: 8px;
            font-weight: bold;
            text-align: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.2);
        }
        .success-message {
            background: rgba(40, 167, 69, 0.8);
            color: white;
            border: 1px solid rgba(40, 167, 69, 0.5);
        }
        .error-message {
            background: rgba(220, 53, 69, 0.8);
            color: white;
            border: 1px solid rgba(220, 53, 69, 0.5);
        }

        /* --- SEARCH & FILTER SECTION --- */
        .filter-section {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            margin-bottom: 30px;
            padding: 20px;
            background-color: rgba(0, 0, 0, 0.3);
            border-radius: 10px;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .search-box {
            flex: 1;
            min-width: 250px;
            position: relative;
        }

        .search-box input {
            width: 100%;
            padding: 12px 45px 12px 15px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 8px;
            background: rgba(0, 0, 0, 0.4);
            color: #fff;
            font-family: 'Montserrat', sans-serif;
            font-size: 1em;
            outline: none;
            transition: border-color 0.3s ease;
        }

        .search-box input:focus {
            border-color: #e74c3c;
        }

        .search-box input::placeholder {
            color: rgba(255, 255, 255, 0.5);
        }

        .search-box i {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: rgba(255, 255, 255, 0.5);
        }

        .filter-group {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .filter-group label {
            color: #fff;
            font-weight: 500;
            white-space: nowrap;
        }

        .filter-group select {
            padding: 10px 15px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 8px;
            background: rgba(0, 0, 0, 0.4);
            color: #fff;
            font-family: 'Montserrat', sans-serif;
            outline: none;
            cursor: pointer;
            min-width: 150px;
        }

        .filter-group select:focus {
            border-color: #e74c3c;
        }

        .sort-buttons {
            display: flex;
            gap: 10px;
        }

        .sort-btn {
            padding: 10px 15px;
            background: rgba(23, 162, 184, 0.3);
            border: 1px solid #17a2b8;
            color: #17a2b8;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .sort-btn:hover {
            background: #17a2b8;
            color: white;
        }

        .sort-btn.active {
            background: #17a2b8;
            color: white;
        }
        .sort-btn.asc::after {
            content: " ↑";
            margin-left: 5px;
        }
        .sort-btn.desc::after {
            content: " ↓";
            margin-left: 5px;
        }

        /* --- Table Styling --- */
        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin-bottom: 30px;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(0,0,0,0.3);
            background-color: rgba(255, 255, 255, 0.08);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        table th, table td {
            border-bottom: 1px solid rgba(255, 255, 255, 0.15);
            padding: 18px 15px;
            text-align: center;
            vertical-align: middle;
        }

        table th {
            background: #e74c3c;
            color: white;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.95em;
        }

        table tr:last-child td {
            border-bottom: none;
        }

        table tbody tr {
            transition: background-color 0.3s ease;
        }

        table tbody tr:hover {
            background-color: rgba(255, 255, 255, 0.05);
        }

        /* --- Status Badges --- */
        .status {
            font-weight: bold;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.9em;
            display: inline-block;
            min-width: 120px;
        }

        .pending {
            background-color: rgba(255, 193, 7, 0.2);
            color: #ffc107;
            border: 1px solid #ffc107;
        }

        .confirmed {
            background-color: rgba(40, 167, 69, 0.2);
            color: #28a745;
            border: 1px solid #28a745;
        }

        .done {
            background-color: rgba(108, 117, 125, 0.2);
            color: #6c757d;
            border: 1px solid #6c757d;
        }

        /* --- Action Buttons --- */
        .btn {
            background: #17a2b8;
            color: white;
            border: none;
            padding: 8px 16px; /* Giảm kích thước để gọn hơn */
            border-radius: 8px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 0.9em; /* Giảm kích thước chữ */
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
            position: relative;
            overflow: hidden;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.3);
            background: #138496; /* Tối hơn khi hover */
        }

        .btn:active {
            transform: translateY(0);
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
        }

        .btn i {
            font-size: 1em; /* Kích thước biểu tượng nhỏ hơn */
            transition: transform 0.3s ease;
        }

        .btn:hover i {
            transform: scale(1.2); /* Phóng to nhẹ biểu tượng khi hover */
        }

        .btn-detail {
            background: #17a2b8;
        }

        .btn-delete {
            background: #dc3545;
        }

        .btn-delete:hover {
            background: #c82333;
        }

        /* Tooltip cho nút */
        .btn::after {
            content: attr(title);
            position: absolute;
            bottom: 100%;
            left: 50%;
            transform: translateX(-50%);
            background: rgba(0, 0, 0, 0.8);
            color: white;
            padding: 5px 10px;
            border-radius: 5px;
            font-size: 0.8em;
            white-space: nowrap;
            opacity: 0;
            visibility: hidden;
            transition: opacity 0.3s ease, visibility 0.3s ease;
            margin-bottom: 8px;
        }

        .btn:hover::after {
            opacity: 1;
            visibility: visible;
        }

        .back-link-container {
            text-align: center;
            margin-top: 20px;
        }

        .no-results {
            text-align: center;
            padding: 40px;
            color: rgba(255, 255, 255, 0.6);
            font-size: 1.1em;
        }

        /* --- Pagination --- */
        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
            margin-top: 30px;
            flex-wrap: wrap;
        }

        .pagination button,
        .pagination span {
            padding: 10px 16px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            background: rgba(0, 0, 0, 0.4);
            color: #fff;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s ease;
            min-width: 45px;
            text-align: center;
        }

        .pagination button:hover:not(:disabled) {
            background: #17a2b8;
            border-color: #17a2b8;
            transform: translateY(-2px);
        }

        .pagination button:disabled {
            opacity: 0.4;
            cursor: not-allowed;
        }

        .pagination .active {
            background: #17a2b8;
            border-color: #17a2b8;
            color: white;
        }

        .pagination-info {
            color: rgba(255, 255, 255, 0.7);
            font-size: 0.95em;
        }
    </style>
</head>
<body>
<%
    // Lấy dữ liệu từ request attributes
    List<OrderHistoryServlet.ReservationWithTables> reservations =
            (List<OrderHistoryServlet.ReservationWithTables>) request.getAttribute("reservations");
    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");

    // Formatter cho ngày và giờ
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
    DateTimeFormatter datetimeFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

    if (reservations == null) {
        reservations = new java.util.ArrayList<>();
    }
%>

<div class="container">
    <h2><i class="fas fa-history"></i> Lịch sử đặt bàn</h2>

    <!-- Success Message -->
    <%
        if (successMessage != null) {
    %>
    <div class="message success-message">
        <i class="fas fa-check-circle"></i> <%= successMessage %>
    </div>
    <%
        }

        // Check for cancellation success
        String cancelled = request.getParameter("cancelled");
        if ("true".equals(cancelled)) {
    %>
    <div class="message success-message">
        <i class="fas fa-check-circle"></i> Hủy đơn đặt bàn thành công!
    </div>
    <%
        }
    %>

    <!-- Error Message -->
    <%
        if (errorMessage != null) {
    %>
    <div class="message error-message">
        <i class="fas fa-exclamation-circle"></i> <%= errorMessage %>
    </div>
    <%
        }
    %>

    <!-- SEARCH & FILTER SECTION -->
    <div class="filter-section">
        <div class="search-box">
            <input type="text" id="searchInput" placeholder="Tìm kiếm theo mã đặt bàn, số bàn...">
            <i class="fas fa-search"></i>
        </div>

        <div class="filter-group">
            <label for="statusFilter"><i class="fas fa-filter"></i> Trạng thái:</label>
            <select id="statusFilter">
                <option value="all">Tất cả</option>
                <option value="PENDING">Đang chờ</option>
                <option value="CONFIRMED">Đã xác nhận</option>
                <option value="DONE">Hoàn tất</option>
            </select>
        </div>

        <div class="sort-buttons">
            <button class="sort-btn" id="sortCreatedBtn" onclick="sortByCreated()">
                <i class="fas fa-calendar-plus"></i> Sắp xếp theo thời gian tạo
            </button>
            <button class="sort-btn" id="sortDateBtn" onclick="sortByDate()">
                <i class="fas fa-calendar-alt"></i> Sắp xếp theo ngày
            </button>
            <button class="sort-btn" id="sortTimeBtn" onclick="sortByTime()">
                <i class="fas fa-clock"></i> Sắp xếp theo giờ
            </button>
        </div>
    </div>

    <table id="bookingTable">
        <thead>
        <tr>
            <th>Mã đặt bàn</th>
            <th>Ngày</th>
            <th>Giờ</th>
            <th>Thời gian đặt</th>
            <th>Số bàn</th>
            <th>Số người</th>
            <th>Trạng thái</th>
            <th>Hành động</th>
        </tr>
        </thead>
        <tbody id="bookingTableBody">
        <%
            if (reservations.isEmpty()) {
        %>
        <tr>
            <td colspan="8" style="text-align: center; padding: 40px; color: rgba(255, 255, 255, 0.6);">
                <i class="fas fa-inbox" style="font-size: 3em; margin-bottom: 15px; color: rgba(255, 255, 255, 0.3);"></i>
                <div style="font-size: 1.2em; font-weight: 500;">Chưa có đơn đặt bàn nào</div>
            </td>
        </tr>
        <%
        } else {
            for (OrderHistoryServlet.ReservationWithTables item : reservations) {
                Reservation r = item.getReservation();
                List<Table> tables = item.getTables();

                // Tạo danh sách tên bàn
                StringBuilder tableNames = new StringBuilder();
                for (int i = 0; i < tables.size(); i++) {
                    if (i > 0) tableNames.append(", ");
                    tableNames.append(tables.get(i).getTableName() != null ? tables.get(i).getTableName() : "Bàn " + tables.get(i).getTableId());
                }

                // Map status
                String statusClass = "pending";
                String statusText = "⏳ Đang chờ";
                if ("CONFIRMED".equals(r.getStatus())) {
                    statusClass = "confirmed";
                    statusText = "✅ Đã xác nhận";
                } else if ("DONE".equals(r.getStatus()) || "COMPLETED".equals(r.getStatus())) {
                    statusClass = "done";
                    statusText = "✔️ Hoàn tất";
                } else if ("CANCELLED".equals(r.getStatus())) {
                    statusClass = "done";
                    statusText = "❌ Đã hủy";
                }
        %>
        <tr data-status="<%= r.getStatus() %>"
            data-date="<%= r.getReservationDate() != null ? r.getReservationDate().toString() : "" %>"
            data-time="<%= r.getReservationTime() != null ? r.getReservationTime().toString() : "" %>"
            data-created="<%= r.getCreatedAt() != null ? r.getCreatedAt().toString() : "" %>"
            data-updated="<%= r.getUpdatedAt() != null ? r.getUpdatedAt().toString() : "" %>">
            <td>DB<%= String.format("%03d", r.getReservationId()) %></td>
            <td><%= r.getReservationDate() != null ? r.getReservationDate().format(dateFormatter) : "N/A" %></td>
            <td><%= r.getReservationTime() != null ? r.getReservationTime().format(timeFormatter) : "N/A" %></td>
            <td>
                <%
                    // Hiển thị thời gian tạo hoặc thời gian cập nhật
                    if (r.getUpdatedAt() != null && r.getCreatedAt() != null) {
                        // Kiểm tra nếu updated khác với created thì hiển thị updated
                        if (!r.getUpdatedAt().equals(r.getCreatedAt())) {
                %>
                <span title="Cập nhật: <%= r.getUpdatedAt().format(datetimeFormatter) %>">
                            <i class="fas fa-edit" style="color: #ffc107;"></i> <%= r.getUpdatedAt().format(datetimeFormatter) %>
                        </span>
                <%
                } else {
                %>
                <span title="Tạo: <%= r.getCreatedAt().format(datetimeFormatter) %>">
                            <i class="fas fa-clock"></i> <%= r.getCreatedAt().format(datetimeFormatter) %>
                        </span>
                <%
                    }
                } else if (r.getCreatedAt() != null) {
                %>
                <span title="Tạo: <%= r.getCreatedAt().format(datetimeFormatter) %>">
                        <i class="fas fa-clock"></i> <%= r.getCreatedAt().format(datetimeFormatter) %>
                    </span>
                <%
                } else {
                %>
                N/A
                <%
                    }
                %>
            </td>
            <td><%= tableNames.toString() %></td>
            <td><%= r.getGuestCount() %></td>
            <td><span class="status <%= statusClass %>"><%= statusText %></span></td>
            <td>
                <div style="display: flex; gap: 10px; justify-content: center; align-items: center; flex-wrap: wrap;">
                    <a href="orderDetails?id=<%= r.getReservationId() %>" class="btn btn-detail" title="Xem chi tiết đơn hàng">
                        <i class="fas fa-eye"></i> Chi tiết
                    </a>
                    <% if (!"DONE".equals(r.getStatus()) && !"CANCELLED".equals(r.getStatus())) { %>
                    <a href="cancelOrder?reservationId=<%= r.getReservationId() %>" class="btn btn-delete" title="Hủy đơn hàng" onclick="return confirm('Bạn có chắc chắn muốn hủy đơn đặt bàn này?');">
                        <i class="fas fa-trash-alt"></i> Hủy
                    </a>
                    <% } %>
                </div>
            </td>
        </tr>
        <%
                }
            }
        %>
        </tbody>
    </table>

    <div id="noResults" class="no-results" style="display: none;">
        <i class="fas fa-search" style="font-size: 3em; margin-bottom: 15px; opacity: 0.3;"></i>
        <p>Không tìm thấy kết quả phù hợp</p>
    </div>

    <!-- Pagination -->
    <div class="pagination" id="pagination">
        <button id="firstPageBtn" onclick="goToPage(1)">
            <i class="fas fa-angle-double-left"></i>
        </button>
        <button id="prevPageBtn" onclick="goToPreviousPage()">
            <i class="fas fa-angle-left"></i>
        </button>
        <div id="pageNumbers"></div>
        <button id="nextPageBtn" onclick="goToNextPage()">
            <i class="fas fa-angle-right"></i>
        </button>
        <button id="lastPageBtn" onclick="goToPage(-1)">
            <i class="fas fa-angle-double-right"></i>
        </button>
        <span class="pagination-info" id="pageInfo"></span>
    </div>

    <div class="back-link-container">
        <a href="home" class="btn" style="background-color: #6c757d;"><i class="fas fa-home"></i> Quay về trang chủ</a>
    </div>
</div>

<script>
    const searchInput = document.getElementById('searchInput');
    const statusFilter = document.getElementById('statusFilter');
    const tableBody = document.getElementById('bookingTableBody');
    const noResults = document.getElementById('noResults');
    const sortCreatedBtn = document.getElementById('sortCreatedBtn');
    const sortDateBtn = document.getElementById('sortDateBtn');
    const sortTimeBtn = document.getElementById('sortTimeBtn');

    // Trạng thái sắp xếp: null (chưa sort), 'asc', 'desc'
    let currentSortType = 'created'; // Mặc định theo thời gian tạo
    let currentSortOrder = 'desc'; // Mặc định mới nhất trước

    // Khởi tạo: active button mặc định
    sortCreatedBtn.classList.add('active', 'desc');

    // Phân trang
    const itemsPerPage = 5; // Số dòng mỗi trang
    let currentPage = 1;

    // Tìm kiếm
    searchInput.addEventListener('input', function() {
        filterTable();
    });

    // Lọc theo trạng thái
    statusFilter.addEventListener('change', function() {
        filterTable();
    });

    function filterTable() {
        const searchTerm = searchInput.value.toLowerCase().trim();
        const statusValue = statusFilter.value;
        const rows = Array.from(tableBody.getElementsByTagName('tr'));
        let visibleRows = [];

        // Lọc các hàng theo tìm kiếm và trạng thái
        rows.forEach(row => {
            const cells = row.getElementsByTagName('td');
            const rowStatus = row.getAttribute('data-status');

            if (cells.length === 0) return; // Bỏ qua hàng trống

            // Lấy nội dung các cột để tìm kiếm
            const code = cells[0].textContent.toLowerCase();
            const date = cells[1].textContent.toLowerCase();
            const time = cells[2].textContent.toLowerCase();
            const orderTime = cells[3].textContent.toLowerCase();
            const table = cells[4].textContent.toLowerCase();

            const matchesSearch = !searchTerm ||
                code.includes(searchTerm) ||
                date.includes(searchTerm) ||
                time.includes(searchTerm) ||
                orderTime.includes(searchTerm) ||
                table.includes(searchTerm);

            const matchesStatus = statusValue === 'all' || rowStatus === statusValue;

            if (matchesSearch && matchesStatus) {
                row.classList.add('visible-row');
                row.style.display = '';
                visibleRows.push(row);
            } else {
                row.classList.remove('visible-row');
                row.style.display = 'none';
            }
        });

        // Cập nhật phân trang và hiển thị
        currentPage = 1; // Reset về trang đầu khi filter
        updatePagination(visibleRows.length);
        showCurrentPage(visibleRows);

        // Hiển thị thông báo nếu không có kết quả
        if (visibleRows.length === 0) {
            noResults.style.display = 'block';
            document.getElementById('pagination').style.display = 'none';
        } else {
            noResults.style.display = 'none';
            document.getElementById('pagination').style.display = 'flex';
        }
    }

    // Hiển thị trang hiện tại
    function showCurrentPage(rows) {
        const startIndex = (currentPage - 1) * itemsPerPage;
        const endIndex = startIndex + itemsPerPage;

        rows.forEach((row, index) => {
            if (index >= startIndex && index < endIndex) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }

    // Cập nhật phân trang
    function updatePagination(totalItems) {
        const totalPages = Math.ceil(totalItems / itemsPerPage);
        const pageNumbersDiv = document.getElementById('pageNumbers');
        const pageInfo = document.getElementById('pageInfo');

        // Xóa số trang cũ
        pageNumbersDiv.innerHTML = '';

        // Hiển thị số trang
        for (let i = 1; i <= totalPages; i++) {
            const button = document.createElement('button');
            button.textContent = i;
            button.onclick = () => goToPage(i);
            if (i === currentPage) {
                button.classList.add('active');
            }
            pageNumbersDiv.appendChild(button);
        }

        // Cập nhật thông tin trang
        if (totalItems > 0) {
            const startItem = (currentPage - 1) * itemsPerPage + 1;
            const endItem = Math.min(currentPage * itemsPerPage, totalItems);
            pageInfo.textContent = `${startItem}-${endItem} / ${totalItems}`;
        } else {
            pageInfo.textContent = '0 / 0';
        }

        // Enable/Disable nút điều hướng
        document.getElementById('firstPageBtn').disabled = currentPage === 1;
        document.getElementById('prevPageBtn').disabled = currentPage === 1;
        document.getElementById('nextPageBtn').disabled = currentPage === totalPages;
        document.getElementById('lastPageBtn').disabled = currentPage === totalPages;
    }

    // Điều hướng trang
    function goToPage(page) {
        const visibleRows = Array.from(tableBody.getElementsByTagName('tr')).filter(
            row => row.classList.contains('visible-row')
        );
        const totalPages = Math.ceil(visibleRows.length / itemsPerPage);

        if (page === -1) {
            // Trang cuối
            currentPage = totalPages;
        } else if (page === totalPages + 1) {
            // Trang đầu
            currentPage = 1;
        } else if (page >= 1 && page <= totalPages) {
            currentPage = page;
        }

        showCurrentPage(visibleRows);
        updatePagination(visibleRows.length);
    }

    function goToNextPage() {
        const visibleRows = Array.from(tableBody.getElementsByTagName('tr')).filter(
            row => row.classList.contains('visible-row')
        );
        const totalPages = Math.ceil(visibleRows.length / itemsPerPage);
        if (currentPage < totalPages) {
            goToPage(currentPage + 1);
        }
    }

    function goToPreviousPage() {
        if (currentPage > 1) {
            goToPage(currentPage - 1);
        }
    }

    // Sắp xếp theo thời gian tạo
    function sortByCreated() {
        handleSort('created', sortCreatedBtn);
    }

    // Sắp xếp theo ngày
    function sortByDate() {
        handleSort('date', sortDateBtn);
    }

    // Sắp xếp theo giờ
    function sortByTime() {
        handleSort('time', sortTimeBtn);
    }

    // Xử lý sắp xếp
    function handleSort(type, clickedBtn) {
        // Nếu click vào button khác, reset trạng thái button cũ và active button mới
        if (currentSortType !== type) {
            clearAllButtons();
            currentSortType = type;
            currentSortOrder = 'asc'; // Bắt đầu từ asc
        } else {
            // Nếu click vào cùng button, đảo chiều sắp xếp
            currentSortOrder = currentSortOrder === 'asc' ? 'desc' : 'asc';
        }

        // Apply sort
        applySort(type, clickedBtn);
    }

    // Clear tất cả sort buttons
    function clearAllButtons() {
        [sortCreatedBtn, sortDateBtn, sortTimeBtn].forEach(btn => {
            btn.classList.remove('active', 'asc', 'desc');
        });
    }

    // Apply sort
    function applySort(type, btn) {
        const rows = Array.from(tableBody.getElementsByTagName('tr'));

        rows.sort((a, b) => {
            let aValue, bValue;

            if (type === 'created') {
                const aCreated = a.getAttribute('data-created');
                const bCreated = b.getAttribute('data-created');
                aValue = aCreated ? new Date(aCreated) : new Date(0);
                bValue = bCreated ? new Date(bCreated) : new Date(0);
            } else if (type === 'date') {
                const aDate = a.getAttribute('data-date');
                const bDate = b.getAttribute('data-date');
                aValue = aDate ? new Date(aDate) : new Date(0);
                bValue = bDate ? new Date(bDate) : new Date(0);
            } else if (type === 'time') {
                const aTime = a.getAttribute('data-time');
                const bTime = b.getAttribute('data-time');
                aValue = convertTimeToMinutes(aTime);
                bValue = convertTimeToMinutes(bTime);
            }

            // Đảo chiều sắp xếp
            if (currentSortOrder === 'asc') {
                return aValue > bValue ? 1 : -1;
            } else {
                return aValue < bValue ? 1 : -1;
            }
        });

        // Xóa và thêm lại các hàng đã sắp xếp
        rows.forEach(row => tableBody.appendChild(row));

        // Update button state
        clearAllButtons();
        btn.classList.add('active', currentSortOrder);

        // Giữ nguyên filter sau khi sort - nhưng không reset phân trang
        const visibleRows = Array.from(tableBody.getElementsByTagName('tr')).filter(
            row => row.classList.contains('visible-row')
        );
        showCurrentPage(visibleRows);
    }

    function convertTimeToMinutes(time) {
        const parts = time.split(':');
        return parseInt(parts[0]) * 60 + parseInt(parts[1]);
    }

    // Auto hide success message after 5 seconds và khởi tạo sort mặc định
    window.addEventListener('DOMContentLoaded', function() {
        const successMsg = document.querySelector('.success-message');
        if (successMsg) {
            setTimeout(function() {
                successMsg.style.transition = 'opacity 0.5s';
                successMsg.style.opacity = '0';
                setTimeout(() => successMsg.remove(), 500);
            }, 5000);
        }

        // Khởi tạo sort mặc định: theo thời gian tạo DESC
        applySort('created', sortCreatedBtn);

        // Khởi tạo phân trang với tất cả các hàng
        const allRows = Array.from(tableBody.getElementsByTagName('tr')).filter(
            row => row.getElementsByTagName('td').length > 0
        );
        allRows.forEach(row => row.classList.add('visible-row'));
        updatePagination(allRows.length);
        showCurrentPage(allRows);
    });
</script>
</body>
</html>