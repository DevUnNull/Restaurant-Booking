<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.HashMap, java.util.Map, java.text.DecimalFormat, java.math.BigDecimal" %>
<%@ page import="com.fpt.restaurantbooking.models.OrderItem" %>
<%@ page import="com.fpt.restaurantbooking.models.Reservation" %>
<%@ page import="com.fpt.restaurantbooking.models.MenuItem" %>
<%@ page import="com.fpt.restaurantbooking.models.Table" %>
<%@ page import="com.fpt.restaurantbooking.repositories.impl.MenuItemDAO" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Giỏ hàng & Thanh toán</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/theme.css">

    <style>
        /* --- General Reset & Body Styling --- */
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body, html {
            font-family: 'Montserrat', sans-serif;
            background-image: linear-gradient(var(--bg-overlay), var(--bg-overlay)), url('https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?q=80&w=2070&auto=format&fit=crop');
            background-position: center;
            background-size: cover;
            background-attachment: fixed;
            color: var(--text-primary);
            min-height: 100vh;
            transition: background 0.3s ease, color 0.3s ease;
        }

        .container {
            width: 90%;
            max-width: 900px;
            margin: 40px auto;
            background-color: var(--box-bg);
            backdrop-filter: blur(8px);
            padding: 30px;
            border-radius: 15px;
            box-shadow: var(--shadow);
            border: 1px solid var(--input-border);
            transition: all 0.3s ease;
        }

        h2 {
            text-align: center;
            margin-bottom: 30px;
            color: var(--text-primary);
            font-size: 2.5em;
            font-weight: 700;
            letter-spacing: 2px;
            text-transform: uppercase;
            text-shadow: 2px 2px 8px rgba(0,0,0,0.5);
            transition: color 0.3s ease;
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

        /* --- Table Styling --- */
        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin-bottom: 30px;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: var(--shadow);
            background-color: var(--table-bg);
            border: 1px solid var(--input-border);
            transition: all 0.3s ease;
        }
        table th, table td {
            border-bottom: 1px solid var(--table-border);
            padding: 18px 20px;
            text-align: left;
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
        .item-row td {
            color: #f0f0f0;
        }
        .price-col {
            text-align: right;
            font-weight: bold;
            color: #ffc107;
        }
        .note-text {
            font-size: 0.9em;
            color: rgba(255, 255, 255, 0.7);
            font-style: italic;
            margin-top: 5px;
        }

        /* --- Quantity Control --- */
        .quantity-controls {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            margin-top: 8px;
        }
        .qty-btn {
            background: #667eea;
            color: white;
            border: none;
            width: 32px;
            height: 32px;
            border-radius: 50%;
            cursor: pointer;
            font-size: 1em;
            font-weight: bold;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s;
        }
        .qty-btn:hover {
            background: #5568d3;
            transform: scale(1.1);
        }
        .qty-input {
            width: 50px;
            text-align: center;
            padding: 5px;
            border: 2px solid rgba(255, 255, 255, 0.3);
            border-radius: 5px;
            background: rgba(255, 255, 255, 0.1);
            color: #fff;
            font-size: 1em;
            font-weight: bold;
        }
        .qty-input:focus {
            outline: none;
            border-color: #667eea;
        }
        .remove-btn {
            background: #e74c3c;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 0.85em;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        .remove-btn:hover {
            background: #c0392b;
            transform: translateY(-2px);
        }
        .update-btn {
            background: #28a745;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 0.85em;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            gap: 5px;
            margin-left: 5px;
        }
        .update-btn:hover {
            background: #218838;
            transform: translateY(-2px);
        }
        .item-actions {
            margin-top: 8px;
            display: flex;
            justify-content: center;
            gap: 8px;
        }

        /* --- Total Summary --- */
        .total-summary {
            background-color: rgba(0, 0, 0, 0.5);
            border-radius: 10px;
            padding: 25px;
            margin-top: 20px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            box-shadow: 0 2px 15px rgba(0,0,0,0.3);
        }
        .total-summary p {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin: 10px 0;
            font-size: 1.1em;
            color: rgba(255,255,255,0.9);
        }
        .total-summary p strong {
            color: #ffc107;
            font-size: 1.2em;
        }
        .final-total {
            border-top: 2px solid rgba(255, 255, 255, 0.2);
            padding-top: 18px;
            margin-top: 18px;
            font-size: 1.6em !important;
            font-weight: bold;
            color: #e74c3c !important;
        }

        /* --- Discount Code Section --- */
        .discount-section {
            margin: 30px 0;
            padding: 25px;
            background: rgba(102, 126, 234, 0.1);
            border-radius: 10px;
            border: 2px solid rgba(102, 126, 234, 0.3);
        }
        .discount-header {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 15px;
        }
        .discount-header i {
            font-size: 1.5em;
            color: #667eea;
        }
        .discount-header h3 {
            color: #fff;
            font-size: 1.3em;
            margin: 0;
        }
        .discount-input-group {
            display: flex;
            gap: 10px;
            margin-bottom: 10px;
        }
        .discount-input {
            flex: 1;
            padding: 12px 15px;
            border: 2px solid rgba(255, 255, 255, 0.2);
            border-radius: 8px;
            background: rgba(255, 255, 255, 0.1);
            color: #fff;
            font-size: 1em;
            transition: all 0.3s;
        }
        .discount-input:focus {
            outline: none;
            border-color: #667eea;
            background: rgba(255, 255, 255, 0.15);
        }
        .discount-input::placeholder {
            color: rgba(255, 255, 255, 0.5);
        }
        .btn-apply {
            padding: 12px 25px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .btn-apply:hover {
            background: #5568d3;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }
        .btn-apply:disabled {
            background: #6c757d;
            cursor: not-allowed;
            transform: none;
        }
        .discount-info {
            margin-top: 12px;
            padding: 10px;
            border-radius: 6px;
            font-size: 0.95em;
            display: none;
        }
        .discount-success {
            background: rgba(40, 167, 69, 0.2);
            color: #4ade80;
            border: 1px solid rgba(40, 167, 69, 0.3);
        }
        .discount-error {
            background: rgba(220, 53, 69, 0.2);
            color: #f87171;
            border: 1px solid rgba(220, 53, 69, 0.3);
        }
        .applied-discount {
            color: #4ade80;
            font-weight: 600;
        }

        /* --- Payment Method --- */
        .payment-method {
            margin: 30px 0;
            padding: 20px;
            background: rgba(0, 0, 0, 0.3);
            border-radius: 10px;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }
        .payment-method p {
            font-weight: 600;
            margin-bottom: 15px;
            font-size: 1.2em;
            color: #fff;
        }
        .payment-method label {
            display: block;
            margin: 12px 0;
            font-weight: 500;
            cursor: pointer;
            color: rgba(255,255,255,0.9);
            padding: 10px;
            border-radius: 5px;
            transition: background 0.3s;
        }
        .payment-method label:hover {
            background: rgba(255, 255, 255, 0.1);
        }
        .payment-method input[type="radio"] {
            transform: scale(1.2);
            accent-color: #e74c3c;
            cursor: pointer;
            margin-right: 10px;
        }

        /* Payment Info Box */
        .payment-info {
            margin-top: 15px;
            padding: 15px;
            border-radius: 8px;
            border-left: 4px solid #667eea;
            background: rgba(102, 126, 234, 0.1);
            animation: slideIn 0.3s ease;
            display: none;
        }
        .payment-info.show {
            display: block;
        }
        .payment-info i {
            color: #667eea;
            margin-right: 10px;
        }
        .payment-info p {
            margin: 0;
            color: rgba(255, 255, 255, 0.9);
            font-size: 0.95em;
            line-height: 1.6;
        }
        .payment-info.cash {
            border-left-color: #ffc107;
            background: rgba(255, 193, 7, 0.1);
        }
        .payment-info.cash i {
            color: #ffc107;
        }
        .payment-info.prepaid {
            border-left-color: #28a745;
            background: rgba(40, 167, 69, 0.1);
        }
        .payment-info.prepaid i {
            color: #28a745;
        }
        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* --- Action Buttons --- */
        .actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 40px;
            flex-wrap: wrap;
            gap: 15px;
        }
        .actions .btn {
            padding: 14px 28px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 1.05em;
            font-weight: 600;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-family: 'Montserrat', sans-serif;
        }
        .actions .btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 15px rgba(0,0,0,0.2);
        }
        .back-btn {
            background: #6c757d;
            color: white;
        }
        .back-btn:hover {
            background: #5a6268;
        }
        .confirm-btn {
            background: #e74c3c;
            color: white;
        }
        .confirm-btn:hover {
            background: #c0392b;
        }

        .empty-cart {
            text-align: center;
            padding: 40px;
            color: rgba(255, 255, 255, 0.7);
        }
        .empty-cart i {
            font-size: 4em;
            margin-bottom: 20px;
            color: rgba(255, 255, 255, 0.5);
        }

        /* --- Combo Item Styling --- */
        .combo-item-row {
            background: linear-gradient(90deg, rgba(255, 193, 7, 0.15) 0%, rgba(255, 193, 7, 0.05) 100%);
            border-left: 4px solid #ffc107 !important;
        }
        .combo-badge {
            display: inline-block;
            background: #ffc107;
            color: #000;
            padding: 3px 10px;
            border-radius: 12px;
            font-size: 0.75em;
            font-weight: 700;
            margin-left: 8px;
            letter-spacing: 0.5px;
        }
        .combo-locked-notice {
            font-size: 0.85em;
            color: #ffc107;
            font-style: italic;
            margin-top: 5px;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        .combo-locked-notice i {
            font-size: 1em;
        }

    </style>
</head>
<body>
<!-- Theme Toggle Button -->
<button class="theme-toggle" id="themeToggle" onclick="toggleTheme()">
    <i class="fas fa-moon" id="themeIcon"></i>
    <span id="themeText">Chế độ tối</span>
</button>

<%
    // Lấy dữ liệu từ request attributes
    List<OrderItem> orderItems = (List<OrderItem>) request.getAttribute("currentItems");
    List<Table> selectedTables = (List<Table>) request.getAttribute("selectedTables");
    Reservation reservation = (Reservation) request.getAttribute("reservation");
    String errorMessage = (String) request.getAttribute("errorMessage");
    String successMessage = (String) request.getAttribute("successMessage");
    List<MenuItem> serviceComboItems = (List<MenuItem>) request.getAttribute("serviceComboItems");
    Integer selectedServiceId = (Integer) request.getAttribute("selectedServiceId");

    // Khởi tạo formatter
    DecimalFormat formatter = new DecimalFormat("###,###,### VNĐ");

    // Tạo set để kiểm tra nhanh món nào là combo
    java.util.Set<Integer> comboItemIds = new java.util.HashSet<>();
    if (serviceComboItems != null) {
        for (MenuItem comboItem : serviceComboItems) {
            comboItemIds.add(comboItem.getItemId());
        }
    }

    // Tính tổng tiền
    BigDecimal totalAmount = BigDecimal.ZERO;
    if (reservation != null && reservation.getTotalAmount() != null) {
        totalAmount = reservation.getTotalAmount();
    }

    boolean hasItems = (orderItems != null && !orderItems.isEmpty());
    boolean hasTables = (selectedTables != null && !selectedTables.isEmpty());

    // Lấy thông tin menu items để hiển thị tên món
    Map<Integer, String> menuItemNames = new HashMap<>();
    if (hasItems) {
        MenuItemDAO menuItemDAO = new MenuItemDAO();
        for (OrderItem item : orderItems) {
            if (!menuItemNames.containsKey(item.getItemId())) {
                MenuItem menuItem = menuItemDAO.getMenuItemById(item.getItemId());
                if (menuItem != null) {
                    menuItemNames.put(item.getItemId(), menuItem.getItemName());
                } else {
                    menuItemNames.put(item.getItemId(), "Món #" + item.getItemId());
                }
            }
        }
    }
%>

<div class="container">
    <h2><i class="fas fa-shopping-cart"></i> Giỏ hàng & Thanh toán</h2>

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

    <!-- Success Message -->
    <%
        if (successMessage != null) {
    %>
    <div class="message success-message">
        <i class="fas fa-check-circle"></i> <%= successMessage %>
    </div>
    <%
        }
    %>

    <%
        if (!hasTables) {
    %>
    <!-- No Tables Selected -->
    <div class="empty-cart">
        <i class="fas fa-table"></i>
        <h3>Bạn chưa chọn bàn nào</h3>
        <p>Vui lòng chọn bàn để tiếp tục đặt bàn</p>
        <a href="tableServlet" class="btn back-btn" style="margin-top: 20px;">
            <i class="fas fa-table"></i> Quay lại chọn bàn
        </a>
    </div>
    <%
    } else {
    %>

    <!-- Selected Tables Section -->
    <%
        if (hasTables) {
    %>
    <div style="background-color: rgba(0, 0, 0, 0.5); border-radius: 10px; padding: 20px; margin-bottom: 30px; border: 1px solid rgba(255, 255, 255, 0.1);">
        <h3 style="color: #fff; font-size: 1.5em; margin-bottom: 15px; display: flex; align-items: center; gap: 10px;">
            <i class="fas fa-table"></i> Bàn đã chọn
        </h3>
        <table style="width: 100%; border-collapse: separate; border-spacing: 0; border-radius: 10px; overflow: hidden; background-color: rgba(255, 255, 255, 0.08);">
            <thead>
            <tr style="background: #667eea;">
                <th style="padding: 12px; color: white; font-weight: 600; text-align: left;">Tên bàn</th>
                <th style="padding: 12px; color: white; font-weight: 600; text-align: center;">Sức chứa</th>
                <th style="padding: 12px; color: white; font-weight: 600; text-align: center;">Tầng</th>
                <th style="padding: 12px; color: white; font-weight: 600; text-align: center;">Loại bàn</th>
                <th style="padding: 12px; color: white; font-weight: 600; text-align: center;">Thao tác</th>
            </tr>
            </thead>
            <tbody>
            <%
                for (int i = 0; i < selectedTables.size(); i++) {
                    Table table = selectedTables.get(i);
            %>
            <tr class="table-row" data-table-id="<%= table.getTableId() %>" style="border-bottom: 1px solid rgba(255, 255, 255, 0.15);">
                <td style="padding: 12px; color: #f0f0f0;">
                    <strong><%= table.getTableName() != null ? table.getTableName() : "Bàn " + table.getTableId() %></strong>
                </td>
                <td style="padding: 12px; color: #f0f0f0; text-align: center;">
                    <i class="fas fa-users"></i> <%= table.getCapacity() %> người
                </td>
                <td style="padding: 12px; color: #f0f0f0; text-align: center;">
                    <i class="fas fa-layer-group"></i> Tầng <%= table.getFloor() %>
                </td>
                <td style="padding: 12px; color: #f0f0f0; text-align: center;">
                    <%= table.getTableType() != null ? table.getTableType() : "Standard" %>
                </td>
                <td style="padding: 12px; color: #f0f0f0; text-align: center;">
                    <button class="remove-btn" onclick="removeTable(<%= table.getTableId() %>)" title="Xóa bàn này">
                        <i class="fas fa-trash"></i> Xóa
                    </button>
                </td>
            </tr>
            <%
                }
            %>
            </tbody>
        </table>

        <!-- Special Request Information -->
        <%
            if (reservation != null && reservation.getSpecialRequests() != null && !reservation.getSpecialRequests().trim().isEmpty()) {
        %>
        <div style="margin-top: 20px; padding: 15px; background: rgba(102, 126, 234, 0.2); border-radius: 8px; border-left: 4px solid #667eea;">
            <h4 style="color: #fff; margin-bottom: 10px; font-size: 1em; display: flex; align-items: center; gap: 8px;">
                <i class="fas fa-star"></i> Yêu cầu đặc biệt
            </h4>
            <p style="color: rgba(255, 255, 255, 0.9); margin: 0; font-style: italic; font-size: 0.95em;">
                <%= reservation.getSpecialRequests() %>
            </p>
        </div>
        <%
            }
        %>
    </div>
    <%
        }
    %>

    <!-- Order Items Table -->
    <table>
        <thead>
        <tr>
            <th>STT</th>
            <th>Tên món</th>
            <th>Số lượng</th>
            <th class="price-col">Đơn giá</th>
            <th class="price-col">Thành tiền</th>
        </tr>
        </thead>
        <tbody>
        <%
            if (hasItems) {
                int displayIndex = 1;  // STT hiển thị (1, 2, 3...)
                int arrayIndex = 0;     // Index thực trong list (0, 1, 2...)
                for (OrderItem item : orderItems) {
                    BigDecimal itemTotal = item.getUnitPrice().multiply(new BigDecimal(item.getQuantity()));
                    boolean isComboItem = comboItemIds.contains(item.getItemId());
        %>
        <tr class="item-row <%= isComboItem ? "combo-item-row" : "" %>" data-item-index="<%= arrayIndex %>">
            <td style="text-align: center;"><%= displayIndex++ %></td>
            <td>
                <div>
                    <strong><%= menuItemNames.get(item.getItemId()) != null ? menuItemNames.get(item.getItemId()) : "Món #" + item.getItemId() %></strong>
                    <% if (isComboItem) { %>
                    <span class="combo-badge">🌟 COMBO</span>
                    <% } %>
                </div>
                <%
                    if (item.getSpecialInstructions() != null && !item.getSpecialInstructions().trim().isEmpty()) {
                %>
                <div class="note-text">
                    <i class="fas fa-sticky-note"></i> <%= item.getSpecialInstructions() %>
                </div>
                <%
                    }
                    if (isComboItem) {
                %>
                <div class="combo-locked-notice">
                    <i class="fas fa-info-circle"></i> Món trong combo dịch vụ (có thể thay đổi số lượng)
                </div>
                <%
                    }
                %>
            </td>
            <td style="text-align: center;">
                <!-- ✅ TẤT CẢ MÓN (COMBO + THƯỜNG) ĐỀU CHO PHÉP CHỈNH SỬA -->
                <div class="quantity-controls">
                    <button class="qty-btn" onclick="decreaseQty(<%= arrayIndex %>)">-</button>
                    <input type="number" class="qty-input" id="qty-<%= arrayIndex %>" value="<%= item.getQuantity() %>" min="1" max="100">
                    <button class="qty-btn" onclick="increaseQty(<%= arrayIndex %>)">+</button>
                </div>
                <div class="item-actions">
                    <button class="update-btn" onclick="updateItemQty(<%= arrayIndex %>)">
                        <i class="fas fa-sync-alt"></i> Cập nhật
                    </button>
                    <button class="remove-btn" onclick="removeItem(<%= arrayIndex %>)">
                        <i class="fas fa-trash"></i> Xóa
                    </button>
                </div>
            </td>
            <td class="price-col"><%= formatter.format(item.getUnitPrice()) %></td>
            <td class="price-col" id="total-<%= arrayIndex %>"><%= formatter.format(itemTotal) %></td>
        </tr>
        <%
                arrayIndex++;  // Tăng index thực
            }
        } else {
        %>
        <tr>
            <td colspan="5" style="text-align: center; padding: 40px; color: rgba(255, 255, 255, 0.6);">
                <i class="fas fa-shopping-cart" style="font-size: 3em; margin-bottom: 15px; color: rgba(255, 255, 255, 0.3);"></i>
                <div style="font-size: 1.2em; font-weight: 500;">Chưa có món ăn nào</div>
                <div style="font-size: 0.9em; margin-top: 5px;">Bạn có thể đặt bàn mà không cần chọn món</div>
                <a href="orderItems" class="btn update-btn" style="margin-top: 15px; text-decoration: none; display: inline-flex;" id="addItemsLink">
                    <i class="fas fa-utensils"></i> Thêm món ăn
                </a>
            </td>
        </tr>
        <%
            }
        %>
        </tbody>
    </table>

    <!-- Total Summary -->
    <div class="total-summary">
        <p>Tổng tiền món ăn: <strong id="subtotal"><%= formatter.format(totalAmount) %></strong></p>
        <p id="discount-line" style="display: none;">Giảm giá: <strong class="applied-discount" id="discount-amount">0 VNĐ</strong></p>
        <p class="final-total">Tổng tiền cần thanh toán: <strong id="final-total"><%= formatter.format(totalAmount) %></strong></p>
        <input type="hidden" id="subtotalValue" value="<%= totalAmount.doubleValue() %>">
    </div>

    <!-- Payment Form -->
    <form method="post" action="checkout" id="checkoutForm">
        <input type="hidden" name="action" value="confirm">

        <!-- Discount Code Section -->
        <div class="discount-section">
            <div class="discount-header">
                <i class="fas fa-tag"></i>
                <h3>Mã giảm giá</h3>
            </div>
            <div class="discount-input-group">
                <input type="text"
                       class="discount-input"
                       id="discountCode"
                       name="discountCode"
                       placeholder="Nhập mã giảm giá (ví dụ: SAVE10, SUMMER20)">
                <button type="button" class="btn-apply" id="applyDiscountBtn">
                    <i class="fas fa-check"></i> Áp dụng
                </button>
            </div>
            <div id="discountInfo" class="discount-info"></div>
            <input type="hidden" name="discountAmount" id="discountAmount" value="0">
            <input type="hidden" name="discountCodeValue" id="discountCodeValue" value="">
        </div>

        <!-- Payment Method Selection -->
        <div class="payment-method">
            <p><i class="fas fa-credit-card"></i> Chọn hình thức thanh toán:</p>
            <label>
                <input type="radio" name="paymentMethod" value="CASH" checked>
                <i class="fas fa-money-bill-wave"></i> Thanh toán khi nhận (COD)
            </label>
            <label>
                <input type="radio" name="paymentMethod" value="CREDIT_CARD">
                <i class="fas fa-credit-card"></i> Thẻ tín dụng
            </label>
            <label>
                <input type="radio" name="paymentMethod" value="E_WALLET">
                <i class="fas fa-wallet"></i> Ví điện tử (Momo, ZaloPay)
            </label>

            <!-- Payment Info -->
            <div id="paymentInfoCash" class="payment-info cash show">
                <p>
                    <i class="fas fa-info-circle"></i>
                    <strong>Thanh toán khi nhận:</strong><br>
                    Món ăn sẽ được nấu khi bạn đến nhà hàng. Vui lòng đến đúng giờ đã đặt.
                </p>
            </div>
            <div id="paymentInfoPrepaid" class="payment-info prepaid" style="display: none;">
                <p>
                    <i class="fas fa-check-circle"></i>
                    <strong>Thanh toán trước:</strong><br>
                    Món ăn sẽ được chuẩn bị sẵn trước khi bạn đến. Đến nhà hàng sẽ có món ăn sẵn sàng ngay!
                </p>
            </div>
        </div>

        <!-- Action Buttons -->
        <div class="actions">
            <a href="orderItems" class="btn back-btn">
                <i class="fas fa-arrow-left"></i> Quay lại chọn món
            </a>
            <button type="submit" class="btn confirm-btn">
                <i class="fas fa-check-circle"></i> Xác nhận & Thanh toán
            </button>
        </div>
    </form>
    <%
        }
    %>
</div>

<script src="${pageContext.request.contextPath}/js/theme-manager.js"></script>
<script>
    // Configuration - Mã giảm giá và phần trăm giảm
    const discountCodes = {
        'SAVE10': 10,
        'SAVE20': 20,
        'SUMMER20': 20,
        'WELCOME15': 15,
        'VIP30': 30,
        'FLASH25': 25
    };

    let appliedDiscount = 0;
    let discountCodeUsed = '';

    // Tính tổng ban đầu - Lấy từ hidden input để tránh JSP lỗi
    const originalTotal = parseFloat(document.getElementById('subtotalValue').value) || 0;

    // Format tiền
    function formatMoney(amount) {
        return new Intl.NumberFormat('vi-VN', {
            style: 'currency',
            currency: 'VND'
        }).format(amount);
    }

    // Cập nhật tổng tiền
    function updateTotal() {
        const discountAmount = (originalTotal * appliedDiscount / 100);
        const finalTotal = originalTotal - discountAmount;

        // Cập nhật UI
        document.getElementById('discount-amount').textContent = formatMoney(discountAmount);
        document.getElementById('final-total').textContent = formatMoney(finalTotal);
        document.getElementById('discountAmount').value = discountAmount;
        document.getElementById('discountCodeValue').value = discountCodeUsed;

        // Hiển thị/ẩn dòng giảm giá
        const discountLine = document.getElementById('discount-line');
        if (appliedDiscount > 0) {
            discountLine.style.display = 'flex';
        } else {
            discountLine.style.display = 'none';
        }
    }

    // Xử lý nút Áp dụng mã giảm giá
    document.getElementById('applyDiscountBtn').addEventListener('click', function() {
        const code = document.getElementById('discountCode').value.trim().toUpperCase();
        const infoDiv = document.getElementById('discountInfo');
        const applyBtn = this;

        // Kiểm tra mã có tồn tại không
        if (!code) {
            infoDiv.className = 'discount-info discount-error';
            infoDiv.style.display = 'block';
            infoDiv.innerHTML = '<i class="fas fa-exclamation-circle"></i> Vui lòng nhập mã giảm giá';
            return;
        }

        if (discountCodes[code]) {
            // Mã hợp lệ
            appliedDiscount = discountCodes[code];
            discountCodeUsed = code;

            infoDiv.className = 'discount-info discount-success';
            infoDiv.style.display = 'block';
            infoDiv.innerHTML = `<i class="fas fa-check-circle"></i> Áp dụng thành công mã giảm giá <strong>${code}</strong> - Giảm ${appliedDiscount}%`;

            document.getElementById('discountCode').disabled = true;
            applyBtn.disabled = true;

            updateTotal();
        } else {
            // Mã không hợp lệ
            infoDiv.className = 'discount-info discount-error';
            infoDiv.style.display = 'block';
            infoDiv.innerHTML = '<i class="fas fa-times-circle"></i> Mã giảm giá không hợp lệ. Vui lòng thử lại';
        }
    });

    // Cho phép nhấn Enter để áp dụng mã - Ngăn chặn submit form
    document.getElementById('discountCode').addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            e.preventDefault(); // Ngăn chặn submit form
            document.getElementById('applyDiscountBtn').click();
        }
    });

    // Ngăn chặn form submit khi nhấn Enter trong ô discount code
    document.getElementById('checkoutForm').addEventListener('keypress', function(e) {
        if (e.key === 'Enter' && e.target.id === 'discountCode') {
            e.preventDefault();
        }
    });

    // ===== XỬ LÝ THAY ĐỔI PAYMENT METHOD =====
    const paymentMethods = document.querySelectorAll('input[name="paymentMethod"]');
    const paymentInfoCash = document.getElementById('paymentInfoCash');
    const paymentInfoPrepaid = document.getElementById('paymentInfoPrepaid');

    paymentMethods.forEach(function(radio) {
        radio.addEventListener('change', function() {
            if (this.value === 'CASH') {
                // Thanh toán khi nhận (COD)
                paymentInfoCash.style.display = 'block';
                paymentInfoPrepaid.style.display = 'none';
            } else if (this.value === 'CREDIT_CARD' || this.value === 'E_WALLET') {
                // Thanh toán trước
                paymentInfoCash.style.display = 'none';
                paymentInfoPrepaid.style.display = 'block';
            }
        });
    });

    // ===== CÁC HÀM QUẢN LÝ GIỎ HÀNG =====

    // Tăng số lượng
    function increaseQty(itemIndex) {
        const input = document.getElementById('qty-' + itemIndex);
        let currentQty = parseInt(input.value) || 1;
        input.value = currentQty + 1;
    }

    // Giảm số lượng
    function decreaseQty(itemIndex) {
        const input = document.getElementById('qty-' + itemIndex);
        let currentQty = parseInt(input.value) || 1;
        if (currentQty > 1) {
            input.value = currentQty - 1;
        }
    }

    // Cập nhật số lượng món ăn
    function updateItemQty(itemIndex) {
        const quantity = parseInt(document.getElementById('qty-' + itemIndex).value);

        if (isNaN(quantity) || quantity < 1) {
            alert('Số lượng phải lớn hơn 0');
            return;
        }

        // Gọi AJAX để cập nhật
        fetch('orderItems', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'action=updateQty&itemIndex=' + itemIndex + '&quantity=' + quantity
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Reload trang để cập nhật tổng tiền
                    location.reload();
                } else {
                    alert('Lỗi khi cập nhật: ' + (data.message || 'Vui lòng thử lại'));
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Có lỗi xảy ra khi cập nhật');
            });
    }

    // Xóa món ăn
    function removeItem(itemIndex) {
        if (!confirm('Bạn có chắc muốn xóa món ăn này khỏi giỏ hàng?')) {
            return;
        }

        // Gọi AJAX để xóa
        fetch('orderItems', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'action=remove&itemIndex=' + itemIndex
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Reload trang để cập nhật
                    location.reload();
                } else {
                    alert('Lỗi khi xóa: ' + (data.message || 'Vui lòng thử lại'));
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Có lỗi xảy ra khi xóa');
            });
    }

    // Cập nhật thành tiền của món (tạm thời, chưa tính lại tổng)
    function updateItemTotal(orderItemId) {
        const row = document.querySelector('[data-item-id="' + orderItemId + '"]');
        if (!row) return;

        const qtyInput = document.getElementById('qty-' + orderItemId);
        const priceCell = row.querySelector('.price-col');
        const totalCell = document.getElementById('total-' + orderItemId);

        if (priceCell && totalCell && qtyInput) {
            // Lấy giá từ cell (cần parse giá tiền)
            const priceText = priceCell.textContent.trim();
            const unitPrice = parsePrice(priceText);
            const quantity = parseInt(qtyInput.value) || 1;
            const total = unitPrice * quantity;

            totalCell.textContent = formatMoney(total);
        }
    }

    // Parse giá tiền từ chuỗi
    function parsePrice(priceText) {
        // Loại bỏ "VNĐ" và các ký tự không phải số
        const cleaned = priceText.replace(/[^\d]/g, '');
        return parseFloat(cleaned) || 0;
    }

    // ===== XÓA BÀN =====
    function removeTable(tableId) {
        const tableName = document.querySelector('[data-table-id="' + tableId + '"] td strong').textContent;

        if (!confirm('Bạn có chắc muốn xóa bàn ' + tableName + ' khỏi đơn đặt bàn?')) {
            return;
        }

        // Gọi AJAX để xóa bàn
        fetch('removeTable', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'tableId=' + tableId
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Xóa dòng khỏi bảng
                    const row = document.querySelector('[data-table-id="' + tableId + '"]');
                    if (row) {
                        row.remove();
                    }
                    alert('Xóa bàn thành công!');
                    // Reload trang để cập nhật
                    location.reload();
                } else {
                    alert('Lỗi khi xóa bàn: ' + (data.message || 'Vui lòng thử lại'));
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Có lỗi xảy ra khi xóa bàn');
            });
    }

    // Hiển thị alert nếu có message
    window.addEventListener('DOMContentLoaded', function() {
        <%
        if (successMessage != null) {
        %>
        setTimeout(function() {
            const successMsg = document.querySelector('.success-message');
            if (successMsg) {
                successMsg.remove();
            }
        }, 5000);
        <%
        }
        %>
    });

    // Ngăn thêm món khi chưa có bàn
    (function() {
        var addItemsLink = document.getElementById('addItemsLink');
        if (addItemsLink) {
            addItemsLink.addEventListener('click', function(e) {
                var hasTables = <%= hasTables ? "true" : "false" %>;
                if (!hasTables) {
                    e.preventDefault();
                    alert('Bạn phải chọn ít nhất 1 bàn trước khi chọn món.');
                }
            });
        }
    })();

    // Ngăn submit khi chưa có bàn (phòng hờ nếu người dùng bỏ qua link)
    (function() {
        var checkoutForm = document.getElementById('checkoutForm');
        if (checkoutForm) {
            checkoutForm.addEventListener('submit', function(e) {
                var hasTables = <%= hasTables ? "true" : "false" %>;
                if (!hasTables) {
                    e.preventDefault();
                    alert('Bạn phải chọn ít nhất 1 bàn trước khi đặt món/thanh toán.');
                }
            });
        }
    })();
</script>

</body>
</html>