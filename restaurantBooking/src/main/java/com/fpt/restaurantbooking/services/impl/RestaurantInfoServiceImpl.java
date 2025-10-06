package com.fpt.restaurantbooking.services.impl;

import com.fpt.restaurantbooking.models.RestaurantInfo;
import com.fpt.restaurantbooking.repositories.RestaurantInfoRepository;
import com.fpt.restaurantbooking.services.RestaurantInfoService;

import java.util.List;
import java.util.Optional;

/**
 * Implementation of RestaurantInfoService interface
 */
public class RestaurantInfoServiceImpl implements RestaurantInfoService {
    
    private final RestaurantInfoRepository restaurantInfoRepository;
    
    // Constructor for dependency injection
    public RestaurantInfoServiceImpl(RestaurantInfoRepository restaurantInfoRepository) {
        this.restaurantInfoRepository = restaurantInfoRepository;
    }
    
    @Override
    public RestaurantInfo create(RestaurantInfo restaurantInfo) {
        if (restaurantInfo != null) {
            return restaurantInfoRepository.save(restaurantInfo);
        }
        return null;
    }
    
    @Override
    public RestaurantInfo update(RestaurantInfo restaurantInfo) {
        return restaurantInfoRepository.update(restaurantInfo);
    }
    
    @Override
    public Optional<RestaurantInfo> findById(Long id) {
        return restaurantInfoRepository.findById(id);
    }
    
    @Override
    public Optional<RestaurantInfo> getMainRestaurantInfo() {
        return restaurantInfoRepository.getMainRestaurantInfo();
    }
    
    @Override
    public Optional<RestaurantInfo> findByRestaurantName(String restaurantName) {
        return restaurantInfoRepository.findByRestaurantName(restaurantName);
    }
    
    @Override
    public List<RestaurantInfo> findAll() {
        return restaurantInfoRepository.findAll();
    }
    
    @Override
    public List<RestaurantInfo> findAllActive() {
        return restaurantInfoRepository.findAllActive();
    }
    
    @Override
    public boolean deleteById(Long id) {
        return restaurantInfoRepository.deleteById(id);
    }
    
    @Override
    public boolean softDeleteById(Long id) {
        return restaurantInfoRepository.softDeleteById(id);
    }
    
    @Override
    public boolean existsById(Long id) {
        return restaurantInfoRepository.existsById(id);
    }
    
    @Override
    public long getTotalCount() {
        return restaurantInfoRepository.count();
    }
    
    @Override
    public long getActiveCount() {
        return restaurantInfoRepository.countActive();
    }
    
    @Override
    public boolean validate(RestaurantInfo entity) {
        if (entity == null) {
            return false;
        }
        
        // Basic validation
        if (entity.getRestaurantName() == null || entity.getRestaurantName().trim().isEmpty()) {
            return false;
        }
        
        if (entity.getAddress() == null || entity.getAddress().trim().isEmpty()) {
            return false;
        }
        
        if (entity.getPhoneNumber() == null || entity.getPhoneNumber().trim().isEmpty()) {
            return false;
        }
        
        return true;
    }
}