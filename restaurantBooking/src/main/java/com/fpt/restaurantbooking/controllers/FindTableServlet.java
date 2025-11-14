package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.models.Table;
import com.fpt.restaurantbooking.models.Service;
import com.fpt.restaurantbooking.models.TimeSlot;
import com.fpt.restaurantbooking.repositories.impl.TableDAO;
import com.fpt.restaurantbooking.repositories.impl.ServiceRepository;
import com.fpt.restaurantbooking.repositories.impl.TimeRepository;
import com.fpt.restaurantbooking.repositories.impl.ReservationDAO;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/findTable")
public class FindTableServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(FindTableServlet.class);
    private final TableDAO tableDAO = new TableDAO();
    private final ServiceRepository serviceRepository = new ServiceRepository();
    private final TimeRepository timeRepository = new TimeRepository();
    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final ObjectMapper objectMapper = new ObjectMapper();

    /**
     * ✅ Helper method: Load active services và set vào request
     */
    private void loadActiveServices(HttpServletRequest request) {
        try {
            List<Service> activeServices = serviceRepository.getActiveServices();
            request.setAttribute("activeServices", activeServices);
            logger.debug("Loaded {} active services", activeServices != null ? activeServices.size() : 0);
        } catch (SQLException e) {
            logger.error("Error loading active services", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        logger.debug("FindTableServlet doGet called, request URI: {}", request.getRequestURI());
        
        // Kiểm tra nếu là request lấy TimeSlot (AJAX)
        String dateParam = request.getParameter("date");
        if (dateParam != null && !dateParam.isEmpty()) {
            logger.debug("AJAX request for date: {}", dateParam);
            try {
                TimeSlot timeSlot = timeRepository.getTime(dateParam);
                Map<String, Object> slotData = new HashMap<>();
                
                if (timeSlot != null) {
                    // Có dữ liệu trong DB
                    slotData.put("exists", true);
                    slotData.put("categoryId", timeSlot.getCategory_id());
                    slotData.put("description", timeSlot.getDescription());
                    
                    // Kiểm tra slot nào bị block (tất cả thời gian = null)
                    boolean morningBlocked = timeSlot.getMorning_start_time() == null || 
                                           timeSlot.getMorning_end_time() == null;
                    boolean afternoonBlocked = timeSlot.getAfternoon_start_time() == null || 
                                             timeSlot.getAfternoon_end_time() == null;
                    boolean eveningBlocked = timeSlot.getEvening_start_time() == null || 
                                           timeSlot.getEvening_end_time() == null;
                    
                    // Slot Sáng
                    Map<String, Object> morning = new HashMap<>();
                    morning.put("available", !morningBlocked);
                    morning.put("startTime", timeSlot.getMorning_start_time());
                    morning.put("endTime", timeSlot.getMorning_end_time());
                    morning.put("blocked", morningBlocked);
                    slotData.put("morning", morning);
                    
                    // Slot Chiều
                    Map<String, Object> afternoon = new HashMap<>();
                    afternoon.put("available", !afternoonBlocked);
                    afternoon.put("startTime", timeSlot.getAfternoon_start_time());
                    afternoon.put("endTime", timeSlot.getAfternoon_end_time());
                    afternoon.put("blocked", afternoonBlocked);
                    slotData.put("afternoon", afternoon);
                    
                    // Slot Tối
                    Map<String, Object> evening = new HashMap<>();
                    evening.put("available", !eveningBlocked);
                    evening.put("startTime", timeSlot.getEvening_start_time());
                    evening.put("endTime", timeSlot.getEvening_end_time());
                    evening.put("blocked", eveningBlocked);
                    slotData.put("evening", evening);
                    
                    // Có slot đặc biệt hoặc bị block không?
                    boolean hasSpecial = timeSlot.getCategory_id() == 2 || timeSlot.getCategory_id() == 3;
                    slotData.put("hasWarning", hasSpecial);
                } else {
                    // Không có trong DB, dùng mặc định (NORMAL)
                    slotData.put("exists", false);
                    slotData.put("categoryId", 1);
                    slotData.put("hasWarning", false);
                    
                    // Slot mặc định
                    Map<String, Object> morning = new HashMap<>();
                    morning.put("available", true);
                    morning.put("startTime", "08:00:00");
                    morning.put("endTime", "11:30:00");
                    morning.put("blocked", false);
                    slotData.put("morning", morning);
                    
                    Map<String, Object> afternoon = new HashMap<>();
                    afternoon.put("available", true);
                    afternoon.put("startTime", "12:00:00");
                    afternoon.put("endTime", "17:00:00");
                    afternoon.put("blocked", false);
                    slotData.put("afternoon", afternoon);
                    
                    Map<String, Object> evening = new HashMap<>();
                    evening.put("available", true);
                    evening.put("startTime", "18:00:00");
                    evening.put("endTime", "21:00:00");
                    evening.put("blocked", false);
                    slotData.put("evening", evening);
                }
                
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                PrintWriter out = response.getWriter();
                out.print(objectMapper.writeValueAsString(slotData));
                out.flush();
                return;
            } catch (Exception e) {
                logger.error("Error getting time slot", e);
                try {
                    // Return default slots on error
                    Map<String, Object> slotData = new HashMap<>();
                    slotData.put("exists", false);
                    slotData.put("categoryId", 1);
                    slotData.put("hasWarning", false);
                    
                    Map<String, Object> morning = new HashMap<>();
                    morning.put("available", true);
                    morning.put("startTime", "08:00:00");
                    morning.put("endTime", "11:30:00");
                    morning.put("blocked", false);
                    slotData.put("morning", morning);
                    
                    Map<String, Object> afternoon = new HashMap<>();
                    afternoon.put("available", true);
                    afternoon.put("startTime", "12:00:00");
                    afternoon.put("endTime", "17:00:00");
                    afternoon.put("blocked", false);
                    slotData.put("afternoon", afternoon);
                    
                    Map<String, Object> evening = new HashMap<>();
                    evening.put("available", true);
                    evening.put("startTime", "18:00:00");
                    evening.put("endTime", "21:00:00");
                    evening.put("blocked", false);
                    slotData.put("evening", evening);
                    
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    PrintWriter out = response.getWriter();
                    out.print(objectMapper.writeValueAsString(slotData));
                    out.flush();
                } catch (Exception ex) {
                    logger.error("Error writing error response", ex);
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                }
                return;
            }
        }
        
        logger.debug("Loading findTable.jsp page");
        
        // Load danh sách services ACTIVE
        loadActiveServices(request);

        // Hiển thị form tìm bàn
        try {
            request.getRequestDispatcher("/WEB-INF/BookTable/findTable.jsp").forward(request, response);
            logger.debug("Successfully forwarded to findTable.jsp");
        } catch (Exception e) {
            logger.error("Error forwarding to findTable.jsp", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading page: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        try {
            // Lấy thông tin từ form
            String dateStr = request.getParameter("date");
            String slotStr = request.getParameter("slot"); // Thay đổi từ "time" sang "slot"
            String guestCountStr = request.getParameter("guests");
            String floorStr = request.getParameter("floor");
            String specialRequest = request.getParameter("specialRequest");
            String serviceIdStr = request.getParameter("serviceId");
            String promotion = request.getParameter("promotion");

            // Kiểm tra hợp lệ
            if (dateStr == null || dateStr.isEmpty()
                    || slotStr == null || slotStr.isEmpty()
                    || guestCountStr == null || guestCountStr.isEmpty()) {
                request.setAttribute("errorMessage", "Vui lòng nhập đầy đủ thông tin.");
                loadActiveServices(request);
                request.getRequestDispatcher("/WEB-INF/BookTable/findTable.jsp").forward(request, response);
                return;
            }

            LocalDate reservationDate = LocalDate.parse(dateStr);
            
            // Map slot sang thời gian cụ thể để lưu vào session
            // slotStr có thể là: "MORNING", "AFTERNOON", "EVENING"
            String timeStr = "18:00"; // Mặc định
            try {
                TimeSlot timeSlot = timeRepository.getTime(dateStr);
                if (timeSlot != null) {
                    switch (slotStr.toUpperCase()) {
                        case "MORNING":
                            timeStr = timeSlot.getMorning_start_time() != null ? 
                                     timeSlot.getMorning_start_time().substring(0, 5) : "08:00";
                            break;
                        case "AFTERNOON":
                            timeStr = timeSlot.getAfternoon_start_time() != null ? 
                                     timeSlot.getAfternoon_start_time().substring(0, 5) : "12:00";
                            break;
                        case "EVENING":
                            timeStr = timeSlot.getEvening_start_time() != null ? 
                                     timeSlot.getEvening_start_time().substring(0, 5) : "18:00";
                            break;
                    }
                } else {
                    // Dùng mặc định
                    switch (slotStr.toUpperCase()) {
                        case "MORNING": timeStr = "08:00"; break;
                        case "AFTERNOON": timeStr = "12:00"; break;
                        case "EVENING": timeStr = "18:00"; break;
                    }
                }
            } catch (SQLException e) {
                logger.error("Error getting time slot for mapping", e);
            }
            
            int guestCount = Integer.parseInt(guestCountStr);
            int floor = (floorStr != null && !floorStr.isEmpty()) ? Integer.parseInt(floorStr) : 1;

            // Kiểm tra ngày
            if (reservationDate.isBefore(LocalDate.now())) {
                request.setAttribute("errorMessage", "Ngày đặt bàn không được là ngày quá khứ.");
                loadActiveServices(request); // ✅ Load lại services trước khi forward
                request.getRequestDispatcher("/WEB-INF/BookTable/findTable.jsp").forward(request, response);
                return;
            }

            // ✅ Lưu thông tin vào session (dùng cho bước chọn bàn)
            session.setAttribute("requiredDate", dateStr);
            session.setAttribute("requiredTime", timeStr);
            session.setAttribute("requiredSlot", slotStr); // Lưu slot đã chọn
            session.setAttribute("guestCount", guestCount);
            session.setAttribute("floor", floor);
            session.setAttribute("specialRequest", specialRequest);
            session.setAttribute("promotion", promotion);

            // Lưu serviceId vào session (có thể null nếu không chọn service)
            if (serviceIdStr != null && !serviceIdStr.isEmpty() && !serviceIdStr.equals("none")) {
                try {
                    int serviceId = Integer.parseInt(serviceIdStr);
                    session.setAttribute("selectedServiceId", serviceId);
                    logger.info("Selected service ID: {}", serviceId);
                } catch (NumberFormatException e) {
                    logger.warn("Invalid service ID: {}", serviceIdStr);
                    session.removeAttribute("selectedServiceId");
                }
            } else {
                // Nếu không chọn service, xóa khỏi session
                session.removeAttribute("selectedServiceId");
                logger.info("No service selected");
            }

            // ✅ Lấy danh sách bàn trống
            List<Table> availableTables = tableDAO.getAvailableTablesByCapacity(guestCount, floor);
            if (availableTables.isEmpty()) {
                request.setAttribute("errorMessage", "Không có bàn trống phù hợp với yêu cầu của bạn.");
            }

            // ✅ Lấy danh sách bàn đã được đặt trong cùng ngày và slot
            List<Integer> bookedTableIds = reservationDAO.getBookedTableIdsForSlot(reservationDate, slotStr);

            // Map dữ liệu bàn
            Map<Integer, Map<String, Object>> tableStatusMap = new HashMap<>();
            for (Table table : tableDAO.getAllTables()) {
                Map<String, Object> info = new HashMap<>();
                
                // Kiểm tra xem bàn có đã được đặt trong slot này không
                if (bookedTableIds.contains(table.getTableId())) {
                    info.put("status", "booked");
                } else {
                    info.put("status", "available");
                }
                
                info.put("capacity", table.getCapacity());
                info.put("floor", table.getFloor());
                info.put("match", table.getCapacity() >= guestCount && table.getFloor() == floor);
                tableStatusMap.put(table.getTableId(), info);
            }

            request.setAttribute("tableStatusMap", tableStatusMap);
            request.setAttribute("requiredDate", dateStr);
            request.setAttribute("requiredTime", timeStr);
            request.setAttribute("guestCount", guestCount);

            // ✅ Chuyển sang trang chọn bàn
            request.getRequestDispatcher("/WEB-INF/BookTable/mapTable.jsp").forward(request, response);

        } catch (Exception e) {
            logger.error("Error in FindTableServlet", e);
            request.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            loadActiveServices(request); // ✅ Load lại services trước khi forward
            request.getRequestDispatcher("/WEB-INF/BookTable/findTable.jsp").forward(request, response);
        }
    }
}
