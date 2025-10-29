package com.fpt.restaurantbooking.models;

import java.util.Date;

public class JobRequest {
    private int requestId;
    private int userId;
    private Date requestDate;
    private String status;
    private Integer reviewedBy;
    private Date reviewedDate;
    private String notes;

    public JobRequest() {}

    public JobRequest(int requestId, int userId, Date requestDate, String status, Integer reviewedBy, Date reviewedDate, String notes) {
        this.requestId = requestId;
        this.userId = userId;
        this.requestDate = requestDate;
        this.status = status;
        this.reviewedBy = reviewedBy;
        this.reviewedDate = reviewedDate;
        this.notes = notes;
    }

    // Getters & Setters
    public int getRequestId() { return requestId; }
    public void setRequestId(int requestId) { this.requestId = requestId; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public Date getRequestDate() { return requestDate; }
    public void setRequestDate(Date requestDate) { this.requestDate = requestDate; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Integer getReviewedBy() { return reviewedBy; }
    public void setReviewedBy(Integer reviewedBy) { this.reviewedBy = reviewedBy; }
    public Date getReviewedDate() { return reviewedDate; }
    public void setReviewedDate(Date reviewedDate) { this.reviewedDate = reviewedDate; }
    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
}
