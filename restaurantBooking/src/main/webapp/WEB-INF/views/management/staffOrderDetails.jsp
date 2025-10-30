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
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            padding: 40px;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 3px solid #667eea;
        }

        .header h1 {
            color: #2d3748;
            font-size: 2em;
            font-weight: 700;
        }

        .btn-back {
            background: #667eea;
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
            background: #5568d3;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .info-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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
            color: #2d3748;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .section-title i {
            color: #667eea;
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
            color: #4a5568;
            width: 200px;
            flex-shrink: 0;
        }

        .detail-value {
            color: #2d3748;
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
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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
        <a href="${pageContext.request.contextPath}/OrderManagement" class="btn-back">
            <i class="fas fa-arrow-left"></i> Quay lại
        </a>
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
    <c:if test="${not empty serviceMenuItems}">
        <div class="section">
            <div class="section-title">
                <i class="fas fa-box-open"></i>
                Món Trong Combo/Dịch Vụ (${serviceMenuItems.size()} món)
            </div>
            <table class="table">
                <thead>
                <tr>
                    <th>STT</th>
                    <th>Tên món</th>
                    <th>Giá</th>
                    <th>Loại</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="item" items="${serviceMenuItems}" varStatus="loop">
                    <tr>
                        <td>${loop.index + 1}</td>
                        <td>
                            <strong>${item.itemName}</strong>
                            <c:if test="${item.description != null}">
                                <br><small style="color: #718096;">
                                    ${item.description}
                            </small>
                            </c:if>
                        </td>
                        <td>
                            <fmt:formatNumber value="${item.price}" pattern="#,###"/> VNĐ
                        </td>
                        <td>
                                    <span class="table-badge">
                                        Combo
                                    </span>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </c:if>

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
                                    <br><small style="color: #718096;">
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
                <p style="padding: 20px; text-align: center; color: #718096;">
                    <i class="fas fa-info-circle"></i>
                    Khách không đặt thêm món nào
                </p>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Total -->
    <div class="total-section">
        <div class="total-row grand-total">
            <span>TỔNG CỘNG:</span>
            <span>
                    <fmt:formatNumber value="${reservation.totalAmount != null ? reservation.totalAmount : calculatedTotal}"
                                      pattern="#,###"/> VNĐ
                </span>
        </div>
    </div>
</div>
</body>
</html>

