package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.models.GalleryImage;
import com.fpt.restaurantbooking.models.MenuItem;
import com.fpt.restaurantbooking.models.RestaurantInfo;
import com.fpt.restaurantbooking.models.Review;
import com.fpt.restaurantbooking.repositories.GalleryImageRepository;
import com.fpt.restaurantbooking.repositories.MenuItemRepository;
import com.fpt.restaurantbooking.repositories.RestaurantInfoRepository;
import com.fpt.restaurantbooking.repositories.ReviewRepository;
import com.fpt.restaurantbooking.repositories.impl.GalleryImageRepositoryImpl;
import com.fpt.restaurantbooking.repositories.impl.MenuItemRepositoryImpl;
import com.fpt.restaurantbooking.repositories.impl.RestaurantInfoRepositoryImpl;
import com.fpt.restaurantbooking.repositories.impl.ReviewRepositoryImpl;
import com.fpt.restaurantbooking.services.GalleryImageService;
import com.fpt.restaurantbooking.services.MenuItemService;
import com.fpt.restaurantbooking.services.RestaurantInfoService;
import com.fpt.restaurantbooking.services.ReviewService;
import com.fpt.restaurantbooking.services.impl.GalleryImageServiceImpl;
import com.fpt.restaurantbooking.services.impl.MenuItemServiceImpl;
import com.fpt.restaurantbooking.services.impl.RestaurantInfoServiceImpl;
import com.fpt.restaurantbooking.services.impl.ReviewServiceImpl;
import com.fpt.restaurantbooking.utils.DatabaseUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;

/**
 * Controller for handling restaurant detail page requests
 */
@WebServlet(name = "RestaurantDetailController", urlPatterns = {"/restaurant-detail"})
public class RestaurantDetailController extends BaseController {

    private final RestaurantInfoService restaurantInfoService;
    private final MenuItemService menuItemService;
    private final GalleryImageService galleryImageService;
    private final ReviewService reviewService;
    
    public RestaurantDetailController() {
        try {
            Connection connection = DatabaseUtil.getConnection();
            
            // Initialize repositories
            RestaurantInfoRepository restaurantInfoRepository = new RestaurantInfoRepositoryImpl(connection);
            MenuItemRepository menuItemRepository = new MenuItemRepositoryImpl(connection);
            GalleryImageRepository galleryImageRepository = new GalleryImageRepositoryImpl(connection);
            ReviewRepository reviewRepository = new ReviewRepositoryImpl(connection);
            
            // Initialize services with dependency injection
            this.restaurantInfoService = new RestaurantInfoServiceImpl(restaurantInfoRepository);
            this.menuItemService = new MenuItemServiceImpl(menuItemRepository);
            this.galleryImageService = new GalleryImageServiceImpl(galleryImageRepository);
            this.reviewService = new ReviewServiceImpl(reviewRepository);
        } catch (Exception e) {
            throw new RuntimeException("Failed to initialize RestaurantDetailController", e);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // Get restaurant info
            RestaurantInfo restaurantInfo = restaurantInfoService.getMainRestaurantInfo().orElse(null);
            request.setAttribute("restaurantInfo", restaurantInfo);
            
            // Get all menu items grouped by category
            List<MenuItem> menuItems = menuItemService.findActiveItems();
            request.setAttribute("menuItems", menuItems);
            
            // Get approved reviews for display
            List<Review> reviews = reviewService.findAllApproved();
            request.setAttribute("reviews", reviews);
            
            // Get approved gallery images for display
            List<GalleryImage> galleryImages = galleryImageService.findAllApproved();
            request.setAttribute("galleryImages", galleryImages);
            
            // Forward to restaurant detail page
            forwardToPage(request, response, "/WEB-INF/views/customer/restaurant-detail.jsp");
            
        } catch (Exception e) {
            // Log error and forward to error page
            System.err.println("Error loading restaurant detail page: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi tải trang chi tiết nhà hàng");
        }
    }
    
    // These methods are no longer needed since we're using real data from services
    // They can be removed in a future cleanup
}