package com.fpt.restaurantbooking.models;

/**
 * Table entity representing restaurant tables
 */
public class Table extends BaseEntity {
    private Integer tableId;
    private String tableName;
    private Integer capacity;
    private Integer floor;
    private String tableType;
    private String status;

    public enum TableStatus {
        AVAILABLE, OCCUPIED, RESERVED, OUT_OF_SERVICE
    }

    public Table() {
        super();
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
}