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
import java.util.List;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/orderDetails")
public class OrderDetailsServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(OrderDetailsServlet.class);

    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final ReservationTableDAO reservationTableDAO = new ReservationTableDAO();
    private final OrderItemDAO orderItemDAO = new OrderItemDAO();
    private final MenuItemDAO menuItemDAO = new MenuItemDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        try {
            Integer userId = (Integer) session.getAttribute("userId");
            if (userId == null) {
                response.sendRedirect("login");
                return;
            }

            String idParam = request.getParameter("id");
            if (idParam == null || idParam.isEmpty()) {
                request.setAttribute("errorMessage", "Thiếu mã đơn đặt bàn.");
                request.getRequestDispatcher("/orderHistory").forward(request, response);
                return;
            }

            int reservationId;
            try {
                reservationId = Integer.parseInt(idParam);
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Mã đơn đặt bàn không hợp lệ.");
                request.getRequestDispatcher("/orderHistory").forward(request, response);
                return;
            }

            Reservation reservation = reservationDAO.getReservationById(reservationId);
            if (reservation == null) {
                request.setAttribute("errorMessage", "Không tìm thấy đơn đặt bàn.");
                request.getRequestDispatcher("/orderHistory").forward(request, response);
                return;
            }

            if (reservation.getUserId() == null || !reservation.getUserId().equals(userId)) {
                logger.warn("User {} attempted to access reservation {} not owned by them", userId, reservationId);
                response.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }

            List<Table> tables = reservationTableDAO.getTablesByReservationIdDetailed(reservationId);
            List<OrderItem> items = orderItemDAO.getOrderItemsByReservationId(reservationId);
            Payment payment = paymentDAO.getPaymentByReservationId(reservationId);

            // Resolve item names for display
            Map<Integer, String> itemNames = new HashMap<>();
            for (OrderItem item : items) {
                Integer itemId = item.getItemId();
                if (itemId != null && !itemNames.containsKey(itemId)) {
                    MenuItem menuItem = menuItemDAO.getMenuItemById(itemId);
                    itemNames.put(itemId, menuItem != null ? menuItem.getItemName() : ("Món #" + itemId));
                }
            }

            request.setAttribute("reservation", reservation);
            request.setAttribute("tables", tables);
            request.setAttribute("orderItems", items);
            request.setAttribute("itemNames", itemNames);
            request.setAttribute("payment", payment);
            request.setAttribute("reservationId", reservationId);

            request.getRequestDispatcher("/WEB-INF/BookTable/orderDetails.jsp").forward(request, response);
        } catch (Exception e) {
            logger.error("Error loading order details", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi tải chi tiết đơn");
        }
    }
}


