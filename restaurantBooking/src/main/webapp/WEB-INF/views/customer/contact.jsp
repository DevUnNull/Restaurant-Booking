<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="Contact Us - Tica's Tacos" />
<c:set var="pageDescription" value="Get in touch with us for reservations, feedback, or any questions" />
<c:set var="pageCSS" value="contact.css" />
<c:set var="pageJS" value="contact.js" />

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle}</title>
    <meta name="description" content="${pageDescription}">
    
    <!-- Common CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    
    <!-- Page-specific CSS -->
    <c:if test="${not empty pageCSS}">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/${pageCSS}">
    </c:if>
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=Roboto:wght@400;700&display=swap" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <!-- Include Header -->
    <jsp:include page="../common/header.jsp" />

    <main class="main-content">
        <!-- Contact Hero Section -->
        <section class="contact-hero">
            <div class="container">
                <h1 class="hero-title">Contact Us</h1>
                <p class="hero-subtitle">We'd love to hear from you. Get in touch with us!</p>
            </div>
        </section>

        <!-- Contact Content -->
        <section class="contact-section">
            <div class="container">
                <div class="contact-grid">
                    <!-- Contact Form -->
                    <div class="contact-form-container">
                        <h2 class="section-title">Send us a Message</h2>
                        
                        <form id="contact-form" action="${pageContext.request.contextPath}/contact/submit" method="post" class="contact-form">
                            <div class="form-group">
                                <label for="contact-name">Full Name *</label>
                                <input type="text" id="contact-name" name="name" class="form-control" 
                                       placeholder="Enter your full name" required>
                            </div>
                            
                            <div class="form-group">
                                <label for="contact-email">Email Address *</label>
                                <input type="email" id="contact-email" name="email" class="form-control" 
                                       placeholder="Enter your email address" required>
                            </div>
                            
                            <div class="form-group">
                                <label for="contact-phone">Phone Number</label>
                                <input type="tel" id="contact-phone" name="phone" class="form-control" 
                                       placeholder="Enter your phone number">
                            </div>
                            
                            <div class="form-group">
                                <label for="contact-subject">Subject *</label>
                                <select id="contact-subject" name="subject" class="form-control" required>
                                    <option value="">Select a subject</option>
                                    <option value="reservation">Reservation Inquiry</option>
                                    <option value="feedback">Feedback</option>
                                    <option value="complaint">Complaint</option>
                                    <option value="catering">Catering Services</option>
                                    <option value="general">General Question</option>
                                    <option value="other">Other</option>
                                </select>
                            </div>
                            
                            <div class="form-group">
                                <label for="contact-message">Message *</label>
                                <textarea id="contact-message" name="message" class="form-control" 
                                          rows="6" placeholder="Enter your message here..." required></textarea>
                            </div>
                            
                            <button type="submit" class="btn btn-primary btn-submit">
                                <i class="fas fa-paper-plane"></i>
                                Send Message
                            </button>
                        </form>
                    </div>

                    <!-- Contact Information -->
                    <div class="contact-info-container">
                        <h2 class="section-title">Get in Touch</h2>
                        
                        <div class="contact-info">
                            <div class="info-item">
                                <div class="info-icon">
                                    <i class="fas fa-map-marker-alt"></i>
                                </div>
                                <div class="info-content">
                                    <h3>Address</h3>
                                    <p>123 Taco Street<br>
                                       Hanoi, Vietnam 10000</p>
                                </div>
                            </div>
                            
                            <div class="info-item">
                                <div class="info-icon">
                                    <i class="fas fa-phone"></i>
                                </div>
                                <div class="info-content">
                                    <h3>Phone</h3>
                                    <p><a href="tel:+84123456789">+84 123 456 789</a></p>
                                </div>
                            </div>
                            
                            <div class="info-item">
                                <div class="info-icon">
                                    <i class="fas fa-envelope"></i>
                                </div>
                                <div class="info-content">
                                    <h3>Email</h3>
                                    <p><a href="mailto:info@ticastacos.com">info@ticastacos.com</a></p>
                                </div>
                            </div>
                            
                            <div class="info-item">
                                <div class="info-icon">
                                    <i class="fas fa-clock"></i>
                                </div>
                                <div class="info-content">
                                    <h3>Opening Hours</h3>
                                    <p>Monday - Thursday: 11:00 AM - 10:00 PM<br>
                                       Friday - Saturday: 11:00 AM - 11:00 PM<br>
                                       Sunday: 12:00 PM - 9:00 PM</p>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Social Media Links -->
                        <div class="social-media">
                            <h3>Follow Us</h3>
                            <div class="social-links">
                                <a href="#" class="social-link facebook" aria-label="Facebook">
                                    <i class="fab fa-facebook-f"></i>
                                </a>
                                <a href="#" class="social-link instagram" aria-label="Instagram">
                                    <i class="fab fa-instagram"></i>
                                </a>
                                <a href="#" class="social-link twitter" aria-label="Twitter">
                                    <i class="fab fa-twitter"></i>
                                </a>
                                <a href="#" class="social-link youtube" aria-label="YouTube">
                                    <i class="fab fa-youtube"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Map Section -->
        <section class="map-section">
            <div class="container">
                <h2 class="section-title">Find Us</h2>
                <div class="map-container">
                    <iframe 
                        src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3724.0969470624447!2d105.83615831533456!3d21.035785885995!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3135ab9bd9861ca1%3A0xe7887f7b72ca17a!2sHanoi%2C%20Vietnam!5e0!3m2!1sen!2s!4v1642974014000!5m2!1sen!2s"
                        width="100%" 
                        height="400" 
                        style="border:0;" 
                        allowfullscreen="" 
                        loading="lazy" 
                        referrerpolicy="no-referrer-when-downgrade"
                        title="Restaurant Location">
                    </iframe>
                </div>
            </div>
        </section>

        <!-- FAQ Section -->
        <section class="faq-section">
            <div class="container">
                <h2 class="section-title">Frequently Asked Questions</h2>
                <div class="faq-grid">
                    <div class="faq-item">
                        <h3 class="faq-question">Do you take reservations?</h3>
                        <p class="faq-answer">Yes, we accept reservations for parties of 4 or more. You can make a reservation through our website or by calling us directly.</p>
                    </div>
                    
                    <div class="faq-item">
                        <h3 class="faq-question">Do you offer delivery?</h3>
                        <p class="faq-answer">Yes, we offer delivery within a 10km radius of our restaurant. Delivery fees apply based on distance.</p>
                    </div>
                    
                    <div class="faq-item">
                        <h3 class="faq-question">Do you have vegetarian options?</h3>
                        <p class="faq-answer">Absolutely! We have a variety of vegetarian tacos, burritos, and other dishes. All vegetarian items are clearly marked on our menu.</p>
                    </div>
                    
                    <div class="faq-item">
                        <h3 class="faq-question">Can you cater events?</h3>
                        <p class="faq-answer">Yes, we provide catering services for events of all sizes. Please contact us at least 48 hours in advance to discuss your catering needs.</p>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <!-- Include Footer -->
    <jsp:include page="../common/footer.jsp" />

    <!-- Common JavaScript -->
    <script src="${pageContext.request.contextPath}/js/common.js"></script>
    
    <!-- Page-specific JavaScript -->
    <c:if test="${not empty pageJS}">
        <script src="${pageContext.request.contextPath}/js/${pageJS}"></script>
    </c:if>

    <!-- Contact Data for JavaScript -->
    <script>
        // Pass server-side data to client-side JavaScript
        window.contactData = {
            contextPath: "${pageContext.request.contextPath}",
            submitUrl: "${pageContext.request.contextPath}/contact/submit"
        };
    </script>
    
    <!-- Toast Handler -->
    <jsp:include page="../common/toast-handler.jsp" />
</body>
</html>