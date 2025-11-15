<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý đơn hàng - Restaurant Booking</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/theme.css">

    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Montserrat', sans-serif;
            background: #ffffff;
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            background: #ffffff;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
            padding: 40px;
        }

        .header {
            margin-bottom: 40px;
            border-bottom: 3px solid #dc3545;
            padding-bottom: 20px;
        }

        .header h1 {
            color: #000000;
            font-size: 2.5em;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .header h1 i {
            color: #dc3545;
        }

        .header p {
            color: #000000;
            margin-top: 10px;
            font-size: 1.1em;
        }

        /* Filter Section */
        .filter-section {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 30px;
            box-shadow: 0 10px 30px rgba(220, 53, 69, 0.3);
        }

        .filter-controls {
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
            align-items: flex-end;
        }

        .filter-group {
            flex: 1;
            min-width: 200px;
        }

        .filter-group label {
            display: block;
            color: white;
            font-weight: 600;
            margin-bottom: 8px;
            font-size: 0.95em;
        }

        .filter-group select,
        .filter-group input {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid rgba(255, 255, 255, 0.3);
            border-radius: 10px;
            background: rgba(255, 255, 255, 0.95);
            font-size: 1em;
            transition: all 0.3s;
            font-family: 'Montserrat', sans-serif;
        }

        .filter-group select:focus,
        .filter-group input:focus {
            outline: none;
            border-color: white;
            background: white;
            box-shadow: 0 0 0 3px rgba(255, 255, 255, 0.2);
        }

        .filter-buttons {
            display: flex;
            gap: 10px;
        }

        .btn-filter,
        .btn-reset {
            padding: 12px 25px;
            border: none;
            border-radius: 10px;
            font-weight: 600;
            font-size: 1em;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 8px;
            font-family: 'Montserrat', sans-serif;
        }

        .btn-filter {
            background: white;
            color: #dc3545;
        }

        .btn-filter:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }

        .btn-reset {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            border: 2px solid white;
        }

        .btn-reset:hover {
            background: white;
            color: #dc3545;
        }

        /* Statistics Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            padding: 25px;
            border-radius: 15px;
            color: white;
            box-shadow: 0 10px 30px rgba(220, 53, 69, 0.3);
        }

        .stat-card h3 {
            font-size: 0.9em;
            font-weight: 500;
            opacity: 0.9;
            margin-bottom: 10px;
        }

        .stat-card .stat-value {
            font-size: 2.5em;
            font-weight: 700;
        }

        /* Orders Table */
        .orders-table-wrapper {
            overflow-x: auto;
            margin-bottom: 30px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }

        .orders-table {
            width: 100%;
            border-collapse: collapse;
            background: white;
        }

        .orders-table thead {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            color: white;
        }

        .orders-table th {
            padding: 18px 15px;
            text-align: left;
            font-weight: 600;
            font-size: 0.95em;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .orders-table tbody tr {
            border-bottom: 1px solid #e2e8f0;
            transition: all 0.3s;
        }

        .orders-table tbody tr:hover {
            background: #f7fafc;
            transform: scale(1.01);
        }

        .orders-table td {
            padding: 15px;
            color: #000000;
        }

        .order-id {
            font-weight: 700;
            color: #dc3545;
            font-size: 1.1em;
        }

        .customer-info {
            display: flex;
            flex-direction: column;
            gap: 3px;
        }

        .customer-name {
            font-weight: 600;
            color: #000000;
        }

        .customer-contact {
            font-size: 0.85em;
            color: #000000;
        }

        .table-names {
            display: flex;
            flex-wrap: wrap;
            gap: 5px;
        }

        .table-badge {
            background: #e6f3ff;
            color: #0066cc;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 0.85em;
            font-weight: 600;
        }

        .amount {
            font-weight: 700;
            color: #38a169;
            font-size: 1.1em;
        }

        /* Status Badge */
        .status-badge {
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 0.85em;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .status-badge i {
            font-size: 0.9em;
        }

        .status-PENDING {
            background: #fff3cd;
            color: #856404;
        }

        .status-CONFIRMED {
            background: #d1ecf1;
            color: #0c5460;
        }

        .status-COMPLETED {
            background: #d4edda;
            color: #155724;
        }

        .status-CANCELLED {
            background: #f8d7da;
            color: #721c24;
        }

        .status-NO_SHOW {
            background: #e2e3e5;
            color: #383d41;
        }

        /* Status Dropdown */
        .status-dropdown {
            position: relative;
            display: inline-block;
        }

        .status-dropdown select {
            appearance: none;
            padding: 8px 35px 8px 15px;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            background: white;
            font-weight: 600;
            font-size: 0.9em;
            cursor: pointer;
            transition: all 0.3s;
            font-family: 'Montserrat', sans-serif;
        }

        .status-dropdown select:hover {
            border-color: #dc3545;
        }

        .status-dropdown select:focus {
            outline: none;
            border-color: #dc3545;
            box-shadow: 0 0 0 3px rgba(220, 53, 69, 0.1);
        }

        .status-dropdown::after {
            content: '\f078';
            font-family: 'Font Awesome 6 Free';
            font-weight: 900;
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            pointer-events: none;
            color: #dc3545;
        }

        /* Payment Badges */
        .payment-badge {
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 0.85em;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 4px;
            white-space: nowrap;
        }

        .payment-cash {
            background: #fef3c7;
            color: #92400e;
        }

        .payment-card {
            background: #dbeafe;
            color: #1e40af;
        }

        .payment-wallet {
            background: #d1fae5;
            color: #065f46;
        }

        /* Payment Status Badges */
        .payment-status-badge {
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 0.85em;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 4px;
            white-space: nowrap;
        }

        .payment-pending {
            background: #fff3cd;
            color: #856404;
        }

        .payment-completed {
            background: #d4edda;
            color: #155724;
        }

        .payment-failed {
            background: #f8d7da;
            color: #721c24;
        }

        /* Actions Buttons */
        .actions {
            display: flex;
            gap: 8px;
        }

        .btn-action {
            padding: 8px 15px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 0.9em;
            font-weight: 600;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            text-decoration: none;
            font-family: 'Montserrat', sans-serif;
        }

        .btn-view {
            background: #dc3545;
            color: white;
        }

        .btn-view:hover {
            background: #c82333;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(220, 53, 69, 0.3);
        }

        .btn-edit {
            background: #48bb78;
            color: white;
        }

        .btn-edit:hover {
            background: #38a169;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(72, 187, 120, 0.3);
        }

        /* Pagination */
        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
            margin-top: 30px;
        }

        .pagination a,
        .pagination span {
            padding: 10px 16px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s;
        }

        .pagination a {
            background: white;
            color: #dc3545;
            border: 2px solid #dc3545;
        }

        .pagination a:hover {
            background: #dc3545;
            color: white;
            transform: translateY(-2px);
        }

        .pagination .current {
            background: #dc3545;
            color: white;
            border: 2px solid #dc3545;
        }

        .pagination .disabled {
            background: #e2e8f0;
            color: #a0aec0;
            border: 2px solid #e2e8f0;
            cursor: not-allowed;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
        }

        .empty-state i {
            font-size: 5em;
            color: #cbd5e0;
            margin-bottom: 20px;
        }

        .empty-state h3 {
            color: #000000;
            font-size: 1.5em;
            margin-bottom: 10px;
        }

        .empty-state p {
            color: #000000;
        }

        /* Loading Spinner */
        .loading {
            text-align: center;
            padding: 40px;
        }

        .spinner {
            border: 4px solid #f3f4f6;
            border-top: 4px solid #dc3545;
            border-radius: 50%;
            width: 50px;
            height: 50px;
            animation: spin 1s linear infinite;
            margin: 0 auto;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* Responsive */
        @media (max-width: 768px) {
            .container {
                padding: 20px;
            }

            .header h1 {
                font-size: 1.8em;
            }

            .filter-controls {
                flex-direction: column;
            }

            .filter-group {
                width: 100%;
            }

            .orders-table {
                font-size: 0.9em;
            }

            .orders-table th,
            .orders-table td {
                padding: 10px 8px;
            }
        }
    </style>
</head>
<body>
<!-- Include Header -->
<jsp:include page="../common/header.jsp" />

<div class="container">
    <!-- Header -->
    <div class="header">
        <div style="display: flex; justify-content: space-between; align-items: center;">
            <div>
                <h1>
                    <i class="fas fa-clipboard-list"></i>
                    Quản lý đơn hàng
                </h1>
                <p>Xem và quản lý tất cả các đơn đặt bàn của khách hàng</p>
            </div>
            <button onclick="openCreateOrderModal()" class="btn-create-order" style="padding: 12px 24px; background: #dc3545; color: white; border: none; border-radius: 10px; font-weight: 600; cursor: pointer; font-size: 1em; display: flex; align-items: center; gap: 8px;">
                <i class="fas fa-plus"></i> Tạo đơn hàng mới
            </button>
        </div>
    </div>

    <!-- Statistics Cards -->
    <div class="stats-grid">
        <div class="stat-card">
            <h3>Tổng đơn hàng</h3>
            <div class="stat-value">${totalOrders}</div>
        </div>
    </div>

    <!-- Filter Section -->
    <div class="filter-section">
        <form method="get" action="${pageContext.request.contextPath}/OrderManagement" id="filterForm">
            <div class="filter-controls">
                <div class="filter-group">
                    <label for="statusFilter">
                        <i class="fas fa-filter"></i> Lọc theo trạng thái
                    </label>
                    <select name="status" id="statusFilter">
                        <option value="ALL" ${statusFilter == 'ALL' ? 'selected' : ''}>Tất cả</option>
                        <option value="PENDING" ${statusFilter == 'PENDING' ? 'selected' : ''}>Chờ xác nhận</option>
                        <option value="CONFIRMED" ${statusFilter == 'CONFIRMED' ? 'selected' : ''}>Đã xác nhận</option>
                        <option value="COMPLETED" ${statusFilter == 'COMPLETED' ? 'selected' : ''}>Hoàn thành</option>
                        <option value="CANCELLED" ${statusFilter == 'CANCELLED' ? 'selected' : ''}>Đã hủy</option>
                        <option value="NO_SHOW" ${statusFilter == 'NO_SHOW' ? 'selected' : ''}>Không đến</option>
                    </select>
                </div>

                <div class="filter-group">
                    <label for="searchInput">
                        <i class="fas fa-search"></i> Tìm kiếm
                    </label>
                    <input type="text"
                           name="search"
                           id="searchInput"
                           placeholder="Tên khách hàng, SĐT, Email, Mã đơn..."
                           value="${searchQuery != null ? searchQuery : ''}">
                </div>

                <div class="filter-buttons">
                    <button type="submit" class="btn-filter">
                        <i class="fas fa-search"></i> Tìm kiếm
                    </button>
                    <button type="button" class="btn-reset" onclick="resetFilter()">
                        <i class="fas fa-redo"></i> Reset
                    </button>
                </div>
            </div>
        </form>
    </div>

    <!-- Orders Table -->
    <div class="orders-table-wrapper">
        <c:choose>
            <c:when test="${empty orders}">
                <div class="empty-state">
                    <i class="fas fa-inbox"></i>
                    <h3>Không tìm thấy đơn hàng</h3>
                    <p>Thử thay đổi bộ lọc hoặc tìm kiếm khác</p>
                </div>
            </c:when>
            <c:otherwise>
                <table class="orders-table">
                    <thead>
                    <tr>
                        <th>Mã đơn</th>
                        <th>Khách hàng</th>
                        <th>Ngày & Giờ</th>
                        <th>Bàn</th>
                        <th>Số khách</th>
                        <th>Số món</th>
                        <th>Tổng tiền</th>
                        <th>Thanh toán</th>
                        <th>Trạng thái</th>
                        <th>Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="order" items="${orders}">
                        <tr>
                            <td>
                                <span class="order-id">#${order.reservationId}</span>
                            </td>
                            <td>
                                <div class="customer-info">
                                    <span class="customer-name">${order.customerName}</span>
                                    <span class="customer-contact">
                                                <i class="fas fa-phone"></i> ${order.customerPhone}
                                            </span>
                                    <span class="customer-contact">
                                                <i class="fas fa-envelope"></i> ${order.customerEmail}
                                            </span>
                                </div>
                            </td>
                            <td>
                                <div>
                                    <i class="fas fa-calendar"></i>
                                        ${order.reservationDate}
                                </div>
                                <div style="margin-top: 5px;">
                                    <i class="fas fa-clock"></i>
                                        ${order.reservationTime}
                                </div>
                            </td>
                            <td>
                                <div class="table-names">
                                    <c:forEach var="tableName" items="${fn:split(order.tableNames, ', ')}">
                                        <span class="table-badge">${tableName}</span>
                                    </c:forEach>
                                </div>
                            </td>
                            <td>
                                <i class="fas fa-users"></i> ${order.guestCount}
                            </td>
                            <td>
                                <i class="fas fa-utensils"></i> ${order.itemCount}
                            </td>
                            <td>
                                        <span class="amount">
                                            <fmt:formatNumber value="${order.totalAmount}" pattern="#,###" /> VNĐ
                                        </span>
                            </td>
                            <td>
                                <div style="display: flex; flex-direction: column; gap: 8px; align-items: flex-start;">
                                    <!-- Payment Method Badge - Always show if payment method exists -->
                                    <c:if test="${not empty order.paymentMethod}">
                                        <c:choose>
                                            <c:when test="${order.paymentMethod == 'CASH'}">
                                                        <span class="payment-badge payment-cash">
                                                            <i class="fas fa-money-bill-wave"></i> Đến nơi trả tiền
                                                        </span>
                                            </c:when>
                                            <c:when test="${order.paymentMethod == 'CREDIT_CARD'}">
                                                        <span class="payment-badge payment-card">
                                                            <i class="fas fa-credit-card"></i> Thẻ
                                                        </span>
                                            </c:when>
                                            <c:when test="${order.paymentMethod == 'E_WALLET'}">
                                                        <span class="payment-badge payment-wallet">
                                                            <i class="fas fa-wallet"></i> Ví
                                                        </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="payment-badge">${order.paymentMethod}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:if>

                                    <!-- Payment Status Badge -->
                                    <c:if test="${not empty order.paymentStatus}">
                                        <c:choose>
                                            <c:when test="${order.paymentStatus == 'PENDING'}">
                                                        <span class="payment-status-badge payment-pending">
                                                            <i class="fas fa-clock"></i> Chờ
                                                        </span>
                                            </c:when>
                                            <c:when test="${order.paymentStatus == 'COMPLETED'}">
                                                        <span class="payment-status-badge payment-completed">
                                                            <i class="fas fa-check-circle"></i> Đã TT
                                                        </span>
                                            </c:when>
                                            <c:when test="${order.paymentStatus == 'FAILED'}">
                                                        <span class="payment-status-badge payment-failed">
                                                            <i class="fas fa-times-circle"></i> Thất bại
                                                        </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="payment-status-badge">${order.paymentStatus}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:if>

                                    <!-- Note for CASH payment with deposit -->
                                    <c:if test="${order.paymentMethod == 'CASH' and order.paymentStatus == 'COMPLETED'}">
                                        <div style="font-size: 0.85em; color: #ffc107; font-style: italic; margin-top: 4px;">
                                            <i class="fas fa-info-circle"></i> Đã trả tiền cọc - Đến nơi trả tiền
                                        </div>
                                    </c:if>
                                </div>
                            </td>
                            <td>
                                <div class="status-dropdown">
                                    <select onchange="updateStatus(${order.reservationId}, this.value);"
                                            data-original="${order.status}">
                                        <option value="PENDING" ${order.status == 'PENDING' ? 'selected' : ''}>Chờ xác nhận</option>
                                        <option value="CONFIRMED" ${order.status == 'CONFIRMED' ? 'selected' : ''}>Đã xác nhận</option>
                                        <option value="COMPLETED" ${order.status == 'COMPLETED' ? 'selected' : ''}>Hoàn thành</option>
                                        <option value="CANCELLED" ${order.status == 'CANCELLED' ? 'selected' : ''}>Đã hủy</option>
                                        <option value="NO_SHOW" ${order.status == 'NO_SHOW' ? 'selected' : ''}>Không đến</option>
                                    </select>
                                </div>
                            </td>
                            <td>
                                <div class="actions">
                                    <a href="${pageContext.request.contextPath}/staffOrderDetails?id=${order.reservationId}"
                                       class="btn-action btn-view"
                                       title="Xem chi tiết">
                                        <i class="fas fa-eye"></i> Xem
                                    </a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Pagination -->
    <c:if test="${totalPages > 1}">
        <div class="pagination">
            <c:choose>
                <c:when test="${currentPage > 1}">
                    <a href="?page=${currentPage - 1}&status=${statusFilter}&search=${searchQuery}">
                        <i class="fas fa-chevron-left"></i> Trước
                    </a>
                </c:when>
                <c:otherwise>
                        <span class="disabled">
                            <i class="fas fa-chevron-left"></i> Trước
                        </span>
                </c:otherwise>
            </c:choose>

            <c:forEach begin="1" end="${totalPages}" var="i">
                <c:choose>
                    <c:when test="${currentPage == i}">
                        <span class="current">${i}</span>
                    </c:when>
                    <c:otherwise>
                        <a href="?page=${i}&status=${statusFilter}&search=${searchQuery}">${i}</a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>

            <c:choose>
                <c:when test="${currentPage < totalPages}">
                    <a href="?page=${currentPage + 1}&status=${statusFilter}&search=${searchQuery}">
                        Sau <i class="fas fa-chevron-right"></i>
                    </a>
                </c:when>
                <c:otherwise>
                        <span class="disabled">
                            Sau <i class="fas fa-chevron-right"></i>
                        </span>
                </c:otherwise>
            </c:choose>
        </div>
    </c:if>
</div>

<script>
    // Reset filter
    function resetFilter() {
        window.location.href = '${pageContext.request.contextPath}/OrderManagement';
    }

    // Update order status
    function updateStatus(reservationId, newStatus) {
        const selectElement = event.target;
        const originalStatus = selectElement.getAttribute('data-original');

        if (!confirm('Bạn có chắc muốn thay đổi trạng thái đơn hàng này?')) {
            selectElement.value = originalStatus;
            return;
        }

        // Show loading
        selectElement.disabled = true;

        fetch('${pageContext.request.contextPath}/OrderManagement', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'action=updateStatus&reservationId=' + reservationId + '&status=' + newStatus
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('Cập nhật trạng thái thành công!');
                    selectElement.setAttribute('data-original', newStatus);
                    location.reload();
                } else {
                    alert('Lỗi: ' + data.message);
                    selectElement.value = originalStatus;
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Có lỗi xảy ra khi cập nhật trạng thái');
                selectElement.value = originalStatus;
            })
            .finally(() => {
                selectElement.disabled = false;
            });
    }

    // Auto-submit on filter change
    document.getElementById('statusFilter').addEventListener('change', function() {
        document.getElementById('filterForm').submit();
    });

    // Create Order Modal
    function openCreateOrderModal() {
        document.getElementById('createOrderModal').style.display = 'flex';
    }

    function closeCreateOrderModal() {
        document.getElementById('createOrderModal').style.display = 'none';
        document.getElementById('createOrderForm').reset();

        // Reset slot selection
        document.querySelectorAll('.slot-btn-create').forEach(btn => {
            btn.style.borderColor = '#e2e8f0';
            btn.style.background = 'transparent';
            btn.style.opacity = '1';
            btn.style.cursor = 'pointer';
        });
        document.getElementById('createOrderSlot').value = '';
        document.getElementById('createOrderTime').value = '';

        // Reset slot time displays
        document.getElementById('morningTimeCreate').textContent = '--:-- - --:--';
        document.getElementById('afternoonTimeCreate').textContent = '--:-- - --:--';
        document.getElementById('eveningTimeCreate').textContent = '--:-- - --:--';
    }

    // Handle form submission - Wait for DOM to be ready
    function initCreateOrderForm() {
        const createOrderForm = document.getElementById('createOrderForm');
        if (!createOrderForm) {
            console.error('createOrderForm not found! Retrying...');
            setTimeout(initCreateOrderForm, 100);
            return;
        }

        console.log('createOrderForm found, attaching event listener');

        createOrderForm.addEventListener('submit', function(e) {
            e.preventDefault();
            console.log('=== FORM SUBMIT START ===');

            // Get all form values
            const formDataObj = {
                action: 'createReservation',
                customerName: this.querySelector('[name="customerName"]').value,
                customerPhone: this.querySelector('[name="customerPhone"]').value,
                customerEmail: this.querySelector('[name="customerEmail"]').value || '',
                reservationDate: this.querySelector('[name="reservationDate"]').value,
                slot: document.getElementById('createOrderSlot').value,
                reservationTime: document.getElementById('createOrderTime').value,
                guestCount: this.querySelector('[name="guestCount"]').value,
                specialRequests: this.querySelector('[name="specialRequests"]').value || ''
            };

            // Get selected table IDs
            const selectedTables = Array.from(document.querySelectorAll('input[name="tableIds"]:checked'))
                .map(cb => cb.value);

            console.log('Selected tables:', selectedTables);

            if (selectedTables.length === 0) {
                alert('Vui lòng chọn ít nhất một bàn');
                return;
            }

            // Check slot is selected
            if (!formDataObj.slot || !formDataObj.reservationTime) {
                alert('Vui lòng chọn slot thời gian');
                return;
            }

            formDataObj.tableIds = selectedTables.join(',');

            // Debug: Log all form data
            console.log('Form data object:', formDataObj);

            // Convert to URLSearchParams (application/x-www-form-urlencoded)
            const formData = new URLSearchParams();
            for (const [key, value] of Object.entries(formDataObj)) {
                formData.append(key, value);
                console.log(key + ': ' + value);
            }

            // Show loading
            const submitBtn = this.querySelector('button[type="submit"]');
            const originalText = submitBtn.innerHTML;
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang tạo...';

            const url = '${pageContext.request.contextPath}/OrderManagement';
            console.log('Sending request to:', url);

            // Ensure action is set correctly
            console.log('Action before send:', formData.get('action'));

            fetch(url, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
                },
                body: formData.toString()
            })
                .then(response => {
                    console.log('Response status:', response.status);
                    console.log('Response headers:', response.headers);
                    if (!response.ok) {
                        throw new Error('HTTP error! status: ' + response.status);
                    }
                    return response.text(); // Get as text first to see what we get
                })
                .then(text => {
                    console.log('Response text:', text);
                    try {
                        const data = JSON.parse(text);
                        console.log('Parsed JSON:', data);
                        if (data.success) {
                            alert(data.message);
                            closeCreateOrderModal();
                            // Reload page to show new order in list
                            window.location.reload();
                        } else {
                            alert('Lỗi: ' + data.message);
                            submitBtn.disabled = false;
                            submitBtn.innerHTML = originalText;
                        }
                    } catch (e) {
                        console.error('Error parsing JSON:', e);
                        console.error('Response was:', text);
                        alert('Lỗi: Không thể xử lý phản hồi từ server. Vui lòng kiểm tra console.');
                        submitBtn.disabled = false;
                        submitBtn.innerHTML = originalText;
                    }
                })
                .catch(error => {
                    console.error('Fetch error:', error);
                    alert('Có lỗi xảy ra khi tạo đơn hàng: ' + error.message);
                    submitBtn.disabled = false;
                    submitBtn.innerHTML = originalText;
                });
        });
    }

    // Initialize when DOM is ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initCreateOrderForm);
    } else {
        initCreateOrderForm();
    }
</script>

<!-- Create Order Modal -->
<div id="createOrderModal" class="modal-overlay" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1000; justify-content: center; align-items: center;">
    <div class="modal-content" style="background: white; padding: 30px; border-radius: 15px; max-width: 600px; width: 90%; max-height: 90vh; overflow-y: auto; box-shadow: 0 20px 60px rgba(0,0,0,0.3);">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
            <h2 style="color: #dc3545; font-size: 1.8em; margin: 0;">
                <i class="fas fa-plus-circle"></i> Tạo đơn hàng mới
            </h2>
            <button onclick="closeCreateOrderModal()" style="background: none; border: none; font-size: 1.5em; cursor: pointer; color: #666;">&times;</button>
        </div>

        <form id="createOrderForm">
            <div style="display: grid; gap: 20px;">
                <div>
                    <label style="display: block; margin-bottom: 8px; font-weight: 600; color: #333;">
                        <i class="fas fa-user"></i> Tên khách hàng <span style="color: red;">*</span>
                    </label>
                    <input type="text" name="customerName" required
                           style="width: 100%; padding: 12px; border: 2px solid #e2e8f0; border-radius: 8px; font-size: 1em;"
                           placeholder="Nhập tên khách hàng">
                </div>

                <div>
                    <label style="display: block; margin-bottom: 8px; font-weight: 600; color: #333;">
                        <i class="fas fa-phone"></i> Số điện thoại <span style="color: red;">*</span>
                    </label>
                    <input type="tel" name="customerPhone" required
                           style="width: 100%; padding: 12px; border: 2px solid #e2e8f0; border-radius: 8px; font-size: 1em;"
                           placeholder="Nhập số điện thoại">
                </div>

                <div>
                    <label style="display: block; margin-bottom: 8px; font-weight: 600; color: #333;">
                        <i class="fas fa-envelope"></i> Email
                    </label>
                    <input type="email" name="customerEmail"
                           style="width: 100%; padding: 12px; border: 2px solid #e2e8f0; border-radius: 8px; font-size: 1em;"
                           placeholder="Nhập email (tùy chọn)">
                </div>

                <div>
                    <label style="display: block; margin-bottom: 8px; font-weight: 600; color: #333;">
                        <i class="fas fa-calendar"></i> Ngày đặt <span style="color: red;">*</span>
                    </label>
                    <input type="date" id="createOrderDate" name="reservationDate" required
                           style="width: 100%; padding: 12px; border: 2px solid #e2e8f0; border-radius: 8px; font-size: 1em;"
                           onchange="loadSlotsForCreateOrder(this.value)">
                </div>

                <div>
                    <label style="display: block; margin-bottom: 8px; font-weight: 600; color: #333;">
                        <i class="fas fa-clock"></i> Chọn Slot <span style="color: red;">*</span>
                    </label>
                    <div id="slotSelectionCreateOrder" style="display: flex; flex-direction: column; gap: 10px;">
                        <button type="button" class="slot-btn-create" data-slot="MORNING" id="slotMorningCreate"
                                style="padding: 12px 20px; border: 2px solid #e2e8f0; border-radius: 8px; background: transparent; color: #333; cursor: pointer; text-align: left; display: flex; justify-content: space-between; align-items: center;">
                            <span><i class="fas fa-sun"></i> Slot Sáng <span class="slot-time-text" id="morningTimeCreate">--:-- - --:--</span></span>
                        </button>
                        <button type="button" class="slot-btn-create" data-slot="AFTERNOON" id="slotAfternoonCreate"
                                style="padding: 12px 20px; border: 2px solid #e2e8f0; border-radius: 8px; background: transparent; color: #333; cursor: pointer; text-align: left; display: flex; justify-content: space-between; align-items: center;">
                            <span><i class="fas fa-cloud-sun"></i> Slot Chiều <span class="slot-time-text" id="afternoonTimeCreate">--:-- - --:--</span></span>
                        </button>
                        <button type="button" class="slot-btn-create" data-slot="EVENING" id="slotEveningCreate"
                                style="padding: 12px 20px; border: 2px solid #e2e8f0; border-radius: 8px; background: transparent; color: #333; cursor: pointer; text-align: left; display: flex; justify-content: space-between; align-items: center;">
                            <span><i class="fas fa-moon"></i> Slot Tối <span class="slot-time-text" id="eveningTimeCreate">--:-- - --:--</span></span>
                        </button>
                    </div>
                    <input type="hidden" id="createOrderSlot" name="slot" required>
                    <input type="hidden" id="createOrderTime" name="reservationTime">
                    <input type="hidden" name="action" value="createReservation">
                </div>

                <div>
                    <label style="display: block; margin-bottom: 8px; font-weight: 600; color: #333;">
                        <i class="fas fa-users"></i> Số lượng khách <span style="color: red;">*</span>
                    </label>
                    <input type="number" name="guestCount" required min="1"
                           style="width: 100%; padding: 12px; border: 2px solid #e2e8f0; border-radius: 8px; font-size: 1em;"
                           placeholder="Nhập số lượng khách">
                </div>

                <div>
                    <label style="display: block; margin-bottom: 8px; font-weight: 600; color: #333;">
                        <i class="fas fa-table"></i> Chọn bàn <span style="color: red;">*</span>
                    </label>
                    <div style="max-height: 200px; overflow-y: auto; border: 2px solid #e2e8f0; border-radius: 8px; padding: 10px;">
                        <c:forEach var="table" items="${allTables}">
                            <label style="display: flex; align-items: center; gap: 10px; padding: 8px; cursor: pointer; border-radius: 5px; margin-bottom: 5px; transition: background 0.2s;"
                                   onmouseover="this.style.background='#f7fafc'" onmouseout="this.style.background='transparent'">
                                <input type="checkbox" name="tableIds" value="${table.tableId}"
                                       style="width: 18px; height: 18px; cursor: pointer;">
                                <span style="font-weight: 600;">${table.tableName}</span>
                                <span style="color: #666; font-size: 0.9em;">(Tầng ${table.floor}, ${table.capacity} người)</span>
                            </label>
                        </c:forEach>
                    </div>
                </div>

                <div>
                    <label style="display: block; margin-bottom: 8px; font-weight: 600; color: #333;">
                        <i class="fas fa-comment"></i> Ghi chú đặc biệt
                    </label>
                    <textarea name="specialRequests" rows="3"
                              style="width: 100%; padding: 12px; border: 2px solid #e2e8f0; border-radius: 8px; font-size: 1em; resize: vertical;"
                              placeholder="Nhập ghi chú (nếu có)"></textarea>
                </div>
            </div>

            <div style="display: flex; gap: 10px; margin-top: 25px; justify-content: flex-end;">
                <button type="button" onclick="closeCreateOrderModal()"
                        style="padding: 12px 24px; background: #e2e8f0; color: #333; border: none; border-radius: 8px; font-weight: 600; cursor: pointer;">
                    Hủy
                </button>
                <button type="submit"
                        style="padding: 12px 24px; background: #dc3545; color: white; border: none; border-radius: 8px; font-weight: 600; cursor: pointer;">
                    <i class="fas fa-check"></i> Tạo đơn hàng
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    // === SLOT MANAGEMENT FOR CREATE ORDER ===
    let currentSlotDataCreateOrder = null;

    function formatTime(timeStr) {
        if (!timeStr) return '--:--';
        return timeStr.substring(0, 5);
    }

    function loadSlotsForCreateOrder(date) {
        if (!date) return;

        fetch('${pageContext.request.contextPath}/findTable?date=' + encodeURIComponent(date))
            .then(response => response.json())
            .then(data => {
                currentSlotDataCreateOrder = data;

                // Update morning slot
                const morningBtn = document.getElementById('slotMorningCreate');
                const morningTime = document.getElementById('morningTimeCreate');
                if (data.morning && !data.morning.blocked) {
                    morningTime.textContent = formatTime(data.morning.startTime) + ' - ' + formatTime(data.morning.endTime);
                    morningBtn.style.borderColor = '#e2e8f0';
                    morningBtn.style.cursor = 'pointer';
                    morningBtn.style.opacity = '1';
                    morningBtn.onclick = () => selectSlotCreateOrder('MORNING', data.morning.startTime);
                } else {
                    morningTime.textContent = 'Không khả dụng';
                    morningBtn.style.borderColor = '#ccc';
                    morningBtn.style.cursor = 'not-allowed';
                    morningBtn.style.opacity = '0.5';
                    morningBtn.onclick = null;
                }

                // Update afternoon slot
                const afternoonBtn = document.getElementById('slotAfternoonCreate');
                const afternoonTime = document.getElementById('afternoonTimeCreate');
                if (data.afternoon && !data.afternoon.blocked) {
                    afternoonTime.textContent = formatTime(data.afternoon.startTime) + ' - ' + formatTime(data.afternoon.endTime);
                    afternoonBtn.style.borderColor = '#e2e8f0';
                    afternoonBtn.style.cursor = 'pointer';
                    afternoonBtn.style.opacity = '1';
                    afternoonBtn.onclick = () => selectSlotCreateOrder('AFTERNOON', data.afternoon.startTime);
                } else {
                    afternoonTime.textContent = 'Không khả dụng';
                    afternoonBtn.style.borderColor = '#ccc';
                    afternoonBtn.style.cursor = 'not-allowed';
                    afternoonBtn.style.opacity = '0.5';
                    afternoonBtn.onclick = null;
                }

                // Update evening slot
                const eveningBtn = document.getElementById('slotEveningCreate');
                const eveningTime = document.getElementById('eveningTimeCreate');
                if (data.evening && !data.evening.blocked) {
                    eveningTime.textContent = formatTime(data.evening.startTime) + ' - ' + formatTime(data.evening.endTime);
                    eveningBtn.style.borderColor = '#e2e8f0';
                    eveningBtn.style.cursor = 'pointer';
                    eveningBtn.style.opacity = '1';
                    eveningBtn.onclick = () => selectSlotCreateOrder('EVENING', data.evening.startTime);
                } else {
                    eveningTime.textContent = 'Không khả dụng';
                    eveningBtn.style.borderColor = '#ccc';
                    eveningBtn.style.cursor = 'not-allowed';
                    eveningBtn.style.opacity = '0.5';
                    eveningBtn.onclick = null;
                }
            })
            .catch(error => {
                console.error('Error loading slots:', error);
            });
    }

    function selectSlotCreateOrder(slotType, startTime) {
        console.log('Selecting slot:', slotType, 'Time:', startTime);

        // Remove previous selection
        document.querySelectorAll('.slot-btn-create').forEach(btn => {
            btn.style.borderColor = '#e2e8f0';
            btn.style.background = 'transparent';
        });

        // Add selection
        const slotId = 'slot' + slotType.charAt(0) + slotType.slice(1).toLowerCase() + 'Create';
        const btn = document.getElementById(slotId);
        if (btn) {
            btn.style.borderColor = '#dc3545';
            btn.style.background = 'rgba(220, 53, 69, 0.1)';

            // Normalize time format: ensure it's HH:mm:ss format for server
            let normalizedTime = startTime;
            if (normalizedTime && normalizedTime.length === 5) {
                // If format is "08:00", convert to "08:00:00"
                normalizedTime = normalizedTime + ':00';
            }

            document.getElementById('createOrderSlot').value = slotType;
            document.getElementById('createOrderTime').value = normalizedTime;

            console.log('Slot selected:', slotType, 'Normalized time:', normalizedTime);
        } else {
            console.error('Button not found for slot:', slotId);
        }
    }

    // Set min date to today and initialize
    document.addEventListener('DOMContentLoaded', function() {
        const dateInput = document.getElementById('createOrderDate');
        if (dateInput) {
            const today = new Date().toISOString().split('T')[0];
            dateInput.setAttribute('min', today);
            // Load slots if date is already set
            if (dateInput.value) {
                loadSlotsForCreateOrder(dateInput.value);
            }
        }
    });
</script>
</body>
</html>

