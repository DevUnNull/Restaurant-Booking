/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.models.Blog;
import com.fpt.restaurantbooking.repositories.impl.BlogRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;


@WebServlet(name="BlogSingleListController", urlPatterns={"/BlogSingleList"})
public class BlogSingleListController extends HttpServlet {
   

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String id = request.getParameter("id");
        List<Blog> BlogCate = new ArrayList<>();
        List<Blog> postList = new ArrayList<>();

         BlogRepository blogRepository = new BlogRepository();
BlogCate= blogRepository.getAllBlog();
        postList=  blogRepository.getBlog_byCategory(Integer.parseInt(id));
        request.setAttribute("postList", postList);
        request.setAttribute("blogCate", BlogCate);
        request.getRequestDispatcher("/WEB-INF/Blog/BlogSingleList.jsp")
                .forward(request, response);
    }


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String id = request.getParameter("id");
        List<Blog> BlogCate = new ArrayList<>();
        List<Blog> postList = new ArrayList<>();

        BlogRepository blogRepository = new BlogRepository();
        BlogCate= blogRepository.getAllBlog();
        postList=  blogRepository.getBlog_byCategory(Integer.parseInt(id));
        request.setAttribute("postList", postList);
        request.setAttribute("blogCate", BlogCate);
        request.getRequestDispatcher("/WEB-INF/Blog/BlogSingleList.jsp")
                .forward(request, response);
    } 


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }


    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
