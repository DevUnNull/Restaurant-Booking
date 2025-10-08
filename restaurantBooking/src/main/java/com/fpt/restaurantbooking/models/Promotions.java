package com.fpt.restaurantbooking.models;

public class Promotions {
    private int promotion_id;
    private String promotionName;
    private String description;
    private double discount_percentage;
    private double discount_amount;
    private String start_date;
    private String end_date;
    private String status;
    private String created_by;
    private String updated_by;
    private String created_at;
    private String updated_at;
    private int promotion_level_id;


    public Promotions(int promotion_id, String promotionName, String description,
                      double discount_percentage, double discount_amount, String start_date,
                      String end_date, String status, String created_by, String updated_by, String created_at,
                      String updated_at, int promotion_level_id) {
        this.promotion_id = promotion_id;
        this.promotionName = promotionName;
        this.description = description;
        this.discount_percentage = discount_percentage;
        this.discount_amount = discount_amount;
        this.start_date = start_date;
        this.end_date = end_date;
        this.status = status;
        this.created_by = created_by;
        this.updated_by = updated_by;
        this.created_at = created_at;
        this.updated_at = updated_at;
        this.promotion_level_id = promotion_level_id;
    }

    public int getPromotion_id() {
        return promotion_id;
    }

    public void setPromotion_id(int promotion_id) {
        this.promotion_id = promotion_id;
    }

    public String getPromotionName() {
        return promotionName;
    }

    public void setPromotionName(String promotionName) {
        this.promotionName = promotionName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getDiscount_percentage() {
        return discount_percentage;
    }

    public void setDiscount_percentage(double discount_percentage) {
        this.discount_percentage = discount_percentage;
    }

    public double getDiscount_amount() {
        return discount_amount;
    }

    public void setDiscount_amount(double discount_amount) {
        this.discount_amount = discount_amount;
    }

    public String getStart_date() {
        return start_date;
    }

    public void setStart_date(String start_date) {
        this.start_date = start_date;
    }

    public String getEnd_date() {
        return end_date;
    }

    public void setEnd_date(String end_date) {
        this.end_date = end_date;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getCreated_by() {
        return created_by;
    }

    public void setCreated_by(String created_by) {
        this.created_by = created_by;
    }

    public String getUpdated_by() {
        return updated_by;
    }

    public void setUpdated_by(String updated_by) {
        this.updated_by = updated_by;
    }

    public String getCreated_at() {
        return created_at;
    }

    public void setCreated_at(String created_at) {
        this.created_at = created_at;
    }

    public String getUpdated_at() {
        return updated_at;
    }

    public void setUpdated_at(String updated_at) {
        this.updated_at = updated_at;
    }

    public int getPromotion_level_id() {
        return promotion_level_id;
    }

    public void setPromotion_level_id(int promotion_level_id) {
        this.promotion_level_id = promotion_level_id;
    }
}
