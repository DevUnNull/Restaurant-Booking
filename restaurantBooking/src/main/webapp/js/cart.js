// Cart Page JavaScript

document.addEventListener('DOMContentLoaded', function() {
    initializeCart();
    updateCartDisplay();
});

// Cart management
let cart = [];

// Menu prices (should match server-side data)
const menuPrices = {
    "Taco al Pastor": 35000,
    "Taco de Carnitas": 40000,
    "Taco de Pescado": 48000,
    "Taco de Barbacoa": 45000,
    "Taco de Birria": 50000,
    "Taco de Asada": 42000,
    "Taco de Camarón": 55000,
    "Taco de Lengua": 50000,
    "Taco de Chorizo": 40000,
    "Taco de Nopales": 38000,
    "Burrito de Carne Asada": 120000,
    "Burrito de Pollo": 110000,
    "Burrito de Barbacoa": 130000,
    "Burrito de Chorizo y Papas": 115000,
    "Burrito Vegetariano": 100000,
    "Burrito de Camarones": 135000,
    "Burrito de Carnitas": 125000,
    "Burrito de Frijoles y Queso": 90000,
    "Burrito de Huevo": 95000,
    "Burrito Supremo": 150000,
    "Tamales Verdes": 30000,
    "Tamales Rojos": 35000,
    "Tamales de Rajas": 32000,
    "Tamales de Dulce": 28000,
    "Tamales de Elote": 29000,
    "Tamales Oaxaqueños": 40000,
    "Tamales de Cambray": 38000,
    "Tamales de Chicharrón": 36000,
    "Tamales de Frijoles": 30000,
    "Tamales de Chocolate": 33000,
    "Chiles en Nogada": 200000,
    "Chiles en Nogada de Pollo": 190000,
    "Chiles en Nogada Vegetariano": 175000,
    "Chiles en Nogada con Queso": 185000,
    "Chiles en Nogada con Frutas": 195000,
    "Chiles en Nogada con Nuez Pecana": 205000,
    "Chiles en Nogada con Mole": 210000,
    "Chiles en Nogada de Pavo": 220000,
    "Chiles en Nogada con Amaranto": 190000,
    "Pozole": 110000,
    "Menudo": 120000,
    "Caldo de Res": 115000,
    "Sopa de Tortilla": 100000,
    "Caldo de Pollo": 105000,
    "Birria": 130000,
    "Mole Poblano": 140000,
    "Cochinita Pibil": 135000,
    "Carne Guisada": 125000,
    "Albondigas": 120000,
    "Guacamole": 50000,
    "Queso Fundido": 85000,
    "Ceviche": 100000,
    "Tostadas": 65000,
    "Elote": 45000,
    "Pico de Gallo": 40000,
    "Totopos con Salsa": 35000,
    "Esquites": 40000,
    "Tlacoyos": 55000,
    "Sopes": 60000,
    "Horchata": 35000,
    "Agua Fresca": 30000,
    "Margarita": 80000,
    "Michelada": 60000,
    "Coca Cola": 25000,
    "Sprite": 25000
};

function initializeCart() {
    // Load cart from localStorage or use server-side data
    if (window.cartData && window.cartData.items) {
        cart = window.cartData.items;
    } else {
        cart = JSON.parse(localStorage.getItem('cart')) || [];
    }
    
    // Update cart count in header
    updateCartCount();
}

function updateCartDisplay() {
    const cartItemsContainer = document.getElementById('cart-items');
    const subtotalElement = document.getElementById('subtotal-price');
    const taxElement = document.getElementById('tax-price');
    const totalElement = document.getElementById('total-price');
    
    if (!cartItemsContainer) return;
    
    // Clear existing items
    cartItemsContainer.innerHTML = '';
    
    if (cart.length === 0) {
        cartItemsContainer.innerHTML = `
            <div class="empty-cart">
                <p>Your shopping cart is empty.</p>
                <a href="${window.cartData?.contextPath || ''}/menu" class="btn btn-primary">Browse Menu</a>
            </div>
        `;
        updateTotals(0);
        return;
    }
    
    // Render cart items
    cart.forEach((item, index) => {
        const itemElement = createCartItemElement(item, index);
        cartItemsContainer.appendChild(itemElement);
    });
    
    // Update totals
    const subtotal = calculateSubtotal();
    updateTotals(subtotal);
}

function createCartItemElement(item, index) {
    const itemDiv = document.createElement('div');
    itemDiv.className = 'cart-item';
    itemDiv.setAttribute('data-item-id', item.id || index);
    
    const contextPath = window.cartData?.contextPath || '';
    const price = item.price || menuPrices[item.name] || 0;
    const quantity = item.quantity || 1;
    
    itemDiv.innerHTML = `
        <img src="${contextPath}/assets/images/menu/${item.image || 'default.jpg'}" 
             alt="${item.name}" class="item-image">
        <div class="item-details">
            <h3 class="item-name">${item.name}</h3>
            <p class="item-description">${item.description || ''}</p>
        </div>
        <div class="item-quantity">
            <button type="button" class="quantity-btn decrease" onclick="updateQuantity(${index}, -1)">-</button>
            <span class="quantity">${quantity}</span>
            <button type="button" class="quantity-btn increase" onclick="updateQuantity(${index}, 1)">+</button>
        </div>
        <div class="item-price">
            ${formatCurrency(price * quantity)}
        </div>
        <button type="button" class="remove-btn" onclick="removeItem(${index})">
            Remove
        </button>
    `;
    
    return itemDiv;
}

function updateQuantity(index, change) {
    if (index < 0 || index >= cart.length) return;
    
    const item = cart[index];
    const newQuantity = (item.quantity || 1) + change;
    
    if (newQuantity <= 0) {
        removeItem(index);
        return;
    }
    
    item.quantity = newQuantity;
    saveCart();
    updateCartDisplay();
    showMessage('Quantity updated successfully', 'success');
}

function removeItem(index) {
    if (index < 0 || index >= cart.length) return;
    
    // Add removing animation
    const itemElement = document.querySelector(`[data-item-id="${cart[index].id || index}"]`);
    if (itemElement) {
        itemElement.classList.add('removing');
        setTimeout(() => {
            cart.splice(index, 1);
            saveCart();
            updateCartDisplay();
            showMessage('Item removed from cart', 'success');
        }, 300);
    } else {
        cart.splice(index, 1);
        saveCart();
        updateCartDisplay();
        showMessage('Item removed from cart', 'success');
    }
}

function clearCart() {
    if (cart.length === 0) {
        showMessage('Cart is already empty', 'error');
        return;
    }
    
    if (confirm('Are you sure you want to clear all items from your cart?')) {
        cart = [];
        saveCart();
        updateCartDisplay();
        showMessage('Cart cleared successfully', 'success');
    }
}

function calculateSubtotal() {
    return cart.reduce((total, item) => {
        const price = item.price || menuPrices[item.name] || 0;
        const quantity = item.quantity || 1;
        return total + (price * quantity);
    }, 0);
}

function updateTotals(subtotal) {
    const tax = subtotal * 0.1; // 10% tax
    const total = subtotal + tax;
    
    const subtotalElement = document.getElementById('subtotal-price');
    const taxElement = document.getElementById('tax-price');
    const totalElement = document.getElementById('total-price');
    
    if (subtotalElement) subtotalElement.textContent = formatCurrency(subtotal);
    if (taxElement) taxElement.textContent = formatCurrency(tax);
    if (totalElement) totalElement.textContent = formatCurrency(total);
}

function saveCart() {
    localStorage.setItem('cart', JSON.stringify(cart));
    updateCartCount();
}

function updateCartCount() {
    const cartCountElement = document.getElementById('cart-count');
    if (cartCountElement) {
        const totalItems = cart.reduce((sum, item) => sum + (item.quantity || 1), 0);
        cartCountElement.textContent = totalItems;
    }
}

function formatCurrency(amount) {
    return new Intl.NumberFormat('vi-VN', {
        style: 'currency',
        currency: 'VND',
        minimumFractionDigits: 0
    }).format(amount);
}

function showMessage(message, type = 'success') {
    // Remove existing messages
    const existingMessage = document.querySelector('.cart-message');
    if (existingMessage) {
        existingMessage.remove();
    }
    
    // Create new message
    const messageDiv = document.createElement('div');
    messageDiv.className = `cart-message ${type}`;
    messageDiv.textContent = message;
    
    // Insert at the top of the cart container
    const cartContainer = document.querySelector('.cart-container');
    if (cartContainer) {
        cartContainer.insertBefore(messageDiv, cartContainer.firstChild);
        
        // Auto-remove after 3 seconds
        setTimeout(() => {
            if (messageDiv.parentNode) {
                messageDiv.remove();
            }
        }, 3000);
    }
}

// Checkout functionality
function proceedToCheckout() {
    if (cart.length === 0) {
        showMessage('Your cart is empty. Please add items before checkout.', 'error');
        return;
    }
    
    // Save cart for checkout page
    localStorage.setItem('checkoutItems', JSON.stringify(cart));
    
    // Redirect to checkout
    const contextPath = window.cartData?.contextPath || '';
    window.location.href = `${contextPath}/checkout`;
}

// Export functions for global access
window.updateQuantity = updateQuantity;
window.removeItem = removeItem;
window.clearCart = clearCart;
window.proceedToCheckout = proceedToCheckout;