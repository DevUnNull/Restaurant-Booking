<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Kết quả thanh toán VNPay</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/theme.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
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
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .result-container {
            background: white;
            border-radius: 20px;
            padding: 50px;
            max-width: 500px;
            width: 100%;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            text-align: center;
        }

        .result-icon {
            font-size: 80px;
            margin-bottom: 20px;
        }

        .result-icon.success {
            color: #28a745;
        }

        .result-icon.failed {
            color: #dc3545;
        }

        h2 {
            color: #333;
            margin-bottom: 20px;
            font-size: 2em;
        }

        .message {
            font-size: 1.2em;
            margin-bottom: 30px;
            color: #666;
            line-height: 1.6;
        }

        .btn-container {
            display: flex;
            gap: 15px;
            justify-content: center;
        }

        .btn {
            padding: 15px 30px;
            border: none;
            border-radius: 10px;
            font-size: 1em;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            transition: all 0.3s;
        }

        .btn-primary {
            background: #667eea;
            color: white;
        }

        .btn-primary:hover {
            background: #5568d3;
            transform: translateY(-2px);
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
        }

        .btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }

        .error-code {
            margin-top: 20px;
            padding: 15px;
            background: #f8d7da;
            border-radius: 8px;
            color: #721c24;
            font-size: 0.9em;
        }
    </style>
</head>
<body>
<jsp:include page="../views/common/header.jsp" />

<div class="result-container">
    <c:choose>
        <c:when test="${success == true}">
            <div class="result-icon success">
                <i class="fas fa-check-circle"></i>
            </div>
            <h2>Thanh toán thành công!</h2>
            <div class="message">
                    ${message}
                <c:if test="${not empty reservationId}">
                    <br><br>
                    <strong>Mã đơn hàng: #${reservationId}</strong>
                </c:if>
                <c:if test="${not empty txnRef}">
                    <br>
                    <small>Mã giao dịch: ${txnRef}</small>
                </c:if>
            </div>
        </c:when>
        <c:otherwise>
            <div class="result-icon failed">
                <i class="fas fa-times-circle"></i>
            </div>
            <h2>Thanh toán thất bại</h2>
            <div class="message">
                    ${message}
            </div>
            <c:if test="${not empty errorCode}">
                <div class="error-code">
                    <strong>Mã lỗi:</strong> ${errorCode}
                </div>
            </c:if>
        </c:otherwise>
    </c:choose>

    <div class="btn-container">
        <c:if test="${not empty reservationId}">
            <a href="${pageContext.request.contextPath}/orderDetails?id=${reservationId}" class="btn btn-primary">
                <i class="fas fa-eye"></i> Xem chi tiết
            </a>
        </c:if>
        <a href="${pageContext.request.contextPath}" class="btn btn-secondary">
            <i class="fas fa-home"></i> Về trang chủ
        </a>
    </div>
</div>
</body>
</html>

