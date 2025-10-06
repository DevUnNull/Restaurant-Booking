<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="auth-container">
    <div class="auth-card">
        <div class="auth-header">
            <h1>404 - Page Not Found</h1>
            <p>The page you are looking for could not be found.</p>
        </div>
        
        <div class="error-content">
            <div class="error-icon">
                <svg width="120" height="120" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="12" cy="12" r="10"/>
                    <line x1="12" y1="8" x2="12" y2="12"/>
                    <line x1="12" y1="16" x2="12.01" y2="16"/>
                </svg>
            </div>
            
            <h2>Oops! Something went wrong</h2>
            <p>The page you requested might have been moved, deleted, or you entered the wrong URL.</p>
            
            <div class="error-actions">
                <a href="${pageContext.request.contextPath}/" class="btn btn-primary">
                    Go to Homepage
                </a>
                <a href="javascript:history.back()" class="btn btn-secondary">
                    Go Back
                </a>
            </div>
        </div>
    </div>
</div>

<style>
.error-content {
    text-align: center;
    padding: 2rem 0;
}

.error-icon {
    color: #dc3545;
    margin-bottom: 1.5rem;
}

.error-icon svg {
    width: 80px;
    height: 80px;
}

.error-content h2 {
    color: #333;
    margin-bottom: 1rem;
    font-size: 1.5rem;
}

.error-content p {
    color: #666;
    margin-bottom: 2rem;
    line-height: 1.6;
}

.error-actions {
    display: flex;
    gap: 1rem;
    justify-content: center;
    flex-wrap: wrap;
}

.btn {
    padding: 0.75rem 1.5rem;
    border: none;
    border-radius: 5px;
    text-decoration: none;
    font-weight: 500;
    transition: all 0.3s ease;
    cursor: pointer;
    display: inline-block;
}

.btn-primary {
    background-color: #007bff;
    color: white;
}

.btn-primary:hover {
    background-color: #0056b3;
    color: white;
}

.btn-secondary {
    background-color: #6c757d;
    color: white;
}

.btn-secondary:hover {
    background-color: #545b62;
    color: white;
}

@media (max-width: 768px) {
    .error-actions {
        flex-direction: column;
        align-items: center;
    }
    
    .btn {
        width: 200px;
    }
}
</style>