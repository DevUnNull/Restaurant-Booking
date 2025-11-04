
package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.models.MenuItem;
import com.fpt.restaurantbooking.models.Promotions;
import com.fpt.restaurantbooking.repositories.impl.ServiceRepository;
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
@WebServlet(name = "DeleteItemsFromComboController", urlPatterns = {"/DeleteItemsFromCombo"})
public class DeleteItemsFromComboController extends HttpServlet {

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

    String serviceId =  request.getParameter("serviceId");
            String[] selectedItemIds = request.getParameterValues("selectedItems");
            ServiceRepository serviceRepository = new ServiceRepository();
            if (selectedItemIds == null || selectedItemIds.length == 0) {
                response.sendRedirect("ServiceManage?error=1&serviceId=" + serviceId);
                return;
            }
            if (selectedItemIds != null) {
                for (String itemIdStr : selectedItemIds) {
                    int itemId = Integer.parseInt(itemIdStr);
                    serviceRepository.deleteItemCombo(serviceId, itemId);
                    request.setAttribute("falseee", "Đã xóa thành công!!!");
                }
            }
            response.sendRedirect("ServiceManage?deleted=1");
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





