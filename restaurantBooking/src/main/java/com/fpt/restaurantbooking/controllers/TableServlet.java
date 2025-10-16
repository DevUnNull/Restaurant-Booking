package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.services.TableService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeParseException;
import java.util.Map;

@WebServlet(name = "findTableMap", urlPatterns = {"/findTableMap"})
public class TableServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(TableServlet.class);
    private final TableService tableService = new TableService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 🔹 Lấy giá trị từ form
        String dateParam = request.getParameter("date");
        String timeParam = request.getParameter("time");
        String guestsParam = request.getParameter("guests");
        String specialRequest = request.getParameter("specialRequest");

        LocalDate requiredDate = null;
        LocalTime requiredTime = null;
        int guestCount = 0;
        String errorMessage = null;

        try {
            if (dateParam != null && !dateParam.isEmpty()) {
                requiredDate = LocalDate.parse(dateParam);
            }
            if (timeParam != null && !timeParam.isEmpty()) {
                requiredTime = LocalTime.parse(timeParam);
            }
            if (guestsParam != null && !guestsParam.isEmpty()) {
                guestCount = Integer.parseInt(guestsParam);
            }
        } catch (DateTimeParseException | NumberFormatException e) {
            errorMessage = "Invalid date, time, or guest count format.";
            logger.error("Parameter parsing failed", e);
        }

        Map<Integer, Map<String, Object>> tableStatusMap = null;
        if (errorMessage == null && requiredDate != null && requiredTime != null && guestCount > 0) {
            tableStatusMap = tableService.findAvailableTables(requiredDate, requiredTime, guestCount);
        } else {
            errorMessage = (errorMessage != null) ? errorMessage : "Please provide valid search criteria.";
        }

        // Lưu vào session
        HttpSession session = request.getSession();
        session.setAttribute("requiredDate", dateParam);
        session.setAttribute("requiredTime", timeParam);
        session.setAttribute("guestCount", guestCount);
        session.setAttribute("specialRequest", specialRequest);

        // (tùy chọn) Nếu muốn lưu luôn kết quả tìm bàn
        session.setAttribute("tableStatusMap", tableStatusMap);

        // Cũng vẫn lưu vào request để hiển thị ngay ở JSP
        request.setAttribute("tableStatusMap", tableStatusMap);
        request.setAttribute("errorMessage", errorMessage);
        request.setAttribute("requiredDate", dateParam);
        request.setAttribute("requiredTime", timeParam);
        request.setAttribute("guestCount", guestCount);
        request.setAttribute("specialRequest", specialRequest);

        request.getRequestDispatcher("/WEB-INF/BookTable/mapTable.jsp").forward(request, response);
    }
}
