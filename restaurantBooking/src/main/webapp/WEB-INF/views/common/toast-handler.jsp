<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.fpt.restaurantbooking.utils.ToastHelper" %>
<%
    // Check if there are any toasts in the session
    if (ToastHelper.hasToast(request)) {
        String toastsJson = ToastHelper.getAndClearToast(request);
        if (toastsJson != null && !toastsJson.trim().isEmpty()) {
%>
<script type="text/javascript">
    // Wait for DOM and RestaurantApp to be ready
    document.addEventListener('DOMContentLoaded', function() {
        // Small delay to ensure RestaurantApp is initialized
        setTimeout(function() {
            if (typeof RestaurantApp !== 'undefined' && RestaurantApp.toast) {
                try {
                    var toasts = <%= toastsJson %>;
                    if (Array.isArray(toasts)) {
                        toasts.forEach(function(toast) {
                            RestaurantApp.toast.show(toast.type, toast.title || '', toast.message);
                        });
                    } else if (toasts && toasts.type) {
                        // Handle single toast object
                        RestaurantApp.toast.show(toasts.type, toasts.title || '', toasts.message);
                    }
                } catch (e) {
                    console.error('Error displaying toasts:', e);
                }
            } else {
                console.warn('RestaurantApp or toast not available');
            }
        }, 100);
    });
</script>
<%
        }
    }
%>