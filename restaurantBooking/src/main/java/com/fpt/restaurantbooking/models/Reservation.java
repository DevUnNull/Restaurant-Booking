package com.fpt.restaurantbooking.models;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

public class Reservation {
    private Integer reservationId;
    private Integer userId;
    private Integer tableId;
    private LocalDate reservationDate;
    private LocalTime reservationTime;
    private int guestCount;
    private String specialRequests;
    private String status;
    private BigDecimal totalAmount;
    private String cancellationReason;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Constructors
    public Reservation() {}

    public Reservation(Integer reservationId, Integer userId, Integer tableId, int guestCount,
                       LocalDateTime createdAt, String status, int guestCountAgain) {
        this.reservationId = reservationId;
        this.userId = userId;
        this.tableId = tableId;
        this.guestCount = guestCount;
        this.createdAt = createdAt;
        this.status = status;
    }

    // Full constructor
    public Reservation(Integer reservationId, Integer userId, Integer tableId, LocalDate reservationDate,
                       LocalTime reservationTime, int guestCount, String specialRequests, String status,
                       BigDecimal totalAmount, String cancellationReason,
                       LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.reservationId = reservationId;
        this.userId = userId;
        this.tableId = tableId;
        this.reservationDate = reservationDate;
        this.reservationTime = reservationTime;
        this.guestCount = guestCount;
        this.specialRequests = specialRequests;
        this.status = status;
        this.totalAmount = totalAmount;
        this.cancellationReason = cancellationReason;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // Getters and Setters

    public Integer getReservationId() {
        return reservationId;
    }

    public void setReservationId(Integer reservationId) {
        this.reservationId = reservationId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Integer getTableId() {
        return tableId;
    }

    public void setTableId(Integer tableId) {
        this.tableId = tableId;
    }

    public LocalDate getReservationDate() {
        return reservationDate;
    }

    public void setReservationDate(LocalDate reservationDate) {
        this.reservationDate = reservationDate;
    }

    public LocalTime getReservationTime() {
        return reservationTime;
    }

    public void setReservationTime(LocalTime reservationTime) {
        this.reservationTime = reservationTime;
    }

    public int getGuestCount() {
        return guestCount;
    }

    public void setGuestCount(int guestCount) {
        this.guestCount = guestCount;
    }

    public String getSpecialRequests() {
        return specialRequests;
    }

    public void setSpecialRequests(String specialRequests) {
        this.specialRequests = specialRequests;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getCancellationReason() {
        return cancellationReason;
    }

    public void setCancellationReason(String cancellationReason) {
        this.cancellationReason = cancellationReason;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    @Override
    public String toString() {
        return "Reservation{" +
                "reservationId=" + reservationId +
                ", userId=" + userId +
                ", tableId=" + tableId +
                ", reservationDate=" + reservationDate +
                ", reservationTime=" + reservationTime +
                ", guestCount=" + guestCount +
                ", specialRequests='" + specialRequests + '\'' +
                ", status='" + status + '\'' +
                ", totalAmount=" + totalAmount +
                ", cancellationReason='" + cancellationReason + '\'' +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                '}';
    }
}
