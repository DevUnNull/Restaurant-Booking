/**
 * Login Form Validation and Functionality
 */

document.addEventListener('DOMContentLoaded', function() {
    const loginForm = document.getElementById('loginForm');
    const emailInput = document.getElementById('email');
    const passwordInput = document.getElementById('password');
    const loginBtn = document.getElementById('loginBtn');
    
    // Form validation
    function validateForm() {
        let isValid = true;
        
        // Clear previous errors
        clearErrors();
        
        // Validate email
        if (!emailInput.value.trim()) {
            showError('emailError', 'Vui lòng nhập email');
            isValid = false;
        } else if (!isValidEmail(emailInput.value.trim())) {
            showError('emailError', 'Email không hợp lệ');
            isValid = false;
        }
        
        // Validate password
        if (!passwordInput.value.trim()) {
            showError('passwordError', 'Vui lòng nhập mật khẩu');
            isValid = false;
        } else if (passwordInput.value.length < 6) {
            showError('passwordError', 'Mật khẩu phải có ít nhất 6 ký tự');
            isValid = false;
        }
        
        return isValid;
    }
    
    // Email validation function
    function isValidEmail(email) {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email);
    }
    function showError(elementId, message) {
        const errorElement = document.getElementById(elementId);
        const inputElement = errorElement.previousElementSibling.querySelector('input') || 
                           errorElement.previousElementSibling.querySelector('.form-control');
        
        errorElement.textContent = message;
        errorElement.style.display = 'block';
        
        if (inputElement) {
            inputElement.classList.add('error');
        }
    }
    
    // Clear all error messages
    function clearErrors() {
        const errorElements = document.querySelectorAll('.error-message');
        const inputElements = document.querySelectorAll('.form-control');
        
        errorElements.forEach(element => {
            element.textContent = '';
            element.style.display = 'none';
        });
        
        inputElements.forEach(element => {
            element.classList.remove('error');
        });
    }
    
    // Real-time validation
    emailInput.addEventListener('blur', function() {
        if (this.value.trim()) {
            clearFieldError(this);
            if (!isValidEmail(this.value.trim())) {
                showError('emailError', 'Email không hợp lệ');
            }
        }
    });
    
    passwordInput.addEventListener('blur', function() {
        if (this.value.trim()) {
            clearFieldError(this);
            if (this.value.length < 6) {
                showError('passwordError', 'Mật khẩu phải có ít nhất 6 ký tự');
            }
        }
    });
    
    // Clear error when user starts typing
    emailInput.addEventListener('input', function() {
        clearFieldError(this);
    });
    
    passwordInput.addEventListener('input', function() {
        clearFieldError(this);
    });
    
    // Clear error for specific field
    function clearFieldError(inputElement) {
        const formGroup = inputElement.closest('.form-group');
        const errorElement = formGroup.querySelector('.error-message');
        
        if (errorElement) {
            errorElement.textContent = '';
            errorElement.style.display = 'none';
        }
        
        inputElement.classList.remove('error');
    }
    
    // Form submission
    loginForm.addEventListener('submit', function(e) {
        e.preventDefault();
        
        if (validateForm()) {
            // Show loading state
            loginBtn.disabled = true;
            loginBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang đăng nhập...';
            
            // Submit form after a short delay to show loading state
            setTimeout(() => {
                loginForm.submit();
            }, 500);
        }
    });
    
    // Password toggle functionality
    window.togglePassword = function(inputId) {
        const input = document.getElementById(inputId);
        const toggleBtn = input.nextElementSibling;
        const icon = toggleBtn.querySelector('.eye-icon');
        
        if (input.type === 'password') {
            input.type = 'text';
            icon.classList.remove('fa-eye');
            icon.classList.add('fa-eye-slash');
        } else {
            input.type = 'password';
            icon.classList.remove('fa-eye-slash');
            icon.classList.add('fa-eye');
        }
        
        // Focus back to input
        input.focus();
    };
    
    // Handle Enter key
    emailInput.addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            e.preventDefault();
            passwordInput.focus();
        }
    });
    
    passwordInput.addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            e.preventDefault();
            loginForm.dispatchEvent(new Event('submit'));
        }
    });
    
    // Auto-focus email field on page load
    emailInput.focus();
    
    // Handle demo credentials for testing
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.has('demo')) {
        if (urlParams.get('demo') === 'invalid') {
            emailInput.value = 'invalid@example.com';
            passwordInput.value = 'password';
        }
    }
});