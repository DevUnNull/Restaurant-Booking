<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="funt" uri="http://java.sun.com/jsp/jstl/functions" %>
<jsp:useBean id="today" class="java.util.Date" scope="page" />

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Báo Cáo Đặt Bàn Đã Hủy</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

    <style>
        :root {

            --main-color: #D32F2F;
            --light-red: #FFCDD2;
            --dark-red: #B71C1C;
            --menu-bg: #8B0000;
            --menu-hover: #A52A2A;
            --text-light: #f8f8f8;
            --text-dark: #333;
            --sidebar-width: 250px;
            --top-nav-height: 60px;
            --booking-color: #2196F3;
            --revenue-color: #4CAF50;
            --cancellation-color: #E91E63;
            --rate-color: #FF9800;
            --staff-chart-color: #00897B;
            --staff-border-color: #00897B;
            --customer-color: #1976D2;
        }

        body {
            font-family: Arial, sans-serif;
            padding: 0;
            margin: 0;
            background-color: #f4f4f4;
            padding-top: var(--top-nav-height);
            overflow-x: hidden;
        }

        .wrapper {
            display: flex;
            min-height: calc(100vh - var(--top-nav-height));
            position: relative;
        }

        .top-nav {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            height: var(--top-nav-height);
            background-color: var(--main-color);
            color: var(--text-light);
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 15px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            z-index: 1000;
        }

        .top-nav .restaurant-group {
            display: flex;
            align-items: center;
            gap: 15px;
            flex-shrink: 0;
        }

        .home-button {
            background-color: var(--main-color);
            color: white;
            border: 1px solid var(--main-color);
            padding: 5px 10px;
            border-radius: 4px;
            text-decoration: none;
            font-size: 0.85em;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.2);
        }

        .home-button:hover {
            background-color: var(--dark-red);
            color: white;
            border-color: var(--dark-red);
        }

        .top-nav .user-info {
            display: flex;
            align-items: center;
            padding-right: 15px;
            font-size: 1em;
            font-weight: bold;
        }

        .sidebar {
            width: var(--sidebar-width);
            position: fixed;
            top: var(--top-nav-height);
            left: 0;
            bottom: 0;
            background-color: var(--menu-bg);
            color: var(--text-light);
            padding-top: 10px;
            box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1);
            z-index: 999;
        }

        .sidebar ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .sidebar li a {
            display: block;
            padding: 15px 20px;
            text-decoration: none;
            color: var(--text-light);
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            transition: background-color 0.3s;
        }

        .sidebar li a:hover, .sidebar li a.active {
            background-color: var(--menu-hover);
            color: white;
        }

        .main-content-body {
            margin-left: var(--sidebar-width);
            flex-grow: 1;
            padding: 20px;
            background-color: #f4f4f4;
            min-height: 100%;
            box-sizing: border-box;
        }

        .content-container {
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.05);
            width: 100%;
            margin: 0 auto;
            box-sizing: border-box;
        }

        .filter-section {
            background-color: #fff;
            padding: 15px 20px;
            border: 1px solid #eee;
            border-radius: 6px;
            margin-bottom: 20px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
        }

        .filter-item {
            display: flex;
            flex-direction: column;
            min-width: 120px;
        }

        .filter-item label {
            font-size: 0.9em;
            color: #555;
            margin-bottom: 5px;
            font-weight: bold;
        }

        .filter-item input[type="date"] {
            padding: 8px 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            min-width: 120px;
            font-size: 1em;
        }

        .btn-apply {
            background-color: var(--main-color);
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: bold;
            transition: background-color 0.3s;
        }

        .btn-apply:hover {
            background-color: var(--dark-red);
        }

        h1, h2, h3 {
            color: var(--dark-red);
        }

        h1 {
            border-bottom: 2px solid var(--main-color);
            padding-bottom: 10px;
        }

        hr {
            border: none;
            height: 1px;
            background-color: var(--light-red);
            margin: 20px 0;
        }

        .warning-box-yellow { background-color: #fff9c4; color: #5d4037; padding: 15px; border: 1px solid #fff59d; border-radius: 4px; margin-top: 20px; }

        .cancellation-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            border: 1px solid #ddd;
        }

        .cancellation-table th, .cancellation-table td {
            padding: 12px;
            border: 1px solid #ddd;
        }

        .cancellation-table th {
            background-color: #f8f8f8;
            color: var(--cancellation-color);
            font-weight: bold;
            text-transform: uppercase;
        }

        .cancellation-table tr:hover {
            background-color: #fce4ec;
        }
        /* ----------------------------------------------- */

        .reason-cell {
            max-width: 300px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            cursor: help;
        }

        .status-cancelled {
            background-color: #FFC107;
            color: #333;
            padding: 4px 8px;
            border-radius: 4px;
            font-weight: bold;
        }

        .status-no-show {
            background-color: var(--cancellation-color);
            color: white;
            padding: 4px 8px;
            border-radius: 4px;
            font-weight: bold;
        }


        .text-center {
            text-align: center;
        }

        .text-right {
            text-align: right;
        }

        .modal {
            display: none;
            position: fixed;
            z-index: 1001;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0, 0, 0, 0.4);
            padding-top: 60px;
        }

        .modal-content {
            background-color: #fefefe;
            margin: 5% auto;
            padding: 20px;
            border: 1px solid #888;
            width: 90%;
            max-width: 400px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
            margin-bottom: 15px;
        }

        .close {
            color: #aaa;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }

        .close:hover {
            color: #000;
        }

        .filter-grid {
            display: flex;
            gap: 15px;
            align-items: flex-end;
        }

        .tooltip {
            position: relative;
            display: inline-block;
        }

        .tooltip .tooltiptext {
            visibility: hidden;
            width: 300px;
            background-color: #333;
            color: #fff;
            text-align: center;
            border-radius: 6px;
            padding: 5px;
            position: absolute;
            z-index: 1;
            bottom: 125%;
            left: 50%;
            margin-left: -150px;
            opacity: 0;
            transition: opacity 0.3s;
            white-space: normal;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }

        .tooltip:hover .tooltiptext {
            visibility: visible;
            opacity: 1;
        }

        /* PHẦN PHÂN TRANG (PAGINATION) - CHUẨN HÓA */
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

        .modal-form .btn-apply {
            margin-top: 20px;
            width: 100%;
        }

        /* [THÊM] CSS cho thanh thông báo lỗi (giống user-report) */
        #missingDateAlert {
            position: fixed;
            top: 20px;
            left: 50%;
            transform: translateX(-50%);
            padding: 20px 30px;
            min-width: 300px;
            max-width: 90%;
            background-color: #E65100;
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
    </style>
</head>
<body>
<c:set var="pageSize" value="5" scope="request"/>
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

            <form action="cancel-report" method="GET" id="filterForm" style="display: none;">
                <input type="hidden" id="formStartDate" name="startDate" value="${requestScope.startDateParam}">
                <input type="hidden" id="formEndDate" name="endDate" value="${requestScope.endDateParam}">
                <input type="hidden" name="page" value="1">
                <input type="hidden" name="pageSize" value="${pageSize}">
            </form>

            <h1>Báo Cáo Chi Tiết Hủy Đặt Bàn & Không Đến </h1>

            <div class="filter-section">
                <h3 style="color: #555; margin-top: 0; margin-bottom: 15px;">Bộ Lọc Báo Cáo</h3>
                <button type="button" class="btn-apply" onclick="openFilterModal()"><i class="fas fa-calendar"></i> Lọc
                    theo Ngày
                </button>
            </div>

            <c:if test="${not empty requestScope.warningMessage}">
                <div id="alertWarning"
                     style="background-color: #fff3cd; color: #856404; padding: 15px; margin-bottom: 20px; border: 1px solid #ffeeba; border-radius: 4px;">
                    <i class="fas fa-exclamation-triangle"></i>
                    <strong>Cảnh báo:</strong> ${requestScope.warningMessage}
                </div>
            </c:if>

            <c:if test="${not empty requestScope.errorMessage}">
                <div id="alertError"
                     style="background-color: #f8d7da; color: #721c24; padding: 15px; margin-bottom: 20px; border: 1px solid #f5c6cb; border-radius: 4px;">
                    <i class="fas fa-times-circle"></i>
                    <strong>Lỗi Hệ thống:</strong> ${requestScope.errorMessage}
                </div>
            </c:if>

            <c:choose>
                <c:when test="${not empty requestScope.cancellationData}">
                    <table class="cancellation-table">
                        <thead>
                        <tr>
                            <th>ID Đặt Bàn</th>
                            <th>Tên Khách Hàng</th>
                            <th>Email Khách Hàng</th>
                            <th>Ngày/Giờ Đặt Bàn</th>
                            <th class="text-center">Số Khách</th>
                            <th class="text-center">Trạng Thái</th>
                            <th>Lý do Hủy</th>
                            <th class="text-center">Thời gian Báo trước (Ngày)</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="item" items="${requestScope.cancellationData}">
                            <tr>
                                <td><c:out value="${item.reservationId}"/></td>
                                <td><c:out value="${item.customerName}"/></td>
                                <td><c:out value="${item.customerEmail}"/></td>
                                <td>
                                    <fmt:parseDate value="${item.reservationDate}" pattern="yyyy-MM-dd" var="resDateObj" type="date"/>
                                    <fmt:formatDate value="${resDateObj}" pattern="dd/MM/yyyy"/> lúc <c:out value="${item.reservationTime}"/>
                                </td>
                                <td class="text-center"><c:out value="${item.numberOfGuests}"/></td>
                                <td class="text-center">
                                    <c:choose>
                                        <c:when test="${item.reservationStatus == 'CANCELLED'}">
                                            <span class="status-cancelled">Đã Hủy</span>
                                        </c:when>
                                        <c:when test="${item.reservationStatus == 'NO_SHOW'}">
                                            <span class="status-no-show">Không Đến</span>
                                        </c:when>
                                        <c:otherwise>
                                            <c:out value="${item.reservationStatus}"/>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="reason-cell">
                                    <div class="tooltip">
                                        <c:set var="reasonText" value="${item.cancellationReason != null ? item.cancellationReason : 'Không cung cấp'}"/>
                                        <c:out value="${reasonText.length() > 50 ? reasonText.substring(0, 50).concat('...') : reasonText}"/>
                                        <c:if test="${item.cancellationReason != null}">
                                            <span class="tooltiptext"><c:out value="${item.cancellationReason}"/></span>
                                        </c:if>
                                    </div>
                                </td>
                                <td class="text-center">
                                    <c:choose>
                                        <c:when test="${item.leadTimeDays >= 0}">
                                            <c:out value="${item.leadTimeDays}"/> ngày
                                        </c:when>
                                        <c:otherwise>
                                            N/A
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>

                    <c:set var="currentPage" value="${requestScope.currentPage}"/>
                    <c:set var="totalPages" value="${requestScope.totalPages}"/>
                    <c:set var="totalRecords" value="${requestScope.totalRecords}"/>
                    <c:set var="startDate" value="${requestScope.startDateParam}"/>
                    <c:set var="endDate" value="${requestScope.endDateParam}"/>

                    <c:if test="${totalRecords > 0 and totalPages > 1}">
                        <div class="pagination-container">
                            <ul class="pagination">

                                <c:url var="prevUrl" value="cancel-report">
                                    <c:param name="page" value="${currentPage - 1}"/>
                                    <c:param name="pageSize" value="${pageSize}"/>
                                    <c:param name="startDate" value="${startDate}"/>
                                    <c:param name="endDate" value="${endDate}"/>
                                </c:url>
                                <c:choose>
                                    <c:when test="${currentPage > 1}">
                                        <li><a href="${prevUrl}"><i class="fas fa-chevron-left"></i> Trước</a></li>
                                    </c:when>
                                    <c:otherwise>
                                        <li class="disabled"><span><i class="fas fa-chevron-left"></i> Trước</span></li>
                                    </c:otherwise>
                                </c:choose>

                                <c:set var="startPage" value="${(currentPage - 2) > 1 ? (currentPage - 2) : 1}"/>
                                <c:set var="endPage" value="${(currentPage + 2) < totalPages ? (currentPage + 2) : totalPages}"/>

                                <c:if test="${startPage > 1}">
                                    <c:url var="page1Url" value="cancel-report">
                                        <c:param name="page" value="1"/>
                                        <c:param name="pageSize" value="${pageSize}"/>
                                        <c:param name="startDate" value="${startDate}"/>
                                        <c:param name="endDate" value="${endDate}"/>
                                    </c:url>
                                    <li><a href="${page1Url}">1</a></li>
                                    <c:if test="${startPage > 2}"><li><span>...</span></li></c:if>
                                </c:if>

                                <c:forEach begin="${startPage}" end="${endPage}" var="i">
                                    <c:url var="pageUrl" value="cancel-report">
                                        <c:param name="page" value="${i}"/>
                                        <c:param name="pageSize" value="${pageSize}"/>
                                        <c:param name="startDate" value="${startDate}"/>
                                        <c:param name="endDate" value="${endDate}"/>
                                    </c:url>
                                    <c:choose>
                                        <c:when test="${i == currentPage}">
                                            <li class="active"><span><c:out value="${i}"/></span></li>
                                        </c:when>
                                        <c:otherwise>
                                            <li><a href="${pageUrl}"><c:out value="${i}"/></a></li>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>

                                <c:if test="${endPage < totalPages}">
                                    <c:if test="${endPage < totalPages - 1}"><li><span>...</span></li></c:if>
                                    <c:url var="lastPageUrl" value="cancel-report">
                                        <c:param name="page" value="${totalPages}"/>
                                        <c:param name="pageSize" value="${pageSize}"/>
                                        <c:param name="startDate" value="${startDate}"/>
                                        <c:param name="endDate" value="${endDate}"/>
                                    </c:url>
                                    <li><a href="${lastPageUrl}"><c:out value="${totalPages}"/></a></li>
                                </c:if>

                                <c:url var="nextUrl" value="cancel-report">
                                    <c:param name="page" value="${currentPage + 1}"/>
                                    <c:param name="pageSize" value="${pageSize}"/>
                                    <c:param name="startDate" value="${startDate}"/>
                                    <c:param name="endDate" value="${endDate}"/>
                                </c:url>
                                <c:choose>
                                    <c:when test="${currentPage < totalPages}">
                                        <li><a href="${nextUrl}">Tiếp <i class="fas fa-chevron-right"></i></a></li>
                                    </c:when>
                                    <c:otherwise>
                                        <li class="disabled"><span>Tiếp <i class="fas fa-chevron-right"></i></span></li>
                                    </c:otherwise>
                                </c:choose>
                            </ul>
                        </div>
                    </c:if>

                </c:when>

                <%-- [SỬA] Thay thế hộp cảnh báo màu đỏ bằng hộp màu vàng --%>
                <c:otherwise>
                    <c:if test="${empty requestScope.startDateParam}">
                        <%-- Khối này đã được SỬA --%>
                        <div class="warning-box-yellow">Vui lòng chọn cả ngày bắt đầu và ngày kết thúc để xem báo cáo chi tiết.</div>
                    </c:if>
                    <c:if test="${not empty requestScope.startDateParam and empty requestScope.cancellationData}">
                        <p>Không có đặt bàn nào bị hủy hoặc đánh dấu là không đến trong khoảng thời gian đã chọn.</p>
                    </c:if>
                </c:otherwise>
            </c:choose>

            <hr/>
        </div>
    </div>
</div>

<div id="filterModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3>Bộ Lọc Báo Cáo (Ngày)</h3>
            <span class="close" onclick="closeFilterModal()">&times;</span>
        </div>
        <form id="modalForm" class="modal-form">
            <div class="filter-item">
                <label for="modalStartDate">Từ Ngày</label>
                <input type="date" id="modalStartDate" name="startDate" value="${requestScope.startDateParam}">
            </div>
            <div class="filter-item">
                <label for="modalEndDate">Đến Ngày</label>
                <input type="date" id="modalEndDate" name="endDate" value="${requestScope.endDateParam}">
            </div>

            <button type="button" class="btn-apply" onclick="submitFilterForm()"><i class="fas fa-check"></i> Áp Dụng
                Bộ Lọc
            </button>
        </form>
    </div>
</div>

<div id="missingDateAlert">
    <span id="missingDateAlertText"></span>
</div>

<script>
    const START_OF_BUSINESS_DATE = "2025-01-01";
    const CURRENT_DATE = new Date().toISOString().split('T')[0];

    const TARGET_PAGE_SIZE = "${pageSize}";

    // [THÊM] Lấy thẻ HTML của thanh thông báo lỗi
    const missingDateAlert = document.getElementById('missingDateAlert');
    const missingDateAlertText = document.getElementById('missingDateAlertText');

    // [THÊM] Hàm showAlert (giống hệt user-report)
    function showAlert(message) {
        missingDateAlertText.textContent = message;
        missingDateAlert.style.display = 'block';
        setTimeout(() => { missingDateAlert.style.opacity = '1'; }, 10);
        setTimeout(() => {
            missingDateAlert.style.opacity = '0';
            setTimeout(() => {
                missingDateAlert.style.display = 'none';
                missingDateAlertText.textContent = '';
            }, 300);
        }, 5000); // Tự động đóng sau 5s
    }

    function openFilterModal() {
        const modalStartDateInput = document.getElementById('modalStartDate');
        const modalEndDateInput = document.getElementById('modalEndDate');


        modalStartDateInput.min = START_OF_BUSINESS_DATE;
        modalStartDateInput.max = CURRENT_DATE;
        modalEndDateInput.max = CURRENT_DATE;

        if (modalStartDateInput.value && modalStartDateInput.value < START_OF_BUSINESS_DATE) {
            modalStartDateInput.value = START_OF_BUSINESS_DATE;
        }

        if (modalEndDateInput.value > CURRENT_DATE) {
            modalEndDateInput.value = CURRENT_DATE;
        }

        document.getElementById('filterModal').style.display = 'block';
    }

    function closeFilterModal() {
        document.getElementById('filterModal').style.display = 'none';
    }

    // [SỬA] Cập nhật hàm submitFilterForm
    function submitFilterForm() {
        const startDate = document.getElementById('modalStartDate').value;
        const endDate = document.getElementById('modalEndDate').value;

        // --- [SỬA] Sử dụng showAlert thay vì alert() ---
        if (!startDate) {
            showAlert("Lỗi: Vui lòng chọn Ngày Bắt đầu (Từ Ngày) cho báo cáo.");
            return;
        }
        if (!endDate) {
            showAlert("Lỗi: Vui lòng chọn Ngày Kết thúc (Đến Ngày) cho báo cáo.");
            return;
        }

        if (new Date(startDate) > new Date(endDate)) {
            showAlert("Lỗi: Ngày Bắt đầu không được lớn hơn Ngày Kết thúc. Vui lòng kiểm tra lại.");
            return;
        }

        if (startDate > CURRENT_DATE || endDate > CURRENT_DATE) {
            showAlert("Lỗi: Vui lòng không chọn Ngày Bắt đầu hoặc Ngày Kết thúc là ngày trong tương lai.");
            return;
        }

        // [SỬA] Sử dụng form ẩn
        const formStartDate = document.getElementById('formStartDate');
        const formEndDate = document.getElementById('formEndDate');

        if (formStartDate && formEndDate) {
            formStartDate.value = startDate;
            formEndDate.value = endDate;

            document.getElementById('filterForm').submit();
            closeFilterModal();
        } else {
            showAlert("Lỗi DOM: Không tìm thấy form ẩn 'filterForm'.");
        }
    }

    window.onclick = function (event) {
        const filterModal = document.getElementById('filterModal');
        if (event.target == filterModal) {
            closeFilterModal();
        }
    }
</script>
</body>
</html>