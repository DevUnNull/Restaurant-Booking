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
import java.util.ArrayList;
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

            // ✅ Lấy danh sách món trong service combo (nếu có) - TRƯỚC KHI LỌC
            Integer selectedServiceId = (Integer) session.getAttribute("selectedServiceId");
            List<MenuItem> serviceComboItems = new ArrayList<>();
            if (selectedServiceId != null && selectedServiceId > 0) {
                serviceComboItems = menuItemDAO.getMenuItemsByServiceId(selectedServiceId);
                logger.info("✅ Loaded {} items from service combo (service_id={})",
                        serviceComboItems.size(), selectedServiceId);
            }

            // Lấy tất cả menu items
            List<MenuItem> allMenuItems;
            if (search != null && !search.trim().isEmpty()) {
                allMenuItems = menuItemDAO.searchMenuItems(search);
            } else if ("combo".equals(category) && !serviceComboItems.isEmpty()) {
                // 🌟 LỌC CHỈ HIỂN THỊ MÓN TRONG COMBO
                allMenuItems = new ArrayList<>(serviceComboItems);
                logger.info("🌟 Filtering combo items only: {} items", allMenuItems.size());
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
            request.setAttribute("serviceComboItems", serviceComboItems);
            request.setAttribute("selectedServiceId", selectedServiceId);

            logger.info("✅ Loaded {} menu items for page {}/{}", menuItems.size(), currentPage, totalPages);

            request.getRequestDispatcher("/WEB-INF/BookTable/orderItem.jsp").forward(request, response);

        } catch (Exception e) {
            logger.error("❌ Error in OrderItemsServlet.doGet()", e);
            request.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/BookTable/orderItem.jsp").forward(request, response);
        }
    }

    /**
     * ✅ XỬ LÝ REQUEST LẤY TỔNG TIỀN (JSON) - TÍNH TỪ SESSION
     */
    private void handleGetTotal(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws IOException {
        response.setContentType("application/json;charset=UTF-8");

        try {
            // Lấy danh sách món ăn từ session
            @SuppressWarnings("unchecked")
            List<OrderItem> sessionItems = (List<OrderItem>) session.getAttribute("cartItems");

            BigDecimal totalPrice = BigDecimal.ZERO;
            int totalItems = 0;

            if (sessionItems != null && !sessionItems.isEmpty()) {
                for (OrderItem item : sessionItems) {
                    BigDecimal itemTotal = item.getUnitPrice().multiply(new BigDecimal(item.getQuantity()));
                    totalPrice = totalPrice.add(itemTotal);
                    totalItems += item.getQuantity();
                }
            }

            // Trả về JSON
            response.getWriter().write(String.format(
                    "{\"success\": true, \"total\": %.2f, \"totalItems\": %d}",
                    totalPrice.doubleValue(),
                    totalItems
            ));

            logger.info("✅ getTotal from session: total={}, items={}", totalPrice, totalItems);

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

            logger.info(">>> action: {}", action);

            if ("add".equals(action)) {
                // 🔹 LẤY MÓN ĂN TỪ SESSION (không lưu vào DB)
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

                // Lấy danh sách món từ session
                @SuppressWarnings("unchecked")
                List<OrderItem> sessionItems = (List<OrderItem>) session.getAttribute("cartItems");

                if (sessionItems == null) {
                    sessionItems = new ArrayList<>();
                }

                // ✅ Kiểm tra xem món combo hay món thường
                Integer selectedServiceId = (Integer) session.getAttribute("selectedServiceId");
                boolean isComboItem = false;
                if (selectedServiceId != null && selectedServiceId > 0) {
                    List<MenuItem> comboItems = menuItemDAO.getMenuItemsByServiceId(selectedServiceId);
                    for (MenuItem comboItem : comboItems) {
                        if (comboItem.getItemId().equals(itemId)) {
                            isComboItem = true;
                            break;
                        }
                    }
                }

                // 🔄 Kiểm tra xem món đã có trong session chưa
                boolean found = false;
                for (OrderItem existingItem : sessionItems) {
                    if (existingItem.getItemId() == itemId) {
                        if (isComboItem) {
                            // 🌟 MÓN COMBO: Luôn cộng dồn (không quan tâm note)
                            existingItem.setQuantity(existingItem.getQuantity() + quantity);
                            found = true;
                            logger.info("✅ Combo item: Added {} to existing quantity", quantity);
                            break;
                        } else if ((existingItem.getSpecialInstructions() == null && (note == null || note.isEmpty())) ||
                                (existingItem.getSpecialInstructions() != null && existingItem.getSpecialInstructions().equals(note))) {
                            // 🍽️ MÓN THƯỜNG: Cộng dồn nếu cùng note
                            existingItem.setQuantity(existingItem.getQuantity() + quantity);
                            found = true;
                            logger.info("✅ Regular item: Added {} to existing quantity", quantity);
                            break;
                        }
                    }
                }

                if (!found) {
                    // Tạo OrderItem mới (chưa có reservationId)
                    OrderItem orderItem = new OrderItem(0, itemId, quantity, menuItem.getPrice());
                    orderItem.setSpecialInstructions(note);
                    sessionItems.add(orderItem);
                    logger.info("✅ Created new OrderItem for item {}", itemId);
                }

                // Lưu lại vào session
                session.setAttribute("cartItems", sessionItems);

                logger.info("✅ Added item {} to session cart. Total items: {}", itemId, sessionItems.size());
                response.getWriter().write("{\"success\": true, \"message\": \"Thêm món thành công\"}");

            } else if ("updateQty".equals(action)) {
                // Cập nhật số lượng món ăn trong session bằng INDEX
                String itemIndexStr = request.getParameter("itemIndex");
                String qtyStr = request.getParameter("quantity");

                logger.info(">>> updateQty: itemIndex={}, quantity={}", itemIndexStr, qtyStr);

                if (itemIndexStr == null || qtyStr == null) {
                    response.getWriter().write("{\"success\": false, \"message\": \"Thiếu thông tin\"}");
                    return;
                }

                int itemIndex = Integer.parseInt(itemIndexStr);
                int quantity = Integer.parseInt(qtyStr);

                if (quantity <= 0) {
                    logger.warn("⚠️ Quantity <= 0: {}", quantity);
                    response.getWriter().write("{\"success\": false, \"message\": \"Số lượng phải lớn hơn 0\"}");
                    return;
                }

                @SuppressWarnings("unchecked")
                List<OrderItem> sessionItems = (List<OrderItem>) session.getAttribute("cartItems");

                if (sessionItems != null && itemIndex >= 0 && itemIndex < sessionItems.size()) {
                    OrderItem item = sessionItems.get(itemIndex);
                    item.setQuantity(quantity);
                    session.setAttribute("cartItems", sessionItems);
                    logger.info("✅ Updated item at index {} to quantity {}", itemIndex, quantity);
                    response.getWriter().write("{\"success\": true, \"message\": \"Cập nhật thành công\"}");
                } else {
                    response.getWriter().write("{\"success\": false, \"message\": \"Không tìm thấy món\"}");
                }
            }
            else if ("remove".equals(action)) {
                // Xóa món ăn khỏi session bằng INDEX
                String itemIndexStr = request.getParameter("itemIndex");

                logger.info(">>> remove: itemIndex={}", itemIndexStr);

                if (itemIndexStr == null) {
                    response.getWriter().write("{\"success\": false, \"message\": \"Thiếu thông tin\"}");
                    return;
                }

                int itemIndex = Integer.parseInt(itemIndexStr);

                @SuppressWarnings("unchecked")
                List<OrderItem> sessionItems = (List<OrderItem>) session.getAttribute("cartItems");

                if (sessionItems != null && itemIndex >= 0 && itemIndex < sessionItems.size()) {
                    OrderItem removedItem = sessionItems.remove(itemIndex);
                    session.setAttribute("cartItems", sessionItems);

                    logger.info("✅ Removed item at index {} from session", itemIndex);
                    response.getWriter().write("{\"success\": true, \"message\": \"Xóa thành công\"}");
                } else {
                    response.getWriter().write("{\"success\": false, \"message\": \"Không tìm thấy món\"}");
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

