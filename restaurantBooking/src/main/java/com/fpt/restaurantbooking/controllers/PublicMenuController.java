package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.models.MenuCategory;
import com.fpt.restaurantbooking.models.MenuItem;
import com.fpt.restaurantbooking.repositories.impl.MenuRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "PublicMenuController", urlPatterns = {"/menu"})
public class PublicMenuController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        int page = 1;
        int recordsPerPage = 9;

        String pageRaw = request.getParameter("page");
        if (pageRaw != null && !pageRaw.trim().isEmpty()) {
            try {
                page = Integer.parseInt(pageRaw);
            } catch (NumberFormatException ignored) {
                page = 1;
            }
        }

        String categoryIdRaw = request.getParameter("categoryId");
        int categoryId = 0; // 0 = Tất cả
        if (categoryIdRaw != null && !categoryIdRaw.trim().isEmpty()) {
            try {
                categoryId = Integer.parseInt(categoryIdRaw);
            } catch (NumberFormatException ignored) {
                categoryId = 0;
            }
        }

        int offset = (page - 1) * recordsPerPage;
        String sort = request.getParameter("sort"); // ASC | DESC
        if (sort == null || !(sort.equalsIgnoreCase("ASC") || sort.equalsIgnoreCase("DESC"))) {
            sort = "ASC";
        }

        try {
            MenuRepository menuRepository = new MenuRepository();
            List<MenuCategory> categories = menuRepository.getCateGory();
            List<MenuItem> items = (categoryId == 0)
                    ? menuRepository.getMenuItemsAllSorted(offset, recordsPerPage, sort)
                    : menuRepository.getMenuItemsSorted(categoryId, offset, recordsPerPage, sort);
            int totalRecords = (categoryId == 0)
                    ? menuRepository.getAllMenuItemsAll().size()
                    : menuRepository.getAllMenuItems(categoryId).size();
            int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

            request.setAttribute("listMenuCategory", categories);
            request.setAttribute("menuList", items);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("selectedCategoryId", categoryId);
            request.setAttribute("sort", sort);

            request.getRequestDispatcher("/WEB-INF/views/customer/menu-view.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Không thể tải thực đơn: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
}


