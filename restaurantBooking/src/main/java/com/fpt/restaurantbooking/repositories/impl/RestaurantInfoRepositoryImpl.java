package com.fpt.restaurantbooking.repositories.impl;

import com.fpt.restaurantbooking.models.RestaurantInfo;
import com.fpt.restaurantbooking.repositories.RestaurantInfoRepository;
import com.fpt.restaurantbooking.utils.DatabaseUtil;
import java.sql.*;
import java.util.Optional;

public class RestaurantInfoRepositoryImpl implements RestaurantInfoRepository {

    public RestaurantInfoRepositoryImpl() {}

    public Optional<RestaurantInfo> findMainRestaurantInfo() {
        String sql = "SELECT * FROM Restaurant_Info LIMIT 1";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return Optional.of(mapResultSetToRestaurantInfo(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return Optional.empty();
    }

    private RestaurantInfo mapResultSetToRestaurantInfo(ResultSet rs) throws SQLException {
        RestaurantInfo info = new RestaurantInfo();
        info.setInfoId(rs.getInt("info_id"));
        info.setRestaurantName(rs.getString("restaurant_name"));
        info.setAddress(rs.getString("address"));
        info.setContactPhone(rs.getString("contact_phone")); // Gán cho contactPhone
        info.setEmail(rs.getString("email"));
        info.setDescription(rs.getString("description"));
        info.setOpenHours(rs.getString("open_hours")); // Gán cho openHours
        return info;
    }
}