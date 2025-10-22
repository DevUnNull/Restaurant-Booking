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
}