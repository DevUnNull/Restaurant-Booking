package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.models.Reservation;
import com.fpt.restaurantbooking.models.Table;
import com.fpt.restaurantbooking.repositories.impl.ReservationDAO;
import com.fpt.restaurantbooking.repositories.impl.ReservationTableDAO;
import com.fpt.restaurantbooking.repositories.impl.TableDAO;
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

@WebServlet("/orderHistory")
public class OrderHistoryServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(OrderHistoryServlet.class);
    private ReservationDAO reservationDAO = new ReservationDAO();
    private ReservationTableDAO reservationTableDAO = new ReservationTableDAO();
    private TableDAO tableDAO = new TableDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        logger.info(">>> [ORDER HISTORY] Loading order history page");

        try {
            // Lấy userId từ session
            Integer userId = (Integer) session.getAttribute("userId");

            if (userId == null) {
                logger.warn("⚠️ User not logged in, redirecting to login");
                response.sendRedirect("login");
                return;
            }

            // Kiểm tra thông báo success
            String success = request.getParameter("success");
            if (success != null && success.equals("true")) {
                request.setAttribute("successMessage", "Đặt bàn thành công! Chúng tôi sẽ liên hệ với bạn sớm nhất.");
                logger.info("✅ Booking success message displayed");
            }

            // Lấy danh sách reservations của user
            List<Reservation> reservations = reservationDAO.getReservationsByUserId(userId);

            logger.info("✅ Found {} reservations for user {}", reservations.size(), userId);

            // Lấy thông tin bàn cho mỗi reservation
            List<ReservationWithTables> reservationsWithTables = new ArrayList<>();
            for (Reservation reservation : reservations) {
                List<Integer> tableIds = reservationTableDAO.getTablesByReservationId(reservation.getReservationId());
                List<Table> tables = new ArrayList<>();
                for (Integer tableId : tableIds) {
                    Table table = tableDAO.getTableById(tableId);
                    if (table != null) {
                        tables.add(table);
                    }
                }
                reservationsWithTables.add(new ReservationWithTables(reservation, tables));
            }

            // Set attributes
            request.setAttribute("reservations", reservationsWithTables);
            request.setAttribute("userId", userId);

            request.getRequestDispatcher("/WEB-INF/BookTable/orderHistory.jsp").forward(request, response);

        } catch (Exception e) {
            logger.error("❌ Error in OrderHistoryServlet GET", e);
            request.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/BookTable/orderHistory.jsp").forward(request, response);
        }
    }

    // Inner class để đóng gói Reservation với Tables
    public static class ReservationWithTables {
        private Reservation reservation;
        private List<Table> tables;

        public ReservationWithTables(Reservation reservation, List<Table> tables) {
            this.reservation = reservation;
            this.tables = tables;
        }

        public Reservation getReservation() {
            return reservation;
        }

        public List<Table> getTables() {
            return tables;
        }
    }
}
