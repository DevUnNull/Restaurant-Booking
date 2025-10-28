package com.fpt.restaurantbooking.repositories.impl;

import com.fpt.restaurantbooking.models.GalleryImage;
import com.fpt.restaurantbooking.repositories.GalleryImageRepository;
import com.fpt.restaurantbooking.utils.DatabaseUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class GalleryImageRepositoryImpl implements GalleryImageRepository {

    public GalleryImageRepositoryImpl() {}

    @Override
    public List<GalleryImage> findAllApproved() {
        List<GalleryImage> images = new ArrayList<>();
        String sql = "SELECT * FROM Gallery_Images ORDER BY created_at DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                GalleryImage image = new GalleryImage();
                image.setImageId(rs.getInt("image_id"));
                image.setImageUrl(rs.getString("image_url"));
                image.setImageTile(rs.getString("image_title"));
                images.add(image);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return images;
    }
}