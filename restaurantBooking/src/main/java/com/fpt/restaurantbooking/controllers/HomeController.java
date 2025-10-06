package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.models.MenuItem;
import com.fpt.restaurantbooking.models.Promotion;
import com.fpt.restaurantbooking.models.RestaurantInfo;
import com.fpt.restaurantbooking.repositories.MenuItemRepository;
import com.fpt.restaurantbooking.repositories.PromotionRepository;
import com.fpt.restaurantbooking.repositories.RestaurantInfoRepository;
import com.fpt.restaurantbooking.repositories.impl.MenuItemRepositoryImpl;
import com.fpt.restaurantbooking.repositories.impl.PromotionRepositoryImpl;
import com.fpt.restaurantbooking.repositories.impl.RestaurantInfoRepositoryImpl;
import com.fpt.restaurantbooking.services.MenuItemService;
import com.fpt.restaurantbooking.services.PromotionService;
import com.fpt.restaurantbooking.services.RestaurantInfoService;
import com.fpt.restaurantbooking.services.impl.MenuItemServiceImpl;
import com.fpt.restaurantbooking.services.impl.PromotionServiceImpl;
import com.fpt.restaurantbooking.services.impl.RestaurantInfoServiceImpl;
import com.fpt.restaurantbooking.utils.DatabaseUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;

/**
 * Controller for handling home page requests
 */
@WebServlet(name = "HomeController", urlPatterns = {"/", "/home"})
public class HomeController extends BaseController {

    private final PromotionService promotionService;
    private final RestaurantInfoService restaurantInfoService;
    private final MenuItemService menuItemService;
    
    public HomeController() {
        try {
            Connection connection = DatabaseUtil.getConnection();
            
            // Initialize repositories
            PromotionRepository promotionRepository = new PromotionRepositoryImpl(connection);
            RestaurantInfoRepository restaurantInfoRepository = new RestaurantInfoRepositoryImpl(connection);
            MenuItemRepository menuItemRepository = new MenuItemRepositoryImpl(connection);
            
            // Initialize services with dependency injection
            this.promotionService = new PromotionServiceImpl(promotionRepository);
            this.restaurantInfoService = new RestaurantInfoServiceImpl(restaurantInfoRepository);
            this.menuItemService = new MenuItemServiceImpl(menuItemRepository);
        } catch (Exception e) {
            throw new RuntimeException("Failed to initialize HomeController", e);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // Get active promotions for banners
            List<Promotion> activePromotions = promotionService.findActivePromotionsForHomePage();
            request.setAttribute("promotions", activePromotions);
            
            // Get restaurant info for opening hours and address
            RestaurantInfo restaurantInfo = restaurantInfoService.getMainRestaurantInfo().orElse(null);
            request.setAttribute("restaurantInfo", restaurantInfo);
            
            // Get featured dishes
            List<MenuItem> featuredDishes = menuItemService.findFeaturedItems();
            request.setAttribute("featuredDishes", featuredDishes);
            
            // Forward to home page
            forwardToPage(request, response, "/WEB-INF/views/home.jsp");
            
        } catch (Exception e) {
            // Log error and forward to home page anyway
            System.err.println("Error loading home page data: " + e.getMessage());
            e.printStackTrace();
            forwardToPage(request, response, "/WEB-INF/views/home.jsp");
        }
    }
}