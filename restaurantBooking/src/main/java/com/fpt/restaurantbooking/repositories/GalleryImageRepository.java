package com.fpt.restaurantbooking.repositories;

import com.fpt.restaurantbooking.models.GalleryImage;
import java.util.List;

public interface GalleryImageRepository {
    List<GalleryImage> findAllApproved();
}