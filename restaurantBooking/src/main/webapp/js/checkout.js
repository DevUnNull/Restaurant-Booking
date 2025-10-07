// Checkout Page JavaScript

// Menu prices for calculation
const menuPrices = {
    'Carne Asada Taco': 45000,
    'Carnitas Taco': 42000,
    'Pollo Taco': 40000,
    'Pescado Taco': 48000,
    'Veggie Taco': 38000,
    'Carne Asada Burrito': 85000,
    'Carnitas Burrito': 82000,
    'Pollo Burrito': 80000,
    'Bean Burrito': 75000,
    'Breakfast Burrito': 78000,
    'Pork Tamale': 35000,
    'Chicken Tamale': 35000,
    'Cheese Tamale': 32000,
    'Sweet Tamale': 30000
};

// Restaurant location for distance calculation
const restaurantLocation = {
    lat: 21.03578588599425,
    lng: 105.83841731540213
};

// Initialize checkout page
document.addEventListener('DOMContentLoaded', function() {
    initializePaymentTabs();
    loadOrderSummary();
    setupFormValidation();
    setupAddressCalculation();
    generateOrderCode();
});

// Initialize payment method tabs
function initializePaymentTabs() {
    const paymentMethods = document.querySelectorAll('.payment-method');
    const tabContents = document.querySelectorAll('.tab-content');
    
    paymentMethods.forEach(method => {
        method.addEventListener('click', function() {
            const tabId = this.dataset.tab;
            
            // Remove active class from all methods and tabs
            paymentMethods.forEach(m => m.classList.remove('active'));
            tabContents.forEach(t => t.classList.remove('active'));
            
            // Add active class to clicked method and corresponding tab
            this.classList.add('active');
            document.getElementById(tabId).classList.add('active');
            
            // Update hidden payment method field
            document.getElementById('payment-method-data').value = tabId;
        });
    });
}

// Load order summary from localStorage or server data
function loadOrderSummary() {
    let cartItems = [];
    
    // Try to get from server data first
    if (window.checkoutData && window.checkoutData.orderItems) {
        cartItems = window.checkoutData.orderItems;
    } else {
        // Fallback to localStorage
        const savedCart = localStorage.getItem('cart');
        if (savedCart) {
            cartItems = JSON.parse(savedCart);
        }
    }
    
    displayOrderItems(cartItems);
    calculateTotals(cartItems);
}

// Display order items in summary
function displayOrderItems(items) {
    const orderSummary = document.getElementById('order-summary');
    
    if (!items || items.length === 0) {
        orderSummary.innerHTML = '<div class="empty-order"><p>No items in your order.</p></div>';
        return;
    }
    
    let html = '';
    items.forEach(item => {
        const price = menuPrices[item.name] || item.price || 0;
        const total = price * item.quantity;
        
        html += `
            <div class="order-item">
                <div class="item-info">
                    <div class="item-image">
                        <img src="${getImagePath(item.image || item.name)}" alt="${item.name}">
                    </div>
                    <div class="item-details">
                        <div class="item-name">${item.name}</div>
                        <div class="item-quantity">Qty: ${item.quantity}</div>
                    </div>
                </div>
                <div class="item-price">${formatCurrency(total)}</div>
            </div>
        `;
    });
    
    orderSummary.innerHTML = html;
    
    // Store order items data for form submission
    document.getElementById('order-items-data').value = JSON.stringify(items);
}

// Calculate and display totals
function calculateTotals(items) {
    let subtotal = 0;
    
    items.forEach(item => {
        const price = menuPrices[item.name] || item.price || 0;
        subtotal += price * item.quantity;
    });
    
    const tax = subtotal * 0.1; // 10% tax
    const shippingFee = parseFloat(document.getElementById('shipping-fee-data').value) || 0;
    const total = subtotal + tax + shippingFee;
    
    // Update display
    document.getElementById('subtotal').textContent = formatCurrency(subtotal);
    document.getElementById('tax').textContent = formatCurrency(tax);
    document.getElementById('shipping').textContent = formatCurrency(shippingFee);
    document.getElementById('total').textContent = formatCurrency(total);
    document.getElementById('total-to-pay').textContent = formatCurrency(total);
    
    // Update hidden form fields
    document.getElementById('subtotal-data').value = subtotal;
    document.getElementById('total-data').value = total;
}

// Setup address input for distance calculation
function setupAddressCalculation() {
    const addressInput = document.getElementById('delivery-address');
    let debounceTimer;
    
    addressInput.addEventListener('input', function() {
        clearTimeout(debounceTimer);
        debounceTimer = setTimeout(() => {
            if (this.value.trim().length > 10) {
                calculateDistance(this.value.trim());
            }
        }, 1000);
    });
}

// Calculate distance and shipping fee
async function calculateDistance(address) {
    try {
        // Get coordinates for the address using Nominatim API
        const response = await fetch(`https://nominatim.openstreetmap.org/search?format=json&q=${encodeURIComponent(address)}&limit=1`);
        const data = await response.json();
        
        if (data && data.length > 0) {
            const customerLat = parseFloat(data[0].lat);
            const customerLng = parseFloat(data[0].lon);
            
            // Calculate distance using Haversine formula
            const distance = haversineDistance(
                restaurantLocation.lat, restaurantLocation.lng,
                customerLat, customerLng
            );
            
            // Calculate shipping fee (15,000 VND per km, minimum 20,000 VND)
            const shippingFee = Math.max(20000, Math.round(distance * 15000));
            
            // Update display
            document.getElementById('distance').textContent = `${distance.toFixed(1)} km`;
            document.getElementById('shipping-fee').textContent = formatCurrency(shippingFee);
            document.getElementById('shipping-fee-data').value = shippingFee;
            
            // Recalculate totals
            const savedCart = localStorage.getItem('cart');
            const cartItems = savedCart ? JSON.parse(savedCart) : [];
            calculateTotals(cartItems);
        }
    } catch (error) {
        console.error('Error calculating distance:', error);
        // Set default shipping fee
        document.getElementById('shipping-fee').textContent = formatCurrency(20000);
        document.getElementById('shipping-fee-data').value = 20000;
    }
}

// Haversine distance calculation
function haversineDistance(lat1, lon1, lat2, lon2) {
    const R = 6371; // Earth's radius in kilometers
    const dLat = (lat2 - lat1) * Math.PI / 180;
    const dLon = (lon2 - lon1) * Math.PI / 180;
    const a = Math.sin(dLat/2) * Math.sin(dLat/2) +
              Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) *
              Math.sin(dLon/2) * Math.sin(dLon/2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
    return R * c;
}

// Setup form validation
function setupFormValidation() {
    const form = document.getElementById('delivery-form');
    const inputs = form.querySelectorAll('input[required]');
    
    inputs.forEach(input => {
        input.addEventListener('blur', validateField);
        input.addEventListener('input', clearFieldError);
    });
}

// Validate individual field
function validateField(event) {
    const field = event.target;
    const value = field.value.trim();
    
    // Remove existing error styling
    field.classList.remove('error');
    
    // Validate based on field type
    let isValid = true;
    let errorMessage = '';
    
    if (field.hasAttribute('required') && !value) {
        isValid = false;
        errorMessage = 'This field is required';
    } else if (field.type === 'email' && value && !isValidEmail(value)) {
        isValid = false;
        errorMessage = 'Please enter a valid email address';
    } else if (field.type === 'tel' && value && !isValidPhone(value)) {
        isValid = false;
        errorMessage = 'Please enter a valid phone number';
    }
    
    if (!isValid) {
        field.classList.add('error');
        showFieldError(field, errorMessage);
    }
    
    return isValid;
}

// Clear field error styling
function clearFieldError(event) {
    const field = event.target;
    field.classList.remove('error');
    hideFieldError(field);
}

// Show field error message
function showFieldError(field, message) {
    hideFieldError(field); // Remove existing error message
    
    const errorDiv = document.createElement('div');
    errorDiv.className = 'field-error';
    errorDiv.textContent = message;
    errorDiv.style.color = '#dc3545';
    errorDiv.style.fontSize = '0.875rem';
    errorDiv.style.marginTop = '0.25rem';
    
    field.parentNode.appendChild(errorDiv);
}

// Hide field error message
function hideFieldError(field) {
    const existingError = field.parentNode.querySelector('.field-error');
    if (existingError) {
        existingError.remove();
    }
}

// Generate unique order code
function generateOrderCode() {
    const timestamp = Date.now().toString().slice(-6);
    const random = Math.random().toString(36).substr(2, 4).toUpperCase();
    const orderCode = `${timestamp}${random}`;
    
    document.getElementById('order-code').textContent = orderCode;
}

// Place order function
function placeOrder() {
    const form = document.getElementById('delivery-form');
    const formData = new FormData(form);
    
    // Validate form
    if (!validateForm(form)) {
        alert('Please fill in all required fields correctly.');
        return;
    }
    
    // Check if cart is not empty
    const orderItemsData = document.getElementById('order-items-data').value;
    if (!orderItemsData || orderItemsData === '[]') {
        alert('Your cart is empty. Please add items before placing an order.');
        return;
    }
    
    // Disable button to prevent double submission
    const button = document.querySelector('.btn-place-order');
    button.disabled = true;
    button.textContent = 'Processing...';
    
    // Submit form
    fetch(form.action, {
        method: 'POST',
        body: formData
    })
    .then(response => {
        if (response.ok) {
            // Clear cart and redirect
            localStorage.removeItem('cart');
            alert('Order placed successfully! You will receive a confirmation email shortly.');
            window.location.href = window.checkoutData?.contextPath + '/' || '/';
        } else {
            throw new Error('Failed to place order');
        }
    })
    .catch(error => {
        console.error('Error placing order:', error);
        alert('Failed to place order. Please try again.');
    })
    .finally(() => {
        // Re-enable button
        button.disabled = false;
        button.textContent = 'Place Order';
    });
}

// Validate entire form
function validateForm(form) {
    const inputs = form.querySelectorAll('input[required]');
    let isValid = true;
    
    inputs.forEach(input => {
        if (!validateField({ target: input })) {
            isValid = false;
        }
    });
    
    return isValid;
}

// Utility functions
function formatCurrency(amount) {
    return new Intl.NumberFormat('vi-VN', {
        style: 'currency',
        currency: 'VND',
        minimumFractionDigits: 0
    }).format(amount).replace('₫', '₫');
}

function getImagePath(imageName) {
    const contextPath = window.checkoutData?.contextPath || '';
    if (imageName && imageName.includes('/')) {
        return imageName; // Already a full path
    }
    return `${contextPath}/assets/images/menu/${imageName || 'default.jpg'}`;
}

function isValidEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
}

function isValidPhone(phone) {
    const phoneRegex = /^[\+]?[0-9\s\-\(\)]{10,}$/;
    return phoneRegex.test(phone);
}

// Credit card formatting (if needed)
document.addEventListener('DOMContentLoaded', function() {
    const cardNumberInput = document.getElementById('card-number');
    const expiryInput = document.getElementById('expiry-date');
    const cvvInput = document.getElementById('cvv');
    
    if (cardNumberInput) {
        cardNumberInput.addEventListener('input', function() {
            let value = this.value.replace(/\s/g, '').replace(/[^0-9]/gi, '');
            let formattedValue = value.match(/.{1,4}/g)?.join(' ') || value;
            this.value = formattedValue;
        });
    }
    
    if (expiryInput) {
        expiryInput.addEventListener('input', function() {
            let value = this.value.replace(/\D/g, '');
            if (value.length >= 2) {
                value = value.substring(0, 2) + '/' + value.substring(2, 4);
            }
            this.value = value;
        });
    }
    
    if (cvvInput) {
        cvvInput.addEventListener('input', function() {
            this.value = this.value.replace(/[^0-9]/g, '');
        });
    }
});