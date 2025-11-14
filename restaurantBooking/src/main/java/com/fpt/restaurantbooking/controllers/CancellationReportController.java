package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.repositories.CancellationReportRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.Collections; // MỚI: Để tạo danh sách rỗng khi không có ngày
import java.util.List;
import java.util.Map;

@WebServlet(name="CancellationReportController", urlPatterns={"/cancel-report"})
public class CancellationReportController extends HttpServlet {

    private final CancellationReportRepository reportRepository = new CancellationReportRepository();
    //    private static final LocalDate START_OF_BUSINESS = LocalDate.of(2025, 1, 1);
    private static final int DEFAULT_PAGE_SIZE = 7;

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

    private int safeParseInt(String intStr, int defaultValue) {
        if (intStr == null || intStr.isEmpty()) {
            return defaultValue;
        }
        try {
            return Integer.parseInt(intStr);
        } catch (NumberFormatException e) {
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

        // 1. Xử lý tham số Phân Trang
        int currentPage = safeParseInt(request.getParameter("page"), 1);
        int pageSize = safeParseInt(request.getParameter("pageSize"), DEFAULT_PAGE_SIZE);

        if (currentPage < 1) currentPage = 1;
        if (pageSize < 1) pageSize = DEFAULT_PAGE_SIZE;

        int offset = (currentPage - 1) * pageSize;
        int totalRecords = 0;
        int totalPages = 0;

        // 2. Xử lý tham số Lọc Ngày
        String startDateParam = request.getParameter("startDate");
        String endDateParam = request.getParameter("endDate");
        String warningMessage = null;
        String errorMessage = null;
        List<Map<String, Object>> cancellationData = null;

        // ********** MỚI: KIỂM TRA BẮT BUỘC NGÀY **********
        if (startDateParam == null || startDateParam.isEmpty() || endDateParam == null || endDateParam.isEmpty()) {
            // Thiết lập các giá trị cần thiết cho JSP hiển thị trống (không có data)
            request.setAttribute("cancellationData", Collections.emptyList());
            request.setAttribute("totalRecords", 0);
            request.setAttribute("totalPages", 0);
            request.setAttribute("currentPage", 1);

            // Chuyển tiếp ngay lập tức để JSP yêu cầu chọn ngày
            request.getRequestDispatcher("/WEB-INF/report/cancel-report.jsp").forward(request, response);
            return;
        }
        // **************************************************


        // --- CHỈ CHẠY TIẾP NẾU CÓ ĐỦ NGÀY HỢP LỆ ---
        LocalDate currentDate = LocalDate.now();
        // Giả định một ngày bắt đầu kinh doanh an toàn nếu cần validation chi tiết hơn
        LocalDate START_OF_BUSINESS = LocalDate.of(2025, 1, 1);

        LocalDate endDate = safeParseDate(endDateParam, currentDate);
        LocalDate startDate = safeParseDate(startDateParam, START_OF_BUSINESS);


        // ... (Logic Validation Ngày giữ nguyên)
        if (endDate.isAfter(currentDate)) {
            String futureWarning = "Warning: The end date (" + endDate.toString() + ") cannot exceed the current date. The system has adjusted the end date to **" + currentDate.toString() + "**.";
            if (warningMessage != null) warningMessage += "<br/>" + futureWarning; else warningMessage = futureWarning;
            endDate = currentDate;
        }

        if (startDate.isAfter(endDate)) {
            LocalDate originalStartDate = startDate;
            LocalDate originalEndDate = endDate;

            LocalDate tempDate = startDate;
            startDate = endDate;
            endDate = tempDate;

            String swapMessage = "Warning: The start date (" + originalStartDate.toString() + ") was later than the end date (" + originalEndDate.toString() + "). The system automatically **swapped** the two dates (From " + startDate.toString() + " to " + endDate.toString() + ") to display valid data.";

            if (warningMessage != null) warningMessage += "<br/>" + swapMessage; else warningMessage = swapMessage;
        }

        // Cập nhật lại chuỗi ngày sau khi đã validate
        startDateParam = startDate.toString();
        endDateParam = endDate.toString();


        try {
            // 3. Lấy Tổng số bản ghi (Cần thiết cho phân trang)
            totalRecords = reportRepository.getTotalCancellationCount(startDateParam, endDateParam);
            totalPages = (int) Math.ceil((double) totalRecords / pageSize);

            // Điều chỉnh currentPage nếu nó lớn hơn totalPages
            if (currentPage > totalPages && totalPages > 0) {
                currentPage = totalPages;
                offset = (currentPage - 1) * pageSize;
            } else if (totalPages == 0) {
                currentPage = 1;
                offset = 0;
            }

            // 4. Lấy Dữ liệu đã phân trang
            cancellationData = reportRepository.getCancellationData(startDateParam, endDateParam, pageSize, offset);

        } catch (SQLException e) {
            errorMessage = "Database query error: " + e.getMessage();
            e.printStackTrace();
        } catch (Exception e) {
            errorMessage = "Unknown error: " + e.getMessage();
            e.printStackTrace();
        }

        // 5. Thiết lập thuộc tính cho JSP
        request.setAttribute("warningMessage", warningMessage);
        request.setAttribute("errorMessage", errorMessage);
        request.setAttribute("startDateParam", startDateParam);
        request.setAttribute("endDateParam", endDateParam);
        request.setAttribute("cancellationData", cancellationData);

        // Thông tin phân trang
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("pageSize", pageSize);


        request.getRequestDispatcher("/WEB-INF/report/cancel-report.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}