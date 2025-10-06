package com.fpt.restaurantbooking.utils;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Utility class for handling toast notifications across servlet redirects
 * Stores toast messages in session and displays them after redirect
 */
public class ToastHelper {
    
    private static final String TOAST_MESSAGE_KEY = "TOAST_MESSAGE";
    private static final Gson gson = new Gson();
    
    /**
     * Add success toast message to session before redirect
     */
    public static void addSuccessToast(HttpServletRequest request, String message) {
        addToast(request, "success", message, null, 5000);
    }
    
    /**
     * Add success toast message with custom title
     */
    public static void addSuccessToast(HttpServletRequest request, String message, String title) {
        addToast(request, "success", message, title, 5000);
    }
    
    /**
     * Add error toast message to session before redirect
     */
    public static void addErrorToast(HttpServletRequest request, String message) {
        addToast(request, "failed", message, null, 7000);
    }
    
    /**
     * Add error toast message with custom title
     */
    public static void addErrorToast(HttpServletRequest request, String message, String title) {
        addToast(request, "failed", message, title, 7000);
    }
    
    /**
     * Add warning toast message to session before redirect
     */
    public static void addWarningToast(HttpServletRequest request, String message) {
        addToast(request, "warning", message, null, 6000);
    }
    
    /**
     * Add warning toast message with custom title
     */
    public static void addWarningToast(HttpServletRequest request, String message, String title) {
        addToast(request, "warning", message, title, 6000);
    }
    
    /**
     * Add custom toast message to session
     */
    public static void addToast(HttpServletRequest request, String type, String message, String title, int duration) {
        HttpSession session = request.getSession();
        
        JsonObject toastData = new JsonObject();
        toastData.addProperty("type", type);
        toastData.addProperty("message", message);
        if (title != null && !title.trim().isEmpty()) {
            toastData.addProperty("title", title);
        }
        toastData.addProperty("duration", duration);
        toastData.addProperty("timestamp", System.currentTimeMillis());
        
        session.setAttribute(TOAST_MESSAGE_KEY, gson.toJson(toastData));
    }
    
    /**
     * Get toast message from session and remove it (one-time use)
     */
    public static String getAndClearToast(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        
        String toastJson = (String) session.getAttribute(TOAST_MESSAGE_KEY);
        if (toastJson != null) {
            session.removeAttribute(TOAST_MESSAGE_KEY);
        }
        
        return toastJson;
    }
    
    /**
     * Check if there's a pending toast message
     */
    public static boolean hasToast(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null && session.getAttribute(TOAST_MESSAGE_KEY) != null;
    }
    
    /**
     * Convenience method: Add success toast and redirect
     */
    public static void successAndRedirect(HttpServletRequest request, HttpServletResponse response, 
                                        String message, String redirectUrl) throws Exception {
        addSuccessToast(request, message);
        response.sendRedirect(redirectUrl);
    }
    
    /**
     * Convenience method: Add error toast and redirect
     */
    public static void errorAndRedirect(HttpServletRequest request, HttpServletResponse response, 
                                      String message, String redirectUrl) throws Exception {
        addErrorToast(request, message);
        response.sendRedirect(redirectUrl);
    }
    
    /**
     * Convenience method: Add warning toast and redirect
     */
    public static void warningAndRedirect(HttpServletRequest request, HttpServletResponse response, 
                                        String message, String redirectUrl) throws Exception {
        addWarningToast(request, message);
        response.sendRedirect(redirectUrl);
    }
    
    /**
     * Create JavaScript code to display toast from session data
     */
    public static String createToastScript(String toastJson) {
        if (toastJson == null || toastJson.trim().isEmpty()) {
            return "";
        }
        
        StringBuilder script = new StringBuilder();
        script.append("<script type=\"text/javascript\">\n");
        script.append("document.addEventListener('DOMContentLoaded', function() {\n");
        script.append("    if (typeof RestaurantApp !== 'undefined' && RestaurantApp.toastManager) {\n");
        script.append("        try {\n");
        script.append("            var toastData = ").append(toastJson).append(";\n");
        script.append("            var title = toastData.title ? toastData.title + ': ' : '';\n");
        script.append("            var fullMessage = title + toastData.message;\n");
        script.append("            RestaurantApp.toastManager.show(fullMessage, toastData.type, toastData.duration);\n");
        script.append("        } catch (e) {\n");
        script.append("            console.error('Error displaying toast:', e);\n");
        script.append("        }\n");
        script.append("    }\n");
        script.append("});\n");
        script.append("</script>\n");
        
        return script.toString();
    }
}