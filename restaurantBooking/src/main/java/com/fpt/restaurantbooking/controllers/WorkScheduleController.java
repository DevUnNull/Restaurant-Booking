package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.models.User;
import com.fpt.restaurantbooking.models.WorkSchedule;
import com.fpt.restaurantbooking.repositories.impl.UserDao;
import com.fpt.restaurantbooking.repositories.impl.WorkScheduleDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@WebServlet(name = "WorkSchedule", urlPatterns = {"/WorkSchedule"})
public class WorkScheduleController extends HttpServlet {

    private WorkScheduleDAO workScheduleDao;
    private UserDao userDao;

    @Override
    public void init() throws ServletException {
        workScheduleDao = new WorkScheduleDAO();
        userDao = new UserDao();
    }

    // ===================== MAIN REQUESTS =====================

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        showWorkScheduleList(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("add".equalsIgnoreCase(action)) {
            handleAddSchedule(request, response);
        } else if ("delete".equalsIgnoreCase(action)) {
            handleDeleteSchedule(request, response);
        }else if ("edit".equalsIgnoreCase(action)) {
            handleEditSchedule(request, response);
        } else {
            showWorkScheduleList(request, response);
        }
    }

    // ===================== HANDLER METHODS =====================

    /**
     * Hiển thị danh sách lịch làm việc (có phân trang, loại bỏ CANCELLED)
     */
    private void showWorkScheduleList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<WorkSchedule> schedules = workScheduleDao.getAllWorkSchedules();

            // Ẩn những lịch có trạng thái CANCELLED
            schedules.removeIf(ws -> "CANCELLED".equalsIgnoreCase(ws.getStatus()));

            // Lấy danh sách nhân viên để hiển thị trong popup
            List<User> staffList = userDao.findAllStaff();

            // Xử lý phân trang
            int page = 1;
            int recordsPerPage = 10;
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

            // Gửi sang JSP
            request.setAttribute("schedules", pageList);
            request.setAttribute("staffList", staffList);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);

            request.getRequestDispatcher("/WEB-INF/StaffManage/WorkSchedule.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể tải danh sách lịch làm việc!");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    /**
     * Xử lý thêm lịch làm việc mới
     */
    private void handleAddSchedule(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            LocalDate workDate = LocalDate.parse(request.getParameter("workDate"));
            String shift = request.getParameter("shift");
            LocalTime startTime = LocalTime.parse(request.getParameter("startTime"));
            LocalTime endTime = LocalTime.parse(request.getParameter("endTime"));
            String workPosition = request.getParameter("workPosition");
            String notes = request.getParameter("notes");

            User user = new User();
            user.setUserId(userId);

            WorkSchedule ws = new WorkSchedule(null, user, workDate, shift, startTime, endTime, workPosition, notes, "TENTATIVE");

            workScheduleDao.addWorkSchedule(ws);
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/WorkSchedule");
    }

    /**
     * Xử lý xóa lịch làm việc (đổi trạng thái sang CANCELLED)
     */
    private void handleDeleteSchedule(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int scheduleId = Integer.parseInt(request.getParameter("scheduleId"));
            workScheduleDao.updateStatus(scheduleId, "CANCELLED");
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/WorkSchedule");
    }

    /**
     * Xử lý sửa lịch làm việc
     */
    private void handleEditSchedule(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int scheduleId = Integer.parseInt(request.getParameter("scheduleId"));
            int userId = Integer.parseInt(request.getParameter("userId"));
            LocalDate workDate = LocalDate.parse(request.getParameter("workDate"));
            String shift = request.getParameter("shift");
            LocalTime startTime = LocalTime.parse(request.getParameter("startTime"));
            LocalTime endTime = LocalTime.parse(request.getParameter("endTime"));
            String workPosition = request.getParameter("workPosition");
            String notes = request.getParameter("notes");

            WorkSchedule existing = workScheduleDao.getWorkScheduleById(scheduleId);
            String currentStatus = existing != null ? existing.getStatus() : "TENTATIVE";

            User user = new User();
            user.setUserId(userId);

            WorkSchedule ws = new WorkSchedule(scheduleId, user, workDate, shift, startTime, endTime, workPosition, notes, currentStatus);

            workScheduleDao.updateWorkSchedule(ws);
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/WorkSchedule");
    }

}
