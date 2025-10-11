/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.fpt.restaurantbooking.models;


public class Blog {
    private int id;
    private String nameCategoryBlog;
    private String description;
    private String imgUrl;
    private String createdDate;
    private String createdBy;
    private int idBlogSingle;
    private String titleBlogSingle;
    private String contentBlogSingle;
    private String thumbnailBlogSingle;
    private String createdAtBlogSingle;

    public Blog(int id, String nameCategoryBlog, String imgUrl, String description, String createdDate) {
        this.id = id;
        this.nameCategoryBlog = nameCategoryBlog;
        this.imgUrl = imgUrl;
        this.description = description;
        this.createdDate = createdDate;
    }
    public Blog(int idBlogSingle, String titleBlogSingle, String imgUrl, String contentBlogSingle, String createdBy, String createdDate, String nameCategoryBlog, int id ) {
        this.idBlogSingle = idBlogSingle;
        this.titleBlogSingle = titleBlogSingle;
        this.imgUrl = imgUrl;
        this.contentBlogSingle = contentBlogSingle;
        this.createdDate = createdDate;
        this.createdBy = createdBy;
        this.nameCategoryBlog = nameCategoryBlog;
        this.id = id;
    }

    public String getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(String createdBy) {
        this.createdBy = createdBy;
    }
    public String getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(String createdDate) {
        this.createdDate = createdDate;
    }
    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNameCategoryBlog() {
        return nameCategoryBlog;
    }

    public void setNameCategoryBlog(String nameCategoryBlog) {
        this.nameCategoryBlog = nameCategoryBlog;
    }

    public String getImgUrl() {
        return imgUrl;
    }

    public void setImgUrl(String imgUrl) {
        this.imgUrl = imgUrl;
    }

    public int getIdBlogSingle() {
        return idBlogSingle;
    }

    public void setIdBlogSingle(int idBlogSingle) {
        this.idBlogSingle = idBlogSingle;
    }

    public String getTitleBlogSingle() {
        return titleBlogSingle;
    }

    public void setTitleBlogSingle(String titleBlogSingle) {
        this.titleBlogSingle = titleBlogSingle;
    }

    public String getContentBlogSingle() {
        return contentBlogSingle;
    }

    public void setContentBlogSingle(String contentBlogSingle) {
        this.contentBlogSingle = contentBlogSingle;
    }

    public String getThumbnailBlogSingle() {
        return thumbnailBlogSingle;
    }

    public void setThumbnailBlogSingle(String thumbnailBlogSingle) {
        this.thumbnailBlogSingle = thumbnailBlogSingle;
    }

    public String getCreatedAtBlogSingle() {
        return createdAtBlogSingle;
    }

    public void setCreatedAtBlogSingle(String createdAtBlogSingle) {
        this.createdAtBlogSingle = createdAtBlogSingle;
    }
    
    
}
