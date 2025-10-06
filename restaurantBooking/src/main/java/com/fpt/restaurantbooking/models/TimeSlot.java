package com.fpt.restaurantbooking.models;

import java.time.LocalDate;
import java.time.LocalTime;

/**
 * TimeSlot entity representing time slots
 */
public class TimeSlot extends BaseEntity {
    private Integer slotId;
    private LocalDate applicableDate;
    private LocalTime startTime;
    private LocalTime endTime;
    private String slotType;
    private String status;
    private String blockReason;

    public TimeSlot() {
        super();
        this.status = "AVAILABLE";
    }

    // Getters and Setters
    public Integer getSlotId() {
        return slotId;
    }

    public void setSlotId(Integer slotId) {
        this.slotId = slotId;
    }

    public LocalDate getApplicableDate() {
        return applicableDate;
    }

    public void setApplicableDate(LocalDate applicableDate) {
        this.applicableDate = applicableDate;
    }

    public LocalTime getStartTime() {
        return startTime;
    }

    public void setStartTime(LocalTime startTime) {
        this.startTime = startTime;
    }

    public LocalTime getEndTime() {
        return endTime;
    }

    public void setEndTime(LocalTime endTime) {
        this.endTime = endTime;
    }

    public String getSlotType() {
        return slotType;
    }

    public void setSlotType(String slotType) {
        this.slotType = slotType;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getBlockReason() {
        return blockReason;
    }

    public void setBlockReason(String blockReason) {
        this.blockReason = blockReason;
    }
}