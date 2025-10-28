<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.fpt.restaurantbooking.models.Reservation" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hủy đặt bàn</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        /* --- General Reset & Body Styling --- */
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }
        body, html {
            font-family: 'Montserrat', sans-serif;
            background-image: linear-gradient(rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.6)), url('https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?q=80&w=2070&auto=format&fit=crop');
            background-position: center;
            background-size: cover;
            background-attachment: fixed;
            color: #f0f0f0;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        .container {
            width: 90%;
            max-width: 700px;
            background-color: rgba(20, 10, 10, 0.75);
            backdrop-filter: blur(8px);
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.37);
            border: 1px solid rgba(255, 255, 255, 0.18);
        }
        h2 {
            text-align: center;
            margin-bottom: 30px;
            color: #fff;
            font-size: 2.2em; /* Giảm nhẹ kích thước để gọn hơn */
            font-weight: 700;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            text-shadow: 2px 2px 8px rgba(0,0,0,0.5);
        }
        form {
            display: flex;
            flex-direction: column;
            gap: 15px; /* Giảm khoảng cách để bố cục chặt chẽ hơn */
        }
        label {
            font-size: 1em; /* Giảm kích thước chữ */
            font-weight: 600;
            color: #fff;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        select, textarea {
            padding: 10px 12px; /* Giảm padding để gọn hơn */
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 8px;
            font-size: 0.95em; /* Giảm kích thước chữ */
            background: rgba(0, 0, 0, 0.4);
            color: #fff;
            font-family: 'Montserrat', sans-serif;
            outline: none;
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
        }
        select:focus, textarea:focus {
            border-color: #e74c3c;
            box-shadow: 0 0 8px rgba(231, 76, 60, 0.3);
        }
        textarea {
            min-height: 100px; /* Giảm chiều cao để gọn hơn */
            resize: vertical;
        }
        option {
            background-color: #333;
            color: #fff;
        }
        /* CHÍNH SÁCH HỦY */
        .policy-section {
            background: rgba(231, 76, 60, 0.1);
            border: 1px solid rgba(231, 76, 60, 0.3);
            border-radius: 10px;
            padding: 15px; /* Giảm padding */
            margin-bottom: 20px;
        }
        .policy-section h3 {
            color: #e74c3c;
            font-size: 1.1em; /* Giảm kích thước chữ */
            margin-bottom: 12px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .policy-section ul {
            list-style: none;
            padding-left: 0;
        }
        .policy-section li {
            padding: 6px 0;
            padding-left: 20px;
            position: relative;
            line-height: 1.5;
            color: rgba(255, 255, 255, 0.9);
            font-size: 0.9em; /* Giảm kích thước chữ */
        }
        .policy-section li:before {
            content: "✓";
            position: absolute;
            left: 0;
            color: #e74c3c;
            font-weight: bold;
        }
        .actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px; /* Giảm khoảng cách */
            margin-top: 15px;
        }
        .btn {
            border: none;
            padding: 10px 20px; /* Giảm kích thước nút */
            border-radius: 8px;
            cursor: pointer;
            font-size: 0.95em; /* Giảm kích thước chữ */
            font-weight: 600;
            transition: background-color 0.3s ease, transform 0.2s ease, box-shadow 0.2s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            position: relative;
            overflow: hidden;
        }
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 10px rgba(0,0,0,0.3);
        }
        .btn:active {
            transform: translateY(0);
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
        }
        .btn i {
            font-size: 0.9em; /* Giảm kích thước biểu tượng */
            transition: transform 0.3s ease;
        }
        .btn:hover i {
            transform: scale(1.2); /* Phóng to biểu tượng khi hover */
        }
        .cancel-btn {
            background: #e74c3c;
            color: white;
        }
        .cancel-btn:hover {
            background: #c0392b;
        }
        .back-btn {
            background-color: #6c757d;
            color: white;
        }
        .back-btn:hover {
            background-color: #5a6268;
        }
        /* Tooltip cho nút */
        .btn::after {
            content: attr(title);
            position: absolute;
            bottom: 100%;
            left: 50%;
            transform: translateX(-50%);
            background: rgba(0, 0, 0, 0.8);
            color: white;
            padding: 5px 10px;
            border-radius: 5px;
            font-size: 0.8em;
            white-space: nowrap;
            opacity: 0;
            visibility: hidden;
            transition: opacity 0.3s ease, visibility 0.3s ease;
            margin-bottom: 8px;
        }
        .btn:hover::after {
            opacity: 1;
            visibility: visible;
        }
        /* POPUP XÁC NHẬN */
        .popup-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.7);
            z-index: 9999;
            justify-content: center;
            align-items: center;
        }
        .popup-overlay.show {
            display: flex;
        }
        .popup-content {
            background: rgba(20, 10, 10, 0.95);
            backdrop-filter: blur(10px);
            padding: 25px; /* Giảm padding */
            border-radius: 12px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.5);
            border: 2px solid rgba(231, 76, 60, 0.5);
            max-width: 450px; /* Giảm chiều rộng */
            width: 90%;
            animation: popupSlideIn 0.3s ease;
        }
        @keyframes popupSlideIn {
            from {
                opacity: 0;
                transform: translateY(-30px); /* Giảm khoảng cách trượt */
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        .popup-content h3 {
            color: #e74c3c;
            font-size: 1.6em; /* Giảm kích thước chữ */
            margin-bottom: 15px;
            text-align: center;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        .popup-content p {
            color: #fff;
            font-size: 1em; /* Giảm kích thước chữ */
            line-height: 1.6;
            margin-bottom: 10px;
        }
        .popup-content .booking-info {
            background: rgba(0, 0, 0, 0.3);
            padding: 12px;
            border-radius: 8px;
            margin: 15px 0;
            border-left: 3px solid #e74c3c;
        }
        .popup-content .booking-info p {
            margin: 6px 0;
            font-size: 0.9em; /* Giảm kích thước chữ */
        }
        .popup-buttons {
            display: flex;
            gap: 10px; /* Giảm khoảng cách */
            margin-top: 20px;
        }
        .popup-buttons button {
            flex: 1;
            padding: 10px 15px; /* Giảm kích thước nút */
            border: none;
            border-radius: 8px;
            font-size: 0.95em; /* Giảm kích thước chữ */
            font予約
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            font-family: 'Montserrat', sans-serif;
        }
        .popup-buttons .confirm-yes {
            background: #e74c3c;
            color: white;
        }
        .popup-buttons .confirm-yes:hover {
            background: #c0392b;
        }
        .popup-buttons .confirm-no {
            background: #6c757d;
            color: white;
        }
        .popup-buttons .confirm-no:hover {
            background: #5a6268;
        }
        /* Thông báo lỗi */
        .error-message {
            background: rgba(231, 76, 60, 0.2);
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
            color: #e74c3c;
            text-align: center;
            font-size: 0.95em;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        /* Thông báo không có dữ liệu */
        .no-data {
            text-align: center;
            padding: 30px;
            font-size: 1.1em;
            color: rgba(255, 255, 255, 0.8);
        }
    </style>
</head>
<body>
<%
    Reservation reservation = (Reservation) request.getAttribute("reservation");
    List<Integer> tableIds = (List<Integer>) request.getAttribute("tableIds");
    String errorMessage = (String) request.getAttribute("errorMessage");
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
%>
<div class="container">
    <h2><i class="fas fa-ban"></i> Hủy đặt bàn</h2>
    <% if (errorMessage != null) { %>
    <div class="error-message">
        <i class="fas fa-exclamation-circle"></i> <%= errorMessage %>
    </div>
    <% } %>
    <% if (reservation == null) { %>
    <div class="no-data">
        <i class="fas fa-info-circle" style="font-size: 2em; margin-bottom: 15px; color: rgba(255, 255, 255, 0.5);"></i>
        <p>Không có thông tin đơn đặt bàn.</p>
        <a href="orderHistory" class="btn back-btn" title="Quay về lịch sử đặt bàn">
            <i class="fas fa-arrow-left"></i> Quay về lịch sử
        </a>
    </div>
    <% } else { %>
    <!-- CHÍNH SÁCH HỦY -->
    <div class="policy-section">
        <h3><i class="fas fa-info-circle"></i> Chính sách hủy đặt bàn</h3>
        <ul>
            <li>Miễn phí hủy nếu hủy trước 24 giờ so với giờ đặt bàn</li>
            <li>Không hoàn lại tiền đặt cọc nếu hủy sau giờ đặt bàn</li>
            <li>Vui lòng cung cấp lý do hủy để chúng tôi cải thiện dịch vụ</li>
        </ul>
    </div>
    <!-- Thông tin đơn đặt bàn -->
    <div class="policy-section" style="background: rgba(102, 126, 234, 0.1); border-color: rgba(102, 126, 234, 0.3);">
        <h3 style="color: #667eea;"><i class="fas fa-info-circle"></i> Thông tin đơn đặt bàn</h3>
        <ul style="list-style: none;">
            <li style="padding-left: 0;"><strong>Mã đơn:</strong> DB<%= String.format("%03d", reservation.getReservationId()) %></li>
            <li style="padding-left: 0;"><strong>Ngày:</strong> <%= reservation.getReservationDate() != null ? reservation.getReservationDate().format(dateFormatter) : "N/A" %></li>
            <li style="padding-left: 0;"><strong>Giờ:</strong> <%= reservation.getReservationTime() != null ? reservation.getReservationTime().format(timeFormatter) : "N/A" %></li>
            <li style="padding-left: 0;"><strong>Số người:</strong> <%= reservation.getGuestCount() %></li>
            <li style="padding-left: 0;"><strong>Trạng thái:</strong> <%= reservation.getStatus() %></li>
            <% if (tableIds != null && !tableIds.isEmpty()) { %>
            <li style="padding-left: 0;"><strong>Bàn:</strong>
                <% for (int i = 0; i < tableIds.size(); i++) { %>
                Bàn <%= tableIds.get(i) %><%= i < tableIds.size() - 1 ? ", " : "" %>
                <% } %>
            </li>
            <% } %>
        </ul>
    </div>
    <form id="cancelForm" method="post" action="cancelOrder">
        <input type="hidden" name="reservationId" value="<%= reservation.getReservationId() %>">
        <input type="hidden" name="reason" id="reasonInput" required>
        <label for="reasonSelect"><i class="fas fa-comment-alt"></i> Lý do hủy:</label>
        <select name="reasonSelect" id="reasonSelect" onchange="handleReasonChange()">
            <option value="">-- Chọn lý do --</option>
            <option value="Thay đổi kế hoạch">Thay đổi kế hoạch</option>
            <option value="Đặt nhầm thời gian">Đặt nhầm thời gian</option>
            <option value="Tìm được nhà hàng khác">Tìm được nhà hàng khác</option>
            <option value="Số lượng khách thay đổi">Số lượng khách thay đổi</option>
            <option value="Vấn đề sức khỏe">Vấn đề sức khỏe</option>
            <option value="other">Lý do khác</option>
        </select>
        <div id="otherReasonContainer" style="display: none;">
            <label for="otherReason"><i class="fas fa-edit"></i> Chi tiết lý do:</label>
            <textarea name="otherReason" id="otherReason" placeholder="Vui lòng nhập lý do cụ thể..." required></textarea>
        </div>
        <div class="actions">
            <a href="orderHistory" class="btn back-btn" title="Quay về lịch sử đặt bàn">
                <i class="fas fa-arrow-left"></i> Quay lại
            </a>
            <button type="button" class="btn cancel-btn" title="Xác nhận hủy đặt bàn" onclick="showConfirmPopup()">
                <i class="fas fa-times-circle"></i> Xác nhận hủy
            </button>
        </div>
    </form>
    <% } %>
</div>
<!-- POPUP XÁC NHẬN -->
<div class="popup-overlay" id="confirmPopup">
    <div class="popup-content">
        <h3><i class="fas fa-exclamation-triangle"></i> Xác nhận hủy bàn</h3>
        <p>Bạn có chắc chắn muốn hủy đặt bàn này không?</p>
        <div class="booking-info" id="popupBookingInfo">
            <% if (reservation != null) { %>
            <p><strong><i class="fas fa-hashtag"></i> Mã đặt bàn:</strong> DB<%= String.format("%03d", reservation.getReservationId()) %></p>
            <p><strong><i class="fas fa-calendar-alt"></i> Ngày:</strong> <%= reservation.getReservationDate() != null ? reservation.getReservationDate().format(dateFormatter) : "N/A" %></p>
            <p><strong><i class="fas fa-clock"></i> Giờ:</strong> <%= reservation.getReservationTime() != null ? reservation.getReservationTime().format(timeFormatter) : "N/A" %></p>
            <p><strong><i class="fas fa-users"></i> Số người:</strong> <%= reservation.getGuestCount() %></p>
            <p><strong><i class="fas fa-comment"></i> Lý do:</strong> <span id="popupReason">-</span></p>
            <% } %>
        </div>
        <p style="color: #ffc107; font-size: 0.9em;">
            <i class="fas fa-info-circle"></i> Lưu ý: Vui lòng xem chính sách hủy phía trên để biết chi tiết về phí hủy.
        </p>
        <div class="popup-buttons">
            <button class="confirm-no" title="Giữ lại đặt bàn" onclick="closeConfirmPopup()">
                <i class="fas fa-times"></i> Không, giữ lại
            </button>
            <button class="confirm-yes" title="Xác nhận hủy đặt bàn" onclick="submitCancellation()">
                <i class="fas fa-check"></i> Có, hủy
            </button>
        </div>
    </div>
</div>
<script>
    const reasonSelect = document.getElementById('reasonSelect');
    const reasonInput = document.getElementById('reasonInput');
    const otherReasonContainer = document.getElementById('otherReasonContainer');
    const otherReasonTextarea = document.getElementById('otherReason');
    const confirmPopup = document.getElementById('confirmPopup');

    function handleReasonChange() {
        if (reasonSelect.value === 'other') {
            otherReasonContainer.style.display = 'block';
            otherReasonTextarea.required = true;
            reasonInput.value = '';
        } else {
            otherReasonContainer.style.display = 'none';
            otherReasonTextarea.required = false;
            otherReasonTextarea.value = '';
            reasonInput.value = reasonSelect.value;
        }
    }

    function showConfirmPopup() {
        // Lấy lý do hủy
        let reason = reasonSelect.value;
        if (reason === 'other') {
            reason = otherReasonTextarea.value.trim();
            if (!reason) {
                alert('Vui lòng nhập lý do hủy.');
                return;
            }
        } else if (!reason || reason === '') {
            alert('Vui lòng chọn lý do hủy.');
            return;
        }
        reasonInput.value = reason;
        // Cập nhật lý do trong popup
        document.getElementById('popupReason').textContent = reason || 'Không xác định';
        // Hiển thị popup
        confirmPopup.classList.add('show');
    }

    function closeConfirmPopup() {
        confirmPopup.classList.remove('show');
    }

    function submitCancellation() {
        // Gửi form đến server
        const form = document.getElementById('cancelForm');
        form.submit();
    }

    // Đóng popup khi click ra ngoài
    confirmPopup.addEventListener('click', function(e) {
        if (e.target === confirmPopup) {
            closeConfirmPopup();
        }
    });

    // Tự động ẩn thông báo lỗi sau 5 giây
    window.addEventListener('DOMContentLoaded', function() {
        const errorMsg = document.querySelector('.error-message');
        if (errorMsg) {
            setTimeout(function() {
                errorMsg.style.transition = 'opacity 0.5s';
                errorMsg.style.opacity = '0';
                setTimeout(() => errorMsg.remove(), 500);
            }, 5000);
        }
    });
</script>
</body>
</html>