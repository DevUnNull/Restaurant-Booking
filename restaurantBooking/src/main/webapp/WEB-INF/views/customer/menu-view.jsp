<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<head>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #e4e9f0 100%);
            margin: 0;
            padding: 0;
            line-height: 1.6;
        }
        .menu-page {
            max-width: 1280px;
            margin: 60px auto;
            padding: 0 24px;
            animation: fadeIn 0.5s ease-in-out;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .menu-page h2 {
            font-size: 2.5rem;
            color: #1a2a44;
            text-align: center;
            margin-bottom: 40px;
            font-weight: 700;
            position: relative;
        }
        .menu-page h2::after {
            content: '';
            width: 60px;
            height: 4px;
            background: #e74c3c;
            position: absolute;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
            border-radius: 2px;
        }
        .filter-container {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 16px;
            margin-bottom: 40px;
            flex-wrap: wrap;
        }
        .category-filter {
            display: flex;
            gap: 12px;
            align-items: center;
            flex-wrap: wrap;
        }
        .category-filter a {
            padding: 12px 24px;
            border: 2px solid #e0e0e0;
            border-radius: 30px;
            text-decoration: none;
            color: #1a2a44;
            font-size: 0.95rem;
            font-weight: 500;
            transition: all 0.3s ease;
            background: #fff;
        }
        .category-filter a:hover,
        .category-filter a.active {
            background: #e74c3c;
            color: #fff;
            border-color: #e74c3c;
            box-shadow: 0 4px 12px rgba(231, 76, 60, 0.3);
            transform: scale(1.05);
        }
        .sort-container {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .sort-container label {
            color: #1a2a44;
            font-size: 0.95rem;
            font-weight: 500;
        }
        .sort-container select {
            padding: 12px 16px;
            border-radius: 30px;
            border: 2px solid #e0e0e0;
            background: #fff;
            color: #1a2a44;
            font-size: 0.95rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .sort-container select:hover,
        .sort-container select:focus {
            border-color: #e74c3c;
            box-shadow: 0 0 8px rgba(231, 76, 60, 0.2);
            outline: none;
        }
        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 24px;
        }
        .card {
            background: #fff;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
            transition: transform 0.4s ease, box-shadow 0.4s ease;
            position: relative;
        }
        .card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 24px rgba(0, 0, 0, 0.2);
        }
        .card img {
            width: 100%;
            height: 200px;
            object-fit: cover;
            transition: transform 0.3s ease;
        }
        .card:hover img {
            transform: scale(1.05);
        }
        .card-content {
            padding: 20px;
        }
        .card-content .item-name {
            font-size: 1.3rem;
            font-weight: 600;
            color: #1a2a44;
            margin-bottom: 10px;
            display: -webkit-box;
            -webkit-line-clamp: 1;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        .card-content .description {
            font-size: 0.9rem;
            color: #6b7280;
            line-height: 1.5;
            min-height: 48px;
            margin-bottom: 12px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        .card-content .price-status {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .card-content .price {
            font-size: 1.15rem;
            font-weight: 600;
            color: #e74c3c;
        }
        .card-content .status {
            font-size: 0.85rem;
            color: #6b7280;
            background: #f1f3f5;
            padding: 4px 12px;
            border-radius: 12px;
        }
        .pagination {
            display: flex;
            justify-content: center;
            gap: 12px;
            margin: 40px 0;
        }
        .pagination a {
            padding: 12px 18px;
            border: 2px solid #e0e0e0;
            border-radius: 12px;
            text-decoration: none;
            color: #1a2a44;
            font-weight: 500;
            transition: all 0.3s ease;
            background: #fff;
        }
        .pagination a:hover,
        .pagination a.active {
            background: #e74c3c;
            color: #fff;
            border-color: #e74c3c;
            box-shadow: 0 4px 12px rgba(231, 76, 60, 0.3);
        }
        @media (max-width: 768px) {
            .menu-page {
                margin: 40px auto;
                padding: 0 16px;
            }
            .menu-page h2 {
                font-size: 2rem;
            }
            .filter-container {
                justify-content: center;
            }
            .category-filter {
                justify-content: center;
            }
            .grid {
                grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
                gap: 16px;
            }
            .card img {
                height: 160px;
            }
        }
        @media (max-width: 480px) {
            .sort-container label {
                display: none; /* Ẩn label trên màn hình nhỏ để tiết kiệm không gian */
            }
            .sort-container select {
                padding: 10px 12px;
                font-size: 0.9rem;
            }
        }
    </style>
</head>
<jsp:include page="../common/header.jsp" />
<div class="menu-page">
    <h2>Thực đơn</h2>
    <div class="filter-container">
        <div class="category-filter">
            <a href="${pageContext.request.contextPath}/menu?categoryId=0&sort=${sort}"
               class="${selectedCategoryId == 0 ? 'active' : ''}">Tất cả</a>
            <c:forEach var="c" items="${listMenuCategory}">
                <a href="${pageContext.request.contextPath}/menu?categoryId=${c.id_menuCategory}&sort=${sort}"
                   class="${selectedCategoryId == c.id_menuCategory ? 'active' : ''}">
                        ${c.categoryName}
                </a>
            </c:forEach>
            <div class="sort-container">
                <label for="sort">Sắp xếp:</label>
                <select id="sort" onchange="onChangeSort(this.value)">
                    <option value="" ${sort == '' ? 'selected' : ''}>Mặc định</option>
                    <option value="ASC" ${sort == 'ASC' ? 'selected' : ''}>Giá tăng dần</option>
                    <option value="DESC" ${sort == 'DESC' ? 'selected' : ''}>Giá giảm dần</option>
                </select>
            </div>
        </div>
    </div>
    <div class="grid">
        <c:forEach var="item" items="${menuList}">
            <div class="card">
                <img src="${pageContext.request.contextPath}/images/${empty item.imageUrl ? 'no-image.png' : item.imageUrl}"
                     alt="${item.itemName}">
                <div class="card-content">
                    <div class="item-name">${item.itemName}</div>
                    <div class="description">${item.description}</div>
                    <div class="price-status">
                        <span class="price">${item.price} đ</span>
                        <span class="status">${item.status}</span>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
    <c:if test="${totalPages > 1}">
        <div class="pagination">
            <c:if test="${currentPage > 1}">
                <a href="${pageContext.request.contextPath}/menu?categoryId=${selectedCategoryId}&page=${currentPage - 1}&sort=${sort}">Trước</a>
            </c:if>
            <c:forEach var="i" begin="1" end="${totalPages}">
                <a href="${pageContext.request.contextPath}/menu?categoryId=${selectedCategoryId}&page=${i}&sort=${sort}"
                   class="${i == currentPage ? 'active' : ''}">${i}</a>
            </c:forEach>
            <c:if test="${currentPage < totalPages}">
                <a href="${pageContext.request.contextPath}/menu?categoryId=${selectedCategoryId}&page=${currentPage + 1}&sort=${sort}">Sau</a>
            </c:if>
        </div>
    </c:if>
</div>
<script>
    function onChangeSort(val) {
        const params = new URLSearchParams(window.location.search);
        params.set('sort', val);
        params.set('page', '1');
        if (!params.has('categoryId')) {
            params.set('categoryId', '${selectedCategoryId}');
        }
        window.location.href = '${pageContext.request.contextPath}/menu?' + params.toString();
    }
</script>
<jsp:include page="../common/footer.jsp" />