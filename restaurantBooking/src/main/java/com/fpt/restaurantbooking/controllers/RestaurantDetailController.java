package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.models.GalleryImage;
import com.fpt.restaurantbooking.models.MenuItem;
import com.fpt.restaurantbooking.models.RestaurantInfo;
import com.fpt.restaurantbooking.models.Review;
import com.fpt.restaurantbooking.repositories.GalleryImageRepository;
import com.fpt.restaurantbooking.repositories.MenuItemRepository;
import com.fpt.restaurantbooking.repositories.RestaurantInfoRepository;
import com.fpt.restaurantbooking.repositories.ReviewRepository;
import com.fpt.restaurantbooking.repositories.impl.*; // Import gọn hơn
import com.fpt.restaurantbooking.services.GalleryImageService;
import com.fpt.restaurantbooking.services.MenuItemService;
import com.fpt.restaurantbooking.services.RestaurantInfoService;
import com.fpt.restaurantbooking.services.ReviewService;
import com.fpt.restaurantbooking.services.impl.*; // Import gọn hơn
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "RestaurantDetailController", urlPatterns = {"/restaurant-detail"})
public class RestaurantDetailController extends BaseController {

    private final RestaurantInfoService restaurantInfoService;
    //private final MenuItemService menuItemService;
    private final GalleryImageService galleryImageService;
    private final ReviewService reviewService;

    public RestaurantDetailController() {
        // KHỞI TẠO TẤT CẢ REPOSITORY THEO CHUẨN MỚI
        RestaurantInfoRepository restaurantInfoRepository = new RestaurantInfoRepositoryImpl();
        //MenuItemRepository menuItemRepository = new MenuItemDAO();
        GalleryImageRepository galleryImageRepository = new GalleryImageRepositoryImpl();
        ReviewRepository reviewRepository = new ReviewRepositoryImpl();

        this.restaurantInfoService = new RestaurantInfoServiceImpl(restaurantInfoRepository);
        //this.menuItemService = new MenuItemServiceImpl(menuItemRepository);
        this.galleryImageService = new GalleryImageServiceImpl(galleryImageRepository);
        this.reviewService = new ReviewServiceImpl(reviewRepository);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            RestaurantInfo restaurantInfo = restaurantInfoService.getMainRestaurantInfo().orElse(null);
            request.setAttribute("restaurantInfo", restaurantInfo);

//            List<MenuItem> menuItems = menuItemService.findAllAvailable(); // Sửa lại tên phương thức
//            request.setAttribute("menuItems", menuItems);

            List<Review> reviews = reviewService.findAllApproved();
            request.setAttribute("reviews", reviews);

            List<GalleryImage> galleryImages = galleryImageService.findAllApproved();
            request.setAttribute("galleryImages", galleryImages);

            forwardToPage(request, response, "/WEB-INF/views/customer/restaurant-detail.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi tải trang");
        }
    }
}