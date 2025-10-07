/**
 * Change Password Form Validation
 * Handles client-side validation for the change password form
 */


// Form elements - will be initialized when DOM is ready
let changePasswordForm;
let currentPasswordInput;
let newPasswordInput;
let confirmPasswordInput;
let changePasswordBtn;

// Error message elements - will be initialized when DOM is ready
let currentPasswordError;
let newPasswordError;
let confirmPasswordError;
let passwordStrength;

// Validation state
let isFormValid = false;

/**
 * Toggle password visibility
 */
function togglePassword(inputId) {
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
}

/**
 * Check password strength
 */
function checkPasswordStrength(password) {
    let strength = 0;
    let strengthText = '';
    let strengthClass = '';
    
    if (password.length >= 6) strength++;
    if (password.length >= 8) strength++;
    if (/[a-z]/.test(password) && /[A-Z]/.test(password)) strength++;
    if (/\d/.test(password)) strength++;
    if (/[!@#$%^&*(),.?":{}|<>]/.test(password)) strength++;
    
    switch (strength) {
        case 0:
        case 1:
            strengthText = 'Yếu';
            strengthClass = 'weak';
            break;
        case 2:
        case 3:
            strengthText = 'Trung bình';
            strengthClass = 'medium';
            break;
        case 4:
        case 5:
            strengthText = 'Mạnh';
            strengthClass = 'strong';
            break;
    }
    
    passwordStrength.textContent = `Độ mạnh: ${strengthText}`;
    passwordStrength.className = `password-strength ${strengthClass}`;
}

/**
 * Validate current password
 */
function validateCurrentPassword() {
    const currentPassword = currentPasswordInput.value.trim();
    
    if (currentPassword === '') {
        showError(currentPasswordError, 'Vui lòng nhập mật khẩu hiện tại.');
        return false;
    }
    
    if (currentPassword.length < 6) {
        showError(currentPasswordError, 'Mật khẩu phải có ít nhất 6 ký tự.');
        return false;
    }
    
    hideError(currentPasswordError);
    return true;
}

/**
 * Validate new password
 */
function validateNewPassword() {
    const newPassword = newPasswordInput.value.trim();
    const currentPassword = currentPasswordInput.value.trim();
    
    if (newPassword === '') {
        showError(newPasswordError, 'Vui lòng nhập mật khẩu mới.');
        checkPasswordStrength('');
        return false;
    }
    
    if (newPassword.length < 6) {
        showError(newPasswordError, 'Mật khẩu mới phải có ít nhất 6 ký tự.');
        checkPasswordStrength(newPassword);
        return false;
    }
    
    if (newPassword === currentPassword) {
        showError(newPasswordError, 'Mật khẩu mới phải khác mật khẩu hiện tại.');
        checkPasswordStrength(newPassword);
        return false;
    }
    
    hideError(newPasswordError);
    checkPasswordStrength(newPassword);
    return true;
}

/**
 * Validate confirm password
 */
function validateConfirmPassword() {
    const confirmPassword = confirmPasswordInput.value.trim();
    const newPassword = newPasswordInput.value.trim();
    
    if (confirmPassword === '') {
        showError(confirmPasswordError, 'Vui lòng xác nhận mật khẩu mới.');
        return false;
    }
    
    if (confirmPassword !== newPassword) {
        showError(confirmPasswordError, 'Mật khẩu xác nhận không khớp.');
        return false;
    }
    
    hideError(confirmPasswordError);
    return true;
}

/**
 * Show error message
 */
function showError(errorElement, message) {
    errorElement.textContent = message;
    errorElement.style.display = 'block';
}

/**
 * Hide error message
 */
function hideError(errorElement) {
    errorElement.style.display = 'none';
}

/**
 * Validate entire form
 */
function validateForm() {
    console.log('validateForm called');
    const isCurrentPasswordValid = validateCurrentPassword();
    const isNewPasswordValid = validateNewPassword();
    const isConfirmPasswordValid = validateConfirmPassword();
    
    isFormValid = isCurrentPasswordValid && isNewPasswordValid && isConfirmPasswordValid;
    
    return isFormValid;
}

/**
 * Initialize form elements and event listeners
 */
document.addEventListener('DOMContentLoaded', function() {
    console.log('DOMContentLoaded fired - initializing change password form');
    
    // Initialize DOM elements
    changePasswordForm = document.getElementById('changePasswordForm');
    currentPasswordInput = document.getElementById('currentPassword');
    newPasswordInput = document.getElementById('newPassword');
    confirmPasswordInput = document.getElementById('confirmPassword');
    changePasswordBtn = document.getElementById('changePasswordBtn');
    

    
    // Initialize error message elements
    currentPasswordError = document.getElementById('currentPasswordError');
    newPasswordError = document.getElementById('newPasswordError');
    confirmPasswordError = document.getElementById('confirmPasswordError');
    passwordStrength = document.getElementById('passwordStrength');
    

    
    // Clear any previous error states
    hideError(currentPasswordError);
    hideError(newPasswordError);
    hideError(confirmPasswordError);
    if (passwordStrength) {
        passwordStrength.textContent = '';
    }
    
    // Add event listeners
    if (changePasswordForm) {
        changePasswordForm.addEventListener('submit', handleFormSubmit);
        console.log('Form submit listener added');
    }
    
    if (currentPasswordInput) {
        currentPasswordInput.addEventListener('blur', validateCurrentPassword);
        currentPasswordInput.addEventListener('input', function() {
            if (this.value.trim() !== '') {
                validateCurrentPassword();
            }
        });
        console.log('Current password input listeners added');
    }
    
    if (newPasswordInput) {
        newPasswordInput.addEventListener('blur', validateNewPassword);
        newPasswordInput.addEventListener('input', function() {
            if (this.value.trim() !== '') {
                validateNewPassword();
                // Revalidate confirm password if it has value
                if (confirmPasswordInput && confirmPasswordInput.value.trim() !== '') {
                    validateConfirmPassword();
                }
            }
        });
        console.log('New password input listeners added');
    }
    
    if (confirmPasswordInput) {
        confirmPasswordInput.addEventListener('blur', validateConfirmPassword);
        confirmPasswordInput.addEventListener('input', function() {
            if (this.value.trim() !== '') {
                validateConfirmPassword();
            }
        });
        console.log('Confirm password input listeners added');
    }
    
    console.log('Change password form initialization complete');
});

/**
 * Handle form submission
 */
function handleFormSubmit(e) {
    if (!validateForm()) {
        e.preventDefault();
        return;
    }
    
    // Show loading state
    if (changePasswordBtn) {
        changePasswordBtn.disabled = true;
        changePasswordBtn.innerHTML = '<span class="btn-text">Đang xử lý...</span>';
    }
}