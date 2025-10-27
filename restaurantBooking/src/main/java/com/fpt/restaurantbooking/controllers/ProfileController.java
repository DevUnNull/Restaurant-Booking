package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.models.User;
import com.fpt.restaurantbooking.repositories.UserRepository;
import com.fpt.restaurantbooking.repositories.impl.UserRepositoryImpl;
import com.fpt.restaurantbooking.services.UserService;
import com.fpt.restaurantbooking.services.impl.UserServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "ProfileController", urlPatterns = {"/profile"})
public class ProfileController extends BaseController {

    private final UserService userService;

    public ProfileController() {
        UserRepository userRepository = new UserRepositoryImpl();
        this.userService = new UserServiceImpl(userRepository);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        User currentUser = (User) session.getAttribute("currentUser");
        request.setAttribute("user", currentUser);
        forwardToPage(request, response, "/WEB-INF/views/customer/profile.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User currentUser = (User) session.getAttribute("currentUser");
        String action = request.getParameter("action");
        String message = "";
        boolean success = false;

        try {
            switch (action) {
                case "updateInfo":
                    currentUser.setFullName(request.getParameter("fullName"));
                    currentUser.setPhoneNumber(request.getParameter("phone"));
                    currentUser.setEmail(request.getParameter("email"));
                    String dateOfBirthStr = request.getParameter("dateOfBirth");
                    if (dateOfBirthStr != null && !dateOfBirthStr.isEmpty()) {
                        currentUser.setDateOfBirth(java.time.LocalDate.parse(dateOfBirthStr));
                    }
                    currentUser.setGender(request.getParameter("gender"));

                    if (userService.updateUser(currentUser)) {


                        message = "Cập nhật thông tin thành công!";
                        success = true;
                    } else {
                        throw new Exception("Cập nhật thông tin thất bại.");
                    }
                    break;

                case "updateAvatar":
                    String avatarBase64 = request.getParameter("avatarBase64");
                    if (avatarBase64 != null && !avatarBase64.isEmpty()) {
                        if (userService.updateAvatar(currentUser.getUserId(), avatarBase64)) {
                            currentUser.setAvatar(avatarBase64); // Cập nhật avatar trong session
                            message = "Cập nhật ảnh đại diện thành công!";
                            success = true;
                        } else {
                            throw new Exception("Cập nhật ảnh đại diện thất bại.");
                        }
                    } else {
                        throw new Exception("Không có ảnh nào được chọn!");
                    }
                    break;

            }

            session.setAttribute("currentUser", currentUser);

        } catch (Exception e) {
            message = "Lỗi: " + e.getMessage();
            success = false;
        }

        request.setAttribute("message", message);
        request.setAttribute("success", success);
        doGet(request, response);
    }
}