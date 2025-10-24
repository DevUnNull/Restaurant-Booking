package com.fpt.restaurantbooking.models;

import java.time.LocalDateTime;

/**
 * Table entity representing restaurant tables
 */
public class Table extends BaseEntity {
    private Integer tableId;
    private String tableName;
    private Integer capacity;
    private Integer floor;
    private String tableType;
    private String status; // AVAILABLE, RESERVED, MAINTENANCE
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public enum TableStatus {
        AVAILABLE, RESERVED, MAINTENANCE
    }

    // Constructors
    public Table() {
        super();
        this.status = "AVAILABLE";
    }

    public Table(Integer tableId, String tableName, Integer capacity, Integer floor, String tableType) {
        super();
        this.tableId = tableId;
        this.tableName = tableName;
        this.capacity = capacity;
        this.floor = floor;
        this.tableType = tableType;
        this.status = "AVAILABLE";
    }

    // Getters and Setters
    public Integer getTableId() {
        return tableId;
    }

    public void setTableId(Integer tableId) {
        this.tableId = tableId;
    }

    public String getTableName() {
        return tableName;
    }

    public void setTableName(String tableName) {
        this.tableName = tableName;
    }

    public Integer getCapacity() {
        return capacity;
    }

    public void setCapacity(Integer capacity) {
        this.capacity = capacity;
    }

    public Integer getFloor() {
        return floor;
    }

    public void setFloor(Integer floor) {
        this.floor = floor;
    }

    public String getTableType() {
        return tableType;
    }

    public void setTableType(String tableType) {
        this.tableType = tableType;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
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
        return "Table{" +
                "tableId=" + tableId +
                ", tableName='" + tableName + '\'' +
                ", capacity=" + capacity +
                ", floor=" + floor +
                ", status='" + status + '\'' +
                '}';
    }
}