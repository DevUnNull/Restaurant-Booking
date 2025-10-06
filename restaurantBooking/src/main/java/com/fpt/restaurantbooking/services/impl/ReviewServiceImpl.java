package com.fpt.restaurantbooking.services.impl;

import com.fpt.restaurantbooking.models.Review;
import com.fpt.restaurantbooking.repositories.ReviewRepository;
import com.fpt.restaurantbooking.services.ReviewService;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * Implementation of ReviewService interface
 */
public class ReviewServiceImpl implements ReviewService {
    
    private final ReviewRepository reviewRepository;
    
    // Constructor for dependency injection
    public ReviewServiceImpl(ReviewRepository reviewRepository) {
        this.reviewRepository = reviewRepository;
    }
    
    @Override
    public Review create(Review review) {
        if (review != null && validate(review)) {
            // Set default status if not provided
            if (review.getStatus() == null || review.getStatus().trim().isEmpty()) {
                review.setStatus("PENDING");
            }
            review.setCreatedAt(LocalDateTime.now());
            return reviewRepository.save(review);
        }
        return null;
    }
    
    @Override
    public Review update(Review review) {
        if (review != null && validate(review)) {
            review.setUpdatedAt(LocalDateTime.now());
            return reviewRepository.update(review);
        }
        return null;
    }
    
    @Override
    public Optional<Review> findById(Integer id) {
        return reviewRepository.findById(id);
    }
    
    @Override
    public List<Review> findAll() {
        return reviewRepository.findAll();
    }
    
    @Override
    public List<Review> findAllActive() {
        return reviewRepository.findAllActive();
    }
    
    @Override
    public List<Review> findAllApproved() {
        return reviewRepository.findAllApproved();
    }
    
    @Override
    public List<Review> findByStatus(String status) {
        return reviewRepository.findByStatus(status);
    }
    
    @Override
    public List<Review> findByUserId(Integer userId) {
        return reviewRepository.findByUserId(userId);
    }
    
    @Override
    public List<Review> findByReservationId(Integer reservationId) {
        return reviewRepository.findByReservationId(reservationId);
    }
    
    @Override
    public boolean approveReview(Integer reviewId, Integer approvedBy) {
        Optional<Review> reviewOpt = reviewRepository.findById(reviewId);
        if (reviewOpt.isPresent()) {
            Review review = reviewOpt.get();
            review.setStatus("APPROVED");
            review.setApprovedBy(approvedBy);
            review.setUpdatedAt(LocalDateTime.now());
            reviewRepository.update(review);
            return true;
        }
        return false;
    }
    
    @Override
    public boolean rejectReview(Integer reviewId, String reason, Integer approvedBy) {
        Optional<Review> reviewOpt = reviewRepository.findById(reviewId);
        if (reviewOpt.isPresent()) {
            Review review = reviewOpt.get();
            review.setStatus("REJECTED");
            review.setApprovedBy(approvedBy);
            review.setUpdatedAt(LocalDateTime.now());
            // You might want to store the rejection reason in a separate field or comment
            if (review.getComment() != null && !review.getComment().isEmpty()) {
                review.setComment(review.getComment() + " [Rejected: " + reason + "]");
            }
            reviewRepository.update(review);
            return true;
        }
        return false;
    }
    
    @Override
    public Double getAverageRating() {
        List<Review> approvedReviews = reviewRepository.findAllApproved();
        if (approvedReviews.isEmpty()) {
            return 0.0;
        }
        
        double sum = approvedReviews.stream()
                .mapToInt(Review::getRating)
                .sum();
        
        return sum / approvedReviews.size();
    }
    
    @Override
    public List<Integer> getRatingDistribution() {
        List<Review> approvedReviews = reviewRepository.findAllApproved();
        
        // Count reviews for each rating from 1 to 5
        List<Integer> distribution = new java.util.ArrayList<>(List.of(0, 0, 0, 0, 0));
        
        for (Review review : approvedReviews) {
            int rating = review.getRating();
            if (rating >= 1 && rating <= 5) {
                distribution.set(rating - 1, distribution.get(rating - 1) + 1);
            }
        }
        
        return distribution;
    }
    
    @Override
    public boolean deleteById(Integer id) {
        return reviewRepository.deleteById(id);
    }
    
    @Override
    public boolean softDeleteById(Integer id) {
        return reviewRepository.softDeleteById(id);
    }
    
    @Override
    public boolean existsById(Integer id) {
        return reviewRepository.existsById(id);
    }
    
    @Override
    public long getTotalCount() {
        return reviewRepository.count();
    }
    
    @Override
    public long getActiveCount() {
        return reviewRepository.countActive();
    }
    
    @Override
    public boolean validate(Review entity) {
        if (entity == null) {
            return false;
        }
        
        // Basic validation
        if (entity.getUserId() == null || entity.getUserId() <= 0) {
            return false;
        }
        
        if (entity.getReservationId() == null || entity.getReservationId() <= 0) {
            return false;
        }
        
        if (entity.getRating() == null || entity.getRating() < 1 || entity.getRating() > 5) {
            return false;
        }
        
        if (entity.getComment() == null || entity.getComment().trim().isEmpty()) {
            return false;
        }
        
        if (entity.getStatus() == null || entity.getStatus().trim().isEmpty()) {
            return false;
        }
        
        return true;
    }
}