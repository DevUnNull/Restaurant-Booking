
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
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

/**
 * @author Quandxnunxi28
 */
@WebServlet(name = "ManageTimeController", urlPatterns = {"/ManageTime"})
public class ManageTimeController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        try {
            TimeRepository timeRepository = new TimeRepository();

            int pageSize = 11; // mỗi trang 11 item
            int page = 1;

            // Lấy tham số ?page=... từ URL nếu có
            String pageParam = request.getParameter("page");
            if (pageParam != null) {
                try {
                    page = Integer.parseInt(pageParam);
                } catch (NumberFormatException ignored) { }
            }

            int totalItems = timeRepository.countTimeSlots();
            int totalPages = (int) Math.ceil((double) totalItems / pageSize);

            // Lấy dữ liệu trang hiện tại
            List<TimeSlot> timeSlots = timeRepository.getTimeSlotPage(page, pageSize);

            // Gửi sang JSP
            request.setAttribute("timeSlots", timeSlots);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);

            request.getRequestDispatcher("/WEB-INF/Time_slot/ManageSingleTime.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }













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
        String date= request.getParameter("applicable_date");

        DateTimeFormatter inputFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        LocalDate parsedDate = LocalDate.parse(date, inputFormatter);

        // Convert sang định dạng MySQL (thực ra vẫn là yyyy-MM-dd nên dòng này có thể bỏ)
        DateTimeFormatter mysqlFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        String mysqlDate = parsedDate.format(mysqlFormatter);
String updated_by =request.getParameter("updated_by");
        String morning_start_time =request.getParameter("morning_start_time");
        String morning_end_time =request.getParameter("morning_end_time");
        String afternoon_start_time =request.getParameter("afternoon_start_time");
        String afternoon_end_time =request.getParameter("afternoon_end_time");
        String evening_start_time =request.getParameter("evening_start_time");
        String evening_end_time =request.getParameter("evening_end_time");
        String slot_description = request.getParameter("slot_description");
TimeRepository timeRepository = new TimeRepository();
        try {
            if(slot_description.isEmpty() || slot_description==null){
                String er= "cột mô tả không được null";
                request.setAttribute("er", er);
                request.setAttribute("actionType", "EDIT"); // để popup mở đúng form

                request.setAttribute("applicable_date", mysqlDate);
                request.setAttribute("morning_start_time", morning_start_time);
                request.setAttribute("morning_end_time", morning_end_time);
                request.setAttribute("afternoon_start_time", afternoon_start_time);
                request.setAttribute("afternoon_end_time", afternoon_end_time);
                request.setAttribute("evening_start_time", evening_start_time);
                request.setAttribute("evening_end_time", evening_end_time);
                request.setAttribute("slot_description", slot_description);
                int pageSize = 11; // mỗi trang 11 item
                int page = 1;

                // Lấy tham số ?page=... từ URL nếu có
                String pageParam = request.getParameter("page");
                if (pageParam != null) {
                    try {
                        page = Integer.parseInt(pageParam);
                    } catch (NumberFormatException ignored) { }
                }

                int totalItems = timeRepository.countTimeSlots();
                int totalPages = (int) Math.ceil((double) totalItems / pageSize);

                // Lấy dữ liệu trang hiện tại
                List<TimeSlot> timeSlots = timeRepository.getTimeSlotPage(page, pageSize);

                // Gửi sang JSP
                request.setAttribute("timeSlots", timeSlots);
                request.setAttribute("currentPage", page);
                request.setAttribute("totalPages", totalPages);
                request.getRequestDispatcher("/WEB-INF/Time_slot/ManageSingleTime.jsp").forward(request, response);
                return;
            }
            TimeSlot tim = timeRepository.getTime(mysqlDate);
            String er= "ngày này là 1 ngày đã ằm trong danh sách";
            if(tim !=null){
                request.setAttribute("er", er);
                request.setAttribute("actionType", "EDIT"); // để popup mở đúng form
                int pageSize = 11; // mỗi trang 11 item
                int page = 1;

                // Lấy tham số ?page=... từ URL nếu có
                String pageParam = request.getParameter("page");
                if (pageParam != null) {
                    try {
                        page = Integer.parseInt(pageParam);
                    } catch (NumberFormatException ignored) { }
                }

                int totalItems = timeRepository.countTimeSlots();
                int totalPages = (int) Math.ceil((double) totalItems / pageSize);

                // Lấy dữ liệu trang hiện tại
                List<TimeSlot> timeSlots = timeRepository.getTimeSlotPage(page, pageSize);

                // Gửi sang JSP
                request.setAttribute("timeSlots", timeSlots);
                request.setAttribute("currentPage", page);
                request.setAttribute("totalPages", totalPages);

                request.setAttribute("applicable_date", mysqlDate);
                request.setAttribute("morning_start_time", morning_start_time);
                request.setAttribute("morning_end_time", morning_end_time);
                request.setAttribute("afternoon_start_time", afternoon_start_time);
                request.setAttribute("afternoon_end_time", afternoon_end_time);
                request.setAttribute("evening_start_time", evening_start_time);
                request.setAttribute("evening_end_time", evening_end_time);
                request.setAttribute("slot_description", slot_description);
                request.getRequestDispatcher("/WEB-INF/Time_slot/ManageSingleTime.jsp").forward(request, response);
                return;
            }
            timeRepository.insertEditTime(mysqlDate, slot_description,morning_start_time,morning_end_time,afternoon_start_time,afternoon_end_time,evening_start_time,evening_end_time , updated_by);
            int pageSize = 11; // mỗi trang 11 item
            int page = 1;

            // Lấy tham số ?page=... từ URL nếu có
            String pageParam = request.getParameter("page");
            if (pageParam != null) {
                try {
                    page = Integer.parseInt(pageParam);
                } catch (NumberFormatException ignored) { }
            }

            int totalItems = timeRepository.countTimeSlots();
            int totalPages = (int) Math.ceil((double) totalItems / pageSize);

            // Lấy dữ liệu trang hiện tại
            List<TimeSlot> timeSlots = timeRepository.getTimeSlotPage(page, pageSize);

            // Gửi sang JSP
            request.setAttribute("timeSlots", timeSlots);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);

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






