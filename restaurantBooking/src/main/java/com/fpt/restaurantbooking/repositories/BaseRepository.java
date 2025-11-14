package com.fpt.restaurantbooking.repositories;

import java.util.List;
import java.util.Optional;

/**
 * Base repository interface for common CRUD operations
 */
public interface BaseRepository<T, ID> {

    /**
     * Save an entity
     */
    T save(T entity);

    /**
     * Update an entity
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
     * Count all entities
     */
    long count();

    /**
     * Count all active entities
     */
    long countActive();
}