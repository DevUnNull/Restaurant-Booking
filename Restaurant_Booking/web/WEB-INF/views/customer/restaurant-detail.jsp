<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi Tiết Nhà Hàng - ${restaurantInfo.restaurantName}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/restaurant-detail.css">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=Roboto:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
</head>
<body>
    <!-- Header -->
    <jsp:include page="../common/header.jsp" />
    
    <!-- Main Content -->
    <main>
        <!-- Loading overlay -->
        <div id="loading" class="loading">
            <div class="spinner"></div>
        </div>
        
        <!-- Restaurant Detail Container -->
        <div class="restaurant-detail-container">
            
            <!-- Restaurant Basic Information Section -->
            <section class="restaurant-info-section">
                <div class="container">
                    <div class="restaurant-info-card">
                        <div class="restaurant-header">
                            <h1 class="restaurant-name">${restaurantInfo.restaurantName}</h1>
                            <div class="restaurant-rating">
                                <div class="stars">
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star-half-alt"></i>
                                </div>
                                <span class="rating-text">4.5/5 (128 đánh giá)</span>
                            </div>
                        </div>
                        
                        <div class="restaurant-details">
                            <div class="detail-item">
                                <i class="fas fa-map-marker-alt"></i>
                                <div class="detail-content">
                                    <h4>Địa chỉ</h4>
                                    <p>${restaurantInfo.address}</p>
                                </div>
                            </div>
                            
                            <div class="detail-item">
                                <i class="fas fa-clock"></i>
                                <div class="detail-content">
                                    <h4>Giờ mở cửa</h4>
                                    <p>
                                        ${restaurantInfo.openingTime} - ${restaurantInfo.closingTime}
                                    </p>
                                </div>
                            </div>
                            
                            <div class="detail-item">
                                <i class="fas fa-phone"></i>
                                <div class="detail-content">
                                    <h4>Liên hệ</h4>
                                    <p>${restaurantInfo.phoneNumber}</p>
                                </div>
                            </div>
                            
                            <div class="detail-item">
                                <i class="fas fa-envelope"></i>
                                <div class="detail-content">
                                    <h4>Email</h4>
                                    <p>${restaurantInfo.email}</p>
                                </div>
                            </div>
                        </div>
                        
                        <div class="restaurant-description">
                            <h3>Giới thiệu</h3>
                            <p>${restaurantInfo.description}</p>
                        </div>
                    </div>
                </div>
            </section>
            
            <!-- Gallery Section -->
            <section class="gallery-section">
                <div class="container">
                    <h2 class="section-title">
                        <i class="fas fa-images"></i>
                        Không gian nhà hàng
                    </h2>
                    <div class="gallery-grid">
                        <c:forEach items="${galleryImages}" var="image">
                            <div class="gallery-item">
                                <img src="${pageContext.request.contextPath}/uploads/gallery/${image.imageUrl}" 
                                     alt="${image.imageName}" 
                                     class="gallery-image">
                                <div class="gallery-overlay">
                                    <h4>${image.imageName}</h4>
                                    <p>${image.description}</p>
                                </div>
                            </div>
                        </c:forEach>
                        
                        <!-- Mock gallery images for demo -->
                        <c:if test="${empty galleryImages}">
                            <div class="gallery-item">
                                <img src="https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=400" 
                                     alt="Không gian chính" class="gallery-image">
                                <div class="gallery-overlay">
                                    <h4>Không gian chính</h4>
                                    <p>Không gian ấm cúng và sang trọng</p>
                                </div>
                            </div>
                            <div class="gallery-item">
                                <img src="https://images.unsplash.com/photo-1552566626-52f8b828add9?w=400" 
                                     alt="Khu vực ăn uống" class="gallery-image">
                                <div class="gallery-overlay">
                                    <h4>Khu vực ăn uống</h4>
                                    <p>Bàn ăn được bài trí tinh tế</p>
                                </div>
                            </div>
                            <div class="gallery-item">
                                <img src="https://images.unsplash.com/photo-1577563908411-5077b6dc7624?w=400" 
                                     alt="Quầy bar" class="gallery-image">
                                <div class="gallery-overlay">
                                    <h4>Quầy bar</h4>
                                    <p>Đồ uống đa dạng và chất lượng</p>
                                </div>
                            </div>
                            <div class="gallery-item">
                                <img src="https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=400" 
                                     alt="Phòng VIP" class="gallery-image">
                                <div class="gallery-overlay">
                                    <h4>Phòng VIP</h4>
                                    <p>Không gian riêng tư cho sự kiện đặc biệt</p>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>
            </section>
            
            <!-- Menu Section -->
            <section class="menu-section">
                <div class="container">
                    <h2 class="section-title">
                        <i class="fas fa-utensils"></i>
                        Thực đơn
                    </h2>
                    
                    <div class="menu-categories">
                        <button class="category-btn active" data-category="all">Tất cả</button>
                        <button class="category-btn" data-category="appetizer">Khai vị</button>
                        <button class="category-btn" data-category="main">Món chính</button>
                        <button class="category-btn" data-category="dessert">Tráng miệng</button>
                        <button class="category-btn" data-category="drink">Đồ uống</button>
                    </div>
                    
                    <div class="menu-grid">
                        <c:forEach items="${menuItems}" var="dish">
                            <div class="menu-item" data-category="${dish.category}">
                                <div class="menu-item-image">
                                    <img src="${pageContext.request.contextPath}/uploads/menu/${dish.imageUrl}" 
                                         alt="${dish.itemName}" 
                                         onerror="this.src='data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMzAwIiBoZWlnaHQ9IjIwMCIgdmlld0JveD0iMCAwIDMwMCAyMDAiIGZpbGw9Im5vbmUiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CjxyZWN0IHdpZHRoPSIzMDAiIGhlaWdodD0iMjAwIiBmaWxsPSIjRjNGNEY2Ii8+Cjx0ZXh0IHg9IjE1MCIgeT0iMTAwIiB0ZXh0LWFuY2hvcj0ibWlkZGxlIiBkb21pbmFudC1iYXNlbGluZT0iY2VudHJhbCIgZmlsbD0iIzk0QTNCOCIgZm9udC1mYW1pbHk9IkFyaWFsIiBmb250LXNpemU9IjE0Ij5ObyBJbWFnZTwvdGV4dD4KPC9zdmc+'">
                                    <div class="menu-item-overlay">
                                        <button class="btn-add-cart" onclick="addToCart(${dish.itemId}, '${dish.itemName}', ${dish.price})">
                                            <i class="fas fa-cart-plus"></i>
                                            Thêm vào giỏ
                                        </button>
                                    </div>
                                </div>
                                <div class="menu-item-content">
                                    <h3 class="menu-item-name">${dish.itemName}</h3>
                                    <p class="menu-item-description">${dish.description}</p>
                                    <div class="menu-item-footer">
                                        <span class="menu-item-price">
                                            <fmt:formatNumber value="${dish.price}" type="currency" currencyCode="VND" />
                                        </span>
                                        <span class="menu-item-category">${dish.category}</span>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                        
                        <c:if test="${empty menuItems}">
                            <div class="no-menu-items">
                                <i class="fas fa-utensils"></i>
                                <p>Chưa có món ăn nào trong thực đơn</p>
                            </div>
                        </c:if>
                    </div>
                </div>
            </section>
            
            <!-- Reviews Section -->
            <section class="reviews-section">
                <div class="container">
                    <h2 class="section-title">
                        <i class="fas fa-star"></i>
                        Đánh giá & Bình luận
                    </h2>
                    
                    <div class="reviews-container">
                        <c:forEach items="${reviews}" var="review">
                            <div class="review-item">
                                <div class="review-header">
                                    <div class="reviewer-info">
                                        <div class="reviewer-avatar">
                                            <img src="https://ui-avatars.com/api/?name=${review.userId}&background=random&size=50" 
                                                 alt="Avatar">
                                        </div>
                                        <div class="reviewer-details">
                                            <h4>User ${review.userId}</h4>
                                            <div class="review-rating">
                                                <c:forEach begin="1" end="5" var="i">
                                                    <i class="fas fa-star ${i <= review.rating ? 'active' : ''}"></i>
                                                </c:forEach>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="review-date">
                                        ${review.createdAt.dayOfMonth}/${review.createdAt.monthValue}/${review.createdAt.year}
                                    </div>
                                </div>
                                <div class="review-content">
                                    <p>${review.comment}</p>
                                </div>
                            </div>
                        </c:forEach>
                        
                        <!-- Mock reviews for demo -->
                        <c:if test="${empty reviews}">
                            <div class="review-item">
                                <div class="review-header">
                                    <div class="reviewer-info">
                                        <div class="reviewer-avatar">
                                            <img src="https://ui-avatars.com/api/?name=Nguyen+Van+A&background=random&size=50" 
                                                 alt="Avatar">
                                        </div>
                                        <div class="reviewer-details">
                                            <h4>Nguyễn Văn A</h4>
                                            <div class="review-rating">
                                                <i class="fas fa-star active"></i>
                                                <i class="fas fa-star active"></i>
                                                <i class="fas fa-star active"></i>
                                                <i class="fas fa-star active"></i>
                                                <i class="fas fa-star active"></i>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="review-date">
                                        15/03/2024
                                    </div>
                                </div>
                                <div class="review-content">
                                    <p>Nhà hàng rất đẹp, món ăn ngon, phục vụ chuyên nghiệp. Sẽ quay lại lần sau!</p>
                                </div>
                            </div>
                            
                            <div class="review-item">
                                <div class="review-header">
                                    <div class="reviewer-info">
                                        <div class="reviewer-avatar">
                                            <img src="https://ui-avatars.com/api/?name=Tran+Thi+B&background=random&size=50" 
                                                 alt="Avatar">
                                        </div>
                                        <div class="reviewer-details">
                                            <h4>Trần Thị B</h4>
                                            <div class="review-rating">
                                                <i class="fas fa-star active"></i>
                                                <i class="fas fa-star active"></i>
                                                <i class="fas fa-star active"></i>
                                                <i class="fas fa-star active"></i>
                                                <i class="fas fa-star"></i>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="review-date">
                                        10/03/2024
                                    </div>
                                </div>
                                <div class="review-content">
                                    <p>Không gian ấm cúng, phù hợp cho buổi hẹn hò. Giá cả hợp lý.</p>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>
            </section>
            
        </div>
    </main>
    
    <!-- Footer -->
    <jsp:include page="../common/footer.jsp" />
    
    <!-- Alert Container for notifications -->
    <div id="alert-container" class="alert-container"></div>
    
    <!-- Toast Handler -->
    <jsp:include page="../common/toast-handler.jsp" />
    
    <script>
        // Menu category filtering
        document.addEventListener('DOMContentLoaded', function() {
            const categoryButtons = document.querySelectorAll('.category-btn');
            const menuItems = document.querySelectorAll('.menu-item');
            
            categoryButtons.forEach(button => {
                button.addEventListener('click', function() {
                    const category = this.getAttribute('data-category');
                    
                    // Update active button
                    categoryButtons.forEach(btn => btn.classList.remove('active'));
                    this.classList.add('active');
                    
                    // Filter menu items
                    menuItems.forEach(item => {
                        if (category === 'all' || item.getAttribute('data-category') === category) {
                            item.style.display = 'block';
                        } else {
                            item.style.display = 'none';
                        }
                    });
                });
            });
        });
        
        // Add to cart function
        function addToCart(itemId, itemName, price) {
            // Implementation for adding to cart
            showToast(`Đã thêm ${itemName} vào giỏ hàng`, 'success');
        }
        
        // Gallery image click handler
        document.querySelectorAll('.gallery-item').forEach(item => {
            item.addEventListener('click', function() {
                const img = this.querySelector('.gallery-image');
                const modal = document.createElement('div');
                modal.className = 'image-modal';
                modal.innerHTML = `
                    <div class="modal-content">
                        <span class="close-modal">&times;</span>
                        <img src="${img.src}" alt="${img.alt}" class="modal-image">
                        <div class="modal-caption">${img.alt}</div>
                    </div>
                `;
                document.body.appendChild(modal);
                
                modal.querySelector('.close-modal').addEventListener('click', function() {
                    modal.remove();
                });
                
                modal.addEventListener('click', function(e) {
                    if (e.target === modal) {
                        modal.remove();
                    }
                });
            });
        });
    </script>
</body>
</html>