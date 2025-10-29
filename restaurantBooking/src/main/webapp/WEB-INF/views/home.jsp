<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nhà Hàng Của Chúng Tôi - Trang Chủ</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=Roboto:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
</head>
<body>
<!-- Header -->
<jsp:include page="common/header.jsp" />
<main>
    <!-- Welcome Section -->
    <section id="welcome">
        <div class="overlay"></div>
        <div class="welcome-content">
            <h2>WELCOME TO</h2>
            <h1>NHÀ HÀNG CỦA CHÚNG TÔI</h1>
            <p>TRẢI NGHIỆM ẨM THỰC TUYỆT VỜI</p>
        </div>
        <div class="scroll-down">
            <a href="#about"><span></span></a>
        </div>
    </section>


    <!-- About Section -->
    <section id="about">
        <div class="about-content">
            <h2>Về Chúng Tôi</h2>
            <p>Chào mừng bạn đến với nhà hàng của chúng tôi - nơi mang đến trải nghiệm ẩm thực tuyệt vời với những món ăn được chế biến từ nguyên liệu tươi ngon nhất. Với không gian ấm cúng và phục vụ chuyên nghiệp, chúng tôi cam kết mang đến cho bạn những bữa ăn đáng nhớ.</p>

            <a href="${pageContext.request.contextPath}/restaurant-detail" class="about-button">XEM CHI TIẾT NHÀ HÀNG</a>
        </div>
    </section>

    <!-- Menu Section -->
    <section id="menu">
        <div class="menu-content container">
            <h2>Món Ăn Nổi Bật</h2>
            <p class="menu-intro">Khám phá những món ăn đặc sắc được lựa chọn đặc biệt bởi các đầu bếp của chúng tôi.</p>

            <div class="menu-grid">
                <c:if test="${not empty featuredDishes}">
                    <c:forEach items="${featuredDishes}" var="dish">
                        <div class="dish-card">
                            <div class="dish-image-container">
                                <img src="${pageContext.request.contextPath}/images/dishes/${dish.imageUrl}" alt="${dish.itemName}">
                            </div>
                            <div class="dish-details">
                                <h3 class="dish-name">${dish.itemName}</h3>
                                <p class="dish-description">${dish.description}</p>
                            </div>
                            <div class="dish-footer">
                                <span class="dish-price"><fmt:formatNumber value="${dish.price}" type="currency" currencyCode="VND"/></span>
                                <button class="dish-order-btn" onclick="addToCart(${dish.itemId})">
                                    <i class="fas fa-shopping-cart"></i> Thêm vào giỏ
                                </button>
                            </div>
                        </div>
                    </c:forEach>
                </c:if>
                <c:if test="${empty featuredDishes}">
                    <p>Chưa có món ăn nổi bật nào để hiển thị.</p>
                </c:if>
            </div>

            <div class="view-full-menu">
                <a href="${pageContext.request.contextPath}/menu" class="menu-button">Xem Toàn Bộ Thực Đơn</a>
            </div>
        </div>
    </section>



    <!-- Testimonials Section -->
    <section id="testimonials" class="testimonials">
        <div class="testimonials-content">
            <h2>Khách Hàng Nói Gì</h2>
            <div class="testimonials-items">
                <div class="testimonial-card">
                    <div class="testimonial-content">
                        <p>"Món ăn rất ngon, phục vụ chu đáo. Tôi sẽ quay lại lần nữa!"</p>
                    </div>
                    <div class="testimonial-author">
                        <div class="author-avatar">
                            <img src="${pageContext.request.contextPath}/assets/images/avatar1.jpg" alt="Nguyễn Văn A" />
                        </div>
                        <div class="author-info">
                            <h4>Nguyễn Văn A</h4>
                            <span>Khách hàng thân thiết</span>
                        </div>
                    </div>
                </div>
                <div class="testimonial-card">
                    <div class="testimonial-content">
                        <p>"Không gian ấm cúng, thức ăn tuyệt vời. Rất đáng để thử!"</p>
                    </div>
                    <div class="testimonial-author">
                        <div class="author-avatar">
                            <img src="${pageContext.request.contextPath}/assets/images/avatar2.jpg" alt="Trần Thị B" />
                        </div>
                        <div class="author-info">
                            <h4>Trần Thị B</h4>
                            <span>Khách hàng mới</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Why Choose Us Section -->
    <section id="why-choose-us">
        <div class="why-choose-overlay"></div>
        <div class="why-choose-content">
            <h2>Tại Sao Chọn Chúng Tôi?</h2>
            <p>Khám phá lý do tại sao chúng tôi là lựa chọn hàng đầu cho những người yêu ẩm thực. Chúng tôi tự hào mang đến trải nghiệm ẩm thực chân thực kết hợp hoàn hảo giữa truyền thống lâu đời và chất lượng xuất sắc.</p>
            <div class="why-choose-items">
                <div class="why-choose-column left-column">
                    <div class="why-choose-item">
                        <h3>Hương Vị Tuyệt Hảo</h3>
                        <p>Với nguyên liệu tươi ngon được lựa chọn cẩn thận, mỗi món ăn đều được truyền tải tinh hoa ẩm thực với hương vị đậm đà, khó cưỡng.</p>
                    </div>
                    <div class="why-choose-item">
                        <h3>Truyền Thống Lâu Đời</h3>
                        <p>Trong hơn 30 năm qua, nhà hàng đã trở thành biểu tượng ẩm thực, được nhiều thế hệ thực khách yêu mến trên toàn thế giới.</p>
                    </div>
                </div>
                <div class="why-choose-column right-column">
                    <div class="why-choose-item">
                        <h3>Không Gian Thân Thiện</h3>
                        <p>Không gian nhà hàng rộng rãi, hiện đại và ấm cúng, lý tưởng cho bữa ăn gia đình, gặp gỡ bạn bè hay những buổi hẹn hò thư giãn.</p>
                    </div>
                    <div class="why-choose-item">
                        <h3>Chất Lượng Xuất Sắc</h3>
                        <p>Mỗi món ăn đều được chế biến tỉ mỉ, từ thịt nướng thơm lừng đến những gia vị độc đáo, đảm bảo độ tươi ngon mỗi ngày.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Container for Visit Us and Notification with Shared Video Background -->
    <div class="video-background-container">
        <video autoplay muted loop playsinline class="background-video">
            <source src="${pageContext.request.contextPath}/assets/template/tacos-background-video.mp4" type="video/mp4">
            Trình duyệt của bạn không hỗ trợ thẻ video.
        </video>

        <!-- Visit Us Section -->
        <section id="visit-us">
            <div class="visit-us-overlay"></div>
            <div class="visit-us-content">
                <h2>Tham Quan Nhà Hàng Của Chúng Tôi</h2>
                <c:if test="${not empty restaurantInfo}">
                    <div class="restaurant-info">
                        <div class="info-item">
                            <h3><i class="fas fa-map-marker-alt"></i> Địa Chỉ</h3>
                            <p>${restaurantInfo.address}</p>
                        </div>
                        <div class="info-item">
                            <h3><i class="fas fa-phone"></i> Liên Hệ</h3>
                            <p>Điện thoại: ${restaurantInfo.contactPhone}</p>
                            <p>Email: ${restaurantInfo.email}</p>
<%--                                                            <c:if test="${not empty restaurantInfo.website}">--%>
<%--                                                                <p>Website: <a href="${restaurantInfo.website}" target="_blank">${restaurantInfo.website}</a></p>--%>
<%--                                                            </c:if>--%>
                        </div>
                        <div class="info-item">
                            <h3><i class="fas fa-clock"></i> Giờ Mở Cửa</h3>
                            <p>${restaurantInfo.openHours}</p>
                        </div>
<%--                                                    <c:if test="${restaurantInfo.capacity > 0}">--%>
<%--                                                        <div class="info-item">--%>
<%--                                                            <h3><i class="fas fa-users"></i> Sức Chứa</h3>--%>
<%--                                                            <p>${restaurantInfo.capacity} khách</p>--%>
<%--                                                        </div>--%>
<%--                                                    </c:if>--%>
                    </div>
                </c:if>
                <p>Nhà hàng của chúng tôi không chỉ là nơi thưởng thức ẩm thực, mà còn là nơi lưu giữ và lan tỏa tinh hoa ẩm thực. Tại đây, bạn sẽ được thưởng thức những món ăn truyền thống với hương vị đậm đà, được chế biến từ nguyên liệu tươi ngon nhất, trong không gian ấm cúng và thân thiện. Hãy đến và khám phá nhà hàng của chúng tôi, cùng nhiều món đặc sắc khác, hứa hẹn mang đến trải nghiệm ẩm thực khó quên.</p>
            </div>
        </section>

        <!-- Receive a Notification Section -->
        <section id="notification">
            <div class="notification-overlay"></div>
            <div class="notification-section">
                <h3>Tham Gia Câu Lạc Bộ Của Chúng Tôi</h3>
                <p>Đăng ký nhận bản tin của chúng tôi để nhận ưu đãi độc quyền, món ăn mới và mẹo ẩm thực!</p>
                <form class="subscribe-form">
                    <input type="email" placeholder="Nhập địa chỉ email của bạn">
                    <button type="submit">Đăng Ký</button>
                </form>
            </div>
        </section>
    </div>
</main>

<!-- Footer -->
<jsp:include page="common/footer.jsp" />

<!-- Alert Container for notifications -->
<div id="alert-container" class="alert-container"></div>

<!-- JavaScript for smooth scrolling -->
<script>
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });

    // Update cart count
    function updateCartCount() {
        fetch('${pageContext.request.contextPath}/api/cart/count')
            .then(response => response.json())
            .then(data => {
                const cartCount = document.querySelector('.cart-count');
                if (cartCount) {
                    cartCount.textContent = data.count;
                }
            })
            .catch(error => console.error('Error updating cart count:', error));
    }

    // Form submission handling
    document.addEventListener('DOMContentLoaded', function() {
        const subscribeForm = document.querySelector('.subscribe-form');
        if (subscribeForm) {
            subscribeForm.addEventListener('submit', function(e) {
                e.preventDefault();
                const email = this.querySelector('input[type="email"]').value;

                fetch('${pageContext.request.contextPath}/subscribe', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'email=' + encodeURIComponent(email)
                })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            alert('Đăng ký thành công!');
                            this.reset();
                        } else {
                            alert('Có lỗi xảy ra. Vui lòng thử lại.');
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('Có lỗi xảy ra. Vui lòng thử lại.');
                    });
            });
        }

        // Initialize cart count
        updateCartCount();
    });
</script>

<!-- JavaScript -->

<!-- Toast Handler -->
<jsp:include page="common/toast-handler.jsp" />
</body>
</html>