package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.models.OrderItem;
import com.fpt.restaurantbooking.models.Reservation;
import com.fpt.restaurantbooking.models.MenuItem;
import com.fpt.restaurantbooking.models.Table;
import com.fpt.restaurantbooking.models.Payment;
import com.fpt.restaurantbooking.repositories.impl.OrderItemDAO;
import com.fpt.restaurantbooking.repositories.impl.ReservationDAO;
import com.fpt.restaurantbooking.repositories.impl.ReservationTableDAO;
import com.fpt.restaurantbooking.repositories.impl.MenuItemDAO;
import com.fpt.restaurantbooking.repositories.impl.PaymentDAO;
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
import java.util.HashMap;
import java.util.Map;

/**
 * Servlet for STAFF to view order details
 * Different from OrderDetailsServlet which is for CUSTOMERS
 */
@WebServlet("/staffOrderDetails")
public class StaffOrderDetailsServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(StaffOrderDetailsServlet.class);

    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final ReservationTableDAO reservationTableDAO = new ReservationTableDAO();
    private final OrderItemDAO orderItemDAO = new OrderItemDAO();
    private final MenuItemDAO menuItemDAO = new MenuItemDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        try {
            // Check authentication
            if (session == null || session.getAttribute("userId") == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            // Check authorization - only STAFF (role = 2) can access
            Integer userRole = (Integer) session.getAttribute("userRole");
            if (userRole == null || userRole != 2) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN,
                        "Access denied. Staff role required.");
                return;
            }

            // Get reservation ID parameter
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.isEmpty()) {
                request.setAttribute("errorMessage", "Thiếu mã đơn đặt bàn.");
                response.sendRedirect(request.getContextPath() + "/OrderManagement");
                return;
            }

            int reservationId;
            try {
                reservationId = Integer.parseInt(idParam);
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Mã đơn đặt bàn không hợp lệ.");
                response.sendRedirect(request.getContextPath() + "/OrderManagement");
                return;
            }

            // Get reservation details
            Reservation reservation = reservationDAO.getReservationById(reservationId);
            if (reservation == null) {
                request.setAttribute("errorMessage", "Không tìm thấy đơn đặt bàn.");
                response.sendRedirect(request.getContextPath() + "/OrderManagement");
                return;
            }

            // Get related data
            List<Table> tables = reservationTableDAO.getTablesByReservationIdDetailed(reservationId);
            List<OrderItem> orderItems = orderItemDAO.getOrderItemsByReservationId(reservationId);
            Payment payment = paymentDAO.getPaymentByReservationId(reservationId);

            // Get service menu items (combo items) - try multiple methods
            List<MenuItem> serviceMenuItems = new java.util.ArrayList<>();
            Integer serviceId = null;
            List<Integer> itemIds = new java.util.ArrayList<>();

            // Collect all itemIds from orderItems
            if (orderItems != null && !orderItems.isEmpty()) {
                for (OrderItem item : orderItems) {
                    if (item.getItemId() != null) {
                        itemIds.add(item.getItemId());
                    }
                }
                logger.info("Reservation {} - Found {} items in orderItems: {}", reservationId, itemIds.size(), itemIds);
            }

            // Method 1: Try getting serviceId from Reservations table
            serviceId = reservationDAO.getServiceIdByReservationId(reservationId);
            logger.info("Reservation {} - ServiceId from Reservations table: {}", reservationId, serviceId);

            // Method 2: If not found, try to find serviceId from orderItems
            if (serviceId == null && !itemIds.isEmpty()) {
                // Try to get serviceId from the first item
                serviceId = menuItemDAO.getServiceIdByMenuItemId(itemIds.get(0));
                logger.info("Reservation {} - ServiceId from first orderItem (itemId={}): {}",
                        reservationId, itemIds.get(0), serviceId);

                // If still null, try to find common service from all items
                if (serviceId == null && itemIds.size() > 1) {
                    serviceId = menuItemDAO.getServiceIdByMenuItemIds(itemIds);
                    logger.info("Reservation {} - ServiceId from all orderItems: {}", reservationId, serviceId);
                }
            }

            // Method 3: Load combo items from serviceId if found
            if (serviceId != null) {
                serviceMenuItems = menuItemDAO.getMenuItemsByServiceId(serviceId);
                logger.info("Reservation {} - Loaded {} combo items from serviceId {}",
                        reservationId, serviceMenuItems.size(), serviceId);
            }

            // Method 4: If serviceId not found or no items loaded, get combo items directly from orderItems
            if (serviceMenuItems.isEmpty() && !itemIds.isEmpty()) {
                serviceMenuItems = menuItemDAO.getComboMenuItemsByItemIds(itemIds);
                logger.info("Reservation {} - Loaded {} combo items directly from orderItems",
                        reservationId, serviceMenuItems.size());

                // If we found combo items but no serviceId, try to get serviceId from the first combo item
                if (!serviceMenuItems.isEmpty() && serviceId == null) {
                    serviceId = menuItemDAO.getServiceIdByMenuItemId(serviceMenuItems.get(0).getItemId());
                    logger.info("Reservation {} - Found serviceId {} from combo items", reservationId, serviceId);
                }
            }

            if (serviceMenuItems.isEmpty()) {
                logger.warn("Reservation {} - No combo items found after all methods. ItemIds: {}", reservationId, itemIds);
            }

            // Resolve menu item names for display
            Map<Integer, MenuItem> menuItemsMap = new HashMap<>();
            BigDecimal calculatedTotal = BigDecimal.ZERO;

            for (OrderItem item : orderItems) {
                Integer itemId = item.getItemId();
                if (itemId != null && !menuItemsMap.containsKey(itemId)) {
                    MenuItem menuItem = menuItemDAO.getMenuItemById(itemId);
                    if (menuItem != null) {
                        menuItemsMap.put(itemId, menuItem);
                    }
                }

                // Calculate total
                if (item.getUnitPrice() != null && item.getQuantity() != null) {
                    BigDecimal itemTotal = item.getUnitPrice()
                            .multiply(BigDecimal.valueOf(item.getQuantity()));
                    calculatedTotal = calculatedTotal.add(itemTotal);
                }
            }

            logger.info("Staff viewing order details for reservation {}", reservationId);

            // Set attributes for JSP
            request.setAttribute("reservation", reservation);
            request.setAttribute("tables", tables);
            request.setAttribute("orderItems", orderItems);
            request.setAttribute("serviceMenuItems", serviceMenuItems);
            request.setAttribute("menuItemsMap", menuItemsMap);
            request.setAttribute("payment", payment);
            request.setAttribute("calculatedTotal", calculatedTotal);
            request.setAttribute("reservationId", reservationId);

            // Forward to staff-specific JSP
            request.getRequestDispatcher("/WEB-INF/views/management/staffOrderDetails.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            logger.error("Error loading staff order details", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Lỗi tải chi tiết đơn hàng");
        }
    }
}

