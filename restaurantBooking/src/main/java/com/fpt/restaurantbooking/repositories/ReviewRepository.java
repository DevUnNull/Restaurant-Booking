package com.fpt.restaurantbooking.repositories;

import com.fpt.restaurantbooking.models.Review;

import java.util.List;

/**
 * Repository interface for Review entity
 */
public interface ReviewRepository extends BaseRepository<Review, Integer> {
    
    /**
     * Find all approved reviews
     */
    List<Review> findAllApproved();
    
    /**
     * Find reviews by status
     */
    List<Review> findByStatus(String status);
    
    /**
     * Find reviews by user ID
     */
    List<Review> findByUserId(Integer userId);
    
    /**
     * Find reviews by reservation ID
     */
    List<Review> findByReservationId(Integer reservationId);
}