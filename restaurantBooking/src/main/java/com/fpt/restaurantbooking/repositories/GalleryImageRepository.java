package com.fpt.restaurantbooking.repositories;

import com.fpt.restaurantbooking.models.GalleryImage;

import java.util.List;

/**
 * Repository interface for Gallery Image entity
 */
public interface GalleryImageRepository extends BaseRepository<GalleryImage, Integer> {
    
    /**
     * Find all active gallery images
     */
    List<GalleryImage> findAllActive();
    
    /**
     * Find gallery images by status
     */
    List<GalleryImage> findByStatus(String status);
}