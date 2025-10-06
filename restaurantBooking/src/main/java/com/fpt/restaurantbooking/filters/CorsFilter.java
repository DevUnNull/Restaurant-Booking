package com.fpt.restaurantbooking.filters;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

/**
 * CORS filter to handle Cross-Origin Resource Sharing requests
 */
@WebFilter("/api/*")
public class CorsFilter implements Filter {
    
    private static final Logger logger = LoggerFactory.getLogger(CorsFilter.class);
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        logger.info("CorsFilter initialized");
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        // Set CORS headers
        String origin = httpRequest.getHeader("Origin");
        if (origin != null && isAllowedOrigin(origin)) {
            httpResponse.setHeader("Access-Control-Allow-Origin", origin);
        } else {
            httpResponse.setHeader("Access-Control-Allow-Origin", "*");
        }
        
        httpResponse.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
        httpResponse.setHeader("Access-Control-Allow-Headers", 
            "Content-Type, Authorization, X-Requested-With, Accept, Origin");
        httpResponse.setHeader("Access-Control-Allow-Credentials", "true");
        httpResponse.setHeader("Access-Control-Max-Age", "3600");
        
        // Handle preflight OPTIONS request
        if ("OPTIONS".equalsIgnoreCase(httpRequest.getMethod())) {
            logger.debug("Handling CORS preflight request from origin: {}", origin);
            httpResponse.setStatus(HttpServletResponse.SC_OK);
            return;
        }
        
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
        logger.info("CorsFilter destroyed");
    }
    
    /**
     * Check if origin is allowed
     */
    private boolean isAllowedOrigin(String origin) {
        // Add your allowed origins here
        String[] allowedOrigins = {
            "http://localhost:3000",
            "http://localhost:8080",
            "http://127.0.0.1:3000",
            "http://127.0.0.1:8080"
        };
        
        for (String allowedOrigin : allowedOrigins) {
            if (allowedOrigin.equals(origin)) {
                return true;
            }
        }
        
        return false;
    }
}