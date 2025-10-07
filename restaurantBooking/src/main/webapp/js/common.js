/**
 * Common JavaScript utilities for Restaurant Booking Application
 */

// Toast notification system
class ToastManager {
    constructor() {
        this.container = null;
        this.init();
    }

    init() {
        // Create toast container
        this.container = document.createElement('div');
        this.container.id = 'toast-container';
        this.container.className = 'toast-container';
        document.body.appendChild(this.container);

        // Add CSS styles
        this.addStyles();
    }

    addStyles() {
        if (document.getElementById('toast-styles')) return;

        const style = document.createElement('style');
        style.id = 'toast-styles';
        style.textContent = `
            .toast-container {
                position: fixed;
                top: 20px;
                right: 20px;
                z-index: 10000;
                max-width: 400px;
            }

            .toast {
                background: white;
                border-radius: 8px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
                margin-bottom: 10px;
                padding: 16px;
                display: flex;
                align-items: center;
                transform: translateX(100%);
                transition: all 0.3s ease;
                border-left: 4px solid;
                position: relative;
                overflow: hidden;
            }

            .toast.show {
                transform: translateX(0);
            }

            .toast.success {
                border-left-color: #28a745;
            }

            .toast.failed,
            .toast.error {
                border-left-color: #dc3545;
            }

            .toast.warning {
                border-left-color: #ffc107;
            }

            .toast-icon {
                margin-right: 12px;
                font-size: 20px;
                flex-shrink: 0;
            }

            .toast.success .toast-icon {
                color: #28a745;
            }

            .toast.failed .toast-icon,
            .toast.error .toast-icon {
                color: #dc3545;
            }

            .toast.warning .toast-icon {
                color: #ffc107;
            }

            .toast-content {
                flex: 1;
            }

            .toast-title {
                font-weight: 600;
                margin-bottom: 4px;
                font-size: 14px;
            }

            .toast-message {
                font-size: 13px;
                color: #666;
                line-height: 1.4;
            }

            .toast-close {
                background: none;
                border: none;
                font-size: 18px;
                cursor: pointer;
                color: #999;
                margin-left: 12px;
                padding: 0;
                width: 20px;
                height: 20px;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .toast-close:hover {
                color: #666;
            }

            .toast-progress {
                position: absolute;
                bottom: 0;
                left: 0;
                height: 3px;
                background: rgba(0, 0, 0, 0.1);
                transition: width linear;
            }

            .toast.success .toast-progress {
                background: #28a745;
            }

            .toast.failed .toast-progress,
            .toast.error .toast-progress {
                background: #dc3545;
            }

            .toast.warning .toast-progress {
                background: #ffc107;
            }

            @media (max-width: 480px) {
                .toast-container {
                    left: 10px;
                    right: 10px;
                    top: 10px;
                    max-width: none;
                }

                .toast {
                    transform: translateY(-100%);
                }

                .toast.show {
                    transform: translateY(0);
                }
            }
        `;
        document.head.appendChild(style);
    }

    show(type, title, message, duration = 5000) {
        const toast = document.createElement('div');
        toast.className = `toast ${type}`;

        const icons = {
            success: '✓',
            failed: '✕',
            error: '✕',
            warning: '⚠'
        };

        toast.innerHTML = `
            <div class="toast-icon">${icons[type] || '●'}</div>
            <div class="toast-content">
                <div class="toast-title">${title}</div>
                <div class="toast-message">${message}</div>
            </div>
            <button class="toast-close" onclick="this.parentElement.remove()">&times;</button>
            <div class="toast-progress"></div>
        `;

        this.container.appendChild(toast);

        // Trigger animation
        setTimeout(() => toast.classList.add('show'), 10);

        // Auto remove
        if (duration > 0) {
            const progressBar = toast.querySelector('.toast-progress');
            progressBar.style.width = '100%';
            progressBar.style.transitionDuration = duration + 'ms';

            setTimeout(() => {
                progressBar.style.width = '0%';
            }, 50);

            setTimeout(() => {
                if (toast.parentElement) {
                    toast.classList.remove('show');
                    setTimeout(() => toast.remove(), 300);
                }
            }, duration);
        }

        return toast;
    }

    success(title, message, duration) {
        return this.show('success', title, message, duration);
    }

    failed(title, message, duration) {
        return this.show('failed', title, message, duration);
    }

    error(title, message, duration) {
        return this.show('error', title, message, duration);
    }

    warning(title, message, duration) {
        return this.show('warning', title, message, duration);
    }

    clear() {
        this.container.innerHTML = '';
    }
}



// Utility Functions
const RestaurantApp = {
    
    // Initialize the application
    init: function() {
        this.initializeToast();
        this.setupEventListeners();
        this.initializeComponents();
    },

    initializeToast: function() {
        this.toast = new ToastManager();
    },

    // Check if user is logged in (implement your own logic)
    isUserLoggedIn: function() {
        // Example: check for session token or user data
        return localStorage.getItem('userToken') || sessionStorage.getItem('userId');
    },

    // Setup common event listeners
    setupEventListeners: function() {
        // Handle form submissions
        document.addEventListener('submit', this.handleFormSubmit.bind(this));
        
        // Handle navigation
        document.addEventListener('click', this.handleNavigation.bind(this));
        
        // Handle modal close
        document.addEventListener('click', this.handleModalClose.bind(this));
        
        // Handle escape key for modals
        document.addEventListener('keydown', this.handleEscapeKey.bind(this));
    },

    // Initialize components
    initializeComponents: function() {
        this.initializeModals();
        this.initializeTooltips();
        this.updateCartCount();
    },

    // Form handling
    handleFormSubmit: function(event) {
        const form = event.target;
        if (form.classList.contains('ajax-form')) {
            event.preventDefault();
            this.submitFormAjax(form);
        }
    },

    // Submit form via AJAX
    submitFormAjax: function(form) {
        const formData = new FormData(form);
        const url = form.action || window.location.href;
        const method = form.method || 'POST';

        this.showLoading(form);

        fetch(url, {
            method: method,
            body: formData,
            headers: {
                'X-Requested-With': 'XMLHttpRequest'
            }
        })
        .then(response => response.json())
        .then(data => {
            this.hideLoading(form);
            if (data.success) {
                this.showAlert('success', data.message);
                if (data.redirect) {
                    setTimeout(() => {
                        window.location.href = data.redirect;
                    }, 1500);
                }
            } else {
                this.showAlert('error', data.message);
            }
        })
        .catch(error => {
            this.hideLoading(form);
            this.showAlert('error', 'An error occurred. Please try again.');
            console.error('Error:', error);
        });
    },

    // Navigation handling
    handleNavigation: function(event) {
        const link = event.target.closest('a[data-navigate]');
        if (link) {
            event.preventDefault();
            const url = link.href;
            this.navigateTo(url);
        }
    },

    // Navigate to URL
    navigateTo: function(url) {
        window.location.href = url;
    },

    // Modal functions
    initializeModals: function() {
        const modalTriggers = document.querySelectorAll('[data-modal-target]');
        modalTriggers.forEach(trigger => {
            trigger.addEventListener('click', (e) => {
                e.preventDefault();
                const modalId = trigger.getAttribute('data-modal-target');
                this.showModal(modalId);
            });
        });
    },

    showModal: function(modalId) {
        const modal = document.getElementById(modalId);
        if (modal) {
            modal.style.display = 'block';
            document.body.classList.add('modal-open');
        }
    },

    hideModal: function(modalId) {
        const modal = document.getElementById(modalId);
        if (modal) {
            modal.style.display = 'none';
            document.body.classList.remove('modal-open');
        }
    },

    handleModalClose: function(event) {
        if (event.target.classList.contains('modal-overlay') || 
            event.target.classList.contains('modal-close')) {
            const modal = event.target.closest('.modal');
            if (modal) {
                this.hideModal(modal.id);
            }
        }
    },

    handleEscapeKey: function(event) {
        if (event.key === 'Escape') {
            const openModal = document.querySelector('.modal[style*="block"]');
            if (openModal) {
                this.hideModal(openModal.id);
            }
        }
    },

    // Alert/Notification functions (legacy - use toast instead)
    showAlert: function(type, message, duration = 5000) {
        // Use new toast system
        this.toast.show(type, type.charAt(0).toUpperCase() + type.slice(1), message, duration);
    },

    getOrCreateAlertContainer: function() {
        let container = document.getElementById('alert-container');
        if (!container) {
            container = document.createElement('div');
            container.id = 'alert-container';
            container.className = 'alert-container';
            document.body.appendChild(container);
        }
        return container;
    },

    // Loading functions
    showLoading: function(element) {
        const loader = document.createElement('div');
        loader.className = 'loading-overlay';
        loader.innerHTML = '<div class="spinner"></div>';
        element.style.position = 'relative';
        element.appendChild(loader);
    },

    hideLoading: function(element) {
        const loader = element.querySelector('.loading-overlay');
        if (loader) {
            loader.remove();
        }
    },

    // Tooltip functions
    initializeTooltips: function() {
        const tooltipElements = document.querySelectorAll('[data-tooltip]');
        tooltipElements.forEach(element => {
            element.addEventListener('mouseenter', this.showTooltip.bind(this));
            element.addEventListener('mouseleave', this.hideTooltip.bind(this));
        });
    },

    showTooltip: function(event) {
        const element = event.target;
        const text = element.getAttribute('data-tooltip');
        
        const tooltip = document.createElement('div');
        tooltip.className = 'tooltip';
        tooltip.textContent = text;
        document.body.appendChild(tooltip);
        
        const rect = element.getBoundingClientRect();
        tooltip.style.left = rect.left + (rect.width / 2) - (tooltip.offsetWidth / 2) + 'px';
        tooltip.style.top = rect.top - tooltip.offsetHeight - 5 + 'px';
        
        element._tooltip = tooltip;
    },

    hideTooltip: function(event) {
        const element = event.target;
        if (element._tooltip) {
            element._tooltip.remove();
            delete element._tooltip;
        }
    },

    // Cart functions
    updateCartCount: function() {
        const cartCount = localStorage.getItem('cartCount') || 0;
        const cartCountElements = document.querySelectorAll('.cart-count');
        cartCountElements.forEach(element => {
            element.textContent = cartCount;
        });
    },

    addToCart: function(itemId, quantity = 1) {
        let cart = JSON.parse(localStorage.getItem('cart') || '{}');
        cart[itemId] = (cart[itemId] || 0) + quantity;
        localStorage.setItem('cart', JSON.stringify(cart));
        
        const totalCount = Object.values(cart).reduce((sum, qty) => sum + qty, 0);
        localStorage.setItem('cartCount', totalCount);
        
        this.updateCartCount();
        this.toast.success('Added to Cart', 'Item added to cart successfully!');
    },

    removeFromCart: function(itemId) {
        let cart = JSON.parse(localStorage.getItem('cart') || '{}');
        delete cart[itemId];
        localStorage.setItem('cart', JSON.stringify(cart));
        
        const totalCount = Object.values(cart).reduce((sum, qty) => sum + qty, 0);
        localStorage.setItem('cartCount', totalCount);
        
        this.updateCartCount();
    },

    clearCart: function() {
        localStorage.removeItem('cart');
        localStorage.removeItem('cartCount');
        this.updateCartCount();
    },

    // Utility functions
    formatCurrency: function(amount) {
        return new Intl.NumberFormat('vi-VN', {
            style: 'currency',
            currency: 'VND'
        }).format(amount);
    },

    formatDate: function(date) {
        return new Intl.DateTimeFormat('vi-VN').format(new Date(date));
    },

    validateEmail: function(email) {
        const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return re.test(email);
    },

    validatePhone: function(phone) {
        const re = /^[0-9]{10,11}$/;
        return re.test(phone.replace(/\s/g, ''));
    },

    // Debounce function for search inputs
    debounce: function(func, wait) {
        let timeout;
        return function executedFunction(...args) {
            const later = () => {
                clearTimeout(timeout);
                func(...args);
            };
            clearTimeout(timeout);
            timeout = setTimeout(later, wait);
        };
    }
};

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    RestaurantApp.init();
});

// Export for use in other scripts
window.RestaurantApp = RestaurantApp;