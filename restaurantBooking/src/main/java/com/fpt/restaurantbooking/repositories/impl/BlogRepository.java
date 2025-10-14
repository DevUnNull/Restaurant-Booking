/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.fpt.restaurantbooking.repositories.impl;


import com.fpt.restaurantbooking.models.Blog;
import com.fpt.restaurantbooking.utils.DatabaseUtil;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Quandxnunxi28
 */
public class BlogRepository {
     PreparedStatement stm;
    ResultSet rs;
    DatabaseUtil db = new DatabaseUtil();
    
    public List<Blog> getAllBlog(){
        List<Blog> list = new ArrayList<>();
        String query= "select * from BlogCategories ";
        try {
            stm = db.getConnection().prepareStatement(query);
            rs = stm.executeQuery();
            while (rs.next()) {
                list.add(new Blog(rs.getInt("id"), rs.getString("name"), rs.getString("img_url"), rs.getString("description"), rs.getString("created_date")));
            }
        } catch (Exception e) {
        }
         return list;
        
    }
    public List<Blog> getBlog_byCategory(int category_id){
        List<Blog> list = new ArrayList<>();
        String query= " SELECT\n" +
                "    p.id,\n" +
                "    p.title,\n" +
                "    p.slug,\n" +
                "    p.content,\n" +
                "    p.thumbnail,\n" +
                "    p.category_id,\n" +
                "    c.name AS category_name,\n " +
                "    p.created_at,\n " +
                "    p.created_by\n " +
                " FROM posts p\n "  +
                "         JOIN blogcategories c ON p.category_id = c.id\n" +
                " WHERE p.category_id = ? ";
        try {
            stm = db.getConnection().prepareStatement(query);
            stm.setInt(1, category_id);
            rs = stm.executeQuery();
            while (rs.next()) {
                list.add(new Blog(rs.getInt("id"), rs.getString("title"), rs.getString("thumbnail"), rs.getString("content"), rs.getString("created_by"), rs.getString("created_at"), rs.getString("category_name"), rs.getInt("category_id")));
            }
        } catch (Exception e) {
        }
        return list;

    }
}
