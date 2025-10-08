/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.models.Service;
import com.fpt.restaurantbooking.repositories.impl.ServiceRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;
/**
 *
 * @author Quandxnunxi28
 */
@WebServlet(name = "ServiceList", urlPatterns = {"/ServiceList"})
public class ServiceList extends HttpServlet {
 private static final Logger logger = Logger.getLogger(ServiceList.class.getName());
    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
     List<Service> list = new  ArrayList<>();
        ServiceRepository ServiceDao = new ServiceRepository();
        int page = 1;
        int recordsPerPage = 10;

        if (request.getParameter("page") != null) {
            try {
                page = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        int offset = (page - 1) * recordsPerPage;
                
        try {
            List<Service> listPaginate= ServiceDao.getServicesByPageShowList(offset, recordsPerPage);
            int totalRecords = ServiceDao.getService().size();
            int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
            request.setAttribute("kakao", listPaginate);
          request.setAttribute("currentPage", page);
          request.setAttribute("totalPages", totalPages);
        } catch (Exception e) {
        }
        
        
        
              request.getRequestDispatcher("/WEB-INF/Service/ServiceList.jsp").forward(request, response);
        
     
      // response.sendRedirect("/WEB-INF/Service/ManageService.jsp");
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Service> list = new  ArrayList<>();
        ServiceRepository ServiceDao = new ServiceRepository();
        int page = 1;
        int recordsPerPage = 10;

        if (request.getParameter("page") != null) {
            try {
                page = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        int offset = (page - 1) * recordsPerPage;
                
        try {
            List<Service> listPaginate= ServiceDao.getServicesByPageShowList(offset, recordsPerPage);
            int totalRecords = ServiceDao.getService().size();
            int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
            request.setAttribute("kakao", listPaginate);
          request.setAttribute("currentPage", page);
          request.setAttribute("totalPages", totalPages);
        } catch (Exception e) {
        }
        
        
        
              request.getRequestDispatcher("/WEB-INF/Service/ServiceList.jsp").forward(request, response);
        
     
      // response.sendRedirect("/WEB-INF/Service/ManageService.jsp");
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
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
