package com.fpt.restaurantbooking.controllers;



import com.fpt.restaurantbooking.models.Promotions;
import com.fpt.restaurantbooking.models.User;
import com.fpt.restaurantbooking.repositories.impl.VoucherRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * @author Quandxnunxi28
 */
@WebServlet(name = "Promotion_level_guest_manage", urlPatterns = {"/Promotion_level"})
public class Promotion_level_guest_manage extends HttpServlet  {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
//        List<User> userList = new ArrayList<>();
//        VoucherRepository voucherRepository = new VoucherRepository();
//        try {
//            userList = voucherRepository.getAllUsertoPromotion_level_id();
//            request.setAttribute("userList", userList);
//            request.getRequestDispatcher("/WEB-INF/Voucher/Promotion_level_guest_manage.jsp").forward(request, response);
//        } catch (Exception e) {
//            throw new RuntimeException(e);
//        }






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


