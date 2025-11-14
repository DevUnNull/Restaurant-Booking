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

@WebServlet("/addTable")
public class AddTableServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(AddTableServlet.class);
    private final MenuItemDAO menuItemDAO = new MenuItemDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        response.setContentType("application/json;charset=UTF-8");

        try {
            String tableIdStr = request.getParameter("tableId");
            Integer userId = (Integer) session.getAttribute("userId");

            if (tableIdStr == null || tableIdStr.isEmpty()) {
                response.getWriter().write("{\"success\": false, \"message\": \"Thiếu thông tin bàn\"}");
                return;
            }

            if (userId == null) {
                response.getWriter().write("{\"success\": false, \"message\": \"Vui lòng đăng nhập để đặt bàn\"}");
                return;
            }

            int tableId = Integer.parseInt(tableIdStr);

            // 🔹 Lấy danh sách bàn đã chọn từ session (không lưu vào DB)
            @SuppressWarnings("unchecked")
            List<Integer> selectedTableIds = (List<Integer>) session.getAttribute("selectedTableIds");

            if (selectedTableIds == null) {
                selectedTableIds = new ArrayList<>();
            }

            // 🔹 Kiểm tra xem bàn đã nằm trong danh sách chưa
            if (selectedTableIds.contains(tableId)) {
                response.getWriter().write("{\"success\": false, \"message\": \"Bàn này đã được thêm vào đơn đặt\"}");
                return;
            }

            // 🔹 Thêm bàn vào danh sách session
            selectedTableIds.add(tableId);
            session.setAttribute("selectedTableIds", selectedTableIds);

            logger.info("✅ Added table {} to session (not in DB yet)", tableId);

            // 🔹 Kiểm tra nếu có service được chọn, tự động thêm combo món ăn
            Integer selectedServiceId = (Integer) session.getAttribute("selectedServiceId");
            if (selectedServiceId != null && selectedServiceId > 0) {
                // Lấy danh sách món ăn trong service
                List<MenuItem> serviceMenuItems = menuItemDAO.getMenuItemsByServiceId(selectedServiceId);

                if (!serviceMenuItems.isEmpty()) {
                    // Lấy cart hiện tại từ session
                    @SuppressWarnings("unchecked")
                    List<OrderItem> cartItems = (List<OrderItem>) session.getAttribute("cartItems");
                    if (cartItems == null) {
                        cartItems = new ArrayList<>();
                    }

                    // 🔥 SỐ LƯỢNG MÓN = SỐ BÀN ĐÃ CHỌN
                    int tableCount = selectedTableIds.size();

                    // Cập nhật/thêm từng món trong service vào cart
                    for (MenuItem menuItem : serviceMenuItems) {
                        // Kiểm tra xem món đã có trong cart chưa
                        boolean itemExists = false;
                        for (OrderItem existingItem : cartItems) {
                            if (existingItem.getItemId() != null &&
                                    existingItem.getItemId().equals(menuItem.getItemId())) {
                                // Món đã có, cập nhật số lượng = số bàn
                                existingItem.setQuantity(tableCount);
                                itemExists = true;
                                logger.info("✅ Updated quantity for item {} to {} (based on {} tables)",
                                        menuItem.getItemId(), tableCount, tableCount);
                                break;
                            }
                        }

                        // Nếu món chưa có, thêm mới vào cart với số lượng = số bàn
                        if (!itemExists) {
                            OrderItem newOrderItem = new OrderItem();
                            newOrderItem.setItemId(menuItem.getItemId());
                            newOrderItem.setQuantity(tableCount);
                            newOrderItem.setUnitPrice(menuItem.getPrice());
                            newOrderItem.setStatus("PENDING");
                            cartItems.add(newOrderItem);
                            logger.info("✅ Added new item {} (from service {}) to cart with quantity {}",
                                    menuItem.getItemId(), selectedServiceId, tableCount);
                        }
                    }

                    // Lưu lại cart vào session
                    session.setAttribute("cartItems", cartItems);
                    logger.info("✅ Auto-updated {} combo items based on {} selected tables",
                            serviceMenuItems.size(), tableCount);
                }
            }

            response.getWriter().write("{\"success\": true, \"message\": \"Thêm bàn thành công\"}");

        } catch (NumberFormatException e) {
            logger.error("❌ Invalid table ID format", e);
            response.getWriter().write("{\"success\": false, \"message\": \"Mã bàn không hợp lệ\"}");
        } catch (Exception e) {
            logger.error("❌ Error in AddTableServlet", e);
            response.getWriter().write("{\"success\": false, \"message\": \"Có lỗi xảy ra trong quá trình thêm bàn\"}");
        }
    }
}
