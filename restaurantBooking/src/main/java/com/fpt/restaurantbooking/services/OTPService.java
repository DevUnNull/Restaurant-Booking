package com.fpt.restaurantbooking.services;

import com.fpt.restaurantbooking.models.EmailVerification;
import com.fpt.restaurantbooking.repositories.EmailVerificationRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.Optional;

/**
 * Service for OTP generation and validation
 */
public class OTPService {
    
    private static final Logger logger = LoggerFactory.getLogger(OTPService.class);
    private static final int OTP_LENGTH = 6;
    private static final int OTP_EXPIRY_MINUTES = 30;
    private static final String OTP_CHARACTERS = "0123456789";
    private static final SecureRandom random = new SecureRandom();
    
    private EmailVerificationRepository emailVerificationRepository;
    
    public OTPService(EmailVerificationRepository emailVerificationRepository) {
        this.emailVerificationRepository = emailVerificationRepository;
    }
    
    /**
     * Generate a new OTP code
     */
    public String generateOTP() {
        StringBuilder otp = new StringBuilder();
        for (int i = 0; i < OTP_LENGTH; i++) {
            otp.append(OTP_CHARACTERS.charAt(random.nextInt(OTP_CHARACTERS.length())));
        }
        return otp.toString();
    }
    
    /**
     * Generate and save OTP for user
     */
    public EmailVerification generateOTPForUser(Long userId) {
        try {
            // Invalidate any existing pending verifications for this user
            invalidateExistingVerifications(userId);
            
            // Generate new OTP
            String otpCode = generateOTP();
            
            // Create new verification record
            EmailVerification verification = new EmailVerification(userId, otpCode);
            verification.setExpirationTime(LocalDateTime.now().plusMinutes(OTP_EXPIRY_MINUTES));
            
            // Save to database
            EmailVerification savedVerification = emailVerificationRepository.save(verification);
            
            logger.info("Generated OTP for user ID: {}", userId);
            return savedVerification;
            
        } catch (Exception e) {
            logger.error("Error generating OTP for user ID: {}", userId, e);
            return null;
        }
    }
    
    /**
     * Validate OTP code for user
     */
    public boolean validateOTP(Long userId, String otpCode) {
        try {
            Optional<EmailVerification> verificationOpt = 
                emailVerificationRepository.findByUserIdAndOtpCode(userId, otpCode);
            
            if (verificationOpt.isEmpty()) {
                logger.warn("Invalid OTP attempt for user ID: {} with code: {}", userId, otpCode);
                return false;
            }
            
            EmailVerification verification = verificationOpt.get();
            
            // Check if already verified
            if (verification.isVerified()) {
                logger.warn("OTP already verified for user ID: {}", userId);
                return false;
            }
            
            // Check if expired
            if (verification.isExpired()) {
                verification.markAsExpired();
                emailVerificationRepository.update(verification);
                logger.warn("Expired OTP attempt for user ID: {}", userId);
                return false;
            }
            
            // Check if pending
            if (!verification.isPending()) {
                logger.warn("OTP not in pending status for user ID: {}", userId);
                return false;
            }
            
            // Mark as verified
            verification.markAsVerified();
            emailVerificationRepository.update(verification);
            
            logger.info("OTP successfully validated for user ID: {}", userId);
            return true;
            
        } catch (Exception e) {
            logger.error("Error validating OTP for user ID: {} with code: {}", userId, otpCode, e);
            return false;
        }
    }
    
    /**
     * Check if user has valid pending OTP
     */
    public boolean hasValidPendingOTP(Long userId) {
        try {
            Optional<EmailVerification> verificationOpt = 
                emailVerificationRepository.findLatestByUserId(userId);
            
            if (verificationOpt.isEmpty()) {
                return false;
            }
            
            EmailVerification verification = verificationOpt.get();
            return verification.isPending() && !verification.isExpired();
            
        } catch (Exception e) {
            logger.error("Error checking pending OTP for user ID: {}", userId, e);
            return false;
        }
    }
    
    /**
     * Get remaining time for OTP expiration in minutes
     */
    public long getRemainingTimeMinutes(Long userId) {
        try {
            Optional<EmailVerification> verificationOpt = 
                emailVerificationRepository.findLatestByUserId(userId);
            
            if (verificationOpt.isEmpty()) {
                return 0;
            }
            
            EmailVerification verification = verificationOpt.get();
            if (!verification.isPending() || verification.isExpired()) {
                return 0;
            }
            
            LocalDateTime now = LocalDateTime.now();
            LocalDateTime expiration = verification.getExpirationTime();
            
            return java.time.Duration.between(now, expiration).toMinutes();
            
        } catch (Exception e) {
            logger.error("Error getting remaining time for user ID: {}", userId, e);
            return 0;
        }
    }
    
    /**
     * Invalidate existing pending verifications for user
     */
    private void invalidateExistingVerifications(Long userId) {
        try {
            Optional<EmailVerification> existingOpt = 
                emailVerificationRepository.findLatestByUserId(userId);
            
            if (existingOpt.isPresent()) {
                EmailVerification existing = existingOpt.get();
                if (existing.isPending()) {
                    existing.markAsExpired();
                    emailVerificationRepository.update(existing);
                    logger.info("Invalidated existing OTP for user ID: {}", userId);
                }
            }
        } catch (Exception e) {
            logger.error("Error invalidating existing verifications for user ID: {}", userId, e);
        }
    }
    
    /**
     * Clean up expired verifications
     */
    public int cleanupExpiredVerifications() {
        try {
            int deletedCount = emailVerificationRepository.deleteExpiredVerifications();
            logger.info("Cleaned up {} expired verifications", deletedCount);
            return deletedCount;
        } catch (Exception e) {
            logger.error("Error cleaning up expired verifications", e);
            return 0;
        }
    }
    
    /**
     * Get OTP expiry time in minutes
     */
    public static int getOtpExpiryMinutes() {
        return OTP_EXPIRY_MINUTES;
    }
    
    /**
     * Get OTP length
     */
    public static int getOtpLength() {
        return OTP_LENGTH;
    }
}