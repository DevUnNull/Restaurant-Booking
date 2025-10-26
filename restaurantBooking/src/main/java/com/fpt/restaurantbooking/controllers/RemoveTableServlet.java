package com.fpt.restaurantbooking.controllers;

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

@WebServlet("/removeTable")
public class RemoveTableServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(RemoveTableServlet.class);
    private ReservationTableDAO reservationTableDAO = new ReservationTableDAO();
    private TableDAO tableDAO = new TableDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        response.setContentType("application/json;charset=UTF-8");

        try {
            Integer reservationId = (Integer) session.getAttribute("reservationId");
            String tableIdStr = request.getParameter("tableId");

            if (reservationId == null) {
                response.getWriter().write("{\"success\": false, \"message\": \"Không có đơn đặt bàn\"}");
                return;
            }

            if (tableIdStr == null || tableIdStr.isEmpty()) {
                response.getWriter().write("{\"success\": false, \"message\": \"Thiếu thông tin bàn\"}");
                return;
            }

            int tableId = Integer.parseInt(tableIdStr);

            logger.info(">>> Removing table {} from reservation {}", tableId, reservationId);

            // Xóa bàn khỏi đơn đặt bàn
            boolean success = reservationTableDAO.removeTableFromReservation(reservationId, tableId);

            if (success) {
                // Cập nhật trạng thái bàn thành AVAILABLE
                tableDAO.updateTableStatus(tableId, "AVAILABLE");
                logger.info("✅ Removed table {} from reservation {}", tableId, reservationId);
                response.getWriter().write("{\"success\": true, \"message\": \"Xóa bàn thành công\"}");
            } else {
                logger.error("❌ Failed to remove table from reservation");
                response.getWriter().write("{\"success\": false, \"message\": \"Lỗi khi xóa bàn\"}");
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
