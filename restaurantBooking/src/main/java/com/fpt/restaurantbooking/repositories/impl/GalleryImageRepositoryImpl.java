package com.fpt.restaurantbooking.repositories.impl;

import com.fpt.restaurantbooking.models.GalleryImage;
import com.fpt.restaurantbooking.repositories.GalleryImageRepository;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * Implementation of GalleryImageRepository interface
 */
public class GalleryImageRepositoryImpl implements GalleryImageRepository {
    
    private Connection connection;
    
    public GalleryImageRepositoryImpl(Connection connection) {
        this.connection = connection;
    }
    
    @Override
    public GalleryImage save(GalleryImage galleryImage) {
        String sql = "INSERT INTO Gallery_Images (image_url, image_title, created_at) VALUES (?, ?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, galleryImage.getImageUrl());
            stmt.setString(2, galleryImage.getImageName());
            stmt.setTimestamp(3, Timestamp.valueOf(galleryImage.getCreatedAt()));
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        galleryImage.setImageId(generatedKeys.getInt(1));
                    }
                }
            }
            return galleryImage;
        } catch (SQLException e) {
            throw new RuntimeException("Error saving gallery image", e);
        }
    }
    
    @Override
    public GalleryImage update(GalleryImage galleryImage) {
        String sql = "UPDATE Gallery_Images SET image_url = ?, image_title = ? WHERE image_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, galleryImage.getImageUrl());
            stmt.setString(2, galleryImage.getImageName());
            stmt.setInt(3, galleryImage.getImageId());
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0 ? galleryImage : null;
        } catch (SQLException e) {
            throw new RuntimeException("Error updating gallery image", e);
        }
    }
    
    @Override
    public Optional<GalleryImage> findById(Integer id) {
        String sql = "SELECT * FROM Gallery_Images WHERE image_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToGalleryImage(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding gallery image by id", e);
        }
        
        return Optional.empty();
    }
    
    @Override
    public List<GalleryImage> findAll() {
        String sql = "SELECT * FROM Gallery_Images ORDER BY image_id";
        List<GalleryImage> galleryImages = new ArrayList<>();
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    galleryImages.add(mapResultSetToGalleryImage(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding all gallery images", e);
        }
        
        return galleryImages;
    }
    
    @Override
    public List<GalleryImage> findAllActive() {
        // For Gallery_Images table, we'll consider all images as active
        return findAll();
    }
    
    @Override
    public boolean deleteById(Integer id) {
        String sql = "DELETE FROM Gallery_Images WHERE image_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error deleting gallery image", e);
        }
    }
    
    @Override
    public boolean softDeleteById(Integer id) {
        // Gallery_Images table doesn't have status column, so we do hard delete
        return deleteById(id);
    }
    
    @Override
    public boolean existsById(Integer id) {
        String sql = "SELECT COUNT(*) FROM Gallery_Images WHERE image_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error checking gallery image existence", e);
        }
        
        return false;
    }
    
    @Override
    public long count() {
        String sql = "SELECT COUNT(*) FROM Gallery_Images";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getLong(1);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error counting gallery images", e);
        }
        
        return 0;
    }
    
    @Override
    public long countActive() {
        return count();
    }
    
    @Override
    public List<GalleryImage> findByStatus(String status) {
        // Gallery_Images table doesn't have status column, so return all
        return findAll();
    }
    
    private GalleryImage mapResultSetToGalleryImage(ResultSet rs) throws SQLException {
        GalleryImage galleryImage = new GalleryImage();
        galleryImage.setImageId(rs.getInt("image_id"));
        galleryImage.setImageUrl(rs.getString("image_url"));
        galleryImage.setImageName(rs.getString("image_title"));
        galleryImage.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        return galleryImage;
    }
}