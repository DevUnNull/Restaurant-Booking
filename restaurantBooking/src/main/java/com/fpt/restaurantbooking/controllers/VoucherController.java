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
@WebServlet(name="VoucherController", urlPatterns={"/VoucherController"})
public class VoucherController extends HttpServlet {
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

        response.setContentType("text/html;charset=UTF-8");
        List<Promotions> promotions = new ArrayList<>();
        VoucherRepository vrepo = new VoucherRepository();
        String idLevel = request.getParameter("idlevel");
        if(idLevel==null){
            try {
                promotions = vrepo.getAllPromotions(1);
                request.setAttribute("promotions", promotions);
                request.setAttribute("kaku",idLevel);
                request.getRequestDispatcher("/WEB-INF/Voucher/ManageVoucher.jsp").forward(request, response);
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
            request.setAttribute("promotions", promotions);
        }else{
            try {
                promotions = vrepo.getAllPromotions(Integer.parseInt(idLevel));
                request.setAttribute("promotions", promotions);
                request.setAttribute("kaku",idLevel);
                request.getRequestDispatcher("/WEB-INF/Voucher/ManageVoucher.jsp").forward(request, response);
            }catch (Exception ex){

            }



        }


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
        String id = request.getParameter("id");
        String nameVoucher = request.getParameter("promotionName");
        String description = request.getParameter("description");
        String discount_percentage= request.getParameter("discount_percentage");
        String start_date= request.getParameter("start_date");
        String end_date= request.getParameter("end_date");
        String updated_by = request.getParameter("updated_by");
         VoucherRepository vrepo = new VoucherRepository();
         String er;
if(nameVoucher.isEmpty()){
     er = "Name must not be empty";
     request.setAttribute("errorMessage", er);
    processRequest(request, response);
    return;
}else if(description.isEmpty()){
    er = "Description must not be empty";
    request.setAttribute("errorMessage", er);
    processRequest(request, response);
    return;
}else if(discount_percentage.isEmpty()){
    er = "Discount percentage must not be empty";
    request.setAttribute("errorMessage", er);
    processRequest(request, response);
    return;
}else if(start_date.isEmpty()){
    er = "Start date must not be empty";
    request.setAttribute("errorMessage", er);
    processRequest(request, response);
    return;
}else if(end_date.isEmpty()){
    er = "End date must not be empty";
    request.setAttribute("errorMessage", er);
    processRequest(request, response);
    return;
}

        try {
            vrepo.UpdatePromotion(id,nameVoucher,description,discount_percentage,start_date,end_date, updated_by);
            processRequest(request, response);

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

