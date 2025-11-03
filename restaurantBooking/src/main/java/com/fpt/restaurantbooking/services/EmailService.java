package com.fpt.restaurantbooking.services;

import com.fpt.restaurantbooking.dto.OrderManagementDTO;
import com.fpt.restaurantbooking.models.EmailVerification;
import com.fpt.restaurantbooking.models.User;
import com.fpt.restaurantbooking.utils.EmailUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.time.format.DateTimeFormatter;

/**
 * Service for sending email verification related emails
 */
public class EmailService {

    private static final Logger logger = LoggerFactory.getLogger(EmailService.class);

    /**
     * Send OTP verification email to user
     */
    public boolean sendOTPVerificationEmail(User user, String otpCode) {
        try {
            String subject = "Xác Thực Email - Hệ Thống Đặt Bàn Nhà Hàng";
            String htmlBody = buildOTPEmailTemplate(user.getFullName(), otpCode);

            boolean sent = EmailUtil.sendHtmlEmail(user.getEmail(), subject, htmlBody);

            if (sent) {
                logger.info("OTP verification email sent successfully to: {}", user.getEmail());
            } else {
                logger.error("Failed to send OTP verification email to: {}", user.getEmail());
            }

            return sent;

        } catch (Exception e) {
            logger.error("Error sending OTP verification email to: {}", user.getEmail(), e);
            return false;
        }
    }

    /**
     * Send OTP verification email using EmailVerification object
     */
    public boolean sendOTPVerificationEmail(User user, EmailVerification verification) {
        return sendOTPVerificationEmail(user, verification.getOtpCode());
    }

    /**
     * Send email verification success notification
     */
    public boolean sendVerificationSuccessEmail(User user) {
        try {
            String subject = "Xác Thực Email Thành Công - Hệ Thống Đặt Bàn Nhà Hàng";
            String htmlBody = buildVerificationSuccessTemplate(user.getFullName());

            boolean sent = EmailUtil.sendHtmlEmail(user.getEmail(), subject, htmlBody);

            if (sent) {
                logger.info("Verification success email sent successfully to: {}", user.getEmail());
            } else {
                logger.error("Failed to send verification success email to: {}", user.getEmail());
            }

            return sent;

        } catch (Exception e) {
            logger.error("Error sending verification success email to: {}", user.getEmail(), e);
            return false;
        }
    }

    /**
     * Send OTP resend notification email
     */
    public boolean sendOTPResendEmail(User user, String otpCode) {
        try {
            String subject = "Mã OTP Mới - Hệ Thống Đặt Bàn Nhà Hàng";
            String htmlBody = buildOTPResendTemplate(user.getFullName(), otpCode);

            boolean sent = EmailUtil.sendHtmlEmail(user.getEmail(), subject, htmlBody);

            if (sent) {
                logger.info("OTP resend email sent successfully to: {}", user.getEmail());
            } else {
                logger.error("Failed to send OTP resend email to: {}", user.getEmail());
            }

            return sent;

        } catch (Exception e) {
            logger.error("Error sending OTP resend email to: {}", user.getEmail(), e);
            return false;
        }
    }

    /**
     * Send order status change notification email
     */
    public boolean sendOrderStatusChangeEmail(OrderManagementDTO order, String newStatus) {
        try {
            if (order.getCustomerEmail() == null || order.getCustomerEmail().isEmpty()) {
                logger.warn("No email found for order {}, cannot send status change notification",
                        order.getReservationId());
                return false;
            }

            String subject = "Thông Báo Thay Đổi Trạng Thái Đơn Hàng - Hệ Thống Đặt Bàn Nhà Hàng";
            String htmlBody = buildOrderStatusChangeTemplate(order, newStatus);

            boolean sent = EmailUtil.sendHtmlEmail(order.getCustomerEmail(), subject, htmlBody);

            if (sent) {
                logger.info("Order status change email sent successfully to: {} for order {}",
                        order.getCustomerEmail(), order.getReservationId());
            } else {
                logger.error("Failed to send order status change email to: {} for order {}",
                        order.getCustomerEmail(), order.getReservationId());
            }

            return sent;

        } catch (Exception e) {
            logger.error("Error sending order status change email for order {}",
                    order.getReservationId(), e);
            return false;
        }
    }

    /**
     * Build OTP verification email template
     */
    private String buildOTPEmailTemplate(String userName, String otpCode) {
        return "<!DOCTYPE html>" +
                "<html>" +
                "<head>" +
                "    <meta charset='UTF-8'>" +
                "    <meta name='viewport' content='width=device-width, initial-scale=1.0'>" +
                "    <title>Xác Thực Email</title>" +
                "    <style>" +
                "        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto; padding: 20px; }" +
                "        .header { background-color: #d4a574; color: white; padding: 20px; text-align: center; border-radius: 8px 8px 0 0; }" +
                "        .content { background-color: #f9f9f9; padding: 30px; border-radius: 0 0 8px 8px; }" +
                "        .otp-code { background-color: #fff; border: 2px solid #d4a574; padding: 20px; text-align: center; margin: 20px 0; border-radius: 8px; }" +
                "        .otp-number { font-size: 32px; font-weight: bold; color: #d4a574; letter-spacing: 8px; }" +
                "        .warning { background-color: #fff3cd; border: 1px solid #ffeaa7; padding: 15px; border-radius: 5px; margin: 20px 0; }" +
                "        .footer { text-align: center; margin-top: 30px; color: #666; font-size: 14px; }" +
                "    </style>" +
                "</head>" +
                "<body>" +
                "    <div class='header'>" +
                "        <h1>Hệ Thống Đặt Bàn Nhà Hàng</h1>" +
                "        <h2>Xác Thực Email</h2>" +
                "    </div>" +
                "    <div class='content'>" +
                "        <h3>Xin chào " + userName + ",</h3>" +
                "        <p>Cảm ơn bạn đã đăng ký với Hệ Thống Đặt Bàn Nhà Hàng của chúng tôi. Để hoàn tất đăng ký, vui lòng xác thực địa chỉ email của bạn bằng cách sử dụng mã OTP bên dưới:</p>" +
                "        <div class='otp-code'>" +
                "            <p>Mã xác thực của bạn là:</p>" +
                "            <div class='otp-number'>" + otpCode + "</div>" +
                "        </div>" +
                "        <div class='warning'>" +
                "            <strong>Quan trọng:</strong>" +
                "            <ul>" +
                "                <li>Mã này sẽ hết hạn sau 30 phút</li>" +
                "                <li>Không chia sẻ mã này với bất kỳ ai</li>" +
                "                <li>Nếu bạn không yêu cầu xác thực này, vui lòng bỏ qua email này</li>" +
                "            </ul>" +
                "        </div>" +
                "        <p>Nhập mã này trên trang xác thực để kích hoạt tài khoản và bắt đầu đặt bàn.</p>" +
                "        <p>Nếu bạn có bất kỳ câu hỏi nào hoặc cần hỗ trợ, vui lòng liên hệ với đội ngũ hỗ trợ của chúng tôi.</p>" +
                "    </div>" +
                "    <div class='footer'>" +
                "        <p>Trân trọng,<br>Đội Ngũ Hệ Thống Đặt Bàn Nhà Hàng</p>" +
                "        <p><small>Đây là email tự động. Vui lòng không trả lời email này.</small></p>" +
                "    </div>" +
                "</body>" +
                "</html>";
    }

    /**
     * Build verification success email template
     */
    private String buildVerificationSuccessTemplate(String userName) {
        return "<!DOCTYPE html>" +
                "<html>" +
                "<head>" +
                "    <meta charset='UTF-8'>" +
                "    <meta name='viewport' content='width=device-width, initial-scale=1.0'>" +
                "    <title>Xác Thực Email Thành Công</title>" +
                "    <style>" +
                "        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto; padding: 20px; }" +
                "        .header { background-color: #28a745; color: white; padding: 20px; text-align: center; border-radius: 8px 8px 0 0; }" +
                "        .content { background-color: #f9f9f9; padding: 30px; border-radius: 0 0 8px 8px; }" +
                "        .success-icon { font-size: 48px; color: #28a745; text-align: center; margin: 20px 0; }" +
                "        .footer { text-align: center; margin-top: 30px; color: #666; font-size: 14px; }" +
                "    </style>" +
                "</head>" +
                "<body>" +
                "    <div class='header'>" +
                "        <h1>Hệ Thống Đặt Bàn Nhà Hàng</h1>" +
                "        <h2>Xác Thực Email Thành Công!</h2>" +
                "    </div>" +
                "    <div class='content'>" +
                "        <div class='success-icon'>✅</div>" +
                "        <h3>Chúc mừng " + userName + "!</h3>" +
                "        <p>Địa chỉ email của bạn đã được xác thực thành công. Tài khoản của bạn hiện đã hoạt động và bạn có thể:</p>" +
                "        <ul>" +
                "            <li>Đặt bàn tại nhà hàng</li>" +
                "            <li>Xem và quản lý đặt bàn của bạn</li>" +
                "            <li>Nhận xác nhận và cập nhật về đặt bàn</li>" +
                "            <li>Truy cập tất cả tính năng của hệ thống</li>" +
                "        </ul>" +
                "        <p>Cảm ơn bạn đã chọn Hệ Thống Đặt Bàn Nhà Hàng của chúng tôi. Chúng tôi mong được phục vụ bạn!</p>" +
                "    </div>" +
                "    <div class='footer'>" +
                "        <p>Trân trọng,<br>Đội Ngũ Đặt Bàn Nhà Hàng</p>" +
                "    </div>" +
                "</body>" +
                "</html>";
    }

    /**
     * Build OTP resend email template
     */
    private String buildOTPResendTemplate(String userName, String otpCode) {
        return "<!DOCTYPE html>" +
                "<html>" +
                "<head>" +
                "    <meta charset='UTF-8'>" +
                "    <meta name='viewport' content='width=device-width, initial-scale=1.0'>" +
                "    <title>Mã OTP Mới</title>" +
                "    <style>" +
                "        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto; padding: 20px; }" +
                "        .header { background-color: #17a2b8; color: white; padding: 20px; text-align: center; border-radius: 8px 8px 0 0; }" +
                "        .content { background-color: #f9f9f9; padding: 30px; border-radius: 0 0 8px 8px; }" +
                "        .otp-code { background-color: #fff; border: 2px solid #17a2b8; padding: 20px; text-align: center; margin: 20px 0; border-radius: 8px; }" +
                "        .otp-number { font-size: 32px; font-weight: bold; color: #17a2b8; letter-spacing: 8px; }" +
                "        .info { background-color: #d1ecf1; border: 1px solid #bee5eb; padding: 15px; border-radius: 5px; margin: 20px 0; }" +
                "        .footer { text-align: center; margin-top: 30px; color: #666; font-size: 14px; }" +
                "    </style>" +
                "</head>" +
                "<body>" +
                "    <div class='header'>" +
                "        <h1>Hệ Thống Đặt Bàn Nhà Hàng</h1>" +
                "        <h2>Mã Xác Thực Mới</h2>" +
                "    </div>" +
                "    <div class='content'>" +
                "        <h3>Xin chào " + userName + ",</h3>" +
                "        <p>Bạn đã yêu cầu mã xác thực mới. Đây là mã OTP mới của bạn:</p>" +
                "        <div class='otp-code'>" +
                "            <p>Mã xác thực mới của bạn là:</p>" +
                "            <div class='otp-number'>" + otpCode + "</div>" +
                "        </div>" +
                "        <div class='info'>" +
                "            <strong>Lưu ý:</strong>" +
                "            <ul>" +
                "                <li>Mã mới này sẽ hết hạn sau 30 phút</li>" +
                "                <li>Mã trước đó không còn hiệu lực</li>" +
                "                <li>Sử dụng mã này để hoàn tất xác thực email</li>" +
                "            </ul>" +
                "        </div>" +
                "        <p>Nhập mã này trên trang xác thực để kích hoạt tài khoản của bạn.</p>" +
                "    </div>" +
                "    <div class='footer'>" +
                "        <p>Trân trọng,<br>Đội Ngũ Hệ Thống Đặt Bàn Nhà Hàng</p>" +
                "        <p><small>Đây là email tự động. Vui lòng không trả lời email này.</small></p>" +
                "    </div>" +
                "</body>" +
                "</html>";
    }

    /**
     * Build order status change email template
     */
    private String buildOrderStatusChangeTemplate(OrderManagementDTO order, String newStatus) {
        // Map status to Vietnamese
        String statusText = mapStatusToVietnamese(newStatus);

        // Format date and time
        DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
        String formattedDate = order.getReservationDate() != null
                ? order.getReservationDate().format(dateFormatter) : "N/A";
        String formattedTime = order.getReservationTime() != null
                ? order.getReservationTime().format(timeFormatter) : "N/A";

        // Format amount
        String formattedAmount = formatAmount(order.getTotalAmount());

        // Get table names
        String tableNames = order.getTableNames() != null && !order.getTableNames().isEmpty()
                ? order.getTableNames() : "Chưa xác định";

        return "<!DOCTYPE html>" +
                "<html>" +
                "<head>" +
                "    <meta charset='UTF-8'>" +
                "    <meta name='viewport' content='width=device-width, initial-scale=1.0'>" +
                "    <title>Thông Báo Trạng Thái Đơn Hàng</title>" +
                "    <style>" +
                "        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto; padding: 20px; }" +
                "        .header { background-color: #dc3545; color: white; padding: 20px; text-align: center; border-radius: 8px 8px 0 0; }" +
                "        .content { background-color: #f9f9f9; padding: 30px; border-radius: 0 0 8px 8px; }" +
                "        .status-box { background-color: #fff; border: 2px solid #dc3545; padding: 20px; text-align: center; margin: 20px 0; border-radius: 8px; }" +
                "        .status-text { font-size: 24px; font-weight: bold; color: #dc3545; }" +
                "        .details { background-color: #fff; padding: 15px; border-radius: 5px; margin: 20px 0; }" +
                "        .details p { margin: 10px 0; }" +
                "        .details strong { color: #333; }" +
                "        .footer { text-align: center; margin-top: 30px; color: #666; font-size: 14px; }" +
                "    </style>" +
                "</head>" +
                "<body>" +
                "    <div class='header'>" +
                "        <h1>Hệ Thống Đặt Bàn Nhà Hàng</h1>" +
                "        <h2>Thông Báo Thay Đổi Trạng Thái</h2>" +
                "    </div>" +
                "    <div class='content'>" +
                "        <h3>Xin chào " + (order.getCustomerName() != null ? order.getCustomerName() : "Quý khách") + ",</h3>" +
                "        <p>Chúng tôi xin thông báo rằng trạng thái đơn đặt bàn của bạn đã được cập nhật.</p>" +
                "        <div class='status-box'>" +
                "            <p>Trạng thái mới:</p>" +
                "            <div class='status-text'>" + statusText + "</div>" +
                "        </div>" +
                "        <div class='details'>" +
                "            <p><strong>Mã đơn hàng:</strong> #" + order.getReservationId() + "</p>" +
                "            <p><strong>Ngày:</strong> " + formattedDate + "</p>" +
                "            <p><strong>Giờ:</strong> " + formattedTime + "</p>" +
                "            <p><strong>Bàn:</strong> " + tableNames + "</p>" +
                "            <p><strong>Số khách:</strong> " + order.getGuestCount() + " người</p>" +
                "            <p><strong>Tổng tiền:</strong> " + formattedAmount + "</p>" +
                "        </div>" +
                "        <p>Cảm ơn bạn đã sử dụng dịch vụ của chúng tôi!</p>" +
                "        <p>Nếu có bất kỳ thắc mắc nào, vui lòng liên hệ với chúng tôi qua số hotline hoặc email hỗ trợ.</p>" +
                "    </div>" +
                "    <div class='footer'>" +
                "        <p>Trân trọng,<br>Đội Ngũ Hệ Thống Đặt Bàn Nhà Hàng</p>" +
                "        <p><small>Đây là email tự động. Vui lòng không trả lời email này.</small></p>" +
                "    </div>" +
                "</body>" +
                "</html>";
    }

    /**
     * Map order status to Vietnamese text
     */
    private String mapStatusToVietnamese(String status) {
        if (status == null) {
            return "Không xác định";
        }

        switch (status.toUpperCase()) {
            case "PENDING":
                return "Chờ Xác Nhận";
            case "CONFIRMED":
                return "Đã Xác Nhận";
            case "COMPLETED":
                return "Hoàn Thành";
            case "CANCELLED":
                return "Đã Hủy";
            case "NO_SHOW":
                return "Không Đến";
            default:
                return status;
        }
    }

    /**
     * Format amount to Vietnamese currency format
     */
    private String formatAmount(java.math.BigDecimal amount) {
        if (amount == null) {
            return "0 VNĐ";
        }

        DecimalFormatSymbols symbols = new DecimalFormatSymbols();
        symbols.setGroupingSeparator(',');
        DecimalFormat formatter = new DecimalFormat("#,###", symbols);
        return formatter.format(amount) + " VNĐ";
    }
}