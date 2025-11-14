package com.fpt.restaurantbooking.utils;

import com.itextpdf.io.font.PdfEncodings;
import com.itextpdf.kernel.font.PdfFont;
import com.itextpdf.kernel.font.PdfFontFactory;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.element.AreaBreak;
import com.itextpdf.layout.element.Paragraph;
import com.itextpdf.layout.element.Table;
import com.itextpdf.layout.properties.AreaBreakType;
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
     * Tạo báo cáo PDF cho danh sách món ăn bán chạy nhất. (Hàm này có vẻ cũ, giữ lại)
     */
    public void generate(List<Map<String, Object>> data, OutputStream outputStream,
                         String serviceType, String status, String startDate, String endDate) throws IOException {
        // ... (Giữ nguyên code của hàm này, không thay đổi) ...
        PdfFont font;
        try {
            font = PdfFontFactory.createFont(
                    VIETNAMESE_FONT_PATH,
                    PdfEncodings.IDENTITY_H,
                    PdfFontFactory.EmbeddingStrategy.PREFER_EMBEDDED
            );
        } catch (IOException e) {
            throw new IOException("Lỗi Font: Không tìm thấy font tiếng Việt tại đường dẫn: "
                    + VIETNAMESE_FONT_PATH + ". Vui lòng kiểm tra lại đường dẫn.", e);
        }

        try {
            PdfWriter writer = new PdfWriter(outputStream);
            PdfDocument pdf = new PdfDocument(writer);
            Document document = new Document(pdf);

            document.setFont(font);
            document.add(new Paragraph("BÁO CÁO MÓN BÁN CHẠY NHẤT")
                    .setBold().setFontSize(16).setTextAlignment(TextAlignment.CENTER).setFont(font));
            document.add(new Paragraph("Ngày Lập Báo Cáo: " + LocalDate.now())
                    .setFontSize(10).setTextAlignment(TextAlignment.CENTER).setFont(font));
            String filterInfo1 = "Loại Dịch Vụ: " + (serviceType != null ? serviceType : "Tất Cả") +
                    " | Trạng Thái: " + (status != null ? status.toUpperCase().replace(" ", "_") : "HOÀN THÀNH");
            document.add(new Paragraph(filterInfo1).setFontSize(10).setTextAlignment(TextAlignment.CENTER).setFont(font));
            String filterInfo2 = "Khoảng Thời Gian: " + (startDate != null ? startDate : "Bất Kỳ") + " đến " + (endDate != null ? endDate : "Bất Kỳ");
            document.add(new Paragraph(filterInfo2).setFontSize(10).setMarginBottom(15).setTextAlignment(TextAlignment.CENTER).setFont(font));
            float[] columnWidths = {1, 7, 4, 5};
            Table table = new Table(columnWidths);
            table.setWidth(UnitValue.createPercentValue(100));
            String[] headers = {"Hạng", "Tên Món/Dịch Vụ", "Số Lượng Đã Bán", "Doanh Thu (VND)"};
            for (String header : headers) {
                table.addHeaderCell(new Paragraph(header).setBold().setFont(font));
            }
            int rank = 1;
            for (Map<String, Object> rowData : data) {
                table.addCell(new Paragraph(String.valueOf(rank++)).setFont(font));
                table.addCell(new Paragraph(String.valueOf(rowData.get("item_name"))).setFont(font));
                Object quantityObj = rowData.get("total_quantity_sold");
                int quantity = (quantityObj instanceof Long) ? ((Long) quantityObj).intValue() : (Integer) quantityObj;
                table.addCell(new Paragraph(String.valueOf(quantity)).setFont(font));
                BigDecimal revenue = (BigDecimal) rowData.get("total_revenue_from_item");
                table.addCell(new Paragraph(String.format("%,.0f VND", revenue != null ? revenue.doubleValue() : 0.0))
                        .setTextAlignment(TextAlignment.RIGHT).setFont(font));
            }
            document.add(table);
            document.close();
        } catch (Exception e) {
            throw new IOException("Đã xảy ra lỗi trong quá trình tạo PDF: " + e.getMessage(), e);
        }
    }


    /**
     * Tạo báo cáo PDF cho báo cáo tổng quan. (Giữ nguyên)
     */
    public void generateOverviewReport(Map<String, Object> summaryData, List<Map<String, Object>> timeTrendData, OutputStream outputStream) throws IOException {
        // ... (Giữ nguyên code của hàm này, không thay đổi) ...
        PdfFont font;
        try {
            font = PdfFontFactory.createFont(
                    VIETNAMESE_FONT_PATH,
                    PdfEncodings.IDENTITY_H,
                    PdfFontFactory.EmbeddingStrategy.PREFER_EMBEDDED
            );
        } catch (IOException e) {
            throw new IOException("Lỗi Font: Không tìm thấy font tiếng Việt tại đường dẫn: "
                    + VIETNAMESE_FONT_PATH + ". Vui lòng kiểm tra lại đường dẫn.", e);
        }

        try {
            PdfWriter writer = new PdfWriter(outputStream);
            PdfDocument pdf = new PdfDocument(writer);
            Document document = new Document(pdf);

            document.setFont(font);
            document.add(new Paragraph("BÁO CÁO TỔNG QUAN")
                    .setBold().setFontSize(16).setTextAlignment(TextAlignment.CENTER).setFont(font));
            document.add(new Paragraph("Ngày Lập Báo Cáo: " + LocalDate.now())
                    .setFontSize(10).setMarginBottom(15).setTextAlignment(TextAlignment.CENTER).setFont(font));
            document.add(new Paragraph("Tóm Tắt Chung")
                    .setBold().setFontSize(14).setMarginBottom(10).setFont(font));
            document.add(new Paragraph("Tổng Số Lượt Đặt Bàn: " + summaryData.getOrDefault("totalBookings", 0))
                    .setFont(font));
            Object revenueObj = summaryData.getOrDefault("totalRevenue", 0L);
            long revenueValue = 0L;
            if (revenueObj instanceof Long) {
                revenueValue = (Long) revenueObj;
            } else if (revenueObj instanceof BigDecimal) {
                revenueValue = ((BigDecimal) revenueObj).longValue();
            }
            document.add(new Paragraph("Tổng Doanh Thu (VND): " + String.format("%,d", revenueValue))
                    .setFont(font));
            document.add(new Paragraph("Tổng Số Lượt Hủy: " + summaryData.getOrDefault("totalCancellations", 0))
                    .setFont(font));
            document.add(new Paragraph("Tỷ Lệ Hủy (%): " + String.format("%.2f", summaryData.getOrDefault("cancellationRate", 0.0)))
                    .setFont(font));
            document.add(new Paragraph("\nBiểu Đồ Xu Hướng Thời Gian")
                    .setBold().setFontSize(14).setMarginTop(15).setMarginBottom(10).setFont(font));
            float[] columnWidths = {3, 3, 2, 2};
            Table table = new Table(columnWidths);
            table.setWidth(UnitValue.createPercentValue(100));
            table.addHeaderCell(new Paragraph("Ngày").setBold().setFont(font));
            table.addHeaderCell(new Paragraph("Doanh Thu (VND)").setBold().setFont(font));
            table.addHeaderCell(new Paragraph("Lượt Đặt Bàn").setBold().setFont(font));
            table.addHeaderCell(new Paragraph("Lượt Hủy").setBold().setFont(font));
            if (timeTrendData != null) {
                for (Map<String, Object> item : timeTrendData) {
                    table.addCell(new Paragraph((String) item.getOrDefault("date", "")).setFont(font));
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
            throw new IOException("Đã xảy ra lỗi trong quá trình tạo PDF: " + e.getMessage(), e);
        }
    }

// ... (Hàm generateOverviewReport và các import giữ nguyên) ...

    // === SỬA ĐỔI PHƯƠNG THỨC NÀY ===
    public void generateServiceReport(List<Map<String, Object>> topSellingItems,
                                      List<Map<String, Object>> trendData, // Thêm tham số này
                                      OutputStream outputStream,
                                      String serviceType, String status, String startDate, String endDate) throws IOException {

        PdfFont font;
        try {
            font = PdfFontFactory.createFont(
                    VIETNAMESE_FONT_PATH,
                    PdfEncodings.IDENTITY_H,
                    PdfFontFactory.EmbeddingStrategy.PREFER_EMBEDDED
            );
        } catch (IOException e) {
            throw new IOException("Lỗi Font: " + VIETNAMESE_FONT_PATH, e);
        }

        try {
            PdfWriter writer = new PdfWriter(outputStream);
            PdfDocument pdf = new PdfDocument(writer);
            Document document = new Document(pdf);
            document.setFont(font);

            String filterStatus = (status != null && !status.trim().isEmpty()) ? status.toUpperCase().replace(" ", "_") : "Tất Cả";
            String filterInfo1 = "Loại Dịch Vụ: " + (serviceType != null ? serviceType : "Tất Cả") +
                    " | Trạng Thái: " + filterStatus;
            String filterInfo2 = "Khoảng Thời Gian: " + (startDate != null ? startDate : "Bất Kỳ") + " đến " + (endDate != null ? endDate : "Bất Kỳ");

            // ==============================================
            // TRANG 1: CHI TIẾT CÁC MÓN BÁN CHẠY NHẤT
            // ==============================================
            document.add(new Paragraph("BÁO CÁO DỊCH VỤ (TRANG 1/2)")
                    .setBold().setFontSize(16).setTextAlignment(TextAlignment.CENTER).setFont(font));
            document.add(new Paragraph("Ngày Lập Báo Cáo: " + LocalDate.now())
                    .setFontSize(10).setTextAlignment(TextAlignment.CENTER).setFont(font));
            document.add(new Paragraph(filterInfo1).setFontSize(10).setTextAlignment(TextAlignment.CENTER).setFont(font));
            document.add(new Paragraph(filterInfo2).setFontSize(10).setMarginBottom(20).setTextAlignment(TextAlignment.CENTER).setFont(font));

            document.add(new Paragraph("CHI TIẾT: CÁC MÓN BÁN CHẠY NHẤT")
                    .setBold().setFontSize(14).setMarginBottom(10).setFont(font));

            float[] columnWidthsTop = {1, 5, 3, 4};
            Table tableTop = new Table(columnWidthsTop);
            tableTop.setWidth(UnitValue.createPercentValue(100));

            String[] headersTop = {"Hạng", "Tên Món Ăn/Dịch Vụ", "Số Lượng Đã Bán", "Doanh Thu (VND)"};
            for (String header : headersTop) {
                tableTop.addHeaderCell(new Paragraph(header).setBold().setFont(font));
            }

            int rank = 1;
            if (topSellingItems != null) {
                for (Map<String, Object> rowData : topSellingItems) {
                    tableTop.addCell(new Paragraph(String.valueOf(rank++)).setFont(font));
                    tableTop.addCell(new Paragraph(String.valueOf(rowData.get("item_name"))).setFont(font));

                    Object quantityObj = rowData.get("total_quantity_sold");
                    int quantity = (quantityObj instanceof Long) ? ((Long) quantityObj).intValue() : (Integer) quantityObj;
                    tableTop.addCell(new Paragraph(String.valueOf(quantity)).setTextAlignment(TextAlignment.RIGHT).setFont(font));

                    BigDecimal revenue = (BigDecimal) rowData.get("total_revenue_from_item");
                    tableTop.addCell(new Paragraph(String.format("%,.0f VND", revenue != null ? revenue.doubleValue() : 0.0))
                            .setTextAlignment(TextAlignment.RIGHT).setFont(font));
                }
            }
            document.add(tableTop);

            // ==============================================
            // TRANG 2: XU HƯỚNG DOANH THU (PHẦN MỚI)
            // ==============================================
            document.add(new AreaBreak(AreaBreakType.NEXT_PAGE)); // Ngắt trang

            document.add(new Paragraph("BÁO CÁO DỊCH VỤ (TRANG 2/2)")
                    .setBold().setFontSize(16).setTextAlignment(TextAlignment.CENTER).setFont(font));
            document.add(new Paragraph(filterInfo1).setFontSize(10).setTextAlignment(TextAlignment.CENTER).setFont(font));
            document.add(new Paragraph(filterInfo2).setFontSize(10).setMarginBottom(20).setTextAlignment(TextAlignment.CENTER).setFont(font));

            document.add(new Paragraph("CHI TIẾT: XU HƯỚNG DOANH THU & ĐẶT BÀN")
                    .setBold().setFontSize(14).setMarginBottom(10).setFont(font));

            // Cần 8 cột
            float[] columnWidthsTrend = {3, 4, 2, 2, 2, 2, 2, 2};
            Table tableTrend = new Table(columnWidthsTrend);
            tableTrend.setWidth(UnitValue.createPercentValue(100));

            String[] headersTrend = {"Ngày", "Doanh Thu", "Tổng", "Hoàn Thành", "Hủy", "K.Đến", "Chờ", "Đã X.Nhận"};
            for (String header : headersTrend) {
                tableTrend.addHeaderCell(new Paragraph(header).setBold().setFont(font).setFontSize(9));
            }

            if (trendData != null) {
                for (Map<String, Object> rowData : trendData) {
                    tableTrend.addCell(new Paragraph(rowData.get("report_date").toString()).setFontSize(9));

                    BigDecimal revenue = (BigDecimal) rowData.get("total_revenue");
                    tableTrend.addCell(new Paragraph(String.format("%,.0f VND", revenue.doubleValue()))
                            .setTextAlignment(TextAlignment.RIGHT).setFontSize(9));

                    tableTrend.addCell(new Paragraph(String.valueOf(rowData.get("total_bookings"))).setTextAlignment(TextAlignment.RIGHT).setFontSize(9));
                    tableTrend.addCell(new Paragraph(String.valueOf(rowData.get("completed_bookings"))).setTextAlignment(TextAlignment.RIGHT).setFontSize(9));
                    tableTrend.addCell(new Paragraph(String.valueOf(rowData.get("cancelled_bookings"))).setTextAlignment(TextAlignment.RIGHT).setFontSize(9));
                    tableTrend.addCell(new Paragraph(String.valueOf(rowData.get("no_show_bookings"))).setTextAlignment(TextAlignment.RIGHT).setFontSize(9));
                    tableTrend.addCell(new Paragraph(String.valueOf(rowData.get("pending_bookings"))).setTextAlignment(TextAlignment.RIGHT).setFontSize(9));
                    tableTrend.addCell(new Paragraph(String.valueOf(rowData.get("checked_in_bookings"))).setTextAlignment(TextAlignment.RIGHT).setFontSize(9));
                }
            }
            document.add(tableTrend);

            // Đóng tài liệu
            document.close();

        } catch (Exception e) {
            throw new IOException("Đã xảy ra lỗi trong quá trình tạo PDF: " + e.getMessage(), e);
        }
    }
}