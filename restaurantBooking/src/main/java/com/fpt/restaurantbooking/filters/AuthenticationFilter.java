package com.fpt.restaurantbooking.filters;

import com.fpt.restaurantbooking.models.User;
import com.fpt.restaurantbooking.services.UserService;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.Arrays;
import java.util.List;

/**
 * Authentication filter to check user login status and permissions
 */
@WebFilter("/*")
public class AuthenticationFilter implements Filter {
    
    private static final Logger logger = LoggerFactory.getLogger(AuthenticationFilter.class);
    
    private UserService userService;
    
    // URLs that don't require authentication
    private static final List<String> PUBLIC_URLS = Arrays.asList(
        "/login",
        "/register",
        "/",
        "/home",
        "/email-verification",
        "/verify-email",
        "/verify-otp",
        "/resend-otp",
        "/resend-verification",
        "/logout",
        "/restaurant-detail",
        "/api/public/",
        "/static/",
        "/css/",
        "/js/",
        "/images/",
        "/uploads/",
        "/error"
    );
    
    // URLs that require admin role
    private static final List<String> ADMIN_URLS = Arrays.asList(
        "/admin/",
        "/api/admin/"
    );
    
    // URLs that require staff or admin role
    private static final List<String> STAFF_URLS = Arrays.asList(
        "/staff/",
        "/api/staff/"
    );
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        logger.info("AuthenticationFilter initialized");

    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = requestURI.substring(contextPath.length());
        
        logger.info("Processing request - URI: {}, ContextPath: {}, Path: {}", requestURI, contextPath, path);
        logger.info("isPublicUrl('/profile'): {}", isPublicUrl("/profile"));

        // Allow public URLs
        if (isPublicUrl(path)) {
            chain.doFilter(request, response);
            return;
        }
        
        // Check authentication
        HttpSession session = httpRequest.getSession(false);
        User currentUser = null;
        
        if (session != null) {
            currentUser = (User) session.getAttribute("currentUser");
        }
        
        // If user is not authenticated, redirect to login
        if (currentUser == null) {
            logger.debug("User not authenticated, redirecting to login");
            if (isApiRequest(path)) {
                sendJsonError(httpResponse, HttpServletResponse.SC_UNAUTHORIZED, "Authentication required");
            } else {
                // Use the relative path (without context path) for redirect parameter
                String redirectPath = path;
                if (redirectPath.isEmpty()) {
                    redirectPath = "/";
                }
                httpResponse.sendRedirect(contextPath + "/login?redirect=" + URLEncoder.encode(redirectPath, "UTF-8"));
            }
            return;
        }
        
        // Check authorization for admin URLs
        if (isAdminUrl(path) && !isAdmin(currentUser)) {
            logger.warn("User {} attempted to access admin URL: {}", currentUser.getEmail(), path);
            if (isApiRequest(path)) {
                sendJsonError(httpResponse, HttpServletResponse.SC_FORBIDDEN, "Admin access required");
            } else {
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            }
            return;
        }
        
        // Check authorization for staff URLs
        if (isStaffUrl(path) && !isStaffOrAdmin(currentUser)) {
            logger.warn("User {} attempted to access staff URL: {}", currentUser.getEmail(), path);
            if (isApiRequest(path)) {
                sendJsonError(httpResponse, HttpServletResponse.SC_FORBIDDEN, "Staff access required");
            } else {
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            }
            return;
        }
        
        // Check if user account is active
        if (!currentUser.getIsActive()) {
            logger.warn("Inactive user {} attempted to access: {}", currentUser.getEmail(), path);
            session.invalidate();
            if (isApiRequest(path)) {
                sendJsonError(httpResponse, HttpServletResponse.SC_FORBIDDEN, "Account is inactive");
            } else {
                httpResponse.sendRedirect(contextPath + "/login?error=account_inactive");
            }
            return;
        }
        
        // Note: Email verification is now handled by LoginController
        // The LoginController will redirect PENDING users to email verification
        // This removes the database call for better performance
        
        // Set user in request attribute for easy access in controllers
        httpRequest.setAttribute("currentUser", currentUser);
        
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
        logger.info("AuthenticationFilter destroyed");
    }
    
    /**
     * Check if URL is public (doesn't require authentication)
     */
    private boolean isPublicUrl(String path) {
        boolean result = PUBLIC_URLS.stream().anyMatch(publicUrl -> {
            if (publicUrl.equals("/")) {
                // Exact match for root path only
                return path.equals("/");
            } else {
                // Starts with match for other patterns
                return path.startsWith(publicUrl);
            }
        });
        logger.info("isPublicUrl check for path '{}': {}", path, result);
        return result;
    }
    
    /**
     * Check if URL requires admin role
     */
    private boolean isAdminUrl(String path) {
        return ADMIN_URLS.stream().anyMatch(adminUrl -> path.startsWith(adminUrl));
    }
    
    /**
     * Check if URL requires staff or admin role
     */
    private boolean isStaffUrl(String path) {
        return STAFF_URLS.stream().anyMatch(staffUrl -> path.startsWith(staffUrl));
    }
    
    /**
     * Check if request is an API request
     */
    private boolean isApiRequest(String path) {
        return path.startsWith("/api/") || path.endsWith(".json") || path.endsWith(".xml");
    }
    
    /**
     * Check if user has admin role
     */
    private boolean isAdmin(User user) {
        return user != null && User.UserRole.ADMIN.equals(user.getRole());
    }
    
    /**
     * Check if user has staff or admin role
     */
    private boolean isStaffOrAdmin(User user) {
        return user != null && (User.UserRole.STAFF.equals(user.getRole()) || User.UserRole.ADMIN.equals(user.getRole()));
    }
    
    
    /**
     * Send JSON error response
     */
    private void sendJsonError(HttpServletResponse response, int statusCode, String message) throws IOException {
        response.setStatus(statusCode);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String jsonError = String.format(
            "{\"error\": true, \"message\": \"%s\", \"statusCode\": %d}",
            message, statusCode
        );
        
        response.getWriter().write(jsonError);
    }
}