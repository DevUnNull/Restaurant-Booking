<%--
  Created by IntelliJ IDEA.
  User: Duong Quy Nhan
  Date: 10/11/2025
  Time: 10:10 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
  <head>
      <title>Đơn xin việc</title>
      <link href="css/ServiceManage.css" rel="stylesheet" type="text/css" />
      <link href="css/Employee.css" rel="stylesheet" type="text/css" />
      <link href="css/WorkShedule.css" rel="stylesheet" type="text/css" />
  </head>
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
                  <li><a href="WorkSchedule">Phân lịch làm việc</a></li>
                  <li><a href="#">Lịch làm việc</a></li>
                  <li><a href="#">Trạng thái nhân sự</a></li>
                  <li><a href="${pageContext.request.contextPath}/JobRequest?action=list">Đơn xin việc</a></li>
              </ul>
          </div>
          <div class="content">
              <h2>Danh sách đơn xin việc</h2>
              <table border="1" cellpadding="5">
                  <tr>
                      <th>ID</th>
                      <th>User ID</th>
                      <th>Ngày gửi</th>
                      <th>Trạng thái</th>
                      <th>Thao tác</th>
                  </tr>
                  <c:forEach var="req" items="${requests}">
                      <tr>
                          <td>${req.requestId}</td>
                          <td>${req.userId}</td>
                          <td>${req.requestDate}</td>
                          <td>${req.status}</td>
                          <td>
                              <a href="JobRequest?action=approve&id=${req.requestId}&userId=${req.userId}">Duyệt</a> |
                              <a href="JobRequest?action=reject&id=${req.requestId}">Từ chối</a>
                          </td>
                      </tr>
                  </c:forEach>
              </table>
          </div>

      </div>
  </div>
  </body>
</html>
