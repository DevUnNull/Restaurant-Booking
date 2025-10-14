
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
@WebServlet(name="VoucherController", urlPatterns={"/Voucher"})
public class VoucherController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        int page = 1;
        int recordsPerPage = 6;
        if (request.getParameter("page") != null) {
            try {
                page = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        Promotions promo= (Promotions) request.getAttribute("pro");
        int offset = (page - 1) * recordsPerPage;
        try {
            VoucherRepository vrepo = new VoucherRepository();
            List<Promotions> promotions = vrepo.getVouchersByPage(promo.getPromotion_level_id(), offset, recordsPerPage);
            int totalRecords = vrepo.getAllPromotions(promo.getPromotion_level_id()).size();
            int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
            request.setAttribute("kaku", promo.getPromotion_level_id());
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("promotions", promotions);
            request.getRequestDispatcher("/WEB-INF/Voucher/ManageVoucher.jsp").forward(request, response);
        }catch (Exception ex){
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        int page = 1;
        int recordsPerPage = 6;
        if (request.getParameter("page") != null) {
            try {
                page = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        int offset = (page - 1) * recordsPerPage;


        List<Promotions> promotions = new ArrayList<>();
        VoucherRepository vrepo = new VoucherRepository();
        String idLevel = request.getParameter("idlevel");
        if(idLevel==null){
            try {
                promotions = vrepo.getVouchersByPage(1, offset, recordsPerPage);
                int totalRecords = vrepo.getAllPromotions(1).size();
                int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
                request.setAttribute("currentPage", page);
                request.setAttribute("totalPages", totalPages);
                request.setAttribute("promotions", promotions);
                request.setAttribute("kaku",idLevel);
                request.getRequestDispatcher("/WEB-INF/Voucher/ManageVoucher.jsp").forward(request, response);
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
            request.setAttribute("promotions", promotions);
        }else{
            try {
                promotions = vrepo.getVouchersByPage(Integer.parseInt(idLevel), offset, recordsPerPage);
                int totalRecords = vrepo.getAllPromotions(Integer.parseInt(idLevel)).size();
                int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
                request.setAttribute("currentPage", page);
                request.setAttribute("totalPages", totalPages);
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
            Promotions pro = vrepo.getIdWithUpdate(Integer.parseInt(id));
            vrepo.UpdatePromotion(id,nameVoucher,description,discount_percentage,start_date,end_date, updated_by);
            request.setAttribute("pro", pro);
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


