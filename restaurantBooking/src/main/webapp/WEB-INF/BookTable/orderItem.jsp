<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.ArrayList, java.text.DecimalFormat, com.fpt.restaurantbooking.models.MenuItem" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chọn món & Đặt bàn</title>

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

        .page-wrapper {
            width: 90%;
            max-width: 1200px;
            margin: 40px auto;
            padding-bottom: 120px; /* Space for sticky footer */
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

        /* --- Filter & Header Actions --- */
        .header-actions {
            background-color: rgba(20, 10, 10, 0.75);
            backdrop-filter: blur(8px);
            padding: 20px 25px;
            border-radius: 12px;
            box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.37);
            border: 1px solid rgba(255, 255, 255, 0.18);
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 40px;
            gap: 20px;
            flex-wrap: wrap;
        }

        .search-filter-form {
            display: flex;
            gap: 20px;
            align-items: center;
            flex-grow: 1;
            flex-wrap: wrap;
        }

        .input-group {
            display: flex;
            align-items: center;
            background: transparent;
            border-bottom: 1px solid rgba(255, 255, 255, 0.3);
            padding: 5px 0;
        }

        .input-group i {
            margin-right: 10px;
            color: rgba(255, 255, 255, 0.7);
        }

        .search-filter-form input[type="text"], .search-filter-form select {
            background: transparent;
            border: none;
            color: #fff;
            font-family: 'Montserrat', sans-serif;
            padding: 8px 5px;
            font-size: 1em;
        }

        .search-filter-form select option {
            background: #333;
            color: #fff;
        }

        .search-filter-form input[type="text"]::placeholder {
            color: rgba(255, 255, 255, 0.5);
        }

        .search-filter-form input:focus, .search-filter-form select:focus {
            outline: none;
        }

        .btn-filter {
            padding: 10px 25px;
            background: #e74c3c;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 500;
            font-size: 1em;
            transition: background 0.3s ease;
        }
        .btn-filter:hover {
            background: #c0392b;
        }

        .cart-summary a {
            color: #f0f0f0;
            text-decoration: none;
            font-size: 1.1em;
            transition: color 0.3s;
        }
        .cart-summary a:hover {
            color: #e74c3c;
        }

        /* --- Menu List & Items --- */
        .menu-list {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(290px, 1fr));
            gap: 25px;
        }

        .menu-item {
            background-color: rgba(20, 10, 10, 0.65);
            backdrop-filter: blur(5px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            padding: 15px;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
            transition: transform 0.3s, box-shadow 0.3s;
            display: flex;
            flex-direction: column;
        }
        .menu-item:hover {
            transform: translateY(-8px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.4);
        }

        .menu-item img {
            width: 100%;
            height: 160px;
            object-fit: cover;
            border-radius: 8px;
            margin-bottom: 15px;
        }

        .item-details h3 {
            margin: 0 0 5px 0;
            color: #fff;
            font-size: 1.3em;
            font-weight: 500;
        }

        .item-details p { margin: 5px 0; color: rgba(255,255,255,0.8); }
        .item-details .price { font-weight: bold; color: #ffc107; }
        .item-details .calories { font-style: italic; font-size: 0.9em; }

        .item-controls {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-top: auto; /* Pushes to the bottom */
            padding-top: 15px;
        }

        .item-controls label {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .item-controls input[type="number"] {
            width: 60px;
            padding: 5px;
            border: 1px solid rgba(255,255,255,0.2);
            border-radius: 4px;
            text-align: center;
            background: rgba(0,0,0,0.3);
            color: #fff;
        }

        .btn-add-cart {
            padding: 8px 12px;
            background: #28a745;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            transition: background 0.3s;
        }
        .btn-add-cart:hover {
            background: #218838;
        }

        .note-input {
            width: 100%;
            margin-top: 10px;
            padding: 8px;
            border: 1px solid rgba(255,255,255,0.2);
            border-radius: 6px;
            resize: vertical;
            background: rgba(0,0,0,0.3);
            color: #fff;
        }
        .note-input::placeholder {
            color: rgba(255,255,255,0.5);
        }

        /* --- Sticky Footer --- */
        .sticky-footer {
            position: fixed;
            bottom: 0;
            left: 0;
            width: 100%;
            background: rgba(10, 5, 5, 0.85);
            backdrop-filter: blur(10px);
            color: white;
            padding: 15px 5%;
            box-shadow: 0 -4px 20px rgba(0,0,0,0.4);
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
        }
        .sticky-footer .total {
            font-size: 1.4em;
            font-weight: 700;
        }
        .sticky-footer .total span {
            color: #ffc107;
        }

        .footer-buttons {
            display: flex;
            gap: 15px;
        }

        .btn {
            background: transparent;
            color: white;
            border: 1px solid #fff;
            padding: 10px 20px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 1em;
            text-decoration: none;
            transition: background 0.3s, color 0.3s;
        }
        .btn:hover {
            background: #fff;
            color: #000;
        }

        .btn-confirm {
            background: #e74c3c;
            border: 1px solid #e74c3c;
        }
        .btn-confirm:hover {
            background: #c0392b;
            border-color: #c0392b;
            color: #fff;
        }

        /* --- Pagination --- */
        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
            margin-top: 30px;
            padding: 10px;
        }

        .pagination a {
            color: #fff;
            background: rgba(255, 255, 255, 0.1);
            padding: 8px 14px;
            border-radius: 6px;
            text-decoration: none;
            transition: background 0.3s;
            font-size: 1em;
        }

        .pagination a:hover {
            background: #e74c3c;
        }

        .pagination a.active {
            background: #e74c3c;
            font-weight: bold;
        }

        .pagination a.disabled {
            background: rgba(255, 255, 255, 0.05);
            color: rgba(255, 255, 255, 0.5);
            cursor: not-allowed;
        }
    </style>
</head>
<body>
<%
    // Get data from request attributes (set by servlet)
    List<MenuItem> menuItems = (List<MenuItem>) request.getAttribute("menuItems");
    List<String> categories = (List<String>) request.getAttribute("categories");
    Integer currentPage = (Integer) request.getAttribute("currentPage");
    Integer totalPages = (Integer) request.getAttribute("totalPages");

    // Get current filter params
    String searchKeyword = request.getParameter("search");
    String categoryFilter = request.getParameter("category");

    // Initialize formatter
    DecimalFormat formatter = new DecimalFormat("###,###,### VNĐ");

    // Default values if null
    if (menuItems == null) menuItems = new ArrayList<>();
    if (categories == null) categories = new ArrayList<>();
    if (currentPage == null) currentPage = 1;
    if (totalPages == null) totalPages = 1;
    if (categoryFilter == null) categoryFilter = "all";
%>

<div class="page-wrapper">
    <h2>Our Menu</h2>

    <div class="header-actions">
        <form class="search-filter-form" method="get" action="orderItems">
            <!-- ✅ KHÔNG CẦN hidden input cho GET form -->
            <div class="input-group">
                <i class="fas fa-search"></i>
                <input type="text" name="search" placeholder="Tìm kiếm món ăn..." value="<%= searchKeyword != null ? searchKeyword : "" %>">
            </div>
            <div class="input-group">
                <i class="fas fa-utensils"></i>
                <select name="category" onchange="this.form.submit()">
                    <option value="all">Tất cả danh mục</option>
                    <% for (String category : categories) { %>
                    <option value="<%= category %>" <%= category.equals(categoryFilter) ? "selected" : "" %>><%= category %></option>
                    <% } %>
                </select>
            </div>
            <button type="submit" class="btn-filter">Lọc</button>
        </form>
        <div class="cart-summary">
            <a href="#cart">
                <i class="fas fa-shopping-cart"></i> Giỏ hàng (<span id="cart-count">0</span>)
            </a>
        </div>
    </div>

    <div class="menu-list">
        <% for (MenuItem item : menuItems) { %>
        <div class="menu-item">
            <img src="<%= item.getImageUrl() %>" alt="<%= item.getItemName() %>">
            <div class="item-details">
                <h3><%= item.getItemName() %></h3>
                <p class="price"><%= formatter.format(item.getPrice()) %></p>
                <p><%= item.getDescription() %></p>
                <% if (item.getCalories() != null) { %>
                <p class="calories"><%= item.getCalories() %> calo</p>
                <% } %>
            </div>

            <div class="item-controls">
                <label>
                    Số lượng:
                    <input type="number" name="qty_<%= item.getItemId() %>" value="0" min="0">
                </label>

                <button type="button" class="btn-add-cart"
                        onclick="addToCart(<%= item.getItemId() %>, '<%= item.getItemName().replace("'", "\\'") %>', <%= item.getPrice().doubleValue() %>)">
                    <i class="fas fa-cart-plus"></i> THÊM
                </button>
            </div>

            <textarea class="note-input"
                      name="note_<%= item.getItemId() %>"
                      placeholder="Yêu cầu đặc biệt..."></textarea>
        </div>
        <% } %>
    </div>

    <div class="pagination">
        <% if (currentPage > 1) { %>
        <a href="orderItems?page=<%= currentPage - 1 %>&search=<%= searchKeyword != null ? searchKeyword : "" %>&category=<%= categoryFilter %>">&laquo; Trước</a>
        <% } else { %>
        <a class="disabled">&laquo; Trước</a>
        <% } %>

        <% for (int i = 1; i <= totalPages; i++) { %>
        <a href="orderItems?page=<%= i %>&search=<%= searchKeyword != null ? searchKeyword : "" %>&category=<%= categoryFilter %>" <%= i == currentPage ? "class='active'" : "" %>><%= i %></a>
        <% } %>

        <% if (currentPage < totalPages) { %>
        <a href="orderItems?page=<%= currentPage + 1 %>&search=<%= searchKeyword != null ? searchKeyword : "" %>&category=<%= categoryFilter %>">Tiếp &raquo;</a>
        <% } else { %>
        <a class="disabled">Tiếp &raquo;</a>
        <% } %>
    </div>
</div>

<div class="sticky-footer" id="cart">
    <div class="total">
        Tổng cộng: <span id="total-price">0 VNĐ</span>
    </div>
    <div class="footer-buttons">
        <a href="mapTable" class="btn">
            <i class="fas fa-arrow-left"></i> Quay lại chọn bàn
        </a>
        <a href="checkout" class="btn btn-confirm">
            <i class="fas fa-check-circle"></i> Xác nhận & Thanh toán
        </a>
    </div>
</div>

<script>
    const contextPath = '<%= request.getContextPath() %>';

    // Load initial cart state on page load
    window.addEventListener('DOMContentLoaded', function() {
        updateTotalPrice();
    });

    function addToCart(itemId, itemName, price) {
        console.log('🔍 addToCart called with itemId:', itemId);

        // ✅ Tìm input theo attribute selector an toàn hơn
        const qtyInput = document.querySelector('input[name="qty_' + itemId + '"]');
        const noteInput = document.querySelector('textarea[name="note_' + itemId + '"]');

        console.log('🔍 Found qtyInput:', qtyInput);
        console.log('🔍 Input value:', qtyInput ? qtyInput.value : 'NULL');

        if (!qtyInput) {
            alert('❌ Không tìm thấy ô nhập số lượng cho món #' + itemId);
            console.error('❌ Selector failed: input[name="qty_' + itemId + '"]');
            return;
        }

        const quantity = parseInt(qtyInput.value);
        const note = noteInput ? noteInput.value.trim() : '';

        console.log('📊 Quantity:', quantity, '| Note:', note);

        if (isNaN(quantity) || quantity <= 0) {
            alert('⚠️ Vui lòng nhập số lượng > 0');
            return;
        }

        // ✅ Dùng URLSearchParams thay vì FormData để đảm bảo servlet nhận được parameters
        const params = new URLSearchParams();
        params.append('action', 'add');
        params.append('itemId', itemId);
        params.append('quantity', quantity);
        params.append('note', note);

        console.log('📤 Sending request with params:', params.toString());

        fetch(contextPath + '/orderItems', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: params.toString()
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('✅ Thêm ' + itemName + ' thành công!');
                    qtyInput.value = 0;
                    if (noteInput) noteInput.value = '';
                    updateTotalPrice();
                } else {
                    alert('⚠️ Lỗi: ' + (data.message || 'Không thể thêm món'));
                }
            })
            .catch(error => {
                console.error('Fetch error:', error);
                alert('❌ Có lỗi xảy ra khi thêm món.');
            });
    }

    function updateTotalPrice() {
        fetch(contextPath + '/orderItems?action=getTotal')
            .then(response => response.json())
            .then(data => {
                const formatter = new Intl.NumberFormat('vi-VN', {
                    style: 'currency',
                    currency: 'VND'
                });

                const totalPriceElement = document.getElementById('total-price');
                const cartCountElement = document.getElementById('cart-count');

                if (totalPriceElement) {
                    totalPriceElement.textContent = formatter.format(data.total || 0);
                }

                if (cartCountElement) {
                    cartCountElement.textContent = data.totalItems || 0;
                }
            })
            .catch(error => {
                console.error('Error updating total:', error);
            });
    }
</script>

</body>
</html>