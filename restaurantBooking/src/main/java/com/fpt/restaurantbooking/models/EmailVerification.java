package com.fpt.restaurantbooking.models;

import java.time.LocalDateTime;

/**
 * EmailVerification entity for managing OTP-based email verification
 */
public class EmailVerification extends BaseEntity {
    private Long verificationId;
    private Long userId;
    private String otpCode;
    private String resetToken;
    private LocalDateTime expirationTime;
    private String status;
    
    public enum VerificationStatus {
        PENDING, VERIFIED, EXPIRED, FAILED
    }
    
    public EmailVerification() {
        super();
        this.status = VerificationStatus.PENDING.name();
        this.expirationTime = LocalDateTime.now().plusMinutes(30); // 30 minutes expiration
    }
    
    public EmailVerification(Long userId, String otpCode) {
        this();
        this.userId = userId;
        this.otpCode = otpCode;
    }
    
    // Getters and Setters
    public Long getVerificationId() {
        return verificationId;
    }
    
    public void setVerificationId(Long verificationId) {
        this.verificationId = verificationId;
    }
    
    public Long getUserId() {
        return userId;
    }
    
    public void setUserId(Long userId) {
        this.userId = userId;
    }
    
    public String getOtpCode() {
        return otpCode;
    }
    
    public void setOtpCode(String otpCode) {
        this.otpCode = otpCode;
    }
    
    public String getResetToken() {
        return resetToken;
    }
    
    public void setResetToken(String resetToken) {
        this.resetToken = resetToken;
    }
    
    public LocalDateTime getExpirationTime() {
        return expirationTime;
    }
    
    public void setExpirationTime(LocalDateTime expirationTime) {
        this.expirationTime = expirationTime;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public void setStatus(VerificationStatus status) {
        this.status = status.name();
    }
    
    /**
     * Check if the OTP has expired
     */
    public boolean isExpired() {
        return LocalDateTime.now().isAfter(this.expirationTime);
    }
    
    /**
     * Check if the verification is pending
     */
    public boolean isPending() {
        return VerificationStatus.PENDING.name().equals(this.status);
    }
    
    /**
     * Check if the verification is verified
     */
    public boolean isVerified() {
        return VerificationStatus.VERIFIED.name().equals(this.status);
    }
    
    /**
     * Mark as verified
     */
    public void markAsVerified() {
        this.status = VerificationStatus.VERIFIED.name();
        this.updateTimestamp();
    }
    
    /**
     * Mark as expired
     */
    public void markAsExpired() {
        this.status = VerificationStatus.EXPIRED.name();
        this.updateTimestamp();
    }
    
    /**
     * Mark as failed
     */
    public void markAsFailed() {
        this.status = VerificationStatus.FAILED.name();
        this.updateTimestamp();
    }
    
    @Override
    public String toString() {
        return "EmailVerification{" +
                "verificationId=" + verificationId +
                ", userId=" + userId +
                ", status='" + status + '\'' +
                ", expirationTime=" + expirationTime +
                ", createdAt=" + createdAt +
                '}';
    }
}