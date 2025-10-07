// Menu Page JavaScript

// Global variables
let currentSlide = 0;
let slideInterval;
let menuData = {};
let cart = JSON.parse(localStorage.getItem('restaurantCart')) || [];
let currentCartItem = null;

// Initialize menu page
document.addEventListener('DOMContentLoaded', function() {
    initializeSlideshow();
    loadMenuData();
    updateCartCount();
    
    // Show popular items by default
    setTimeout(() => {
        showCategory('popular');
    }, 100);
});

// Slideshow functionality
function initializeSlideshow() {
    const slides = document.querySelectorAll('.banner-slide');
    const dotsContainer = document.getElementById('dots');
    
    if (slides.length === 0) return;
    
    // Create dots
    dotsContainer.innerHTML = '';
    slides.forEach((_, index) => {
        const dot = document.createElement('span');
        dot.className = 'dot';
        if (index === 0) dot.classList.add('active');
        dot.onclick = () => goToSlide(index);
        dotsContainer.appendChild(dot);
    });
    
    // Start auto-slideshow
    startSlideshow();
}

function startSlideshow() {
    const slides = document.querySelectorAll('.banner-slide');
    if (slides.length <= 1) return;
    
    slideInterval = setInterval(() => {
        nextSlide();
    }, 5000);
}

function stopSlideshow() {
    if (slideInterval) {
        clearInterval(slideInterval);
    }
}

function nextSlide() {
    const slides = document.querySelectorAll('.banner-slide');
    currentSlide = (currentSlide + 1) % slides.length;
    updateSlidePosition();
}

function goToSlide(index) {
    currentSlide = index;
    updateSlidePosition();
    
    // Restart slideshow
    stopSlideshow();
    startSlideshow();
}

function updateSlidePosition() {
    const slidesContainer = document.getElementById('slides');
    const dots = document.querySelectorAll('.dot');
    
    if (slidesContainer) {
        slidesContainer.style.transform = `translateX(-${currentSlide * 100}%)`;
    }
    
    // Update dots
    dots.forEach((dot, index) => {
        dot.classList.toggle('active', index === currentSlide);
    });
}

// Menu data loading
function loadMenuData() {
    const menuDataElement = document.getElementById('menuData');
    if (menuDataElement) {
        try {
            menuData = JSON.parse(menuDataElement.textContent);
        } catch (error) {
            console.error('Error parsing menu data:', error);
            menuData = {};
        }
    }
}

// Dropdown functionality
function toggleDropdown() {
    const dropdownContent = document.getElementById('dropdownContent');
    const arrow = document.querySelector('.arrow');
    
    if (dropdownContent.style.display === 'block') {
        dropdownContent.style.display = 'none';
        arrow.style.transform = 'rotate(0deg)';
    } else {
        dropdownContent.style.display = 'block';
        arrow.style.transform = 'rotate(180deg)';
    }
}

// Category display functions
function showCategory(categorySlug) {
    const contentDiv = document.getElementById('content');
    const items = menuData[categorySlug] || [];
    
    if (items.length === 0) {
        contentDiv.innerHTML = `
            <h2>Category: ${categorySlug.charAt(0).toUpperCase() + categorySlug.slice(1)}</h2>
            <p class="menu-instruction">No items available in this category at the moment.</p>
        `;
        return;
    }
    
    let html = `<h2>${getCategoryDisplayName(categorySlug)}</h2><div class="menu-items">`;
    
    items.forEach(item => {
        html += createMenuItemHTML(item);
    });
    
    html += '</div>';
    contentDiv.innerHTML = html;
    
    // Close dropdown after selection
    const dropdownContent = document.getElementById('dropdownContent');
    const arrow = document.querySelector('.arrow');
    dropdownContent.style.display = 'none';
    arrow.style.transform = 'rotate(0deg)';
}

function getCategoryDisplayName(slug) {
    const categoryNames = {
        'popular': 'Most Popular Items',
        'tacos': 'Tacos Collection',
        'burritos': 'Burrito Selection',
        'tamales': 'Traditional Tamales',
        'chiles': 'Chiles en Nogada',
        'soups': 'Authentic Soups',
        'stews': 'Hearty Stews',
        'appetizers': 'Appetizers & Starters',
        'drinks': 'Beverages & Drinks'
    };
    
    return categoryNames[slug] || slug.charAt(0).toUpperCase() + slug.slice(1);
}

function createMenuItemHTML(item) {
    const isAvailable = item.isAvailable !== false;
    const formattedPrice = formatCurrency(item.price, item.currency || 'VND');
    
    return `
        <div class="menu-item">
            <div class="menu-card">
                <div class="menu-front">
                    <img src="${getContextPath()}/assets/images/menu/${item.image}" 
                         alt="${item.name}" 
                         onerror="this.src='${getContextPath()}/assets/images/menu/placeholder.jpg'">
                    <h3>${item.name}</h3>
                    ${item.isBestSeller ? '<span class="best-seller">Best Seller</span>' : ''}
                    ${!isAvailable ? '<span class="unavailable">Unavailable</span>' : ''}
                </div>
                <div class="menu-back">
                    <h3>${item.name}</h3>
                    <p>${item.description}</p>
                    <p class="price">${formattedPrice}</p>
                    <div class="food-buttons">
                        <button class="add-to-cart" 
                                onclick="openCartModal('${item.name}')" 
                                ${!isAvailable ? 'disabled' : ''}>
                            Add to Cart
                        </button>
                        <button class="buy-now" 
                                onclick="buyNow('${item.name}')" 
                                ${!isAvailable ? 'disabled' : ''}>
                            Order Now
                        </button>
                    </div>
                </div>
            </div>
        </div>
    `;
}

// Cart functionality
function openCartModal(itemName) {
    const item = findMenuItem(itemName);
    if (!item) return;
    
    currentCartItem = item;
    
    const modal = document.getElementById('cartModal');
    const itemDetails = document.getElementById('cartItemDetails');
    
    itemDetails.innerHTML = `
        <div style="display: flex; align-items: center; gap: 15px;">
            <img src="${getContextPath()}/assets/images/menu/${item.image}" 
                 alt="${item.name}" 
                 style="width: 80px; height: 80px; object-fit: cover; border-radius: 8px;"
                 onerror="this.src='${getContextPath()}/assets/images/menu/placeholder.jpg'">
            <div>
                <h4 style="margin: 0 0 5px 0; color: var(--primary-color);">${item.name}</h4>
                <p style="margin: 0; color: #666; font-size: 0.9rem;">${item.description}</p>
                <p style="margin: 5px 0 0 0; font-weight: bold; color: var(--primary-color);">
                    ${formatCurrency(item.price, item.currency || 'VND')}
                </p>
            </div>
        </div>
    `;
    
    // Reset form
    document.getElementById('quantity').value = 1;
    document.getElementById('instructions').value = '';
    
    modal.style.display = 'block';
}

function closeCartModal() {
    const modal = document.getElementById('cartModal');
    modal.style.display = 'none';
    currentCartItem = null;
}

function increaseQuantity() {
    const quantityInput = document.getElementById('quantity');
    const currentValue = parseInt(quantityInput.value);
    if (currentValue < 10) {
        quantityInput.value = currentValue + 1;
    }
}

function decreaseQuantity() {
    const quantityInput = document.getElementById('quantity');
    const currentValue = parseInt(quantityInput.value);
    if (currentValue > 1) {
        quantityInput.value = currentValue - 1;
    }
}

function confirmAddToCart() {
    if (!currentCartItem) return;
    
    const quantity = parseInt(document.getElementById('quantity').value);
    const instructions = document.getElementById('instructions').value.trim();
    
    const cartItem = {
        id: generateCartItemId(),
        name: currentCartItem.name,
        image: currentCartItem.image,
        price: currentCartItem.price,
        currency: currentCartItem.currency || 'VND',
        quantity: quantity,
        instructions: instructions,
        addedAt: new Date().toISOString()
    };
    
    // Check if item already exists in cart
    const existingItemIndex = cart.findIndex(item => 
        item.name === cartItem.name && item.instructions === cartItem.instructions
    );
    
    if (existingItemIndex > -1) {
        cart[existingItemIndex].quantity += quantity;
    } else {
        cart.push(cartItem);
    }
    
    // Save to localStorage
    localStorage.setItem('restaurantCart', JSON.stringify(cart));
    
    // Update cart count
    updateCartCount();
    
    // Show success message
    showAlert('Item added to cart successfully!', 'success');
    
    // Close modal
    closeCartModal();
}

function buyNow(itemName) {
    const item = findMenuItem(itemName);
    if (!item) return;
    
    // Add to cart first
    const cartItem = {
        id: generateCartItemId(),
        name: item.name,
        image: item.image,
        price: item.price,
        currency: item.currency || 'VND',
        quantity: 1,
        instructions: '',
        addedAt: new Date().toISOString()
    };
    
    cart.push(cartItem);
    localStorage.setItem('restaurantCart', JSON.stringify(cart));
    updateCartCount();
    
    // Redirect to checkout or cart page
    window.location.href = getContextPath() + '/cart';
}

// Utility functions
function findMenuItem(itemName) {
    for (const category in menuData) {
        const item = menuData[category].find(item => item.name === itemName);
        if (item) return item;
    }
    return null;
}

function generateCartItemId() {
    return 'cart_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9);
}

function updateCartCount() {
    const cartCountElement = document.getElementById('cart-count');
    if (cartCountElement) {
        const totalItems = cart.reduce((sum, item) => sum + item.quantity, 0);
        cartCountElement.textContent = totalItems;
    }
}

function formatCurrency(amount, currency = 'VND') {
    if (currency === 'VND') {
        return new Intl.NumberFormat('vi-VN').format(amount) + ' VND';
    }
    return new Intl.NumberFormat('en-US', {
        style: 'currency',
        currency: currency
    }).format(amount);
}

function getContextPath() {
    return window.location.pathname.substring(0, window.location.pathname.indexOf('/', 1)) || '';
}

function showAlert(message, type = 'info') {
    // Create alert element
    const alert = document.createElement('div');
    alert.className = `alert alert-${type}`;
    alert.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        padding: 15px 20px;
        background: ${type === 'success' ? '#28a745' : type === 'error' ? '#dc3545' : '#007bff'};
        color: white;
        border-radius: 8px;
        box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        z-index: 10000;
        animation: slideInRight 0.3s ease;
    `;
    alert.textContent = message;
    
    document.body.appendChild(alert);
    
    // Remove after 3 seconds
    setTimeout(() => {
        alert.style.animation = 'slideOutRight 0.3s ease';
        setTimeout(() => {
            if (alert.parentNode) {
                alert.parentNode.removeChild(alert);
            }
        }, 300);
    }, 3000);
}

// Close modal when clicking outside
window.onclick = function(event) {
    const modal = document.getElementById('cartModal');
    if (event.target === modal) {
        closeCartModal();
    }
}

// Keyboard navigation
document.addEventListener('keydown', function(event) {
    const modal = document.getElementById('cartModal');
    if (modal.style.display === 'block') {
        if (event.key === 'Escape') {
            closeCartModal();
        }
    }
});

// Add CSS animations
const style = document.createElement('style');
style.textContent = `
    @keyframes slideInRight {
        from {
            transform: translateX(100%);
            opacity: 0;
        }
        to {
            transform: translateX(0);
            opacity: 1;
        }
    }
    
    @keyframes slideOutRight {
        from {
            transform: translateX(0);
            opacity: 1;
        }
        to {
            transform: translateX(100%);
            opacity: 0;
        }
    }
`;
document.head.appendChild(style);