package com.fpt.restaurantbooking.services;

import com.fpt.restaurantbooking.models.Promotion;

import java.time.LocalDate;
import java.util.List;

/**
 * Service interface for Promotion business operations
 */
public interface PromotionService extends BaseService<Promotion, Long> {
    
    /**
     * Find active promotions by date range
     */
    List<Promotion> findActivePromotions(LocalDate currentDate);
    
    /**
     * Find active promotions for home page display
     */
    List<Promotion> findActivePromotionsForHomePage();
    
    /**
     * Find promotions by status
     */
    List<Promotion> findByStatus(String status);
}