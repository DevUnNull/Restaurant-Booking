package com.fpt.restaurantbooking.services;

import com.fpt.restaurantbooking.models.RestaurantInfo;
import java.util.Optional;

public interface RestaurantInfoService {
    Optional<RestaurantInfo> getMainRestaurantInfo();
}