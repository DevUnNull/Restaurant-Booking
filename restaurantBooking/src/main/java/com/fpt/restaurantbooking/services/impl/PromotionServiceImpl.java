package com.fpt.restaurantbooking.services.impl;

import com.fpt.restaurantbooking.models.Promotion;
import com.fpt.restaurantbooking.repositories.PromotionRepository;
import com.fpt.restaurantbooking.services.PromotionService;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

/**
 * Implementation of PromotionService interface
 */
public class PromotionServiceImpl implements PromotionService {
    
    private final PromotionRepository promotionRepository;
    
    // Constructor for dependency injection
    public PromotionServiceImpl(PromotionRepository promotionRepository) {
        this.promotionRepository = promotionRepository;
    }
    
    @Override
    public Promotion create(Promotion promotion) {
        if (promotion != null) {
            return promotionRepository.save(promotion);
        }
        return null;
    }
    
    @Override
    public Promotion update(Promotion promotion) {
        return promotionRepository.update(promotion);
    }
    
    @Override
    public Optional<Promotion> findById(Long id) {
        return promotionRepository.findById(id);
    }
    
    @Override
    public List<Promotion> findActivePromotions(LocalDate currentDate) {
        return promotionRepository.findActivePromotions(currentDate);
    }
    
    @Override
    public List<Promotion> findActivePromotionsForHomePage() {
        return promotionRepository.findActivePromotionsForHomePage();
    }
    
    @Override
    public List<Promotion> findByStatus(String status) {
        return promotionRepository.findByStatus(status);
    }
    
    @Override
    public List<Promotion> findAll() {
        return promotionRepository.findAll();
    }
    
    @Override
    public List<Promotion> findAllActive() {
        return promotionRepository.findAllActive();
    }
    
    @Override
    public boolean deleteById(Long id) {
        return promotionRepository.deleteById(id);
    }
    
    @Override
    public boolean softDeleteById(Long id) {
        return promotionRepository.softDeleteById(id);
    }
    
    @Override
    public boolean existsById(Long id) {
        return promotionRepository.existsById(id);
    }
    
    @Override
    public long getTotalCount() {
        return promotionRepository.count();
    }
    
    @Override
    public long getActiveCount() {
        return promotionRepository.countActive();
    }
    
    @Override
    public boolean validate(Promotion entity) {
        if (entity == null) {
            return false;
        }
        
        // Basic validation
        if (entity.getPromotionName() == null || entity.getPromotionName().trim().isEmpty()) {
            return false;
        }
        
        if (entity.getDescription() == null || entity.getDescription().trim().isEmpty()) {
            return false;
        }
        
        if (entity.getDiscountValue() == null || entity.getDiscountValue().compareTo(BigDecimal.ZERO) <= 0) {
            return false;
        }
        
        return true;
    }
}