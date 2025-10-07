package com.fpt.restaurantbooking.services;

import java.util.List;
import java.util.Optional;

/**
 * Base service interface for common business operations
 */
public interface BaseService<T, ID> {
    
    /**
     * Create a new entity
     */
    T create(T entity);
    
    /**
     * Update an existing entity
     */
    T update(T entity);
    
    /**
     * Find entity by ID
     */
    Optional<T> findById(ID id);
    
    /**
     * Find all entities
     */
    List<T> findAll();
    
    /**
     * Find all active entities
     */
    List<T> findAllActive();
    
    /**
     * Delete entity by ID
     */
    boolean deleteById(ID id);
    
    /**
     * Soft delete entity by ID
     */
    boolean softDeleteById(ID id);
    
    /**
     * Check if entity exists by ID
     */
    boolean existsById(ID id);
    
    /**
     * Get total count
     */
    long getTotalCount();
    
    /**
     * Get active count
     */
    long getActiveCount();
    
    /**
     * Validate entity before save/update
     */
    boolean validate(T entity);
}