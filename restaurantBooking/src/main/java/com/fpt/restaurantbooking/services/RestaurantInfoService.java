package com.fpt.restaurantbooking.services;

import com.fpt.restaurantbooking.models.RestaurantInfo;

import java.util.Optional;

/**
 * Service interface for Restaurant Info business operations
 */
public interface RestaurantInfoService extends BaseService<RestaurantInfo, Long> {
    
    /**
     * Get the main restaurant information (assuming single restaurant)
     */
    Optional<RestaurantInfo> getMainRestaurantInfo();
    
    /**
     * Find restaurant info by name
     */
    Optional<RestaurantInfo> findByRestaurantName(String restaurantName);
}