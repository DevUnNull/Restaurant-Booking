<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi Tiết Đơn Hàng #${reservation.reservationId}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
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
            max-width: 1200px;
            margin: 0 auto;
            background: #ffffff;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
            padding: 40px;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 3px solid #dc3545;
        }

        .header h1 {
            color: #000000;
            font-size: 2em;
            font-weight: 700;
        }

        .btn-back {
            background: #dc3545;
            color: white;
            padding: 12px 24px;
            border-radius: 10px;
            text-decoration: none;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s;
        }

        .btn-back:hover {
            background: #c82333;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(220, 53, 69, 0.4);
        }

        .header-actions {
            display: flex;
            gap: 12px;
            align-items: center;
        }

        .btn-add-item {
            background: #28a745;
            color: white;
            padding: 12px 24px;
            border-radius: 10px;
            border: none;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
            transition: all 0.3s;
            font-size: 1em;
        }

        .btn-add-item:hover {
            background: #218838;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(40, 167, 69, 0.4);
        }

        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0, 0, 0, 0.5);
        }

        .modal-content {
            background-color: #ffffff;
            margin: 5% auto;
            padding: 30px;
            border-radius: 15px;
            width: 90%;
            max-width: 800px;
            max-height: 80vh;
            overflow-y: auto;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 2px solid #dc3545;
        }

        .modal-header h2 {
            color: #000000;
            font-size: 1.8em;
            font-weight: 700;
            margin: 0;
        }

        .close-modal {
            color: #aaa;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
            transition: color 0.3s;
        }

        .close-modal:hover {
            color: #dc3545;
        }

        .menu-items-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 25px;
        }

        .menu-item-card {
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            padding: 15px;
            cursor: pointer;
            transition: all 0.3s;
            background: #ffffff;
        }

        .menu-item-card:hover {
            border-color: #dc3545;
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(220, 53, 69, 0.2);
        }

        .menu-item-card.selected {
            border-color: #dc3545;
            background: #fff5f5;
        }

        .menu-item-card img {
            width: 100%;
            height: 120px;
            object-fit: cover;
            border-radius: 8px;
            margin-bottom: 10px;
        }

        .menu-item-card h3 {
            font-size: 1em;
            font-weight: 600;
            color: #000000;
            margin-bottom: 8px;
        }

        .menu-item-card .price {
            color: #dc3545;
            font-weight: 700;
            font-size: 1.1em;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            font-weight: 600;
            color: #000000;
            margin-bottom: 8px;
        }

        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            font-size: 1em;
            transition: border-color 0.3s;
        }

        .form-group input:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #dc3545;
        }

        .form-group textarea {
            resize: vertical;
            min-height: 80px;
        }

        .quantity-controls {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .quantity-btn {
            background: #dc3545;
            color: white;
            border: none;
            width: 35px;
            height: 35px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 1.2em;
            font-weight: bold;
            transition: all 0.3s;
        }

        .quantity-btn:hover {
            background: #c82333;
        }

        .quantity-input {
            width: 80px;
            text-align: center;
            font-weight: 600;
        }

        .modal-actions {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            margin-top: 25px;
            padding-top: 20px;
            border-top: 2px solid #e2e8f0;
        }

        .btn-modal {
            padding: 12px 24px;
            border-radius: 8px;
            border: none;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }

        .btn-modal-primary {
            background: #dc3545;
            color: white;
        }

        .btn-modal-primary:hover {
            background: #c82333;
        }

        .btn-modal-secondary {
            background: #6c757d;
            color: white;
        }

        .btn-modal-secondary:hover {
            background: #5a6268;
        }

        .loading-spinner {
            display: none;
            text-align: center;
            padding: 20px;
        }

        .loading-spinner.active {
            display: block;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .info-card {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            padding: 20px;
            border-radius: 15px;
            color: white;
        }

        .info-card h3 {
            font-size: 0.9em;
            opacity: 0.9;
            margin-bottom: 10px;
        }

        .info-card .value {
            font-size: 1.5em;
            font-weight: 700;
        }

        .section {
            background: #f7fafc;
            padding: 25px;
            border-radius: 15px;
            margin-bottom: 20px;
        }

        .section-title {
            font-size: 1.3em;
            font-weight: 700;
            color: #000000;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .section-title i {
            color: #dc3545;
        }

        .detail-row {
            display: flex;
            padding: 12px 0;
            border-bottom: 1px solid #e2e8f0;
        }

        .detail-row:last-child {
            border-bottom: none;
        }

        .detail-label {
            font-weight: 600;
            color: #000000;
            width: 200px;
            flex-shrink: 0;
        }

        .detail-value {
            color: #000000;
            flex-grow: 1;
        }

        /* Payment Method Badges */
        .payment-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 16px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.95em;
        }

        .payment-CASH {
            background: #fef3c7;
            color: #92400e;
        }

        .payment-CREDIT_CARD {
            background: #dbeafe;
            color: #1e40af;
        }

        .payment-E_WALLET {
            background: #d1fae5;
            color: #065f46;
        }

        /* Payment Status Badges */
        .payment-status-PENDING {
            background: #fff3cd;
            color: #856404;
        }

        .payment-status-COMPLETED {
            background: #d4edda;
            color: #155724;
        }

        .payment-status-FAILED {
            background: #f8d7da;
            color: #721c24;
        }

        /* Order Status Badges */
        .status-badge {
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 0.9em;
            font-weight: 600;
            text-transform: uppercase;
            display: inline-block;
        }

        .status-PENDING { background: #fff3cd; color: #856404; }
        .status-CONFIRMED { background: #d1ecf1; color: #0c5460; }
        .status-CHECKED_IN { background: #cce5ff; color: #004085; }
        .status-COMPLETED { background: #d4edda; color: #155724; }
        .status-CANCELLED { background: #f8d7da; color: #721c24; }
        .status-NO_SHOW { background: #e2e3e5; color: #383d41; }

        /* Tables */
        .table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }

        .table thead {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            color: white;
        }

        .table th {
            padding: 15px;
            text-align: left;
            font-weight: 600;
            font-size: 0.95em;
        }

        .table td {
            padding: 15px;
            border-bottom: 1px solid #e2e8f0;
        }

        .table tbody tr:hover {
            background: #f7fafc;
        }

        .table-badge {
            background: #e6f3ff;
            color: #0066cc;
            padding: 6px 12px;
            border-radius: 12px;
            font-size: 0.9em;
            font-weight: 600;
            display: inline-block;
            margin: 2px;
        }

        .total-section {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            color: white;
            padding: 25px;
            border-radius: 15px;
            margin-top: 20px;
        }

        .total-row {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            font-size: 1.1em;
        }

        .total-row.grand-total {
            font-size: 1.5em;
            font-weight: 700;
            border-top: 2px solid rgba(255,255,255,0.3);
            padding-top: 20px;
            margin-top: 10px;
        }

        .alert {
            padding: 15px 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .alert-info {
            background: #d1ecf1;
            color: #0c5460;
            border-left: 4px solid #17a2b8;
        }

        .alert-warning {
            background: #fff3cd;
            color: #856404;
            border-left: 4px solid #ffc107;
        }

        .alert-success {
            background: #d4edda;
            color: #155724;
            border-left: 4px solid #28a745;
        }
    </style>
</head>
<body>
<!-- Include Header -->
<jsp:include page="../common/header.jsp" />

<div class="container">
    <!-- Header -->
    <div class="header">
        <h1>
            <i class="fas fa-file-invoice"></i>
            Chi Tiết Đơn Hàng #${reservation.reservationId}
        </h1>
        <div class="header-actions">
            <button class="btn-add-item" onclick="openAddItemModal()">
                <i class="fas fa-plus"></i> Thêm món
            </button>
            <a href="${pageContext.request.contextPath}/OrderManagement" class="btn-back">
                <i class="fas fa-arrow-left"></i> Quay lại
            </a>
        </div>
    </div>

    <!-- Summary Cards -->
    <div class="info-grid">
        <div class="info-card">
            <h3>Trạng thái đơn hàng</h3>
            <div class="value">${reservation.status}</div>
        </div>
        <div class="info-card">
            <h3>Tổng tiền</h3>
            <div class="value">
                <fmt:formatNumber value="${reservation.totalAmount != null ? reservation.totalAmount : calculatedTotal}"
                                  pattern="#,###"/> VNĐ
            </div>
        </div>
        <div class="info-card">
            <h3>Số khách</h3>
            <div class="value">${reservation.guestCount} người</div>
        </div>
        <div class="info-card">
            <h3>Số bàn</h3>
            <div class="value">${tables.size()} bàn</div>
        </div>
    </div>

    <!-- Payment Status Alert -->
    <c:if test="${payment != null}">
        <c:choose>
            <c:when test="${payment.paymentMethod == 'CASH' && payment.paymentStatus == 'PENDING'}">
                <div class="alert alert-info">
                    <i class="fas fa-info-circle fa-lg"></i>
                    <strong>Thanh toán tại quán:</strong>
                    Khách hàng sẽ thanh toán trực tiếp khi đến nhà hàng.
                    Chuyển sang "COMPLETED" sau khi nhận tiền.
                </div>
            </c:when>
            <c:when test="${(payment.paymentMethod == 'CREDIT_CARD' || payment.paymentMethod == 'E_WALLET')
                               && payment.paymentStatus == 'PENDING'}">
                <div class="alert alert-warning">
                    <i class="fas fa-exclamation-triangle fa-lg"></i>
                    <strong>Chờ thanh toán online:</strong>
                    Khách đã chọn thanh toán online nhưng chưa hoàn tất.
                    Liên hệ khách nếu quá 30 phút.
                </div>
            </c:when>
            <c:when test="${payment.paymentStatus == 'COMPLETED'}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle fa-lg"></i>
                    <strong>Đã thanh toán:</strong>
                    Thanh toán đã hoàn tất bằng ${payment.paymentMethod == 'CASH' ? 'tiền mặt' :
                        payment.paymentMethod == 'CREDIT_CARD' ? 'thẻ tín dụng' : 'ví điện tử'}.
                </div>
            </c:when>
        </c:choose>
    </c:if>

    <!-- Reservation Information -->
    <div class="section">
        <div class="section-title">
            <i class="fas fa-calendar-alt"></i>
            Thông Tin Đặt Bàn
        </div>
        <div class="detail-row">
            <span class="detail-label">Mã đơn:</span>
            <span class="detail-value">#${reservation.reservationId}</span>
        </div>
        <div class="detail-row">
            <span class="detail-label">Ngày đặt:</span>
            <span class="detail-value">${reservation.reservationDate}</span>
        </div>
        <div class="detail-row">
            <span class="detail-label">Giờ đặt:</span>
            <span class="detail-value">${reservation.reservationTime}</span>
        </div>
        <div class="detail-row">
            <span class="detail-label">Số lượng khách:</span>
            <span class="detail-value">${reservation.guestCount} người</span>
        </div>
        <div class="detail-row">
            <span class="detail-label">Trạng thái:</span>
            <span class="detail-value">
                    <span class="status-badge status-${reservation.status}">
                        ${reservation.status}
                    </span>
                </span>
        </div>
        <c:if test="${reservation.specialRequests != null && !reservation.specialRequests.isEmpty()}">
            <div class="detail-row">
                <span class="detail-label">Yêu cầu đặc biệt:</span>
                <span class="detail-value">${reservation.specialRequests}</span>
            </div>
        </c:if>
    </div>

    <!-- Tables Information -->
    <div class="section">
        <div class="section-title">
            <i class="fas fa-chair"></i>
            Bàn Đã Chọn (${tables.size()} bàn)
        </div>
        <c:forEach var="table" items="${tables}">
                <span class="table-badge">
                    ${table.tableName} - ${table.capacity} người - Tầng ${table.floor}
                </span>
        </c:forEach>
    </div>

    <!-- Payment Information -->
    <c:if test="${payment != null}">
        <div class="section">
            <div class="section-title">
                <i class="fas fa-credit-card"></i>
                Thông Tin Thanh Toán
            </div>
            <div class="detail-row">
                <span class="detail-label">Phương thức thanh toán:</span>
                <span class="detail-value">
                        <span class="payment-badge payment-${payment.paymentMethod}">
                            <i class="fas ${payment.paymentMethod == 'CASH' ? 'fa-money-bill-wave' :
                                         payment.paymentMethod == 'CREDIT_CARD' ? 'fa-credit-card' : 'fa-wallet'}"></i>
                            <c:choose>
                                <c:when test="${payment.paymentMethod == 'CASH'}">Thanh toán tại quán (COD)</c:when>
                                <c:when test="${payment.paymentMethod == 'CREDIT_CARD'}">Thẻ tín dụng</c:when>
                                <c:when test="${payment.paymentMethod == 'E_WALLET'}">Ví điện tử</c:when>
                                <c:otherwise>${payment.paymentMethod}</c:otherwise>
                            </c:choose>
                        </span>
                    </span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Trạng thái thanh toán:</span>
                <span class="detail-value">
                        <span class="payment-badge payment-status-${payment.paymentStatus}">
                            <i class="fas ${payment.paymentStatus == 'COMPLETED' ? 'fa-check-circle' :
                                         payment.paymentStatus == 'PENDING' ? 'fa-clock' : 'fa-times-circle'}"></i>
                            ${payment.paymentStatus}
                        </span>
                    </span>
            </div>
            <c:if test="${payment.paymentDate != null}">
                <div class="detail-row">
                    <span class="detail-label">Ngày thanh toán:</span>
                    <span class="detail-value">${payment.paymentDate}</span>
                </div>
            </c:if>
        </div>
    </c:if>

    <!-- Service Menu Items (Combo Items) -->
    <div class="section">
        <div class="section-title">
            <i class="fas fa-box-open"></i>
            Món Trong Combo/Dịch Vụ
        </div>

        <c:choose>
            <c:when test="${not empty serviceMenuItems}">
                <table class="table">
                    <thead>
                    <tr>
                        <th>STT</th>
                        <th>Tên món</th>
                        <th>Đơn giá</th>
                        <th>Số lượng</th>
                        <th>Thành tiền</th>
                        <th>Loại</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="item" items="${serviceMenuItems}" varStatus="loop">
                        <c:set var="foundOrderItem" value="${null}" />
                        <c:forEach var="orderItem" items="${orderItems}">
                            <c:if test="${orderItem.itemId == item.itemId}">
                                <c:set var="foundOrderItem" value="${orderItem}" />
                            </c:if>
                        </c:forEach>

                        <tr>
                            <td>${loop.index + 1}</td>
                            <td>
                                <strong>${item.itemName}</strong>
                                <c:if test="${item.description != null}">
                                    <br><small style="color: #000000;">
                                        ${item.description}
                                </small>
                                </c:if>
                                <c:if test="${foundOrderItem != null && foundOrderItem.specialInstructions != null}">
                                    <br><small style="color: #000000;">
                                    <i class="fas fa-info-circle"></i> ${foundOrderItem.specialInstructions}
                                </small>
                                </c:if>
                            </td>
                            <td>
                                <fmt:formatNumber value="${item.price}" pattern="#,###"/> VNĐ
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${foundOrderItem != null}">
                                        <strong>${foundOrderItem.quantity}</strong>
                                    </c:when>
                                    <c:otherwise>
                                        0
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${foundOrderItem != null}">
                                        <strong>
                                            <fmt:formatNumber value="${foundOrderItem.unitPrice * foundOrderItem.quantity}" pattern="#,###"/> VNĐ
                                        </strong>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color: #999;">-</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <span class="table-badge" style="background: #ffe0e0; color: #c82333;">
                                    <i class="fas fa-gift"></i> Combo
                                </span>
                                <c:if test="${foundOrderItem != null}">
                                    <br><span class="status-badge status-${foundOrderItem.status}" style="margin-top: 4px; display: inline-block;">
                                        ${foundOrderItem.status}
                                </span>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <p style="padding: 20px; text-align: center; color: #000000;">
                    <i class="fas fa-info-circle"></i>
                    Đơn hàng này không có món combo/dịch vụ
                </p>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Order Items (Additional Items) -->
    <div class="section">
        <div class="section-title">
            <i class="fas fa-utensils"></i>
            Món Đặt Thêm
            <c:if test="${not empty orderItems}">
                (${orderItems.size()} món)
            </c:if>
            <c:if test="${empty orderItems}">
                (Không có)
            </c:if>
        </div>
        <c:choose>
            <c:when test="${not empty orderItems}">
                <table class="table">
                    <thead>
                    <tr>
                        <th>STT</th>
                        <th>Tên món</th>
                        <th>Đơn giá</th>
                        <th>Số lượng</th>
                        <th>Thành tiền</th>
                        <th>Trạng thái</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="item" items="${orderItems}" varStatus="loop">
                        <tr>
                            <td>${loop.index + 1}</td>
                            <td>
                                <strong>
                                        ${menuItemsMap[item.itemId] != null ?
                                                menuItemsMap[item.itemId].itemName :
                                                'Món #' += item.itemId}
                                </strong>
                                <c:if test="${item.specialInstructions != null}">
                                    <br><small style="color: #000000;">
                                    <i class="fas fa-info-circle"></i>
                                        ${item.specialInstructions}
                                </small>
                                </c:if>
                            </td>
                            <td>
                                <fmt:formatNumber value="${item.unitPrice}" pattern="#,###"/> VNĐ
                            </td>
                            <td>${item.quantity}</td>
                            <td>
                                <strong>
                                    <fmt:formatNumber value="${item.unitPrice * item.quantity}" pattern="#,###"/> VNĐ
                                </strong>
                            </td>
                            <td>
                                        <span class="status-badge status-${item.status}">
                                                ${item.status}
                                        </span>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <p style="padding: 20px; text-align: center; color: #000000;">
                    <i class="fas fa-info-circle"></i>
                    Khách không đặt thêm món nào
                </p>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Total -->
    <div class="total-section">
        <c:set var="tableCount" value="${tables.size()}" />
        <c:set var="depositAmount" value="0" />
        <c:set var="hasDeposit" value="false" />
        <c:if test="${payment != null && payment.paymentMethod == 'CASH' && tableCount > 0}">
            <c:set var="depositAmount" value="${tableCount * 20000}" />
            <c:set var="hasDeposit" value="true" />
        </c:if>

        <c:set var="itemsTotal" value="${calculatedTotal}" />
        <c:if test="${reservation.totalAmount != null}">
            <c:choose>
                <c:when test="${hasDeposit}">
                    <c:set var="itemsTotal" value="${reservation.totalAmount - depositAmount}" />
                </c:when>
                <c:otherwise>
                    <c:set var="itemsTotal" value="${reservation.totalAmount}" />
                </c:otherwise>
            </c:choose>
        </c:if>

        <div class="total-row">
            <span>Tổng tiền món ăn:</span>
            <span>
                <fmt:formatNumber value="${itemsTotal}" pattern="#,###"/> VNĐ
            </span>
        </div>

        <c:if test="${hasDeposit}">
            <div class="total-row" style="border-top: 1px solid rgba(255,255,255,0.2); padding-top: 15px; margin-top: 10px;">
                <span>
                    <i class="fas fa-info-circle"></i> Phí đặt cọc (${tableCount} bàn × 20.000 VNĐ/bàn):
                </span>
                <span style="color: #ffc107;">
                    <fmt:formatNumber value="${depositAmount}" pattern="#,###"/> VNĐ
                </span>
            </div>
            <div style="padding: 10px 0; font-size: 0.9em; opacity: 0.9; border-top: 1px solid rgba(255,255,255,0.1); margin-top: 10px;">
                <i class="fas fa-info-circle"></i>
                <strong>Lưu ý:</strong> Tiền đặt cọc sẽ được hoàn lại khi khách đến quán và thanh toán đầy đủ.
            </div>
        </c:if>

        <div class="total-row grand-total">
            <span>TỔNG CỘNG:</span>
            <span>
                <fmt:formatNumber value="${reservation.totalAmount != null ? reservation.totalAmount : (calculatedTotal + depositAmount)}"
                                  pattern="#,###"/> VNĐ
            </span>
        </div>
    </div>
</div>

<!-- Modal: Add Menu Item -->
<div id="addItemModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h2><i class="fas fa-utensils"></i> Thêm món vào đơn hàng</h2>
            <span class="close-modal" onclick="closeAddItemModal()">&times;</span>
        </div>

        <div class="form-group">
            <label>Tìm kiếm món ăn:</label>
            <input type="text" id="searchMenuItem" placeholder="Nhập tên món ăn..."
                   onkeyup="filterMenuItems()">
        </div>

        <div class="menu-items-grid" id="menuItemsGrid">
            <c:forEach var="menuItem" items="${allMenuItems}">
                <div class="menu-item-card" data-item-id="${menuItem.itemId}"
                     data-item-name="${menuItem.itemName}"
                     data-item-price="${menuItem.price}"
                     data-item-image="${menuItem.imageUrl}">
                    <c:if test="${menuItem.imageUrl != null && !menuItem.imageUrl.isEmpty()}">
                        <img src="${pageContext.request.contextPath}${menuItem.imageUrl}"
                             alt="${menuItem.itemName}"
                             onerror="this.src='${pageContext.request.contextPath}/images/default-food.jpg'">
                    </c:if>
                    <c:if test="${menuItem.imageUrl == null || menuItem.imageUrl.isEmpty()}">
                        <img src="${pageContext.request.contextPath}/images/default-food.jpg"
                             alt="${menuItem.itemName}">
                    </c:if>
                    <h3>${menuItem.itemName}</h3>
                    <div class="price">
                        <fmt:formatNumber value="${menuItem.price}" pattern="#,###"/> VNĐ
                    </div>
                </div>
            </c:forEach>
        </div>

        <c:if test="${empty allMenuItems}">
            <p style="text-align: center; padding: 40px; color: #6c757d;">
                <i class="fas fa-info-circle"></i> Không có món ăn nào khả dụng.
            </p>
        </c:if>

        <div id="selectedItemSection" style="display: none;">
            <div class="form-group">
                <label>Món đã chọn:</label>
                <div style="padding: 15px; background: #f7fafc; border-radius: 8px; margin-bottom: 15px;">
                    <strong id="selectedItemName"></strong>
                    <div class="price" id="selectedItemPrice"></div>
                </div>
            </div>

            <div class="form-group">
                <label>Số lượng:</label>
                <div class="quantity-controls">
                    <button class="quantity-btn" onclick="decreaseQuantity()">-</button>
                    <input type="number" id="itemQuantity" class="quantity-input"
                           value="1" min="1" onchange="validateQuantity()">
                    <button class="quantity-btn" onclick="increaseQuantity()">+</button>
                </div>
            </div>

            <div class="form-group">
                <label>Ghi chú đặc biệt (tùy chọn):</label>
                <textarea id="specialInstructions"
                          placeholder="Ví dụ: Không cay, ít đường, không hành..."
                          rows="3"></textarea>
            </div>
        </div>

        <div class="loading-spinner" id="loadingSpinner">
            <i class="fas fa-spinner fa-spin fa-2x"></i>
            <p>Đang thêm món...</p>
        </div>

        <div class="modal-actions">
            <button class="btn-modal btn-modal-secondary" onclick="closeAddItemModal()">
                Hủy
            </button>
            <button class="btn-modal btn-modal-primary" id="addItemBtn"
                    onclick="addItemToOrder()" disabled>
                <i class="fas fa-check"></i> Thêm vào đơn hàng
            </button>
        </div>
    </div>
</div>

<script>
    let selectedItemId = null;
    let selectedItemPrice = null;

    function openAddItemModal() {
        document.getElementById('addItemModal').style.display = 'block';
        resetModal();
    }

    function closeAddItemModal() {
        document.getElementById('addItemModal').style.display = 'none';
        resetModal();
    }

    function resetModal() {
        selectedItemId = null;
        selectedItemPrice = null;
        document.getElementById('selectedItemSection').style.display = 'none';
        document.getElementById('addItemBtn').disabled = true;
        document.getElementById('itemQuantity').value = 1;
        document.getElementById('specialInstructions').value = '';
        document.getElementById('searchMenuItem').value = '';

        // Reset all cards
        document.querySelectorAll('.menu-item-card').forEach(card => {
            card.classList.remove('selected');
        });

        // Show all items
        filterMenuItems();
    }


    function selectMenuItem(itemId, itemName, price, cardElement) {
        selectedItemId = itemId;
        selectedItemPrice = price;

        // Update UI
        document.getElementById('selectedItemName').textContent = itemName;
        document.getElementById('selectedItemPrice').innerHTML =
            new Intl.NumberFormat('vi-VN').format(price) + ' VNĐ';
        document.getElementById('selectedItemSection').style.display = 'block';
        document.getElementById('addItemBtn').disabled = false;

        // Highlight selected card
        document.querySelectorAll('.menu-item-card').forEach(card => {
            card.classList.remove('selected');
        });
        if (cardElement) {
            cardElement.classList.add('selected');
        }
    }

    function increaseQuantity() {
        const quantityInput = document.getElementById('itemQuantity');
        quantityInput.value = parseInt(quantityInput.value) + 1;
    }

    function decreaseQuantity() {
        const quantityInput = document.getElementById('itemQuantity');
        const currentValue = parseInt(quantityInput.value);
        if (currentValue > 1) {
            quantityInput.value = currentValue - 1;
        }
    }

    function validateQuantity() {
        const quantityInput = document.getElementById('itemQuantity');
        const value = parseInt(quantityInput.value);
        if (isNaN(value) || value < 1) {
            quantityInput.value = 1;
        }
    }

    function filterMenuItems() {
        const searchTerm = document.getElementById('searchMenuItem').value.toLowerCase();
        const cards = document.querySelectorAll('.menu-item-card');

        cards.forEach(card => {
            const itemName = card.querySelector('h3').textContent.toLowerCase();
            if (itemName.includes(searchTerm)) {
                card.style.display = 'block';
            } else {
                card.style.display = 'none';
            }
        });
    }

    function addItemToOrder() {
        if (!selectedItemId) {
            alert('Vui lòng chọn món ăn');
            return;
        }

        const quantity = parseInt(document.getElementById('itemQuantity').value);
        const specialInstructions = document.getElementById('specialInstructions').value.trim();
        const reservationId = ${reservation.reservationId};

        if (quantity < 1) {
            alert('Số lượng phải lớn hơn 0');
            return;
        }

        // Show loading
        document.getElementById('loadingSpinner').classList.add('active');
        document.getElementById('addItemBtn').disabled = true;

        // Prepare form data
        const formData = new URLSearchParams();
        formData.append('action', 'addOrderItem');
        formData.append('reservationId', reservationId);
        formData.append('itemId', selectedItemId);
        formData.append('quantity', quantity);
        if (specialInstructions) {
            formData.append('specialInstructions', specialInstructions);
        }

        // Send AJAX request
        fetch('${pageContext.request.contextPath}/staffOrderDetails', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
            },
            body: formData.toString()
        })
            .then(response => response.json())
            .then(data => {
                document.getElementById('loadingSpinner').classList.remove('active');

                if (data.success) {
                    alert(data.message);
                    // Reload page to show new item
                    window.location.reload();
                } else {
                    alert('Lỗi: ' + data.message);
                    document.getElementById('addItemBtn').disabled = false;
                }
            })
            .catch(error => {
                document.getElementById('loadingSpinner').classList.remove('active');
                document.getElementById('addItemBtn').disabled = false;
                console.error('Error:', error);
                alert('Lỗi khi thêm món: ' + error.message);
            });
    }

    // Use event delegation for menu item cards
    document.addEventListener('click', function(event) {
        const card = event.target.closest('.menu-item-card');
        if (card && document.getElementById('addItemModal').style.display === 'block') {
            const itemId = parseInt(card.getAttribute('data-item-id'));
            const itemName = card.getAttribute('data-item-name');
            const price = parseFloat(card.getAttribute('data-item-price'));

            selectMenuItem(itemId, itemName, price, card);
        }
    });

    // Close modal when clicking outside
    window.onclick = function(event) {
        const modal = document.getElementById('addItemModal');
        if (event.target == modal) {
            closeAddItemModal();
        }
    }
</script>
</body>
</html>

