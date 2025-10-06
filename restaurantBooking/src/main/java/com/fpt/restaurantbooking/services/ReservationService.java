package com.fpt.restaurantbooking.services;

import com.fpt.restaurantbooking.models.Reservation;

import java.time.LocalDateTime;
import java.util.List;

/**
 * Service interface for Reservation business operations
 */
public interface ReservationService extends BaseService<Reservation, Long> {
    
    /**
     * Create a new reservation
     */
    Reservation createReservation(Reservation reservation);
    
    /**
     * Check table availability
     */
    boolean isTableAvailable(Long tableId, LocalDateTime dateTime, int duration);
    
    /**
     * Find available tables for reservation
     */
    List<Long> findAvailableTables(Long restaurantId, LocalDateTime dateTime, int partySize, int duration);
    
    /**
     * Get user reservations
     */
    List<Reservation> getUserReservations(Long userId);
    
    /**
     * Get upcoming reservations for user
     */
    List<Reservation> getUpcomingReservations(Long userId);
    
    /**
     * Get past reservations for user
     */
    List<Reservation> getPastReservations(Long userId);
    
    /**
     * Get restaurant reservations
     */
    List<Reservation> getRestaurantReservations(Long restaurantId);
    
    /**
     * Get today's reservations for restaurant
     */
    List<Reservation> getTodayReservations(Long restaurantId);
    
    /**
     * Get reservations by date range
     */
    List<Reservation> getReservationsByDateRange(Long restaurantId, LocalDateTime startDate, LocalDateTime endDate);
    
    /**
     * Confirm reservation
     */
    boolean confirmReservation(Long reservationId);
    
    /**
     * Cancel reservation
     */
    boolean cancelReservation(Long reservationId, String reason);
    
    /**
     * Mark reservation as completed
     */
    boolean completeReservation(Long reservationId);
    
    /**
     * Mark reservation as no-show
     */
    boolean markAsNoShow(Long reservationId);
    
    /**
     * Update reservation status
     */
    boolean updateReservationStatus(Long reservationId, Reservation.ReservationStatus status);
    
    /**
     * Send reservation confirmation email
     */
    boolean sendConfirmationEmail(Reservation reservation);
    
    /**
     * Send reservation reminder email
     */
    boolean sendReminderEmail(Reservation reservation);
    
    /**
     * Send cancellation email
     */
    boolean sendCancellationEmail(Reservation reservation, String reason);
    
    /**
     * Validate reservation data
     */
    boolean validateReservation(Reservation reservation);
    
    /**
     * Check if reservation can be modified
     */
    boolean canModifyReservation(Long reservationId);
    
    /**
     * Check if reservation can be cancelled
     */
    boolean canCancelReservation(Long reservationId);
}