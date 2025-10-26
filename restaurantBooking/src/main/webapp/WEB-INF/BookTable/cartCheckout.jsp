<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.text.DecimalFormat, java.math.BigDecimal" %>
<%@ page import="com.fpt.restaurantbooking.models.OrderItem" %>
<%@ page import="com.fpt.restaurantbooking.models.Reservation" %>
<%@ page import="com.fpt.restaurantbooking.models.MenuItem" %>
<%@ page import="com.fpt.restaurantbooking.models.Table" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Giỏ hàng & Thanh toán</title>

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
            max-width: 900px;
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

    </style>
</head>
<body>
<%
    // Lấy dữ liệu từ request attributes
    List<OrderItem> orderItems = (List<OrderItem>) request.getAttribute("currentItems");
    List<Table> selectedTables = (List<Table>) request.getAttribute("selectedTables");
    Reservation reservation = (Reservation) request.getAttribute("reservation");
    String errorMessage = (String) request.getAttribute("errorMessage");
    String successMessage = (String) request.getAttribute("successMessage");

    // Khởi tạo formatter
    DecimalFormat formatter = new DecimalFormat("###,###,### VNĐ");

    // Tính tổng tiền
    BigDecimal totalAmount = BigDecimal.ZERO;
    if (reservation != null && reservation.getTotalAmount() != null) {
        totalAmount = reservation.getTotalAmount();
    }

    boolean hasItems = (orderItems != null && !orderItems.isEmpty());
    boolean hasTables = (selectedTables != null && !selectedTables.isEmpty());
%>

<div class="container">
    <h2><i class="fas fa-shopping-cart"></i> Giỏ hàng & Thanh toán</h2>

    <!-- Error Message -->
    <% if (errorMessage != null) { %>
    <div class="message error-message">
        <i class="fas fa-exclamation-circle"></i> <%= errorMessage %>
    </div>
    <% } %>

    <!-- Success Message -->
    <% if (successMessage != null) { %>
    <div class="message success-message">
        <i class="fas fa-check-circle"></i> <%= successMessage %>
    </div>
    <% } %>

    <% if (!hasItems) { %>
    <!-- Empty Cart -->
    <div class="empty-cart">
        <i class="fas fa-shopping-cart"></i>
        <h3>Giỏ hàng của bạn đang trống</h3>
        <p>Vui lòng chọn món ăn để tiếp tục</p>
        <a href="orderItems" class="btn back-btn" style="margin-top: 20px;">
            <i class="fas fa-utensils"></i> Quay lại chọn món
        </a>
    </div>
    <% } else { %>

    <!-- Selected Tables Section -->
    <% if (hasTables) { %>
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
            </tr>
            </thead>
            <tbody>
            <% for (int i = 0; i < selectedTables.size(); i++) {
                Table table = selectedTables.get(i);
            %>
            <tr style="border-bottom: 1px solid rgba(255, 255, 255, 0.15);">
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
            </tr>
            <% } %>
            </tbody>
        </table>
    </div>
    <% } %>

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
            int index = 1;
            for (OrderItem item : orderItems) {
                BigDecimal itemTotal = item.getUnitPrice().multiply(new BigDecimal(item.getQuantity()));
        %>
        <tr class="item-row">
            <td style="text-align: center;"><%= index++ %></td>
            <td>
                <div><%= item.getItemId() %></div>
                <% if (item.getSpecialInstructions() != null && !item.getSpecialInstructions().trim().isEmpty()) { %>
                <div class="note-text">
                    <i class="fas fa-sticky-note"></i> <%= item.getSpecialInstructions() %>
                </div>
                <% } %>
            </td>
            <td style="text-align: center;"><%= item.getQuantity() %></td>
            <td class="price-col"><%= formatter.format(item.getUnitPrice()) %></td>
            <td class="price-col"><%= formatter.format(itemTotal) %></td>
        </tr>
        <% } %>
        </tbody>
    </table>

    <!-- Total Summary -->
    <div class="total-summary">
        <p>Tổng tiền món ăn: <strong><%= formatter.format(totalAmount) %></strong></p>
        <p class="final-total">Tổng tiền cần thanh toán: <strong><%= formatter.format(totalAmount) %></strong></p>
    </div>

    <!-- Payment Form -->
    <form method="post" action="checkout">
        <input type="hidden" name="action" value="confirm">

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
    <% } %>
</div>

<script>
    // Hiển thị alert nếu có message
    window.addEventListener('DOMContentLoaded', function() {
        <% if (successMessage != null) { %>
        setTimeout(function() {
            document.querySelector('.success-message')?.remove();
        }, 5000);
        <% } %>
    });
</script>

</body>
</html>