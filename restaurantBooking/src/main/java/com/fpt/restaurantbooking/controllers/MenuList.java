package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.models.MenuCategory;
import com.fpt.restaurantbooking.models.MenuItem;
import com.fpt.restaurantbooking.models.Promotions;
import com.fpt.restaurantbooking.repositories.impl.MenuRepository;
import com.fpt.restaurantbooking.repositories.impl.VoucherRepository;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Quandxnunxi28
 */
@WebServlet(name="MenuList", urlPatterns={"/MenuList"})
public class MenuList extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
MenuRepository menuRepository = new MenuRepository();
        try {
            List<MenuItem> listmenuItem = menuRepository.getMenuItemsAlk();
            if(listmenuItem.isEmpty()|| listmenuItem==null){
                request.getRequestDispatcher("/WEB-INF/Time_slot/TimeDetail.jsp").forward(request, response);
                return;
            }
request.setAttribute("listmenuItem", listmenuItem);

            RequestDispatcher rd =  request.getRequestDispatcher("/WEB-INF/Service/MenuList.jsp");
            rd.include(request, response);
        } catch (SQLException e) {
            throw new RuntimeException(e);
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



