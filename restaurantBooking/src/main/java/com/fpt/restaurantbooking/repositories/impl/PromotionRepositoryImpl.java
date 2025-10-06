package com.fpt.restaurantbooking.repositories.impl;

import com.fpt.restaurantbooking.models.Promotion;
import com.fpt.restaurantbooking.repositories.PromotionRepository;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * Implementation of PromotionRepository interface
 */
public class PromotionRepositoryImpl implements PromotionRepository {
    
    private Connection connection;
    
    public PromotionRepositoryImpl(Connection connection) {
        this.connection = connection;
    }
    
    @Override
    public Promotion save(Promotion promotion) {
        String sql = "INSERT INTO promotions (promotion_name, description, discount_percentage, start_date, end_date, status, created_by, updated_by, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, promotion.getPromotionName());
            stmt.setString(2, promotion.getDescription());
            stmt.setBigDecimal(3, promotion.getDiscountValue());
            stmt.setDate(4, Date.valueOf(promotion.getStartDate()));
            stmt.setDate(5, Date.valueOf(promotion.getEndDate()));
            stmt.setString(6, promotion.getStatus());
            stmt.setInt(7, 1); // created_by - default to admin
            stmt.setInt(8, 1); // updated_by - default to admin
            stmt.setTimestamp(9, Timestamp.valueOf(promotion.getCreatedAt()));
            stmt.setTimestamp(10, Timestamp.valueOf(promotion.getUpdatedAt()));
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        promotion.setPromotionId(generatedKeys.getInt(1));
                    }
                }
            }
            return promotion;
        } catch (SQLException e) {
            throw new RuntimeException("Error saving promotion", e);
        }
    }
    
    @Override
    public Promotion update(Promotion promotion) {
        String sql = "UPDATE promotions SET promotion_name = ?, description = ?, discount_percentage = ?, start_date = ?, end_date = ?, status = ?, updated_by = ?, updated_at = ? WHERE promotion_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, promotion.getPromotionName());
            stmt.setString(2, promotion.getDescription());
            stmt.setBigDecimal(3, promotion.getDiscountValue());
            stmt.setDate(4, Date.valueOf(promotion.getStartDate()));
            stmt.setDate(5, Date.valueOf(promotion.getEndDate()));
            stmt.setString(6, promotion.getStatus());
            stmt.setInt(7, 1); // updated_by - default to admin
            stmt.setTimestamp(8, Timestamp.valueOf(promotion.getUpdatedAt()));
            stmt.setInt(9, promotion.getPromotionId());
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0 ? promotion : null;
        } catch (SQLException e) {
            throw new RuntimeException("Error updating promotion", e);
        }
    }
    
    @Override
    public Optional<Promotion> findById(Long id) {
        String sql = "SELECT * FROM promotions WHERE promotion_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToPromotion(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding promotion by id", e);
        }
        
        return Optional.empty();
    }
    
    @Override
    public List<Promotion> findActivePromotions(LocalDate currentDate) {
        String sql = "SELECT * FROM promotions WHERE status = 'ACTIVE' AND start_date <= ? AND end_date >= ? ORDER BY promotion_id DESC";
        List<Promotion> promotions = new ArrayList<>();
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setDate(1, Date.valueOf(currentDate));
            stmt.setDate(2, Date.valueOf(currentDate));
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    promotions.add(mapResultSetToPromotion(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding active promotions", e);
        }
        
        return promotions;
    }
    
    @Override
    public List<Promotion> findActivePromotionsForHomePage() {
        LocalDate currentDate = LocalDate.now();
        return findActivePromotions(currentDate);
    }
    
    @Override
    public List<Promotion> findByStatus(String status) {
        String sql = "SELECT * FROM promotions WHERE status = ? ORDER BY promotion_id DESC";
        List<Promotion> promotions = new ArrayList<>();
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, status);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    promotions.add(mapResultSetToPromotion(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding promotions by status", e);
        }
        
        return promotions;
    }
    
    @Override
    public List<Promotion> findAll() {
        String sql = "SELECT * FROM promotions ORDER BY promotion_id DESC";
        List<Promotion> promotions = new ArrayList<>();
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    promotions.add(mapResultSetToPromotion(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding all promotions", e);
        }
        
        return promotions;
    }
    
    @Override
    public List<Promotion> findAllActive() {
        return findByStatus("ACTIVE");
    }
    
    @Override
    public boolean deleteById(Long id) {
        String sql = "DELETE FROM promotions WHERE promotion_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error deleting promotion", e);
        }
    }
    
    @Override
    public boolean softDeleteById(Long id) {
        String sql = "UPDATE promotions SET status = 'INACTIVE' WHERE promotion_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error soft deleting promotion", e);
        }
    }
    
    @Override
    public boolean existsById(Long id) {
        String sql = "SELECT COUNT(*) FROM promotions WHERE promotion_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error checking promotion existence", e);
        }
        
        return false;
    }
    
    @Override
    public long count() {
        String sql = "SELECT COUNT(*) FROM promotions";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getLong(1);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error counting promotions", e);
        }
        
        return 0;
    }
    
    @Override
    public long countActive() {
        String sql = "SELECT COUNT(*) FROM promotions WHERE status = 'ACTIVE'";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getLong(1);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error counting active promotions", e);
        }
        
        return 0;
    }
    
    private Promotion mapResultSetToPromotion(ResultSet rs) throws SQLException {
        Promotion promotion = new Promotion();
        promotion.setPromotionId(rs.getInt("promotion_id"));
        promotion.setPromotionName(rs.getString("promotion_name"));
        promotion.setDescription(rs.getString("description"));
        promotion.setDiscountValue(rs.getBigDecimal("discount_percentage"));
        promotion.setStartDate(rs.getDate("start_date").toLocalDate());
        promotion.setEndDate(rs.getDate("end_date").toLocalDate());
        promotion.setStatus(rs.getString("status"));
        promotion.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        promotion.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
        return promotion;
    }
}