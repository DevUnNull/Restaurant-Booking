package com.fpt.restaurantbooking.utils;


import java.io.OutputStream;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import java.io.IOException;

public class ExcelGeneratorUtil {
    public void generate(List<Map<String, Object>> data, OutputStream outputStream) throws IOException {

        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("Top Selling Report");

        CellStyle headerStyle = workbook.createCellStyle();
        Font headerFont = workbook.createFont();
        headerFont.setBold(true);
        headerStyle.setFont(headerFont);

        Row headerRow = sheet.createRow(0);
        String[] headers = {"Rank", "Dish Name", "Total Quantity Sold", "Revenue (VND)"};

        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(headerStyle);
        }

        int rowNum = 1;
        for (Map<String, Object> rowData : data) {
            Row row = sheet.createRow(rowNum++);

            row.createCell(0).setCellValue(rowNum - 1); // Rank
            row.createCell(1).setCellValue((String) rowData.get("item_name"));
            row.createCell(2).setCellValue((Integer) rowData.get("total_quantity_sold"));

            // Chuyển BigDecimal (từ DB) sang Double cho Excel
            BigDecimal revenue = (BigDecimal) rowData.get("total_revenue_from_item");
            row.createCell(3).setCellValue(revenue.doubleValue());
        }

        for (int i = 0; i < headers.length; i++) {
            sheet.autoSizeColumn(i);
        }

        workbook.write(outputStream);
        workbook.close();
    }


    public void generateOverviewReport(Map<String, Object> summaryData, List<Map<String, Object>> timeTrendData, OutputStream outputStream) throws IOException {
        Workbook workbook = new XSSFWorkbook();

        // Summary Sheet
        Sheet summarySheet = workbook.createSheet("Summary");
        CellStyle headerStyle = workbook.createCellStyle();
        Font headerFont = workbook.createFont();
        headerFont.setBold(true);
        headerStyle.setFont(headerFont);

        Row headerRow = summarySheet.createRow(0);
        headerRow.createCell(0).setCellValue("Metric");
        headerRow.createCell(1).setCellValue("Value");
        headerRow.getCell(0).setCellStyle(headerStyle);
        headerRow.getCell(1).setCellStyle(headerStyle);

        Row dataRow1 = summarySheet.createRow(1);
        dataRow1.createCell(0).setCellValue("Total Bookings");
        dataRow1.createCell(1).setCellValue((Integer) summaryData.getOrDefault("totalBookings", 0));

        Row dataRow2 = summarySheet.createRow(2);
        dataRow2.createCell(0).setCellValue("Total Revenue (VND)");
        dataRow2.createCell(1).setCellValue((Long) summaryData.getOrDefault("totalRevenue", 0L));

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
        trendHeader.createCell(0).setCellValue("Label");
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
                row.createCell(0).setCellValue((String) item.getOrDefault("label", ""));
                row.createCell(1).setCellValue((Long) item.getOrDefault("totalRevenue", 0L));
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