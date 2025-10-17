<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.ArrayList, java.util.LinkedHashMap, java.util.Map, java.text.DecimalFormat" %>
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
            /* THAY THẾ BẰNG URL ẢNH NỀN CỦA BẠN */
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

    </style>
</head>
<body>
<%
    // --- TOÀN BỘ LOGIC JAVA CỦA BẠN ĐƯỢC GIỮ NGUYÊN ---
    class MenuItem {
        String id; String name; String category; String description;
        double price; int calories; String image; int orderCount;
        MenuItem(String id, String name, String category, String description, double price, int calories, String image, int orderCount) {
            this.id = id; this.name = name; this.category = category; this.description = description;
            this.price = price; this.calories = calories; this.image = image; this.orderCount = orderCount;
        }
    }
    List<MenuItem> allMenuItems = new ArrayList<>();
    allMenuItems.add(new MenuItem("phoBo", "Phở Bò", "Món chính", "Món phở truyền thống với thịt bò.", 50000.0, 450, "https://via.placeholder.com/300x160?text=Pho+Bo", 150));
    allMenuItems.add(new MenuItem("comGa", "Cơm Gà", "Món chính", "Cơm thơm ăn kèm với gà giòn.", 45000.0, 600, "https://via.placeholder.com/300x160?text=Com+Ga", 210));
    allMenuItems.add(new MenuItem("banhMi", "Bánh Mì Thịt", "Đồ ăn nhanh", "Bánh mì Việt Nam với chả lụa.", 25000.0, 350, "https://via.placeholder.com/300x160?text=Banh+Mi", 300));
    allMenuItems.add(new MenuItem("traSua", "Trà Sữa", "Đồ uống", "Trà sữa béo ngậy ăn kèm trân châu.", 30000.0, 250, "https://via.placeholder.com/300x160?text=Tra+Sua", 120));
    allMenuItems.add(new MenuItem("nemRan", "Nem Rán", "Món khai vị", "Nem rán giòn rụm chấm mắm.", 35000.0, 200, "https://via.placeholder.com/300x160?text=Nem+Ran", 250));

    Map<String, Map<String, Object>> cart = (Map<String, Map<String, Object>>) session.getAttribute("cart");
    if (cart == null) {
        cart = new LinkedHashMap<>();
        session.setAttribute("cart", cart);
    }
    String action = request.getParameter("action");
    if ("add".equals(action)) {
        String itemId = request.getParameter("itemId");
        String qtyStr = request.getParameter("qty_" + itemId); // Sửa lại cách lấy qty
        String note = request.getParameter("note_" + itemId); // Sửa lại cách lấy note

        try {
            int quantity = Integer.parseInt(qtyStr);
            if (quantity > 0) {
                MenuItem selectedItem = null;
                for (MenuItem item : allMenuItems) {
                    if (item.id.equals(itemId)) { selectedItem = item; break; }
                }
                if (selectedItem != null) {
                    Map<String, Object> newItem = new LinkedHashMap<>();
                    newItem.put("item", selectedItem);
                    newItem.put("quantity", quantity);
                    newItem.put("note", note);
                    cart.put(itemId, newItem); // Ghi đè hoặc thêm mới
                }
            } else if (quantity == 0) {
                cart.remove(itemId); // Xóa khỏi giỏ hàng nếu số lượng là 0
            }
        } catch (NumberFormatException e) {
            // Bỏ qua lỗi
        }
    } else if ("confirm".equals(action)) {
        if (!cart.isEmpty()) {
            session.removeAttribute("cart");
            // Chuyển hướng hoặc hiển thị thông báo thành công
        }
    }

    String searchKeyword = request.getParameter("search");
    String categoryFilter = request.getParameter("category");
    List<MenuItem> filteredItems = new ArrayList<>();
    for (MenuItem item : allMenuItems) {
        boolean matchesSearch = searchKeyword == null || searchKeyword.trim().isEmpty() || item.name.toLowerCase().contains(searchKeyword.toLowerCase());
        boolean matchesCategory = categoryFilter == null || "all".equals(categoryFilter) || item.category.equals(categoryFilter);
        if (matchesSearch && matchesCategory) {
            filteredItems.add(item);
        }
    }

    int totalItemsInCart = 0;
    double totalPrice = 0;
    for (Map<String, Object> itemData : cart.values()) {
        int qty = (Integer) itemData.get("quantity");
        MenuItem menuItem = (MenuItem) itemData.get("item");
        totalItemsInCart += qty;
        totalPrice += qty * menuItem.price;
    }
    DecimalFormat formatter = new DecimalFormat("###,###,### VNĐ");
%>

<div class="page-wrapper">
    <h2>Our Menu</h2>

    <div class="header-actions">
        <form class="search-filter-form" method="get">
            <div class="input-group">
                <i class="fas fa-search"></i>
                <input type="text" name="search" placeholder="Tìm kiếm món ăn..." value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
            </div>
            <div class="input-group">
                <i class="fas fa-utensils"></i>
                <select name="category" onchange="this.form.submit()">
                    <option value="all">Tất cả danh mục</option>
                    <option value="Món chính" <%= "Món chính".equals(categoryFilter) ? "selected" : "" %>>Món chính</option>
                    <option value="Món khai vị" <%= "Món khai vị".equals(categoryFilter) ? "selected" : "" %>>Món khai vị</option>
                    <option value="Đồ uống" <%= "Đồ uống".equals(categoryFilter) ? "selected" : "" %>>Đồ uống</option>
                </select>
            </div>
            <button type="submit" class="btn-filter">Lọc</button>
        </form>
        <div class="cart-summary">
            <a href="#cart">
                <i class="fas fa-shopping-cart"></i> Giỏ hàng (<%= totalItemsInCart %>)
            </a>
        </div>
    </div>

    <form method="post" id="menuForm">
        <div class="menu-list">
            <% for (MenuItem item : filteredItems) {
                int currentQty = 0;
                String currentNote = "";
                if(cart.containsKey(item.id)) {
                    currentQty = (Integer) cart.get(item.id).get("quantity");
                    currentNote = (String) cart.get(item.id).get("note");
                }
            %>
            <div class="menu-item">
                <img src="<%= item.image %>" alt="<%= item.name %>">
                <div class="item-details">
                    <h3><%= item.name %></h3>
                    <p class="price"><%= formatter.format(item.price) %></p>
                    <p><%= item.description %></p>
                    <p class="calories"><%= item.calories %> calo</p>
                </div>
                <div class="item-controls">
                    <label>
                        Số lượng:
                        <input type="number" name="qty_<%= item.id %>" value="<%= currentQty %>" min="0" onchange="document.getElementById('itemId').value='<%= item.id %>'; document.getElementById('menuForm').submit();">
                    </label>
                </div>
                <textarea class="note-input" name="note_<%= item.id %>" placeholder="Yêu cầu đặc biệt..."><%= currentNote %></textarea>
            </div>
            <% } %>
        </div>

        <input type="hidden" name="action" value="add">
        <input type="hidden" name="itemId" id="itemId">
    </form>
</div>

<div class="sticky-footer" id="cart">
    <div class="total">
        Tổng cộng: <span><%= formatter.format(totalPrice) %></span>
    </div>
    <div class="footer-buttons">
        <a href="trangdatban.jsp" class="btn">Quay lại Đặt bàn</a>
        <form method="post" style="display:inline;">
            <button type="submit" name="action" value="confirm" class="btn btn-confirm">
                <i class="fas fa-check-circle"></i> Xác nhận đơn hàng
            </button>
        </form>
    </div>
</div>
</body>
</html>