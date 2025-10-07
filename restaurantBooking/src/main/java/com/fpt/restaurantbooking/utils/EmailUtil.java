package com.fpt.restaurantbooking.utils;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.InputStream;
import java.util.Properties;

/**
 * Email utility class for sending emails
 */
public class EmailUtil {
    
    private static final Logger logger = LoggerFactory.getLogger(EmailUtil.class);
    private static Properties emailProperties;
    private static final String EMAIL_CONFIG_FILE = "email.properties";
    
    static {
        loadEmailProperties();
    }
    
    /**
     * Load email configuration properties
     */
    private static void loadEmailProperties() {
        emailProperties = new Properties();
        try (InputStream input = EmailUtil.class.getClassLoader().getResourceAsStream(EMAIL_CONFIG_FILE)) {
            if (input != null) {
                emailProperties.load(input);
            } else {
                // Default email properties
                emailProperties.setProperty("mail.smtp.host", "smtp.gmail.com");
                emailProperties.setProperty("mail.smtp.port", "587");
                emailProperties.setProperty("mail.smtp.auth", "true");
                emailProperties.setProperty("mail.smtp.starttls.enable", "true");
                emailProperties.setProperty("mail.username", "your-email@gmail.com");
                emailProperties.setProperty("mail.password", "your-app-password");
                emailProperties.setProperty("mail.from", "your-email@gmail.com");
                emailProperties.setProperty("mail.from.name", "Hệ Thống Đặt Bàn Nhà Hàng");
                logger.warn("Email properties file not found, using default values");
            }
        } catch (Exception e) {
            logger.error("Error loading email properties", e);
        }
    }
    
    /**
     * Send simple text email
     */
    public static boolean sendEmail(String to, String subject, String body) {
        return sendEmail(to, subject, body, false);
    }
    
    /**
     * Send HTML email
     */
    public static boolean sendHtmlEmail(String to, String subject, String htmlBody) {
        return sendEmail(to, subject, htmlBody, true);
    }
    
    /**
     * Send email with specified content type
     */
    private static boolean sendEmail(String to, String subject, String body, boolean isHtml) {
        try {
            // Create session
            Session session = createEmailSession();
            
            // Create message
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(
                emailProperties.getProperty("mail.from"),
                emailProperties.getProperty("mail.from.name")
            ));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(subject);
            
            if (isHtml) {
                message.setContent(body, "text/html; charset=utf-8");
            } else {
                message.setText(body);
            }
            
            // Send message
            Transport.send(message);
            logger.info("Email sent successfully to: {}", to);
            return true;
            
        } catch (Exception e) {
            logger.error("Failed to send email to: {}", to, e);
            return false;
        }
    }
    
    /**
     * Create email session with authentication
     */
    private static Session createEmailSession() {
        Properties props = new Properties();
        props.putAll(emailProperties);
        
        return Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(
                    emailProperties.getProperty("mail.username"),
                    emailProperties.getProperty("mail.password")
                );
            }
        });
    }
    
    /**
     * Send verification email (DEPRECATED - use OTP verification instead)
     * This method is kept for backward compatibility but should not be used
     */
    @Deprecated
    public static boolean sendVerificationEmail(String to, String username, String verificationToken) {
        // This method is deprecated as email verification is now handled by OTP
        // Consider removing it or updating it to use OTP-based verification
        return false;
    }
    
    /**
     * Send reservation confirmation email
     */
    public static boolean sendReservationConfirmation(String to, String customerName, 
            String restaurantName, String dateTime, String partySize) {
        String subject = "Xác Nhận Đặt Bàn - " + restaurantName;
        
        String htmlBody = String.format("""
            <html>
            <body>
                <h2>Đặt Bàn Thành Công!</h2>
                <p>Kính gửi %s,</p>
                <p>Đặt bàn của bạn đã được xác nhận với các chi tiết sau:</p>
                <div style="background-color: #f9f9f9; padding: 15px; border-radius: 5px; margin: 15px 0;">
                    <p><strong>Nhà hàng:</strong> %s</p>
                    <p><strong>Ngày & Giờ:</strong> %s</p>
                    <p><strong>Số người:</strong> %s người</p>
                </div>
                <p>Vui lòng đến đúng giờ. Nếu bạn cần hủy hoặc thay đổi đặt bàn, vui lòng liên hệ với chúng tôi ít nhất 2 giờ trước.</p>
                <p>Chúng tôi mong được phục vụ bạn!</p>
                <p>Trân trọng,<br>Đội ngũ %s</p>
            </body>
            </html>
            """, customerName, restaurantName, dateTime, partySize, restaurantName);
        
        return sendHtmlEmail(to, subject, htmlBody);
    }
    
    /**
     * Send reservation cancellation email
     */
    public static boolean sendReservationCancellation(String to, String customerName, 
            String restaurantName, String dateTime, String reason) {
        String subject = "Đặt Bàn Đã Hủy - " + restaurantName;
        
        String htmlBody = String.format("""
            <html>
            <body>
                <h2>Đặt Bàn Đã Hủy</h2>
                <p>Kính gửi %s,</p>
                <p>Đặt bàn của bạn đã bị hủy:</p>
                <div style="background-color: #f9f9f9; padding: 15px; border-radius: 5px; margin: 15px 0;">
                    <p><strong>Nhà hàng:</strong> %s</p>
                    <p><strong>Ngày & Giờ:</strong> %s</p>
                    <p><strong>Lý do:</strong> %s</p>
                </div>
                <p>Chúng tôi xin lỗi vì sự bất tiện này. Bạn có thể đặt bàn mới bất cứ lúc nào.</p>
                <p>Trân trọng,<br>Đội ngũ %s</p>
            </body>
            </html>
            """, customerName, restaurantName, dateTime, reason, restaurantName);
        
        return sendHtmlEmail(to, subject, htmlBody);
    }
    
    /**
     * Send password reset email
     */
    public static boolean sendPasswordResetEmail(String to, String username, String resetToken) {
        String subject = "Đặt Lại Mật Khẩu - Hệ Thống Đặt Bàn Nhà Hàng";
        String resetUrl = getBaseUrl() + "/reset-password?token=" + resetToken + "&email=" + to;
        
        String htmlBody = String.format("""
            <html>
            <body>
                <h2>Yêu Cầu Đặt Lại Mật Khẩu</h2>
                <p>Xin chào %s,</p>
                <p>Bạn đã yêu cầu đặt lại mật khẩu. Nhấp vào liên kết bên dưới để đặt mật khẩu mới:</p>
                <p><a href="%s" style="background-color: #2196F3; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px;">Đặt Lại Mật Khẩu</a></p>
                <p>Nếu nút không hoạt động, sao chép và dán liên kết này vào trình duyệt của bạn:</p>
                <p>%s</p>
                <p>Liên kết này sẽ hết hạn sau 1 giờ. Nếu bạn không yêu cầu điều này, vui lòng bỏ qua email này.</p>
                <p>Trân trọng,<br>Đội Ngũ Đặt Bàn Nhà Hàng</p>
            </body>
            </html>
            """, username, resetUrl, resetUrl);
        
        return sendHtmlEmail(to, subject, htmlBody);
    }
    
    /**
     * Get base URL for email links
     */
    private static String getBaseUrl() {
        return emailProperties.getProperty("app.base.url", "http://localhost:8080/restaurantbooking");
    }
    
    /**
     * Test email configuration
     */
    public static boolean testEmailConfiguration() {
        try {
            Session session = createEmailSession();
            Transport transport = session.getTransport("smtp");
            transport.connect();
            transport.close();
            logger.info("Email configuration test successful");
            return true;
        } catch (Exception e) {
            logger.error("Email configuration test failed", e);
            return false;
        }
    }
}