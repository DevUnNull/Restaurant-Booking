package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.repositories.ServiceReportRepository;
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

// Giữ nguyên tên Servlet (đã sửa ở lần trước)
@WebServlet("/ExportServiceReportServlet")
public class ExportReportController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final ServiceReportRepository serviceReportRepository = new ServiceReportRepository();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String type = request.getParameter("type");

        // === SỬA ĐỔI: Thêm 2 biến cho 2 loại dữ liệu ===
        List<Map<String, Object>> topSellingData;
        List<Map<String, Object>> trendData;

        // Lấy các tham số lọc
        String serviceType = request.getParameter("serviceType");
        String status = request.getParameter("status");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        // === SỬA ĐỔI: Lấy thêm timeGrouping cho Trend Report ===
        String timeGrouping = request.getParameter("timeGrouping");

        // Dọn dẹp tham số
        if (serviceType != null && serviceType.trim().isEmpty()) serviceType = null;
        if (status != null && status.trim().isEmpty()) status = null;
        if (startDate != null && startDate.trim().isEmpty()) startDate = null;
        if (endDate != null && endDate.trim().isEmpty()) endDate = null;
        // Đặt mặc định cho timeGrouping nếu nó rỗng (giống như trên web)
        if (timeGrouping == null || timeGrouping.trim().isEmpty()) {
            timeGrouping = "day";
        }

        String serviceName = (serviceType != null) ? serviceType.replaceAll("\\s+", "_") : "Tat_Ca_Dich_Vu";
        String filenameBase = String.format("BaoCaoDichVu_%s", serviceName);

        try {
            // === SỬA ĐỔI: Lấy cả 2 loại dữ liệu ===
            // 1. Lấy dữ liệu Top Selling (Giữ nguyên 500)
            topSellingData = serviceReportRepository.getTopSellingItems(serviceType, status, startDate, endDate, 500);

            // 2. Lấy dữ liệu Xu Hướng
            trendData = serviceReportRepository.getServiceTrendReport(serviceType, status, startDate, endDate, timeGrouping);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi Cơ sở dữ liệu: " + e.getMessage());
            return;
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Thất bại khi lấy dữ liệu: " + e.getMessage());
            return;
        }

        try {
            if ("excel".equalsIgnoreCase(type)) {
                response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
                response.setHeader("Content-Disposition", String.format("attachment; filename=\"%s.xlsx\"", filenameBase));

                ExcelGeneratorUtil generator = new ExcelGeneratorUtil();

                // === SỬA ĐỔI: Gửi cả 2 danh sách ===
                generator.generateServiceReport(topSellingData, trendData, response.getOutputStream(),
                        serviceType, status, startDate, endDate);

            } else if ("pdf".equalsIgnoreCase(type)) {
                response.setContentType("application/pdf");
                response.setHeader("Content-Disposition", String.format("attachment; filename=\"%s.pdf\"", filenameBase));

                PdfGeneratorUtil generator = new PdfGeneratorUtil();

                // === SỬA ĐỔI: Gửi cả 2 danh sách ===
                generator.generateServiceReport(topSellingData, trendData, response.getOutputStream(),
                        serviceType, status, startDate, endDate);

            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Kiểu báo cáo không hợp lệ.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi tạo file báo cáo: " + e.getMessage());
        }
    }
}