<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- Set page attributes for layout -->
<c:set var="pageTitle" value="Home" scope="request" />
<c:set var="pageDescription" value="Welcome to Restaurant Booking - Experience authentic flavors and exceptional service" scope="request" />
<c:set var="bodyClass" value="home-page" scope="request" />

<!-- Welcome Section -->
<section id="welcome" class="welcome-section">
    <div class="welcome-overlay"></div>
    <video class="welcome-video" autoplay muted loop>
        <source src="${pageContext.request.contextPath}/assets/videos/tacos-background-video.mp4" type="video/mp4">
    </video>
    <div class="welcome-content">
        <h2 class="welcome-subtitle">WELCOME TO</h2>
        <h1 class="welcome-title">RESTAURANT BOOKING</h1>
        <p class="welcome-description">THE AUTHENTIC DINING EXPERIENCE</p>
        <div class="welcome-actions">
            <a href="${pageContext.request.contextPath}/reservation" class="btn btn-primary btn-large">Book a Table</a>
            <a href="${pageContext.request.contextPath}/menu" class="btn btn-outline btn-large">View Menu</a>
        </div>
    </div>
    <div class="scroll-down">
        <a href="#about" class="scroll-indicator">
            <span class="scroll-arrow"></span>
        </a>
    </div>
</section>

<!-- About Section -->
<section id="about" class="about-section">
    <div class="container">
        <div class="about-content">
            <div class="about-text">
                <h2 class="section-title">About Our Restaurant</h2>
                <p class="about-description">
                    Our restaurant is one of the most celebrated dining establishments, offering you a special culinary experience 
                    with authentic flavors and exceptional service. Established with a passion for great food, we have become 
                    an icon of fine dining, serving not only locals but also visitors from all over the world. We are proud 
                    to bring you exceptional dishes made with fresh ingredients and traditional recipes, creating unforgettable 
                    flavors that represent the best of culinary culture.
                </p>
                <a href="#why-choose-us" class="btn btn-secondary">More About Us</a>
            </div>
            <div class="about-image">
                <img src="${pageContext.request.contextPath}/assets/images/banner/banner1.webp" alt="Restaurant Interior" class="img-responsive">
            </div>
        </div>
    </div>
</section>

<!-- Featured Menu Section -->
<section id="menu" class="featured-menu-section">
    <div class="menu-overlay"></div>
    <div class="container">
        <div class="menu-content">
            <h2 class="section-title text-center">Our Signature Dishes</h2>
            <p class="menu-intro text-center">
                Every dish is carefully prepared with the finest ingredients, from the freshest produce to the finest spices. 
                Our signature dishes represent the perfect blend of traditional techniques and modern culinary innovation.
            </p>
            
            <div class="menu-grid">
                <c:forEach var="dish" items="${featuredDishes}" varStatus="status">
                    <div class="menu-item">
                        <div class="menu-card">
                            <div class="menu-front">
                                <img src="${pageContext.request.contextPath}/assets/images/menu/${dish.imageUrl}" alt="${dish.itemName}" class="menu-image">
                                <h3 class="menu-title">${dish.itemName}</h3>
                                <span class="best-seller">Best Seller</span>
                                <div class="menu-price">
                                    <fmt:formatNumber value="${dish.price}" type="currency" currencySymbol="$" />
                                </div>
                            </div>
                            <div class="menu-back">
                                <h3 class="menu-title">${dish.itemName}</h3>
                                <p class="menu-description">${dish.description}</p>
                                <div class="menu-actions">
                                    <button class="btn btn-primary btn-small" onclick="RestaurantApp.addToCart(${dish.itemId})">
                                        Add to Cart
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
                
                <!-- Default items if no featured dishes available -->
                <c:if test="${empty featuredDishes}">
                    <div class="menu-item">
                        <div class="menu-card">
                            <div class="menu-front">
                                <img src="${pageContext.request.contextPath}/assets/images/menu/tacos-al-pastor.jpg" alt="Signature Dish" class="menu-image">
                                <h3 class="menu-title">Signature Dish</h3>
                                <span class="best-seller">Best Seller</span>
                                <div class="menu-price">$12.99</div>
                            </div>
                            <div class="menu-back">
                                <h3 class="menu-title">Signature Dish</h3>
                                <p class="menu-description">Our most popular dish, prepared with the finest ingredients and traditional techniques.</p>
                                <div class="menu-actions">
                                    <button class="btn btn-primary btn-small" onclick="RestaurantApp.addToCart(1)">
                                        Add to Cart
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:if>
            </div>
            
            <div class="menu-cta text-center">
                <a href="${pageContext.request.contextPath}/menu" class="btn btn-primary btn-large">View Full Menu</a>
            </div>
        </div>
    </div>
</section>

<!-- Why Choose Us Section -->
<section id="why-choose-us" class="features-section">
    <div class="container">
        <h2 class="section-title text-center">Why Choose Us</h2>
        <div class="features-grid">
            <div class="feature-item">
                <div class="feature-icon"><i class="fas fa-utensils"></i></div>
                <h3 class="feature-title">Fresh Ingredients</h3>
                <p class="feature-description">We source only the freshest, highest-quality ingredients for all our dishes.</p>
            </div>
            <div class="feature-item">
                <div class="feature-icon"><i class="fas fa-user-chef"></i></div>
                <h3 class="feature-title">Expert Chefs</h3>
                <p class="feature-description">Our experienced chefs bring passion and expertise to every dish they create.</p>
            </div>
            <div class="feature-item">
                <div class="feature-icon"><i class="fas fa-trophy"></i></div>
                <h3 class="feature-title">Award Winning</h3>
                <p class="feature-description">Recognized for excellence in food quality and customer service.</p>
            </div>
            <div class="feature-item">
                <div class="feature-icon"><i class="fas fa-shipping-fast"></i></div>
                <h3 class="feature-title">Fast Delivery</h3>
                <p class="feature-description">Quick and reliable delivery service to bring our food to your doorstep.</p>
            </div>
        </div>
    </div>
</section>

<!-- Member Benefits Section -->
<section class="benefits-section">
    <div class="container">
        <h2 class="section-title text-center">Member Benefits</h2>
        <div class="benefits-grid">
            <div class="benefit-item">
                <div class="benefit-icon"><i class="fas fa-percent"></i></div>
                <h3 class="benefit-title">Member Discounts</h3>
                <p class="benefit-description">Enjoy exclusive discounts and special offers as a valued member.</p>
            </div>
            <div class="benefit-item">
                <div class="benefit-icon"><i class="fas fa-bolt"></i></div>
                <h3 class="benefit-title">Priority Service</h3>
                <p class="benefit-description">Skip the queue with priority service for all your orders.</p>
            </div>
            <div class="benefit-item">
                <div class="benefit-icon"><i class="fas fa-gift"></i></div>
                <h3 class="benefit-title">Birthday Rewards</h3>
                <p class="benefit-description">Celebrate your special day with complimentary dishes and treats.</p>
            </div>
            <div class="benefit-item">
                <div class="benefit-icon"><i class="fas fa-calendar-alt"></i></div>
                <h3 class="benefit-title">Early Access</h3>
                <p class="benefit-description">Get early access to new menu items and seasonal specials.</p>
            </div>
        </div>
    </div>
</section>

<!-- Call to Action Section -->
<section class="cta-section">
    <div class="container">
        <div class="cta-content text-center">
            <h2 class="cta-title">Ready for an Amazing Dining Experience?</h2>
            <p class="cta-description">Book your table now and enjoy our exceptional food and service.</p>
            <div class="cta-actions">
                <a href="${pageContext.request.contextPath}/reservation" class="btn btn-primary btn-large">Make Reservation</a>
                <a href="${pageContext.request.contextPath}/contact" class="btn btn-outline btn-large">Contact Us</a>
            </div>
        </div>
    </div>
</section>

<!-- Page-specific CSS -->
<c:set var="pageCss" value="${['home.css']}" scope="request" />

<!-- Page-specific JavaScript -->
<c:set var="pageJs" value="${['home.js']}" scope="request" />

<!-- Inline JavaScript for dynamic functionality -->
<c:set var="inlineJs" scope="request">
    // Initialize home page specific functionality
    document.addEventListener('DOMContentLoaded', function() {
        // Smooth scrolling for anchor links
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
        
        // Auto-play welcome video
        const video = document.querySelector('.welcome-video');
        if (video) {
            video.play().catch(e => console.log('Video autoplay failed:', e));
        }
    });
</c:set>