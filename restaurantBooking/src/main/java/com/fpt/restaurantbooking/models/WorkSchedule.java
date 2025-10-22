package com.fpt.restaurantbooking.models;

import java.time.LocalDate;
import java.time.LocalTime;

/**
 * WorkSchedule entity representing work schedules
 */
public class WorkSchedule extends BaseEntity {
    private Integer scheduleId;
    private Integer userId;
    private String employeeName;
    private LocalDate workDate;
    private String shift;
    private LocalTime startTime;
    private LocalTime endTime;
    private String workPosition;
    private String notes;
    private String status;
    private Integer assignedBy;

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

    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }

    public String getEmployeeName() { return employeeName; }
    public void setEmployeeName(String employeeName) { this.employeeName = employeeName; }

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

    @Override
    public String toString() {
        return "WorkSchedule{" +
                "scheduleId=" + scheduleId +
                ", userId=" + userId +
                ", workDate=" + workDate +
                ", shift='" + shift + '\'' +
                ", startTime=" + startTime +
                ", endTime=" + endTime +
                ", position='" + workPosition + '\'' +
                ", note='" + notes + '\'' +
                ", status='" + status + '\'' +
                ", assignedBy='" + assignedBy + '\'' +
                '}';
    }

}