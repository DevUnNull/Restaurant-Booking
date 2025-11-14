package com.fpt.restaurantbooking.utils;

import java.io.OutputStream;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import java.io.IOException;

public class ExcelGeneratorUtil {

    /**
     * Tạo báo cáo Excel cho danh sách món ăn bán chạy nhất. (Hàm này có vẻ cũ, giữ lại)
     * (Đã cập nhật xử lý kiểu số an toàn)
     */
    public void generate(List<Map<String, Object>> data, OutputStream outputStream,
                         String serviceType, String status, String startDate, String endDate) throws IOException {

        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("BaoCaoMonBanChayNhat");
        CellStyle headerStyle = workbook.createCellStyle();
        Font headerFont = workbook.createFont();
        headerFont.setBold(true);
        headerStyle.setFont(headerFont);
        CellStyle currencyStyle = workbook.createCellStyle();
        currencyStyle.setDataFormat(workbook.createDataFormat().getFormat("#,##0"));
        Row titleRow = sheet.createRow(0);
        titleRow.createCell(0).setCellValue("BÁO CÁO MÓN BÁN CHẠY NHẤT");
        titleRow.getCell(0).setCellStyle(headerStyle);
        Row filterRow1 = sheet.createRow(1);
        filterRow1.createCell(0).setCellValue("Loại Dịch Vụ: " + (serviceType != null ? serviceType : "Tất Cả"));
        filterRow1.createCell(1).setCellValue("Trạng Thái: " + (status != null ? status.toUpperCase().replace(" ", "_") : "HOÀN THÀNH"));
        Row filterRow2 = sheet.createRow(2);
        filterRow2.createCell(0).setCellValue("Khoảng Thời Gian: " + (startDate != null ? startDate : "Bất Kỳ") + " đến " + (endDate != null ? endDate : "Bất Kỳ"));
        Row headerRow = sheet.createRow(4);
        String[] headers = {"Hạng", "Tên Món Ăn/Dịch Vụ", "Tổng Số Lượng Đã Bán", "Doanh Thu (VND)"};
        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(headerStyle);
        }
        int rowNum = 5;
        for (Map<String, Object> rowData : data) {
            Row row = sheet.createRow(rowNum++);
            row.createCell(0).setCellValue(rowNum - 5);
            row.createCell(1).setCellValue((String) rowData.get("item_name"));

            // === SỬA LỖI AN TOÀN KIỂU DỮ LIỆU ===
            Object quantityObj = rowData.get("total_quantity_sold");
            int quantity = 0;
            if (quantityObj instanceof Number) {
                quantity = ((Number) quantityObj).intValue();
            }
            row.createCell(2).setCellValue(quantity);
            // === KẾT THÚC SỬA LỖI ===

            BigDecimal revenue = (BigDecimal) rowData.get("total_revenue_from_item");
            Cell revenueCell = row.createCell(3);
            revenueCell.setCellValue(revenue != null ? revenue.doubleValue() : 0.0);
            revenueCell.setCellStyle(currencyStyle);
        }
        for (int i = 0; i < headers.length; i++) {
            sheet.autoSizeColumn(i);
        }
        sheet.addMergedRegion(new org.apache.poi.ss.util.CellRangeAddress(0, 0, 0, headers.length - 1));
        workbook.write(outputStream);
        workbook.close();
    }


    /**
     * Tạo báo cáo Excel cho báo cáo tổng quan. (Giữ nguyên)
     */
    public void generateOverviewReport(Map<String, Object> summaryData, List<Map<String, Object>> timeTrendData, OutputStream outputStream) throws IOException {
        // ... (Giữ nguyên code của hàm này, không thay đổi) ...
        Workbook workbook = new XSSFWorkbook();
        CellStyle headerStyle = workbook.createCellStyle();
        Font headerFont = workbook.createFont();
        headerFont.setBold(true);
        headerStyle.setFont(headerFont);
        CellStyle currencyStyle = workbook.createCellStyle();
        currencyStyle.setDataFormat(workbook.createDataFormat().getFormat("#,##0"));
        Sheet summarySheet = workbook.createSheet("Tóm Tắt");
        Row headerRow = summarySheet.createRow(0);
        headerRow.createCell(0).setCellValue("Chỉ Số");
        headerRow.createCell(1).setCellValue("Giá Trị");
        headerRow.getCell(0).setCellStyle(headerStyle);
        headerRow.getCell(1).setCellStyle(headerStyle);
        Row dataRow1 = summarySheet.createRow(1);
        dataRow1.createCell(0).setCellValue("Tổng Số Lượt Đặt Bàn");
        dataRow1.createCell(1).setCellValue((Integer) summaryData.getOrDefault("totalBookings", 0));
        Row dataRow2 = summarySheet.createRow(2);
        dataRow2.createCell(0).setCellValue("Tổng Doanh Thu (VND)");
        Cell revenueCell = dataRow2.createCell(1);
        Object revenueObj = summaryData.getOrDefault("totalRevenue", 0L);
        double revenueValue = 0.0;
        if (revenueObj instanceof Long) {
            revenueValue = ((Long) revenueObj).doubleValue();
        } else if (revenueObj instanceof BigDecimal) {
            revenueValue = ((BigDecimal) revenueObj).doubleValue();
        } else if (revenueObj instanceof Number) { // Thêm để an toàn
            revenueValue = ((Number) revenueObj).doubleValue();
        }
        revenueCell.setCellValue(revenueValue);
        revenueCell.setCellStyle(currencyStyle);
        Row dataRow3 = summarySheet.createRow(3);
        dataRow3.createCell(0).setCellValue("Tổng Số Lượt Hủy");
        dataRow3.createCell(1).setCellValue((Integer) summaryData.getOrDefault("totalCancellations", 0));
        Row dataRow4 = summarySheet.createRow(4);
        dataRow4.createCell(0).setCellValue("Tỷ Lệ Hủy (%)");
        dataRow4.createCell(1).setCellValue((Double) summaryData.getOrDefault("cancellationRate", 0.0));
        for (int i = 0; i < 2; i++) {
            summarySheet.autoSizeColumn(i);
        }
        Sheet trendSheet = workbook.createSheet("Xu Hướng Thời Gian");
        Row trendHeader = trendSheet.createRow(0);
        trendHeader.createCell(0).setCellValue("Ngày");
        trendHeader.createCell(1).setCellValue("Doanh Thu (VND)");
        trendHeader.createCell(2).setCellValue("Lượt Đặt Bàn");
        trendHeader.createCell(3).setCellValue("Lượt Hủy");
        for (int i = 0; i < 4; i++) {
            trendHeader.getCell(i).setCellStyle(headerStyle);
        }
        if (timeTrendData != null) {
            for (int i = 0; i < timeTrendData.size(); i++) {
                Row row = trendSheet.createRow(i + 1);
                Map<String, Object> item = timeTrendData.get(i);
                row.createCell(0).setCellValue((String) item.getOrDefault("date", ""));
                Cell trendRevenueCell = row.createCell(1);
                Object trendRevenueObj = item.getOrDefault("totalRevenue", 0L);
                double trendRevenueValue = 0.0;
                if (trendRevenueObj instanceof Long) {
                    trendRevenueValue = ((Long) trendRevenueObj).doubleValue();
                } else if (trendRevenueObj instanceof BigDecimal) {
                    trendRevenueValue = ((BigDecimal) trendRevenueObj).doubleValue();
                } else if (trendRevenueObj instanceof Number) { // Thêm để an toàn
                    trendRevenueValue = ((Number) trendRevenueObj).doubleValue();
                }
                trendRevenueCell.setCellValue(trendRevenueValue);
                trendRevenueCell.setCellStyle(currencyStyle);
                row.createCell(2).setCellValue((Integer) item.getOrDefault("totalBookings", 0));
                row.createCell(3).setCellValue((Integer) item.getOrDefault("totalCancellations", 0));
            }
        }
        for (int i = 0; i < 4; i++) {
            trendSheet.autoSizeColumn(i);
        }
        workbook.write(outputStream);
        workbook.close();
    }


    /**
     * === PHIÊN BẢN ĐÃ SỬA LỖI CHO BÁO CÁO DỊCH VỤ ===
     * Tạo báo cáo Excel cho cả top selling và trend.
     * (Đã cập nhật xử lý kiểu số an toàn)
     */
    public void generateServiceReport(List<Map<String, Object>> topSellingItems,
                                      List<Map<String, Object>> trendData, // Thêm tham số này
                                      OutputStream outputStream,
                                      String serviceType, String status, String startDate, String endDate) throws IOException {

        Workbook workbook = new XSSFWorkbook();

        // Style chung
        CellStyle headerStyle = workbook.createCellStyle();
        Font headerFont = workbook.createFont();
        headerFont.setBold(true);
        headerStyle.setFont(headerFont);
        CellStyle currencyStyle = workbook.createCellStyle();
        currencyStyle.setDataFormat(workbook.createDataFormat().getFormat("#,##0"));
        CellStyle integerStyle = workbook.createCellStyle();
        integerStyle.setDataFormat(workbook.createDataFormat().getFormat("0"));

        // Thông tin lọc chung
        String filterStatus = (status != null && !status.trim().isEmpty()) ? status.toUpperCase().replace(" ", "_") : "Tất Cả";
        String dateRange = "Khoảng Thời Gian: " + (startDate != null ? startDate : "Bất Kỳ") + " đến " + (endDate != null ? endDate : "Bất Kỳ");

        // =================================================
        // 1. TẠO SHEET MÓN BÁN CHẠY NHẤT (Giống như cũ)
        // =================================================
        Sheet topSellingSheet = workbook.createSheet("BaoCaoMonBanChay");

        Row titleRowTop = topSellingSheet.createRow(0);
        titleRowTop.createCell(0).setCellValue("CHI TIẾT: CÁC MÓN BÁN CHẠY NHẤT");
        titleRowTop.getCell(0).setCellStyle(headerStyle);
        topSellingSheet.addMergedRegion(new org.apache.poi.ss.util.CellRangeAddress(0, 0, 0, 3));

        Row filterRowTop1 = topSellingSheet.createRow(1);
        filterRowTop1.createCell(0).setCellValue("Loại Dịch Vụ: " + (serviceType != null ? serviceType : "Tất Cả"));
        filterRowTop1.createCell(2).setCellValue("Trạng Thái: " + filterStatus);

        Row filterRowTop2 = topSellingSheet.createRow(2);
        filterRowTop2.createCell(0).setCellValue(dateRange);
        topSellingSheet.addMergedRegion(new org.apache.poi.ss.util.CellRangeAddress(2, 2, 0, 3));

        Row headerRowTop = topSellingSheet.createRow(4);
        String[] headersTop = {"Hạng", "Tên Món Ăn/Dịch Vụ", "Tổng Số Lượng Đã Bán", "Doanh Thu (VND)"};

        for (int i = 0; i < headersTop.length; i++) {
            Cell cell = headerRowTop.createCell(i);
            cell.setCellValue(headersTop[i]);
            cell.setCellStyle(headerStyle);
        }

        int rowNumTop = 5;
        if (topSellingItems != null) {
            for (Map<String, Object> rowData : topSellingItems) {
                Row row = topSellingSheet.createRow(rowNumTop++);
                row.createCell(0).setCellValue(rowNumTop - 5); // Rank
                row.createCell(1).setCellValue((String) rowData.get("item_name"));

                // === SỬA LỖI AN TOÀN KIỂU DỮ LIỆU ===
                Object quantityObj = rowData.get("total_quantity_sold");
                int quantity = 0;
                if (quantityObj instanceof Number) {
                    quantity = ((Number) quantityObj).intValue();
                }
                row.createCell(2).setCellValue(quantity);
                // === KẾT THÚC SỬA LỖI ===

                Object revenueObj = rowData.get("total_revenue_from_item");
                double revenue = 0.0;
                if (revenueObj instanceof Number) {
                    revenue = ((Number) revenueObj).doubleValue();
                }
                Cell revenueCell = row.createCell(3);
                revenueCell.setCellValue(revenue);
                revenueCell.setCellStyle(currencyStyle);
            }
        }
        for (int i = 0; i < headersTop.length; i++) {
            topSellingSheet.autoSizeColumn(i);
        }

        // =================================================
        // 2. TẠO SHEET XU HƯỚNG (PHẦN MỚI)
        // =================================================
        Sheet trendSheet = workbook.createSheet("XuHuongDoanhThuDatBan");

        Row titleRowTrend = trendSheet.createRow(0);
        titleRowTrend.createCell(0).setCellValue("BÁO CÁO XU HƯỚNG DOANH THU & ĐẶT BÀN");
        titleRowTrend.getCell(0).setCellStyle(headerStyle);
        trendSheet.addMergedRegion(new org.apache.poi.ss.util.CellRangeAddress(0, 0, 0, 7)); // Mở rộng ra 8 cột

        Row filterRowTrend1 = trendSheet.createRow(1);
        filterRowTrend1.createCell(0).setCellValue("Loại Dịch Vụ: " + (serviceType != null ? serviceType : "Tất Cả"));
        filterRowTrend1.createCell(2).setCellValue("Trạng Thái: " + filterStatus);

        Row filterRowTrend2 = trendSheet.createRow(2);
        filterRowTrend2.createCell(0).setCellValue(dateRange);
        trendSheet.addMergedRegion(new org.apache.poi.ss.util.CellRangeAddress(2, 2, 0, 7));

        Row headerRowTrend = trendSheet.createRow(4);
        String[] headersTrend = {
                "Ngày", "Doanh Thu (VND)", "Tổng Lượt Đặt",
                "Hoàn Thành", "Đã Hủy", "Không Đến",
                "Chờ Xác Nhận", "Đã Xác Nhận"
        };
        for (int i = 0; i < headersTrend.length; i++) {
            Cell cell = headerRowTrend.createCell(i);
            cell.setCellValue(headersTrend[i]);
            cell.setCellStyle(headerStyle);
        }

        // Dữ liệu cho Trend
        int rowNumTrend = 5;
        if (trendData != null) {
            for (Map<String, Object> rowData : trendData) {
                Row row = trendSheet.createRow(rowNumTrend++);
                row.createCell(0).setCellValue(rowData.get("report_date").toString());

                // Xử lý Doanh thu (an toàn)
                Object revenueObj = rowData.get("total_revenue");
                double revenue = 0.0;
                if (revenueObj instanceof Number) {
                    revenue = ((Number) revenueObj).doubleValue();
                }
                Cell revenueCell = row.createCell(1);
                revenueCell.setCellValue(revenue);
                revenueCell.setCellStyle(currencyStyle);

                // Xử lý các kiểu Integer (an toàn)
                row.createCell(2).setCellValue(getIntegerFromMap(rowData, "total_bookings"));
                row.createCell(3).setCellValue(getIntegerFromMap(rowData, "completed_bookings"));
                row.createCell(4).setCellValue(getIntegerFromMap(rowData, "cancelled_bookings"));
                row.createCell(5).setCellValue(getIntegerFromMap(rowData, "no_show_bookings"));
                row.createCell(6).setCellValue(getIntegerFromMap(rowData, "pending_bookings"));
                row.createCell(7).setCellValue(getIntegerFromMap(rowData, "checked_in_bookings"));
            }
        }
        for (int i = 0; i < headersTrend.length; i++) {
            trendSheet.autoSizeColumn(i);
        }

        // Kết thúc và ghi workbook
        workbook.write(outputStream);
        workbook.close();
    }

    // Hàm tiện ích private để lấy số nguyên từ Map một cách an toàn
    private int getIntegerFromMap(Map<String, Object> map, String key) {
        Object obj = map.get(key);
        if (obj instanceof Number) {
            return ((Number) obj).intValue();
        }
        return 0; // Trả về 0 nếu null hoặc không phải là số
    }

}