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
     * Sửa: Thêm tham số lọc để đưa vào tiêu đề báo cáo
     */
    public void generate(List<Map<String, Object>> data, OutputStream outputStream,
                         String serviceType, String status, String startDate, String endDate) throws IOException {

        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("Top Selling Report");

        // Style for Header
        CellStyle headerStyle = workbook.createCellStyle();
        Font headerFont = workbook.createFont();
        headerFont.setBold(true);
        headerStyle.setFont(headerFont);

        // Style for Data (Revenue column)
        CellStyle currencyStyle = workbook.createCellStyle();
        currencyStyle.setDataFormat(workbook.createDataFormat().getFormat("#,##0")); // Định dạng số không thập phân

        // Tiêu đề chính
        Row titleRow = sheet.createRow(0);
        titleRow.createCell(0).setCellValue("BÁO CÁO MÓN BÁN CHẠY NHẤT");
        titleRow.getCell(0).setCellStyle(headerStyle);

        // Thông tin lọc
        Row filterRow1 = sheet.createRow(1);
        filterRow1.createCell(0).setCellValue("Service Type: " + (serviceType != null ? serviceType : "All"));
        filterRow1.createCell(1).setCellValue("Status: " + (status != null ? status.toUpperCase().replace(" ", "_") : "COMPLETED"));

        Row filterRow2 = sheet.createRow(2);
        filterRow2.createCell(0).setCellValue("Date Range: " + (startDate != null ? startDate : "Any") + " to " + (endDate != null ? endDate : "Any"));


        // Header Columns
        Row headerRow = sheet.createRow(4); // Bắt đầu từ dòng 4 (sau tiêu đề và lọc)
        String[] headers = {"Rank", "Dish Name", "Total Quantity Sold", "Revenue (VND)"};

        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(headerStyle);
        }

        // Data Rows
        int rowNum = 5;
        for (Map<String, Object> rowData : data) {
            Row row = sheet.createRow(rowNum++);

            row.createCell(0).setCellValue(rowNum - 5); // Rank
            row.createCell(1).setCellValue((String) rowData.get("item_name"));

            // Xử lý an toàn cho Integer
            Object quantityObj = rowData.get("total_quantity_sold");
            int quantity = (quantityObj instanceof Long) ? ((Long) quantityObj).intValue() : (Integer) quantityObj;
            row.createCell(2).setCellValue(quantity);

            // Xử lý an toàn cho BigDecimal
            BigDecimal revenue = (BigDecimal) rowData.get("total_revenue_from_item");
            Cell revenueCell = row.createCell(3);
            revenueCell.setCellValue(revenue != null ? revenue.doubleValue() : 0.0);
            revenueCell.setCellStyle(currencyStyle);
        }

        // Auto size columns
        for (int i = 0; i < headers.length; i++) {
            sheet.autoSizeColumn(i);
        }

        // Merge cells for Title
        sheet.addMergedRegion(new org.apache.poi.ss.util.CellRangeAddress(0, 0, 0, headers.length - 1));

        workbook.write(outputStream);
        workbook.close();
    }


    /**
     * Sửa: Cập nhật cấu trúc Summary Sheet để phù hợp với kiểu dữ liệu Long/BigDecimal
     */
    public void generateOverviewReport(Map<String, Object> summaryData, List<Map<String, Object>> timeTrendData, OutputStream outputStream) throws IOException {
        Workbook workbook = new XSSFWorkbook();

        // Style for Header
        CellStyle headerStyle = workbook.createCellStyle();
        Font headerFont = workbook.createFont();
        headerFont.setBold(true);
        headerStyle.setFont(headerFont);

        // Style for Currency (Long/BigDecimal)
        CellStyle currencyStyle = workbook.createCellStyle();
        currencyStyle.setDataFormat(workbook.createDataFormat().getFormat("#,##0"));


        // Summary Sheet
        Sheet summarySheet = workbook.createSheet("Summary");
        Row headerRow = summarySheet.createRow(0);
        headerRow.createCell(0).setCellValue("Metric");
        headerRow.createCell(1).setCellValue("Value");
        headerRow.getCell(0).setCellStyle(headerStyle);
        headerRow.getCell(1).setCellStyle(headerStyle);

        Row dataRow1 = summarySheet.createRow(1);
        dataRow1.createCell(0).setCellValue("Total Bookings");
        dataRow1.createCell(1).setCellValue((Integer) summaryData.getOrDefault("totalBookings", 0));

        // Dùng BigInteger/Long cho Revenue
        Row dataRow2 = summarySheet.createRow(2);
        dataRow2.createCell(0).setCellValue("Total Revenue (VND)");
        Cell revenueCell = dataRow2.createCell(1);

        // Hỗ trợ cả Long và BigDecimal cho Total Revenue
        Object revenueObj = summaryData.getOrDefault("totalRevenue", 0L);
        double revenueValue = 0.0;
        if (revenueObj instanceof Long) {
            revenueValue = ((Long) revenueObj).doubleValue();
        } else if (revenueObj instanceof BigDecimal) {
            revenueValue = ((BigDecimal) revenueObj).doubleValue();
        }

        revenueCell.setCellValue(revenueValue);
        revenueCell.setCellStyle(currencyStyle);


        Row dataRow3 = summarySheet.createRow(3);
        dataRow3.createCell(0).setCellValue("Total Cancellations");
        dataRow3.createCell(1).setCellValue((Integer) summaryData.getOrDefault("totalCancellations", 0));

        Row dataRow4 = summarySheet.createRow(4);
        dataRow4.createCell(0).setCellValue("Cancellation Rate (%)");
        dataRow4.createCell(1).setCellValue((Double) summaryData.getOrDefault("cancellationRate", 0.0));

        for (int i = 0; i < 2; i++) {
            summarySheet.autoSizeColumn(i);
        }

        // Time Trend Sheet
        Sheet trendSheet = workbook.createSheet("Time Trend");
        Row trendHeader = trendSheet.createRow(0);
        trendHeader.createCell(0).setCellValue("Date");
        trendHeader.createCell(1).setCellValue("Revenue (VND)");
        trendHeader.createCell(2).setCellValue("Bookings");
        trendHeader.createCell(3).setCellValue("Cancellations");
        for (int i = 0; i < 4; i++) {
            trendHeader.getCell(i).setCellStyle(headerStyle);
        }

        if (timeTrendData != null) {
            for (int i = 0; i < timeTrendData.size(); i++) {
                Row row = trendSheet.createRow(i + 1);
                Map<String, Object> item = timeTrendData.get(i);

                // Date/Month
                row.createCell(0).setCellValue((String) item.getOrDefault("date", ""));

                // Revenue
                Cell trendRevenueCell = row.createCell(1);
                Object trendRevenueObj = item.getOrDefault("totalRevenue", 0L);
                double trendRevenueValue = 0.0;
                if (trendRevenueObj instanceof Long) {
                    trendRevenueValue = ((Long) trendRevenueObj).doubleValue();
                } else if (trendRevenueObj instanceof BigDecimal) {
                    trendRevenueValue = ((BigDecimal) trendRevenueObj).doubleValue();
                }

                trendRevenueCell.setCellValue(trendRevenueValue);
                trendRevenueCell.setCellStyle(currencyStyle);

                // Bookings & Cancellations
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
}