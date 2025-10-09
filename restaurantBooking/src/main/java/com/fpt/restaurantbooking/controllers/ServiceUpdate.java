/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package com.fpt.restaurantbooking.controllers;


import com.fpt.restaurantbooking.repositories.impl.ServiceRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Quandxnunxi28
 */
@WebServlet(name="ServiceUpdate", urlPatterns={"/ServiceUpdate"})
public class ServiceUpdate extends HttpServlet {
   
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
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ServiceUpdate</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ServiceUpdate at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
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
        String serviceCode = request.getParameter("serviceId");
        String serviceName = request.getParameter("serviceName");
        String description = request.getParameter("description");
        String price = request.getParameter("price");
        String status = request.getParameter("status");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        ServiceRepository dao = new ServiceRepository();
        String erkaka;


        if(serviceName.isEmpty()){
            erkaka = "Service name must not be empty";
            request.setAttribute("erkaka", erkaka);
            request.getRequestDispatcher("ServiceManage").forward(request, response);
            return;
        }else if(description.isEmpty()){
            erkaka = "Description must not be empty";
            request.setAttribute("erkaka", erkaka);
            request.getRequestDispatcher("ServiceManage").forward(request, response);
            return;
        }else if(price.isEmpty()){
            erkaka = "Price must not be empty";
            request.setAttribute("erkaka", erkaka);
            request.getRequestDispatcher("ServiceManage").forward(request, response);
            return;
        }else if(status.isEmpty()){
            erkaka = "Status must not be empty";
            request.setAttribute("erkaka", erkaka);
            request.getRequestDispatcher("ServiceManage").forward(request, response);
            return;
        }else if(startDate.isEmpty()){
            erkaka = "Start date must not be empty";
            request.setAttribute("erkaka", erkaka);
            request.getRequestDispatcher("ServiceManage").forward(request, response);
            return;
        }else if(endDate.isEmpty()){
            erkaka = "End date must not be empty";
            request.setAttribute("erkaka", erkaka);
            request.getRequestDispatcher("ServiceManage").forward(request, response);
            return;
        }

        try {
            dao.updateService(serviceName, description, price, status, startDate, endDate, serviceCode);
            response.sendRedirect("ServiceManage");
        } catch (SQLException ex) {
            ex.printStackTrace();

            // In ra trình duyệt để dễ debug
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();

            out.println("<html><body style='font-family:monospace;background:#111;color:#f55;'>");
            out.println("<h2>Lỗi SQL xảy ra!</h2>");
            out.println("<p><strong>Message:</strong> " + ex.getMessage() + "</p>");
            out.println("<p><strong>SQLState:</strong> " + ex.getSQLState() + "</p>");
            out.println("<p><strong>Error Code:</strong> " + ex.getErrorCode() + "</p>");
            out.println("<hr>");
            out.println("<pre>");
            ex.printStackTrace(out);
            out.println("</pre>");
            out.println("</body></html>");
            out.close();
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
