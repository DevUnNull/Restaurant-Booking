package com.fpt.restaurantbooking.services;

import com.fpt.restaurantbooking.models.GalleryImage;

import java.util.List;

/**
 * Service interface for Gallery Image business operations
 */
public interface GalleryImageService extends BaseService<GalleryImage, Integer> {
    
    /**
     * Find all active gallery images
     */
    List<GalleryImage> findAllActive();
    
    /**
     * Find gallery images by status
     */
    List<GalleryImage> findByStatus(String status);
    
    /**
     * Find gallery images by image type
     */
    List<GalleryImage> findByImageType(String imageType);
    
    /**
     * Find gallery images by uploaded by user
     */
    List<GalleryImage> findByUploadedBy(Integer uploadedBy);
    
    /**
     * Find all approved gallery images for restaurant display
     */
    List<GalleryImage> findAllApproved();
}