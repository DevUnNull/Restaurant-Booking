package com.fpt.restaurantbooking.repositories;

import com.fpt.restaurantbooking.models.MenuItem;

import java.util.List;

/**
 * Repository interface for Menu Item entity
 */
public interface MenuItemRepository extends BaseRepository<MenuItem, Long> {

    /**
     * Find featured menu items for home page display
     */
    List<MenuItem> findFeaturedItems();

    // Các phương thức mới cho trang menu
    List<MenuItem> findAllAvailable();
    List<MenuItem> findByCategoryId(int categoryId);
    /**
     * Find menu items by category
     */
    List<MenuItem> findByCategory(String category);


    List<MenuItem> findActiveItems();

    /**
     * Find menu items by status
     */
    List<MenuItem> findByStatus(String status);
}