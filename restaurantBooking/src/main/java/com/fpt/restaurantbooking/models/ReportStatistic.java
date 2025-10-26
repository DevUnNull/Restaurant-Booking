package com.fpt.restaurantbooking.models;
import java.math.BigDecimal;
import java.sql.Date;

public class ReportStatistic {

        private int id;
        private Date reportDate;
        private int month;
        private int year;
        private int totalBookings;
        private int successfulBookings;
        private int cancelledBookings;
        private BigDecimal totalRevenue;

    public ReportStatistic() {
    }

    public ReportStatistic(int id, Date reportDate, int month, int year, int totalBookings, int successfulBookings, int cancelledBookings, BigDecimal totalRevenue) {
        this.id = id;
        this.reportDate = reportDate;
        this.month = month;
        this.year = year;
        this.totalBookings = totalBookings;
        this.successfulBookings = successfulBookings;
        this.cancelledBookings = cancelledBookings;
        this.totalRevenue = totalRevenue;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Date getReportDate() {
        return reportDate;
    }

    public void setReportDate(Date reportDate) {
        this.reportDate = reportDate;
    }

    public int getMonth() {
        return month;
    }

    public void setMonth(int month) {
        this.month = month;
    }

    public int getYear() {
        return year;
    }

    public void setYear(int year) {
        this.year = year;
    }

    public int getTotalBookings() {
        return totalBookings;
    }

    public void setTotalBookings(int totalBookings) {
        this.totalBookings = totalBookings;
    }

    public int getSuccessfulBookings() {
        return successfulBookings;
    }

    public void setSuccessfulBookings(int successfulBookings) {
        this.successfulBookings = successfulBookings;
    }

    public int getCancelledBookings() {
        return cancelledBookings;
    }

    public void setCancelledBookings(int cancelledBookings) {
        this.cancelledBookings = cancelledBookings;
    }

    public BigDecimal getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(BigDecimal totalRevenue) {
        this.totalRevenue = totalRevenue;
    }

    @Override
    public String toString() {
        return "ReportStatistic{" +
                "id=" + id +
                ", reportDate=" + reportDate +
                ", month=" + month +
                ", year=" + year +
                ", totalBookings=" + totalBookings +
                ", successfulBookings=" + successfulBookings +
                ", cancelledBookings=" + cancelledBookings +
                ", totalRevenue=" + totalRevenue +
                '}';
    }
}

