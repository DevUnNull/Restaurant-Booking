
package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.models.Promotions;
import com.fpt.restaurantbooking.models.TimeSlot;
import com.fpt.restaurantbooking.repositories.impl.TimeRepository;
import com.fpt.restaurantbooking.repositories.impl.VoucherRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * @author Quandxnunxi28
 */
@WebServlet(name = "TimeBlockController", urlPatterns = {"/TimeBlock"})
public class TimeBlockController extends HttpServlet {
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");





    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
String slot_id = request.getParameter("slot_id");
String slot_description = request.getParameter("slot_description");
String updated_by = request.getParameter("updated_by");
        TimeRepository timeDAO= new TimeRepository();
        try {
            if (slot_description == null || slot_description.trim().isEmpty()) {
                request.setAttribute("errorBlock", "Lý do (mô tả) không được để trống!");
                request.setAttribute("openBlockModal", true);
                request.setAttribute("slot_id", slot_id);
                request.setAttribute("slot_description", slot_description);
                // Load lại danh sách
                int pageSize = 11; // mỗi trang 11 item
                int page = 1;

                // Lấy tham số ?page=... từ URL nếu có
                String pageParam = request.getParameter("page");
                if (pageParam != null) {
                    try {
                        page = Integer.parseInt(pageParam);
                    } catch (NumberFormatException ignored) { }
                }

                int totalItems = timeDAO.countTimeSlots();
                int totalPages = (int) Math.ceil((double) totalItems / pageSize);

                // Lấy dữ liệu trang hiện tại
                List<TimeSlot> timeSlots = timeDAO.getTimeSlotPage(page, pageSize);

                // Gửi sang JSP
                request.setAttribute("timeSlots", timeSlots);
                request.setAttribute("currentPage", page);
                request.setAttribute("totalPages", totalPages);;

                request.getRequestDispatcher("/WEB-INF/Time_slot/ManageSingleTime.jsp")
                        .forward(request, response);
                return;
            }
            timeDAO.UpdateTimeSlottBlock(slot_id, updated_by, slot_description);
            List<TimeSlot> timeSlots = new ArrayList<>();
            TimeRepository timeRepository = new TimeRepository();
            timeSlots = timeRepository.getAllTimeSlot();
            request.setAttribute("timeSlots", timeSlots);
            request.getRequestDispatcher("/WEB-INF/Time_slot/ManageSingleTime.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}





