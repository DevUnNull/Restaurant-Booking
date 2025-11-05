package com.fpt.restaurantbooking.models;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * Service entity representing services
 */
public class Service {
    private int ServiceId;
    private String ServiceName;
    private String ServiceCode;
    private String Description;
    private String Price;
    private String PromotionInfo;
    private String StartDate;
    private String EndDate;
    private String Status;
    private int CreatedBy;
    private int UpdatedBy;
    private String NameCreated;
    private String NameUpdated;
    private int item_id;
    public Service() {
    }
    public Service(int ServiceId, int item_id) {
        this.ServiceId = ServiceId;
        this.item_id = item_id;

    }
    public Service(int ServiceId, String ServiceName, String ServiceCode, String Description, String Price, String PromotionInfo, String StartDate, String EndDate, String Status, String NameCreated, String NameUpdated) {
        this.ServiceId = ServiceId;
        this.ServiceName = ServiceName;
        this.ServiceCode = ServiceCode;
        this.Description = Description;
        this.Price = Price;
        this.PromotionInfo = PromotionInfo;
        this.StartDate = StartDate;
        this.EndDate = EndDate;
        this.Status = Status;
        this.NameCreated = NameCreated;
        this.NameUpdated = NameUpdated;
    }

    public Service(int ServiceId, String ServiceName, String ServiceCode, String Description, String Price, String PromotionInfo, String StartDate, String EndDate, String Status) {
        this.ServiceId = ServiceId;
        this.ServiceName = ServiceName;
        this.ServiceCode = ServiceCode;
        this.Description = Description;
        this.Price = Price;
        this.PromotionInfo = PromotionInfo;
        this.StartDate = StartDate;
        this.EndDate = EndDate;
        this.Status = Status;
    }

    public String getNameCreated() {
        return NameCreated;
    }

    public void setNameCreated(String NameCreated) {
        this.NameCreated = NameCreated;
    }

    public String getNameUpdated() {
        return NameUpdated;
    }

    public void setNameUpdated(String NameUpdated) {
        this.NameUpdated = NameUpdated;
    }

    public void setUpdatedBy(int UpdatedBy) {
        this.UpdatedBy = UpdatedBy;
    }
    public int getItem_id() {
        return item_id;
    }


    public void setItem_id(int item_id) {
        this.item_id = item_id;
    }
    public int getServiceId() {
        return ServiceId;
    }


    public void setServiceId(int ServiceId) {
        this.ServiceId = ServiceId;
    }

    public String getServiceName() {
        return ServiceName;
    }

    public void setServiceName(String ServiceName) {
        this.ServiceName = ServiceName;
    }

    public String getServiceCode() {
        return ServiceCode;
    }

    public void setServiceCode(String ServiceCode) {
        this.ServiceCode = ServiceCode;
    }

    public String getDescription() {
        return Description;
    }

    public void setDescription(String Description) {
        this.Description = Description;
    }

    public String getPrice() {
        return Price;
    }

    public void setPrice(String Price) {
        this.Price = Price;
    }

    public String getPromotionInfo() {
        return PromotionInfo;
    }

    public void setPromotionInfo(String PromotionInfo) {
        this.PromotionInfo = PromotionInfo;
    }

    public String getStartDate() {
        return StartDate;
    }

    public void setStartDate(String StartDate) {
        this.StartDate = StartDate;
    }

    public String getEndDate() {
        return EndDate;
    }

    public void setEndDate(String EndDate) {
        this.EndDate = EndDate;
    }

    public String getStatus() {
        return Status;
    }

    public void setStatus(String Status) {
        this.Status = Status;
    }

    public int getCreatedBy() {
        return CreatedBy;
    }

    public void setCreatedBy(int CreatedBy) {
        this.CreatedBy = CreatedBy;
    }

    public int getUpdatedBy() {
        return UpdatedBy;
    }

    public void setUpdated_by(int updated_by) {
        this.UpdatedBy = updated_by;
    }






}