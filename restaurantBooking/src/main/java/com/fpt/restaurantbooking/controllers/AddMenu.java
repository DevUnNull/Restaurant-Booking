package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.models.MenuCategory;
import com.fpt.restaurantbooking.models.MenuItem;
import com.fpt.restaurantbooking.models.Promotions;
import com.fpt.restaurantbooking.repositories.impl.MenuRepository;
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



@WebServlet(name="AddMenu", urlPatterns={"/AddMenu"})
public class AddMenu  extends HttpServlet {

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
        Object idLevelObj = request.getAttribute("idlevel");
        String idlevel = idLevelObj != null ? idLevelObj.toString() : "1"; // default là 1 nếu chưa có

        int offset = (page - 1) * recordsPerPage;

        Object errorObj = request.getAttribute("errorMessageee");
        String errorMessageee = errorObj != null ? errorObj.toString() : null;
        MenuRepository menuRepo = new MenuRepository();
        try {
            List<MenuCategory> listMenuCategory = new ArrayList<>();
            listMenuCategory = menuRepo.getCateGory();
            List<MenuItem> menuList = menuRepo.getMenuItems(Integer.parseInt(idlevel), offset, recordsPerPage);
            int totalRecords = menuRepo.getAllMenuItems(Integer.parseInt(idlevel)).size();
            int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
            request.setAttribute("listMenuCategory", listMenuCategory);
            request.setAttribute("kaku", Integer.parseInt(idlevel));
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("menuList", menuList);
            request.setAttribute("errorMessageee", errorMessageee);
            request.getRequestDispatcher("/WEB-INF/Menu/Menu.jsp").forward(request, response);
        }catch (Exception ex){
        }
    }



    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String itemName = request.getParameter("itemName");
        String code_dish= request.getParameter("code_dish");
        String description = request.getParameter("description");
        String img_url= request.getParameter("imageFile");
        String price= request.getParameter("price");
        String categoryId = request.getParameter("categoryId");
        String status = request.getParameter("status");
        String created_by = request.getParameter("created_by");
        String er;

        if(itemName.isEmpty()){
            er="name must not be empty";
            request.setAttribute("errorMessageee", er);
            processRequest(request, response);
            return;
        }else if(description.isEmpty()){
            er="description must not be empty";
            request.setAttribute("errorMessageee", er);
            processRequest(request, response);
            return;
        }else if(price.isEmpty()){
            er="price must not be empty";
            request.setAttribute("errorMessageee", er);
            processRequest(request, response);
            return;
        }else if(categoryId.isEmpty()){
            er="category must not be empty";
            request.setAttribute("errorMessageee", er);
            processRequest(request, response);
            return;
        }else if(status.isEmpty()){
            er="status must not be empty";
            request.setAttribute("errorMessageee", er);
            processRequest(request, response);
            return;
        }

        MenuRepository menuRepo = new MenuRepository();
        try {
            menuRepo.addMenu(itemName,code_dish, description,price,categoryId,status,created_by, img_url);
            request.setAttribute("idlevel", categoryId);
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
