package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.models.WorkSchedule;
import com.fpt.restaurantbooking.repositories.impl.WorkScheduleRepositoryImpl;
import com.fpt.restaurantbooking.utils.DatabaseUtil;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@WebServlet(name = "WorkScheduleController", urlPatterns = {"/WorkSchedule"})
public class WorkScheduleController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try (Connection connection = DatabaseUtil.getConnection()) {
            WorkScheduleRepositoryImpl repo = new WorkScheduleRepositoryImpl();
            List<WorkSchedule> schedules = repo.findAll();
            request.setAttribute("schedules", schedules);
            request.getRequestDispatcher("/WEB-INF/StaffManage/WorkSchedule.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        request.setCharacterEncoding("UTF-8");
//        try (Connection connection = DatabaseUtil.getConnection()) {
//            WorkScheduleRepositoryImpl repo = new WorkScheduleRepositoryImpl(connection);
//            WorkSchedule w = new WorkSchedule();
//
//            w.setUserId(Integer.parseInt(request.getParameter("userId")));
//            w.setWorkDate(LocalDate.parse(request.getParameter("workDate")));
//            w.setShift(request.getParameter("shift"));
//            w.setStartTime(LocalTime.parse(request.getParameter("startTime")));
//            w.setEndTime(LocalTime.parse(request.getParameter("endTime")));
//            w.setWorkPosition(request.getParameter("position"));
//            w.setNotes(request.getParameter("notes"));
//            w.setStatus("CONFIRMED");
//            w.setAssignedBy(1); // giả định là Admin đang đăng nhập
//
//            repo.insert(w);
//
//            response.sendRedirect(request.getContextPath() + "/WorkSchedule");
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//    }
}
