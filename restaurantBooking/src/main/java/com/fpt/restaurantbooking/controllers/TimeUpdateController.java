package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.models.Promotions;
import com.fpt.restaurantbooking.models.TimeSlot;
import com.fpt.restaurantbooking.models.User;
import com.fpt.restaurantbooking.models.WorkSchedule;
import com.fpt.restaurantbooking.repositories.impl.TimeRepository;
import com.fpt.restaurantbooking.repositories.impl.UserDao;
import com.fpt.restaurantbooking.repositories.impl.VoucherRepository;
import com.fpt.restaurantbooking.repositories.impl.WorkScheduleDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

@WebServlet(name = "TimeUpdateController", urlPatterns = {"/TimeUpdate"})
public class TimeUpdateController extends HttpServlet {





    /**
     * @author Quandxnunxi28
     */


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
String updated_by = request.getParameter("updated_by");
String morning_start_time= request.getParameter("morning_start_time");
String morning_end_time = request.getParameter("morning_end_time");
String afternoon_start_time = request.getParameter("afternoon_start_time");
String afternoon_end_time = request.getParameter("afternoon_end_time");
String evening_start_time = request.getParameter("evening_start_time");
String evening_end_time = request.getParameter("evening_end_time");
String slot_description= request.getParameter("slot_description");
String applicable_date= request.getParameter("applicable_date");
            String category_name= request.getParameter("category_name");
            TimeRepository timeDAO= new TimeRepository();
            try {
                if (slot_description == null || slot_description.trim().isEmpty()) {
                    request.setAttribute("errorEdit", "Mô tả không được để trống!");

                    // Duy trì dữ liệu để modal hiển thị lại
                    request.setAttribute("openEditModal", true);
                    request.setAttribute("slot_id", slot_id);
                    request.setAttribute("slot_description", slot_description);
                    request.setAttribute("morning_start_time", morning_start_time);
                    request.setAttribute("morning_end_time", morning_end_time);
                    request.setAttribute("afternoon_start_time", afternoon_start_time);
                    request.setAttribute("afternoon_end_time", afternoon_end_time);
                    request.setAttribute("evening_start_time", evening_start_time);
                    request.setAttribute("evening_end_time", evening_end_time);
                    request.setAttribute("category_name", category_name);
                    request.setAttribute("applicable_date", applicable_date);
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
                timeDAO.UpdateTimeSlott(slot_id, updated_by, morning_start_time, morning_end_time,afternoon_start_time,afternoon_end_time, evening_start_time,evening_end_time, slot_description);

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

                int totalItems = timeDAO.countTimeSlots();
                int totalPages = (int) Math.ceil((double) totalItems / pageSize);

                // Lấy dữ liệu trang hiện tại
                List<TimeSlot> timeSlots = timeRepository.getTimeSlotPage(page, pageSize);

                // Gửi sang JSP
                request.setAttribute("timeSlots", timeSlots);
                request.setAttribute("currentPage", page);
                request.setAttribute("totalPages", totalPages);;
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






    /**
     * Xử lý thêm lịch làm việc mới
     */





