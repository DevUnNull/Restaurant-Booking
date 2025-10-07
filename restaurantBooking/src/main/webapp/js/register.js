/**
 * Register Form Validation and Handling
 */

document.addEventListener('DOMContentLoaded', function() {
    const registerForm = document.getElementById('registerForm');
    const registerBtn = document.getElementById('registerBtn');
    
    // Form fields
    const fullNameField = document.getElementById('fullName');
    const emailField = document.getElementById('email');
    const phoneNumberField = document.getElementById('phoneNumber');
    const passwordField = document.getElementById('password');
    const confirmPasswordField = document.getElementById('confirmPassword');
    const agreeTermsField = document.getElementById('agreeTerms');
    
    // Error message containers
    const errorContainers = {
        fullName: document.getElementById('fullNameError'),
        email: document.getElementById('emailError'),
        phoneNumber: document.getElementById('phoneNumberError'),
        password: document.getElementById('passwordError'),
        confirmPassword: document.getElementById('confirmPasswordError'),
        agreeTerms: document.getElementById('agreeTermsError')
    };
    
    // Validation rules
    const validationRules = {
        fullName: {
            required: true,
            minLength: 2,
            maxLength: 100,
            pattern: /^[a-zA-ZÀ-ỹ\s]+$/,
            message: 'Họ tên phải có ít nhất 2 ký tự và chỉ chứa chữ cái'
        },
        email: {
            required: true,
            pattern: /^[^\s@]+@[^\s@]+\.[^\s@]+$/,
            message: 'Vui lòng nhập địa chỉ email hợp lệ'
        },
        phoneNumber: {
            required: true,
            pattern: /^(0[3|5|7|8|9])+([0-9]{8})$/,
            message: 'Số điện thoại phải có 10 số và bắt đầu bằng 03, 05, 07, 08, 09'
        },
        password: {
            required: true,
            minLength: 6,
            maxLength: 50,
            message: 'Mật khẩu phải có ít nhất 6 ký tự'
        },
        confirmPassword: {
            required: true,
            matchField: 'password',
            message: 'Mật khẩu xác nhận không khớp'
        },
        agreeTerms: {
            required: true,
            message: 'Bạn phải đồng ý với điều khoản sử dụng'
        }
    };
    
    // Real-time validation
    Object.keys(validationRules).forEach(fieldName => {
        const field = document.getElementById(fieldName);
        if (field) {
            field.addEventListener('blur', () => validateField(fieldName));
            field.addEventListener('input', () => {
                clearError(fieldName);
                if (fieldName === 'password') {
                    updatePasswordStrength();
                }
                if (fieldName === 'confirmPassword' || fieldName === 'password') {
                    validatePasswordMatch();
                }
            });
        }
    });
    
    // Form submission
    registerForm.addEventListener('submit', function(e) {
        e.preventDefault();
        
        if (validateForm()) {
            submitForm();
        }
    });
    
    /**
     * Validate individual field
     */
    function validateField(fieldName) {
        const field = document.getElementById(fieldName);
        const rule = validationRules[fieldName];
        const value = field.value.trim();
        
        // Required validation
        if (rule.required && !value) {
            showError(fieldName, `${getFieldLabel(fieldName)} là bắt buộc`);
            return false;
        }
        
        // Skip other validations if field is empty and not required
        if (!value && !rule.required) {
            return true;
        }
        
        // Length validation
        if (rule.minLength && value.length < rule.minLength) {
            showError(fieldName, `${getFieldLabel(fieldName)} phải có ít nhất ${rule.minLength} ký tự`);
            return false;
        }
        
        if (rule.maxLength && value.length > rule.maxLength) {
            showError(fieldName, `${getFieldLabel(fieldName)} không được vượt quá ${rule.maxLength} ký tự`);
            return false;
        }
        
        // Pattern validation
        if (rule.pattern && !rule.pattern.test(value)) {
            showError(fieldName, rule.message);
            return false;
        }
        
        // Match field validation
        if (rule.matchField) {
            const matchField = document.getElementById(rule.matchField);
            if (value !== matchField.value) {
                showError(fieldName, rule.message);
                return false;
            }
        }
        
        // Checkbox validation
        if (fieldName === 'agreeTerms' && !field.checked) {
            showError(fieldName, rule.message);
            return false;
        }
        
        clearError(fieldName);
        return true;
    }
    
    /**
     * Validate entire form
     */
    function validateForm() {
        let isValid = true;
        
        Object.keys(validationRules).forEach(fieldName => {
            if (!validateField(fieldName)) {
                isValid = false;
            }
        });
        
        return isValid;
    }
    
    /**
     * Show error message
     */
    function showError(fieldName, message) {
        const errorContainer = errorContainers[fieldName];
        const field = document.getElementById(fieldName);
        
        if (errorContainer) {
            errorContainer.textContent = message;
            errorContainer.style.display = 'block';
        }
        
        if (field) {
            field.classList.add('error');
        }
    }
    
    /**
     * Clear error message
     */
    function clearError(fieldName) {
        const errorContainer = errorContainers[fieldName];
        const field = document.getElementById(fieldName);
        
        if (errorContainer) {
            errorContainer.textContent = '';
            errorContainer.style.display = 'none';
        }
        
        if (field) {
            field.classList.remove('error');
        }
    }
    
    /**
     * Get field label for error messages
     */
    function getFieldLabel(fieldName) {
        const labels = {
            fullName: 'Họ và tên',
            email: 'Email',
            phoneNumber: 'Số điện thoại',
            password: 'Mật khẩu',
            confirmPassword: 'Xác nhận mật khẩu',
            agreeTerms: 'Đồng ý điều khoản'
        };
        return labels[fieldName] || fieldName;
    }
    
    /**
     * Update password strength indicator
     */
    function updatePasswordStrength() {
        const password = passwordField.value;
        const strengthContainer = document.getElementById('passwordStrength');
        
        if (!password) {
            strengthContainer.innerHTML = '';
            return;
        }
        
        let strength = 0;
        let feedback = [];
        
        // Length check
        if (password.length >= 8) strength++;
        else feedback.push('ít nhất 8 ký tự');
        
        // Uppercase check
        if (/[A-Z]/.test(password)) strength++;
        else feedback.push('chữ hoa');
        
        // Lowercase check
        if (/[a-z]/.test(password)) strength++;
        else feedback.push('chữ thường');
        
        // Number check
        if (/[0-9]/.test(password)) strength++;
        else feedback.push('số');
        
        // Special character check
        if (/[^A-Za-z0-9]/.test(password)) strength++;
        else feedback.push('ký tự đặc biệt');
        
        const strengthLevels = ['Rất yếu', 'Yếu', 'Trung bình', 'Mạnh', 'Rất mạnh'];
        const strengthColors = ['#ff4757', '#ff6b7a', '#ffa502', '#2ed573', '#20bf6b'];
        
        let strengthText = strengthLevels[Math.min(strength, 4)];
        let strengthColor = strengthColors[Math.min(strength, 4)];
        
        strengthContainer.innerHTML = `
            <div class="password-strength-bar">
                <div class="strength-fill" style="width: ${(strength / 5) * 100}%; background-color: ${strengthColor}"></div>
            </div>
            <div class="strength-text" style="color: ${strengthColor}">
                Độ mạnh: ${strengthText}
                ${feedback.length > 0 ? `<br><small>Cần thêm: ${feedback.join(', ')}</small>` : ''}
            </div>
        `;
    }
    
    /**
     * Validate password match
     */
    function validatePasswordMatch() {
        const password = passwordField.value;
        const confirmPassword = confirmPasswordField.value;
        
        if (confirmPassword && password !== confirmPassword) {
            showError('confirmPassword', 'Mật khẩu xác nhận không khớp');
        } else if (confirmPassword && password === confirmPassword) {
            clearError('confirmPassword');
        }
    }
    
    /**
     * Submit form
     */
    function submitForm() {
        // Show loading state
        const btnText = registerBtn.querySelector('.btn-text');
        const btnLoading = registerBtn.querySelector('.btn-loading');
        
        if (btnText) {
            btnText.style.display = 'none';
        }
        
        if (btnLoading) {
            btnLoading.style.display = 'inline-flex';
        }
        
        registerBtn.disabled = true;
        
        // Submit form normally (let the browser handle the submission)
        registerForm.submit();
    }
    
    /**
     * Parse server errors from response
     */
    function parseServerErrors(responseText) {
        // This is a simple implementation - you might need to adjust based on your server response format
        if (responseText.includes('email đã tồn tại') || responseText.includes('email already exists')) {
            showError('email', 'Email này đã được sử dụng');
        } else if (responseText.includes('số điện thoại đã tồn tại') || responseText.includes('phone already exists')) {
            showError('phoneNumber', 'Số điện thoại này đã được sử dụng');
        } else {
            showErrorMessage('Đăng ký không thành công. Vui lòng kiểm tra lại thông tin.');
        }
    }
    
    /**
     * Show success message
     */
    function showSuccessMessage(message) {
        // You can integrate with your toast system here
        if (window.showToast) {
            window.showToast(message, 'success');
        } else {
            alert(message);
        }
    }
    
    /**
     * Show error message
     */
    function showErrorMessage(message) {
        // You can integrate with your toast system here
        if (window.showToast) {
            window.showToast(message, 'error');
        } else {
            alert(message);
        }
    }
});

/**
 * Toggle password visibility
 */
function togglePassword(fieldId) {
    const field = document.getElementById(fieldId);
    const button = field.nextElementSibling;
    const icon = button.querySelector('.eye-icon');
    
    if (field.type === 'password') {
        field.type = 'text';
        icon.classList.remove('fa-eye');
        icon.classList.add('fa-eye-slash');
    } else {
        field.type = 'password';
        icon.classList.remove('fa-eye-slash');
        icon.classList.add('fa-eye');
    }
}