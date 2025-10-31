package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.repositories.OverviewReportRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.math.BigDecimal;

@WebServlet(name="OverviewReportController", urlPatterns={"/overview-report"})
public class OverviewReportController extends HttpServlet {

    private final OverviewReportRepository reportRepository = new OverviewReportRepository();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        response.setContentType("text/html;charset=UTF-8");

        if (session == null || session.getAttribute("userRole") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String startDateParam = request.getParameter("startDate");
        String endDateParam = request.getParameter("endDate");
        String chartUnitParam = request.getParameter("chartUnit");

        // isInitialLoad là true nếu cả hai ngày đều null hoặc empty
        boolean isInitialLoad = (startDateParam == null || startDateParam.isEmpty())
                && (endDateParam == null || endDateParam.isEmpty());

        if (chartUnitParam == null || chartUnitParam.isEmpty()) {
            chartUnitParam = "month";
        }

        LocalDate currentDate = LocalDate.now();
        // Giữ nguyên Min/Max Date Bounds của bạn
        LocalDate minDate = LocalDate.of(2025, 9, 1);
        LocalDate maxDate = LocalDate.of(2025, 10, 31);

        Map<String, Object> summaryData = new HashMap<>();
        List<Map<String, Object>> timeTrendData = null;
        String warningMessage = null;
        String errorMessage = null;

        // =========================================================
        // ✅ ĐÃ BỎ LOGIC GÁN NGÀY MẶC ĐỊNH
        // =========================================================
        // Logic gán ngày mặc định (KHÔNG CÒN)
        /*
        if (isInitialLoad) {
            startDateParam = currentDate.minusMonths(1).toString();
            endDateParam = currentDate.toString();
        }
        */


        try {
            // =========================================================
            // ✅ XỬ LÝ KHI NGÀY BỊ THIẾU HOẶC TẢI LẦN ĐẦU
            // =========================================================
            if (startDateParam == null || startDateParam.trim().isEmpty() || endDateParam == null || endDateParam.trim().isEmpty()) {

                // Nếu là Initial Load HOẶC người dùng submit filter mà thiếu ngày
                warningMessage = " Vui lòng chọn cả ngày bắt đầu và ngày kết thúc để xem báo cáo chi tiết.";

                // Đảm bảo các tham số vẫn được gửi đi (nếu có) để giữ lại các giá trị khác trong filter modal
                // Nhưng giữ nguyên null/empty cho startDateParam/endDateParam để báo hiệu chưa có ngày
                startDateParam = request.getParameter("startDate");
                endDateParam = request.getParameter("endDate");

            } else {
                // Nếu cả hai ngày đều có giá trị, tiến hành chạy báo cáo

                // Xử lý Min/Max Date Bounds (Nếu người dùng chọn ngoài phạm vi cho phép)
                LocalDate startDate = LocalDate.parse(startDateParam);
                LocalDate endDate = LocalDate.parse(endDateParam);

                if (startDate.isBefore(minDate)) {
                    startDate = minDate;
                    startDateParam = minDate.toString();
                }
                if (endDate.isAfter(maxDate)) {
                    endDate = maxDate;
                    endDateParam = maxDate.toString();
                }

                // Chạy Repository
                summaryData = reportRepository.getSummaryData(startDateParam, endDateParam);
                timeTrendData = reportRepository.getTimeTrendData(startDateParam, endDateParam, chartUnitParam);

                // Xử lý dữ liệu (BigDecimal to Long)
                BigDecimal revenueSummary = (BigDecimal) summaryData.getOrDefault("totalRevenue", BigDecimal.ZERO);
                summaryData.put("totalRevenue", revenueSummary.longValue());

                if (timeTrendData != null) {
                    for (Map<String, Object> item : timeTrendData) {
                        BigDecimal itemRevenue = (BigDecimal) item.getOrDefault("totalRevenue", BigDecimal.ZERO);
                        item.put("totalRevenue", itemRevenue.longValue());
                    }
                }

                Integer totalBookings = (Integer) summaryData.getOrDefault("totalBookings", 0);

                // Cảnh báo không có dữ liệu
                if (totalBookings == 0) {
                    warningMessage = "Không có dữ liệu đặt bàn nào được tìm thấy trong khoảng thời gian đã chọn (" + startDateParam + " đến " + endDateParam + ").";
                }
            }
            // =========================================================

        } catch (SQLException e) {
            e.printStackTrace();
            errorMessage = "Lỗi truy vấn cơ sở dữ liệu: " + e.getMessage();
        } catch (Exception e) {
            e.printStackTrace();
            errorMessage = "Lỗi không xác định: " + e.getMessage();
        }

        request.setAttribute("isInitialLoad", isInitialLoad);
        request.setAttribute("warningMessage", warningMessage);
        request.setAttribute("errorMessage", errorMessage);
        request.setAttribute("startDateParam", startDateParam);
        request.setAttribute("endDateParam", endDateParam);
        request.setAttribute("chartUnitParam", chartUnitParam);
        request.setAttribute("currentDate", currentDate.toString());

        request.setAttribute("summaryData", summaryData);
        request.setAttribute("timeTrendData", timeTrendData);

        request.getRequestDispatcher("/WEB-INF/report/overview-report.jsp").forward(request, response);
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