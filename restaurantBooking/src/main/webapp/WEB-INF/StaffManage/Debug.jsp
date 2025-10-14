<%@ page import="com.fpt.restaurantbooking.models.User" %>
<%--
  Created by IntelliJ IDEA.
  User: Duong Quy Nhan
  Date: 10/11/2025
  Time: 11:22 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<html>
<head>
    <title>Title</title>
</head>
<body>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser != null) {
        out.println("<p style='color:blue;'>User Role: " + currentUser.getRole() + "</p>");
    } else {
        out.println("<p style='color:red;'>No current user in session</p>");
    }
%>
</body>
</html>
