<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<footer style="
        background: url('${pageContext.request.contextPath}/images/img_1.png') no-repeat center center/cover;
        color: #fff;
        position: relative;
        margin-top: 50px;
        ">
    <div class="footer-container">
        <div class="footer-top">
            <div class="footer-section contact">
                <h3 style="font-size: 1.5rem; margin-bottom: 15px; color: #ffd700;">Restaurant Booking</h3>
                <p style="margin-bottom: 10px; line-height: 1.6;">Experience authentic flavors and exceptional service at our restaurant.</p>
                <p style="margin: 8px 0;"><span style="margin-right: 8px;">Location:</span> 123 Restaurant Street, Food City</p>
                <p style="margin: 8px 0;"><span style="margin-right: 8px;">Phone:</span> +1 (555) 123-4567</p>
                <p style="margin: 8px 0;"><span style="margin-right: 8px;">Email:</span> info@restaurantbooking.com</p>
            </div>

            <div class="footer-section info">
                <h3 style="font-size: 1.3rem; margin-bottom: 15px; color: #ffd700;">Quick Links</h3>
                <ul style="list-style: none; padding: 0;">
                    <li style="margin: 10px 0;"><a href="${pageContext.request.contextPath}/" style="color: #ddd; text-decoration: none; transition: color 0.3s;">Home</a></li>
                    <li style="margin: 10px 0;"><a href="${pageContext.request.contextPath}/menu" style="color: #ddd; text-decoration: none; transition: color 0.3s;">Menu</a></li>
                    <li style="margin: 10px 0;"><a href="${pageContext.request.contextPath}/reservation" style="color: #ddd; text-decoration: none; transition: color 0.3s;">Reservations</a></li>
                    <li style="margin: 10px 0;"><a href="${pageContext.request.contextPath}/contact" style="color: #ddd; text-decoration: none; transition: color 0.3s;">Contact Us</a></li>
                </ul>
            </div>

            <div class="footer-section location">
                <h3 style="font-size: 1.3rem; margin-bottom: 15px; color: #ffd700;">Location</h3>
                <p style="margin-bottom: 15px;">123 Restaurant Street, Food City</p>
                <div class="map-container" style="
                    height: 180px;
                    border-radius: 10px;
                    overflow: hidden;
                    box-shadow: 0 4px 10px rgba(0,0,0,0.3);
                ">
                    <iframe 
                        src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3724.020116220433!2d105.80972827584135!3d21.031881087670317!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3135ab6c8f0450a1%3A0xc43bd24106768fcc!2zTG90dGUgRGVwYXJ0bWVudCBTdG9yZSwgNTQgUC4gTGnhu4V1IEdpYWksIEPhu5FuZyBW4buLLCBCYSDEkMOsbmgsIEjDoCBO4buZaSAxMTQwMCwgVmlldG5hbQ!5e0!3m2!1sen!2s!4v1761837583358!5m2!1sen!2s"
                        style="border:0; width:100%; height:100%;"
                        allowfullscreen=""
                        loading="lazy">
                    </iframe>
                </div>
            </div>
        </div>

        <!-- Footer Bottom -->
        <div class="footer-bottom" style="
            border-top: 1px solid rgba(255,255,255,0.2);
            padding-top: 20px;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 15px;
            text-align: center;
            font-size: 0.9rem;
        ">
            <div class="social-links" style="display: flex; gap: 20px;">
                <a href="#" target="_blank" style="color: #ddd; text-decoration: none; display: flex; align-items: center; gap: 8px; transition: color 0.3s;">
                    <i class="fab fa-facebook-f"></i> Facebook
                </a>
                <a href="#" target="_blank" style="color: #ddd; text-decoration: none; display: flex; align-items: center; gap: 8px; transition: color 0.3s;">
                    <i class="fab fa-instagram"></i> Instagram
                </a>
                <a href="#" target="_blank" style="color: #ddd; text-decoration: none; display: flex; align-items: center; gap: 8px; transition: color 0.3s;">
                    <i class="fab fa-twitter"></i> Twitter
                </a>
            </div>
            <div class="copyright">
                <p>&copy; <span id="currentYear">2024</span> Restaurant Booking. All rights reserved.</p>
            </div>
        </div>
    </div>
</footer>

<!-- JS: Cập nhật năm tự động -->
<script>
    document.getElementById('currentYear').textContent = new Date().getFullYear();
</script>

<!-- JS Files -->
<script src="${pageContext.request.contextPath}/js/common.js"></script>

        <!-- Toast Handler - Check for session toasts and display them -->
        <jsp:include page="toast-handler.jsp" />