package com.fpt.restaurantbooking.repositories;

import com.fpt.restaurantbooking.models.User;

import java.util.List;
import java.util.Optional;

/**
 * Repository interface for User entity
 */
public interface UserRepository extends BaseRepository<User, Long> {

    /**
     * Find user by email
     */
    Optional<User> findByEmail(String email);

    /**
     * Find user by verification token
     */
    Optional<User> findByVerificationToken(String token);

    /**
     * Check if email exists
     */
    boolean existsByEmail(String email);

    /**
     * Find users by role
     */
    List<User> findByRole(User.UserRole role);

    /**
     * Find verified users
     */
    List<User> findVerifiedUsers();

    /**
     * Find unverified users
     */
    List<User> findUnverifiedUsers();

    /**
     * Update user password
     */
    boolean updatePassword(Long userId, String newPassword);

    /**
     * Verify user email
     */
    boolean verifyEmail(String verificationToken);

    boolean updateInfo(User user);
    boolean changePassword(int userId, String newPassword);
    boolean updateAvatar(int userId, String avatarBase64);
    String findPasswordById(int userId);
}