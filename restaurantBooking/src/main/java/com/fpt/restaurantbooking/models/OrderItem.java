package com.fpt.restaurantbooking.models;

import java.math.BigDecimal;

public class OrderItem extends BaseEntity {
    private Integer orderItemId;
    private Integer reservationId;
    private Integer itemId;
    private Integer quantity;
    private BigDecimal unitPrice;
    private String status;
    private String specialInstructions;

    public enum OrderItemStatus {
        PENDING, PREPARING, SERVED, COMPLETED, CANCELLED
    }

    // Constructors
    public OrderItem() {
        super();
        this.status = "PENDING";
    }

    public OrderItem(Integer reservationId, Integer itemId, Integer quantity, BigDecimal unitPrice) {
        super();
        this.reservationId = reservationId;
        this.itemId = itemId;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.status = "PENDING";
    }

    // Getters and Setters
    public Integer getOrderItemId() { return orderItemId; }
    public void setOrderItemId(Integer orderItemId) { this.orderItemId = orderItemId; }

    public Integer getReservationId() { return reservationId; }
    public void setReservationId(Integer reservationId) { this.reservationId = reservationId; }

    public Integer getItemId() { return itemId; }
    public void setItemId(Integer itemId) { this.itemId = itemId; }

    public Integer getQuantity() { return quantity; }
    public void setQuantity(Integer quantity) { this.quantity = quantity; }

    public BigDecimal getUnitPrice() { return unitPrice; }
    public void setUnitPrice(BigDecimal unitPrice) { this.unitPrice = unitPrice; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getSpecialInstructions() { return specialInstructions; }
    public void setSpecialInstructions(String specialInstructions) { this.specialInstructions = specialInstructions; }

    public BigDecimal getTotal() {
        if (unitPrice != null && quantity != null) {
            return unitPrice.multiply(new BigDecimal(quantity));
        }
        return BigDecimal.ZERO;
    }
}