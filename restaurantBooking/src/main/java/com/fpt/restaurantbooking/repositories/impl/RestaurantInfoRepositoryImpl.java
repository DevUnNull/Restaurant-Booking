package com.fpt.restaurantbooking.repositories.impl;

import com.fpt.restaurantbooking.models.RestaurantInfo;
import com.fpt.restaurantbooking.repositories.RestaurantInfoRepository;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * Implementation of RestaurantInfoRepository interface
 */
public class RestaurantInfoRepositoryImpl implements RestaurantInfoRepository {
    
    private Connection connection;
    
    public RestaurantInfoRepositoryImpl(Connection connection) {
        this.connection = connection;
    }
    
    @Override
    public RestaurantInfo save(RestaurantInfo restaurantInfo) {
        String sql = "INSERT INTO restaurant_info (restaurant_name, address, contact_phone, email, description, open_hours, banner_image, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, restaurantInfo.getRestaurantName());
            stmt.setString(2, restaurantInfo.getAddress());
            stmt.setString(3, restaurantInfo.getPhoneNumber());
            stmt.setString(4, restaurantInfo.getEmail());
            stmt.setString(5, restaurantInfo.getDescription());
            stmt.setString(6, restaurantInfo.getOperatingDays());
            stmt.setString(7, restaurantInfo.getBannerUrl());
            stmt.setTimestamp(8, Timestamp.valueOf(restaurantInfo.getUpdatedAt()));
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        restaurantInfo.setInfoId(generatedKeys.getInt(1));
                    }
                }
            }
            return restaurantInfo;
        } catch (SQLException e) {
            throw new RuntimeException("Error saving restaurant info", e);
        }
    }
    
    @Override
    public RestaurantInfo update(RestaurantInfo restaurantInfo) {
        String sql = "UPDATE restaurant_info SET restaurant_name = ?, address = ?, contact_phone = ?, email = ?, description = ?, open_hours = ?, banner_image = ?, updated_at = ? WHERE info_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, restaurantInfo.getRestaurantName());
            stmt.setString(2, restaurantInfo.getAddress());
            stmt.setString(3, restaurantInfo.getPhoneNumber());
            stmt.setString(4, restaurantInfo.getEmail());
            stmt.setString(5, restaurantInfo.getDescription());
            stmt.setString(6, restaurantInfo.getOperatingDays());
            stmt.setString(7, restaurantInfo.getBannerUrl());
            stmt.setTimestamp(8, Timestamp.valueOf(restaurantInfo.getUpdatedAt()));
            stmt.setInt(9, restaurantInfo.getInfoId());
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0 ? restaurantInfo : null;
        } catch (SQLException e) {
            throw new RuntimeException("Error updating restaurant info", e);
        }
    }
    
    @Override
    public Optional<RestaurantInfo> findById(Long id) {
        String sql = "SELECT * FROM restaurant_info WHERE info_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToRestaurantInfo(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding restaurant info by id", e);
        }
        
        return Optional.empty();
    }
    
    @Override
    public Optional<RestaurantInfo> getMainRestaurantInfo() {
        String sql = "SELECT * FROM restaurant_info ORDER BY info_id LIMIT 1";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToRestaurantInfo(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding main restaurant info", e);
        }
        
        return Optional.empty();
    }
    
    @Override
    public Optional<RestaurantInfo> findByRestaurantName(String restaurantName) {
        String sql = "SELECT * FROM restaurant_info WHERE restaurant_name = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, restaurantName);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToRestaurantInfo(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding restaurant info by name", e);
        }
        
        return Optional.empty();
    }
    
    @Override
    public List<RestaurantInfo> findAll() {
        String sql = "SELECT * FROM restaurant_info ORDER BY info_id";
        List<RestaurantInfo> restaurantInfos = new ArrayList<>();
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    restaurantInfos.add(mapResultSetToRestaurantInfo(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding all restaurant info", e);
        }
        
        return restaurantInfos;
    }
    
    @Override
    public List<RestaurantInfo> findAllActive() {
        String sql = "SELECT * FROM restaurant_info WHERE status = 'ACTIVE' ORDER BY info_id";
        List<RestaurantInfo> restaurantInfos = new ArrayList<>();
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    restaurantInfos.add(mapResultSetToRestaurantInfo(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding active restaurant info", e);
        }
        
        return restaurantInfos;
    }
    
    @Override
    public boolean deleteById(Long id) {
        String sql = "DELETE FROM restaurant_info WHERE info_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error deleting restaurant info", e);
        }
    }
    
    @Override
    public boolean softDeleteById(Long id) {
        String sql = "UPDATE restaurant_info SET status = 'INACTIVE' WHERE info_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error soft deleting restaurant info", e);
        }
    }
    
    @Override
    public boolean existsById(Long id) {
        String sql = "SELECT COUNT(*) FROM restaurant_info WHERE info_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error checking restaurant info existence", e);
        }
        
        return false;
    }
    
    @Override
    public long count() {
        String sql = "SELECT COUNT(*) FROM restaurant_info";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getLong(1);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error counting restaurant info", e);
        }
        
        return 0;
    }
    
    @Override
    public long countActive() {
        String sql = "SELECT COUNT(*) FROM restaurant_info WHERE status = 'ACTIVE'";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getLong(1);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error counting active restaurant info", e);
        }
        
        return 0;
    }
    
    private RestaurantInfo mapResultSetToRestaurantInfo(ResultSet rs) throws SQLException {
        RestaurantInfo restaurantInfo = new RestaurantInfo();
        restaurantInfo.setInfoId(rs.getInt("info_id"));
        restaurantInfo.setRestaurantName(rs.getString("restaurant_name"));
        restaurantInfo.setAddress(rs.getString("address"));
        restaurantInfo.setPhoneNumber(rs.getString("contact_phone"));
        restaurantInfo.setEmail(rs.getString("email"));
        restaurantInfo.setDescription(rs.getString("description"));
        restaurantInfo.setOperatingDays(rs.getString("open_hours"));
        restaurantInfo.setBannerUrl(rs.getString("banner_image"));
        restaurantInfo.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
        return restaurantInfo;
    }
}