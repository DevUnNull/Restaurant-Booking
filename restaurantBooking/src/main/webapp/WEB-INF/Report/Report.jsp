<%--
  Created by IntelliJ IDEA.
  User: Huyen
  Date: 10/11/2025
  Time: 3:27 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- Import thư viện JSTL Core cho các vòng lặp và điều kiện --%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Report - Tổng quan</title>
    <%-- Nhúng thư viện Tailwind CSS. Trong môi trường production, bạn nên build CSS tối ưu --%>
    <script src="https://cdn.tailwindcss.com"></script>


    <style>
        /* Tùy chỉnh màu tím cho thương hiệu */
        .primary-purple {
            background-color: #5A32E3;
        }
        .text-primary-purple {
            color: #5A32E3;
        }
        /* Màu nhấn cho dữ liệu tích cực (Màu xanh ngọc) */
        .positive-green {
            background-color: #35C7A5;
        }
        .text-positive-green {
            color: #35C7A5;
        }
        /* Màu nhấn cho dữ liệu tiêu cực (Màu đỏ/hồng) */
        .negative-red {
            color: #F4586C;
        }
        /* Màu nhấn cho biểu đồ */
        .chart-purple { background-color: #8A52F7; }
        .chart-teal { background-color: #35C7A5; }
        .chart-orange { background-color: #F2A03D; }
        .chart-red { background-color: #F4586C; }
    </style>


</head>
<body class="bg-gray-100 font-sans antialiased">

<div class="flex min-h-screen">

    <%-- Sidebar (Menu điều hướng) --%>
    <aside class="w-64 bg-white p-6 shadow-xl sticky top-0 h-screen hidden lg:block">
        <div class="text-2xl font-extrabold text-primary-purple mb-10">
            Restaurant
        </div>

        <nav class="space-y-2">
            <%-- Dùng cú pháp JSP để kiểm tra trang hiện tại và áp dụng class active --%>
            <c:set var="currentPage" value="${param.pageName != null ? param.pageName : 'overview'}" />

            <a href="?pageName=overview" class="flex items-center space-x-3 p-3 rounded-xl <c:if test="${currentPage eq 'overview'}">bg-gray-100 text-primary-purple font-semibold</c:if><c:if test="${currentPage ne 'overview'}">text-gray-500 hover:bg-gray-50</c:if> transition duration-150">
                <span>Tổng quan</span>
            </a>

            <a href="?pageName=services" class="flex items-center space-x-3 p-3 rounded-xl <c:if test="${currentPage eq 'services'}">bg-gray-100 text-primary-purple font-semibold</c:if><c:if test="${currentPage ne 'services'}">text-gray-500 hover:bg-gray-50</c:if> transition duration-150">
                <span>Dịch vụ</span>
            </a>

            <a href="?pageName=staff" class="flex items-center space-x-3 p-3 rounded-xl <c:if test="${currentPage eq 'staff'}">bg-gray-100 text-primary-purple font-semibold</c:if><c:if test="${currentPage ne 'staff'}">text-gray-500 hover:bg-gray-50</c:if> transition duration-150">
                <span>Nhân viên</span>
            </a>

            <a href="?pageName=customer" class="flex items-center space-x-3 p-3 rounded-xl <c:if test="${currentPage eq 'customer'}">bg-gray-100 text-primary-purple font-semibold</c:if><c:if test="${currentPage ne 'customer'}">text-gray-500 hover:bg-gray-50</c:if> transition duration-150">
                <span>Khách hàng</span>
            </a>

            <a href="?pageName=cancel" class="flex items-center space-x-3 p-3 rounded-xl <c:if test="${currentPage eq 'cancel'}">bg-gray-100 text-primary-purple font-semibold</c:if><c:if test="${currentPage ne 'cancel'}">text-gray-500 hover:bg-gray-50</c:if> transition duration-150">
                <span>Lịch hủy</span>
            </a>
        </nav>
    </aside>
    <%-- Hết Sidebar --%>

    <%-- Main Content --%>
    <main class="flex-1 p-6 md:p-8">

        <%-- Tiêu đề và các thành phần lọc (có thể thêm sau) --%>
        <h1 class="text-3xl font-bold text-gray-800 mb-6">
            <c:choose>
                <c:when test="${currentPage eq 'overview'}">Tổng quan</c:when>
                <c:when test="${currentPage eq 'services'}">Báo cáo Dịch vụ</c:when>
                <c:when test="${currentPage eq 'staff'}">Quản lý Nhân viên</c:when>
                <c:when test="${currentPage eq 'customer'}">Phân tích Khách hàng</c:when>
                <c:when test="${currentPage eq 'cancel'}">Thống kê Lịch hủy</c:when>
                <c:otherwise>Báo cáo</c:otherwise>
            </c:choose>
        </h1>

        <%-- Lưới nội dung chính --%>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">

            <section class="md:col-span-2 space-y-6 order-2 md:order-1">

                <%-- Chèn nội dung cụ thể của từng trang tại đây. --%>
                <%-- Có thể dùng c:import để nhúng các phần nhỏ (fragments) --%>
                <%-- Hoặc c:if/c:choose để render nội dung tùy theo biến currentPage --%>

                <c:choose>
                    <c:when test="${currentPage eq 'overview'}">
                        <%-- Ví dụ: Nội dung trang Tổng quan --%>
                        <div class="bg-white p-6 rounded-xl shadow-lg">
                            <h2 class="text-xl font-semibold text-gray-700 mb-4">Các chỉ số chính</h2>
                            <p>Đây là nội dung báo cáo tổng quan. Dữ liệu sẽ được hiển thị từ các Java Bean qua các biểu thức JSP như: <strong>${dataBean.totalRevenue}</strong></p>
                                <%-- Thêm các card/biểu đồ tại đây --%>
                        </div>
                    </c:when>
                    <c:when test="${currentPage eq 'services'}">
                        <%-- Ví dụ: Nội dung trang Dịch vụ --%>
                        <div class="bg-white p-6 rounded-xl shadow-lg">
                            <h2 class="text-xl font-semibold text-gray-700 mb-4">Hiệu suất Dịch vụ</h2>
                            <p>Bảng thống kê các dịch vụ, ví dụ sử dụng JSTL Loop:</p>
                            <ul>
                                <c:forEach var="service" items="${requestScope.serviceList}">
                                    <li>${service.name} - ${service.rating} sao</li>
                                </c:forEach>
                            </ul>
                        </div>
                    </c:when>
                    <%-- Thêm các trang khác tương tự --%>
                    <c:otherwise>
                        <div class="bg-white p-6 rounded-xl shadow-lg text-center text-gray-500">
                            Trang <strong>${currentPage}</strong> đang được xây dựng hoặc không tìm thấy.
                        </div>
                    </c:otherwise>
                </c:choose>

            </section>

        </div>

    </main>
    <%-- Hết Main Content --%>
</div>

</body>
</html>
