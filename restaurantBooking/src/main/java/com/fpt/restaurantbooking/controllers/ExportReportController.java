    package com.fpt.restaurantbooking.controllers;

    import com.fpt.restaurantbooking.repositories.impl.ReportRepository;
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

        private final ReportRepository reportRepository = new ReportRepository();


        @Override
        protected void doGet(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
            String type = request.getParameter("type");

            final int REPORT_LIMIT = 10000;
            List<Map<String, Object>> dataToExport;

            try {
                dataToExport = reportRepository.getTopSellingItems(REPORT_LIMIT);

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
                    // 1. EXCEL
                    response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
                    response.setHeader("Content-Disposition", "attachment; filename=\"TopSellingReport.xlsx\"");

                    ExcelGeneratorUtil generator = new ExcelGeneratorUtil();
                    generator.generate(dataToExport, response.getOutputStream());

                } else if ("pdf".equalsIgnoreCase(type)) {
                    response.setContentType("application/pdf");
                    response.setHeader("Content-Disposition", "attachment; filename=\"TopSellingReport.pdf\"");

                    PdfGeneratorUtil generator = new PdfGeneratorUtil();
                    generator.generate(dataToExport, response.getOutputStream());

                } else {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid or missing report type. Must be 'excel' or 'pdf'.");
                }

            } catch (IOException e) {
                if (e.getMessage() != null && e.getMessage().contains("Lỗi Font")) {
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Export failed: " + e.getMessage());
                } else {
                    e.printStackTrace();
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Export failed: " + e.getMessage());
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Export failed: " + e.getMessage());
            }
        }
    }