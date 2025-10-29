<%--
  Created by IntelliJ IDEA.
  User: Duong Quy Nhan
  Date: 10/28/2025
  Time: 11:38 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<h2>Gửi đơn xin việc</h2>
<form action="JobRequest" method="get">
    <input type="hidden" name="action" value="send">
    <button type="submit">Gửi đơn xin việc</button>
</form>
<p style="color:green">${message}</p>
</body>
</html>
