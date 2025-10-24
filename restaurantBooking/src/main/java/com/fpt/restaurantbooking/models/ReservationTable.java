package com.fpt.restaurantbooking.models;

public class ReservationTable extends BaseEntity {
    private Integer reservationTableId;
    private Integer reservationId;
    private Integer tableId;

    // Constructors
    public ReservationTable() {
        super();
    }

    public ReservationTable(Integer reservationId, Integer tableId) {
        super();
        this.reservationId = reservationId;
        this.tableId = tableId;
    }

    // Getters and Setters
    public Integer getReservationTableId() {
        return reservationTableId;
    }

    public void setReservationTableId(Integer reservationTableId) {
        this.reservationTableId = reservationTableId;
    }

    public Integer getReservationId() {
        return reservationId;
    }

    public void setReservationId(Integer reservationId) {
        this.reservationId = reservationId;
    }

    public Integer getTableId() {
        return tableId;
    }

    public void setTableId(Integer tableId) {
        this.tableId = tableId;
    }
}