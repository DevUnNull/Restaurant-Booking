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
import java.util.List;
import java.util.logging.Logger;

/**
 *
 * @author Quandxnunxi28
 */
@WebServlet(name = "ServiceManage", urlPatterns = {"/ServiceManage"})
public class ServiceManage extends HttpServlet {

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
       response.setContentType("text/html;charset=UTF-8");
        ServiceRepository serviceDao = new ServiceRepository();
String er = (String) request.getAttribute("errorMessageAdd");
        int page = 1;
        int recordsPerPage = 8;

        if (request.getParameter("page") != null) {
            try {
                page = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        int offset = (page - 1) * recordsPerPage;

        try {
            
            // ✅ Lấy danh sách theo trang
            List<Service> paginatedList = serviceDao.getServicesByPage(offset, recordsPerPage);
            int totalRecords = serviceDao.getAllService().size();
            int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

      request.setAttribute("errorMessage", er);
      
request.setAttribute("kakao", paginatedList);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            

        } catch (Exception e) {
            logger.warning("Lỗi lấy danh sách dịch vụ: " + e.getMessage());
          
        }
 request.getRequestDispatcher("/WEB-INF/Service/ManageService.jsp").forward(request, response);
       
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
     response.setContentType("text/html;charset=UTF-8");
        ServiceRepository serviceDao = new ServiceRepository();
String er = (String) request.getAttribute("errorMessageAdd");
        int page = 1;
        int recordsPerPage = 8;

        if (request.getParameter("page") != null) {
            try {
                page = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        int offset = (page - 1) * recordsPerPage;

        try {
            
            // ✅ Lấy danh sách theo trang
            List<Service> paginatedList = serviceDao.getServicesByPage(offset, recordsPerPage);
            int totalRecords = serviceDao.getAllService().size();
            int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

      request.setAttribute("errorMessage", er);
     
request.setAttribute("kakao", paginatedList);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            

        } catch (Exception e) {
            logger.warning("Lỗi lấy danh sách dịch vụ: " + e.getMessage());
          
        }

        request.getRequestDispatcher("/WEB-INF/Service/ManageService.jsp").forward(request, response);
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
