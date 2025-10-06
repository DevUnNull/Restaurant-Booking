package com.fpt.restaurantbooking.repositories.impl;

import com.fpt.restaurantbooking.models.MenuItem;
import com.fpt.restaurantbooking.repositories.MenuItemRepository;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * Implementation of MenuItemRepository interface
 */
public class MenuItemRepositoryImpl implements MenuItemRepository {
    
    private Connection connection;
    
    public MenuItemRepositoryImpl(Connection connection) {
        this.connection = connection;
    }
    
    @Override
    public MenuItem save(MenuItem menuItem) {
        String sql = "INSERT INTO menu_items (item_name, item_code, description, price, image_url, category, calories, status, created_by, updated_by, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, menuItem.getItemName());
            stmt.setString(2, menuItem.getItemCode());
            stmt.setString(3, menuItem.getDescription());
            stmt.setBigDecimal(4, menuItem.getPrice());
            stmt.setString(5, menuItem.getImageUrl());
            stmt.setString(6, menuItem.getCategory());
            stmt.setInt(7, menuItem.getCalories());
            stmt.setString(8, menuItem.getStatus());
            stmt.setInt(9, 1); // created_by - default to admin
            stmt.setInt(10, 1); // updated_by - default to admin
            stmt.setTimestamp(11, Timestamp.valueOf(menuItem.getCreatedAt()));
            stmt.setTimestamp(12, Timestamp.valueOf(menuItem.getUpdatedAt()));
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        menuItem.setItemId(generatedKeys.getInt(1));
                    }
                }
            }
            return menuItem;
        } catch (SQLException e) {
            throw new RuntimeException("Error saving menu item", e);
        }
    }
    
    @Override
    public MenuItem update(MenuItem menuItem) {
        String sql = "UPDATE menu_items SET item_name = ?, item_code = ?, description = ?, price = ?, image_url = ?, category = ?, calories = ?, status = ?, updated_by = ?, updated_at = ? WHERE item_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, menuItem.getItemName());
            stmt.setString(2, menuItem.getItemCode());
            stmt.setString(3, menuItem.getDescription());
            stmt.setBigDecimal(4, menuItem.getPrice());
            stmt.setString(5, menuItem.getImageUrl());
            stmt.setString(6, menuItem.getCategory());
            stmt.setInt(7, menuItem.getCalories());
            stmt.setString(8, menuItem.getStatus());
            stmt.setInt(9, 1); // updated_by - default to admin
            stmt.setTimestamp(10, Timestamp.valueOf(menuItem.getUpdatedAt()));
            stmt.setInt(11, menuItem.getItemId());
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0 ? menuItem : null;
        } catch (SQLException e) {
            throw new RuntimeException("Error updating menu item", e);
        }
    }
    
    @Override
    public Optional<MenuItem> findById(Long id) {
        String sql = "SELECT * FROM menu_items WHERE item_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToMenuItem(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding menu item by id", e);
        }
        
        return Optional.empty();
    }
    
    @Override
    public List<MenuItem> findFeaturedItems() {
        String sql = "SELECT * FROM menu_items WHERE status = 'ACTIVE'  ORDER BY item_id DESC LIMIT 6";
        List<MenuItem> menuItems = new ArrayList<>();
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    menuItems.add(mapResultSetToMenuItem(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding featured menu items", e);
        }
        
        return menuItems;
    }
    
    @Override
    public List<MenuItem> findActiveItems() {
        String sql = "SELECT * FROM menu_items WHERE status = 'ACTIVE' ORDER BY item_id DESC";
        List<MenuItem> menuItems = new ArrayList<>();
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    menuItems.add(mapResultSetToMenuItem(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding active menu items", e);
        }
        
        return menuItems;
    }
    
    @Override
    public List<MenuItem> findByCategory(String category) {
        String sql = "SELECT * FROM menu_items WHERE category = ? AND status = 'ACTIVE' ORDER BY item_id DESC";
        List<MenuItem> menuItems = new ArrayList<>();
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, category);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    menuItems.add(mapResultSetToMenuItem(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding menu items by category", e);
        }
        
        return menuItems;
    }
    
    @Override
    public List<MenuItem> findByStatus(String status) {
        String sql = "SELECT * FROM menu_items WHERE status = ? ORDER BY item_id DESC";
        List<MenuItem> menuItems = new ArrayList<>();
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, status);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    menuItems.add(mapResultSetToMenuItem(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding menu items by status", e);
        }
        
        return menuItems;
    }
    
    @Override
    public List<MenuItem> findAll() {
        String sql = "SELECT * FROM menu_items ORDER BY item_id DESC";
        List<MenuItem> menuItems = new ArrayList<>();
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    menuItems.add(mapResultSetToMenuItem(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding all menu items", e);
        }
        
        return menuItems;
    }
    
    @Override
    public List<MenuItem> findAllActive() {
        return findActiveItems();
    }
    
    @Override
    public boolean deleteById(Long id) {
        String sql = "DELETE FROM menu_items WHERE item_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error deleting menu item", e);
        }
    }
    
    @Override
    public boolean softDeleteById(Long id) {
        String sql = "UPDATE menu_items SET status = 'INACTIVE' WHERE item_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error soft deleting menu item", e);
        }
    }
    
    @Override
    public boolean existsById(Long id) {
        String sql = "SELECT COUNT(*) FROM menu_items WHERE item_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error checking menu item existence", e);
        }
        
        return false;
    }
    
    @Override
    public long count() {
        String sql = "SELECT COUNT(*) FROM menu_items";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getLong(1);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error counting menu items", e);
        }
        
        return 0;
    }
    
    @Override
    public long countActive() {
        String sql = "SELECT COUNT(*) FROM menu_items WHERE status = 'ACTIVE'";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getLong(1);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error counting active menu items", e);
        }
        
        return 0;
    }
    
    private MenuItem mapResultSetToMenuItem(ResultSet rs) throws SQLException {
        MenuItem menuItem = new MenuItem();
        menuItem.setItemId(rs.getInt("item_id"));
        menuItem.setItemName(rs.getString("item_name"));
        menuItem.setItemCode(rs.getString("item_code"));
        menuItem.setDescription(rs.getString("description"));
        menuItem.setPrice(rs.getBigDecimal("price"));
        menuItem.setImageUrl(rs.getString("image_url"));
        menuItem.setCategory(rs.getString("category"));
        menuItem.setCalories(rs.getInt("calories"));
        menuItem.setStatus(rs.getString("status"));
        menuItem.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        menuItem.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
        return menuItem;
    }
}