<%--
  Created by IntelliJ IDEA.
  User: Duong Quy Nhan
  Date: 10/11/2025
  Time: 9:39 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Đơn xin việc</title>
    <link rel="stylesheet" href="css/ServiceManage.css">
</head>
<body>
    <h2 style="text-align:center;">Đơn Xin Việc</h2>
    <form action="apply-job" method="post" style="width: 60%; margin: 0 auto;">
        <textarea name="content" rows="6" style="width:100%; padding:10px; border-radius:10px;"
                  placeholder="Hãy viết mô tả, kỹ năng hoặc lý do bạn muốn ứng tuyển..."></textarea>
        <br><br>
        <div style="text-align:center;">
            <button type="submit" class="search-button">Gửi Đơn</button>
        </div>
    </form>
    <c:if test="${not empty message}">
        <p style="text-align:center; color: green;">${message}</p>
    </c:if>
</body>
</html>
