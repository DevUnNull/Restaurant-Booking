package com.fpt.restaurantbooking.models;

public class MenuCategory {
    private int id_menuCategory;
    private String categoryName;
    public MenuCategory(int id_menuCategory, String categoryName) {
        this.id_menuCategory = id_menuCategory;
        this.categoryName = categoryName;
    }
    public int getId_menuCategory() {
        return id_menuCategory;
    }
    public void setId_menuCategory(int id_menuCategory) {
        this.id_menuCategory = id_menuCategory;
    }
    public String getCategoryName() {
        return categoryName;
    }
    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }
}
