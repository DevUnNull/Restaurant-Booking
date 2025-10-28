package com.fpt.restaurantbooking.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "AboutController", urlPatterns = {"/about"})
public class AboutController extends BaseController {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        forwardToPage(request, response, "/WEB-INF/views/about.jsp");
    }
}