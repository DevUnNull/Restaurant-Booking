package com.fpt.restaurantbooking.models;

/**
 * SystemSetting entity representing system settings
 */
public class SystemSetting extends BaseEntity {
    private Integer settingId;
    private String settingKey;
    private String settingValue;
    private String description;
    private String dataType;
    private String status;

    public SystemSetting() {
        super();
        this.status = "ACTIVE";
    }

    // Getters and Setters
    public Integer getSettingId() {
        return settingId;
    }

    public void setSettingId(Integer settingId) {
        this.settingId = settingId;
    }

    public String getSettingKey() {
        return settingKey;
    }

    public void setSettingKey(String settingKey) {
        this.settingKey = settingKey;
    }

    public String getSettingValue() {
        return settingValue;
    }

    public void setSettingValue(String settingValue) {
        this.settingValue = settingValue;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getDataType() {
        return dataType;
    }

    public void setDataType(String dataType) {
        this.dataType = dataType;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}