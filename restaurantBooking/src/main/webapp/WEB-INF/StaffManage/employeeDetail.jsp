<%--
  Created by IntelliJ IDEA.
  User: Duong Quy Nhan
  Date: 11/4/2025
  Time: 5:52 PM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:if test="${not empty userDetail}">
    <img src="${userDetail.avatar != null ? userDetail.avatar : '/default-avaimagestar.png'}" alt="Avatar" />
    <p><strong>ID:</strong> ${userDetail.userId}</p>
    <p><strong>Họ và tên:</strong> ${userDetail.fullName}</p>
    <p><strong>Giới tính:</strong> ${userDetail.gender}</p>
    <p><strong>Ngày sinh:</strong> ${userDetail.dateOfBirth}</p>
    <p><strong>Email:</strong> ${userDetail.email}</p>
    <p><strong>Số điện thoại:</strong> ${userDetail.phoneNumber}</p>
    <p><strong>Trạng thái:</strong> ${userDetail.status}</p>
    <p><strong>Ngày tạo:</strong> ${userDetail.createdAt}</p>
    <p><strong>Ngày cập nhật:</strong> ${userDetail.updatedAt}</p>
</c:if>