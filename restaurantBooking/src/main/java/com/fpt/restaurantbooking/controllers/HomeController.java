package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.models.MenuItem;
import com.fpt.restaurantbooking.models.RestaurantInfo;
import com.fpt.restaurantbooking.repositories.MenuItemRepository;
import com.fpt.restaurantbooking.repositories.RestaurantInfoRepository;
import com.fpt.restaurantbooking.repositories.impl.MenuItemDAO;
import com.fpt.restaurantbooking.repositories.impl.RestaurantInfoRepositoryImpl;
import com.fpt.restaurantbooking.services.MenuItemService;
import com.fpt.restaurantbooking.services.RestaurantInfoService;
import com.fpt.restaurantbooking.services.impl.MenuItemServiceImpl;
import com.fpt.restaurantbooking.services.impl.RestaurantInfoServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet(name = "HomeController", urlPatterns = {"/", "/home"})
public class HomeController extends BaseController {

    private final RestaurantInfoService restaurantInfoService;
    //private final MenuItemService menuItemService;

    public HomeController() {
        RestaurantInfoRepository restaurantInfoRepository = new RestaurantInfoRepositoryImpl();
        //MenuItemRepository menuItemRepository = new MenuItemDAO();

        this.restaurantInfoService = new RestaurantInfoServiceImpl(restaurantInfoRepository);
        //this.menuItemService = new MenuItemServiceImpl(menuItemRepository);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Đặt khối try-catch ra ngoài để bao trọn cả forward
        try {
            // Lấy tất cả dữ liệu
            Optional<RestaurantInfo> restaurantInfoOpt = restaurantInfoService.getMainRestaurantInfo();
            //List<MenuItem> featuredDishes = menuItemService.findFeaturedItems();

            // Đặt các attribute vào request
//            request.setAttribute("restaurantInfo", restaurantInfoOpt.orElse(null));
//            request.setAttribute("featuredDishes", featuredDishes);

            // Chỉ forward khi tất cả đã xong
            forwardToPage(request, response, "/WEB-INF/views/home.jsp");

        } catch (Exception e) {
            // Nếu có lỗi, in ra và báo lỗi 500.
            // KHÔNG forward nữa để tránh lỗi IllegalStateException
            System.err.println("!!! LỖI NGHIÊM TRỌNG KHI TẢI TRANG CHỦ !!!");
            e.printStackTrace();
            if (!response.isCommitted()) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Không thể tải dữ liệu trang chủ.");
            }
        }
    }
}