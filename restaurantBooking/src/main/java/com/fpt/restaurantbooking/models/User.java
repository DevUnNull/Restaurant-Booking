package com.fpt.restaurantbooking.models;

import java.time.LocalDate;

/**
 * User entity representing customers and staff
 */
public class User extends BaseEntity {
    private Integer userId;
    private Integer roleId;
    private String fullName;
    private String email;
    private String phoneNumber;
    private String password;
    private String avatar;
    private String status;
    private String role;
    private LocalDate dateOfBirth;
    private String gender;

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
    public LocalDate getDateOfBirth() {
        return dateOfBirth;
    }
    public void setDateOfBirth(LocalDate dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }
    public String getGender() {
        return gender;
    }
    public void setGender(String gender) {
        this.gender = gender;
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