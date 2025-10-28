package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.models.Table;
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

@WebServlet("/addTable")
public class AddTableServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(AddTableServlet.class);
    private TableDAO tableDAO = new TableDAO();

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
