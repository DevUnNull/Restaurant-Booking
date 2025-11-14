<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<jsp:useBean id="today" class="java.util.Date" scope="page" />

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Báo Cáo Khách Hàng</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

    <style>
        :root {
            /* Biến Màu Sắc */
            --main-color: #D32F2F; /* Đỏ - Nút Chính, Thanh Điều Hướng Trên Cùng, Viền Tiêu đề */
            --light-red: #FFCDD2; /* Đỏ Nhạt - HR, Hover Bảng, Viền Biểu đồ */
            --dark-red: #B71C1C; /* Đỏ Đậm - Tiêu đề, Văn bản Mạnh */
            --menu-bg: #8B0000; /* Nền Menu - Thanh Bên */
            --menu-hover: #A52A2A; /* Hover Menu */
            --text-light: #f8f8f8;
            --text-dark: #333;
            --sidebar-width: 250px;
            --top-nav-height: 60px;
            --booking-color: #2196F3; /* Xanh Dương */
            --revenue-color: #4CAF50; /* Xanh Lá */
            --cancellation-color: #E91E63; /* Hồng/Đỏ */
            --rate-color: #FF9800; /* Cam/Cảnh báo */
            --staff-chart-color: #00897B; /* Xanh Lục Bảo */
            --staff-border-color: #00897B;
            --customer-color: #1976D2; /* Xanh Dương Khách hàng */
        }

        /* Base & Layout */
        body { font-family: Arial, sans-serif; padding: 0; margin: 0; background-color: #f4f4f4; padding-top: var(--top-nav-height); overflow-x: hidden; }
        .wrapper { display: flex; min-height: calc(100vh - var(--top-nav-height)); position: relative; }
        .top-nav { position: fixed; top: 0; left: 0; right: 0; height: var(--top-nav-height); background-color: var(--main-color); color: var(--text-light); display: flex; align-items: center; justify-content: space-between; padding: 0 15px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); z-index: 1000; }
        .top-nav .restaurant-group { display: flex; align-items: center; gap: 15px; flex-shrink: 0; }
        /*.top-nav .restaurant-name { font-size: 1.2em; font-weight: bold; color: white; white-space: nowrap; }*/
        .home-button { background-color: var(--main-color); color: white; border: 1px solid var(--main-color); padding: 5px 10px; border-radius: 4px; text-decoration: none; font-size: 0.85em; transition: all 0.2s; display: flex; align-items: center; box-shadow: 0 1px 3px rgba(0,0,0,0.2); }
        .home-button:hover { background-color: var(--dark-red); color: white; border-color: var(--dark-red); }
        .top-nav .user-info { display: flex; align-items: center; padding-right: 15px; font-size: 1em; font-weight: bold; }
        .sidebar { width: var(--sidebar-width); position: fixed; top: var(--top-nav-height); left: 0; bottom: 0; background-color: var(--menu-bg); color: var(--text-light); padding-top: 10px; box-shadow: 2px 0 5px rgba(0,0,0,0.1); z-index: 999; }
        .sidebar ul { list-style: none; padding: 0; margin: 0; }
        .sidebar li a { display: block; padding: 15px 20px; text-decoration: none; color: var(--text-light); border-bottom: 1px solid rgba(255, 255, 255, 0.1); transition: background-color 0.3s; }
        .sidebar li a:hover, .sidebar li a.active { background-color: var(--menu-hover); color: white; }
        .main-content-body { margin-left: var(--sidebar-width); flex-grow: 1; padding: 20px; background-color: #f4f4f4; min-height: 100%; box-sizing: border-box; }
        .content-container { background-color: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 0 10px rgba(0, 0, 0, 0.05); width: 100%; max-width: 1200px; margin: 0 auto; box-sizing: border-box; }

        /* Filter Styles */
        .filter-section { background-color: #fff; padding: 15px 20px; border: 1px solid #eee; border-radius: 6px; margin-bottom: 20px; box-shadow: 0 1px 3px rgba(0,0,0,0.05); }
        .filter-item { display: flex; flex-direction: column; min-width: 120px; }
        .filter-item label { font-size: 0.9em; color: #555; margin-bottom: 5px; font-weight: bold; }
        .filter-item input[type="date"] { padding: 8px 10px; border: 1px solid #ccc; border-radius: 4px; min-width: 120px; font-size: 1em; }
        .btn-apply { background-color: var(--main-color); color: white; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; font-weight: bold; transition: background-color 0.3s; }
        .btn-apply:hover { background-color: var(--dark-red); }
        h1, h2, h3 { color: var(--dark-red); }
        h1 { border-bottom: 2px solid var(--main-color); padding-bottom: 10px; }
        hr { border: none; height: 1px; background-color: var(--light-red); margin: 20px 0; }

        /* CSS Thẻ Tóm Tắt */
        .summary-container { display: flex; gap: 20px; margin-bottom: 20px; flex-wrap: wrap; }
        .summary-card { flex: 1; min-width: 250px; color: var(--text-light); padding: 20px; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); display: flex; align-items: center; gap: 20px; }
        .summary-card .icon { font-size: 3em; opacity: 0.8; }
        .summary-card .info .value { font-size: 2.2em; font-weight: 700; }
        .summary-card .info .label { font-size: 1.1em; opacity: 0.9; }
        .summary-card.customer { background-color: var(--customer-color); }
        .summary-card.total { background-color: var(--cancellation-color); }
        .summary-card.revenue { background-color: var(--revenue-color); }

        /* SỬA: Sao chép style từ staff-report.jsp cho thẻ chi tiết */
        .staff-info-card {
            flex: 1;
            padding: 15px;
            border-radius: 8px;
            background-color: #fff;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            border-left: 5px solid var(--customer-color); /* Đổi sang màu khách hàng */
            min-width: 250px; /* Đảm bảo kích thước tối thiểu */
        }
        .staff-info-card div { margin-bottom: 8px; font-size: 0.95em; }
        .staff-info-card strong { color: var(--dark-red); }

        /* Customer Table Styles */
        .customer-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            border: 1px solid #ddd;
        }
        .customer-table th, .customer-table td {
            padding: 12px;
            border: 1px solid #ddd;
        }
        .customer-table th {
            background-color: #f8f8f8;
            color: var(--customer-color);
            font-weight: bold;
            text-transform: uppercase;
        }
        .customer-table tr:hover { background-color: #e3f2fd; }

        /* SỬA: Thêm style cho link tên */
        .customer-table td a {
            color: var(--customer-color);
            font-weight: bold;
            text-decoration: none;
            transition: color 0.2s;
        }
        .customer-table td a:hover {
            color: var(--dark-red);
            text-decoration: underline;
        }

        .status-active { color: var(--revenue-color); font-weight: bold; }
        .status-inactive { color: var(--cancellation-color); font-weight: bold; }

        /* SỬA: Thêm style cho các trạng thái đơn hàng (trong bảng chi tiết) */
        .status-completed { color: var(--revenue-color); font-weight: bold; }
        .status-pending { color: var(--rate-color); font-weight: bold; }
        .status-cancelled { color: var(--cancellation-color); font-weight: bold; }
        .status-no_show { color: #555; font-weight: bold; }

        .text-center { text-align: center; }
        .text-right { text-align: right; }

        /* Modal Styles */
        .modal { display: none; position: fixed; z-index: 1001; left: 0; top: 0; width: 100%; height: 100%; overflow: auto; background-color: rgba(0,0,0,0.4); padding-top: 60px; }
        .modal-content { background-color: #fefefe; margin: 5% auto; padding: 20px; border: 1px solid #888; width: 90%; max-width: 400px; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.2); }
        .modal-header { display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #eee; padding-bottom: 10px; margin-bottom: 15px; }
        .close { color: #aaa; font-size: 28px; font-weight: bold; cursor: pointer; }
        .close:hover { color: #000; }
        .filter-grid { display: flex; gap: 15px; align-items: flex-end; }


        /* Pagination Styles (CHUẨN HÓA) */
        .pagination-container {
            display: flex;
            justify-content: flex-end; /* Căn lề phải */
            margin-top: 25px;
        }
        .pagination {
            list-style: none;
            padding: 0;
            margin: 0;
            display: flex;
            border-radius: 4px;
            overflow: hidden;
            border: 1px solid #ddd;
        }
        .pagination li {
            margin: 0;
        }
        .pagination li a, .pagination li span {
            display: block;
            padding: 10px 15px;
            text-decoration: none;
            color: #555;
            background-color: #fff;
            border-right: 1px solid #ddd;
            transition: background-color 0.3s;
        }
        .pagination li:last-child a, .pagination li:last-child span {
            border-right: none;
        }
        .pagination li a:hover {
            background-color: #f4f4f4;
        }
        .pagination li.active span {
            background-color: var(--main-color);
            color: white;
            font-weight: bold;
            border-color: var(--main-color);
        }
        .pagination li.disabled span, .pagination li.disabled a {
            color: #ccc;
            background-color: #fff;
            pointer-events: none;
            opacity: 0.6;
        }

        /* === NEW POPUP STYLE (From Overview/Service Report) === */
        #missingDateAlert {
            position: fixed;
            top: 20px;
            left: 50%;
            transform: translateX(-50%);
            padding: 20px 30px;
            min-width: 300px;
            max-width: 90%;
            background-color: #E65100; /* Deep Orange/Rust */
            color: white;
            border-radius: 8px;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.25);
            z-index: 1002;
            display: none;
            opacity: 0;
            transition: opacity 0.3s ease-in-out;
            font-weight: bold;
            text-align: center;
            font-size: 1.1em;
        }

        /* MỚI: CSS cho bảng Chi tiết Món ăn đã được xóa */

        /* ==================================================== */
    </style>
</head>
<body>
<%-- SỬA: Đổi pageSize thành 5 --%>
<c:set var="pageSize" value="5" scope="request"/>
<%-- Thanh Điều Hướng Trên Cùng (Top Nav) --%>
<div class="top-nav">
    <div class="restaurant-group">
        <a href="<%= request.getContextPath() %>/" class="home-button">
            <i class="fas fa-home"></i> Trang Chủ
        </a>
    </div>
    <div class="user-info">
    <span>Người dùng:
        <c:choose>
            <c:when test="${not empty sessionScope.currentUser}">
                ${sessionScope.currentUser.fullName}
            </c:when>
            <c:otherwise>
                Khách
            </c:otherwise>
        </c:choose>
    </span>
    </div>
</div>

<%-- Wrapper (Thanh Bên + Nội Dung Chính) --%>
<div class="wrapper">
    <div class="sidebar">
        <ul>
            <li><a href="<%= request.getContextPath() %>/overview-report" ${request.getRequestURI().contains("overview-report") ? "class=\"active\"" : ""}>Báo Cáo Tổng Quan</a></li>
            <li><a href="<%= request.getContextPath() %>/service-report" ${request.getRequestURI().contains("service-report") ? "class=\"active\"" : ""}>Báo Cáo Dịch Vụ</a></li>
            <li><a href="<%= request.getContextPath() %>/staff-report" ${request.getRequestURI().contains("staff-report") ? "class=\"active\"" : ""}>Báo Cáo Nhân Viên</a></li>
            <li><a href="<%= request.getContextPath() %>/user-report" ${request.getRequestURI().contains("user-report") ? "class=\"active\"" : ""}>Báo Cáo Khách Hàng</a></li>
            <li><a href="<%= request.getContextPath() %>/cancel-report" ${request.getRequestURI().contains("cancel-report") ? "class=\"active\"" : ""}>Báo Cáo Hủy Đặt Bàn</a></li>
        </ul>
    </div>

    <div class="main-content-body">
        <div class="content-container">

            <%-- SỬA: BẮT ĐẦU KHỐI C:CHOOSE ĐỂ PHÂN CHIA CHẾ ĐỘ XEM --%>
            <c:choose>
                <%-- CHẾ ĐỘ 1: XEM CHI TIẾT --%>
                <c:when test="${requestScope.isDetailMode && not empty requestScope.selectedCustomerDetail}">

                    <%-- Nút Quay Lại --%>
                    <a href="user-report?startDate=${requestScope.startDateParam}&endDate=${requestScope.endDateParam}" class="home-button" style="margin-bottom: 15px; display: inline-flex; background-color: #555; border-color: #555;"><i class="fas fa-arrow-left"></i> Quay lại Tổng quan</a>

                    <h1>Báo Cáo Chi Tiết Khách Hàng</h1>

                    <%-- SỬA: Đã di chuyển bean 'today' lên đầu --%>
                    <fmt:formatDate value="${today}" pattern="yyyy" var="currentYear" />

                    <%-- Thẻ Thông Tin Chi Tiết Khách Hàng --%>
                    <div class="summary-cards-staff">
                        <div class="staff-info-card">
                            <div><strong>Khách hàng:</strong> ${requestScope.selectedCustomerDetail.fullName} (ID: ${requestScope.selectedUserId})</div>
                            <div><strong>Email:</strong> ${requestScope.selectedCustomerDetail.email}</div>
                            <div><strong>Điện thoại:</strong> ${requestScope.selectedCustomerDetail.phoneNumber}</div>
                            <div><strong>Trạng thái:</strong>
                                <span class="${requestScope.selectedCustomerDetail.status == 'ACTIVE' ? 'status-active' : 'status-inactive'}">
                                        ${requestScope.selectedCustomerDetail.status == 'ACTIVE' ? 'ĐANG HOẠT ĐỘNG' : 'KHÔNG HOẠT ĐỘNG'}
                                </span>
                            </div>
                            <div><strong>Giới tính/Tuổi:</strong>
                                <c:choose>
                                    <c:when test="${customer.gender == 'Male'}">Nam</c:when>
                                    <c:when test="${customer.gender == 'Female'}">Nữ</c:when>
                                    <c:when test="${customer.gender == 'Other'}">Khác</c:when>
                                    <c:otherwise>N/A</c:otherwise>
                                </c:choose>
                                /
                                <c:if test="${not empty requestScope.selectedCustomerDetail.dob}">
                                    <fmt:formatDate value="${requestScope.selectedCustomerDetail.dob}" pattern="yyyy" var="birthYear" />
                                    ${currentYear - birthYear} tuổi
                                </c:if>
                                <c:if test="${empty requestScope.selectedCustomerDetail.dob}">
                                    N/A
                                </c:if>
                            </div>
                        </div>
                    </div>

                    <hr/>
                    <%-- SỬA LỖI HTTP 500: Sử dụng startDateObject và endDateObject --%>
                    <h2>Lịch sử Đơn hàng (trong kỳ <fmt:formatDate value="${requestScope.startDateObject}" pattern="dd/MM/yyyy"/> đến <fmt:formatDate value="${requestScope.endDateObject}" pattern="dd/MM/yyyy"/>)</h2>

                    <%-- Bảng Lịch Sử Đơn Hàng (Đã xóa cột/logic chi tiết) --%>
                    <c:choose>
                        <c:when test="${not empty requestScope.customerReservations}">
                            <table class="customer-table">
                                <thead>
                                <tr>
                                    <th>ID Đơn Hàng</th>
                                    <th>Ngày Đặt</th>
                                    <th>Giờ Đặt</th>
                                    <th>Trạng Thái</th>
                                    <th class="text-right">Tổng Tiền</th>
                                </tr>
                                <thead>
                                <tbody>
                                <c:forEach var="res" items="${requestScope.customerReservations}" varStatus="loop">
                                    <tr>
                                        <td>${res.reservation_id}</td>
                                        <td><fmt:formatDate value="${res.reservation_date}" pattern="dd/MM/yyyy" /></td>
                                        <td><fmt:formatDate value="${res.reservation_time}" pattern="HH:mm" /></td>
                                        <td>
                                            <span class="status-${fn:toLowerCase(res.status)}">
                                                    ${res.status}
                                            </span>
                                        </td>
                                        <td class="text-right">
                                            <c:if test="${res.total_amount != null}">
                                                <fmt:formatNumber value="${res.total_amount}" type="number" pattern="#,###"/> VND
                                            </c:if>
                                            <c:if test="${res.total_amount == null}">
                                                N/A
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </c:when>
                        <c:otherwise>
                            <p>Không tìm thấy đơn hàng nào cho khách hàng này trong khoảng thời gian đã chọn.</p>
                        </c:otherwise>
                    </c:choose>

                </c:when>

                <%-- CHẾ ĐỘ 2: XEM TỔNG QUAN (Code giữ nguyên) --%>
                <c:otherwise>
                    <h1>Báo Cáo Tổng Quan Khách Hàng</h1>

                    <%-- Phần Bộ Lọc (Giữ nguyên) --%>
                    <div class="filter-section">
                        <h3 style="color: #555; margin-top: 0; margin-bottom: 15px;">Bộ Lọc Báo Cáo</h3>
                        <button type="button" class="btn-apply" onclick="openFilterModal()"><i class="fas fa-calendar"></i> Lọc theo Ngày</button>
                    </div>

                    <%-- Thông Báo Cảnh Báo (Giữ nguyên) --%>
                    <c:if test="${not empty requestScope.warningMessage}">
                        <div id="alertWarning" style="background-color: #fff3cd; color: #856404; padding: 15px; margin-bottom: 20px; border: 1px solid #ffeeba; border-radius: 4px;">
                            <i class="fas fa-exclamation-triangle"></i>${requestScope.warningMessage}
                        </div>
                    </c:if>

                    <%-- Thông Báo Lỗi (Giữ nguyên) --%>
                    <c:if test="${not empty requestScope.errorMessage}">
                        <div id="alertError" style="background-color: #f8d7da; color: #721c24; padding: 15px; margin-bottom: 20px; border: 1px solid #f5c6cb; border-radius: 4px;">
                            <i class="fas fa-times-circle"></i>
                            <strong>Lỗi Hệ thống:</strong> ${requestScope.errorMessage}
                        </div>
                    </c:if>

                    <%-- CHỈ HIỂN THỊ KHỐI NÀY NẾU CÓ THAM SỐ NGÀY HỢP LỆ --%>
                    <c:if test="${empty requestScope.errorMessage}">

                        <%-- Hiển thị tiêu đề Tóm tắt --%>
                        <c:if test="${not empty requestScope.startDateParam}">
                            <h2>Tóm Tắt Khách Hàng
                                <c:if test="${not empty requestScope.startDateObject}">
                                    (Từ <fmt:formatDate value="${requestScope.startDateObject}" pattern="dd/MM/yyyy"/> đến <fmt:formatDate value="${requestScope.endDateObject}" pattern="dd/MM/yyyy"/>)
                                </c:if>
                            </h2>
                        </c:if>
                        <c:if test="${empty requestScope.startDateParam}">
                            <h2 style="color: #555;">Tóm Tắt Khách Hàng</h2>
                        </c:if>



                        <%-- KHỐI DỮ LIỆU CHỈ HIỂN THỊ KHI CÓ THAM SỐ NGÀY HỢP LỆ --%>
                        <c:if test="${not empty requestScope.startDateParam}">

                            <div class="summary-container">
                                <div class="summary-card customer">
                                    <div class="icon"><i class="fas fa-user-plus"></i></div>
                                    <div class="info">
                                        <div class="value">${requestScope.newCustomerCount}</div>
                                        <div class="label">Khách Hàng Mới (Trong Kỳ)</div>
                                    </div>
                                </div>
                                <div class="summary-card total">
                                    <div class="icon"><i class="fas fa-users"></i></div>
                                    <div class="info">
                                        <div class="value">${requestScope.totalCustomerCount}</div>
                                        <div class="label">Tổng Khách Hàng Đang Hoạt Động</div>
                                    </div>
                                </div>
                                <div class="summary-card revenue">
                                    <div class="icon"><i class="fas fa-dollar-sign"></i></div>
                                    <div class="info">
                                        <div class="value">
                                            <fmt:formatNumber value="${requestScope.grandTotalSpending}" type="number" minFractionDigits="0" />
                                        </div>
                                        <div class="label">Tổng Chi Tiêu (trong kỳ)</div>
                                    </div>
                                </div>
                            </div>
                            <hr/>

                            <h2>Danh Sách Chi Tiết Khách Hàng (Trang ${requestScope.currentPage} trên ${requestScope.totalPages})</h2>

                            <c:choose>
                                <c:when test="${not empty requestScope.customerData}">
                                    <fmt:formatDate value="${today}" pattern="yyyy" var="currentYear" />
                                    <table class="customer-table">
                                        <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Tên Khách Hàng</th>
                                            <th>Email</th>
                                            <th>Điện Thoại</th>
                                            <th class="text-center">Giới Tính</th>
                                            <th class="text-center">Tuổi</th>
                                            <th class="text-center">Trạng Thái</th>
                                            <th class="text-center">Tổng Số Lượt Đặt Bàn (Hoàn Thành)</th>
                                            <th class="text-right">Tổng Chi Tiêu (Hoàn Thành)</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <c:forEach var="customer" items="${requestScope.customerData}">
                                            <tr>
                                                <td>${customer.customerId}</td>
                                                <td>
                                                    <a href="user-report?userId=${customer.customerId}&startDate=${requestScope.startDateParam}&endDate=${requestScope.endDateParam}">
                                                            ${customer.customerName}
                                                    </a>
                                                </td>
                                                <td>${customer.email}</td>
                                                <td>${customer.phoneNumber}</td>
                                                <td class="text-center">
                                                    <c:choose>
                                                        <c:when test="${customer.gender == 'Male'}">Nam</c:when>
                                                        <c:when test="${customer.gender == 'Female'}">Nữ</c:when>
                                                        <c:when test="${customer.gender == 'Other'}">Khác</c:when>
                                                        <c:otherwise>N/A</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="text-center">
                                                    <c:if test="${not empty customer.dob}">
                                                        <fmt:formatDate value="${customer.dob}" pattern="yyyy" var="birthYear" />
                                                        ${currentYear - birthYear}
                                                    </c:if>
                                                    <c:if test="${empty customer.dob}">
                                                        N/A
                                                    </c:if>
                                                </td>

                                                <td class="text-center">
                                                    <span class="${customer.customerStatus == 'ACTIVE' ? 'status-active' : 'status-inactive'}">
                                                            ${customer.customerStatus == 'ACTIVE' ? 'ĐANG HOẠT ĐỘNG' : 'KHÔNG HOẠT ĐỘNG'}
                                                    </span>
                                                </td>
                                                <td class="text-center">${customer.totalReservations}</td>
                                                <td class="text-right">
                                                    <fmt:formatNumber value="${customer.totalSpending}" type="number" minFractionDigits="0" /> VND
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        </tbody>
                                    </table>
                                </c:when>
                                <c:otherwise>
                                    <p>Không tìm thấy dữ liệu khách hàng hoặc các lượt đặt bàn hoàn thành trong khoảng thời gian đã chọn.</p>
                                </c:otherwise>
                            </c:choose>

                            <%-- PHẦN PHÂN TRANG (Giữ nguyên) --%>
                            <c:set var="currentPage" value="${requestScope.currentPage}"/>
                            <c:set var="totalPages" value="${requestScope.totalPages}"/>
                            <c:set var="startDateParam" value="${requestScope.startDateParam}"/>
                            <c:set var="endDateParam" value="${requestScope.endDateParam}"/>

                            <c:if test="${totalPages > 1}">
                                <div class="pagination-container">
                                    <ul class="pagination">
                                        <c:url var="prevUrl" value="user-report">
                                            <c:param name="page" value="${currentPage - 1}"/>
                                            <c:param name="pageSize" value="${pageSize}"/>
                                            <c:param name="startDate" value="${startDateParam}"/>
                                            <c:param name="endDate" value="${endDateParam}"/>
                                        </c:url>
                                        <c:choose>
                                            <c:when test="${currentPage > 1}">
                                                <li><a href="${prevUrl}">Trước</a></li>
                                            </c:when>
                                            <c:otherwise>
                                                <li class="disabled"><span>Trước</span></li>
                                            </c:otherwise>
                                        </c:choose>
                                        <c:set var="startPage" value="${(currentPage - 2) > 1 ? (currentPage - 2) : 1}"/>
                                        <c:set var="endPage" value="${(currentPage + 2) < totalPages ? (currentPage + 2) : totalPages}"/>
                                        <c:if test="${endPage - startPage < 4}">
                                            <c:set var="newStart" value="${endPage - 4}"/>
                                            <c:if test="${newStart > 1}">
                                                <c:set var="startPage" value="${newStart}"/>
                                            </c:if>
                                            <c:if test="${startPage < 1}">
                                                <c:set var="startPage" value="1"/>
                                            </c:if>
                                            <c:set var="endPage" value="${startPage + 4}"/>
                                            <c:if test="${endPage > totalPages}">
                                                <c:set var="endPage" value="${totalPages}"/>
                                            </c:if>
                                        </c:if>
                                        <c:if test="${startPage > 1}">
                                            <c:url var="page1Url" value="user-report">
                                                <c:param name="page" value="1"/>
                                                <c:param name="pageSize" value="${pageSize}"/>
                                                <c:param name="startDate" value="${startDateParam}"/>
                                                <c:param name="endDate" value="${endDateParam}"/>
                                            </c:url>
                                            <li><a href="${page1Url}">1</a></li>
                                            <c:if test="${startPage > 2}"><li><span>...</span></li></c:if>
                                        </c:if>
                                        <c:forEach begin="${startPage}" end="${endPage}" var="i">
                                            <c:url var="pageUrl" value="user-report">
                                                <c:param name="page" value="${i}"/>
                                                <c:param name="pageSize" value="${pageSize}"/>
                                                <c:param name="startDate" value="${startDateParam}"/>
                                                <c:param name="endDate" value="${endDateParam}"/>
                                            </c:url>
                                            <c:choose>
                                                <c:when test="${i == currentPage}">
                                                    <li class="active"><span>${i}</span></li>
                                                </c:when>
                                                <c:otherwise>
                                                    <li><a href="${pageUrl}">${i}</a></li>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:forEach>
                                        <c:if test="${endPage < totalPages}">
                                            <c:if test="${endPage < totalPages - 1}"><li><span>...</span></li></c:if>
                                            <c:url var="lastPageUrl" value="user-report">
                                                <c:param name="page" value="${totalPages}"/>
                                                <c:param name="pageSize" value="${pageSize}"/>
                                                <c:param name="startDate" value="${startDateParam}"/>
                                                <c:param name="endDate" value="${endDateParam}"/>
                                            </c:url>
                                            <li><a href="${lastPageUrl}">${totalPages}</a></li>
                                        </c:if>
                                        <c:url var="nextUrl" value="user-report">
                                            <c:param name="page" value="${currentPage + 1}"/>
                                            <c:param name="pageSize" value="${pageSize}"/>
                                            <c:param name="startDate" value="${startDateParam}"/>
                                            <c:param name="endDate" value="${endDateParam}"/>
                                        </c:url>
                                        <c:choose>
                                            <c:when test="${currentPage < totalPages}">
                                                <li><a href="${nextUrl}">Sau</a></li>
                                            </c:when>
                                            <c:otherwise>
                                                <li class="disabled"><span>Sau</span></li>
                                            </c:otherwise>
                                        </c:choose>
                                    </ul>
                                </div>
                            </c:if>
                            <hr/>

                        </c:if>

                    </c:if>
                </c:otherwise>
            </c:choose>

        </div>
    </div>
</div>

<%-- Modal Lọc (Giữ nguyên) --%>
<div id="filterModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3>Bộ Lọc Báo Cáo (Ngày)</h3>
            <span class="close" onclick="closeFilterModal()">&times;</span>
        </div>
        <form id="modalForm" class="modal-form">
            <%-- SỬA: Thêm input ẩn cho userId nếu đang ở chế độ chi tiết --%>
            <c:if test="${requestScope.isDetailMode}">
                <input type="hidden" id="modalUserId" name="userId" value="${requestScope.selectedUserId}">
            </c:if>
            <div class="filter-item">
                <label for="modalStartDate">Từ Ngày</label>
                <input type="date" id="modalStartDate" name="startDate" value="${requestScope.startDateParam}">
            </div>
            <div class="filter-item">
                <label for="modalEndDate">Đến Ngày</label>
                <input type="date" id="modalEndDate" name="endDate" value="${requestScope.endDateParam}">
            </div>
            <button type="button" class="btn-apply" onclick="submitFilterForm()"><i class="fas fa-check"></i> Áp Dụng Bộ Lọc</button>
        </form>
    </div>
</div>

<div id="missingDateAlert">
    <span id="missingDateAlertText"></span>
</div>

<%-- JavaScript (Giữ nguyên) --%>
<script>
    const START_OF_BUSINESS_DATE = "2025-09-01"; // SỬA: Cập nhật ngày bắt đầu kinh doanh
    const TARGET_PAGE_SIZE = 5; // SỬA: Cập nhật page size
    const isDetailMode = "${requestScope.isDetailMode}" === "true"; // SỬA: Thêm biến kiểm tra chế độ

    // --- KHAI BÁO CÁC BIẾN POPUP CẢNH BÁO ---
    const missingDateAlert = document.getElementById('missingDateAlert');
    const missingDateAlertText = document.getElementById('missingDateAlertText');

    function showAlert(message) {
        // (Hàm này giữ nguyên như code cũ)
        missingDateAlertText.textContent = message;
        missingDateAlert.style.display = 'block';
        setTimeout(() => { missingDateAlert.style.opacity = '1'; }, 10);
        setTimeout(() => {
            missingDateAlert.style.opacity = '0';
            setTimeout(() => {
                missingDateAlert.style.display = 'none';
                missingDateAlertText.textContent = '';
            }, 300);
        }, 5000);
    }

    // --- HÀM CHO MODAL LỌC NGÀY ---
    function openFilterModal() {
        const modalStartDateInput = document.getElementById('modalStartDate');
        modalStartDateInput.min = START_OF_BUSINESS_DATE;
        if (modalStartDateInput.value && modalStartDateInput.value < START_OF_BUSINESS_DATE) {
            modalStartDateInput.value = START_OF_BUSINESS_DATE;
        }
        document.getElementById('filterModal').style.display = 'block';
    }

    function closeFilterModal() {
        document.getElementById('filterModal').style.display = 'none';
    }

    // SỬA: Cập nhật logic submit để giữ userId nếu có
    function submitFilterForm() {
        const startDate = document.getElementById('modalStartDate').value;
        const endDate = document.getElementById('modalEndDate').value;

        // Khôi phục kiểm tra bắt buộc phải có ngày (theo logic cũ)
        if (!startDate || !endDate) {
            closeFilterModal();
            showAlert("Vui lòng chọn Ngày Bắt đầu và Ngày Kết thúc cho báo cáo.");
            return;
        }

        // Tuy nhiên vẫn kiểm tra tính hợp lệ nếu người dùng nhập ngày không đúng thứ tự
        if (new Date(startDate) > new Date(endDate)) {
            closeFilterModal();
            showAlert("Lỗi: Ngày Bắt đầu không được lớn hơn Ngày Kết thúc. Vui lòng kiểm tra lại.");
            return;
        }

        // Luôn reset về trang 1 khi lọc
        let url = 'user-report?startDate=' + startDate + '&endDate=' + endDate + '&page=1&pageSize=' + TARGET_PAGE_SIZE;

        // SỬA: Nếu đang ở chế độ chi tiết, giữ lại userId
        if (isDetailMode) {
            const userId = document.getElementById('modalUserId').value;
            url += '&userId=' + userId;
        }

        window.location.href = url;
        closeFilterModal();
    }

    window.onclick = function(event) {
        const filterModal = document.getElementById('filterModal');
        if (event.target == filterModal) {
            closeFilterModal();
        }
    }
</script>
</body>
</html>