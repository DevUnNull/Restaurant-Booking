package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.models.MenuCategory;
import com.fpt.restaurantbooking.models.MenuItem;
import com.fpt.restaurantbooking.models.Promotions;
import com.fpt.restaurantbooking.repositories.impl.MenuRepository;
import com.fpt.restaurantbooking.repositories.impl.VoucherRepository;
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
@WebServlet(name="Menu", urlPatterns={"/Menu_manage"})
@MultipartConfig
public class MenuController extends HttpServlet {

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
        MenuItem promo= (MenuItem) request.getAttribute("pro");
        int offset = (page - 1) * recordsPerPage;
        try {
            MenuRepository menuRepo = new MenuRepository();
            List<MenuCategory> listMenuCategory = new ArrayList<>();
            listMenuCategory = menuRepo.getCateGory();
            List<MenuItem> menuItelList = menuRepo.getMenuItems(promo.getCategory_id(), offset, recordsPerPage);
            int totalRecords = menuRepo.getAllMenuItems(promo.getCategory_id()).size();
            int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
            request.setAttribute("listMenuCategory", listMenuCategory);
            request.setAttribute("kaku", promo.getCategory_id());
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("menuList", menuItelList);
            request.getRequestDispatcher("/WEB-INF/Menu/Menu.jsp").forward(request, response);
        }catch (Exception ex){
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        int page = 1;
        int recordsPerPage = 6;

        // 🧭 Xử lý tham số "page" an toàn
        String pageRaw = request.getParameter("page");
        if (pageRaw != null && !pageRaw.trim().isEmpty()) {
            try {
                page = Integer.parseInt(pageRaw);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        int offset = (page - 1) * recordsPerPage;
        MenuRepository menurepo = new MenuRepository();

        // 🧩 Xử lý tham số "categoryId" an toàn
        String categoryIdRaw = request.getParameter("categoryId");
        int categoryId = 1; // giá trị mặc định

        if (categoryIdRaw != null && !categoryIdRaw.trim().isEmpty()) {
            try {
                categoryId = Integer.parseInt(categoryIdRaw);
            } catch (NumberFormatException e) {
                // Nếu parse lỗi, giữ mặc định
                categoryId = 1;
            }
        }

        try {
            // 🔹 Lấy danh sách category & menu
            List<MenuCategory> listMenuCategory = menurepo.getCateGory();
            List<MenuItem> menuItemList = menurepo.getMenuItems(categoryId, offset, recordsPerPage);
            int totalRecords = menurepo.getAllMenuItems(categoryId).size();
            int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

            // 🔹 Set dữ liệu lên request
            request.setAttribute("listMenuCategory", listMenuCategory);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("menuList", menuItemList);
            request.setAttribute("kaku", categoryId);

            // 🔹 Forward tới JSP
            request.getRequestDispatcher("/WEB-INF/Menu/Menu.jsp").forward(request, response);

        } catch (Exception ex) {
            // ⚠️ Log lỗi để dễ debug
            ex.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi tải dữ liệu menu: " + ex.getMessage());
            request.getRequestDispatcher("/WEB-INF/Error.jsp").forward(request, response);
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
        String menuName = request.getParameter("menuName");
        String description = request.getParameter("description");
        String price= request.getParameter("price");
        Part filePart = request.getPart("imageFile");
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

        String uploadPath = getServletContext().getRealPath("/images/appetizers/");
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        String imageFile;
        if (fileName != null && !fileName.isEmpty()) {
            filePart.write(uploadPath + File.separator + fileName);
            imageFile = "images/appetizers/" + fileName;
        } else {
            // Nếu không chọn ảnh mới, dùng lại ảnh cũ
            imageFile = request.getParameter("oldImageUrl");
        }
        String updated_by= request.getParameter("updated_by");
        String status= request.getParameter("status");
        String categoryId = request.getParameter("categoryId");
        MenuRepository menuRepo = new MenuRepository();
        MenuItem pro = null;
        try {
            pro = (MenuItem) menuRepo.getIdWithUpdate(Integer.parseInt(id));
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        String er;


        if(menuName.isEmpty()){
            er = "Name must not be empty";
            request.setAttribute("errorMessage", er);
            request.setAttribute("pro", pro);
            processRequest(request, response);
            return;
        }if(menuName.trim().length() > 40) {
            er="name must not greater than 40 characters";
            request.setAttribute("errorMessageee", er);
            processRequest(request, response);
            return;
        }else if(description.isEmpty()){
            er = "Description must not be empty";
            request.setAttribute("errorMessage", er);
            request.setAttribute("pro", pro);
            processRequest(request, response);
            return;
        }else if(price.isEmpty()){
            er = "price percentage must not be empty";
            request.setAttribute("errorMessage", er);
            request.setAttribute("pro", pro);
            processRequest(request, response);
            return;
        }else if(status.isEmpty()){
            er = "status date must not be empty";
            request.setAttribute("errorMessage", er);
            request.setAttribute("pro", pro);
            processRequest(request, response);
            return;
        }else if(categoryId.isEmpty()){
            er = "categoryId date must not be empty";
            request.setAttribute("errorMessage", er);
            request.setAttribute("pro", pro);
            processRequest(request, response);
            return;
        }

        try {


                menuRepo.UpdateMenu(id,menuName,description,price,imageFile,updated_by,status, categoryId);
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

