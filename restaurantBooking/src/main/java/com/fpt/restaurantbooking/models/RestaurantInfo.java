package com.fpt.restaurantbooking.models;

public class RestaurantInfo {
    private int infoId;
    private String restaurantName;
    private String address;
    private String contactPhone;
    private String email;
    private String description;
    private String openHours;

    public int getInfoId() { return infoId; }
    public void setInfoId(int infoId) { this.infoId = infoId; }
    public String getRestaurantName() { return restaurantName; }
    public void setRestaurantName(String restaurantName) { this.restaurantName = restaurantName; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public String getContactPhone() { return contactPhone; }
    public void setContactPhone(String contactPhone) { this.contactPhone = contactPhone; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getOpenHours() { return openHours; }
    public void setOpenHours(String openHours) { this.openHours = openHours; }
}