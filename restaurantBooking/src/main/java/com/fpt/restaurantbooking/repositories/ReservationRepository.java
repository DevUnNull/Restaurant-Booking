package com.fpt.restaurantbooking.repositories;

import com.fpt.restaurantbooking.models.Reservation;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

/**
 * Repository interface for Reservation entity
 */
public interface ReservationRepository extends BaseRepository<Reservation, Long> {
    
    /**
     * Find reservations by user ID
     */
    List<Reservation> findByUserId(Long userId);
    
    /**
     * Find reservations by restaurant ID
     */
    List<Reservation> findByRestaurantId(Long restaurantId);
    
    /**
     * Find reservations by table ID
     */
    List<Reservation> findByTableId(Long tableId);
    
    /**
     * Find reservations by status
     */
    List<Reservation> findByStatus(Reservation.ReservationStatus status);
    
    /**
     * Find reservations by date range
     */
    List<Reservation> findByDateRange(LocalDateTime startDate, LocalDateTime endDate);
    
    /**
     * Find reservations by restaurant and date range
     */
    List<Reservation> findByRestaurantAndDateRange(Long restaurantId, LocalDateTime startDate, LocalDateTime endDate);
    
    /**
     * Find reservations by table and date range
     */
    List<Reservation> findByTableAndDateRange(Long tableId, LocalDateTime startDate, LocalDateTime endDate);
    
    /**
     * Find upcoming reservations for user
     */
    List<Reservation> findUpcomingReservationsByUserId(Long userId);
    
    /**
     * Find past reservations for user
     */
    List<Reservation> findPastReservationsByUserId(Long userId);
    
    /**
     * Find today's reservations for restaurant
     */
    List<Reservation> findTodayReservationsByRestaurant(Long restaurantId);
    
    /**
     * Check table availability for specific time slot
     */
    boolean isTableAvailable(Long tableId, LocalDateTime startTime, LocalDateTime endTime);
    
    /**
     * Update reservation status
     */
    boolean updateStatus(Long reservationId, Reservation.ReservationStatus status);

    Map<String, Object> getOverviewStats();
}