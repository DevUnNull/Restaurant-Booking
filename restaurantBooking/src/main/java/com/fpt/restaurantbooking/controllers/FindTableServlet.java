package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.models.Reservation;
import com.fpt.restaurantbooking.models.Table;
import com.fpt.restaurantbooking.repositories.impl.ReservationDAO;
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
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/findTable")
public class FindTableServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(FindTableServlet.class);
    private ReservationDAO reservationDAO = new ReservationDAO();
    private TableDAO tableDAO = new TableDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Forward to findTable.jsp
        request.getRequestDispatcher("/WEB-INF/BookTable/findTable.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        try {
            // Get parameters
            String dateStr = request.getParameter("date");
            String timeStr = request.getParameter("time");
            String guestCountStr = request.getParameter("guests");
            String floorStr = request.getParameter("floor");
            String specialRequest = request.getParameter("specialRequest");
            String eventType = request.getParameter("eventType");
            String promotion = request.getParameter("promotion");

            // Validate input
            if (dateStr == null || dateStr.isEmpty() || timeStr == null || timeStr.isEmpty() || guestCountStr == null) {
                request.setAttribute("errorMessage", "Vui lòng nhập đầy đủ thông tin");
                request.getRequestDispatcher("/WEB-INF/BookTable/findTable.jsp").forward(request, response);
                return;
            }

            LocalDate reservationDate = LocalDate.parse(dateStr);
            LocalTime reservationTime = LocalTime.parse(timeStr);
            int guestCount = Integer.parseInt(guestCountStr);
            int floor = floorStr != null && !floorStr.isEmpty() ? Integer.parseInt(floorStr) : 1;

            // Validate date (cannot be in the past)
            if (reservationDate.isBefore(LocalDate.now())) {
                request.setAttribute("errorMessage", "Ngày đặt bàn không được là ngày quá khứ");
                request.getRequestDispatcher("/WEB-INF/BookTable/findTable.jsp").forward(request, response);
                return;
            }

            // Store in session
            session.setAttribute("requiredDate", dateStr);
            session.setAttribute("requiredTime", timeStr);
            session.setAttribute("guestCount", guestCount);
            session.setAttribute("floor", floor);
            session.setAttribute("specialRequest", specialRequest);
            session.setAttribute("eventType", eventType);
            session.setAttribute("promotion", promotion);

            // Create a new reservation with PENDING status
            Reservation reservation = new Reservation(0, (Integer) session.getAttribute("userId"), 0, guestCount,
                    null, "PENDING", guestCount);
            reservation.setReservationDate(reservationDate);
            reservation.setReservationTime(reservationTime);
            reservation.setSpecialRequests(specialRequest);

            int reservationId = reservationDAO.createReservation(reservation);
            if (reservationId > 0) {
                session.setAttribute("reservationId", reservationId);

                // Get available tables
                List<Table> availableTables = tableDAO.getAvailableTablesByCapacity(guestCount, floor);

                if (availableTables.isEmpty()) {
                    request.setAttribute("errorMessage", "Không có bàn trống phù hợp với yêu cầu của bạn");
                }

                // Build table status map for frontend
                Map<Integer, Map<String, Object>> tableStatusMap = new HashMap<>();
                for (Table table : tableDAO.getAllTables()) {
                    Map<String, Object> tableInfo = new HashMap<>();
                    tableInfo.put("status", "available");
                    tableInfo.put("capacity", table.getCapacity());
                    tableInfo.put("floor", table.getFloor());
                    tableInfo.put("match", table.getCapacity() >= guestCount && table.getFloor() == floor);
                    tableStatusMap.put(table.getTableId(), tableInfo);
                }

                request.setAttribute("tableStatusMap", tableStatusMap);
                request.setAttribute("requiredDate", dateStr);
                request.setAttribute("requiredTime", timeStr);
                request.setAttribute("guestCount", guestCount);

                request.getRequestDispatcher("/WEB-INF/BookTable/mapTable.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Lỗi khi tạo đơn đặt bàn");
                request.getRequestDispatcher("/WEB-INF/BookTable/findTable.jsp").forward(request, response);
            }

        } catch (Exception e) {
            logger.error("Error in FindTableServlet", e);
            request.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/BookTable/findTable.jsp").forward(request, response);
        }
    }
}