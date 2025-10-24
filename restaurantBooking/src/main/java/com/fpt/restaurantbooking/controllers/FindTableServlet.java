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
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/findTable")
public class FindTableServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(FindTableServlet.class);
    private TableDAO tableDAO = new TableDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Hiển thị form tìm bàn
        request.getRequestDispatcher("/WEB-INF/BookTable/findTable.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        try {
            // Lấy thông tin từ form
            String dateStr = request.getParameter("date");
            String timeStr = request.getParameter("time");
            String guestCountStr = request.getParameter("guests");
            String floorStr = request.getParameter("floor");
            String specialRequest = request.getParameter("specialRequest");
            String eventType = request.getParameter("eventType");
            String promotion = request.getParameter("promotion");

            // Kiểm tra hợp lệ
            if (dateStr == null || dateStr.isEmpty()
                    || timeStr == null || timeStr.isEmpty()
                    || guestCountStr == null || guestCountStr.isEmpty()) {
                request.setAttribute("errorMessage", "Vui lòng nhập đầy đủ thông tin.");
                request.getRequestDispatcher("/WEB-INF/BookTable/findTable.jsp").forward(request, response);
                return;
            }

            LocalDate reservationDate = LocalDate.parse(dateStr);
            LocalTime reservationTime = LocalTime.parse(timeStr);
            int guestCount = Integer.parseInt(guestCountStr);
            int floor = (floorStr != null && !floorStr.isEmpty()) ? Integer.parseInt(floorStr) : 1;

            // Kiểm tra ngày
            if (reservationDate.isBefore(LocalDate.now())) {
                request.setAttribute("errorMessage", "Ngày đặt bàn không được là ngày quá khứ.");
                request.getRequestDispatcher("/WEB-INF/BookTable/findTable.jsp").forward(request, response);
                return;
            }

            // ✅ Lưu thông tin vào session (dùng cho bước chọn bàn)
            session.setAttribute("requiredDate", dateStr);
            session.setAttribute("requiredTime", timeStr);
            session.setAttribute("guestCount", guestCount);
            session.setAttribute("floor", floor);
            session.setAttribute("specialRequest", specialRequest);
            session.setAttribute("eventType", eventType);
            session.setAttribute("promotion", promotion);

            // ✅ Lấy danh sách bàn trống
            List<Table> availableTables = tableDAO.getAvailableTablesByCapacity(guestCount, floor);
            if (availableTables.isEmpty()) {
                request.setAttribute("errorMessage", "Không có bàn trống phù hợp với yêu cầu của bạn.");
            }

            // Map dữ liệu bàn
            Map<Integer, Map<String, Object>> tableStatusMap = new HashMap<>();
            for (Table table : tableDAO.getAllTables()) {
                Map<String, Object> info = new HashMap<>();
                info.put("status", "available");
                info.put("capacity", table.getCapacity());
                info.put("floor", table.getFloor());
                info.put("match", table.getCapacity() >= guestCount && table.getFloor() == floor);
                tableStatusMap.put(table.getTableId(), info);
            }

            request.setAttribute("tableStatusMap", tableStatusMap);
            request.setAttribute("requiredDate", dateStr);
            request.setAttribute("requiredTime", timeStr);
            request.setAttribute("guestCount", guestCount);

            // ✅ Chuyển sang trang chọn bàn
            request.getRequestDispatcher("/WEB-INF/BookTable/mapTable.jsp").forward(request, response);

        } catch (Exception e) {
            logger.error("Error in FindTableServlet", e);
            request.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/BookTable/findTable.jsp").forward(request, response);
        }
    }
}
