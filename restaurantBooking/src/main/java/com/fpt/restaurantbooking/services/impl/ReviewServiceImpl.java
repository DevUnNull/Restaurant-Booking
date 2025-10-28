package com.fpt.restaurantbooking.services.impl;

import com.fpt.restaurantbooking.models.Review;
import com.fpt.restaurantbooking.repositories.ReviewRepository;
import com.fpt.restaurantbooking.services.ReviewService;
import java.util.List;

public class ReviewServiceImpl implements ReviewService {

    private final ReviewRepository reviewRepository;

    public ReviewServiceImpl(ReviewRepository reviewRepository) {
        this.reviewRepository = reviewRepository;
    }

    @Override
    public List<Review> findAllApproved() {
        return reviewRepository.findAllApproved();
    }
}