package com.fpt.restaurantbooking.controllers;


import com.fpt.restaurantbooking.repositories.impl.ReportRepository;
import com.fpt.restaurantbooking.repositories.impl.ServiceRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

@WebServlet(name="ServiceReportController", urlPatterns={"/ServiceReport"})
    public class ServiceReportController extends HttpServlet {



        protected void processRequest(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
            response.setContentType("text/html;charset=UTF-8");
            // Khai báo biến để lưu trữ kết quả
            List<Map<String, Object>> categoryReport = null;
            List<Map<String, Object>> topSellingItems = null;

            try {

                categoryReport = reportRepository.getServiceCategoryReport();
                topSellingItems =reportRepository.getTopSellingItems(10);

                // Lưu kết quả vào request để chuyển sang JSP
                request.setAttribute("categoryReport", categoryReport);
                request.setAttribute("topSellingItems", topSellingItems);


            } catch (SQLException e) {
                // Xử lý lỗi SQL
                request.setAttribute("errorMessage", "Lỗi truy vấn cơ sở dữ liệu: " + e.getMessage());
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }

            // Forward đến trang JSP để hiển thị báo cáo và vẽ biểu đồ
            request.getRequestDispatcher("/WEB-INF/Report/ServiceReport.jsp").forward(request, response);
        }


        @Override
        protected void doGet(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
            processRequest(request, response);
        }

    private final ReportRepository reportRepository = new ReportRepository();

        @Override
        protected void doPost(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {

        }



        @Override
        public String getServletInfo() {
            return "Short description";
        }

    }


