package com.fpt.restaurantbooking.repositories;

import com.fpt.restaurantbooking.models.RestaurantInfo;

import java.util.Optional;

/**
 * Repository interface for Restaurant Info entity
 */
public interface RestaurantInfoRepository  {

    Optional<RestaurantInfo> findMainRestaurantInfo();
}