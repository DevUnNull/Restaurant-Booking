package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.models.OrderItem;
import com.fpt.restaurantbooking.models.Reservation;
import com.fpt.restaurantbooking.repositories.impl.OrderItemDAO;
import com.fpt.restaurantbooking.repositories.impl.ReservationDAO;
import com.fpt.restaurantbooking.repositories.impl.ReservationTableDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/editReservation")
public class EditReservationServlet extends HttpServlet {

    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final ReservationTableDAO reservationTableDAO = new ReservationTableDAO();
    private final OrderItemDAO orderItemDAO = new OrderItemDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            response.sendRedirect("login");
            return;
        }

        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect("orderHistory");
            return;
        }

        try {
            int reservationId = Integer.parseInt(idParam);

            Reservation reservation = reservationDAO.getReservationById(reservationId);
            if (reservation == null || !reservation.getUserId().equals(userId)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }

            // Load current tables and items
            List<Integer> tableIds = reservationTableDAO.getTablesByReservationId(reservationId);
            List<OrderItem> items = orderItemDAO.getOrderItemsByReservationId(reservationId);

            // Put into session for checkout edit flow
            session.setAttribute("selectedTableIds", tableIds != null ? tableIds : new ArrayList<Integer>());
            session.setAttribute("cartItems", items != null ? items : new ArrayList<OrderItem>());
            session.setAttribute("requiredDate", reservation.getReservationDate() != null ? reservation.getReservationDate().toString() : null);
            session.setAttribute("requiredTime", reservation.getReservationTime() != null ? reservation.getReservationTime().toString() : null);
            session.setAttribute("guestCount", reservation.getGuestCount());
            session.setAttribute("specialRequest", reservation.getSpecialRequests());
            session.setAttribute("editingReservationId", reservationId);

            response.sendRedirect("checkout");
        } catch (NumberFormatException e) {
            response.sendRedirect("orderHistory");
        }
    }
}


