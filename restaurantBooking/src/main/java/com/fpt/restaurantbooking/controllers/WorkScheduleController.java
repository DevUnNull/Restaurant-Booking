package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.models.User;
import com.fpt.restaurantbooking.models.WorkSchedule;
import com.fpt.restaurantbooking.repositories.impl.WorkScheduleDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "WorkSchedule", urlPatterns = {"/WorkSchedule"})
public class WorkScheduleController extends HttpServlet {

    private WorkScheduleDAO workScheduleDao;

    @Override
    public void init() throws ServletException {
        workScheduleDao = new WorkScheduleDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Lấy danh sách lịch làm việc
            List<WorkSchedule> schedules = workScheduleDao.getAllWorkSchedules();

            // Xử lý phân trang
            int page = 1;
            int recordsPerPage = 10; // mỗi trang 10 dòng
            String pageParam = request.getParameter("page");
            if (pageParam != null) {
                try {
                    page = Integer.parseInt(pageParam);
                } catch (NumberFormatException ignored) {}
            }

            int totalRecords = schedules.size();
            int start = (page - 1) * recordsPerPage;
            int end = Math.min(start + recordsPerPage, totalRecords);

            List<WorkSchedule> pageList = schedules.subList(start, end);
            int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

            // Gửi danh sách sang JSP
            request.setAttribute("schedules", pageList);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);

            request.getRequestDispatcher("/WEB-INF/StaffManage/WorkSchedule.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể tải danh sách lịch làm việc!");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

