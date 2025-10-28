package com.fpt.restaurantbooking.repositories.impl;

import com.fpt.restaurantbooking.models.MenuItem;
import com.fpt.restaurantbooking.utils.DatabaseUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MenuItemDAO {
    private static final Logger logger = LoggerFactory.getLogger(MenuItemDAO.class);

    // Get menu item by ID
    public MenuItem getMenuItemById(int itemId) {
        String sql = "SELECT mi.*, mc.name AS category_name, u1.full_name AS created_by_name, u2.full_name AS updated_by_name " +
                "FROM Menu_Items mi " +
                "LEFT JOIN menu_category mc ON mi.category_id = mc.id " +
                "LEFT JOIN Users u1 ON mi.created_by = u1.user_id " +
                "LEFT JOIN Users u2 ON mi.updated_by = u2.user_id " +
                "WHERE mi.item_id = ? AND mi.status = 'AVAILABLE'";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, itemId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToMenuItem(rs);
                }
            }
        } catch (SQLException e) {
            logger.error("Error getting menu item by ID: " + itemId, e);
        }
        return null;
    }

    // Get all available menu items
    public List<MenuItem> getAllAvailableMenuItems() {
        String sql = "SELECT mi.*, mc.name AS category_name, u1.full_name AS created_by_name, u2.full_name AS updated_by_name " +
                "FROM Menu_Items mi " +
                "LEFT JOIN menu_category mc ON mi.category_id = mc.id " +
                "LEFT JOIN Users u1 ON mi.created_by = u1.user_id " +
                "LEFT JOIN Users u2 ON mi.updated_by = u2.user_id " +
                "WHERE mi.status = 'AVAILABLE' ORDER BY mc.name, mi.item_name ASC";
        List<MenuItem> items = new ArrayList<>();

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    items.add(mapResultSetToMenuItem(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error getting all available menu items", e);
        }
        return items;
    }

    // Get menu items by category
    public List<MenuItem> getMenuItemsByCategory(String category) {
        String sql = "SELECT mi.*, mc.name AS category_name, u1.full_name AS created_by_name, u2.full_name AS updated_by_name " +
                "FROM Menu_Items mi " +
                "LEFT JOIN menu_category mc ON mi.category_id = mc.id " +
                "LEFT JOIN Users u1 ON mi.created_by = u1.user_id " +
                "LEFT JOIN Users u2 ON mi.updated_by = u2.user_id " +
                "WHERE mc.name = ? AND mi.status = 'AVAILABLE' ORDER BY mi.item_name ASC";
        List<MenuItem> items = new ArrayList<>();

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, category);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    items.add(mapResultSetToMenuItem(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error getting menu items by category: " + category, e);
        }
        return items;
    }

    // Search menu items
    public List<MenuItem> searchMenuItems(String keyword) {
        String sql = "SELECT mi.*, mc.name AS category_name, u1.full_name AS created_by_name, u2.full_name AS updated_by_name " +
                "FROM Menu_Items mi " +
                "LEFT JOIN menu_category mc ON mi.category_id = mc.id " +
                "LEFT JOIN Users u1 ON mi.created_by = u1.user_id " +
                "LEFT JOIN Users u2 ON mi.updated_by = u2.user_id " +
                "WHERE (mi.item_name LIKE ? OR mi.description LIKE ?) AND mi.status = 'AVAILABLE' ORDER BY mi.item_name ASC";
        List<MenuItem> items = new ArrayList<>();

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            String searchPattern = "%" + keyword + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    items.add(mapResultSetToMenuItem(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error searching menu items", e);
        }
        return items;
    }

    // Get menu categories
    public List<String> getMenuCategories() {
        String sql = "SELECT name FROM menu_category ORDER BY name ASC";
        List<String> categories = new ArrayList<>();

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    categories.add(rs.getString("name"));
                }
            }
        } catch (SQLException e) {
            logger.error("Error getting menu categories", e);
        }
        return categories;
    }

    // Get menu items by service ID
    public List<MenuItem> getMenuItemsByServiceId(int serviceId) {
        String sql = "SELECT mi.*, mc.name AS category_name, u1.full_name AS created_by_name, u2.full_name AS updated_by_name " +
                "FROM Menu_Items mi " +
                "INNER JOIN service_menu_items smi ON mi.item_id = smi.item_id " +
                "LEFT JOIN menu_category mc ON mi.category_id = mc.id " +
                "LEFT JOIN Users u1 ON mi.created_by = u1.user_id " +
                "LEFT JOIN Users u2 ON mi.updated_by = u2.user_id " +
                "WHERE smi.service_id = ? AND mi.status = 'AVAILABLE' ORDER BY mc.name, mi.item_name ASC";
        List<MenuItem> items = new ArrayList<>();

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, serviceId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    items.add(mapResultSetToMenuItem(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error getting menu items by service ID: " + serviceId, e);
        }
        return items;
    }

    private MenuItem mapResultSetToMenuItem(ResultSet rs) throws SQLException {
        MenuItem item = new MenuItem();
        item.setItemId(rs.getInt("item_id"));
        item.setItemName(rs.getString("item_name"));
        item.setItemCode(rs.getString("item_code"));
        item.setDescription(rs.getString("description"));
        item.setPrice(rs.getBigDecimal("price"));
        item.setImageUrl(rs.getString("image_url"));
        item.setCategory(rs.getInt("category_id"));
        item.setCalories(rs.getInt("calories"));
        item.setStatus(rs.getString("status"));
        item.setCreated_By(rs.getString("created_by_name"));
        item.setUpdated_By(rs.getString("updated_by_name"));
        item.setCreated_At(rs.getString("created_at"));
        item.setUpdated_At(rs.getString("updated_at"));
        item.setCategory_name(rs.getString("category_name"));
        return item;
    }
}