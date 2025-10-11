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
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f4f4; }
        .container { width: 90%; margin: 40px auto; background: #fff; padding: 20px; border-radius: 12px; }
        h2 { text-align: center; color: #333; margin-bottom: 20px; }
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: center; }
        th { background: #8b3a3a; color: #fff; }
        tr:nth-child(even) { background-color: #f9f9f9; }
        .btn-add { background: #35c24a; color: white; padding: 8px 16px; border-radius: 6px; text-decoration: none; }
        .top-bar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px; }
        .search-input { padding: 6px 10px; border: 1px solid #ccc; border-radius: 6px; }
    </style>
</head>
<body>
<div class="container">
    <div class="top-bar">
        <h2>Danh sách nhân viên</h2>
        <input class="search-input" type="text" placeholder="Tìm kiếm nhân viên...">
    </div>

    <table>
        <thead>
        <tr>
            <th>ID</th>
            <th>Họ và tên</th>
            <th>Email</th>
            <th>Số điện thoại</th>
            <th>Chức vụ</th>
            <th>Trạng thái</th>
            <th>Ngày tạo</th>
            <th>Ngày cập nhật</th>
            <th>Hành động</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="u" items="${employees}">
            <tr>
                <td>${u.userId}</td>
                <td>${u.fullName}</td>
                <td>${u.email}</td>
                <td>${u.phoneNumber}</td>
                <td>${u.role}</td>
                <td>${u.status}</td>
                <td>${u.createdAt}</td>
                <td>${u.updatedAt}</td>
                <td>
                    <a href="#">Sửa</a> |
                    <a href="#">Xóa</a> |
                    <a href="#">Chi tiết</a>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>

    <br/>
    <a href="#" class="btn-add">+ Thêm nhân viên mới</a>
</div>
</body>
</html>
