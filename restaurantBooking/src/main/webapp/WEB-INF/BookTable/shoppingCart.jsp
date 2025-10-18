<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.LinkedHashMap, java.util.Map, java.text.DecimalFormat, java.util.ArrayList" %>
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
        .item-row td:first-child {
            width: 50px;
            text-align: center;
        }
        input[type="checkbox"] {
            transform: scale(1.3);
            cursor: pointer;
            accent-color: #e74c3c;
        }
        input[type="number"] {
            width: 65px;
            padding: 8px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 5px;
            text-align: center;
            background: rgba(0, 0, 0, 0.3);
            color: #fff;
            font-family: 'Montserrat', sans-serif;
            font-size: 1em;
        }
        input[type="number"]:focus {
            outline: none;
            border-color: #e74c3c;
        }
        .price-col {
            text-align: right;
            font-weight: bold;
            color: #ffc107;
        }

        /* --- Promo Code --- */
        .promo-code {
            display: flex;
            align-items: center;
            margin-bottom: 30px;
            gap: 10px;
        }
        .promo-code input {
            flex-grow: 1;
            padding: 12px 15px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 8px;
            outline: none;
            font-size: 1em;
            background: rgba(0, 0, 0, 0.3);
            color: #fff;
            font-family: 'Montserrat', sans-serif;
        }
        .promo-code input::placeholder {
            color: rgba(255, 255, 255, 0.5);
        }
        .promo-code button {
            padding: 12px 25px;
            background: #28a745;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 1em;
            font-weight: 500;
            transition: background 0.3s ease;
        }
        .promo-code button:hover {
            background: #218838;
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
            padding: 15px 0;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }
        .payment-method p {
            font-weight: 600;
            margin-bottom: 15px;
            font-size: 1.1em;
            color: #fff;
        }
        .payment-method label {
            margin-right: 30px;
            font-weight: 500;
            cursor: pointer;
            color: rgba(255,255,255,0.9);
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .payment-method input[type="radio"] {
            transform: scale(1.2);
            accent-color: #e74c3c;
            cursor: pointer;
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
        }
        .actions .btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 15px rgba(0,0,0,0.2);
        }
        .update-btn {
            background: #ffc107;
            color: #333;
        }
        .update-btn:hover {
            background: #e0a800;
        }
        .confirm-btn {
            background: #e74c3c;
            color: white;
        }
        .confirm-btn:hover {
            background: #c0392b;
        }
        .history-btn {
            background: #17a2b8;
            color: white;
        }
        .history-btn:hover {
            background: #138496;
        }

    </style>
</head>
<body>
<div class="container">
    <h2><i class="fas fa-shopping-cart"></i> Giỏ hàng & Thanh toán</h2>

    <%
        // Khởi tạo hoặc lấy giỏ hàng từ session
        Map<String, Object[]> cart = (Map<String, Object[]>) session.getAttribute("cart");
        if (cart == null) {
            cart = new LinkedHashMap<>();
            // Dữ liệu demo cho giỏ hàng
            cart.put("phoBo", new Object[]{"Phở Bò", 50000.0, 2});
            cart.put("traSua", new Object[]{"Trà Sữa", 30000.0, 1});
            cart.put("bunCha", new Object[]{"Bún Chả", 45000.0, 1});
            cart.put("caPhe", new Object[]{"Cà Phê Sữa", 25000.0, 2});
            cart.put("banhMi", new Object[]{"Bánh Mì Thịt", 20000.0, 3});

            session.setAttribute("cart", cart);
        }

        // Xử lý hành động từ form
        String action = request.getParameter("action");
        String message = null;
        String messageType = null;

        if (action != null) {
            if ("update".equals(action)) {
                for (String key : new ArrayList<>(cart.keySet())) {
                    String qtyStr = request.getParameter(key + "_qty");
                    String removeCheck = request.getParameter("remove_" + key);

                    if ("on".equals(removeCheck)) {
                        cart.remove(key);
                    } else if (qtyStr != null) {
                        try {
                            int newQty = Integer.parseInt(qtyStr);
                            if (newQty > 0) {
                                Object[] item = cart.get(key);
                                if(item != null) item[2] = newQty;
                            } else {
                                cart.remove(key);
                            }
                        } catch (NumberFormatException e) {
                            // Bỏ qua nếu giá trị không hợp lệ
                        }
                    }
                }
                session.setAttribute("updateSuccess", "true");

            } else if ("applyPromo".equals(action)) {
                String promoCodeInput = request.getParameter("promoCode");
                if (promoCodeInput != null && promoCodeInput.equalsIgnoreCase("GIAM10")) {
                    session.setAttribute("promoCode", promoCodeInput);
                    message = "🎉 Đã áp dụng thành công mã GIAM10!";
                    messageType = "success";
                } else {
                    session.removeAttribute("promoCode");
                    message = "❌ Mã khuyến mãi không hợp lệ hoặc đã hết hạn.";
                    messageType = "error";
                }
            } else if ("confirm".equals(action)) {
                if (cart.isEmpty()) {
                    message = "❌ Giỏ hàng của bạn đang trống, không thể xác nhận đơn hàng.";
                    messageType = "error";
                } else {
                    session.setAttribute("orderConfirmed", "true");
                    session.removeAttribute("cart");
                    session.removeAttribute("promoCode");
                }
            }
        }

        if (session.getAttribute("orderConfirmed") != null) {
            message = "🎉 Đơn hàng của bạn đã được xác nhận thành công! Vui lòng chờ để được liên hệ.";
            messageType = "success";
            session.removeAttribute("orderConfirmed");
        } else if (session.getAttribute("updateSuccess") != null) {
            message = "✅ Giỏ hàng đã được cập nhật thành công!";
            messageType = "success";
            session.removeAttribute("updateSuccess");
        }

        double subtotal = 0;
        for (Object[] item : cart.values()) {
            double price = (Double) item[1];
            int quantity = (Integer) item[2];
            subtotal += price * quantity;
        }

        String promoCode = (String) session.getAttribute("promoCode");
        double discount = 0;
        String discountMessage = "";
        if (promoCode != null && promoCode.equalsIgnoreCase("GIAM10")) {
            discount = subtotal * 0.10;
            discountMessage = "(Giảm 10% với mã GIAM10)";
        }

        double finalTotal = subtotal - discount;

        DecimalFormat formatter = new DecimalFormat("###,###,### VNĐ");
    %>

    <% if (message != null) { %>
    <div class="message <%= messageType %>-message">
        <%= message %>
    </div>
    <% } %>

    <form method="post">
        <table>
            <thead>
            <tr>
                <th><i class="fas fa-trash-alt"></i></th>
                <th>Tên món</th>
                <th>Số lượng</th>
                <th class="price-col">Đơn giá</th>
                <th class="price-col">Thành tiền</th>
            </tr>
            </thead>
            <tbody>
            <% if (cart.isEmpty()) { %>
            <tr><td colspan="5" style="text-align:center; padding: 25px; color: rgba(255,255,255,0.7);">Giỏ hàng của bạn đang trống.</td></tr>
            <% } else { %>
            <% for (Map.Entry<String, Object[]> entry : cart.entrySet()) {
                String id = entry.getKey();
                Object[] item = entry.getValue();
                String name = (String) item[0];
                double price = (Double) item[1];
                int quantity = (Integer) item[2];
            %>
            <tr class="item-row">
                <td><input type="checkbox" name="remove_<%= id %>"></td>
                <td><%= name %></td>
                <td><input type="number" name="<%= id %>_qty" value="<%= quantity %>" min="0"></td>
                <td class="price-col"><%= formatter.format(price) %></td>
                <td class="price-col"><%= formatter.format(price * quantity) %></td>
            </tr>
            <% } %>
            <% } %>
            </tbody>
        </table>

        <div class="promo-code">
            <input type="text" name="promoCode" placeholder="Nhập mã khuyến mãi" value="<%= promoCode != null ? promoCode : "" %>">
            <button type="submit" name="action" value="applyPromo"><i class="fas fa-tags"></i> Áp dụng</button>
        </div>

        <div class="total-summary">
            <p>Tổng tiền món: <strong><%= formatter.format(subtotal) %></strong></p>
            <p>Giảm giá <%= discountMessage %>: <strong>- <%= formatter.format(discount) %></strong></p>
            <p class="final-total">Tổng tiền cần thanh toán: <strong><%= formatter.format(finalTotal) %></strong></p>
        </div>

        <div class="payment-method">
            <p><b><i class="fas fa-credit-card"></i> Chọn hình thức thanh toán:</b></p>
            <label><input type="radio" name="payment" value="COD" checked> Thanh toán khi nhận (COD)</label>
            <label><input type="radio" name="payment" value="Online"> Thanh toán Online</label>
            <label><input type="radio" name="payment" value="Card"> Thẻ Ngân Hàng</label>
        </div>

        <div class="actions">
            <button type="submit" name="action" value="update" class="btn update-btn">
                <i class="fas fa-sync-alt"></i> Cập nhật giỏ hàng
            </button>
            <button type="submit" name="action" value="confirm" class="btn confirm-btn">
                <i class="fas fa-check-circle"></i> Xác nhận đơn hàng
            </button>
            <a href="trangdatban.jsp" class="btn history-btn">
                <i class="fas fa-backward"></i> Tiếp tục chọn món
            </a>
            <a href="lichsudat.jsp" class="btn history-btn">
                <i class="fas fa-history"></i> Xem lịch sử đặt hàng
            </a>
        </div>
    </form>
</div>
</body>
</html>
