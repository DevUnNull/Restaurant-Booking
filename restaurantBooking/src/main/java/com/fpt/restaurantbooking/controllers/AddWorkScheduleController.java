package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.models.WorkSchedule;
import com.fpt.restaurantbooking.repositories.impl.WorkScheduleRepositoryImpl;
import com.fpt.restaurantbooking.utils.DatabaseUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.time.LocalDate;
import java.time.LocalTime;

@WebServlet(name = "AddWorkScheduleController", urlPatterns = {"/AddWorkSchedule"})
public class AddWorkScheduleController extends HttpServlet {

    private WorkScheduleRepositoryImpl workScheduleRepo;

    @Override
    public void init() throws ServletException {
        DatabaseUtil db = new DatabaseUtil();
        try {
            Connection con = db.getConnection();
            workScheduleRepo = new WorkScheduleRepositoryImpl();
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Không thể kết nối cơ sở dữ liệu!", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            request.setCharacterEncoding("UTF-8");

            // Lấy dữ liệu từ form
            int userId = Integer.parseInt(request.getParameter("userId"));
            LocalDate workDate = LocalDate.parse(request.getParameter("workDate"));
            String shift = request.getParameter("shift");
            LocalTime startTime = LocalTime.parse(request.getParameter("startTime"));
            LocalTime endTime = LocalTime.parse(request.getParameter("endTime"));
            String workPosition = request.getParameter("workPosition");
            String notes = request.getParameter("notes");

            //  Lấy người tạo lịch (giả sử đang đăng nhập)
            HttpSession session = request.getSession();
            Integer assignedBy = (Integer) session.getAttribute("userId");
            if (assignedBy == null) assignedBy = 1; // fallback nếu chưa đăng nhập

            //  Tạo đối tượng WorkSchedule
            WorkSchedule ws = new WorkSchedule();
            ws.setUserId(userId);
            ws.setWorkDate(workDate);
            ws.setShift(shift);
            ws.setStartTime(startTime);
            ws.setEndTime(endTime);
            ws.setWorkPosition(workPosition);
            ws.setNotes(notes);
            ws.setStatus("Active");
            ws.setAssignedBy(assignedBy);
            String stng = ws.toString();
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().println(stng);

            //  Thêm vào DB
            boolean success = workScheduleRepo.insert(ws);

            if (success) {
                request.getSession().setAttribute("message", "Thêm lịch làm việc thành công!");
            } else {
                request.getSession().setAttribute("error", "Thêm lịch làm việc thất bại!");
            }

            //  Quay lại trang danh sách
            response.sendRedirect("WorkSchedule");

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Lỗi: " + e.getMessage());
            response.sendRedirect("WorkSchedule");
        }
    }
}