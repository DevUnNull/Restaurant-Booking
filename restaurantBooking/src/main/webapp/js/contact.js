// Contact Page JavaScript

// Initialize contact page
document.addEventListener('DOMContentLoaded', function() {
    initializeContactForm();
    setupFormValidation();
    setupFAQInteractions();
});

// Initialize contact form
function initializeContactForm() {
    const form = document.getElementById('contact-form');
    if (form) {
        form.addEventListener('submit', handleFormSubmission);
    }
}

// Setup form validation
function setupFormValidation() {
    const form = document.getElementById('contact-form');
    const inputs = form.querySelectorAll('input, select, textarea');
    
    inputs.forEach(input => {
        input.addEventListener('blur', validateField);
        input.addEventListener('input', clearFieldError);
    });
}

// Handle form submission
function handleFormSubmission(event) {
    event.preventDefault();
    
    const form = event.target;
    const submitButton = form.querySelector('.btn-submit');
    
    // Validate form
    if (!validateForm(form)) {
        showFormMessage('Please fill in all required fields correctly.', 'error');
        return;
    }
    
    // Show loading state
    setButtonLoading(submitButton, true);
    
    // Prepare form data
    const formData = new FormData(form);
    
    // Submit form
    fetch(form.action, {
        method: 'POST',
        body: formData,
        headers: {
            'X-Requested-With': 'XMLHttpRequest'
        }
    })
    .then(response => {
        if (response.ok) {
            return response.json();
        }
        throw new Error('Network response was not ok');
    })
    .then(data => {
        if (data.success) {
            showFormMessage('Thank you for your message! We\'ll get back to you soon.', 'success');
            form.reset();
        } else {
            throw new Error(data.message || 'Failed to send message');
        }
    })
    .catch(error => {
        console.error('Error submitting form:', error);
        showFormMessage('Sorry, there was an error sending your message. Please try again.', 'error');
    })
    .finally(() => {
        setButtonLoading(submitButton, false);
    });
}

// Validate entire form
function validateForm(form) {
    const inputs = form.querySelectorAll('input[required], select[required], textarea[required]');
    let isValid = true;
    
    inputs.forEach(input => {
        if (!validateField({ target: input })) {
            isValid = false;
        }
    });
    
    return isValid;
}

// Validate individual field
function validateField(event) {
    const field = event.target;
    const value = field.value.trim();
    
    // Remove existing error styling
    field.classList.remove('error');
    hideFieldError(field);
    
    // Validate based on field type and requirements
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
    } else if (field.name === 'name' && value && value.length < 2) {
        isValid = false;
        errorMessage = 'Name must be at least 2 characters long';
    } else if (field.name === 'message' && value && value.length < 10) {
        isValid = false;
        errorMessage = 'Message must be at least 10 characters long';
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
    
    field.parentNode.appendChild(errorDiv);
}

// Hide field error message
function hideFieldError(field) {
    const existingError = field.parentNode.querySelector('.field-error');
    if (existingError) {
        existingError.remove();
    }
}

// Show form message (success or error)
function showFormMessage(message, type) {
    // Remove existing messages
    const existingMessages = document.querySelectorAll('.form-success, .form-error');
    existingMessages.forEach(msg => msg.remove());
    
    // Create new message
    const messageDiv = document.createElement('div');
    messageDiv.className = type === 'success' ? 'form-success' : 'form-error';
    messageDiv.textContent = message;
    
    // Insert message at the top of the form
    const form = document.getElementById('contact-form');
    form.insertBefore(messageDiv, form.firstChild);
    
    // Scroll to message
    messageDiv.scrollIntoView({ behavior: 'smooth', block: 'center' });
    
    // Auto-remove message after 5 seconds
    setTimeout(() => {
        messageDiv.remove();
    }, 5000);
}

// Set button loading state
function setButtonLoading(button, isLoading) {
    if (isLoading) {
        button.disabled = true;
        button.classList.add('loading');
        button.setAttribute('data-original-text', button.textContent);
        button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Sending...';
    } else {
        button.disabled = false;
        button.classList.remove('loading');
        const originalText = button.getAttribute('data-original-text');
        button.innerHTML = originalText || '<i class="fas fa-paper-plane"></i> Send Message';
    }
}

// Setup FAQ interactions (if needed for future enhancements)
function setupFAQInteractions() {
    const faqItems = document.querySelectorAll('.faq-item');
    
    faqItems.forEach(item => {
        item.addEventListener('click', function() {
            // Add click animation
            this.style.transform = 'scale(0.98)';
            setTimeout(() => {
                this.style.transform = '';
            }, 150);
        });
    });
}

// Utility functions
function isValidEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
}

function isValidPhone(phone) {
    // Allow various phone number formats
    const phoneRegex = /^[\+]?[0-9\s\-\(\)]{10,}$/;
    return phoneRegex.test(phone);
}

// Character counter for textarea (optional enhancement)
function setupCharacterCounter() {
    const messageField = document.getElementById('contact-message');
    if (messageField) {
        const maxLength = 1000;
        
        // Create counter element
        const counter = document.createElement('div');
        counter.className = 'character-counter';
        counter.style.textAlign = 'right';
        counter.style.fontSize = '0.875rem';
        counter.style.color = '#666';
        counter.style.marginTop = '0.25rem';
        
        messageField.parentNode.appendChild(counter);
        
        // Update counter
        function updateCounter() {
            const remaining = maxLength - messageField.value.length;
            counter.textContent = `${remaining} characters remaining`;
            
            if (remaining < 50) {
                counter.style.color = '#dc3545';
            } else if (remaining < 100) {
                counter.style.color = '#ffc107';
            } else {
                counter.style.color = '#666';
            }
        }
        
        messageField.addEventListener('input', updateCounter);
        updateCounter(); // Initial update
    }
}

// Auto-resize textarea
function setupAutoResizeTextarea() {
    const textarea = document.getElementById('contact-message');
    if (textarea) {
        textarea.addEventListener('input', function() {
            this.style.height = 'auto';
            this.style.height = (this.scrollHeight) + 'px';
        });
    }
}

// Initialize additional features
document.addEventListener('DOMContentLoaded', function() {
    setupCharacterCounter();
    setupAutoResizeTextarea();
});

// Smooth scroll for anchor links (if any)
document.addEventListener('DOMContentLoaded', function() {
    const anchorLinks = document.querySelectorAll('a[href^="#"]');
    
    anchorLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            
            const targetId = this.getAttribute('href').substring(1);
            const targetElement = document.getElementById(targetId);
            
            if (targetElement) {
                targetElement.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });
});

// Form field focus animations
document.addEventListener('DOMContentLoaded', function() {
    const formControls = document.querySelectorAll('.form-control');
    
    formControls.forEach(control => {
        control.addEventListener('focus', function() {
            this.parentNode.classList.add('focused');
        });
        
        control.addEventListener('blur', function() {
            this.parentNode.classList.remove('focused');
        });
    });
});