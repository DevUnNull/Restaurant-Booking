package com.fpt.restaurantbooking.repositories.impl;

import com.fpt.restaurantbooking.models.MenuItem;
import com.fpt.restaurantbooking.utils.DatabaseUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;

public class MenuItemDAO {

    private static final Logger logger = LoggerFactory.getLogger(MenuItemDAO.class);

    /**
     * Retrieves all active menu items from the database.
     *
     * @return A list of MenuItem objects.
     */
    public List<MenuItem> getAllActiveMenuItems() {
        List<MenuItem> menuItems = new ArrayList<>();
        // Chỉ lấy các món có status là 'ACTIVE'
        String sql = "SELECT item_id, item_name, item_code, description, price, image_url, category, calories, status " +
                "FROM Menu_Items WHERE status = 'ACTIVE'";

        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql);
             ResultSet resultSet = preparedStatement.executeQuery()) {

            while (resultSet.next()) {
                MenuItem item = new MenuItem();
                item.setItemId(resultSet.getInt("item_id"));
                item.setItemName(resultSet.getString("item_name"));
                item.setItemCode(resultSet.getString("item_code"));
                item.setDescription(resultSet.getString("description"));
                item.setPrice(resultSet.getBigDecimal("price"));
                item.setImageUrl(resultSet.getString("image_url"));
                item.setCategory(resultSet.getString("category"));
                item.setCalories(resultSet.getObject("calories", Integer.class)); // Dùng getObject cho Integer/null an toàn
                item.setStatus(resultSet.getString("status"));
                menuItems.add(item);
            }
        } catch (SQLException e) {
            logger.error("Error retrieving active menu items", e);
        }
        return menuItems;
    }

    /**
     * Retrieves a menu item by its ID.
     *
     * @param itemId The ID of the item.
     * @return The MenuItem object or null if not found.
     */
    public MenuItem getMenuItemById(int itemId) {
        String sql = "SELECT item_id, item_name, item_code, description, price, image_url, category, calories, status " +
                "FROM Menu_Items WHERE item_id = ? AND status = 'ACTIVE'";

        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setInt(1, itemId);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    MenuItem item = new MenuItem();
                    item.setItemId(resultSet.getInt("item_id"));
                    item.setItemName(resultSet.getString("item_name"));
                    item.setItemCode(resultSet.getString("item_code"));
                    item.setDescription(resultSet.getString("description"));
                    item.setPrice(resultSet.getBigDecimal("price"));
                    item.setImageUrl(resultSet.getString("image_url"));
                    item.setCategory(resultSet.getString("category"));
                    item.setCalories(resultSet.getObject("calories", Integer.class));
                    item.setStatus(resultSet.getString("status"));
                    return item;
                }
            }
        } catch (SQLException e) {
            logger.error("Error retrieving menu item by ID: " + itemId, e);
        }
        return null;
    }
}