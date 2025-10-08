<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quản lý dịch vụ</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
        <link href="css/ServiceList.css" rel="stylesheet" type="text/css" />
    </head>
    <body>

        <!-- Header -->
        <div class="header">
            <div class="logo">Tica's Tacos</div>
            <nav>
                <ul>
                    <li><a href="#">Trang chủ</a></li>
                    <li><a href="#">Đặt bàn</a></li>
                    <li><a href="#">Menu</a></li>
                    <li><a href="#">Liên hệ</a></li>
                    <li><a href="#">Giỏ hàng (0)</a></li>
                </ul>
            </nav>
        </div>

        <!-- Layout -->
        <div class="main-wrapper">
            <!-- Sidebar -->
            <div class="sidebar">
                <h2>Admin Panel</h2>
                <ul>
                    <li><a href="#">Dashboard</a></li>
                    <li><a href="ServiceList">Dịch vụ</a></li>
                    <!-- nếu quyền là admin Restaurant thì hiện  --> 
                    <li><a href="ServiceManage">Quản lý dịch vụ</a></li>
                    <li><a href="CommentList">Quản lý đánh giá bình luận</a></li>

                    <li><a href="#">Quản lý Menu</a></li>
                    <li><a href="VoucherController">Quản lý Voucher khuyến mãi </a></li>
                    <li><a href="#">Quản lý khách hàng thân thiết </a></li>
                    <li><a href="BlogController">BlogList</a></li>
                </ul>
            </div>

            <!-- Content -->
            <div class="content">
                <h2>Danh sách dịch vụ</h2>
                <div class="services">
                    <!-- Card 1 -->
                    <c:forEach var="o" items="${kakao}">
                        <div class="card">
                            <div class="card-icon"><i class="fa-solid fa-burger"></i></div>
                            <h3>${o.serviceName}</h3>
                            <p>${o.serviceCode}</p>
                            <p>${o.description}</p>
                            <p class="price">${o.price} VNĐ</p>
                            <p class="status-active">${o.status}</p>
                            <a href="service-detail.jsp?id=DV001" class="btn">Chọn dịch vụ</a>
                        </div>
                    </c:forEach >


                </div>
            </div>

        </div>
        <div class="pagination">
            <!-- Pagination -->
            <div style="text-align:center; margin-top: 20px;">
                <c:if test="${totalPages > 1}">
                    <c:forEach var="i" begin="1" end="${totalPages}">
                        <c:choose>
                            <c:when test="${i == currentPage}">
                                <span style="margin: 0 5px; font-weight: bold; color: #b23627;">${i}</span>
                            </c:when>
                            <c:otherwise>
                                <a href="ServiceList?page=${i}" 
                                   style="margin: 0 5px; text-decoration:none; color: black;">
                                    ${i}
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                </c:if>
            </div>
        </div>
        <script>
            window.onload = function () {
                // Nếu không có dữ liệu "kakao" (list) thì tự redirect sang servlet
            <%-- Chỉ chạy khi list chưa được set --%>
            <% if (request.getAttribute("kakao") == null) { %>
                window.location.href = "ServiceList";
            <% } %>
            };
        </script>
    </body>

</html>
