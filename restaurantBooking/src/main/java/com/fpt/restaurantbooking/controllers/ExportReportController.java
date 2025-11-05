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

@WebServlet("/ExportReportServlet")
public class ExportReportController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final ServiceReportRepository serviceReportRepository = new ServiceReportRepository();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String type = request.getParameter("type");
        List<Map<String, Object>> dataToExport;

        // =========================================================
        //  LẤY CÁC THAM SỐ LỌC TỪ REQUEST
        // =========================================================
        String serviceType = request.getParameter("serviceType");
        String status = request.getParameter("status");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");

        // Dọn dẹp tham số nếu là chuỗi rỗng
        if (serviceType != null && serviceType.trim().isEmpty()) serviceType = null;
        if (status != null && status.trim().isEmpty()) status = null;
        if (startDate != null && startDate.trim().isEmpty()) startDate = null;
        if (endDate != null && endDate.trim().isEmpty()) endDate = null;
        // =========================================================

        try {
            //  GỌI REPOSITORY VỚI CÁC THAM SỐ LỌC THỰC TẾ
            dataToExport = serviceReportRepository.getTopSellingItems(serviceType, status, startDate, endDate, 20);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database Error retrieving Top Selling data: " + e.getMessage());
            return;
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to retrieve Top Selling data: " + e.getMessage());
            return;
        }

        try {
            if ("excel".equalsIgnoreCase(type)) {

                response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
                response.setHeader("Content-Disposition", "attachment; filename=\"TopSellingReport.xlsx\"");

                ExcelGeneratorUtil generator = new ExcelGeneratorUtil();
                // TRUYỀN CÁC THAM SỐ LỌC VÀO HÀM GENERATE
                generator.generate(dataToExport, response.getOutputStream(),
                        serviceType, status, startDate, endDate);

            } else if ("pdf".equalsIgnoreCase(type)) {

                response.setContentType("application/pdf");
                response.setHeader("Content-Disposition", "attachment; filename=\"TopSellingReport.pdf\"");

                PdfGeneratorUtil generator = new PdfGeneratorUtil();
                //  TRUYỀN CÁC THAM SỐ LỌC VÀO HÀM GENERATE
                generator.generate(dataToExport, response.getOutputStream(),
                        serviceType, status, startDate, endDate);

            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid or missing report type. Must be 'excel' or 'pdf'.");
            }

        } catch (IOException e) {
            e.printStackTrace();
            String errorMessage = "Export failed: " + e.getMessage();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, errorMessage);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Unknown error during report generation: " + e.getMessage());
        }
    }
}