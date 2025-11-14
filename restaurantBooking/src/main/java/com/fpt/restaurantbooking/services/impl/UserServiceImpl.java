package com.fpt.restaurantbooking.services.impl;

import com.fpt.restaurantbooking.models.EmailVerification;
import com.fpt.restaurantbooking.models.User;
import com.fpt.restaurantbooking.repositories.EmailVerificationRepository;
import com.fpt.restaurantbooking.repositories.UserRepository;
import com.fpt.restaurantbooking.services.EmailService;
import com.fpt.restaurantbooking.services.OTPService;
import com.fpt.restaurantbooking.services.UserService;
import org.mindrot.jbcrypt.BCrypt;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public class UserServiceImpl implements UserService {

    private UserRepository userRepository;
    private EmailVerificationRepository emailVerificationRepository;
    private OTPService otpService;
    private EmailService emailService;

    // Constructor for dependency injection
    public UserServiceImpl(UserRepository userRepository,
                           EmailVerificationRepository emailVerificationRepository,
                           OTPService otpService,
                           EmailService emailService) {
        this.userRepository = userRepository;
        this.emailVerificationRepository = emailVerificationRepository;
        this.otpService = otpService;
        this.emailService = emailService;
    }

    private final SecureRandom secureRandom = new SecureRandom();

    public UserServiceImpl() {

    }

    public UserServiceImpl(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    public User create(User user) {
        if (user != null) {
            user.setCreatedAt(LocalDateTime.now());
            user.setUpdatedAt(LocalDateTime.now());
            return userRepository.save(user);
        }
        return null;
    }

    @Override
    public User update(User user) {
        user.setUpdatedAt(LocalDateTime.now());
        return userRepository.update(user);
    }

    @Override
    public Optional<User> findById(Long id) {
        return userRepository.findById(id);
    }

    @Override
    public List<User> findAll() {
        return userRepository.findAll();
    }

    @Override
    public List<User> findAllActive() {
        return userRepository.findAllActive();
    }

    @Override
    public boolean deleteById(Long id) {
        return userRepository.deleteById(id);
    }

    @Override
    public boolean softDeleteById(Long id) {
        return userRepository.softDeleteById(id);
    }

    @Override
    public boolean existsById(Long id) {
        return userRepository.existsById(id);
    }

    @Override
    public long getTotalCount() {
        return userRepository.count();
    }

    @Override
    public long getActiveCount() {
        return userRepository.countActive();
    }

    @Override
    public boolean validate(User entity) {
        if (entity == null) {
            return false;
        }

        // Basic validation
        if (entity.getEmail() == null || entity.getEmail().trim().isEmpty()) {
            return false;
        }

        if (entity.getFullName() == null || entity.getFullName().trim().isEmpty()) {
            return false;
        }

        // Email format validation (basic)
        if (!entity.getEmail().contains("@")) {
            return false;
        }

        return true;
    }

    @Override
    public User register(User user, String password) {
        // Hash password
        user.setPassword(hashPassword(password));

        // Set default values
        user.setStatus("PENDING");
//        user.setRole("CUSTOMER");
        user.setCreatedAt(LocalDateTime.now());
        user.setUpdatedAt(LocalDateTime.now());

        // Save user
        User savedUser = userRepository.save(user);

        // Send OTP verification email
        sendOTPVerificationEmail(savedUser.getUserId().longValue());

        return savedUser;
    }

    @Override
    public Optional<User> authenticate(String email, String password) {
        // Find user by email only
        Optional<User> userOpt = userRepository.findByEmail(email);

        if (userOpt.isPresent() && verifyPassword(password, userOpt.get().getPassword())) {
            return userOpt;
        }
        return Optional.empty();
    }

    @Override
    public Optional<User> findByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    @Override
    public boolean isEmailAvailable(String email) {
        return !userRepository.existsByEmail(email);
    }

    @Override
    public boolean updatePassword(Long userId, String currentPassword, String newPassword) {
        Optional<User> userOpt = userRepository.findById(userId);
        if (userOpt.isPresent() && verifyPassword(currentPassword, userOpt.get().getPassword())) {
            String hashedNewPassword = hashPassword(newPassword);
            return userRepository.updatePassword(userId, hashedNewPassword);
        }
        return false;
    }

    @Override
    public boolean resetPassword(String email) {
        Optional<User> userOpt = userRepository.findByEmail(email);
        if (userOpt.isPresent()) {
            String newPassword = generateTemporaryPassword();
            String hashedPassword = hashPassword(newPassword);
            boolean updated = userRepository.updatePassword(userOpt.get().getUserId().longValue(), hashedPassword);

            if (updated) {
                // Send password reset email using EmailService
                User user = userOpt.get();
                // For now, we'll use a simple approach - you may want to create a specific method in EmailService
                return true; // Placeholder - implement password reset email in EmailService if needed
            }
        }
        return false;
    }

    @Override
    public boolean verifyEmail(String verificationToken) {
        // Since email verification is now handled by Email_Verification table,
        // this method should be updated to use the new table structure
        // For now, return false to avoid errors
        return false;
    }

    @Override
    public boolean sendVerificationEmail(User user) {
        // Since verification_token has been removed and email verification
        // is now handled by Email_Verification table, this method should be updated
        // For now, return false to avoid errors
        return false;
    }

    @Override
    public boolean sendOTPVerificationEmail(Long userId) {
        Optional<User> userOpt = userRepository.findById(userId);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            EmailVerification verification = otpService.generateOTPForUser(userId);
            if (verification != null) {
                return emailService.sendOTPVerificationEmail(user, verification.getOtpCode());
            }
        }
        return false;
    }

    @Override
    public boolean verifyOTPCode(Long userId, String otpCode) {
        boolean isValid = otpService.validateOTP(userId, otpCode);
        if (isValid) {
            // Update user status to active
            Optional<User> userOpt = userRepository.findById(userId);
            if (userOpt.isPresent()) {
                User user = userOpt.get();
                user.setStatus("ACTIVE");
                userRepository.update(user);

                // Send verification success email
                emailService.sendVerificationSuccessEmail(user);
                return true;
            }
        }
        return false;
    }

    @Override
    public boolean resendOTPVerificationEmail(Long userId) {
        Optional<User> userOpt = userRepository.findById(userId);
        if (userOpt.isPresent()) {
            User user = userOpt.get();

            // Check if user already active
            if ("ACTIVE".equals(user.getStatus())) {
                return false;
            }

            // Generate and send new OTP
            EmailVerification verification = otpService.generateOTPForUser(userId);
            if (verification != null) {
                return emailService.sendOTPResendEmail(user, verification.getOtpCode());
            }
        }
        return false;
    }

    @Override
    public boolean hasPendingOTPVerification(Long userId) {
        return otpService.hasValidPendingOTP(userId);
    }

    @Override
    public long getOTPRemainingTime(Long userId) {
        return otpService.getRemainingTimeMinutes(userId);
    }

    @Override
    public boolean isEmailVerified(Long userId) {
        // Check if user has any successful email verification
        List<EmailVerification> verifications = emailVerificationRepository.findByUserIdAndStatus(userId, "VERIFIED");
        return !verifications.isEmpty();
    }

    @Override
    public User updateProfile(User user) {
        user.setUpdatedAt(LocalDateTime.now());
        return userRepository.update(user);
    }

    @Override
    public List<User> findByRole(User.UserRole role) {
        return userRepository.findByRole(role);
    }

    @Override
    public boolean toggleUserStatus(Long userId) {
        Optional<User> userOpt = userRepository.findById(userId);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            String currentStatus = user.getStatus();
            String newStatus = "ACTIVE".equals(currentStatus) ? "INACTIVE" : "ACTIVE";
            user.setStatus(newStatus);
            User updatedUser = userRepository.update(user);
            return updatedUser != null;
        }
        return false;
    }

    @Override
    public String generateVerificationToken() {
        return UUID.randomUUID().toString();
    }

    @Override
    public String hashPassword(String password) {
        return BCrypt.hashpw(password, BCrypt.gensalt());
    }

    @Override
    public boolean verifyPassword(String password, String hashedPassword) {
        if (password == null || hashedPassword == null) {
            return false;
        }
        try {
            return BCrypt.checkpw(password, hashedPassword);
        } catch (IllegalArgumentException e) {
            return false;
        }
    }
    @Override
    public UserRepository getUserRepository() {
        return userRepository;
    }

    private String generateTemporaryPassword() {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        StringBuilder password = new StringBuilder();
        for (int i = 0; i < 12; i++) {
            password.append(chars.charAt(secureRandom.nextInt(chars.length())));
        }
        return password.toString();
    }

    @Override
    public boolean updateUser(User user) {
        if (user == null) return false;
        return userRepository.updateInfo(user);
    }

    @Override
    public boolean changePassword(int userId, String currentPassword, String newPassword) {
        String storedHashedPassword = userRepository.findPasswordById(userId);

        if (storedHashedPassword == null) {
            return false;
        }

        if (verifyPassword(currentPassword, storedHashedPassword)) {
            String newHashedPassword = hashPassword(newPassword);
            return userRepository.changePassword(userId, newHashedPassword);
        }

        return false;
    }

    @Override
    public boolean updateAvatar(int userId, String avatarBase64) {
        return userRepository.updateAvatar(userId, avatarBase64);
    }


}