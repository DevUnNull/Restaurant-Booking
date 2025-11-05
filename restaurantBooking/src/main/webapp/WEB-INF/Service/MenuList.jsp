<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>



<div class="menu-grid">
    <c:forEach var="m" items="${listmenuItem}">
        <label>
            <input type="checkbox" name="menuItems" value="${m.itemId}">
                ${m.itemName}
        </label>
    </c:forEach>
</div>
