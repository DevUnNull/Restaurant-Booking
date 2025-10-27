package com.fpt.restaurantbooking.controllers;

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

@WebServlet("/removeTable")
public class RemoveTableServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(RemoveTableServlet.class);

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
