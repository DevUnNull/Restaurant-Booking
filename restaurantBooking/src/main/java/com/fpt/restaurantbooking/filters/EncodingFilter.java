package com.fpt.restaurantbooking.filters;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

/**
 * Encoding filter to ensure UTF-8 encoding for all requests and responses
 */
@WebFilter("/*")
public class EncodingFilter implements Filter {
    
    private static final Logger logger = LoggerFactory.getLogger(EncodingFilter.class);
    private static final String ENCODING = "UTF-8";
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        logger.info("EncodingFilter initialized with encoding: {}", ENCODING);
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        // Set request encoding
        if (httpRequest.getCharacterEncoding() == null) {
            httpRequest.setCharacterEncoding(ENCODING);
        }
        
        // Set response encoding
        httpResponse.setCharacterEncoding(ENCODING);
        
        // Set content type for HTML responses
        String requestURI = httpRequest.getRequestURI();
        if (isHtmlRequest(requestURI)) {
            httpResponse.setContentType("text/html; charset=" + ENCODING);
        }
        
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
        logger.info("EncodingFilter destroyed");
    }
    
    /**
     * Check if request is for HTML content
     */
    private boolean isHtmlRequest(String requestURI) {
        return !requestURI.contains("/api/") && 
               !requestURI.contains("/css/") && 
               !requestURI.contains("/js/") && 
               !requestURI.contains("/images/") &&
               !requestURI.contains("/template/") &&
               !requestURI.endsWith(".css") &&
               !requestURI.endsWith(".js") &&
               !requestURI.endsWith(".png") &&
               !requestURI.endsWith(".jpg") &&
               !requestURI.endsWith(".jpeg") &&
               !requestURI.endsWith(".gif") &&
               !requestURI.endsWith(".ico");
    }
}