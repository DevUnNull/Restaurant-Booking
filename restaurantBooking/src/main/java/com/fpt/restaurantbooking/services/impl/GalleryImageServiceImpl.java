package com.fpt.restaurantbooking.services.impl;

import com.fpt.restaurantbooking.models.GalleryImage;
import com.fpt.restaurantbooking.repositories.GalleryImageRepository;
import com.fpt.restaurantbooking.services.GalleryImageService;
import java.util.List;

public class GalleryImageServiceImpl implements GalleryImageService {

    private final GalleryImageRepository galleryImageRepository;

    public GalleryImageServiceImpl(GalleryImageRepository galleryImageRepository) {
        this.galleryImageRepository = galleryImageRepository;
    }

    @Override
    public List<GalleryImage> findAllApproved() {
        return galleryImageRepository.findAllApproved();
    }
}