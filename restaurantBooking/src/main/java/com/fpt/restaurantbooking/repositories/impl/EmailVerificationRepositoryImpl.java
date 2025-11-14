package com.fpt.restaurantbooking.repositories.impl;

import com.fpt.restaurantbooking.models.EmailVerification;
import com.fpt.restaurantbooking.repositories.EmailVerificationRepository;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * Implementation of EmailVerificationRepository interface
 */
public class EmailVerificationRepositoryImpl implements EmailVerificationRepository {

    private Connection connection;

    public EmailVerificationRepositoryImpl(Connection connection) {
        this.connection = connection;
    }

    @Override
    public EmailVerification save(EmailVerification verification) {
        String sql = "INSERT INTO Email_Verification (user_id, otp_code, reset_token, expiration_time, status, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setLong(1, verification.getUserId());
            stmt.setString(2, verification.getOtpCode());
            stmt.setString(3, verification.getResetToken());
            stmt.setTimestamp(4, Timestamp.valueOf(verification.getExpirationTime()));
            stmt.setString(5, verification.getStatus());
            stmt.setTimestamp(6, Timestamp.valueOf(verification.getCreatedAt()));
            stmt.setTimestamp(7, Timestamp.valueOf(verification.getUpdatedAt()));

            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        verification.setVerificationId(generatedKeys.getLong(1));
                    }
                }
            }
            return verification;
        } catch (SQLException e) {
            throw new RuntimeException("Error saving email verification", e);
        }
    }

    @Override
    public EmailVerification update(EmailVerification verification) {
        String sql = "UPDATE Email_Verification SET user_id = ?, otp_code = ?, reset_token = ?, expiration_time = ?, status = ?, updated_at = ? WHERE verification_id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, verification.getUserId());
            stmt.setString(2, verification.getOtpCode());
            stmt.setString(3, verification.getResetToken());
            stmt.setTimestamp(4, Timestamp.valueOf(verification.getExpirationTime()));
            stmt.setString(5, verification.getStatus());
            stmt.setTimestamp(6, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setLong(7, verification.getVerificationId());

            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0 ? verification : null;
        } catch (SQLException e) {
            throw new RuntimeException("Error updating email verification", e);
        }
    }

    @Override
    public Optional<EmailVerification> findById(Long id) {
        String sql = "SELECT * FROM Email_Verification WHERE verification_id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToEmailVerification(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding email verification by id", e);
        }

        return Optional.empty();
    }

    @Override
    public Optional<EmailVerification> findByUserId(Long userId) {
        String sql = "SELECT * FROM Email_Verification WHERE user_id = ? ORDER BY created_at DESC LIMIT 1";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToEmailVerification(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding email verification by user id", e);
        }

        return Optional.empty();
    }

    @Override
    public Optional<EmailVerification> findByOtpCode(String otpCode) {
        String sql = "SELECT * FROM Email_Verification WHERE otp_code = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, otpCode);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToEmailVerification(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding email verification by OTP code", e);
        }

        return Optional.empty();
    }

    @Override
    public Optional<EmailVerification> findByResetToken(String resetToken) {
        String sql = "SELECT * FROM Email_Verification WHERE reset_token = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, resetToken);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToEmailVerification(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding email verification by reset token", e);
        }

        return Optional.empty();
    }

    @Override
    public Optional<EmailVerification> findByUserIdAndOtpCode(Long userId, String otpCode) {
        String sql = "SELECT * FROM Email_Verification WHERE user_id = ? AND otp_code = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, userId);
            stmt.setString(2, otpCode);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToEmailVerification(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding email verification by user id and OTP code", e);
        }

        return Optional.empty();
    }

    @Override
    public Optional<EmailVerification> findLatestByUserId(Long userId) {
        String sql = "SELECT * FROM Email_Verification WHERE user_id = ? ORDER BY created_at DESC LIMIT 1";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToEmailVerification(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding latest email verification by user id", e);
        }

        return Optional.empty();
    }

    @Override
    public List<EmailVerification> findPendingVerifications() {
        String sql = "SELECT * FROM Email_Verification WHERE status = 'PENDING'";
        List<EmailVerification> verifications = new ArrayList<>();

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    verifications.add(mapResultSetToEmailVerification(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding pending verifications", e);
        }

        return verifications;
    }

    @Override
    public List<EmailVerification> findExpiredVerifications() {
        String sql = "SELECT * FROM Email_Verification WHERE status = 'EXPIRED' OR expiration_time < ?";
        List<EmailVerification> verifications = new ArrayList<>();

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    verifications.add(mapResultSetToEmailVerification(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding expired verifications", e);
        }

        return verifications;
    }

    @Override
    public List<EmailVerification> findByStatus(String status) {
        String sql = "SELECT * FROM Email_Verification WHERE status = ?";
        List<EmailVerification> verifications = new ArrayList<>();

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, status);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    verifications.add(mapResultSetToEmailVerification(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding verifications by status", e);
        }

        return verifications;
    }

    @Override
    public List<EmailVerification> findByUserIdAndStatus(Long userId, String status) {
        String sql = "SELECT * FROM Email_Verification WHERE user_id = ? AND status = ?";
        List<EmailVerification> verifications = new ArrayList<>();

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, userId);
            stmt.setString(2, status);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    verifications.add(mapResultSetToEmailVerification(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding verifications by user id and status", e);
        }

        return verifications;
    }

    @Override
    public boolean hasPendingVerification(Long userId) {
        String sql = "SELECT COUNT(*) FROM Email_Verification WHERE user_id = ? AND status = 'PENDING' AND expiration_time > ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, userId);
            stmt.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error checking pending verification", e);
        }

        return false;
    }

    @Override
    public boolean isValidOtpCode(String otpCode) {
        String sql = "SELECT COUNT(*) FROM Email_Verification WHERE otp_code = ? AND status = 'PENDING' AND expiration_time > ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, otpCode);
            stmt.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error validating OTP code", e);
        }

        return false;
    }

    @Override
    public int deleteExpiredVerifications() {
        String sql = "DELETE FROM Email_Verification WHERE expiration_time < ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));
            return stmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error deleting expired verifications", e);
        }
    }

    @Override
    public boolean deleteByUserId(Long userId) {
        String sql = "DELETE FROM Email_Verification WHERE user_id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error deleting verifications by user id", e);
        }
    }

    @Override
    public boolean updateStatus(Long verificationId, String status) {
        String sql = "UPDATE Email_Verification SET status = ?, updated_at = ? WHERE verification_id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setLong(3, verificationId);

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error updating verification status", e);
        }
    }

    @Override
    public boolean markAsVerified(Long verificationId) {
        return updateStatus(verificationId, "VERIFIED");
    }

    @Override
    public boolean markAsExpired(Long verificationId) {
        return updateStatus(verificationId, "EXPIRED");
    }

    @Override
    public boolean markAsFailed(Long verificationId) {
        return updateStatus(verificationId, "FAILED");
    }

    @Override
    public long countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM Email_Verification WHERE status = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, status);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getLong(1);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error counting verifications by status", e);
        }

        return 0;
    }

    @Override
    public long countPendingByUserId(Long userId) {
        String sql = "SELECT COUNT(*) FROM Email_Verification WHERE user_id = ? AND status = 'PENDING'";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getLong(1);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error counting pending verifications by user id", e);
        }

        return 0;
    }

    @Override
    public List<EmailVerification> findCreatedBefore(LocalDateTime dateTime) {
        String sql = "SELECT * FROM Email_Verification WHERE created_at < ?";
        List<EmailVerification> verifications = new ArrayList<>();

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setTimestamp(1, Timestamp.valueOf(dateTime));

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    verifications.add(mapResultSetToEmailVerification(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding verifications created before", e);
        }

        return verifications;
    }

    @Override
    public List<EmailVerification> findExpiringBefore(LocalDateTime dateTime) {
        String sql = "SELECT * FROM Email_Verification WHERE expiration_time < ?";
        List<EmailVerification> verifications = new ArrayList<>();

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setTimestamp(1, Timestamp.valueOf(dateTime));

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    verifications.add(mapResultSetToEmailVerification(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding verifications expiring before", e);
        }

        return verifications;
    }

    @Override
    public List<EmailVerification> findAll() {
        String sql = "SELECT * FROM Email_Verification";
        List<EmailVerification> verifications = new ArrayList<>();

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    verifications.add(mapResultSetToEmailVerification(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding all verifications", e);
        }

        return verifications;
    }

    @Override
    public List<EmailVerification> findAllActive() {
        String sql = "SELECT * FROM Email_Verification WHERE status != 'DELETED'";
        List<EmailVerification> verifications = new ArrayList<>();

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    verifications.add(mapResultSetToEmailVerification(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding all active verifications", e);
        }

        return verifications;
    }

    @Override
    public boolean deleteById(Long id) {
        String sql = "DELETE FROM Email_Verification WHERE verification_id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error deleting verification", e);
        }
    }

    @Override
    public boolean softDeleteById(Long id) {
        String sql = "UPDATE Email_Verification SET status = 'DELETED', updated_at = ? WHERE verification_id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setLong(2, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error soft deleting verification", e);
        }
    }

    @Override
    public boolean existsById(Long id) {
        String sql = "SELECT COUNT(*) FROM Email_Verification WHERE verification_id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error checking verification existence", e);
        }

        return false;
    }

    @Override
    public long count() {
        String sql = "SELECT COUNT(*) FROM Email_Verification";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getLong(1);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error counting verifications", e);
        }

        return 0;
    }

    @Override
    public long countActive() {
        String sql = "SELECT COUNT(*) FROM Email_Verification WHERE status != 'DELETED'";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getLong(1);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error counting active verifications", e);
        }

        return 0;
    }

    private EmailVerification mapResultSetToEmailVerification(ResultSet rs) throws SQLException {
        EmailVerification verification = new EmailVerification();
        verification.setVerificationId(rs.getLong("verification_id"));
        verification.setUserId(rs.getLong("user_id"));
        verification.setOtpCode(rs.getString("otp_code"));
        verification.setResetToken(rs.getString("reset_token"));
        verification.setStatus(rs.getString("status"));

        Timestamp expirationTime = rs.getTimestamp("expiration_time");
        if (expirationTime != null) {
            verification.setExpirationTime(expirationTime.toLocalDateTime());
        }

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            verification.setCreatedAt(createdAt.toLocalDateTime());
        }

        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            verification.setUpdatedAt(updatedAt.toLocalDateTime());
        }

        return verification;
    }
}