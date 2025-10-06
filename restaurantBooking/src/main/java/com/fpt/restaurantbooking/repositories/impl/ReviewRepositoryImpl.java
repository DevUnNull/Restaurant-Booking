package com.fpt.restaurantbooking.repositories.impl;

import com.fpt.restaurantbooking.models.Review;
import com.fpt.restaurantbooking.repositories.ReviewRepository;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * Implementation of ReviewRepository interface
 */
public class ReviewRepositoryImpl implements ReviewRepository {
    
    private Connection connection;
    
    public ReviewRepositoryImpl(Connection connection) {
        this.connection = connection;
    }
    
    @Override
    public Review save(Review review) {
        String sql = "INSERT INTO Reviews (user_id, reservation_id, rating, comment, status, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, review.getUserId());
            stmt.setInt(2, review.getReservationId());
            stmt.setInt(3, review.getRating());
            stmt.setString(4, review.getComment());
            stmt.setString(5, review.getStatus());
            stmt.setTimestamp(6, Timestamp.valueOf(review.getCreatedAt()));
            stmt.setTimestamp(7, review.getUpdatedAt() != null ? Timestamp.valueOf(review.getUpdatedAt()) : null);
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        review.setReviewId(generatedKeys.getInt(1));
                    }
                }
            }
            return review;
        } catch (SQLException e) {
            throw new RuntimeException("Error saving review", e);
        }
    }
    
    @Override
    public Review update(Review review) {
        String sql = "UPDATE Reviews SET user_id = ?, reservation_id = ?, rating = ?, comment = ?, status = ?, updated_at = ? WHERE review_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, review.getUserId());
            stmt.setInt(2, review.getReservationId());
            stmt.setInt(3, review.getRating());
            stmt.setString(4, review.getComment());
            stmt.setString(5, review.getStatus());
            stmt.setTimestamp(6, review.getUpdatedAt() != null ? Timestamp.valueOf(review.getUpdatedAt()) : null);
            stmt.setInt(7, review.getReviewId());
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0 ? review : null;
        } catch (SQLException e) {
            throw new RuntimeException("Error updating review", e);
        }
    }
    
    @Override
    public Optional<Review> findById(Integer id) {
        String sql = "SELECT * FROM Reviews WHERE review_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToReview(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding review by id", e);
        }
        
        return Optional.empty();
    }
    
    @Override
    public List<Review> findAll() {
        String sql = "SELECT * FROM Reviews ORDER BY review_id";
        List<Review> reviews = new ArrayList<>();
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    reviews.add(mapResultSetToReview(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding all reviews", e);
        }
        
        return reviews;
    }
    
    @Override
    public List<Review> findAllActive() {
        String sql = "SELECT * FROM Reviews WHERE status = 'ACTIVE' ORDER BY review_id";
        List<Review> reviews = new ArrayList<>();
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    reviews.add(mapResultSetToReview(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding active reviews", e);
        }
        
        return reviews;
    }
    
    @Override
    public List<Review> findAllApproved() {
        String sql = "SELECT * FROM Reviews WHERE status = 'APPROVED' ORDER BY created_at DESC";
        List<Review> reviews = new ArrayList<>();
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    reviews.add(mapResultSetToReview(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding approved reviews", e);
        }
        
        return reviews;
    }
    
    @Override
    public List<Review> findByStatus(String status) {
        String sql = "SELECT * FROM Reviews WHERE status = ? ORDER BY review_id";
        List<Review> reviews = new ArrayList<>();
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, status);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    reviews.add(mapResultSetToReview(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding reviews by status", e);
        }
        
        return reviews;
    }
    
    @Override
    public List<Review> findByUserId(Integer userId) {
        String sql = "SELECT * FROM Reviews WHERE user_id = ? ORDER BY review_id";
        List<Review> reviews = new ArrayList<>();
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    reviews.add(mapResultSetToReview(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding reviews by user ID", e);
        }
        
        return reviews;
    }
    
    @Override
    public List<Review> findByReservationId(Integer reservationId) {
        String sql = "SELECT * FROM Reviews WHERE reservation_id = ? ORDER BY review_id";
        List<Review> reviews = new ArrayList<>();
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, reservationId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    reviews.add(mapResultSetToReview(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding reviews by reservation ID", e);
        }
        
        return reviews;
    }
    
    @Override
    public boolean deleteById(Integer id) {
        String sql = "DELETE FROM Reviews WHERE review_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error deleting review", e);
        }
    }
    
    @Override
    public boolean softDeleteById(Integer id) {
        String sql = "UPDATE Reviews SET status = 'INACTIVE' WHERE review_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error soft deleting review", e);
        }
    }
    
    @Override
    public boolean existsById(Integer id) {
        String sql = "SELECT COUNT(*) FROM Reviews WHERE review_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error checking review existence", e);
        }
        
        return false;
    }
    
    @Override
    public long count() {
        String sql = "SELECT COUNT(*) FROM Reviews";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getLong(1);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error counting reviews", e);
        }
        
        return 0;
    }
    
    @Override
    public long countActive() {
        String sql = "SELECT COUNT(*) FROM Reviews WHERE status = 'ACTIVE'";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getLong(1);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error counting active reviews", e);
        }
        
        return 0;
    }
    
    private Review mapResultSetToReview(ResultSet rs) throws SQLException {
        Review review = new Review();
        review.setReviewId(rs.getInt("review_id"));
        review.setUserId(rs.getInt("user_id"));
        review.setReservationId(rs.getInt("reservation_id"));
        review.setRating(rs.getInt("rating"));
        review.setComment(rs.getString("comment"));
        review.setStatus(rs.getString("status"));
        review.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        if (rs.getTimestamp("updated_at") != null) {
            review.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
        }
        return review;
    }
}