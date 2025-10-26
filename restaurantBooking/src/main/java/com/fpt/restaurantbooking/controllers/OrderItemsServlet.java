package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.models.MenuItem;
import com.fpt.restaurantbooking.models.OrderItem;
import com.fpt.restaurantbooking.repositories.impl.MenuItemDAO;
import com.fpt.restaurantbooking.repositories.impl.OrderItemDAO;
import com.fpt.restaurantbooking.repositories.impl.ReservationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/orderItems")
public class OrderItemsServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(OrderItemsServlet.class);
    private MenuItemDAO menuItemDAO = new MenuItemDAO();
    private OrderItemDAO orderItemDAO = new OrderItemDAO();
    private ReservationDAO reservationDAO = new ReservationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        try {
            // ✅ Kiểm tra nếu là request lấy tổng tiền
            String action = request.getParameter("action");
            if ("getTotal".equals(action)) {
                handleGetTotal(request, response, session);
                return;
            }

            Integer reservationId = (Integer) session.getAttribute("reservationId");

            // Lấy parameters
            String search = request.getParameter("search");
            String category = request.getParameter("category");
            String pageParam = request.getParameter("page");

            int currentPage = 1;
            int pageSize = 6;

            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    currentPage = Integer.parseInt(pageParam);
                    if (currentPage < 1) currentPage = 1;
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }

            // Lấy tất cả menu items
            List<MenuItem> allMenuItems;
            if (search != null && !search.trim().isEmpty()) {
                allMenuItems = menuItemDAO.searchMenuItems(search);
            } else if (category != null && !category.isEmpty() && !"all".equals(category)) {
                allMenuItems = menuItemDAO.getMenuItemsByCategory(category);
            } else {
                allMenuItems = menuItemDAO.getAllAvailableMenuItems();
            }

            // Tính pagination
            int totalItems = allMenuItems.size();
            int totalPages = (int) Math.ceil((double) totalItems / pageSize);
            int offset = (currentPage - 1) * pageSize;

            // Lấy items cho trang hiện tại
            List<MenuItem> menuItems = allMenuItems.subList(
                    Math.min(offset, totalItems),
                    Math.min(offset + pageSize, totalItems)
            );

            // Lấy categories
            List<String> categories = menuItemDAO.getMenuCategories();

            // Set attributes
            request.setAttribute("menuItems", menuItems);
            request.setAttribute("categories", categories);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);

            logger.info("✅ Loaded {} menu items for page {}/{}", menuItems.size(), currentPage, totalPages);
            logger.info("✅ reservationId from session: {}", reservationId);

            request.getRequestDispatcher("/WEB-INF/BookTable/orderItem.jsp").forward(request, response);

        } catch (Exception e) {
            logger.error("❌ Error in OrderItemsServlet.doGet()", e);
            request.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/BookTable/orderItem.jsp").forward(request, response);
        }
    }

    /**
     * ✅ XỬ LÝ REQUEST LẤY TỔNG TIỀN (JSON)
     */
    private void handleGetTotal(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws IOException {
        response.setContentType("application/json;charset=UTF-8");

        try {
            Integer reservationId = (Integer) session.getAttribute("reservationId");

            if (reservationId == null) {
                response.getWriter().write("{\"success\": false, \"total\": 0, \"totalItems\": 0}");
                return;
            }

            // Tính tổng tiền và số lượng món
            BigDecimal totalPrice = orderItemDAO.calculateTotalPrice(reservationId);
            List<OrderItem> orderItems = orderItemDAO.getOrderItemsByReservationId(reservationId);

            int totalItems = 0;
            for (OrderItem item : orderItems) {
                totalItems += item.getQuantity();
            }

            // Trả về JSON
            response.getWriter().write(String.format(
                    "{\"success\": true, \"total\": %.2f, \"totalItems\": %d}",
                    totalPrice.doubleValue(),
                    totalItems
            ));

            logger.info("✅ getTotal: reservationId={}, total={}, items={}",
                    reservationId, totalPrice, totalItems);

        } catch (Exception e) {
            logger.error("❌ Error in handleGetTotal", e);
            response.getWriter().write("{\"success\": false, \"total\": 0, \"totalItems\": 0}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        logger.info(">>> [DEBUG] OrderItemsServlet.doPost()");

        response.setContentType("application/json;charset=UTF-8");

        try {
            String action = request.getParameter("action");
            Integer reservationId = (Integer) session.getAttribute("reservationId");

            logger.info(">>> action: {}", action);
            logger.info(">>> reservationId: {}", reservationId);

            if (reservationId == null) {
                logger.error("❌ reservationId is NULL");
                response.getWriter().write("{\"success\": false, \"message\": \"Không có đơn đặt bàn\"}");
                return;
            }

            if ("add".equals(action)) {
                String itemIdStr = request.getParameter("itemId");
                String qtyStr = request.getParameter("quantity");
                String note = request.getParameter("note");

                logger.info(">>> itemId: {}, quantity: {}, note: {}", itemIdStr, qtyStr, note);

                int itemId = Integer.parseInt(itemIdStr);
                int quantity = Integer.parseInt(qtyStr);

                if (quantity <= 0) {
                    logger.warn("⚠️ Quantity <= 0: {}", quantity);
                    response.getWriter().write("{\"success\": false, \"message\": \"Số lượng phải lớn hơn 0\"}");
                    return;
                }

                MenuItem menuItem = menuItemDAO.getMenuItemById(itemId);
                if (menuItem == null) {
                    logger.error("❌ MenuItem not found: {}", itemId);
                    response.getWriter().write("{\"success\": false, \"message\": \"Món ăn không tồn tại\"}");
                    return;
                }

                logger.info("✅ Found MenuItem: {} - {}", menuItem.getItemId(), menuItem.getItemName());

                OrderItem orderItem = new OrderItem(reservationId, itemId, quantity, menuItem.getPrice());
                orderItem.setSpecialInstructions(note);

                logger.info(">>> Creating OrderItem: resId={}, itemId={}, qty={}, price={}",
                        reservationId, itemId, quantity, menuItem.getPrice());

                int orderItemId = orderItemDAO.addOrderItem(orderItem);

                logger.info(">>> OrderItem created with ID: {}", orderItemId);

                if (orderItemId > 0) {
                    BigDecimal totalPrice = orderItemDAO.calculateTotalPrice(reservationId);
                    reservationDAO.updateTotalAmount(reservationId, totalPrice);

                    logger.info("✅ Added item {} to reservation {}, new total: {}",
                            itemId, reservationId, totalPrice);

                    response.getWriter().write("{\"success\": true, \"message\": \"Thêm món thành công\"}");
                } else {
                    logger.error("❌ Failed to add OrderItem");
                    response.getWriter().write("{\"success\": false, \"message\": \"Lỗi khi thêm món\"}");
                }
            }
            else if ("updateQty".equals(action)) {
                // Cập nhật số lượng món ăn
                String orderItemIdStr = request.getParameter("orderItemId");
                String qtyStr = request.getParameter("quantity");

                logger.info(">>> updateQty: orderItemId={}, quantity={}", orderItemIdStr, qtyStr);

                int orderItemId = Integer.parseInt(orderItemIdStr);
                int quantity = Integer.parseInt(qtyStr);

                if (quantity <= 0) {
                    logger.warn("⚠️ Quantity <= 0: {}", quantity);
                    response.getWriter().write("{\"success\": false, \"message\": \"Số lượng phải lớn hơn 0\"}");
                    return;
                }

                boolean updated = orderItemDAO.updateOrderItemQuantity(orderItemId, quantity);

                if (updated) {
                    BigDecimal totalPrice = orderItemDAO.calculateTotalPrice(reservationId);
                    reservationDAO.updateTotalAmount(reservationId, totalPrice);

                    logger.info("✅ Updated order item {} to quantity {}, new total: {}",
                            orderItemId, quantity, totalPrice);

                    response.getWriter().write("{\"success\": true, \"message\": \"Cập nhật thành công\"}");
                } else {
                    logger.error("❌ Failed to update order item");
                    response.getWriter().write("{\"success\": false, \"message\": \"Lỗi khi cập nhật\"}");
                }
            }
            else if ("remove".equals(action)) {
                // Xóa món ăn
                String orderItemIdStr = request.getParameter("orderItemId");

                logger.info(">>> remove: orderItemId={}", orderItemIdStr);

                int orderItemId = Integer.parseInt(orderItemIdStr);

                boolean deleted = orderItemDAO.deleteOrderItem(orderItemId);

                if (deleted) {
                    BigDecimal totalPrice = orderItemDAO.calculateTotalPrice(reservationId);
                    reservationDAO.updateTotalAmount(reservationId, totalPrice);

                    logger.info("✅ Deleted order item {}, new total: {}", orderItemId, totalPrice);

                    response.getWriter().write("{\"success\": true, \"message\": \"Xóa thành công\"}");
                } else {
                    logger.error("❌ Failed to delete order item");
                    response.getWriter().write("{\"success\": false, \"message\": \"Lỗi khi xóa\"}");
                }
            }

        } catch (NumberFormatException e) {
            logger.error("❌ Invalid number format", e);
            response.getWriter().write("{\"success\": false, \"message\": \"Dữ liệu không hợp lệ\"}");
        } catch (Exception e) {
            logger.error("❌ Error in OrderItemsServlet POST", e);
            response.getWriter().write("{\"success\": false, \"message\": \"Có lỗi xảy ra: " + e.getMessage() + "\"}");
        }
    }
}

