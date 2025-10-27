package com.fpt.restaurantbooking.models;

import java.time.LocalDate;
import java.time.LocalTime;

/**
 * TimeSlot entity representing time slots
 */
public class TimeSlot  {
    private Integer slotId;
    private LocalDate applicableDate;
    private String morning_start_time;
    private String morning_end_time;
    private String afternoon_start_time;
    private String evening_start_time;
    private String afternoon_end_time;
    private String evening_end_time;
    private String slotType;
    private String status;
    private String description;
    private int category_id;
    private String name_Category;
    private String updated_by;
    private String updated_at;
    private String updated_name;

    public TimeSlot(LocalDate applicableDate, int category_id) {
        this.applicableDate = applicableDate;
        this.category_id = category_id;
    }
    public TimeSlot(Integer slotId, LocalDate applicableDate, int category_id, String morning_start_time, String morning_end_time, String afternoon_start_time, String evening_start_time, String afternoon_end_time, String evening_end_time, String description) {
        this.slotId = slotId;
        this.applicableDate = applicableDate;
        this.category_id = category_id;
        this.morning_start_time = morning_start_time;
        this.morning_end_time = morning_end_time;
        this.afternoon_start_time = afternoon_start_time;
        this.evening_start_time = evening_start_time;
        this.afternoon_end_time = afternoon_end_time;
        this.evening_end_time = evening_end_time;
        this.description= description;
    }
    public TimeSlot(Integer slotId, LocalDate applicableDate, int category_id, String morning_start_time, String morning_end_time, String afternoon_start_time, String evening_start_time, String afternoon_end_time, String evening_end_time, String description, String updated_at, String updated_by, String name_Category, String updated_name) {
        this.slotId = slotId;
        this.applicableDate = applicableDate;
        this.category_id = category_id;
        this.morning_start_time = morning_start_time;
        this.morning_end_time = morning_end_time;
        this.afternoon_start_time = afternoon_start_time;
        this.evening_start_time = evening_start_time;
        this.afternoon_end_time = afternoon_end_time;
        this.evening_end_time = evening_end_time;
        this.description= description;
        this.updated_at = updated_at;
        this.updated_by = updated_by;
        this.name_Category = name_Category;
        this.updated_name = updated_name;
    }
    public String getUpdated_by() {
        return updated_by;
    }

    public void setUpdated_by(String updated_by) {
        this.updated_by = updated_by;
    }
    public String getUpdated_at() {
        return updated_at;
    }

    public void setUpdated_at(String updated_at) {
        this.updated_at = updated_at;
    }
    public String getUpdated_name() {
        return updated_name;
    }

    public void setUpdated_name(String updated_name) {
        this.updated_name = updated_name;
    }
    public String getName_Category() {
        return name_Category;
    }

    public void setName_Category(String name_Category) {
        this.name_Category = name_Category;
    }
    public Integer getCategory_id() {
        return category_id;
    }

    public void setCategory_id(Integer category_id) {
        this.category_id = category_id;
    }
    // Getters and Setters
    public String getMorning_start_time() {
        return morning_start_time;
    }

    public void setMorning_start_time(String morning_start_time) {
        this.morning_start_time = morning_start_time;
    }
    public String getMorning_end_time() {
        return morning_end_time;
    }

    public void setMorning_end_time(String morning_end_time) {
        this.morning_end_time = morning_end_time;
    }
    public String getAfternoon_start_time() {
        return afternoon_start_time;
    }

    public void setAfternoon_start_time(String afternoon_start_time) {
        this.afternoon_start_time = afternoon_start_time;
    }
    public String getAfternoon_end_time() {
        return afternoon_end_time;
    }

    public void setAfternoon_end_time(String afternoon_end_time) {
        this.afternoon_end_time = afternoon_end_time;
    }

    public String getEvening_start_time() {
        return evening_start_time;
    }

    public void setEvening_start_time(String evening_start_time) {
        this.evening_start_time = evening_start_time;
    }




    public String getEvening_end_time() {
        return evening_end_time;
    }

    public void setEvening_end_time(String evening_end_time) {
        this.evening_end_time = evening_end_time;
    }
    public Integer getSlotId() {
        return slotId;
    }

    public void setSlotId(Integer slotId) {
        this.slotId = slotId;
    }

    public LocalDate getApplicableDate() {
        return applicableDate;
    }

    public void setApplicableDate(LocalDate applicableDate) {
        this.applicableDate = applicableDate;
    }



    public String getSlotType() {
        return slotType;
    }

    public void setSlotType(String slotType) {
        this.slotType = slotType;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}