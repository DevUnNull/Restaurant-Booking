
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
import java.util.ArrayList;
import java.util.List;

/**
 * @author Quandxnunxi28
 */
@WebServlet(name = "Time_Table", urlPatterns = {"/Time_Table"})
public class Time_Table extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        int day = Integer.parseInt(request.getParameter("day"));
        int month = Integer.parseInt(request.getParameter("month"));
        int year = Integer.parseInt(request.getParameter("year"));

        LocalDate localDate = java.time.LocalDate.of(year, month, day);
        java.sql.Date applicableDate = java.sql.Date.valueOf(localDate);

        TimeRepository timeDAO= new TimeRepository();
        try {
            TimeSlot time = timeDAO.getDate(year , month, day);
            //nếu null thì cuyển hớng đến trang mặc định
            if(time==null){
                request.setAttribute("localDate", localDate);
                request.getRequestDispatcher("/WEB-INF/Time_slot/Detail_Time.jsp").forward(request, response);
            }else{
                request.setAttribute("localDate", localDate);
                request.setAttribute("time", time);
                request.getRequestDispatcher("/WEB-INF/Time_slot/Detail__Time.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }







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






