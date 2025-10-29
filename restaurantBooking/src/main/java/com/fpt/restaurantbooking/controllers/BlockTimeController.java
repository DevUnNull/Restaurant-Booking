
package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.models.Promotions;
import com.fpt.restaurantbooking.models.TimeSlot;
import com.fpt.restaurantbooking.repositories.impl.TimeRepository;
import com.fpt.restaurantbooking.repositories.impl.VoucherRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

/**
 * @author Quandxnunxi28
 */
@WebServlet(name = "BlockTimeController", urlPatterns = {"/BlockTime"})
public class BlockTimeController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");




    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

String date= request.getParameter("applicable_date");
        DateTimeFormatter inputFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        LocalDate parsedDate = LocalDate.parse(date, inputFormatter);

        // Convert sang định dạng MySQL (thực ra vẫn là yyyy-MM-dd nên dòng này có thể bỏ)
        DateTimeFormatter mysqlFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        String mysqlDate = parsedDate.format(mysqlFormatter);
        String description = request.getParameter("slot_description");

        TimeRepository timeRepository = new TimeRepository();
        try {
            timeRepository.insertBlockTime(mysqlDate,description);
            List<TimeSlot> timeSlots = new ArrayList<>();
            timeSlots = timeRepository.getAllTimeSlot();
            request.setAttribute("timeSlots", timeSlots);
            request.getRequestDispatcher("/WEB-INF/Time_slot/ManageSingleTime.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}







