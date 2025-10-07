package com.fpt.restaurantbooking.repositories.impl;

import com.fpt.restaurantbooking.models.User;
import com.fpt.restaurantbooking.repositories.UserRepository;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * Implementation of UserRepository interface
 */
public class UserRepositoryImpl implements UserRepository {
    
    private Connection connection;
    
    public UserRepositoryImpl(Connection connection) {
        this.connection = connection;
    }
    
    @Override
    public User save(User user) {
        String sql = "INSERT INTO users (full_name, email, password, phone_number, role_id, status, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";        
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPassword());
            stmt.setString(4, user.getPhoneNumber());
            stmt.setInt(5, user.getRoleId());
            stmt.setString(6, user.getStatus());
            stmt.setTimestamp(7, Timestamp.valueOf(user.getCreatedAt()));
            stmt.setTimestamp(8, Timestamp.valueOf(user.getUpdatedAt()));
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        user.setUserId(generatedKeys.getInt(1));
                    }
                }
            }
            return user;
        } catch (SQLException e) {
            throw new RuntimeException("Error saving user", e);
        }
    }
    
    @Override
    public User update(User user) {
        String sql = "UPDATE users SET full_name = ?, email = ?, password = ?, phone_number = ?, role_id = ?, status = ?, updated_at = ?, avatar = ? WHERE user_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPassword());
            stmt.setString(4, user.getPhoneNumber());
            stmt.setInt(5, user.getRoleId());
            stmt.setString(6, user.getStatus());
            stmt.setTimestamp(7, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setString(8, user.getAvatar());
            stmt.setInt(9, user.getUserId());
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0 ? user : null;
        } catch (SQLException e) {
            throw new RuntimeException("Error updating user", e);
        }
    }
    
    @Override
    public Optional<User> findById(Long id) {
        String sql = "SELECT * FROM users WHERE user_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToUser(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding user by id", e);
        }
        
        return Optional.empty();
    }
    
    @Override
    public Optional<User> findByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, email);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToUser(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding user by email", e);
        }
        
        return Optional.empty();
    }
    
    @Override
    public Optional<User> findByVerificationToken(String token) {
        // Since verification_token column has been removed and email verification
        // is now handled by Email_Verification table, this method should be updated
        // For now, return empty to avoid SQL errors
        return Optional.empty();
    }
    
    @Override
    public boolean existsByEmail(String email) {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, email);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error checking email existence", e);
        }
        
        return false;
    }
    
    @Override
    public List<User> findByRole(User.UserRole role) {
        String sql = "SELECT * FROM users WHERE role = ?";
        List<User> users = new ArrayList<>();
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, role.name());
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    users.add(mapResultSetToUser(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding users by role", e);
        }
        
        return users;
    }
    
    @Override
    public List<User> findVerifiedUsers() {
        // Since email verification is now handled by Email_Verification table,
        // this method should be updated to use the new table structure
        // For now, return empty list to avoid SQL errors
        return new ArrayList<>();
    }
    
    @Override
    public List<User> findUnverifiedUsers() {
        // Since email verification is now handled by Email_Verification table,
        // this method should be updated to use the new table structure
        // For now, return empty list to avoid SQL errors
        return new ArrayList<>();
    }
    
    @Override
    public boolean updatePassword(Long userId, String newPassword) {
        String sql = "UPDATE users SET password = ?, updated_at = ? WHERE user_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, newPassword);
            stmt.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setLong(3, userId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error updating password", e);
        }
    }
    
    @Override
    public boolean verifyEmail(String verificationToken) {
        // Since email verification is now handled by Email_Verification table,
        // this method should be updated to use the new table structure
        // For now, just return false to avoid SQL errors
        return false;
    }
    
    @Override
    public List<User> findAll() {
        String sql = "SELECT * FROM users";
        List<User> users = new ArrayList<>();
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    users.add(mapResultSetToUser(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding all users", e);
        }
        
        return users;
    }
    
    @Override
    public List<User> findAllActive() {
        String sql = "SELECT * FROM users WHERE status = 'ACTIVE'";
        List<User> users = new ArrayList<>();
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    users.add(mapResultSetToUser(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding active users", e);
        }
        
        return users;
    }
    
    @Override
    public boolean deleteById(Long id) {
        String sql = "DELETE FROM users WHERE user_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error deleting user", e);
        }
    }
    
    @Override
    public boolean softDeleteById(Long id) {
        String sql = "UPDATE users SET status = 'DELETED', updated_at = ? WHERE user_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setLong(2, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error soft deleting user", e);
        }
    }
    
    @Override
    public boolean existsById(Long id) {
        String sql = "SELECT COUNT(*) FROM users WHERE user_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error checking user existence", e);
        }
        
        return false;
    }
    
    @Override
    public long count() {
        String sql = "SELECT COUNT(*) FROM users";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getLong(1);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error counting users", e);
        }
        
        return 0;
    }
    
    @Override
    public long countActive() {
        String sql = "SELECT COUNT(*) FROM users WHERE status = 'ACTIVE'";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getLong(1);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error counting active users", e);
        }
        
        return 0;
    }
    
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setRoleId(rs.getInt("role_id"));
        user.setFullName(rs.getString("full_name"));
        user.setEmail(rs.getString("email"));
        user.setPhoneNumber(rs.getString("phone_number"));
        user.setPassword(rs.getString("password"));
        user.setAvatar(rs.getString("avatar"));
        
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            user.setCreatedAt(createdAt.toLocalDateTime());
        }
        
        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            user.setUpdatedAt(updatedAt.toLocalDateTime());
        }
        
        user.setStatus(rs.getString("status"));
        user.setRole(rs.getString("role"));
        
        return user;
    }
}