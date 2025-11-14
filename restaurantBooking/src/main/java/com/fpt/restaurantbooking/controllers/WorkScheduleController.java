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
import java.util.Comparator;
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
        } else if ("cancel".equalsIgnoreCase(action)) {
            handleDeleteSchedule(request, response);
        } else if ("confirm".equalsIgnoreCase(action)) {
            handleConfirmSchedule(request, response);
        } else if ("edit".equalsIgnoreCase(action)) {
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

            // Ẩn CANCELLED
//            schedules.removeIf(ws -> "CANCELLED".equalsIgnoreCase(ws.getStatus()));

            // Lấy danh sách nhân viên
            List<User> staffList = userDao.findAllStaff();

            // === Lọc theo Nhân viên ===
            String userIdParam = request.getParameter("userId");
            if (userIdParam != null && !userIdParam.isEmpty()) {
                int userIdFilter = Integer.parseInt(userIdParam);
                schedules.removeIf(ws -> ws.getUser() == null || ws.getUser().getUserId() != userIdFilter);
            }

            // === Lọc theo khoảng ngày ===
            String startDateParam = request.getParameter("startDate");
            String endDateParam = request.getParameter("endDate");
            if (startDateParam != null && !startDateParam.isEmpty() &&
                    endDateParam != null && !endDateParam.isEmpty()) {

                LocalDate start = LocalDate.parse(startDateParam);
                LocalDate end = LocalDate.parse(endDateParam);
                schedules.removeIf(ws -> ws.getWorkDate().isBefore(start) || ws.getWorkDate().isAfter(end));
            }

            // === Sắp xếp theo scheduleId ===
            String sortOrder = request.getParameter("sortOrder");
            if ("asc".equalsIgnoreCase(sortOrder)) {
                schedules.sort(Comparator.comparingInt(WorkSchedule::getScheduleId));
            } else if ("desc".equalsIgnoreCase(sortOrder)) {
                schedules.sort(Comparator.comparingInt(WorkSchedule::getScheduleId).reversed());
            }

            // === Lọc theo ca làm ===
            String shiftParam = request.getParameter("shift");
            if (shiftParam != null && !shiftParam.isEmpty()) {
                schedules.removeIf(ws -> ws.getShift() == null || !ws.getShift().equalsIgnoreCase(shiftParam));
            }

            // Phân trang
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

            HttpSession session = request.getSession();
            session.setAttribute("successMessage", "Thêm lịch làm việc thành công!");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Thêm lịch thất bại. Vui lòng thử lại.");
        }

        response.sendRedirect(request.getContextPath() + "/WorkSchedule");
    }

    /**
     * Xử lý Hủy lịch làm việc (đổi trạng thái sang CANCELLED)
     */
    private void handleDeleteSchedule(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int scheduleId = Integer.parseInt(request.getParameter("scheduleId"));
            WorkSchedule existing = workScheduleDao.getWorkScheduleById(scheduleId);

            if (existing == null) {
                request.getSession().setAttribute("errorMessage", "Lịch làm việc không tồn tại.");
            } else if ("CANCELLED".equalsIgnoreCase(existing.getStatus())) {
                request.getSession().setAttribute("errorMessage", "Lịch này đã bị hủy trước đó.");
            } else if ("CONFIRMED".equalsIgnoreCase(existing.getStatus())) {
                request.getSession().setAttribute("errorMessage", "Lịch này đã được xác nhận, không thể hủy.");
            } else {
                workScheduleDao.updateStatus(scheduleId, "CANCELLED");
                request.getSession().setAttribute("successMessage", "Hủy thành công!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Lỗi khi hủy lịch làm việc.");
        }

        response.sendRedirect(request.getContextPath() + "/WorkSchedule");
    }


    /**
     * Xử lý Xác nhận lịch làm việc (đổi trạng thái sang CONFIRMED)
     */
    private void handleConfirmSchedule(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int scheduleId = Integer.parseInt(request.getParameter("scheduleId"));
            WorkSchedule existing = workScheduleDao.getWorkScheduleById(scheduleId);

            if (existing == null) {
                request.getSession().setAttribute("errorMessage", "Lịch làm việc không tồn tại.");
            } else if ("CONFIRMED".equalsIgnoreCase(existing.getStatus())) {
                request.getSession().setAttribute("errorMessage", "Lịch này đã được xác nhận trước đó.");
            } else if ("CANCELLED".equalsIgnoreCase(existing.getStatus())) {
                request.getSession().setAttribute("errorMessage", "Lịch này đã bị hủy, không thể xác nhận.");
            } else {
                workScheduleDao.updateStatus(scheduleId, "CONFIRMED");
                request.getSession().setAttribute("successMessage", "Xác nhận thành công!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Lỗi khi xác nhận lịch làm việc.");
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

            HttpSession session = request.getSession();
            session.setAttribute("successMessage", "Cập nhật thành công!");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Cập nhật không thành công!");
        }

        response.sendRedirect(request.getContextPath() + "/WorkSchedule");
    }

}
