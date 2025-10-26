package com.fpt.restaurantbooking.models;

/**
 * User entity representing customers and staff
 */
public class User extends BaseEntity {
    private Integer userId;
    private Integer roleId;
    private String fullName;
    private String gender;
    private String email;
    private String phoneNumber;
    private String password;
    private String avatar;
    private String status;
    private String role;

    public User(int userId, String fullName) {
        this.userId = userId;
        this.fullName = fullName;
    }

    public User(Integer userId, Integer roleId, String fullName, String gender, String email, String phoneNumber, String status) {
        this.userId = userId;
        this.roleId = roleId;
        this.fullName = fullName;
        this.gender = gender;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.status = status;
    }

    public enum UserRole {
        CUSTOMER, STAFF, ADMIN
    }

    public User() {
        super();
        this.role = "CUSTOMER";
        this.status = "ACTIVE";
    }

    // Getters and Setters
    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Integer getRoleId() {
        return roleId;
    }

    public void setRoleId(Integer roleId) {
        this.roleId = roleId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }



    public boolean getIsActive() {
        return isActive();
    }


    public String toString() {
        return "User{" +
                "userId=" + userId +
                "Pass= "+ password +
                ", roleId=" + roleId +
                ", fullName='" + fullName + '\'' +
                ", email='" + email + '\'' +
                ", phoneNumber='" + phoneNumber + '\'' +
                ", avatar='" + avatar + '\'' +
                ", status='" + status + '\'' +
                ", role='" + role + '\'' +
                '}';
    }


}