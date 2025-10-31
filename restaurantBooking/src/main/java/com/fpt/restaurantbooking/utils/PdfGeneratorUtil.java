package com.fpt.restaurantbooking.utils;

import com.itextpdf.io.font.PdfEncodings;
import com.itextpdf.kernel.font.PdfFont;
import com.itextpdf.kernel.font.PdfFontFactory;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.element.Paragraph;
import com.itextpdf.layout.element.Table;
import com.itextpdf.layout.properties.TextAlignment;
import com.itextpdf.layout.properties.UnitValue;
import java.io.IOException;
import java.io.OutputStream;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

public class PdfGeneratorUtil {

    // Giữ nguyên đường dẫn Font
    public static final String VIETNAMESE_FONT_PATH = "C:/Windows/Fonts/Arial.ttf";

    /**
     * Sửa: Thêm tham số lọc để đưa vào tiêu đề báo cáo
     */
    public void generate(List<Map<String, Object>> data, OutputStream outputStream,
                         String serviceType, String status, String startDate, String endDate) throws IOException {

        PdfFont font;
        try {
            font = PdfFontFactory.createFont(
                    VIETNAMESE_FONT_PATH,
                    PdfEncodings.IDENTITY_H,
                    PdfFontFactory.EmbeddingStrategy.PREFER_EMBEDDED
            );
        } catch (IOException e) {
            throw new IOException("Font Error: Vietnamese font not found at path: "
                    + VIETNAMESE_FONT_PATH + ". Please check the path.", e);
        }

        try {
            PdfWriter writer = new PdfWriter(outputStream);
            PdfDocument pdf = new PdfDocument(writer);
            Document document = new Document(pdf);

            document.setFont(font);

            // TIÊU ĐỀ BÁO CÁO
            document.add(new Paragraph("BÁO CÁO MÓN BÁN CHẠY NHẤT")
                    .setBold().setFontSize(16).setTextAlignment(TextAlignment.CENTER).setFont(font));
            document.add(new Paragraph("Report Date: " + LocalDate.now())
                    .setFontSize(10).setTextAlignment(TextAlignment.CENTER).setFont(font));

            // THÔNG TIN BỘ LỌC
            String filterInfo1 = "Service Type: " + (serviceType != null ? serviceType : "All") +
                    " | Status: " + (status != null ? status.toUpperCase().replace(" ", "_") : "COMPLETED");
            document.add(new Paragraph(filterInfo1).setFontSize(10).setTextAlignment(TextAlignment.CENTER).setFont(font));

            String filterInfo2 = "Date Range: " + (startDate != null ? startDate : "Any") + " to " + (endDate != null ? endDate : "Any");
            document.add(new Paragraph(filterInfo2).setFontSize(10).setMarginBottom(15).setTextAlignment(TextAlignment.CENTER).setFont(font));


            // Create Table
            float[] columnWidths = {1, 7, 4, 5};
            Table table = new Table(columnWidths);
            table.setWidth(UnitValue.createPercentValue(100));

            String[] headers = {"Rank", "Item Name", "Quantity Sold", "Revenue (VND)"};
            for (String header : headers) {
                table.addHeaderCell(new Paragraph(header).setBold().setFont(font));
            }

            // Data
            int rank = 1;
            for (Map<String, Object> rowData : data) {
                table.addCell(new Paragraph(String.valueOf(rank++)).setFont(font));
                table.addCell(new Paragraph(String.valueOf(rowData.get("item_name"))).setFont(font));

                // Quantity Sold
                Object quantityObj = rowData.get("total_quantity_sold");
                int quantity = (quantityObj instanceof Long) ? ((Long) quantityObj).intValue() : (Integer) quantityObj;
                table.addCell(new Paragraph(String.valueOf(quantity)).setFont(font));

                // Revenue (VND)
                BigDecimal revenue = (BigDecimal) rowData.get("total_revenue_from_item");
                table.addCell(new Paragraph(String.format("%,.0f VND", revenue != null ? revenue.doubleValue() : 0.0))
                        .setTextAlignment(TextAlignment.RIGHT).setFont(font));
            }

            document.add(table);
            document.close();

        } catch (Exception e) {
            throw new IOException("An error occurred during PDF generation: " + e.getMessage(), e);
        }
    }


    /**
     * Sửa: Cập nhật cấu trúc Summary/Time Trend để phù hợp với kiểu dữ liệu Long/BigDecimal
     */
    public void generateOverviewReport(Map<String, Object> summaryData, List<Map<String, Object>> timeTrendData, OutputStream outputStream) throws IOException {
        PdfFont font;
        try {
            font = PdfFontFactory.createFont(
                    VIETNAMESE_FONT_PATH,
                    PdfEncodings.IDENTITY_H,
                    PdfFontFactory.EmbeddingStrategy.PREFER_EMBEDDED
            );
        } catch (IOException e) {
            throw new IOException("Font Error: Vietnamese font not found at path: "
                    + VIETNAMESE_FONT_PATH + ". Please check the path.", e);
        }

        try {
            PdfWriter writer = new PdfWriter(outputStream);
            PdfDocument pdf = new PdfDocument(writer);
            Document document = new Document(pdf);

            document.setFont(font);
            document.add(new Paragraph("OVERVIEW REPORT")
                    .setBold().setFontSize(16).setTextAlignment(TextAlignment.CENTER).setFont(font));
            document.add(new Paragraph("Report Date: " + LocalDate.now())
                    .setFontSize(10).setMarginBottom(15).setTextAlignment(TextAlignment.CENTER).setFont(font));

            // Summary Section
            document.add(new Paragraph("Summary")
                    .setBold().setFontSize(14).setMarginBottom(10).setFont(font));
            document.add(new Paragraph("Total Bookings: " + summaryData.getOrDefault("totalBookings", 0))
                    .setFont(font));

            // Xử lý Revenue an toàn hơn
            Object revenueObj = summaryData.getOrDefault("totalRevenue", 0L);
            long revenueValue = 0L;
            if (revenueObj instanceof Long) {
                revenueValue = (Long) revenueObj;
            } else if (revenueObj instanceof BigDecimal) {
                revenueValue = ((BigDecimal) revenueObj).longValue();
            }

            document.add(new Paragraph("Total Revenue (VND): " + String.format("%,d", revenueValue))
                    .setFont(font));

            document.add(new Paragraph("Total Cancellations: " + summaryData.getOrDefault("totalCancellations", 0))
                    .setFont(font));
            document.add(new Paragraph("Cancellation Rate (%): " + String.format("%.2f", summaryData.getOrDefault("cancellationRate", 0.0)))
                    .setFont(font));

            // Time Trend Section
            document.add(new Paragraph("\nTime Trend Data")
                    .setBold().setFontSize(14).setMarginTop(15).setMarginBottom(10).setFont(font));
            float[] columnWidths = {3, 3, 2, 2};
            Table table = new Table(columnWidths);
            table.setWidth(UnitValue.createPercentValue(100));

            table.addHeaderCell(new Paragraph("Date").setBold().setFont(font));
            table.addHeaderCell(new Paragraph("Revenue (VND)").setBold().setFont(font));
            table.addHeaderCell(new Paragraph("Bookings").setBold().setFont(font));
            table.addHeaderCell(new Paragraph("Cancellations").setBold().setFont(font));

            if (timeTrendData != null) {
                for (Map<String, Object> item : timeTrendData) {
                    table.addCell(new Paragraph((String) item.getOrDefault("date", "")).setFont(font));

                    // Revenue Trend (Xử lý an toàn)
                    Object trendRevenueObj = item.getOrDefault("totalRevenue", 0L);
                    long trendRevenueValue = 0L;
                    if (trendRevenueObj instanceof Long) {
                        trendRevenueValue = (Long) trendRevenueObj;
                    } else if (trendRevenueObj instanceof BigDecimal) {
                        trendRevenueValue = ((BigDecimal) trendRevenueObj).longValue();
                    }

                    table.addCell(new Paragraph(String.format("%,d", trendRevenueValue))
                            .setTextAlignment(TextAlignment.RIGHT).setFont(font));

                    table.addCell(new Paragraph(String.valueOf(item.getOrDefault("totalBookings", 0)))
                            .setTextAlignment(TextAlignment.RIGHT).setFont(font));
                    table.addCell(new Paragraph(String.valueOf(item.getOrDefault("totalCancellations", 0)))
                            .setTextAlignment(TextAlignment.RIGHT).setFont(font));
                }
            }

            document.add(table);
            document.close();

        } catch (Exception e) {
            throw new IOException("An error occurred during PDF generation: " + e.getMessage(), e);
        }
    }
}