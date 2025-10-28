package com.fpt.restaurantbooking.repositories.impl;

import com.fpt.restaurantbooking.models.OrderItem;
import com.fpt.restaurantbooking.utils.DatabaseUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;

public class OrderItemDAO {
    private static final Logger logger = LoggerFactory.getLogger(OrderItemDAO.class);

    // Add order item
    public int addOrderItem(OrderItem orderItem) {
        String sql = "INSERT INTO Order_Items (reservation_id, item_id, quantity, unit_price, special_instructions, status, created_at) VALUES (?, ?, ?, ?, ?, ?, NOW())";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setInt(1, orderItem.getReservationId());
            pstmt.setInt(2, orderItem.getItemId());
            pstmt.setInt(3, orderItem.getQuantity());
            pstmt.setBigDecimal(4, orderItem.getUnitPrice());
            pstmt.setString(5, orderItem.getSpecialInstructions());
            pstmt.setString(6, orderItem.getStatus());

            int affectedRows = pstmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = pstmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            logger.error("Error adding order item", e);
        }
        return -1;
    }

    // Get order items by reservation ID
    public List<OrderItem> getOrderItemsByReservationId(int reservationId) {
        String sql = "SELECT * FROM Order_Items WHERE reservation_id = ? ORDER BY created_at ASC";
        List<OrderItem> items = new ArrayList<>();

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, reservationId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    items.add(mapResultSetToOrderItem(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error getting order items", e);
        }
        return items;
    }

    // Get order item by ID
    public OrderItem getOrderItemById(int orderItemId) {
        String sql = "SELECT * FROM Order_Items WHERE order_item_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, orderItemId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToOrderItem(rs);
                }
            }
        } catch (SQLException e) {
            logger.error("Error getting order item by ID", e);
        }
        return null;
    }

    // Update order item quantity
    public boolean updateOrderItemQuantity(int orderItemId, int quantity) {
        if (quantity <= 0) {
            return deleteOrderItem(orderItemId);
        }

        String sql = "UPDATE Order_Items SET quantity = ? WHERE order_item_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, quantity);
            pstmt.setInt(2, orderItemId);

            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            logger.error("Error updating order item quantity", e);
        }
        return false;
    }

    // Update order item status
    public boolean updateOrderItemStatus(int orderItemId, String status) {
        String sql = "UPDATE Order_Items SET status = ? WHERE order_item_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, status);
            pstmt.setInt(2, orderItemId);

            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            logger.error("Error updating order item status", e);
        }
        return false;
    }

    // Delete order item
    public boolean deleteOrderItem(int orderItemId) {
        String sql = "DELETE FROM Order_Items WHERE order_item_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, orderItemId);
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            logger.error("Error deleting order item", e);
        }
        return false;
    }

    // Delete all order items for reservation (when cancelling)
    public boolean deleteAllOrderItemsForReservation(int reservationId) {
        String sql = "DELETE FROM Order_Items WHERE reservation_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, reservationId);
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            logger.error("Error deleting order items for reservation", e);
        }
        return false;
    }

    // Upsert all order items for a reservation: remove existing and insert new
    public boolean replaceOrderItemsForReservation(int reservationId, List<OrderItem> newItems) {
        try (Connection conn = DatabaseUtil.getConnection()) {
            conn.setAutoCommit(false);

            try (PreparedStatement deleteStmt = conn.prepareStatement("DELETE FROM Order_Items WHERE reservation_id = ?")) {
                deleteStmt.setInt(1, reservationId);
                deleteStmt.executeUpdate();
            }

            if (newItems != null) {
                try (PreparedStatement insertStmt = conn.prepareStatement(
                        "INSERT INTO Order_Items (reservation_id, item_id, quantity, unit_price, special_instructions, status, created_at) VALUES (?, ?, ?, ?, ?, ?, NOW())")) {
                    for (OrderItem item : newItems) {
                        insertStmt.setInt(1, reservationId);
                        insertStmt.setInt(2, item.getItemId());
                        insertStmt.setInt(3, item.getQuantity());
                        insertStmt.setBigDecimal(4, item.getUnitPrice());
                        insertStmt.setString(5, item.getSpecialInstructions());
                        insertStmt.setString(6, item.getStatus());
                        insertStmt.addBatch();
                    }
                    insertStmt.executeBatch();
                }
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            logger.error("Error replacing order items for reservation", e);
        }
        return false;
    }

    // Calculate total price for reservation
    public BigDecimal calculateTotalPrice(int reservationId) {
        String sql = "SELECT SUM(quantity * unit_price) as total FROM Order_Items WHERE reservation_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, reservationId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    BigDecimal total = rs.getBigDecimal("total");
                    return total != null ? total : BigDecimal.ZERO;
                }
            }
        } catch (SQLException e) {
            logger.error("Error calculating total price", e);
        }
        return BigDecimal.ZERO;
    }

    private OrderItem mapResultSetToOrderItem(ResultSet rs) throws SQLException {
        OrderItem item = new OrderItem();
        item.setOrderItemId(rs.getInt("order_item_id"));
        item.setReservationId(rs.getInt("reservation_id"));
        item.setItemId(rs.getInt("item_id"));
        item.setQuantity(rs.getInt("quantity"));
        item.setUnitPrice(rs.getBigDecimal("unit_price"));
        item.setStatus(rs.getString("status"));
        item.setSpecialInstructions(rs.getString("special_instructions"));
        return item;
    }
}