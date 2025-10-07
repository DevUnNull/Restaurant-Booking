// OTP Input Auto-focus
const otpInputs = document.querySelectorAll('.otp-input');
const verifyBtn = document.getElementById('verifyBtn');
const resendBtn = document.getElementById('resendBtn');
const otpForm = document.getElementById('otpForm');
const loadingIndicator = document.getElementById('loadingIndicator');
const verificationStatus = document.getElementById('verificationStatus');

// Auto-focus next input
otpInputs.forEach((input, index) => {
    input.addEventListener('input', (e) => {
        if (e.target.value.length === 1 && index < otpInputs.length - 1) {
            otpInputs[index + 1].focus();
        }
        
        // Enable verify button if all fields are filled
        const allFilled = Array.from(otpInputs).every(inp => inp.value.length === 1);
        verifyBtn.disabled = !allFilled;
    });
    
    input.addEventListener('keydown', (e) => {
        if (e.key === 'Backspace' && e.target.value === '' && index > 0) {
            otpInputs[index - 1].focus();
        }
    });
    
    // Only allow numbers
    input.addEventListener('keypress', (e) => {
        if (!/[0-9]/.test(e.key)) {
            e.preventDefault();
        }
    });
});

// Handle OTP verification
otpForm.addEventListener('submit', async (e) => {
    e.preventDefault();
    
    const otpCode = Array.from(otpInputs).map(input => input.value).join('');
    
    if (otpCode.length !== 6) {
        showStatus('Vui lòng nhập đầy đủ mã OTP 6 chữ số.', 'error');
        return;
    }
    
    // Show loading
    loadingIndicator.style.display = 'block';
    verifyBtn.disabled = true;
    
    try {
        // Build form data with additional parameters for registration flow
        const formData = new URLSearchParams();
        formData.append('otpCode', otpCode);
        
        // Add email and fromRegister parameters if in registration flow
        const urlParams = new URLSearchParams(window.location.search);
        const email = urlParams.get('email');
        const fromRegister = urlParams.get('fromRegister');
        const redirect = urlParams.get('redirect');
        
        if (email) {
            formData.append('email', email);
        }
        if (fromRegister) {
            formData.append('fromRegister', fromRegister);
        }
        if (redirect) {
            formData.append('redirect', redirect);
        }
        
        const response = await fetch(`${window.location.origin}${window.location.pathname.split('/').slice(0, -1).join('/')}/verify-otp`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: formData.toString()
                });
        
        const data = await response.json();
        
        if (response.ok) {
            showStatus('Xác thực email thành công! Đang chuyển hướng...', 'success');
            
            // Handle redirect based on flow
            if (fromRegister === 'true') {
                // Registration flow: redirect to login page
                    setTimeout(() => {
                        window.location.href = `${window.location.origin}${window.location.pathname.split('/').slice(0, -1).join('/')}/login`;
                    }, 2000);
                } else {
                    // Normal flow: check for redirect parameter first
                    const redirect = urlParams.get('redirect');
                    if (redirect) {
                        // Redirect to the original requested page
                        setTimeout(() => {
                            window.location.href = `${window.location.origin}${window.location.pathname.split('/').slice(0, -1).join('/')}${decodeURIComponent(redirect)}`;
                        }, 2000);
                    } else {
                        // Default redirect to dashboard
                        setTimeout(() => {
                            window.location.href = `${window.location.origin}${window.location.pathname.split('/').slice(0, -1).join('/')}/dashboard`;
                        }, 2000);
                }
            }
        } else {
            showStatus(data.message || 'Mã OTP không hợp lệ hoặc đã hết hạn.', 'error');
            // Clear OTP inputs
            otpInputs.forEach(input => input.value = '');
            otpInputs[0].focus();
        }
    } catch (error) {
        showStatus('Có lỗi xảy ra trong quá trình xác thực. Vui lòng thử lại.', 'error');
    } finally {
        loadingIndicator.style.display = 'none';
        verifyBtn.disabled = false;
    }
});

// Handle OTP resend
resendBtn.addEventListener('click', async () => {
    resendBtn.disabled = true;
    loadingIndicator.style.display = 'block';
    
    try {
        // Build form data with additional parameters for registration flow
        const formData = new URLSearchParams();
        
        // Add email and fromRegister parameters if in registration flow
        const urlParams = new URLSearchParams(window.location.search);
        const email = urlParams.get('email');
        const fromRegister = urlParams.get('fromRegister');
        
        if (email) {
            formData.append('email', email);
        }
        if (fromRegister) {
            formData.append('fromRegister', fromRegister);
        }
        
        const response = await fetch(`${window.location.origin}${window.location.pathname.split('/').slice(0, -1).join('/')}/resend-otp`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: formData.toString()
                });
        
        const data = await response.json();
        
        if (response.ok) {
            showStatus('Mã OTP mới đã được gửi đến email của bạn!', 'success');
            startResendTimer(data.remainingTime || 60);
        } else {
            showStatus(data.message || 'Không thể gửi lại mã OTP. Vui lòng thử lại sau.', 'error');
            resendBtn.disabled = false;
        }
    } catch (error) {
        showStatus('Có lỗi xảy ra khi gửi lại mã OTP.', 'error');
        resendBtn.disabled = false;
    } finally {
        loadingIndicator.style.display = 'none';
    }
});

// Show status message
function showStatus(message, type) {
    verificationStatus.textContent = message;
    verificationStatus.className = 'verification-status status-' + type;
    verificationStatus.style.display = 'block';
    
    setTimeout(() => {
        verificationStatus.style.display = 'none';
    }, 5000);
}

// Start resend timer
function startResendTimer(seconds) {
    const timerDisplay = document.getElementById('timerDisplay');
    const timerDiv = document.getElementById('resendTimer');
    
    let timeLeft = seconds;
    
    const timer = setInterval(() => {
        if (timeLeft <= 0) {
            clearInterval(timer);
            timerDiv.innerHTML = 'Bạn chưa nhận được mã?';
            resendBtn.disabled = false;
        } else {
            timerDiv.innerHTML = `Có thể gửi lại mã sau <span id="timerDisplay">${timeLeft}</span> giây`;
            timeLeft--;
        }
    }, 1000);
}

// Initialize
document.addEventListener('DOMContentLoaded', () => {
    otpInputs[0].focus();
    
    // Start timer if there's a pending OTP - handle JSP conditional
    const hasPendingOTP = document.querySelector('[data-has-pending-otp]')?.dataset.hasPendingOtp === 'true';
    const remainingTime = parseInt(document.querySelector('[data-remaining-time]')?.dataset.remainingTime || '0');
    
    if (hasPendingOTP && remainingTime > 0) {
        startResendTimer(remainingTime);
    }
});