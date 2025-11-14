<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<table border="1" width="100%" style="border-collapse:collapse; text-align:center;">
    <tr style="background-color:#f5f5f5;">
        <th>Chọn</th>
        <th>Tên món</th>
    </tr>

    <c:forEach var="item" items="${availableItems}">
        <tr>
            <td><input type="checkbox" name="selectedItems" value="${item.itemId}"></td>
            <td>${item.itemName}</td>
        </tr>
    </c:forEach>
</table>
