package com.fpt.restaurantbooking.models;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

public class ReportServiceDetail {

    // --- CỘT TỪ REPORT_SERVICE_DETAILS_EXPANDED ---
    private Integer reportDetailId;

    // --- CỘT TỪ RESERVATIONS ---
    private Integer reservationId;
    private Integer userId;
    private Integer tableId;
    private LocalDate reservationDate;
    private LocalTime reservationTime;
    private String reservationStatus;
    private Integer guestCount;
    private String specialRequests;
    private String cancellationReason;
    private LocalDateTime reservationCreatedAt;
    private BigDecimal reservationTotalAmount; // Tổng tiền của CẢ ĐƠN HÀNG

    // --- CỘT TÍNH TOÁN/LOẠI HÌNH DỊCH VỤ ---
    private String serviceType; // Breakfast, Lunch, Dinner, Other

    // --- CỘT TỪ ORDER_ITEMS & MENU_ITEMS ---
    private Integer orderItemId;
    private Integer itemId;
    private String itemName;
    private String categoryName;
    private Integer quantitySold;
    private BigDecimal lineRevenue; // Doanh thu trên mỗi món (quantity * unit_price)

    // Constructor mặc định
    public ReportServiceDetail() {}

    // Constructor đầy đủ (Tùy chọn, nếu bạn cần khởi tạo nhanh)
    public ReportServiceDetail(Integer reportDetailId, Integer reservationId, Integer userId, Integer tableId, LocalDate reservationDate, LocalTime reservationTime, String reservationStatus, Integer guestCount, String specialRequests, String cancellationReason, LocalDateTime reservationCreatedAt, BigDecimal reservationTotalAmount, String serviceType, Integer orderItemId, Integer itemId, String itemName, String categoryName, Integer quantitySold, BigDecimal lineRevenue) {
        this.reportDetailId = reportDetailId;
        this.reservationId = reservationId;
        this.userId = userId;
        this.tableId = tableId;
        this.reservationDate = reservationDate;
        this.reservationTime = reservationTime;
        this.reservationStatus = reservationStatus;
        this.guestCount = guestCount;
        this.specialRequests = specialRequests;
        this.cancellationReason = cancellationReason;
        this.reservationCreatedAt = reservationCreatedAt;
        this.reservationTotalAmount = reservationTotalAmount;
        this.serviceType = serviceType;
        this.orderItemId = orderItemId;
        this.itemId = itemId;
        this.itemName = itemName;
        this.categoryName = categoryName;
        this.quantitySold = quantitySold;
        this.lineRevenue = lineRevenue;
    }

    // --- Getters và Setters ---

    public Integer getReportDetailId() {
        return reportDetailId;
    }

    public void setReportDetailId(Integer reportDetailId) {
        this.reportDetailId = reportDetailId;
    }

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

    public String getReservationStatus() {
        return reservationStatus;
    }

    public void setReservationStatus(String reservationStatus) {
        this.reservationStatus = reservationStatus;
    }

    public Integer getGuestCount() {
        return guestCount;
    }

    public void setGuestCount(Integer guestCount) {
        this.guestCount = guestCount;
    }

    public String getSpecialRequests() {
        return specialRequests;
    }

    public void setSpecialRequests(String specialRequests) {
        this.specialRequests = specialRequests;
    }

    public String getCancellationReason() {
        return cancellationReason;
    }

    public void setCancellationReason(String cancellationReason) {
        this.cancellationReason = cancellationReason;
    }

    public LocalDateTime getReservationCreatedAt() {
        return reservationCreatedAt;
    }

    public void setReservationCreatedAt(LocalDateTime reservationCreatedAt) {
        this.reservationCreatedAt = reservationCreatedAt;
    }

    public BigDecimal getReservationTotalAmount() {
        return reservationTotalAmount;
    }

    public void setReservationTotalAmount(BigDecimal reservationTotalAmount) {
        this.reservationTotalAmount = reservationTotalAmount;
    }

    public String getServiceType() {
        return serviceType;
    }

    public void setServiceType(String serviceType) {
        this.serviceType = serviceType;
    }

    public Integer getOrderItemId() {
        return orderItemId;
    }

    public void setOrderItemId(Integer orderItemId) {
        this.orderItemId = orderItemId;
    }

    public Integer getItemId() {
        return itemId;
    }

    public void setItemId(Integer itemId) {
        this.itemId = itemId;
    }

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public Integer getQuantitySold() {
        return quantitySold;
    }

    public void setQuantitySold(Integer quantitySold) {
        this.quantitySold = quantitySold;
    }

    public BigDecimal getLineRevenue() {
        return lineRevenue;
    }

    public void setLineRevenue(BigDecimal lineRevenue) {
        this.lineRevenue = lineRevenue;
    }

    // Bạn có thể thêm phương thức toString() tại đây nếu cần debug
}