package com.fpt.restaurantbooking.controllers;

import com.fpt.restaurantbooking.repositories.impl.JobRequestDAO;
import com.fpt.restaurantbooking.repositories.impl.UserDao;
import com.fpt.restaurantbooking.models.JobRequest;
import com.fpt.restaurantbooking.models.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/JobRequest")
public class JobRequestController extends HttpServlet {
    private JobRequestDAO jobRequestDAO = new JobRequestDAO();
    private UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if (action == null) {
                showRequestForm(request, response);
            } else if (action.equals("list")) {
                listRequests(request, response);
            } else if (action.equals("approve")) {
                approveRequest(request, response);
            } else if (action.equals("reject")) {
                rejectRequest(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    // Khách hàng bấm "Xin việc"
    private void showRequestForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("currentUser");

        jobRequestDAO.insertJobRequest(user.getUserId());
        request.setAttribute("message", "Đơn xin việc của bạn đã được gửi!");
        request.getRequestDispatcher("/WEB-INF/StaffManage/Jobrequest.jsp").forward(request, response);
    }

    // Manager xem danh sách
    private void listRequests(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        List<JobRequest> list = jobRequestDAO.getAllRequests();
        request.setAttribute("requests", list);
        request.getRequestDispatcher("/WEB-INF/StaffManage/ManageJobrequest.jsp").forward(request, response);
    }

    // Manager chấp nhận
    private void approveRequest(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int requestId = Integer.parseInt(request.getParameter("id"));
        HttpSession session = request.getSession();
        User manager = (User) session.getAttribute("currentUser");

        jobRequestDAO.updateStatus(requestId, "APPROVED", manager.getUserId(), "Đã duyệt");

        // Cập nhật role_id = 2 (STAFF)
        int userId = Integer.parseInt(request.getParameter("userId"));
        userDao.updateRole(userId, 2);

        response.sendRedirect("JobRequest?action=list");
    }

    // Manager từ chối
    private void rejectRequest(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int requestId = Integer.parseInt(request.getParameter("id"));
        HttpSession session = request.getSession();
        User manager = (User) session.getAttribute("currentUser");

        jobRequestDAO.updateStatus(requestId, "REJECTED", manager.getUserId(), "Từ chối đơn");
        response.sendRedirect("JobRequest?action=list");
    }
}
