<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
            /* THAY THẾ BẰNG URL ẢNH NỀN CỦA BẠN */
            background-image: linear-gradient(rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.6)), url('https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?q=80&w=2070&auto=format&fit=crop');
            background-position: center;
            background-size: cover;
            background-attachment: fixed;
            color: #f0f0f0;
            min-height: 100vh;
        }

        .container {
            width: 90%;
            max-width: 1000px; /* Tăng chiều rộng cho phù hợp với bảng */
            margin: 40px auto;
            background-color: rgba(20, 10, 10, 0.75); /* Frosted glass effect */
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
            background: #e74c3c; /* Accent color */
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
            border-radius: 20px; /* Pill shape */
            font-size: 0.9em;
            display: inline-block;
            min-width: 120px;
        }

        .pending {
            background-color: rgba(255, 193, 7, 0.2); /* Yellow */
            color: #ffc107;
            border: 1px solid #ffc107;
        }

        .confirmed {
            background-color: rgba(40, 167, 69, 0.2); /* Green */
            color: #28a745;
            border: 1px solid #28a745;
        }

        .done {
            background-color: rgba(108, 117, 125, 0.2); /* Gray */
            color: #6c757d;
            border: 1px solid #6c757d;
        }

        /* --- Action Buttons --- */
        .btn {
            background: #17a2b8; /* Cyan */
            color: white;
            border: none;
            padding: 9px 18px;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 500;
            transition: background-color 0.3s ease, transform 0.2s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .btn:hover {
            background: #117a8b;
            transform: translateY(-2px);
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

        /* --- Messages --- */
        .message {
            margin-bottom: 25px;
            padding: 15px;
            border-radius: 8px;
            font-weight: bold;
            text-align: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.2);
            animation: slideDown 0.5s ease;
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
        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

    </style>
</head>
<body>
<%
    com.fpt.restaurantbooking.models.Reservation reservation = (com.fpt.restaurantbooking.models.Reservation) request.getAttribute("reservation");
    java.util.List<com.fpt.restaurantbooking.models.Table> tables = (java.util.List<com.fpt.restaurantbooking.models.Table>) request.getAttribute("tables");
    java.util.List<com.fpt.restaurantbooking.models.OrderItem> orderItems = (java.util.List<com.fpt.restaurantbooking.models.OrderItem>) request.getAttribute("orderItems");
    java.time.format.DateTimeFormatter dateFormatter = java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy");
    java.time.format.DateTimeFormatter timeFormatter = java.time.format.DateTimeFormatter.ofPattern("HH:mm");
    java.util.Map<Integer, String> itemNames = (java.util.Map<Integer, String>) request.getAttribute("itemNames");
%>

<div class="container">
    <h2><i class="fas fa-receipt"></i> Chi tiết đơn DB<%= reservation != null && reservation.getReservationId() != null ? String.format("%03d", reservation.getReservationId()) : "---" %></h2>

    <!-- Success Message -->
    <%
        String success = request.getParameter("success");
        String updated = request.getParameter("updated");
        if ("true".equals(success)) {
    %>
    <div class="message success-message">
        <i class="fas fa-check-circle"></i> Đặt đơn bàn thành công! Cảm ơn bạn đã đặt bàn tại nhà hàng.
    </div>
    <%
    } else if ("true".equals(updated)) {
    %>
    <div class="message success-message">
        <i class="fas fa-check-circle"></i> Cập nhật đơn bàn thành công!
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
                <option value="pending">Đang chờ</option>
                <option value="confirmed">Đã xác nhận</option>
                <option value="done">Hoàn tất</option>
            </select>
        </div>

        <div class="sort-buttons">
            <button class="sort-btn active" id="sortDateBtn" onclick="sortByDate()">
                <i class="fas fa-calendar-alt"></i> Sắp xếp theo ngày
            </button>
            <button class="sort-btn" id="sortTimeBtn" onclick="sortByTime()">
                <i class="fas fa-clock"></i> Sắp xếp theo giờ
            </button>
        </div>
    </div>

    <div style="margin-bottom:20px;">
        <table style="width:100%;">
            <tbody>
            <tr>
                <td><strong>Mã đơn:</strong></td>
                <td>DB<%= reservation != null && reservation.getReservationId() != null ? String.format("%03d", reservation.getReservationId()) : "---" %></td>
            </tr>
            <tr>
                <td><strong>Ngày - Giờ:</strong></td>
                <td>
                    <%= reservation != null && reservation.getReservationDate() != null ? reservation.getReservationDate().format(dateFormatter) : "N/A" %>
                    -
                    <%= reservation != null && reservation.getReservationTime() != null ? reservation.getReservationTime().format(timeFormatter) : "N/A" %>
                </td>
            </tr>
            <tr>
                <td><strong>Số người:</strong></td>
                <td><%= reservation != null && reservation.getGuestCount() != null ? reservation.getGuestCount() : 0 %></td>
            </tr>
            <tr>
                <td><strong>Trạng thái:</strong></td>
                <td><%= reservation != null ? reservation.getStatus() : "N/A" %></td>
            </tr>
            <tr>
                <td><strong>Yêu cầu đặc biệt:</strong></td>
                <td><%= reservation != null && reservation.getSpecialRequests() != null ? reservation.getSpecialRequests() : "-" %></td>
            </tr>
            <tr>
                <td><strong>Bàn:</strong></td>
                <td>
                    <%
                        if (tables != null && !tables.isEmpty()) {
                            for (int i = 0; i < tables.size(); i++) {
                                com.fpt.restaurantbooking.models.Table t = tables.get(i);
                    %>
                    <%= t.getTableName() != null ? t.getTableName() : ("Bàn " + t.getTableId()) %><%= i < tables.size() - 1 ? ", " : "" %>
                    <%
                        }
                    } else {
                    %>
                    -
                    <%
                        }
                    %>
                </td>
            </tr>
            </tbody>
        </table>
    </div>

    <h3 style="margin: 10px 0 15px 0;">Món đã gọi</h3>
    <table id="orderItemsTable">
        <thead>
        <tr>
            <th>#</th>
            <th>Món</th>
            <th>Số lượng</th>
            <th>Đơn giá</th>
            <th>Thành tiền</th>
            <th>Ghi chú</th>
        </tr>
        </thead>
        <tbody>
        <%
            java.math.BigDecimal total = java.math.BigDecimal.ZERO;
            if (orderItems != null && !orderItems.isEmpty()) {
                for (int i = 0; i < orderItems.size(); i++) {
                    com.fpt.restaurantbooking.models.OrderItem it = orderItems.get(i);
                    java.math.BigDecimal line = it.getTotal();
                    if (line != null) total = total.add(line);
        %>
        <tr>
            <td><%= i + 1 %></td>
            <td><%= (itemNames != null && it.getItemId() != null) ? itemNames.getOrDefault(it.getItemId(), "Món #" + it.getItemId()) : "-" %></td>
            <td><%= it.getQuantity() %></td>
            <td><%= it.getUnitPrice() != null ? it.getUnitPrice() : java.math.BigDecimal.ZERO %></td>
            <td><%= line != null ? line : java.math.BigDecimal.ZERO %></td>
            <td><%= it.getSpecialInstructions() != null ? it.getSpecialInstructions() : "" %></td>
        </tr>
        <%
            }
        } else {
        %>
        <tr>
            <td colspan="6" class="no-results">Chưa có món nào.</td>
        </tr>
        <%
            }
        %>
        </tbody>
        <tfoot>
        <tr>
            <td colspan="4" style="text-align:right; font-weight: 600;">Tổng cộng</td>
            <td colspan="2" style="text-align:left; font-weight: 600;"> <%= total %></td>
        </tr>
        </tfoot>
    </table>

    <div id="noResults" class="no-results" style="display: none;">
        <i class="fas fa-search" style="font-size: 3em; margin-bottom: 15px; opacity: 0.3;"></i>
        <p>Không tìm thấy kết quả phù hợp</p>
    </div>

    <div class="back-link-container">
        <a href="orderHistory" class="btn" style="background-color: #6c757d;"><i class="fas fa-arrow-left"></i> Lịch sử đặt bàn</a>
        <a href="home" class="btn" style="margin-left: 10px; background-color: #6c757d;"><i class="fas fa-home"></i> Về trang chủ</a>
        <a href="editReservation?id=<%= reservation != null ? reservation.getReservationId() : 0 %>" class="btn" style="margin-left: 10px; background-color: #e67e22;">
            <i class="fas fa-edit"></i> Chỉnh sửa đơn hàng
        </a>
    </div>
</div>
<script>
    // Auto hide success message after 5 seconds
    window.addEventListener('DOMContentLoaded', function() {
        const successMsg = document.querySelector('.success-message');
        if (successMsg) {
            setTimeout(function() {
                successMsg.style.transition = 'opacity 0.5s';
                successMsg.style.opacity = '0';
                setTimeout(() => successMsg.remove(), 500);
            }, 5000);
        }
    });
</script>
</body>
</html>