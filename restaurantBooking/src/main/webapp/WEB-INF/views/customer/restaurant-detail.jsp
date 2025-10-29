<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Chi Tiết Nhà Hàng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        .detail-container { margin: 100px auto; max-width: 1100px; padding: 20px; }
        .section { margin-bottom: 50px; padding-bottom: 30px; border-bottom: 1px solid #eee; }
        .section-title { font-family: 'Playfair Display', serif; font-size: 2.5rem; text-align: center; margin-bottom: 30px; }
        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 30px; align-items: center; }
        .gallery-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 15px; }
        .gallery-grid img { width: 100%; height: 200px; object-fit: cover; border-radius: 8px; }
        .menu-list-item { display: flex; justify-content: space-between; padding: 15px 0; border-bottom: 1px dashed #ccc; }
        .review-card { background: #f9f9f9; padding: 20px; border-radius: 8px; margin-bottom: 15px; }
        .review-card .rating { color: #f39c12; }
    </style>
</head>
<body>
<jsp:include page="../common/header.jsp"/>

<div class="detail-container">
    <section class="section">
        <c:if test="${not empty restaurantInfo}">
            <div class="info-grid">
                <div>
                    <h1>${restaurantInfo.restaurantName}</h1>
                    <p><i class="fas fa-map-marker-alt"></i> ${restaurantInfo.address}</p>
                    <p><i class="fas fa-clock"></i> ${restaurantInfo.openHours}</p>
                    <p><i class="fas fa-phone"></i> ${restaurantInfo.contactPhone}</p>
                </div>
                <div>
                    <img src="${pageContext.request.contextPath}/images/restaurant-exterior.jpg" alt="Nhà hàng" style="width: 100%; border-radius: 8px;">
                </div>
            </div>
        </c:if>
    </section>

    <section class="section">
        <h2 class="section-title">Không Gian Nhà Hàng</h2>
        <div class="gallery-grid">
            <c:if test="${not empty galleryImages}">
                <c:forEach items="${galleryImages}" var="image">
                    <img src="${pageContext.request.contextPath}/images/gallery/${image.imageUrl}" alt="${image.imageTile}">
                </c:forEach>
            </c:if>
            <c:if test="${empty galleryImages}"><p>Chưa có hình ảnh nào.</p></c:if>
        </div>
    </section>

    <section class="section">
        <h2 class="section-title">Thực Đơn</h2>
        <%-- Gói danh sách món ăn vào một container --%>
        <div id="menu-list-container">
            <c:if test="${not empty menuItems}">
                <c:forEach items="${menuItems}" var="item">
                    <div class="menu-list-item">
                        <div>
                            <h4>${item.itemName}</h4>
                            <p>${item.description}</p>
                        </div>
                        <div style="font-weight: bold;">
                            <fmt:formatNumber value="${item.price}" type="currency" currencyCode="VND"/>
                        </div>
                    </div>
                </c:forEach>
            </c:if>
            <c:if test="${empty menuItems}"><p>Chưa có món ăn nào.</p></c:if>
        </div>
        <div id="menu-pagination" class="pagination"></div>
    </section>

    <section class="section" style="border-bottom: none;">
        <h2 class="section-title">Đánh Giá</h2>
        <%-- Gói danh sách review vào một container --%>
        <div id="review-list-container">
            <c:if test="${not empty reviews}">
                <c:forEach items="${reviews}" var="review">
                    <div class="review-card">
                        <div class="rating">
                            <c:forEach begin="1" end="${review.rating}"><i class="fas fa-star"></i></c:forEach>
                        </div>
                        <p>"${review.comment}"</p>
                        <small><strong>- ${review.userName}</strong></small>
                    </div>
                </c:forEach>
            </c:if>
            <c:if test="${empty reviews}"><p>Chưa có đánh giá nào.</p></c:if>
        </div>
        <%-- Thêm container cho các nút phân trang --%>
        <div id="review-pagination" class="pagination"></div>
    </section>
</div>

<jsp:include page="../common/footer.jsp"/>
</body>


</html>


<script>
    function setupPagination(containerId, paginationId, itemsPerPage) {
        const container = document.getElementById(containerId);
        const paginationContainer = document.getElementById(paginationId);
        // Lấy tất cả các item con trực tiếp của container
        const items = Array.from(container.children);
        const totalItems = items.length;

        if (totalItems <= itemsPerPage) {
            return;
        }

        const totalPages = Math.ceil(totalItems / itemsPerPage);
        let currentPage = 1;

        function showPage(page) {
            currentPage = page;
            const start = (page - 1) * itemsPerPage;
            const end = start + itemsPerPage;

            items.forEach((item, index) => {
                item.style.display = (index >= start && index < end) ? '' : 'none';
            });

            updatePaginationButtons();
        }

        function updatePaginationButtons() {
            paginationContainer.innerHTML = '';

            const prevButton = document.createElement('button');
            prevButton.innerHTML = '<i class="fas fa-chevron-left"></i>';
            prevButton.addEventListener('click', () => showPage(currentPage - 1));
            if (currentPage === 1) {
                prevButton.disabled = true;
            }
            paginationContainer.appendChild(prevButton);

            const pagesToShow = new Set();
            pagesToShow.add(1);
            pagesToShow.add(totalPages);
            pagesToShow.add(currentPage);
            if (currentPage > 1) pagesToShow.add(currentPage - 1);
            if (currentPage < totalPages) pagesToShow.add(currentPage + 1);

            const sortedPages = Array.from(pagesToShow).sort((a, b) => a - b);
            let lastPage = 0;

            sortedPages.forEach(page => {
                if (page > 0 && page <= totalPages) {
                    if (page - lastPage > 1) {
                        const ellipsis = document.createElement('span');
                        ellipsis.innerText = '...';
                        paginationContainer.appendChild(ellipsis);
                    }

                    const button = document.createElement('button');
                    button.innerText = page;
                    if (page === currentPage) {
                        button.classList.add('active');
                    }
                    button.addEventListener('click', () => showPage(page));
                    paginationContainer.appendChild(button);
                    lastPage = page;
                }
            });


            const nextButton = document.createElement('button');
            nextButton.innerHTML = '<i class="fas fa-chevron-right"></i>';
            nextButton.addEventListener('click', () => showPage(currentPage + 1));
            if (currentPage === totalPages) {
                nextButton.disabled = true;
            }
            paginationContainer.appendChild(nextButton);
        }
        showPage(1);
    }

    document.addEventListener('DOMContentLoaded', function() {
        setupPagination('menu-list-container', 'menu-pagination', 5);

        setupPagination('review-list-container', 'review-pagination', 3);
    });
</script>