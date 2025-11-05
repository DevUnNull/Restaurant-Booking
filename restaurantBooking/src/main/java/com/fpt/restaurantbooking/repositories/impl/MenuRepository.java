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
        try(Connection con = db.getConnection(); PreparedStatement stm = con.prepareStatement(sql); ResultSet rs = stm.executeQuery();){
            while (rs.next()) {
                categoryList.add(new MenuCategory(rs.getInt("id"),rs.getString("name")));
            }
        }




        return categoryList;

    }
    public List<MenuItem> getMenuItemsAlk() throws SQLException {
        List<MenuItem> menuItemList = new ArrayList<>();
        String sql= " SELECT \n" +
                "    mi.item_id,\n" +
                "    mi.item_name,\n" +
                "    mi.item_code,\n" +
                "    mi.price,\n" +
                "    mi.status,\n" +
                "    mi.image_url,\n" +
                "    mi.description,\n" +
                "    mi.created_at,\n" +
                "    mi.updated_at,\n" +
                "    mi.category_id,\n" +
                "    mc.name AS category_name\n" +
                "FROM menu_items mi\n" +
                "JOIN menu_category mc ON mi.category_id = mc.id;  ";
        try(Connection con = db.getConnection(); PreparedStatement stm = con.prepareStatement(sql);) {


            try(ResultSet rs = stm.executeQuery();) {
                while (rs.next()) {
                    menuItemList.add(new MenuItem(rs.getInt("item_id"),rs.getString("item_name"),
                            rs.getString("item_code"), rs.getString("description"),
                            rs.getBigDecimal("price"), rs.getString("image_url"),
                            rs.getString("status"),

                            rs.getInt("category_id") ,rs.getString("category_name")));

                }
            }
        }



        return menuItemList;
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
                "    mi.category_id, \n" +
                "    c.name AS category_name,\n " +
                "    mi.calories,\n " +
                "    mi.status,\n " +
                "    u1.full_name AS created_by_name,\n " +
                "    u2.full_name AS updated_by_name,\n " +
                "    mi.created_at,\n " +
                "    mi.updated_at\n " +
                "FROM menu_items mi\n " +
                "LEFT JOIN menu_category c ON mi.category_id = c.id \n " +
                "LEFT JOIN users u1 ON mi.created_by = u1.user_id\n " +
                "LEFT JOIN users u2 ON mi.updated_by = u2.user_id\n " +
                "WHERE mi.category_id = ?\n " +
                "ORDER BY mi.item_id DESC\n " +
                "LIMIT ? ,?  ";
        try(Connection con = db.getConnection(); PreparedStatement stm = con.prepareStatement(sql);) {

            stm.setInt(1, id );
            stm.setInt(2, start );
            stm.setInt(3, end );
            try(ResultSet rs = stm.executeQuery();) {
                while (rs.next()) {
                    menuItemList.add(new MenuItem(rs.getInt("item_id"),rs.getString("item_name"),
                            rs.getString("item_code"), rs.getString("description"),
                            rs.getBigDecimal("price"), rs.getString("image_url"),
                            rs.getString("status"),
                            rs.getString("created_by_name"), rs.getString("updated_by_name"),
                            rs.getString("created_at"),rs.getString("updated_at"), rs.getString("category_name"), rs.getInt("category_id")));

                }
            }
        }



        return menuItemList;
    }

    public List<MenuItem> getMenuItemsSorted(int id, int start, int end, String sortDir) throws SQLException {
        String safeDir = ("DESC".equalsIgnoreCase(sortDir)) ? "DESC" : "ASC";
        List<MenuItem> menuItemList = new ArrayList<MenuItem>();
        String sql= " SELECT \n " +
                "    mi.item_id,\n " +
                "    mi.item_name,\n " +
                "    mi.item_code,\n " +
                "    mi.description,\n " +
                "    mi.price,\n " +
                "    mi.image_url,\n " +
                "    mi.category_id, \n" +
                "    c.name AS category_name,\n " +
                "    mi.calories,\n " +
                "    mi.status,\n " +
                "    u1.full_name AS created_by_name,\n " +
                "    u2.full_name AS updated_by_name,\n " +
                "    mi.created_at,\n " +
                "    mi.updated_at\n " +
                "FROM menu_items mi\n " +
                "LEFT JOIN menu_category c ON mi.category_id = c.id \n " +
                "LEFT JOIN users u1 ON mi.created_by = u1.user_id\n " +
                "LEFT JOIN users u2 ON mi.updated_by = u2.user_id\n " +
                "WHERE mi.category_id = ?\n " +
                "ORDER BY mi.price " + safeDir + "\n " +
                "LIMIT ? ,?  ";
        try(Connection con = db.getConnection(); PreparedStatement stm = con.prepareStatement(sql);) {
            stm.setInt(1, id );
            stm.setInt(2, start );
            stm.setInt(3, end );
            try(ResultSet rs = stm.executeQuery();) {
                while (rs.next()) {
                    menuItemList.add(new MenuItem(rs.getInt("item_id"),rs.getString("item_name"),
                            rs.getString("item_code"), rs.getString("description"),
                            rs.getBigDecimal("price"), rs.getString("image_url"),
                            rs.getString("status"),
                            rs.getString("created_by_name"), rs.getString("updated_by_name"),
                            rs.getString("created_at"),rs.getString("updated_at"), rs.getString("category_name"),rs.getInt("category_id")));
                }
            }
        }
        return menuItemList;
    }

    public List<MenuItem> getMenuItemsAll(int start, int end) throws SQLException {
        List<MenuItem> menuItemList = new ArrayList<MenuItem>();
        String sql = " SELECT \n " +
                "    mi.item_id,\n " +
                "    mi.item_name,\n " +
                "    mi.item_code,\n " +
                "    mi.description,\n " +
                "    mi.price,\n " +
                "    mi.image_url,\n " +
                "    mi.category_id, \n" +
                "    c.name AS category_name,\n " +
                "    mi.calories,\n " +
                "    mi.status,\n " +
                "    u1.full_name AS created_by_name,\n " +
                "    u2.full_name AS updated_by_name,\n " +
                "    mi.created_at,\n " +
                "    mi.updated_at\n " +
                "FROM menu_items mi\n " +
                "LEFT JOIN menu_category c ON mi.category_id = c.id \n " +
                "LEFT JOIN users u1 ON mi.created_by = u1.user_id\n " +
                "LEFT JOIN users u2 ON mi.updated_by = u2.user_id\n " +
                "ORDER BY mi.item_id DESC\n " +
                "LIMIT ? ,?  ";
        try (Connection con = db.getConnection(); PreparedStatement stm = con.prepareStatement(sql)) {
            stm.setInt(1, start);
            stm.setInt(2, end);
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    menuItemList.add(new MenuItem(rs.getInt("item_id"), rs.getString("item_name"),
                            rs.getString("item_code"), rs.getString("description"),
                            rs.getBigDecimal("price"), rs.getString("image_url"),
                            rs.getString("status"),
                            rs.getString("created_by_name"), rs.getString("updated_by_name"),
                            rs.getString("created_at"), rs.getString("updated_at"), rs.getString("category_name"), rs.getInt("category_id")));
                }
            }
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
                "    mi.category_id, \n" +
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

        try(Connection con = db.getConnection(); PreparedStatement stm = con.prepareStatement(sql);){
            stm.setInt(1, id );
            try(ResultSet rs = stm.executeQuery();) {
                while (rs.next()) {
                    menuItemList.add(new MenuItem(rs.getInt("item_id"),rs.getString("item_name"),
                            rs.getString("item_code"), rs.getString("description"),
                            rs.getBigDecimal("price"), rs.getString("image_url"),
                            rs.getString("status"),
                            rs.getString("created_by_name"), rs.getString("updated_by_name"),
                            rs.getString("created_at"),rs.getString("updated_at"),rs.getString("category_name"), rs.getInt("category_id") ));

                }
            }
        }



        return menuItemList;
    }

    public List<MenuItem> getAllMenuItemsAll() throws SQLException {
        List<MenuItem> menuItemList = new ArrayList<MenuItem>();
        String sql= " SELECT \n" +
                "    mi.item_id,\n" +
                "    mi.item_name,\n" +
                "    mi.item_code,\n" +
                "    mi.description,\n" +
                "    mi.price,\n" +
                "    mi.image_url,\n" +
                "    mi.category_id, \n" +
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
                "LEFT JOIN users u2 ON mi.updated_by = u2.user_id";

        try(Connection con = db.getConnection(); PreparedStatement stm = con.prepareStatement(sql); ResultSet rs = stm.executeQuery();){
            while (rs.next()) {
                menuItemList.add(new MenuItem(rs.getInt("item_id"),rs.getString("item_name"),
                        rs.getString("item_code"), rs.getString("description"),
                        rs.getBigDecimal("price"), rs.getString("image_url"),
                        rs.getString("status"),
                        rs.getString("created_by_name"), rs.getString("updated_by_name"),
                        rs.getString("created_at"),rs.getString("updated_at"),rs.getString("category_name"), rs.getInt("category_id") ));

            }
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
        try(Connection con = db.getConnection(); PreparedStatement stm = con.prepareStatement(sql); ) {

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
        try(Connection con = db.getConnection(); PreparedStatement stm = con.prepareStatement(sql); ResultSet rs = stm.executeQuery();)  {

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
        try(Connection con = db.getConnection(); PreparedStatement stm = con.prepareStatement(sql);) {
            stm.setInt(1, id);
            try(ResultSet rs = stm.executeQuery();) {
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
            }
        }





        return menuItem;
    }
    public void DeleteMenu(String id) throws SQLException {
        String sql = " DELETE FROM menu_items \n" +
                " WHERE item_id = ? ";

        try (Connection conn = db.getConnection();
             PreparedStatement stm = conn.prepareStatement(sql);
        ) {

            stm.setString(1, id);

            stm.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }


    }
    public void DeleteMenuItemInservice_menu_items(String id) throws SQLException {
        String sql = " DELETE FROM service_menu_items\n" +
                "WHERE item_id = ?; ";

        try (Connection conn = db.getConnection();
             PreparedStatement stm = conn.prepareStatement(sql);
        ) {

            stm.setString(1, id);

            stm.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }


    }

    public List<MenuItem> getMenuItemsAllSorted(int start, int end, String sortDir) throws SQLException {
        String safeDir = ("DESC".equalsIgnoreCase(sortDir)) ? "DESC" : "ASC";
        List<MenuItem> menuItemList = new ArrayList<MenuItem>();
        String sql = " SELECT \n " +
                "    mi.item_id,\n " +
                "    mi.item_name,\n " +
                "    mi.item_code,\n " +
                "    mi.description,\n " +
                "    mi.price,\n " +
                "    mi.image_url,\n " +
                "    mi.category_id, \n" +
                "    c.name AS category_name,\n " +
                "    mi.calories,\n " +
                "    mi.status,\n " +
                "    u1.full_name AS created_by_name,\n " +
                "    u2.full_name AS updated_by_name,\n " +
                "    mi.created_at,\n " +
                "    mi.updated_at\n " +
                "FROM menu_items mi\n " +
                "LEFT JOIN menu_category c ON mi.category_id = c.id \n " +
                "LEFT JOIN users u1 ON mi.created_by = u1.user_id\n " +
                "LEFT JOIN users u2 ON mi.updated_by = u2.user_id\n " +
                "ORDER BY mi.price " + safeDir + "\n " +
                "LIMIT ? ,?  ";
        try (Connection con = db.getConnection(); PreparedStatement stm = con.prepareStatement(sql)) {
            stm.setInt(1, start);
            stm.setInt(2, end);
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    menuItemList.add(new MenuItem(rs.getInt("item_id"), rs.getString("item_name"),
                            rs.getString("item_code"), rs.getString("description"),
                            rs.getBigDecimal("price"), rs.getString("image_url"),
                            rs.getString("status"),
                            rs.getString("created_by_name"), rs.getString("updated_by_name"),
                            rs.getString("created_at"), rs.getString("updated_at"), rs.getString("category_name"), rs.getInt("category_id")));
                }
            }
        }
        return menuItemList;
    }


}
