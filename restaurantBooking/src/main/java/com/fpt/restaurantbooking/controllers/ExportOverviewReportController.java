package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.repositories.OverviewReportRepository;
import com.fpt.restaurantbooking.utils.ExcelGeneratorUtil;
import com.fpt.restaurantbooking.utils.PdfGeneratorUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.sql.SQLException;
import java.math.BigDecimal;
import java.time.LocalDate;

@WebServlet("/ExportOverviewReportServlet")
public class ExportOverviewReportController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final OverviewReportRepository reportRepository = new OverviewReportRepository();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String type = request.getParameter("type");
        String startDateParam = request.getParameter("startDate");
        String endDateParam = request.getParameter("endDate");
        String chartUnitParam = request.getParameter("chartUnit");

        // Đặt giá trị mặc định cho đơn vị biểu đồ nếu bị thiếu
        if (chartUnitParam == null || chartUnitParam.isEmpty()) {
            chartUnitParam = "month";
        }

        LocalDate currentDate = LocalDate.now();

        // Đặt ngày mặc định cho bộ lọc nếu bị thiếu (Ví dụ: 1 năm trước đến hiện tại)
        startDateParam = (startDateParam == null || startDateParam.isEmpty()) ? currentDate.minusYears(1).toString() : startDateParam;
        endDateParam = (endDateParam == null || endDateParam.isEmpty()) ? currentDate.toString() : endDateParam;


        Map<String, Object> summaryData;
        List<Map<String, Object>> timeTrendData;

        try {
            // Lấy dữ liệu tóm tắt và xu hướng thời gian từ Repository
            summaryData = reportRepository.getSummaryData(startDateParam, endDateParam);
            timeTrendData = reportRepository.getTimeTrendData(startDateParam, endDateParam, chartUnitParam);

            // Chuyển đổi BigDecimal sang Long cho tổng doanh thu để tương thích với các phương thức export
            BigDecimal revenueSummary = (BigDecimal) summaryData.getOrDefault("totalRevenue", BigDecimal.ZERO);
            summaryData.put("totalRevenue", revenueSummary.longValue());

            // Chuyển đổi BigDecimal sang Long cho dữ liệu xu hướng thời gian
            if (timeTrendData != null) {
                for (Map<String, Object> item : timeTrendData) {
                    BigDecimal itemRevenue = (BigDecimal) item.getOrDefault("totalRevenue", BigDecimal.ZERO);
                    item.put("totalRevenue", itemRevenue.longValue());
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            // Xử lý lỗi cơ sở dữ liệu
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi Cơ sở dữ liệu khi lấy dữ liệu Báo cáo Tổng quan: " + e.getMessage());
            return;
        } catch (Exception e) {
            e.printStackTrace();
            // Xử lý lỗi chung
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Thất bại khi lấy dữ liệu Báo cáo Tổng quan: " + e.getMessage());
            return;
        }

        try {
            if ("excel".equalsIgnoreCase(type)) {

                // Thiết lập header cho file Excel
                response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
                response.setHeader("Content-Disposition", String.format("attachment; filename=\"BaoCaoTongQuan_%s_den_%s.xlsx\"", startDateParam, endDateParam));

                // Gọi hàm tạo báo cáo Excel
                ExcelGeneratorUtil generator = new ExcelGeneratorUtil();
                generator.generateOverviewReport(summaryData, timeTrendData, response.getOutputStream());

            } else if ("pdf".equalsIgnoreCase(type)) {

                // Thiết lập header cho file PDF
                response.setContentType("application/pdf");
                response.setHeader("Content-Disposition", String.format("attachment; filename=\"BaoCaoTongQuan_%s_den_%s.pdf\"", startDateParam, endDateParam));

                // Gọi hàm tạo báo cáo PDF
                PdfGeneratorUtil generator = new PdfGeneratorUtil();
                generator.generateOverviewReport(summaryData, timeTrendData, response.getOutputStream());

            } else {
                // Xử lý khi kiểu báo cáo không hợp lệ
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Kiểu báo cáo không hợp lệ hoặc bị thiếu. Phải là 'excel' hoặc 'pdf'.");
            }

        } catch (IOException e) {
            e.printStackTrace();
            // Xử lý lỗi I/O trong quá trình xuất file
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Xuất báo cáo thất bại (Lỗi I/O): " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            // Xử lý lỗi chung trong quá trình tạo báo cáo
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi không xác định trong quá trình tạo báo cáo: " + e.getMessage());
        }
    }
}