package com.fpt.restaurantbooking.services.impl;

import com.fpt.restaurantbooking.models.MenuItem;
import com.fpt.restaurantbooking.repositories.MenuItemRepository;
import com.fpt.restaurantbooking.services.MenuItemService;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

/**
 * Implementation of MenuItemService interface
 */
public class MenuItemServiceImpl implements MenuItemService {
    
    private final MenuItemRepository menuItemRepository;
    
    // Constructor for dependency injection
    public MenuItemServiceImpl(MenuItemRepository menuItemRepository) {
        this.menuItemRepository = menuItemRepository;
    }
    
    @Override
    public MenuItem save(MenuItem menuItem) {
        return menuItemRepository.save(menuItem);
    }

    @Override
    public MenuItem create(MenuItem menuItem) {
        if (menuItem != null) {
            return menuItemRepository.save(menuItem);
        }
        return null;
    }

    @Override
    public MenuItem update(MenuItem menuItem) {
        return menuItemRepository.update(menuItem);
    }
    
    @Override
    public Optional<MenuItem> findById(Long id) {
        return menuItemRepository.findById(id);
    }
    
    @Override
    public List<MenuItem> findFeaturedItems() {
        return menuItemRepository.findFeaturedItems();
    }
    
    @Override
    public List<MenuItem> findActiveItems() {
        return menuItemRepository.findActiveItems();
    }
    
    @Override
    public List<MenuItem> findByCategory(String category) {
        return menuItemRepository.findByCategory(category);
    }
    
    @Override
    public List<MenuItem> findByStatus(String status) {
        return menuItemRepository.findByStatus(status);
    }
    
    @Override
    public List<MenuItem> findAll() {
        return menuItemRepository.findAll();
    }
    
    @Override
    public List<MenuItem> findAllActive() {
        return menuItemRepository.findAllActive();
    }
    
    @Override
    public boolean deleteById(Long id) {
        return menuItemRepository.deleteById(id);
    }
    
    @Override
    public boolean softDeleteById(Long id) {
        return menuItemRepository.softDeleteById(id);
    }
    
    @Override
    public boolean existsById(Long id) {
        return menuItemRepository.existsById(id);
    }
    
    @Override
    public long getTotalCount() {
        return menuItemRepository.count();
    }
    
    @Override
    public long getActiveCount() {
        return menuItemRepository.countActive();
    }
    
    @Override
    public boolean validate(MenuItem entity) {
        if (entity == null) {
            return false;
        }
        
        // Basic validation
        if (entity.getItemName() == null || entity.getItemName().trim().isEmpty()) {
            return false;
        }
        
        if (entity.getItemCode() == null || entity.getItemCode().trim().isEmpty()) {
            return false;
        }
        
        if (entity.getPrice() == null || entity.getPrice().compareTo(BigDecimal.ZERO) <= 0) {
            return false;
        }
        
        return true;
    }
}