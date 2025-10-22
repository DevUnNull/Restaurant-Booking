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

    public static final String VIETNAMESE_FONT_PATH = "C:/Windows/Fonts/Arial.ttf";

    public void generate(List<Map<String, Object>> data, OutputStream outputStream) throws IOException {

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
            document.add(new Paragraph("TOP SELLING ITEMS REPORT")
                    .setBold().setFontSize(16).setTextAlignment(TextAlignment.CENTER));
            document.add(new Paragraph("Report Date: " + LocalDate.now())
                    .setFontSize(10).setMarginBottom(15).setTextAlignment(TextAlignment.CENTER));

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
                table.addCell(new Paragraph(String.valueOf(rank++)));
                table.addCell(new Paragraph(String.valueOf(rowData.get("item_name"))).setFont(font));
                table.addCell(new Paragraph(String.valueOf(rowData.get("total_quantity_sold"))));

                BigDecimal revenue = (BigDecimal) rowData.get("total_revenue_from_item");
                table.addCell(new Paragraph(String.format("%,.0f VND", revenue.doubleValue()))
                        .setTextAlignment(TextAlignment.RIGHT));
            }

            document.add(table);
            document.close();

        } catch (Exception e) {
            throw new IOException("An error occurred during PDF generation: " + e.getMessage(), e);
        }
    }
}