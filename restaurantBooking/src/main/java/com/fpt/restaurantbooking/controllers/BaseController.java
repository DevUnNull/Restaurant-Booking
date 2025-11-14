package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.models.User;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;

/**
 * Base controller class with common functionality
 */
public abstract class BaseController extends HttpServlet {

    protected static final String CONTENT_TYPE_JSON = "application/json";
    protected static final String CONTENT_TYPE_HTML = "text/html";
    protected static final String CHARSET_UTF8 = "UTF-8";

    protected Gson gson = new Gson();

    /**
     * Get current user from session
     */
    protected User getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            return (User) session.getAttribute("currentUser");
        }
        return null;
    }

    /**
     * Set current user in session
     */
    protected void setCurrentUser(HttpServletRequest request, User user) {
        HttpSession session = request.getSession(true);
        session.setAttribute("currentUser", user);
    }

    /**
     * Remove current user from session
     */
    protected void removeCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.removeAttribute("currentUser");
        }
    }

    /**
     * Check if user is authenticated
     */
    protected boolean isAuthenticated(HttpServletRequest request) {
        return getCurrentUser(request) != null;
    }

    /**
     * Check if user has specific role
     */
    protected boolean hasRole(HttpServletRequest request, User.UserRole role) {
        User user = getCurrentUser(request);
        return user != null && user.getRole().equals(role.toString());
    }

    /**
     * Send JSON response
     */
    protected void sendJsonResponse(HttpServletResponse response, Object data) throws IOException {
        response.setContentType(CONTENT_TYPE_JSON);
        response.setCharacterEncoding(CHARSET_UTF8);
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(data));
        out.flush();
    }

    /**
     * Send error response
     */
    protected void sendErrorResponse(HttpServletResponse response, int statusCode, String message) throws IOException {
        response.setStatus(statusCode);
        response.setContentType(CONTENT_TYPE_JSON);
        response.setCharacterEncoding(CHARSET_UTF8);
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(new ErrorResponse(message)));
        out.flush();
    }

    /**
     * Send success response
     */
    protected void sendSuccessResponse(HttpServletResponse response, String message) throws IOException {
        sendJsonResponse(response, new SuccessResponse(message));
    }

    /**
     * Send success response with data
     */
    protected void sendSuccessResponse(HttpServletResponse response, String message, Object data) throws IOException {
        sendJsonResponse(response, new SuccessResponse(message, data));
    }

    /**
     * Forward to JSP page
     */
    protected void forwardToPage(HttpServletRequest request, HttpServletResponse response, String page)
            throws ServletException, IOException {
        request.getRequestDispatcher(page).forward(request, response);
    }

    /**
     * Redirect to URL
     */
    protected void redirectTo(HttpServletResponse response, String url) throws IOException {
        response.sendRedirect(url);
    }

    /**
     * Get parameter as string
     */
    protected String getParameter(HttpServletRequest request, String name) {
        return request.getParameter(name);
    }

    /**
     * Get parameter as integer
     */
    protected Integer getIntParameter(HttpServletRequest request, String name) {
        String value = request.getParameter(name);
        if (value != null && !value.trim().isEmpty()) {
            try {
                return Integer.parseInt(value);
            } catch (NumberFormatException e) {
                return null;
            }
        }
        return null;
    }

    /**
     * Get parameter as long
     */
    protected Long getLongParameter(HttpServletRequest request, String name) {
        String value = request.getParameter(name);
        if (value != null && !value.trim().isEmpty()) {
            try {
                return Long.parseLong(value);
            } catch (NumberFormatException e) {
                return null;
            }
        }
        return null;
    }

    // Response classes
    public static class ErrorResponse {
        private boolean success = false;
        private String message;

        public ErrorResponse(String message) {
            this.message = message;
        }

        // Getters
        public boolean isSuccess() { return success; }
        public String getMessage() { return message; }
    }

    public static class SuccessResponse {
        private boolean success = true;
        private String message;
        private Object data;

        public SuccessResponse(String message) {
            this.message = message;
        }

        public SuccessResponse(String message, Object data) {
            this.message = message;
            this.data = data;
        }

        // Getters
        public boolean isSuccess() { return success; }
        public String getMessage() { return message; }
        public Object getData() { return data; }
    }
}