package com.fpt.restaurantbooking.models;

import java.math.BigDecimal;

/**
 * MenuItem entity representing menu items
 */
public class MenuItem extends BaseEntity {
    private Integer itemId;
    private String itemName;
    private String itemCode;
    private String description;
    private BigDecimal price;
    private String imageUrl;
    private int category_id;
    private Integer calories;
    private String status;
    private String created_By;
    private String updated_By;
    private String created_At;
    private String updated_At;
    private String category_name;

    public MenuItem() {
        super();
        this.status = "ACTIVE";
    }
    public MenuItem(Integer itemId, String itemName, String itemCode, String description, BigDecimal price, String imageUrl,
                    String status, String created_By, String updated_By, String created_At, String updated_At, String category_name) {
        this.itemId = itemId;
        this.itemName = itemName;
        this.itemCode = itemCode;
        this.description = description;
        this.price = price;
        this.imageUrl = imageUrl;
        this.status = status;
        this.created_By = created_By;
        this.updated_By = updated_By;
        this.created_At = created_At;
        this.updated_At = updated_At;
        this.category_name = category_name;
    }
    public MenuItem(Integer itemId, String itemName, String itemCode, String description, BigDecimal price, String imageUrl,
                    String status, String created_By, String updated_By, String created_At, String updated_At, int category_id) {
        this.itemId = itemId;
        this.itemName = itemName;
        this.itemCode = itemCode;
        this.description = description;
        this.price = price;
        this.imageUrl = imageUrl;
        this.status = status;
        this.created_By = created_By;
        this.updated_By = updated_By;
        this.created_At = created_At;
        this.updated_At = updated_At;
        this.category_id = category_id;
    }


    // Getters and Setters


    public String getCreated_By() {
        return created_By;
    }

    public void setCreated_By(String created_By) {
        this.created_By = created_By;
    }
    public String getCategory_name() {
        return category_name;
    }

    public void setCategory_name(String category_name) {
        this.category_name = category_name;
    }
    public String getUpdated_By() {
        return updated_By;
    }

    public void setUpdated_By(String updated_By) {
        this.updated_By = updated_By;
    }
    public String getCreated_At() {
        return created_At;
    }

    public void setCreated_At(String created_At) {
        this.created_At = created_At;
    }
    public String getUpdated_At() {
        return updated_At;
    }

    public void setUpdated_At(String updated_At) {
        this.updated_At = updated_At;
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

    public String getItemCode() {
        return itemCode;
    }

    public void setItemCode(String itemCode) {
        this.itemCode = itemCode;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public int getCategory() {
        return category_id;
    }

    public void setCategory(int category_id) {
        this.category_id = category_id;
    }

    public Integer getCalories() {
        return calories;
    }

    public void setCalories(Integer calories) {
        this.calories = calories;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}