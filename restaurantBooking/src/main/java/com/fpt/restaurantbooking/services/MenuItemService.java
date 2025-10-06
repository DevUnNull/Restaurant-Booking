package com.fpt.restaurantbooking.services;

import com.fpt.restaurantbooking.models.MenuItem;

import java.util.List;

/**
 * Service interface for Menu Item business operations
 */
public interface MenuItemService extends BaseService<MenuItem, Long> {

    MenuItem save(MenuItem menuItem);

    /**
     * Find featured menu items for home page display
     */
    List<MenuItem> findFeaturedItems();
    
    /**
     * Find menu items by category
     */
    List<MenuItem> findByCategory(String category);
    
    /**
     * Find active menu items
     */
    List<MenuItem> findActiveItems();
    
    /**
     * Find menu items by status
     */
    List<MenuItem> findByStatus(String status);
}