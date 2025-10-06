<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<%
    request.setAttribute("pageTitle", "Page Not Found - 404");
    request.setAttribute("pageDescription", "The requested page could not be found");
    request.setAttribute("pageCss", "auth.css");
%>

<jsp:include page="404-content.jsp"/>