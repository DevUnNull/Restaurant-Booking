<%--
  Created by IntelliJ IDEA.
  User: Duong Quy Nhan
  Date: 10/11/2025
  Time: 4:19 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Danh sách nhân viên</title>
    <link href="css/ServiceManage.css" rel="stylesheet" type="text/css" />
</head>

<style>
    /* Container chứa thanh tìm kiếm */
    .search-container {
        display: flex;
        justify-content: center;  /* căn giữa theo chiều ngang */
        align-items: center;
        margin: 20px 0;           /* tạo khoảng cách trên dưới */
        gap: 10px;                /* cách đều input và nút */
    }

    /* Ô nhập từ khóa */
    .search-input {
        padding: 10px 14px;
        width: 250px;
        border: 1px solid #ccc;
        border-radius: 25px;      /* bo tròn đẹp */
        font-size: 15px;
        outline: none;
        transition: all 0.3s ease;
    }

    .search-input:focus {
        border-color: #b23627;
        box-shadow: 0 0 5px #b23627;
    }

    /* Nút Search */
    .search-button {
        background-color: #b23627;
        color: white;
        border: none;
        padding: 10px 20px;
        border-radius: 25px;
        font-size: 15px;
        cursor: pointer;
        transition: all 0.3s ease;
    }

    .search-button:hover {
        background-color: #922c1f;
        transform: translateY(-2px);
    }

    .action-btn {
        margin-right: 6px; /* tạo khoảng cách giữa 2 nút */
    }
    /* Nút thêm dịch vụ */
    .add-btn {
        background-color: #c0392b; /* Đỏ đậm sang trọng */
        color: #fff; /* Chữ trắng */
        border: none;
        padding: 10px 22px;
        font-size: 16px;
        font-weight: bold;
        border-radius: 8px;
        cursor: pointer;
        float: right; /* Đưa sang phải */
        margin-bottom: 15px;
        box-shadow: 0 4px 10px rgba(192, 57, 43, 0.3);
        transition: all 0.3s ease;
        text-decoration: none;
    }

    /* Hiệu ứng hover */
    .add-btn:hover {
        background-color: #e74c3c;
        box-shadow: 0 6px 12px rgba(231, 76, 60, 0.4);
        transform: translateY(-2px);
        text-decoration: none;
    }

    /* Khi bấm giữ */
    .add-btn:active {
        background-color: #a93226;
        transform: translateY(0);
        text-decoration: none;
    }
    a {
        text-decoration: none;
        font-weight: bold;
        padding: 8px 16px;
        border-radius: 20px;
        margin-right: 10px;
        display: inline-block;
        transition: all 0.3s ease;
    }

    .link1 {
        background-color: #b23627; /* đỏ nâu */
        color: white;
    }
    .link2 {
        background-color: #1e90ff; /* xanh dương */
        color: white;
    }
    .link3 {
        background-color: #28a745; /* xanh lá */
        color: white;
    }

    a:hover {
        opacity: 0.8;
    }
</style>

<body>

<div class="main">
    <div class="header">
        <div class="logo">Quản Lý Nhân Sự</div>
    </div>
    <div class="main-wrapper">
        <!-- Sidebar -->
        <div class="sidebar">
            <ul>
                <li><a href="EmployeeList">Danh sách nhân viên</a></li>
                <li><a href="#">Phân lịch làm việc</a></li>
                <li><a href="#">Lịch làm việc</a></li>
                <li><a href="#">Trạng thái nhân sự</a></li>
                <li><a href="apply-job-list">Đơn xin việc</a></li>
            </ul>
        </div>

        <div class="content">
            <h2>Đơn xin việc</h2>
            <table border="1" style="width:90%;margin:auto;">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>User ID</th>
                    <th>Nội dung mô tả</th>
                    <th>Ngày tạo</th>
                    <th>Trạng thái</th>
                    <th>Hành động</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="r" items="${applications}">
                    <tr>
                        <td>${r.reviewId}</td>
                        <td>${r.userId}</td>
                        <td>${r.comment}</td>
                        <td>${r.createdAt}</td>
                        <td>${r.status}</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/admin/approve-application?id=${r.reviewId}&userId=${r.userId}&action=approve">Duyệt</a> |
                            <a href="${pageContext.request.contextPath}/admin/approve-application?id=${r.reviewId}&action=reject">Từ chối</a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>
