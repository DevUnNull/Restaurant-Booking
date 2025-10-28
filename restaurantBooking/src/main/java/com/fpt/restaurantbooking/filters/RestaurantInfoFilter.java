package com.fpt.restaurantbooking.filters;

import com.fpt.restaurantbooking.models.RestaurantInfo;
import com.fpt.restaurantbooking.repositories.RestaurantInfoRepository;
import com.fpt.restaurantbooking.repositories.impl.RestaurantInfoRepositoryImpl;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;

import java.io.IOException;

@WebFilter("/*")
public class RestaurantInfoFilter implements Filter {

    private RestaurantInfoRepository restaurantInfoRepository;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        this.restaurantInfoRepository = new RestaurantInfoRepositoryImpl();
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;

        if (httpRequest.getAttribute("restaurantInfo") == null) {
            try {

                RestaurantInfo info = restaurantInfoRepository.findMainRestaurantInfo().orElse(null);

                httpRequest.setAttribute("restaurantInfo", info);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}