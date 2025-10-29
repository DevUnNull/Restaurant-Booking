package com.fpt.restaurantbooking.services.impl;

import com.fpt.restaurantbooking.models.RestaurantInfo;
import com.fpt.restaurantbooking.repositories.RestaurantInfoRepository;
import com.fpt.restaurantbooking.services.RestaurantInfoService;
import java.util.Optional;

public class RestaurantInfoServiceImpl implements RestaurantInfoService {

    private final RestaurantInfoRepository restaurantInfoRepository;

    // Constructor để nhận Repository từ Controller
    public RestaurantInfoServiceImpl(RestaurantInfoRepository restaurantInfoRepository) {
        this.restaurantInfoRepository = restaurantInfoRepository;
    }

    // Chỉ triển khai phương thức duy nhất có trong Interface
    @Override
    public Optional<RestaurantInfo> getMainRestaurantInfo() {
        // Đơn giản là gọi đến phương thức tương ứng của Repository
        return restaurantInfoRepository.findMainRestaurantInfo();
    }
}