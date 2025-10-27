<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Report</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

    <style>
        :root {
            --main-color: #D32F2F; --light-red: #FFCDD2; --dark-red: #B71C1C;
            --menu-bg: #8B0000; --menu-hover: #A52A2A; --text-light: #f8f8f8;
            --sidebar-width: 250px; --top-nav-height: 60px;

            --revenue-color: #4CAF50;
            --cancellation-color: #E91E63;
            --customer-color: #1976D2;
        }

        /* Base & Layout */
        body { font-family: Arial, sans-serif; padding: 0; margin: 0; background-color: #f4f4f4; padding-top: var(--top-nav-height); overflow-x: hidden; }
        .wrapper { display: flex; min-height: calc(100vh - var(--top-nav-height)); position: relative; }
        .top-nav { position: fixed; top: 0; left: 0; right: 0; height: var(--top-nav-height); background-color: var(--main-color); color: var(--text-light); display: flex; align-items: center; justify-content: space-between; padding: 0 15px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); z-index: 1000; }
        .top-nav .restaurant-group { display: flex; align-items: center; gap: 15px; flex-shrink: 0; }
        .top-nav .restaurant-name { font-size: 1.2em; font-weight: bold; color: white; white-space: nowrap; }
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

        /* Customer Table Styles */
        .customer-table { width: 100%; border-collapse: separate; border-spacing: 0; margin-top: 20px; }
        .customer-table th, .customer-table td { padding: 12px; border-bottom: 1px solid #eee; }
        .customer-table th { background-color: #f8f8f8; color: var(--customer-color); font-weight: bold; text-transform: uppercase; }
        .customer-table tr:hover { background-color: #e3f2fd; }
        .status-active { color: var(--revenue-color); font-weight: bold; }
        .status-inactive { color: var(--cancellation-color); font-weight: bold; }
        .text-center { text-align: center; }
        .text-right { text-align: right; }

        /* Modal Styles */
        .modal { display: none; position: fixed; z-index: 1001; left: 0; top: 0; width: 100%; height: 100%; overflow: auto; background-color: rgba(0,0,0,0.4); padding-top: 60px; }
        .modal-content { background-color: #fefefe; margin: 5% auto; padding: 20px; border: 1px solid #888; width: 90%; max-width: 400px; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.2); }
        .modal-header { display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #eee; padding-bottom: 10px; margin-bottom: 15px; }
        .close { color: #aaa; font-size: 28px; font-weight: bold; cursor: pointer; }
        .close:hover { color: #000; }
        .filter-grid { display: flex; gap: 15px; align-items: flex-end; }


        .pagination-container {
            display: flex;
            justify-content: center;
            align-items: center;
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
        .pagination li.disabled span {
            color: #ccc;
            background-color: #fff;
        }


    </style>
</head>
<body>

<%-- Top Nav --%>
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

<%-- Wrapper (Sidebar + Main Content) --%>
<div class="wrapper">
    <div class="sidebar">
        <ul>
            <li><a href="<%= request.getContextPath() %>/overview-report" ${request.getRequestURI().contains("overview-report") ? "class=\"active\"" : ""}>Overview Report</a></li>
            <li><a href="<%= request.getContextPath() %>/service-report" ${request.getRequestURI().contains("service-report") ? "class=\"active\"" : ""}>Service Report</a></li>
            <li><a href="<%= request.getContextPath() %>/staff-report" ${request.getRequestURI().contains("staff-report") ? "class=\"active\"" : ""}>Staff Report</a></li>
            <li><a href="<%= request.getContextPath() %>/user-report" ${request.getRequestURI().contains("user-report") ? "class=\"active\"" : ""}>Customer Report</a></li>
            <li><a href="<%= request.getContextPath() %>/cancel-report" ${request.getRequestURI().contains("cancel-report") ? "class=\"active\"" : ""}>Cancellation Report</a></li>
        </ul>
    </div>

    <div class="main-content-body">
        <div class="content-container">
            <h1>Customer Overview Report</h1>

            <%-- Filter Section --%>
            <div class="filter-section">
                <h3 style="color: #555; margin-top: 0; margin-bottom: 15px;">Report Filters</h3>
                <button type="button" class="btn-apply" onclick="openFilterModal()"><i class="fas fa-calendar"></i> Filter by Date</button>
            </div>

            <%-- Warning Message --%>
            <c:if test="${not empty requestScope.warningMessage}">
                <div id="alertWarning" style="background-color: #fff3cd; color: #856404; padding: 15px; margin-bottom: 20px; border: 1px solid #ffeeba; border-radius: 4px;">
                    <i class="fas fa-exclamation-triangle"></i>
                    <strong>Warning:</strong> ${requestScope.warningMessage}
                </div>
            </c:if>

            <%-- Error Message --%>
            <c:if test="${not empty requestScope.errorMessage}">
                <div id="alertError" style="background-color: #f8d7da; color: #721c24; padding: 15px; margin-bottom: 20px; border: 1px solid #f5c6cb; border-radius: 4px;">
                    <i class="fas fa-times-circle"></i>
                    <strong>System Error:</strong> ${requestScope.errorMessage}
                </div>
            </c:if>

            <%-- Main Report Content (Only show if no error) --%>
            <c:if test="${empty requestScope.errorMessage}">

                <h2>Customer Summary (${requestScope.startDateParam} to ${requestScope.endDateParam})</h2>

                <%-- Summary Cards (Dữ liệu từ Controller) --%>
                <div class="summary-container">
                    <div class="summary-card customer">
                        <div class="icon"><i class="fas fa-user-plus"></i></div>
                        <div class="info">
                            <div class="value">${requestScope.newCustomerCount}</div>
                            <div class="label">New Customers (in period)</div>
                        </div>
                    </div>

                    <div class="summary-card total">
                        <div class="icon"><i class="fas fa-users"></i></div>
                        <div class="info">
                            <div class="value">${requestScope.totalCustomerCount}</div>
                            <div class="label">Total Active Customers</div>
                        </div>
                    </div>

                    <div class="summary-card revenue">
                        <div class="icon"><i class="fas fa-dollar-sign"></i></div>
                        <div class="info">
                            <div class="value">
                                <fmt:formatNumber value="${requestScope.grandTotalSpending}" type="number" minFractionDigits="0" />
                            </div>
                            <div class="label">Total Spending (in period)</div>
                        </div>
                    </div>
                </div>
                <hr/>

                <h2>Customer Details List (Page ${requestScope.currentPage} of ${requestScope.totalPages})</h2>

                <%-- Customer Table --%>
                <c:choose>
                    <c:when test="${not empty requestScope.customerData}">

                        <jsp:useBean id="today" class="java.util.Date" scope="page" />
                        <fmt:formatDate value="${today}" pattern="yyyy" var="currentYear" />

                        <table class="customer-table">
                            <thead>
                            <tr>
                                <th>ID</th>
                                <th>Customer Name</th>
                                <th>Email</th>
                                <th>Phone</th>
                                <th class="text-center">Gender</th>
                                <th class="text-center">Age</th>
                                <th class="text-center">Status</th>
                                <th class="text-center">Total Bookings (Completed)</th>
                                <th class="text-right">Total Spending (Completed)</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="customer" items="${requestScope.customerData}">
                                <tr>
                                    <td>${customer.customerId}</td>
                                    <td>${customer.customerName}</td>
                                    <td>${customer.email}</td>
                                    <td>${customer.phoneNumber}</td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${not empty customer.gender}">${customer.gender}</c:when>
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
                                                ${customer.customerStatus}
                                        </span>
                                    </td>
                                    <td class="text-center">${customer.totalReservations}</td>
                                    <td class="text-right">
                                        <fmt:formatNumber value="${customer.totalSpending}" type="number" pattern="#,###"/> VND
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </c:when>
                    <c:otherwise>
                        <p>No customer data or completed bookings found for the selected time period.</p>
                    </c:otherwise>
                </c:choose>

                <%-- === KHỐI PHÂN TRANG === --%>
                <c:if test="${requestScope.totalPages > 1}">
                    <div class="pagination-container">
                        <ul class="pagination">


                            <c:choose>
                                <c:when test="${requestScope.currentPage > 1}">
                                    <li>
                                        <a href="user-report?startDate=${requestScope.startDateParam}&endDate=${requestScope.endDateParam}&page=${requestScope.currentPage - 1}">
                                            Prev
                                        </a>
                                    </li>
                                </c:when>
                                <c:otherwise>
                                    <li class="disabled">
                                        <span>Prev</span>
                                    </li>
                                </c:otherwise>
                            </c:choose>


                            <c:forEach var="i" begin="1" end="${requestScope.totalPages}">
                                <c:choose>
                                    <c:when test="${requestScope.currentPage == i}">
                                        <li class="active">
                                            <span>${i}</span>
                                        </li>
                                    </c:when>
                                    <c:otherwise>
                                        <li>
                                            <a href="user-report?startDate=${requestScope.startDateParam}&endDate=${requestScope.endDateParam}&page=${i}">${i}</a>
                                        </li>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>


                            <c:choose>
                                <c:when test="${requestScope.currentPage < requestScope.totalPages}">
                                    <li>
                                        <a href="user-report?startDate=${requestScope.startDateParam}&endDate=${requestScope.endDateParam}&page=${requestScope.currentPage + 1}">
                                            Next
                                        </a>
                                    </li>
                                </c:when>
                                <c:otherwise>
                                    <li class="disabled">
                                        <span>Next</span>
                                    </li>
                                </c:otherwise>
                            </c:choose>

                        </ul>
                    </div>
                </c:if>

                <hr/>

            </c:if>
        </div>
    </div>
</div>

<%-- Filter Modal --%>
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
            <button type="button" class="btn-apply" onclick="submitFilterForm()"><i class="fas fa-check"></i> Apply Filter</button>
        </form>
    </div>
</div>

<%-- JavaScript --%>
<script>
    const START_OF_BUSINESS_DATE = "2025-01-01";

    // --- FUNCTIONS FOR DATE FILTER MODAL ---
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

    function submitFilterForm() {
        const startDate = document.getElementById('modalStartDate').value;
        const endDate = document.getElementById('modalEndDate').value;
        let url = 'user-report?startDate=' + startDate + '&endDate=' + endDate;

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