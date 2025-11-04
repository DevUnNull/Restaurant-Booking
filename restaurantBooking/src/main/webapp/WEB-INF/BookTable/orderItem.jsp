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

        .page-wrapper {
            width: 90%;
            max-width: 1200px;
            margin: 40px auto;
            padding-bottom: 120px; /* Space for sticky footer */
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

        /* --- Filter & Header Actions --- */
        .header-actions {
            background-color: var(--box-bg);
            backdrop-filter: blur(8px);
            padding: 20px 25px;
            border-radius: 12px;
            box-shadow: var(--shadow);
            border: 1px solid var(--input-border);
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 40px;
            gap: 20px;
            flex-wrap: wrap;
            transition: all 0.3s ease;
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
            border-bottom: 1px solid var(--input-border);
            padding: 5px 0;
            transition: border-color 0.3s ease;
        }

        .input-group i {
            margin-right: 10px;
            color: var(--text-muted);
        }

        .search-filter-form input[type="text"], .search-filter-form select {
            background: transparent;
            border: none;
            color: var(--text-primary);
            font-family: 'Montserrat', sans-serif;
            padding: 8px 5px;
            font-size: 1em;
            transition: color 0.3s ease;
        }

        .search-filter-form select option {
            background: var(--box-bg);
            color: var(--text-primary);
        }

        body.light-mode .search-filter-form select option {
            background: #fff;
            color: #2c3e50;
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
            background-color: var(--box-bg);
            backdrop-filter: blur(5px);
            border: 1px solid var(--input-border);
            padding: 15px;
            border-radius: 10px;
            box-shadow: var(--shadow);
            transition: transform 0.3s, box-shadow 0.3s, background-color 0.3s ease;
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
            color: var(--text-primary);
            font-size: 1.3em;
            font-weight: 500;
            transition: color 0.3s ease;
        }

        .item-details p {
            margin: 5px 0;
            color: var(--text-muted);
            transition: color 0.3s ease;
        }
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
            border: 1px solid var(--input-border);
            border-radius: 4px;
            text-align: center;
            background: var(--table-bg);
            color: var(--text-primary);
            transition: all 0.3s ease;
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
            border: 1px solid var(--input-border);
            border-radius: 6px;
            resize: vertical;
            background: var(--table-bg);
            color: var(--text-primary);
            transition: all 0.3s ease;
        }
        .note-input::placeholder {
            color: var(--text-muted);
        }

        /* --- Sticky Footer --- */
        .sticky-footer {
            position: fixed;
            bottom: 0;
            left: 0;
            width: 100%;
            background: var(--box-bg);
            backdrop-filter: blur(10px);
            color: var(--text-primary);
            padding: 15px 5%;
            box-shadow: 0 -4px 20px rgba(0,0,0,0.4);
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-top: 1px solid var(--input-border);
            transition: all 0.3s ease;
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

        /* --- Service Combo Highlight --- */
        .menu-item.combo-item {
            border: 2px solid #ffc107;
            background: linear-gradient(135deg, rgba(255, 193, 7, 0.1) 0%, rgba(255, 193, 7, 0.05) 100%);
            position: relative;
        }

        .menu-item.combo-item::before {
            content: "🌟 COMBO DỊCH VỤ";
            position: absolute;
            top: -10px;
            right: 10px;
            background: #ffc107;
            color: #000;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.75em;
            font-weight: 700;
            letter-spacing: 1px;
            box-shadow: 0 2px 8px rgba(255, 193, 7, 0.5);
        }

        .combo-notice {
            background: rgba(255, 193, 7, 0.2);
            border-left: 4px solid #ffc107;
            padding: 15px 20px;
            margin-bottom: 20px;
            border-radius: 8px;
            color: #fff;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .combo-notice i {
            font-size: 1.5em;
            color: #ffc107;
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
    // Get data from request attributes (set by servlet)
    List<MenuItem> menuItems = (List<MenuItem>) request.getAttribute("menuItems");
    List<String> categories = (List<String>) request.getAttribute("categories");
    Integer currentPage = (Integer) request.getAttribute("currentPage");
    Integer totalPages = (Integer) request.getAttribute("totalPages");
    List<MenuItem> serviceComboItems = (List<MenuItem>) request.getAttribute("serviceComboItems");
    Integer selectedServiceId = (Integer) request.getAttribute("selectedServiceId");

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
    if (serviceComboItems == null) serviceComboItems = new ArrayList<>();

    // Tạo set để kiểm tra nhanh món nào trong combo
    java.util.Set<Integer> comboItemIds = new java.util.HashSet<>();
    for (MenuItem comboItem : serviceComboItems) {
        comboItemIds.add(comboItem.getItemId());
    }
%>

<div class="page-wrapper">
    <h2>Our Menu</h2>

    <% if (selectedServiceId != null && selectedServiceId > 0 && !serviceComboItems.isEmpty()) { %>
    <div class="combo-notice">
        <i class="fas fa-star"></i>
        <div>
            <strong>Đã thêm <%= serviceComboItems.size() %> món từ combo dịch vụ vào giỏ hàng!</strong><br>
            <span style="font-size: 0.9em;">Các món được đánh dấu sao sẽ tự động được thêm vào khi bạn chọn bàn.</span>
        </div>
    </div>
    <% } %>

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
                    <% if (selectedServiceId != null && selectedServiceId > 0 && !serviceComboItems.isEmpty()) { %>
                    <option value="combo" <%= "combo".equals(categoryFilter) ? "selected" : "" %>>🌟 Món trong Combo Dịch vụ</option>
                    <% } %>
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
        <% for (MenuItem item : menuItems) {
            boolean isComboItem = comboItemIds.contains(item.getItemId());
        %>
        <div class="menu-item <%= isComboItem ? "combo-item" : "" %>">
            <img src="${pageContext.request.contextPath}<%= item.getImageUrl() %>" alt="<%= item.getItemName() %>">
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

<script src="${pageContext.request.contextPath}/js/theme-manager.js"></script>
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