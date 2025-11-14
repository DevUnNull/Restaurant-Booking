package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.repositories.CustomerReportRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.time.ZoneId;
import java.util.List;
import java.util.Map;

@WebServlet(name="CustomerReportController", urlPatterns={"/user-report"})
public class CustomerReportController extends HttpServlet {

    private final CustomerReportRepository reportRepository = new CustomerReportRepository();
    private static final LocalDate START_OF_BUSINESS = LocalDate.of(2025, 9, 1);

    private static final int PAGE_SIZE = 5;

    private static final DateTimeFormatter DATE_FORMATTER_VN = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    private LocalDate safeParseDate(String dateStr, LocalDate defaultValue) {
        if (dateStr == null || dateStr.isEmpty()) {
            return defaultValue;
        }
        try {
            return LocalDate.parse(dateStr);
        } catch (Exception e) {
            return defaultValue;
        }
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        response.setContentType("text/html;charset=UTF-8");

        if (session == null || session.getAttribute("userRole") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // --- LẤY TẤT CẢ THAM SỐ ---
        String startDateParam = request.getParameter("startDate");
        String endDateParam = request.getParameter("endDate");
        String userIdParam = request.getParameter("userId");
        String warningMessage = null;
        String errorMessage = null;

        LocalDate currentDate = LocalDate.now();
        LocalDate startDate = null;
        LocalDate endDate = null;

        // MỚI/KHÔI PHỤC LOGIC: Nếu đang ở chế độ tổng quan và thiếu ngày, CHẶN và yêu cầu nhập.
        if (userIdParam == null || userIdParam.isEmpty()) {
            if (startDateParam == null || startDateParam.isEmpty() || endDateParam == null || endDateParam.isEmpty()) {
                request.setAttribute("warningMessage", "Vui lòng chọn Ngày Bắt đầu và Ngày Kết thúc để xem báo cáo.");
                request.setAttribute("isDateRequired", true); // Đánh dấu rằng cần chọn ngày
                request.getRequestDispatcher("/WEB-INF/report/user-report.jsp").forward(request, response);
                return;
            }
        }

        // Gán giá trị ngày từ params
        startDate = safeParseDate(startDateParam, START_OF_BUSINESS);
        endDate = safeParseDate(endDateParam, currentDate);

        // --- BẮT ĐẦU XÁC THỰC NGÀY ---
        if (startDate.isBefore(START_OF_BUSINESS)) {
            warningMessage = "Cảnh báo: Ngày bắt đầu (" + startDate.format(DATE_FORMATTER_VN) + ") đã được điều chỉnh về ngày bắt đầu kinh doanh (" + START_OF_BUSINESS.format(DATE_FORMATTER_VN) + ").";
            startDate = START_OF_BUSINESS;
        }
        if (startDate.isAfter(endDate)) {
            LocalDate originalStartDate = startDate;
            LocalDate originalEndDate = endDate;
            LocalDate tempDate = startDate;
            startDate = endDate;
            endDate = tempDate;
            String swapMessage = "Cảnh báo: Ngày bắt đầu (" + originalStartDate.format(DATE_FORMATTER_VN) + ") muộn hơn ngày kết thúc (" + originalEndDate.format(DATE_FORMATTER_VN) + "). Hệ thống đã tự động **hoán đổi** hai ngày (Từ " + startDate.format(DATE_FORMATTER_VN) + " đến " + endDate.format(DATE_FORMATTER_VN) + ") để hiển thị dữ liệu hợp lệ.";
            if (warningMessage != null) {
                warningMessage += "<br/>" + swapMessage;
            } else {
                warningMessage = swapMessage;
            }
        }

        // Chuẩn bị tham số cho SQL
        String sqlStartDate = startDate.toString();
        String sqlEndDate = endDate.toString();

        // MỚI: Chuyển LocalDate sang java.util.Date để tương thích JSTL (Fix lỗi 500)
        Date startDateUtil = Date.from(startDate.atStartOfDay(ZoneId.systemDefault()).toInstant());
        Date endDateUtil = Date.from(endDate.atStartOfDay(ZoneId.systemDefault()).toInstant());

        // SỬA LỖI 500: Truyền object java.util.Date cho JSP
        request.setAttribute("startDateObject", startDateUtil);
        request.setAttribute("endDateObject", endDateUtil);

        request.setAttribute("startDateParam", sqlStartDate); // Vẫn truyền String cho input value
        request.setAttribute("endDateParam", sqlEndDate); // Vẫn truyền String cho input value
        request.setAttribute("warningMessage", warningMessage);

        // --- RẼ NHÁNH LOGIC: CHI TIẾT hay TỔNG QUAN ---
        try {
            if (userIdParam != null && !userIdParam.isEmpty()) {
                // *** CHẾ ĐỘ XEM CHI TIẾT ***
                request.setAttribute("isDetailMode", true);
                int userId = Integer.parseInt(userIdParam);
                request.setAttribute("selectedUserId", userId);

                Map<String, Object> customerDetail = reportRepository.getCustomerDetails(userId);
                if (customerDetail == null) {
                    errorMessage = "Không tìm thấy khách hàng với ID = " + userId;
                }
                request.setAttribute("selectedCustomerDetail", customerDetail);

                List<Map<String, Object>> reservations = reportRepository.getReservationsForCustomer(userId, sqlStartDate, sqlEndDate);

                // XÓA LOGIC LẤY CHI TIẾT MÓN ĂN (Giữ nguyên danh sách Reservations)

                request.setAttribute("customerReservations", reservations);

            } else {
                // *** CHẾ ĐỘ XEM TỔNG QUAN ***
                request.setAttribute("isDetailMode", false);

                int currentPage = 1;
                try {
                    String pageParam = request.getParameter("page");
                    if (pageParam != null) {
                        currentPage = Integer.parseInt(pageParam);
                    }
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
                if (currentPage < 1) currentPage = 1;
                int offset = (currentPage - 1) * PAGE_SIZE;

                int totalCustomerCount = reportRepository.getTotalActiveCustomerCount();
                int newCustomerCount = reportRepository.getNewCustomerCount(sqlStartDate, sqlEndDate);
                long grandTotalSpending = reportRepository.getGrandTotalSpending(sqlStartDate, sqlEndDate);

                List<Map<String, Object>> customerData = reportRepository.getCustomerOverviewData(sqlStartDate, sqlEndDate, PAGE_SIZE, offset);

                int totalCustomerForPaging = reportRepository.getTotalActiveCustomerCount();
                int totalPages = (int) Math.ceil((double) totalCustomerForPaging / PAGE_SIZE);

                request.setAttribute("customerData", customerData);
                request.setAttribute("newCustomerCount", newCustomerCount);
                request.setAttribute("totalCustomerCount", totalCustomerCount);
                request.setAttribute("grandTotalSpending", grandTotalSpending);
                request.setAttribute("currentPage", currentPage);
                request.setAttribute("totalPages", totalPages);
            }

        } catch (NumberFormatException e) {
            errorMessage = "ID khách hàng không hợp lệ.";
            e.printStackTrace();
        } catch (SQLException e) {
            errorMessage = "Lỗi truy vấn cơ sở dữ liệu: " + e.getMessage();
            e.printStackTrace();
        } catch (Exception e) {
            errorMessage = "Lỗi không xác định: " + e.getMessage();
            e.printStackTrace();
        }

        request.setAttribute("errorMessage", errorMessage);
        request.getRequestDispatcher("/WEB-INF/report/user-report.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}