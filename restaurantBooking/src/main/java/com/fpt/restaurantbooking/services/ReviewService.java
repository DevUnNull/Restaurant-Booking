package com.fpt.restaurantbooking.services;

import com.fpt.restaurantbooking.models.Review;

import java.util.List;

/**
 * Service interface for Review business operations
 */
public interface ReviewService extends BaseService<Review, Integer> {
    
    /**
     * Find all approved reviews for display
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
    
    /**
     * Approve a review
     */
    boolean approveReview(Integer reviewId, Integer approvedBy);
    
    /**
     * Reject a review
     */
    boolean rejectReview(Integer reviewId, String reason, Integer approvedBy);
    
    /**
     * Get average rating for a restaurant
     */
    Double getAverageRating();
    
    /**
     * Get rating distribution (count by rating value)
     */
    List<Integer> getRatingDistribution();
}