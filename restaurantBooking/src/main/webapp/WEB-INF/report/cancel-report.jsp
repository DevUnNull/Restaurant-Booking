<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cancelled Bookings Report</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

    <style>
        :root {
            --main-color: #D32F2F;
            --light-red: #FFCDD2;
            --dark-red: #B71C1C;
            --menu-bg: #8B0000;
            --menu-hover: #A52A2A;
            --text-light: #f8f8f8;
            --sidebar-width: 250px;
            --top-nav-height: 60px;
            --cancellation-color: #E91E63;
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

        .top-nav .restaurant-name {
            font-size: 1.2em;
            font-weight: bold;
            color: white;
            white-space: nowrap;
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
            max-width: 1200px;
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

        /* ----- CANCELLATION TABLE STYLES (ĐÃ SỬA) ----- */
        .cancellation-table {
            width: 100%;
            border-collapse: collapse; /* Sử dụng collapse để có đường kẻ rõ ràng */
            margin-top: 20px;
            border: 1px solid #ddd; /* Đường kẻ ngoài */
        }

        .cancellation-table th, .cancellation-table td {
            padding: 12px;
            border: 1px solid #ddd; /* Đường kẻ cho từng ô */
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
            background-color: #E91E63;
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

        /* PHẦN PHÂN TRANG (PAGINATION) */
        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            margin-top: 20px;
            gap: 8px;
        }

        .pagination a, .pagination span {
            color: var(--main-color);
            padding: 8px 16px;
            text-decoration: none;
            border: 1px solid #ddd;
            border-radius: 4px;
            transition: background-color 0.3s, color 0.3s;
        }

        .pagination a:hover:not(.active) {
            background-color: #f1f1f1;
        }

        .pagination .active {
            background-color: var(--main-color);
            color: white;
            border: 1px solid var(--main-color);
            font-weight: bold;
        }

        .pagination .disabled {
            color: #ccc;
            pointer-events: none;
            cursor: default;
            background-color: #f9f9f9;
        }

        .pagination-info {
            font-size: 0.9em;
            color: #555;
            margin-top: 10px;
            text-align: center;
        }

        .modal-form .btn-apply {
            margin-top: 20px;
            width: 100%;
        }
    </style>
</head>
<body>

<div class="top-nav">
    <div class="restaurant-group">
        <a href="<%= request.getContextPath() %>/" class="home-button">
            <i class="fas fa-home"></i> Home
        </a>
        <span class="restaurant-name">Restaurant Booking</span>
    </div>
    <div class="user-info">
        <span>User:
            <c:choose>
                <c:when test="${not empty sessionScope.userName}">
                    ${sessionScope.userName}
                </c:when>
                <c:otherwise>
                    Guest
                </c:otherwise>
            </c:choose>
        </span>
    </div>
</div>

<div class="wrapper">
    <div class="sidebar">
        <ul>
            <li><a href="<%= request.getContextPath() %>/overview-report" ${request.getRequestURI().contains("overview-report") ? "class=\"active\"" : ""}>Overview Report</a></li>
            <li><a href="<%= request.getContextPath() %>/service-report" ${request.getRequestURI().contains("service-report") ? "class=\"active\"" : ""}>Service Report</a></li>
            <li><a href="<%= request.getContextPath() %>/staff-report" ${request.getRequestURI().contains("staff-report") ? "class=\"active\"" : ""}>Staff Report</a></li>
            <li><a href="<%= request.getContextPath() %>/user-report" ${request.getRequestURI().contains("customer-report") ? "class=\"active\"" : ""}>Customer Report</a></li>
            <li><a href="<%= request.getContextPath() %>/cancel-report" ${request.getRequestURI().contains("cancellation-report") ? "class=\"active\"" : ""}>Cancellation Report</a></li>
        </ul>
    </div>

    <div class="main-content-body">
        <div class="content-container">
            <h1>Detailed Cancellation & No-Show Report</h1>

            <div class="filter-section">
                <h3 style="color: #555; margin-top: 0; margin-bottom: 15px;">Report Filters</h3>
                <button type="button" class="btn-apply" onclick="openFilterModal()"><i class="fas fa-calendar"></i> Filter
                    by Date
                </button>
            </div>

            <c:if test="${not empty requestScope.warningMessage}">
                <div id="alertWarning"
                     style="background-color: #fff3cd; color: #856404; padding: 15px; margin-bottom: 20px; border: 1px solid #ffeeba; border-radius: 4px;">
                    <i class="fas fa-exclamation-triangle"></i>
                    <strong>Warning:</strong> ${requestScope.warningMessage}
                </div>
            </c:if>

            <c:if test="${not empty requestScope.errorMessage}">
                <div id="alertError"
                     style="background-color: #f8d7da; color: #721c24; padding: 15px; margin-bottom: 20px; border: 1px solid #f5c6cb; border-radius: 4px;">
                    <i class="fas fa-times-circle"></i>
                    <strong>System Error:</strong> ${requestScope.errorMessage}
                </div>
            </c:if>


            <c:choose>
                <c:when test="${not empty requestScope.cancellationData}">
                    <table class="cancellation-table">
                        <thead>
                        <tr>
                            <th>Booking ID</th>
                            <th>Customer Name</th>
                            <th>Customer Email</th>
                            <th>Booking Date/Time</th>
                            <th class="text-center">Guests</th>
                            <th class="text-center">Status</th>
                            <th>Cancellation Reason</th>
                            <th class="text-center">Lead Time (Days)</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="item" items="${requestScope.cancellationData}">
                            <tr>
                                <td><c:out value="${item.reservationId}"/></td>
                                <td><c:out value="${item.customerName}"/></td>
                                <td><c:out value="${item.customerEmail}"/></td>
                                <td><c:out value="${item.reservationDate}"/> at <c:out value="${item.reservationTime}"/></td>
                                <td class="text-center"><c:out value="${item.numberOfGuests}"/></td>
                                <td class="text-center">
                                    <c:choose>
                                        <c:when test="${item.reservationStatus == 'CANCELLED'}">
                                            <span class="status-cancelled">Cancelled</span>
                                        </c:when>
                                        <c:when test="${item.reservationStatus == 'NO_SHOW'}">
                                            <span class="status-no-show">No Show</span>
                                        </c:when>
                                        <c:otherwise>
                                            <c:out value="${item.reservationStatus}"/>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="reason-cell">
                                    <div class="tooltip">
                                        <c:set var="reasonText" value="${item.cancellationReason != null ? item.cancellationReason : 'Not provided'}"/>
                                        <c:out value="${reasonText.length() > 50 ? reasonText.substring(0, 50).concat('...') : reasonText}"/>
                                        <c:if test="${item.cancellationReason != null}">
                                            <span class="tooltiptext"><c:out value="${item.cancellationReason}"/></span>
                                        </c:if>
                                    </div>
                                </td>
                                <td class="text-center"><c:out value="${item.leadTimeDays}"/></td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>

                    <%-- PHẦN HIỂN THỊ PHÂN TRANG --%>
                    <c:set var="currentPage" value="${requestScope.currentPage}"/>
                    <c:set var="totalPages" value="${requestScope.totalPages}"/>
                    <c:set var="totalRecords" value="${requestScope.totalRecords}"/>
                    <c:set var="pageSize" value="${requestScope.pageSize}"/>
                    <c:set var="startDate" value="${requestScope.startDateParam}"/>
                    <c:set var="endDate" value="${requestScope.endDateParam}"/>

                    <c:if test="${totalRecords > 0}">
                        <div class="pagination">
                                <%-- Nút Previous --%>
                            <c:url var="prevUrl" value="cancel-report">
                                <c:param name="page" value="${currentPage - 1}"/>
                                <c:param name="pageSize" value="${pageSize}"/>
                                <c:param name="startDate" value="${startDate}"/>
                                <c:param name="endDate" value="${endDate}"/>
                            </c:url>
                            <a href="${currentPage > 1 ? prevUrl : '#'}" class="${currentPage <= 1 ? 'disabled' : ''}"><i class="fas fa-chevron-left"></i> Previous</a>

                                <%-- Hiển thị các số trang --%>
                                <%-- Hiển thị tối đa 5 trang gần trang hiện tại để tránh hiển thị quá nhiều --%>
                            <c:set var="startPage" value="${(currentPage - 2) > 1 ? (currentPage - 2) : 1}"/>
                            <c:set var="endPage" value="${(currentPage + 2) < totalPages ? (currentPage + 2) : totalPages}"/>

                            <c:if test="${startPage > 1}">
                                <c:url var="page1Url" value="cancel-report">
                                    <c:param name="page" value="1"/>
                                    <c:param name="pageSize" value="${pageSize}"/>
                                    <c:param name="startDate" value="${startDate}"/>
                                    <c:param name="endDate" value="${endDate}"/>
                                </c:url>
                                <a href="${page1Url}">1</a>
                                <c:if test="${startPage > 2}">
                                    <span>...</span>
                                </c:if>
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
                                        <span class="active"><c:out value="${i}"/></span>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageUrl}"><c:out value="${i}"/></a>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>

                            <c:if test="${endPage < totalPages}">
                                <c:if test="${endPage < totalPages - 1}">
                                    <span>...</span>
                                </c:if>
                                <c:url var="lastPageUrl" value="cancel-report">
                                    <c:param name="page" value="${totalPages}"/>
                                    <c:param name="pageSize" value="${pageSize}"/>
                                    <c:param name="startDate" value="${startDate}"/>
                                    <c:param name="endDate" value="${endDate}"/>
                                </c:url>
                                <a href="${lastPageUrl}"><c:out value="${totalPages}"/></a>
                            </c:if>

                                <%-- Nút Next --%>
                            <c:url var="nextUrl" value="cancel-report">
                                <c:param name="page" value="${currentPage + 1}"/>
                                <c:param name="pageSize" value="${pageSize}"/>
                                <c:param name="startDate" value="${startDate}"/>
                                <c:param name="endDate" value="${endDate}"/>
                            </c:url>
                            <a href="${currentPage < totalPages ? nextUrl : '#'}" class="${currentPage >= totalPages ? 'disabled' : ''}">Next <i class="fas fa-chevron-right"></i></a>
                        </div>
                    </c:if>

                </c:when>
                <c:otherwise>
                    <p>No bookings were cancelled or marked as no-show during the selected time period.</p>
                </c:otherwise>
            </c:choose>

            <hr/>
        </div>
    </div>
</div>

<div id="filterModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3>Report Filters (Date)</h3>
            <span class="close" onclick="closeFilterModal()">&times;</span>
        </div>
        <form id="modalForm" class="modal-form">
            <div class="filter-item">
                <label for="modalStartDate">From Date</label>
                <input type="date" id="modalStartDate" name="startDate" value="${requestScope.startDateParam}">
            </div>
            <div class="filter-item">
                <label for="modalEndDate">To Date</label>
                <input type="date" id="modalEndDate" name="endDate" value="${requestScope.endDateParam}">
            </div>

            <button type="button" class="btn-apply" onclick="submitFilterForm()"><i class="fas fa-check"></i> Apply
                Filters
            </button>
        </form>
    </div>
</div>
<script>
    const START_OF_BUSINESS_DATE = "2025-01-01";
    const CURRENT_DATE = new Date().toISOString().split('T')[0];

    // Lấy pageSize hiện tại từ requestScope để duy trì khi lọc
    const CURRENT_PAGE_SIZE = ${requestScope.pageSize};

    function openFilterModal() {
        const modalStartDateInput = document.getElementById('modalStartDate');
        const modalEndDateInput = document.getElementById('modalEndDate');


        modalStartDateInput.min = START_OF_BUSINESS_DATE;
        modalStartDateInput.max = CURRENT_DATE;
        modalEndDateInput.max = CURRENT_DATE;

        if (modalStartDateInput.value && modalStartDateInput.value < START_OF_BUSINESS_DATE) {
            modalStartDateInput.value = START_OF_BUSINESS_DATE;
        }

        if (modalEndDateInput.value === '' || modalEndDateInput.value > CURRENT_DATE) {
            modalEndDateInput.value = CURRENT_DATE;
        }

        document.getElementById('filterModal').style.display = 'block';
    }

    function closeFilterModal() {
        document.getElementById('filterModal').style.display = 'none';
    }

    function submitFilterForm() {
        const startDate = document.getElementById('modalStartDate').value;
        const endDate = document.getElementById('modalEndDate').value;

        // --- Bổ sung xác thực phía Client ---
        if (!startDate) {
            alert("Lỗi: Vui lòng chọn Ngày Bắt đầu (From Date) cho báo cáo.");
            return; // Ngăn không cho form gửi đi
        }
        if (!endDate) {
            alert("Lỗi: Vui lòng chọn Ngày Kết thúc (To Date) cho báo cáo.");
            return; // Ngăn không cho form gửi đi
        }

        if (new Date(startDate) > new Date(endDate)) {
            alert("Lỗi: Ngày Bắt đầu không được lớn hơn Ngày Kết thúc. Vui lòng kiểm tra lại.");
            return;
        }

        if (startDate > CURRENT_DATE || endDate > CURRENT_DATE) {
            alert("Lỗi: Vui lòng không chọn Ngày Bắt đầu hoặc Ngày Kết thúc là ngày trong tương lai.");
            // Giữ logic tiếp theo, nhưng thông báo đã cảnh báo người dùng.
        }
        // --- Kết thúc xác thực ---

        // Luôn reset về trang 1 khi thay đổi bộ lọc ngày, và giữ nguyên pageSize
        let url = 'cancel-report?startDate=' + startDate + '&endDate=' + endDate + '&page=1' + '&pageSize=' + CURRENT_PAGE_SIZE;

        window.location.href = url;
        closeFilterModal();
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