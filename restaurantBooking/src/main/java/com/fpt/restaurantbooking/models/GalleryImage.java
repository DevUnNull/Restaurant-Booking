package com.fpt.restaurantbooking.models;

/**
 * GalleryImage entity representing gallery images
 */
public class GalleryImage extends BaseEntity {
    private Integer imageId;
    private String imageName;
    private String imageUrl;
    private String imageType;
    private String description;
    private String status;
    private Integer uploadedBy;

    public GalleryImage() {
        super();
        this.status = "ACTIVE";
    }

    // Getters and Setters
    public Integer getImageId() {
        return imageId;
    }

    public void setImageId(Integer imageId) {
        this.imageId = imageId;
    }

    public String getImageName() {
        return imageName;
    }

    public void setImageName(String imageName) {
        this.imageName = imageName;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getImageType() {
        return imageType;
    }

    public void setImageType(String imageType) {
        this.imageType = imageType;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getUploadedBy() {
        return uploadedBy;
    }

    public void setUploadedBy(Integer uploadedBy) {
        this.uploadedBy = uploadedBy;
    }
}