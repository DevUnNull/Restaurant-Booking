package com.fpt.restaurantbooking.repositories;

import com.fpt.restaurantbooking.models.EmailVerification;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * Repository interface for EmailVerification entity
 */
public interface EmailVerificationRepository extends BaseRepository<EmailVerification, Long> {
    
    /**
     * Find verification by user ID
     */
    Optional<EmailVerification> findByUserId(Long userId);
    
    /**
     * Find verification by OTP code
     */
    Optional<EmailVerification> findByOtpCode(String otpCode);
    
    /**
     * Find verification by reset token
     */
    Optional<EmailVerification> findByResetToken(String resetToken);
    
    /**
     * Find verification by user ID and OTP code
     */
    Optional<EmailVerification> findByUserIdAndOtpCode(Long userId, String otpCode);
    
    /**
     * Find latest verification by user ID
     */
    Optional<EmailVerification> findLatestByUserId(Long userId);
    
    /**
     * Find all pending verifications
     */
    List<EmailVerification> findPendingVerifications();
    
    /**
     * Find all expired verifications
     */
    List<EmailVerification> findExpiredVerifications();
    
    /**
     * Find verifications by status
     */
    List<EmailVerification> findByStatus(String status);
    
    /**
     * Find verifications by user ID and status
     */
    List<EmailVerification> findByUserIdAndStatus(Long userId, String status);
    
    /**
     * Check if user has pending verification
     */
    boolean hasPendingVerification(Long userId);
    
    /**
     * Check if OTP code exists and is valid
     */
    boolean isValidOtpCode(String otpCode);
    
    /**
     * Delete expired verifications
     */
    int deleteExpiredVerifications();
    
    /**
     * Delete verifications by user ID
     */
    boolean deleteByUserId(Long userId);
    
    /**
     * Update verification status
     */
    boolean updateStatus(Long verificationId, String status);
    
    /**
     * Mark verification as verified
     */
    boolean markAsVerified(Long verificationId);
    
    /**
     * Mark verification as expired
     */
    boolean markAsExpired(Long verificationId);
    
    /**
     * Mark verification as failed
     */
    boolean markAsFailed(Long verificationId);
    
    /**
     * Count verifications by status
     */
    long countByStatus(String status);
    
    /**
     * Count pending verifications for user
     */
    long countPendingByUserId(Long userId);
    
    /**
     * Find verifications created before specified time
     */
    List<EmailVerification> findCreatedBefore(LocalDateTime dateTime);
    
    /**
     * Find verifications expiring before specified time
     */
    List<EmailVerification> findExpiringBefore(LocalDateTime dateTime);
}