package com.fpt.restaurantbooking.models;

public class ReservationStaffAssignments {
    private Integer assignmentId;
    private Integer reservationId;
    private Integer staffUserId;

    public ReservationStaffAssignments() {
    }

    public ReservationStaffAssignments(Integer assignmentId, Integer reservationId, Integer staffUserId) {
        this.assignmentId = assignmentId;
        this.reservationId = reservationId;
        this.staffUserId = staffUserId;
    }

    public Integer getAssignmentId() {
        return assignmentId;
    }

    public void setAssignmentId(Integer assignmentId) {
        this.assignmentId = assignmentId;
    }

    public Integer getReservationId() {
        return reservationId;
    }

    public void setReservationId(Integer reservationId) {
        this.reservationId = reservationId;
    }

    public Integer getStaffUserId() {
        return staffUserId;
    }

    public void setStaffUserId(Integer staffUserId) {
        this.staffUserId = staffUserId;
    }
}
