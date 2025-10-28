package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.models.MenuItem;
import com.fpt.restaurantbooking.models.OrderItem;
import com.fpt.restaurantbooking.repositories.impl.MenuItemDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/removeTable")
public class RemoveTableServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(RemoveTableServlet.class);
    private final MenuItemDAO menuItemDAO = new MenuItemDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        response.setContentType("application/json;charset=UTF-8");

        try {
            String tableIdStr = request.getParameter("tableId");

            if (tableIdStr == null || tableIdStr.isEmpty()) {
                response.getWriter().write("{\"success\": false, \"message\": \"Thiếu thông tin bàn\"}");
                return;
            }

            int tableId = Integer.parseInt(tableIdStr);

            logger.info(">>> Removing table {} from session", tableId);

            // 🔹 Lấy danh sách bàn từ session
            @SuppressWarnings("unchecked")
            List<Integer> selectedTableIds = (List<Integer>) session.getAttribute("selectedTableIds");

            if (selectedTableIds == null || selectedTableIds.isEmpty()) {
                response.getWriter().write("{\"success\": false, \"message\": \"Không có bàn nào để xóa\"}");
                return;
            }

            // Xóa bàn khỏi session
            boolean removed = selectedTableIds.removeIf(id -> id.equals(tableId));

            if (removed) {
                // Cập nhật lại session
                session.setAttribute("selectedTableIds", selectedTableIds);
                logger.info("✅ Removed table {} from session", tableId);

                // 🔥 Cập nhật số lượng combo món nếu có service được chọn
                Integer selectedServiceId = (Integer) session.getAttribute("selectedServiceId");
                if (selectedServiceId != null && selectedServiceId > 0) {
                    // Lấy danh sách món trong service
                    List<MenuItem> serviceMenuItems = menuItemDAO.getMenuItemsByServiceId(selectedServiceId);

                    if (!serviceMenuItems.isEmpty()) {
                        // Lấy cart hiện tại
                        @SuppressWarnings("unchecked")
                        List<OrderItem> cartItems = (List<OrderItem>) session.getAttribute("cartItems");
                        if (cartItems == null) {
                            cartItems = new ArrayList<>();
                        }

                        // Số bàn còn lại sau khi xóa
                        int remainingTableCount = selectedTableIds.size();

                        if (remainingTableCount == 0) {
                            // ❌ Không còn bàn nào → Xóa hết combo món khỏi cart
                            cartItems.removeIf(item -> {
                                for (MenuItem menuItem : serviceMenuItems) {
                                    if (item.getItemId() != null && item.getItemId().equals(menuItem.getItemId())) {
                                        logger.info("🗑️ Removed combo item {} from cart (no tables left)", item.getItemId());
                                        return true;
                                    }
                                }
                                return false;
                            });
                        } else {
                            // ✅ Còn bàn → Cập nhật số lượng combo = số bàn còn lại
                            for (MenuItem menuItem : serviceMenuItems) {
                                for (OrderItem cartItem : cartItems) {
                                    if (cartItem.getItemId() != null &&
                                            cartItem.getItemId().equals(menuItem.getItemId())) {
                                        cartItem.setQuantity(remainingTableCount);
                                        logger.info("✅ Updated combo item {} quantity to {} (remaining tables)",
                                                menuItem.getItemId(), remainingTableCount);
                                        break;
                                    }
                                }
                            }
                        }

                        // Lưu lại cart
                        session.setAttribute("cartItems", cartItems);
                        logger.info("✅ Updated combo items based on {} remaining tables", remainingTableCount);
                    }
                }

                response.getWriter().write("{\"success\": true, \"message\": \"Xóa bàn thành công\"}");
            } else {
                logger.warn("⚠️ Table {} not found in session", tableId);
                response.getWriter().write("{\"success\": false, \"message\": \"Không tìm thấy bàn\"}");
            }

        } catch (NumberFormatException e) {
            logger.error("❌ Invalid table ID format", e);
            response.getWriter().write("{\"success\": false, \"message\": \"Mã bàn không hợp lệ\"}");
        } catch (Exception e) {
            logger.error("❌ Error in RemoveTableServlet", e);
            response.getWriter().write("{\"success\": false, \"message\": \"Có lỗi xảy ra trong quá trình xóa bàn\"}");
        }
    }
}
