package com.fpt.restaurantbooking.utils;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.regex.Pattern;

/**
 * Validation utility class for common validation operations
 */
public class ValidationUtil {
    
    private static final Logger logger = LoggerFactory.getLogger(ValidationUtil.class);
    
    // Email regex pattern
    private static final Pattern EMAIL_PATTERN = Pattern.compile(
        "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$"
    );
    
    // Phone regex pattern (supports various formats)
    private static final Pattern PHONE_PATTERN = Pattern.compile(
        "^[+]?[0-9]{10,15}$"
    );
    
    // Email pattern is already defined above
    
    // Password pattern (at least 8 characters, one uppercase, one lowercase, one digit)
    private static final Pattern PASSWORD_PATTERN = Pattern.compile(
        "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d@$!%*?&]{8,}$"
    );
    
    /**
     * Validate email format
     */
    public static boolean isValidEmail(String email) {
        return email != null && EMAIL_PATTERN.matcher(email.trim()).matches();
    }
    
    /**
     * Validate phone number format
     */
    public static boolean isValidPhone(String phone) {
        if (phone == null) return false;
        String cleanPhone = phone.replaceAll("[\\s()-]", "");
        return PHONE_PATTERN.matcher(cleanPhone).matches();
    }
    
    /**
     * Validate email format (already defined as isValidEmail)
     */
    
    /**
     * Validate password strength
     */
    public static boolean isValidPassword(String password) {
        return password != null && PASSWORD_PATTERN.matcher(password).matches();
    }
    
    /**
     * Check if string is null or empty
     */
    public static boolean isEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }
    
    /**
     * Check if string is not null and not empty
     */
    public static boolean isNotEmpty(String str) {
        return !isEmpty(str);
    }
    
    /**
     * Validate string length
     */
    public static boolean isValidLength(String str, int minLength, int maxLength) {
        if (str == null) return false;
        int length = str.trim().length();
        return length >= minLength && length <= maxLength;
    }
    
    /**
     * Validate positive integer
     */
    public static boolean isPositiveInteger(Integer value) {
        return value != null && value > 0;
    }
    
    /**
     * Validate positive long
     */
    public static boolean isPositiveLong(Long value) {
        return value != null && value > 0;
    }
    
    /**
     * Validate that date is in the future
     */
    public static boolean isFutureDateTime(LocalDateTime dateTime) {
        return dateTime != null && dateTime.isAfter(LocalDateTime.now());
    }
    
    /**
     * Validate that date is not too far in the future (within 1 year)
     */
    public static boolean isReasonableFutureDateTime(LocalDateTime dateTime) {
        if (dateTime == null) return false;
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime oneYearFromNow = now.plusYears(1);
        return dateTime.isAfter(now) && dateTime.isBefore(oneYearFromNow);
    }
    
    /**
     * Validate business hours (between 6 AM and 11 PM)
     */
    public static boolean isValidBusinessHour(LocalTime time) {
        if (time == null) return false;
        LocalTime openTime = LocalTime.of(6, 0);
        LocalTime closeTime = LocalTime.of(23, 0);
        return !time.isBefore(openTime) && !time.isAfter(closeTime);
    }
    
    /**
     * Validate party size for restaurant reservation
     */
    public static boolean isValidPartySize(Integer partySize) {
        return partySize != null && partySize >= 1 && partySize <= 20;
    }
    
    /**
     * Validate table capacity
     */
    public static boolean isValidTableCapacity(Integer capacity) {
        return capacity != null && capacity >= 1 && capacity <= 50;
    }
    
    /**
     * Validate restaurant rating (1-5 stars)
     */
    public static boolean isValidRating(Double rating) {
        return rating != null && rating >= 1.0 && rating <= 5.0;
    }
    
    /**
     * Validate price range (LOW, MEDIUM, HIGH, PREMIUM)
     */
    public static boolean isValidPriceRange(String priceRange) {
        if (isEmpty(priceRange)) return false;
        return priceRange.matches("^(LOW|MEDIUM|HIGH|PREMIUM)$");
    }
    
    /**
     * Sanitize string input (remove HTML tags and trim)
     */
    public static String sanitizeInput(String input) {
        if (input == null) return null;
        return input.replaceAll("<[^>]*>", "").trim();
    }
    
    /**
     * Validate and sanitize name (letters, spaces, hyphens, apostrophes only)
     */
    public static String sanitizeName(String name) {
        if (isEmpty(name)) return null;
        String sanitized = name.replaceAll("[^a-zA-Z\\s'-]", "").trim();
        return sanitized.isEmpty() ? null : sanitized;
    }
    
    /**
     * Validate URL format
     */
    public static boolean isValidUrl(String url) {
        if (isEmpty(url)) return false;
        try {
            new java.net.URL(url);
            return true;
        } catch (Exception e) {
            return false;
        }
    }
    
    /**
     * Validate that reservation time is at least 1 hour from now
     */
    public static boolean isValidReservationTime(LocalDateTime reservationTime) {
        if (reservationTime == null) return false;
        LocalDateTime minimumTime = LocalDateTime.now().plusHours(1);
        return reservationTime.isAfter(minimumTime);
    }
    
    /**
     * Validate that cancellation is allowed (at least 2 hours before reservation)
     */
    public static boolean isCancellationAllowed(LocalDateTime reservationTime) {
        if (reservationTime == null) return false;
        LocalDateTime minimumCancelTime = LocalDateTime.now().plusHours(2);
        return reservationTime.isAfter(minimumCancelTime);
    }
    
    /**
     * Get validation error message for password
     */
    public static String getPasswordValidationMessage() {
        return "Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, and one digit.";
    }
    
    /**
     * Get validation error message for email
     */
    public static String getEmailValidationMessage() {
        return "Please enter a valid email address.";
    }
    
    /**
     * Get validation error message for phone
     */
    public static String getPhoneValidationMessage() {
        return "Please enter a valid phone number (10-15 digits).";
    }
    
    /**
     * Get validation error message for username
     */
    public static String getUsernameValidationMessage() {
        return "Username must be 3-20 characters long and contain only letters, numbers, underscores, and hyphens.";
    }
}