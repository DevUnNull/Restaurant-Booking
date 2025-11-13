package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.models.User;
import com.fpt.restaurantbooking.models.WorkSchedule;
import com.fpt.restaurantbooking.repositories.impl.WorkScheduleDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.time.*;
import java.time.format.DateTimeFormatter;
import java.time.temporal.WeekFields;
import java.util.*;

@WebServlet("/WorkTimetable")
public class WorkTimetableController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int year = Optional.ofNullable(req.getParameter("year"))
                .map(Integer::parseInt)
                .orElse(LocalDate.now().getYear());

        int selectedWeek = Optional.ofNullable(req.getParameter("week"))
                .map(Integer::parseInt)
                .orElse(LocalDate.now().get(WeekFields.ISO.weekOfYear()));

        // Tính monday đúng chuẩn ISO week
        LocalDate monday = LocalDate.now()
                .withYear(year)
                .with(WeekFields.ISO.weekOfYear(), selectedWeek)
                .with(DayOfWeek.MONDAY);
        LocalDate sunday = monday.plusDays(6);

        // Lấy lịch từ DB
        WorkScheduleDAO dao = new WorkScheduleDAO();
        List<WorkSchedule> schedules = dao.getSchedulesByWeek(monday, sunday);

        System.out.println("DEBUG: week " + selectedWeek + " range: " + monday + " -> " + sunday);
        System.out.println("DEBUG: schedules fetched = " + (schedules == null ? 0 : schedules.size()));
        if (schedules != null) {
            for (WorkSchedule ws : schedules) {
                System.out.println("  SCHEDULE: " + ws.getWorkDate() + " user=" + (ws.getUser() == null ? "null" : ws.getUser().getFullName()));
            }
        }

        // Tạo danh sách ngày của tuần (dưới dạng chuỗi yyyy-MM-dd) để JSP dễ dùng
        List<String> weekDates = new ArrayList<>();
        DateTimeFormatter isoFmt = DateTimeFormatter.ISO_LOCAL_DATE; // yyyy-MM-dd
        for (int i = 0; i < 7; i++) {
            weekDates.add(monday.plusDays(i).format(isoFmt));
        }

        // Group schedules theo key = workDate.toString() (yyyy-MM-dd)
        Map<String, List<WorkSchedule>> scheduleMap = new HashMap<>();
        if (schedules != null) {
            for (WorkSchedule ws : schedules) {
                String key = ws.getWorkDate().toString(); // LocalDate -> "yyyy-MM-dd"
                scheduleMap.computeIfAbsent(key, k -> new ArrayList<>()).add(ws);
            }
        }

        // Tạo weekOptions (giữ nguyên)
        List<Map<String, Object>> weekOptions = new ArrayList<>();
        LocalDate firstMonday = LocalDate.of(year, 1, 1)
                .with(WeekFields.ISO.weekOfYear(), 1)
                .with(DayOfWeek.MONDAY);
        for (int w = 1; w <= 52; w++) {
            LocalDate start = firstMonday.plusWeeks(w - 1);
            LocalDate end = start.plusDays(6);
            Map<String, Object> option = new HashMap<>();
            option.put("value", w);
            option.put("label", start.format(DateTimeFormatter.ofPattern("dd/MM")) +
                    " To " + end.format(DateTimeFormatter.ofPattern("dd/MM")));
            weekOptions.add(option);
        }

        req.setAttribute("year", year);
        req.setAttribute("selectedWeek", selectedWeek);
        req.setAttribute("weekOptions", weekOptions);
        req.setAttribute("monday", monday);
        req.setAttribute("sunday", sunday);
        req.setAttribute("schedules", schedules); // optional debug
        req.setAttribute("weekDates", weekDates);
        req.setAttribute("scheduleMap", scheduleMap);

        req.getRequestDispatcher("/WEB-INF/StaffManage/WorkTimetable.jsp").forward(req, resp);
    }

}

