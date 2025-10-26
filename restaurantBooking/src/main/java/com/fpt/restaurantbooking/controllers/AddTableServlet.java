package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.models.Reservation;
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
import java.time.LocalDate;
import java.time.LocalTime;

@WebServlet("/addTable")
public class AddTableServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(AddTableServlet.class);
    private ReservationTableDAO reservationTableDAO = new ReservationTableDAO();
    private TableDAO tableDAO = new TableDAO();
    private ReservationDAO reservationDAO = new ReservationDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        response.setContentType("application/json;charset=UTF-8");

        try {
            Integer reservationId = (Integer) session.getAttribute("reservationId");
            String tableIdStr = request.getParameter("tableId");
            Integer userId = (Integer) session.getAttribute("userId");

            if (tableIdStr == null || tableIdStr.isEmpty()) {
                response.getWriter().write("{\"success\": false, \"message\": \"Thiếu thông tin bàn\"}");
                return;
            }

            int tableId = Integer.parseInt(tableIdStr);

            // 🔹 Nếu chưa có reservationId thì tạo mới Reservation
            if (reservationId == null) {
                String dateStr = (String) session.getAttribute("requiredDate");
                String timeStr = (String) session.getAttribute("requiredTime");
                Integer guestCount = (Integer) session.getAttribute("guestCount");
                String specialRequest = (String) session.getAttribute("specialRequest");

                if (userId == null) {
                    response.getWriter().write("{\"success\": false, \"message\": \"Vui lòng đăng nhập để đặt bàn\"}");
                    return;
                }

                if (dateStr == null || timeStr == null || guestCount == null) {
                    response.getWriter().write("{\"success\": false, \"message\": \"Thiếu thông tin đặt bàn\"}");
                    return;
                }

                LocalDate reservationDate = LocalDate.parse(dateStr);
                LocalTime reservationTime = LocalTime.parse(timeStr);

                // Tạo mới Reservation với trạng thái PENDING
                Reservation reservation = new Reservation(
                        0,
                        userId,
                        0,
                        guestCount,
                        null,
                        "PENDING",
                        guestCount
                );
                reservation.setReservationDate(reservationDate);
                reservation.setReservationTime(reservationTime);
                reservation.setSpecialRequests(specialRequest);

                int newReservationId = reservationDAO.createReservation(reservation);
                if (newReservationId <= 0) {
                    response.getWriter().write("{\"success\": false, \"message\": \"Không thể tạo đơn đặt bàn\"}");
                    return;
                }

                // Lưu vào session
                reservationId = newReservationId;
                session.setAttribute("reservationId", reservationId);
                logger.info("✅ Created new reservation with ID: {}", newReservationId);
            }

            // 🔹 Kiểm tra xem bàn đã nằm trong đơn chưa
            if (reservationTableDAO.isTableInReservation(reservationId, tableId)) {
                response.getWriter().write("{\"success\": false, \"message\": \"Bàn này đã được thêm vào đơn đặt\"}");
                return;
            }

            // 🔹 Thêm bàn vào Reservation
            boolean success = reservationTableDAO.addTableToReservation(reservationId, tableId);

            if (success) {
                // Cập nhật trạng thái bàn thành RESERVED
                tableDAO.updateTableStatus(tableId, "RESERVED");
                logger.info("✅ Added table {} to reservation {}", tableId, reservationId);
                response.getWriter().write("{\"success\": true, \"message\": \"Thêm bàn thành công\"}");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"Lỗi khi thêm bàn\"}");
            }

        } catch (NumberFormatException e) {
            logger.error("❌ Invalid table ID format", e);
            response.getWriter().write("{\"success\": false, \"message\": \"Mã bàn không hợp lệ\"}");
        } catch (Exception e) {
            logger.error("❌ Error in AddTableServlet", e);
            response.getWriter().write("{\"success\": false, \"message\": \"Có lỗi xảy ra trong quá trình thêm bàn\"}");
        }
    }
}
