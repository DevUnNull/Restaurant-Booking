package com.fpt.restaurantbooking.models;

import java.time.LocalDate;
import java.time.LocalTime;

/**
 * WorkSchedule entity representing work schedules
 */
public class WorkSchedule extends BaseEntity {
    private Integer scheduleId;
    private User user;
    private LocalDate workDate;
    private String shift;
    private LocalTime startTime;
    private LocalTime endTime;
    private String workPosition;
    private String notes;
    private String status;
    private Integer assignedBy;

    public WorkSchedule(Integer scheduleId, User user, LocalDate workDate, String shift, LocalTime startTime, LocalTime endTime, String workPosition, String notes, String status) {
        this.scheduleId = scheduleId;
        this.user = user;
        this.workDate = workDate;
        this.shift = shift;
        this.startTime = startTime;
        this.endTime = endTime;
        this.workPosition = workPosition;
        this.notes = notes;
        this.status = status;
    }

    public WorkSchedule() {
        super();
        this.status = "ACTIVE";
    }

    // Getters and Setters
    public Integer getScheduleId() {
        return scheduleId;
    }

    public void setScheduleId(Integer scheduleId) {
        this.scheduleId = scheduleId;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public LocalDate getWorkDate() {
        return workDate;
    }

    public void setWorkDate(LocalDate workDate) {
        this.workDate = workDate;
    }

    public String getShift() {
        return shift;
    }

    public void setShift(String shift) {
        this.shift = shift;
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

    public String getWorkPosition() {
        return workPosition;
    }

    public void setWorkPosition(String workPosition) {
        this.workPosition = workPosition;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getAssignedBy() {
        return assignedBy;
    }

    public void setAssignedBy(Integer assignedBy) {
        this.assignedBy = assignedBy;
    }
}