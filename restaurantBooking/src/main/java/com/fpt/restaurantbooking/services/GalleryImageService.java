package com.fpt.restaurantbooking.services;

import com.fpt.restaurantbooking.models.GalleryImage;
import java.util.List;

public interface GalleryImageService {
    List<GalleryImage> findAllApproved();
}