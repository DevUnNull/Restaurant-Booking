package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.repositories.ServiceReportRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@WebServlet(name="ServiceReportController",
        urlPatterns={"/service-report"})
public class ServiceReportController extends HttpServlet {

    private final ServiceReportRepository serviceReportRepository = new ServiceReportRepository();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        response.setContentType("text/html;charset=UTF-8");

        // Lấy 4 tham số lọc từ request
        String serviceType = request.getParameter("serviceType");
        String status = request.getParameter("status");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");

        // Dọn dẹp tham số nếu là chuỗi rỗng
        if (serviceType != null && serviceType.trim().isEmpty()) serviceType = null;
        if (status != null && status.trim().isEmpty()) status = null;
        // BƯỚC 1: KHÔNG DỌN DẸP NGÀY THÁNG ĐỂ THỰC HIỆN VALIDATION BÊN DƯỚI
        // if (startDate != null && startDate.trim().isEmpty()) startDate = null;
        // if (endDate != null && endDate.trim().isEmpty()) endDate = null;


        List<Map<String, Object>> categoryReport = null;
        List<Map<String, Object>> topSellingItems = null;
        String warningMessage = null;
        String errorMessage = null;

        List<String> serviceTypesList = null;
        List<String> statusesList = null;


        try {
            // === Lấy danh sách cho bộ lọc (Luôn lấy) ===
            serviceTypesList = serviceReportRepository.getAvailableServiceTypes();

            statusesList = new ArrayList<>();
            statusesList.add("COMPLETED");
            statusesList.add("PENDING");
            statusesList.add("CANCELLED");
            statusesList.add("NO_SHOW");
            // ==========================================

            // =========================================================
            // BƯỚC 2: VALIDATION BẮT BUỘC NHẬP NGÀY THÁNG
            // =========================================================
            if (startDate == null || startDate.trim().isEmpty() || endDate == null || endDate.trim().isEmpty()) {
                warningMessage = "Vui lòng chọn cả ngày bắt đầu và ngày kết thúc để xem báo cáo chi tiết.";
            } else if (warningMessage == null) {
                // Nếu Validation Ngày tháng đã qua, tiến hành chạy báo cáo

                // GỌI CÁC PHƯƠNG THỨC BÁO CÁO (Đã sửa lỗi gọi hàm)
                categoryReport = serviceReportRepository.getServiceCategoryReport(serviceType, status, startDate, endDate);
                topSellingItems = serviceReportRepository.getTopSellingItems(serviceType, status, startDate, endDate, 20); // SỬA LỖI

                // =========================================================
                // KIỂM TRA VÀ GỬI CẢNH BÁO NẾU KHÔNG CÓ DỮ LIỆU
                // =========================================================
                boolean hasCategoryData = categoryReport != null && !categoryReport.isEmpty();
                boolean hasTopSellingData = topSellingItems != null && !topSellingItems.isEmpty();

                if (!hasCategoryData && !hasTopSellingData) {
                    StringBuilder filterDetail = new StringBuilder();

                    // Logic hiển thị Status trong thông báo
                    String displayStatus = (status != null && !status.trim().isEmpty()) ? status.toUpperCase().replace(" ", "_") : "COMPLETED (Default)";
                    if (status != null && status.equalsIgnoreCase("All")) displayStatus = "All Statuses";

                    filterDetail.append("Status: ").append(displayStatus);

                    if (serviceType != null) {
                        filterDetail.append(", Service Type: ").append(serviceType);
                    }

                    // Logic hiển thị Ngày tháng trong thông báo
                    filterDetail.append(", Date Range: ").append(startDate).append(" to ").append(endDate);


                    warningMessage = "Không tìm thấy dữ liệu báo cáo nào phù hợp với điều kiện lọc. Lọc: " + filterDetail.toString();

                    // Đảm bảo các danh sách là null để JSP không hiển thị bảng rỗng
                    categoryReport = null;
                    topSellingItems = null;
                }
            }
            // =========================================================

        } catch (SQLException e) {
            e.printStackTrace();
            errorMessage = "Database query error: " + e.getMessage();
            categoryReport = null;
            topSellingItems = null;
        } catch (Exception e) {
            e.printStackTrace();
            errorMessage = "Unknown error: " + e.getMessage();
            categoryReport = null;
            topSellingItems = null;
        }

        // Đặt thuộc tính request để gửi sang JSP
        request.setAttribute("warningMessage", warningMessage);
        request.setAttribute("errorMessage", errorMessage);
        request.setAttribute("selectedServiceType", serviceType);
        request.setAttribute("selectedStatus", status);
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);

        request.setAttribute("categoryReport", categoryReport);
        request.setAttribute("topSellingItems", topSellingItems);

        request.setAttribute("serviceTypesList", serviceTypesList);
        request.setAttribute("statusesList", statusesList);

        request.getRequestDispatcher("/WEB-INF/report/service-report.jsp").forward(request, response);
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

    @Override
    public String getServletInfo() {
        return "Service Statistics Report Controller";
    }
}