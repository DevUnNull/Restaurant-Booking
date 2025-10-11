package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.models.Promotions;
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
 *
 * @author Quandxnunxi28
 */
@WebServlet(name="AddVoucherController", urlPatterns={"/AddVoucherController"})
public class AddVoucherController
        extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");



        VoucherRepository vrepo = new VoucherRepository();
        try {
            List<Promotions> promotions = vrepo.getAllPromotions(1);
            request.setAttribute("promotions", promotions);
            request.getRequestDispatcher("/WEB-INF/Voucher/ManageVoucher.jsp").forward(request, response);
        }catch (Exception ex){

        }



    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {



        processRequest(request, response);




    }

    /**
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("promotionName");
        String description = request.getParameter("description");
        String discount_p= request.getParameter("discount_percentage");
        String discountAmount= request.getParameter("discount_amount");
        String start_date = request.getParameter("start_date");
        String end_date = request.getParameter("end_date");
        String status = request.getParameter("status");
        String promotion_level_id = request.getParameter("promotion_level_id");
String created_by = request.getParameter("created_by");

String er;
if(name.isEmpty()){
    er="name must not be empty";
    request.setAttribute("errorMessageee", er);
    processRequest(request, response);
    return;
}else if(description.isEmpty()){
    er="description must not be empty";
    request.setAttribute("errorMessageee", er);
    processRequest(request, response);
    return;
        }else if(discount_p.isEmpty()){
    er="discount_percentage must not be empty";
    request.setAttribute("errorMessageee", er);
    processRequest(request, response);
    return;
}else if(discountAmount.isEmpty()){
    er="discount_amount must not be empty";
    request.setAttribute("errorMessageee", er);
        processRequest(request, response);
        return;
}else if(start_date.isEmpty()){
    er="start_date must not be empty";
    request.setAttribute("errorMessageee", er);
    processRequest(request, response);
    return;
}else if(end_date.isEmpty()){
    er="end_date must not be empty";
    request.setAttribute("errorMessageee", er);
    processRequest(request, response);
    return;
}else if(promotion_level_id.isEmpty()){
    er="promotion_level_id must not be empty";
    request.setAttribute("errorMessageee", er);
    processRequest(request, response);
    return;
}
        VoucherRepository vrepo = new VoucherRepository();
        try {
            vrepo.addVoucher(name, description,discount_p,discountAmount,start_date,end_date,status,promotion_level_id,created_by );
            processRequest(request, response);
            return;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }


    }

    /**
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}

