package com.fpt.restaurantbooking.repositories.impl;

import com.fpt.restaurantbooking.models.MenuCategory;
import com.fpt.restaurantbooking.models.MenuItem;
import com.fpt.restaurantbooking.models.Promotions;
import com.fpt.restaurantbooking.utils.DatabaseUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class MenuRepository {
    PreparedStatement stm;
    ResultSet rs;
    DatabaseUtil db = new DatabaseUtil();
 public List<MenuCategory> getCateGory() throws SQLException {
     List<MenuCategory> categoryList = new ArrayList<MenuCategory>();
     String sql= " select * from menu_category  ";
     stm = db.getConnection().prepareStatement(sql);

     rs = stm.executeQuery();
     while (rs.next()) {
         categoryList.add(new MenuCategory(rs.getInt("id"),rs.getString("name")));
     }
     return categoryList;

 }

 public List<MenuItem> getMenuItems(int id, int start, int end) throws SQLException {
     List<MenuItem> menuItemList = new ArrayList<MenuItem>();
     String sql= " SELECT \n " +
             "    mi.item_id,\n " +
             "    mi.item_name,\n " +
             "    mi.item_code,\n " +
             "    mi.description,\n " +
             "    mi.price,\n " +
             "    mi.image_url,\n " +
             "    c.name AS category_name,\n " +
             "    mi.calories,\n " +
             "    mi.status,\n " +
             "    u1.full_name AS created_by_name,\n " +
             "    u2.full_name AS updated_by_name,\n " +
             "    mi.created_at,\n " +
             "    mi.updated_at\n " +
             "FROM menu_items mi\n " +
             "LEFT JOIN menu_category c ON mi.category_id = c.id\n " +
             "LEFT JOIN users u1 ON mi.created_by = u1.user_id\n " +
             "LEFT JOIN users u2 ON mi.updated_by = u2.user_id\n " +
             "WHERE mi.category_id = ?\n " +
             "ORDER BY mi.item_id DESC\n " +
             "LIMIT ? ,?  ";
     stm = db.getConnection().prepareStatement(sql);
stm.setInt(1, id );
stm.setInt(2, start );
stm.setInt(3, end );
     rs = stm.executeQuery();
     while (rs.next()) {
         menuItemList.add(new MenuItem(rs.getInt("item_id"),rs.getString("item_name"),
                 rs.getString("item_code"), rs.getString("description"),
                 rs.getBigDecimal("price"), rs.getString("image_url"),
                 rs.getString("status"),
                 rs.getString("created_by_name"), rs.getString("updated_by_name"),
                 rs.getString("created_at"),rs.getString("updated_at"), rs.getString("category_name")));

     }
     return menuItemList;
 }
    public List<MenuItem> getAllMenuItems(int id) throws SQLException {
        List<MenuItem> menuItemList = new ArrayList<MenuItem>();
        String sql= " SELECT \n" +
                "    mi.item_id,\n" +
                "    mi.item_name,\n" +
                "    mi.item_code,\n" +
                "    mi.description,\n" +
                "    mi.price,\n" +
                "    mi.image_url,\n" +
                "    c.name AS category_name,\n" +
                "    mi.calories,\n" +
                "    mi.status,\n" +
                "    u1.full_name AS created_by_name,\n" +
                "    u2.full_name AS updated_by_name,\n" +
                "    mi.created_at,\n" +
                "    mi.updated_at\n" +
                "FROM menu_items mi\n" +
                "LEFT JOIN menu_category c ON mi.category_id = c.id\n" +
                "LEFT JOIN users u1 ON mi.created_by = u1.user_id\n" +
                "LEFT JOIN users u2 ON mi.updated_by = u2.user_id\n" +
                "WHERE mi.category_id = ? ";
        stm = db.getConnection().prepareStatement(sql);
        stm.setInt(1, id );
        rs = stm.executeQuery();
        while (rs.next()) {
            menuItemList.add(new MenuItem(rs.getInt("item_id"),rs.getString("item_name"),
                    rs.getString("item_code"), rs.getString("description"),
                    rs.getBigDecimal("price"), rs.getString("image_url"),
                    rs.getString("status"),
                    rs.getString("created_by_name"), rs.getString("updated_by_name"),
                    rs.getString("created_at"),rs.getString("updated_at"),rs.getString("category_name") ));

        }
        return menuItemList;
    }
    public void addMenu(String name,String code, String description, String price, String category_id, String status, String created_by, String img_url) throws SQLException {
        String sql = " INSERT INTO Menu_Items \n" +
                "               (item_name, item_code, description, price, image_url, category_id, status, created_by, created_at) \n" +
                "               VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW()) " ;
        try (Connection con = db.getConnection(); PreparedStatement stm = con.prepareStatement(sql)) {

            stm.setString(1, name);
            stm.setString(2, code);
            stm.setString(3, description);
            stm.setString(4, price);
            stm.setString(5, img_url);
            stm.setString(6, category_id);
            stm.setString(7, status);
            stm.setString(8, created_by);



            stm.executeUpdate();
        } catch (SQLException e) {
            throw e;
        }
    }
    public void UpdateMenu(String id, String name,  String description, String price, String image_url, String updated_by, String status, String category_id ) throws SQLException {
        String sql= " UPDATE Menu_Items SET  \n" +
                "               item_name = ?,  \n" +
                "               description = ?,  \n" +
                "               price = ?,  \n" +
                "               image_url = ?,  \n" +
                "               updated_by = ?,  \n" +
                "               status = ?,  \n" +
                "  category_id = ?, \n" +
                "               updated_at = NOW()  \n" +
                "               WHERE item_id = ?" ;
        try {
            stm= db.getConnection().prepareStatement(sql);
            stm.setString(1, name);

            stm.setString(2, description);
            stm.setString(3, price);
            stm.setString(4, image_url);
            stm.setString(5, updated_by);
            stm.setString(6, status);
            stm.setString(7, category_id);
            stm.setString(8, id);
            stm.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }


    }
    public void UpdateMenu(String id, String name, String description, String price, String updated_by, String status, String category_id ) throws SQLException {
        String sql= " UPDATE Menu_Items SET  \n" +
                "               item_name = ?,  \n" +
                "               description = ?,  \n" +
                "               price = ?,  \n" +
                "               updated_by = ?,  \n" +
                "               status = ?,  \n" +
                "  category_id = ?, \n" +
                "               updated_at = NOW()  \n" +
                "               WHERE item_id = ?" ;
        try {
            stm= db.getConnection().prepareStatement(sql);
            stm.setString(1, name);

            stm.setString(2, description);
            stm.setString(3, price);

            stm.setString(4, updated_by);
            stm.setString(5, status);
            stm.setString(6, category_id);
            stm.setString(7, id);
            stm.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }


    }
    public MenuItem getIdWithUpdate(int id) throws SQLException {
        MenuItem menuItem = null;
        String sql= " select * from menu_items where item_id = ?  ";
        stm = db.getConnection().prepareStatement(sql);
        stm.setInt(1, id);
        rs = stm.executeQuery();
        if (rs.next()) {
            menuItem = new MenuItem(
                    rs.getInt("item_id"),
                    rs.getString("item_name"),
                    rs.getString("item_code"),
                    rs.getString("description"),
                    rs.getBigDecimal("price"),
                    rs.getString("image_url"),
                    rs.getString("status"),
                    rs.getString("created_by"),
                    rs.getString("updated_by"),
                    rs.getString("created_at"),
                    rs.getString("updated_at"),

                    rs.getInt("category_id")
            );
        }
        rs.close();
        stm.close();
        return menuItem;
    }

}
