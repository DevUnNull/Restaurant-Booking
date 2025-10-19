package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.repositories.impl.ReportRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

@WebServlet(name="ServiceReportController", urlPatterns={"/ServiceReport"})
public class ServiceReportController extends HttpServlet {

    private final ReportRepository reportRepository = new ReportRepository();

    // CÁC HẰNG SỐ ID VAI TRÒ
    private static final int ADMIN_ROLE_ID = 1;
    private static final int MANAGER_ROLE_ID = 4;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // 1. KIỂM TRA ĐĂNG NHẬP VÀ VAI TRÒ
        if (session == null || session.getAttribute("userRole") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Object roleObj = session.getAttribute("userRole");
        int userRoleId = -1;

        try {
            if (roleObj instanceof Integer) {
                userRoleId = (Integer) roleObj;
            } else if (roleObj instanceof String) {
                userRoleId = Integer.parseInt((String) roleObj);
            }
        } catch (NumberFormatException e) {
            userRoleId = -1;
        }

        // 2. KIỂM TRA QUYỀN TRUY CẬP
        if (userRoleId != ADMIN_ROLE_ID && userRoleId != MANAGER_ROLE_ID) {
            response.sendRedirect("access_denied.jsp");
            return;
        }

        // 3. CHUẨN HÓA TÊN HIỂN THỊ TRÊN HEADER
        String currentUserName = (String) session.getAttribute("userName");

        if (currentUserName == null || !(currentUserName.equals("Admin") || currentUserName.equals("Manager"))) {
            String newDisplayName;

            if (userRoleId == ADMIN_ROLE_ID) {
                newDisplayName = "Admin";
            } else if (userRoleId == MANAGER_ROLE_ID) {
                newDisplayName = "Manager";
            } else {
                newDisplayName = "Authorized User";
            }
            session.setAttribute("userName", newDisplayName);
        }

        response.setContentType("text/html;charset=UTF-8");

        String serviceType = request.getParameter("serviceType");
        String status = request.getParameter("status");

        // KHÔI PHỤC VÀ LẤY THAM SỐ NGÀY (CHO VIỆC HIỂN THỊ TRÊN FORM)
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");


        List<Map<String, Object>> categoryReport = null;
        List<Map<String, Object>> topSellingItems = null;
        String warningMessage = null;
        String errorMessage = null;

        try {
            // 4. TRUY VẤN DỮ LIỆU VỚI CHỮ KÝ HÀM CŨ (1 tham số)

            // Dữ liệu cho Biểu đồ (Service Category Report)
            categoryReport = reportRepository.getServiceCategoryReportByStatus(status);

            // Dữ liệu cho Bảng Top Selling (Top 20)
            topSellingItems = reportRepository.getTopSellingItems(20);

            // 5. KIỂM TRA DỮ LIỆU RỖNG
            if (categoryReport == null || categoryReport.isEmpty()) {
                String filterStatus = (status != null && !status.trim().isEmpty() && !status.equalsIgnoreCase("All")) ? status : "COMPLETED (Default)";
                warningMessage = "No report data found matching the filter condition for Status: " + filterStatus + ". Please check again.";
            }

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

        // 6. LƯU THUỘC TÍNH VÀ CHUYỂN TIẾP
        request.setAttribute("warningMessage", warningMessage);
        request.setAttribute("errorMessage", errorMessage);
        request.setAttribute("selectedServiceType", serviceType);
        request.setAttribute("selectedStatus", status);

        // LƯU THAM SỐ NGÀY ĐỂ HIỂN THỊ TRONG JSP
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);

        request.setAttribute("categoryReport", categoryReport);
        request.setAttribute("topSellingItems", topSellingItems);

        request.getRequestDispatcher("/WEB-INF/Report/ServiceReport.jsp").forward(request, response);
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