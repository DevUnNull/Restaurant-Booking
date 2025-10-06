package com.fpt.restaurantbooking.repositories;

import com.fpt.restaurantbooking.models.Promotion;

import java.time.LocalDate;
import java.util.List;

/**
 * Repository interface for Promotion entity
 */
public interface PromotionRepository extends BaseRepository<Promotion, Long> {
    
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