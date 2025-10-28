package com.fpt.restaurantbooking.services;

import com.fpt.restaurantbooking.models.Review;
import java.util.List;

public interface ReviewService {
    List<Review> findAllApproved();
}