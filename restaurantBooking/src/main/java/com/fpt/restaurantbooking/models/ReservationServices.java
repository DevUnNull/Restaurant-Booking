package com.fpt.restaurantbooking.models;

import com.fpt.restaurantbooking.services.ReservationService;

import java.util.Objects;

public class ReservationServices {
    private Integer reservationId;
    private Integer serviceId;

    public ReservationServices() {
    }

    public ReservationServices(Integer reservationId, Integer serviceId) {
        this.reservationId = reservationId;
        this.serviceId = serviceId;
    }

    public Integer getReservationId() {
        return reservationId;
    }

    public void setReservationId(Integer reservationId) {
        this.reservationId = reservationId;
    }

    public Integer getServiceId() {
        return serviceId;
    }

    public void setServiceId(Integer serviceId) {
        this.serviceId = serviceId;
    }

}
