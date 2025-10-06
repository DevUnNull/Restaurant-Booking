package com.fpt.restaurantbooking.services;

import com.fpt.restaurantbooking.models.User;
import com.fpt.restaurantbooking.repositories.UserRepository;

import java.util.List;
import java.util.Optional;

/**
 * Service interface for User business operations
 */
public interface UserService extends BaseService<User, Long> {
    
    /**
     * Register a new user
     */
    User register(User user, String password);
    
    /**
     * Authenticate user login by email
     */
    Optional<User> authenticate(String email, String password);
    
    /**
     * Find user by email
     */
    Optional<User> findByEmail(String email);
    
    /**
     * Check if email is available
     */
    boolean isEmailAvailable(String email);
    
    /**
     * Update user password
     */
    boolean updatePassword(Long userId, String currentPassword, String newPassword);
    
    /**
     * Reset password
     */
    boolean resetPassword(String email);
    
    /**
     * Verify user email
     */
    boolean verifyEmail(String verificationToken);
    
    /**
     * Send verification email
     */
    boolean sendVerificationEmail(User user);
    
    /**
     * Send OTP verification email
     */
    boolean sendOTPVerificationEmail(Long userId);
    
    /**
     * Verify OTP code
     */
    boolean verifyOTPCode(Long userId, String otpCode);
    
    /**
     * Resend OTP verification email
     */
    boolean resendOTPVerificationEmail(Long userId);
    
    /**
     * Check if user has pending OTP verification
     */
    boolean hasPendingOTPVerification(Long userId);
    
    /**
     * Get remaining OTP time in minutes
     */
    long getOTPRemainingTime(Long userId);
    
    /**
     * Check if user email is verified
     */
    boolean isEmailVerified(Long userId);
    
    /**
     * Update user profile
     */
    User updateProfile(User user);
    
    /**
     * Find users by role
     */
    List<User> findByRole(User.UserRole role);
    
    /**
     * Activate/Deactivate user account
     */
    boolean toggleUserStatus(Long userId);
    
    /**
     * Generate verification token
     */
    String generateVerificationToken();
    
    /**
     * Hash password
     */
    String hashPassword(String password);
    
    /**
     * Verify password
     */
    boolean verifyPassword(String password, String hashedPassword);

    /**
     * Get user repository
     */
    UserRepository getUserRepository();
}