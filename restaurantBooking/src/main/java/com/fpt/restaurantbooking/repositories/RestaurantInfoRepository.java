package com.fpt.restaurantbooking.repositories;

import com.fpt.restaurantbooking.models.RestaurantInfo;

import java.util.Optional;

/**
 * Repository interface for Restaurant Info entity
 */
public interface RestaurantInfoRepository extends BaseRepository<RestaurantInfo, Long> {
    
    /**
     * Get the main restaurant information (assuming single restaurant)
     */
    Optional<RestaurantInfo> getMainRestaurantInfo();
    
    /**
     * Find restaurant info by name
     */
    Optional<RestaurantInfo> findByRestaurantName(String restaurantName);
}