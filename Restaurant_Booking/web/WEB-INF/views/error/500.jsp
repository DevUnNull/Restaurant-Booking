<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<%
    request.setAttribute("pageTitle", "Internal Server Error - 500");
    request.setAttribute("pageDescription", "An internal server error occurred");
    request.setAttribute("pageCss", "auth.css");
%>

<jsp:include page="500-content.jsp">
</jsp:include>