<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <footer style="background-color:#ad0505;">
    <div class="footer-container">
        <div class="footer-top">
            <div class="footer-section contact">
                <h3>Restaurant Booking</h3>
                <p>Experience authentic flavors and exceptional service at our restaurant.</p>
                <p>📍 123 Restaurant Street, Food City</p>
                <p>📞 +1 (555) 123-4567</p>
                <p>✉️ info@restaurantbooking.com</p>
            </div>
            
            <div class="footer-section info">
                <h3>Quick Links</h3>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/">Home</a></li>
                    <li><a href="${pageContext.request.contextPath}/menu">Menu</a></li>
                    <li><a href="${pageContext.request.contextPath}/reservation">Reservations</a></li>
                    <li><a href="${pageContext.request.contextPath}/contact">Contact Us</a></li>
                </ul>
            </div>
            
            <div class="footer-section location">
                <h3>Location</h3>
                <p>123 Restaurant Street, Food City</p>
                <div class="map-container">
                    <iframe 
                        src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d1000!2d0!3d0!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x0%3A0x0!2zNDDCsDAwJzAwLjAiTiAwwrAwMCcwMC4wIkU!5e0!3m2!1sen!2sus!4v1234567890" 
                        style="border:0;" 
                        allowfullscreen="" 
                        loading="lazy">
                    </iframe>
                </div>
            </div>
        </div>
        
        <div class="footer-bottom">
            <div class="social-links">
                <a href="#" target="_blank"><i class="fab fa-facebook-f"></i> Facebook</a>
                <a href="#" target="_blank"><i class="fab fa-instagram"></i> Instagram</a>
                <a href="#" target="_blank"><i class="fab fa-twitter"></i> Twitter</a>
            </div>
            <div class="copyright">
                <p>&copy; <span id="currentYear">2024</span> Restaurant Booking. All rights reserved.</p>
            </div>
        </div>
    </div>
</footer>

        <script>
            // Set current year
            document.getElementById('currentYear').textContent = new Date().getFullYear();
        </script>
        <!-- JavaScript Files -->
        <script src="${pageContext.request.contextPath}/js/common.js"></script>

        <!-- Toast Handler - Check for session toasts and display them -->
        <jsp:include page="toast-handler.jsp" />