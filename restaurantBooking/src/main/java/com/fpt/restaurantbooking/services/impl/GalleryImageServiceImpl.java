package com.fpt.restaurantbooking.services.impl;

import com.fpt.restaurantbooking.models.GalleryImage;
import com.fpt.restaurantbooking.repositories.GalleryImageRepository;
import com.fpt.restaurantbooking.services.GalleryImageService;

import java.util.List;
import java.util.Optional;

/**
 * Implementation of GalleryImageService interface
 */
public class GalleryImageServiceImpl implements GalleryImageService {

    private final GalleryImageRepository galleryImageRepository;

    // Constructor for dependency injection
    public GalleryImageServiceImpl(GalleryImageRepository galleryImageRepository) {
        this.galleryImageRepository = galleryImageRepository;
    }

    @Override
    public GalleryImage create(GalleryImage galleryImage) {
        if (galleryImage != null && validate(galleryImage)) {
            return galleryImageRepository.save(galleryImage);
        }
        return null;
    }

    @Override
    public GalleryImage update(GalleryImage galleryImage) {
        if (galleryImage != null && validate(galleryImage)) {
            return galleryImageRepository.update(galleryImage);
        }
        return null;
    }

    @Override
    public Optional<GalleryImage> findById(Integer id) {
        return galleryImageRepository.findById(id);
    }

    @Override
    public List<GalleryImage> findAll() {
        return galleryImageRepository.findAll();
    }

    @Override
    public List<GalleryImage> findAllActive() {
        return galleryImageRepository.findAllActive();
    }

    @Override
    public List<GalleryImage> findByStatus(String status) {
        return galleryImageRepository.findByStatus(status);
    }

    @Override
    public List<GalleryImage> findByImageType(String imageType) {
        // This would require a custom query in the repository
        // For now, we'll filter from all active images
        return galleryImageRepository.findAllActive().stream()
                .filter(img -> img.getImageType() != null && img.getImageType().equalsIgnoreCase(imageType))
                .toList();
    }

    @Override
    public List<GalleryImage> findByUploadedBy(Integer uploadedBy) {
        // This would require a custom query in the repository
        // For now, we'll filter from all active images
        return galleryImageRepository.findAllActive().stream()
                .filter(img -> img.getUploadedBy() != null && img.getUploadedBy().equals(uploadedBy))
                .toList();
    }

    @Override
    public List<GalleryImage> findAllApproved() {
        return galleryImageRepository.findByStatus("APPROVED");
    }

    @Override
    public boolean deleteById(Integer id) {
        return galleryImageRepository.deleteById(id);
    }

    @Override
    public boolean softDeleteById(Integer id) {
        return galleryImageRepository.softDeleteById(id);
    }

    @Override
    public boolean existsById(Integer id) {
        return galleryImageRepository.existsById(id);
    }

    @Override
    public long getTotalCount() {
        return galleryImageRepository.count();
    }

    @Override
    public long getActiveCount() {
        return galleryImageRepository.countActive();
    }

    @Override
    public boolean validate(GalleryImage entity) {
        if (entity == null) {
            return false;
        }

        // Basic validation
        if (entity.getImageName() == null || entity.getImageName().trim().isEmpty()) {
            return false;
        }

        if (entity.getImageUrl() == null || entity.getImageUrl().trim().isEmpty()) {
            return false;
        }

        if (entity.getImageType() == null || entity.getImageType().trim().isEmpty()) {
            return false;
        }

        if (entity.getStatus() == null || entity.getStatus().trim().isEmpty()) {
            return false;
        }

        return true;
    }
}