<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.fpt.restaurantbooking.models.Reservation" %>
<%@ page import="com.fpt.restaurantbooking.models.Payment" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.temporal.ChronoUnit" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hủy đặt bàn</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/theme.css">

    <style>
        /* --- General Reset & Body Styling --- */
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body, html {
            font-family: 'Montserrat', sans-serif;
            background-image: linear-gradient(var(--bg-overlay), var(--bg-overlay)), url('https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?q=80&w=2070&auto=format&fit=crop');
            background-position: center;
            background-size: cover;
            background-attachment: fixed;
            color: var(--text-primary);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
            transition: background 0.3s ease, color 0.3s ease;
        }

        .container {
            width: 90%;
            max-width: 700px;
            background-color: var(--box-bg);
            backdrop-filter: blur(8px);
            padding: 30px;
            border-radius: 15px;
            box-shadow: var(--shadow);
            border: 1px solid var(--input-border);
            transition: all 0.3s ease;
        }

        h2 {
            text-align: center;
            margin-bottom: 30px;
            color: var(--text-primary);
            font-size: 2.5em;
            font-weight: 700;
            letter-spacing: 2px;
            text-transform: uppercase;
            text-shadow: 2px 2px 8px rgba(0,0,0,0.5);
            transition: color 0.3s ease;
        }

        form {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        label {
            font-size: 1.1em;
            font-weight: 600;
            color: var(--text-primary);
            display: flex;
            align-items: center;
            gap: 10px;
            transition: color 0.3s ease;
        }

        select, textarea {
            padding: 12px 15px;
            border: 1px solid var(--input-border);
            border-radius: 8px;
            font-size: 1em;
            background: var(--table-bg);
            color: var(--text-primary);
            font-family: 'Montserrat', sans-serif;
            outline: none;
            transition: all 0.3s ease;
        }

        select:focus, textarea:focus {
            border-color: #e74c3c;
        }

        textarea {
            min-height: 120px;
            resize: vertical;
        }

        option {
            background-color: var(--box-bg);
            color: var(--text-primary);
        }

        body.light-mode option {
            background-color: #fff;
            color: #2c3e50;
        }

        /* CHÍNH SÁCH HỦY */
        .policy-section {
            background: rgba(231, 76, 60, 0.1);
            border: 1px solid rgba(231, 76, 60, 0.3);
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
        }

        .policy-section h3 {
            color: #e74c3c;
            font-size: 1.2em;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .policy-section ul {
            list-style: none;
            padding-left: 0;
        }

        .policy-section li {
            padding: 8px 0;
            padding-left: 25px;
            position: relative;
            line-height: 1.6;
            color: rgba(255, 255, 255, 0.9);
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
            gap: 15px;
            margin-top: 20px;
        }

        .btn {
            border: none;
            padding: 14px 28px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 1.05em;
            font-weight: 600;
            transition: background-color 0.3s ease, transform 0.2s ease, box-shadow 0.2s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 10px rgba(0,0,0,0.2);
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
            padding: 35px;
            border-radius: 15px;
            box-shadow: 0 10px 50px rgba(0, 0, 0, 0.5);
            border: 2px solid rgba(231, 76, 60, 0.5);
            max-width: 500px;
            width: 90%;
            animation: popupSlideIn 0.3s ease;
        }

        @keyframes popupSlideIn {
            from {
                opacity: 0;
                transform: translateY(-50px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .popup-content h3 {
            color: #e74c3c;
            font-size: 1.8em;
            margin-bottom: 20px;
            text-align: center;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        .popup-content p {
            color: #fff;
            font-size: 1.1em;
            line-height: 1.8;
            margin-bottom: 15px;
        }

        .popup-content .booking-info {
            background: rgba(0, 0, 0, 0.3);
            padding: 15px;
            border-radius: 8px;
            margin: 20px 0;
            border-left: 4px solid #e74c3c;
        }

        .popup-content .booking-info p {
            margin: 8px 0;
            font-size: 1em;
        }

        .popup-buttons {
            display: flex;
            gap: 15px;
            margin-top: 25px;
        }

        .popup-buttons button {
            flex: 1;
            padding: 12px 20px;
            border: none;
            border-radius: 8px;
            font-size: 1em;
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

    </style>
</head>
<body>
<!-- Theme Toggle Button -->
<button class="theme-toggle" id="themeToggle" onclick="toggleTheme()">
    <i class="fas fa-moon" id="themeIcon"></i>
    <span id="themeText">Chế độ tối</span>
</button>

<%
    Reservation reservation = (Reservation) request.getAttribute("reservation");
    List<Integer> tableIds = (List<Integer>) request.getAttribute("tableIds");
    Payment payment = (Payment) request.getAttribute("payment");
    String errorMessage = (String) request.getAttribute("errorMessage");

    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");

    // Tính tiền đặt cọc
    int tableCount = (tableIds != null) ? tableIds.size() : 0;
    long depositAmount = 0;
    boolean hasDeposit = false;
    if (payment != null && "CASH".equals(payment.getPaymentMethod()) && tableCount > 0) {
        depositAmount = tableCount * 20000L; // 20,000 VNĐ per table
        hasDeposit = true;
    }

    // Kiểm tra nếu hủy sau thời gian đặt bàn
    boolean isCancellingAfterReservationTime = false;
    if (reservation != null && reservation.getReservationDate() != null && reservation.getReservationTime() != null) {
        LocalDateTime reservationDateTime = reservation.getReservationDate().atTime(reservation.getReservationTime());
        LocalDateTime now = LocalDateTime.now();
        isCancellingAfterReservationTime = now.isAfter(reservationDateTime);
    }
%>

<div class="container">
    <h2><i class="fas fa-ban"></i> Hủy đặt bàn</h2>

    <% if (errorMessage != null) { %>
    <div style="background: rgba(231, 76, 60, 0.2); padding: 15px; border-radius: 8px; margin-bottom: 20px; color: #e74c3c; text-align: center;">
        <i class="fas fa-exclamation-circle"></i> <%= errorMessage %>
    </div>
    <% } %>

    <% if (reservation == null) { %>
    <div style="text-align: center; padding: 40px;">
        <p>Không có thông tin đơn đặt bàn.</p>
        <a href="orderHistory" class="btn back-btn" style="margin-top: 20px;">
            <i class="fas fa-arrow-left"></i> Quay về lịch sử
        </a>
    </div>
    <% } else { %>

    <!-- CHÍNH SÁCH HỦY -->
    <div class="policy-section">
        <h3><i class="fas fa-info-circle"></i> Chính sách hủy đặt bàn</h3>
        <ul>
            <li>Miễn phí hủy nếu hủy trước 24 giờ so với giờ đặt bàn</li>
            <li>Hủy trong vòng 12-24 giờ: Phí hủy 50,000 VNĐ</li>
            <li>Hủy trong vòng 12 giờ: Phí hủy 100,000 VNĐ</li>
            <li><strong style="color: #e74c3c;">⚠️ QUAN TRỌNG - Về tiền đặt cọc:</strong></li>
            <li style="padding-left: 40px;">Nếu bạn chọn thanh toán tại quán (COD), yêu cầu đặt cọc 20.000 VNĐ/bàn</li>
            <li style="padding-left: 40px;">Tiền cọc sẽ được hoàn lại khi bạn đến quán và thanh toán đầy đủ</li>
            <li style="padding-left: 40px;"><strong style="color: #ffc107;">Nếu hủy sau thời gian đặt bàn, tiền đặt cọc sẽ không được hoàn lại</strong></li>
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
            <% if (hasDeposit) { %>
            <li style="padding-left: 0;">
                <strong style="color: #ffc107;">
                    <i class="fas fa-money-bill-wave"></i> Tiền đặt cọc:
                    <%= String.format("%,d", depositAmount) %> VNĐ (<%= tableCount %> bàn × 20.000 VNĐ/bàn)
                </strong>
            </li>
            <% if (isCancellingAfterReservationTime) { %>
            <li style="padding-left: 0; color: #e74c3c; font-weight: 600;">
                <i class="fas fa-exclamation-triangle"></i>
                ⚠️ CẢNH BÁO: Bạn đang hủy sau thời gian đặt bàn. Tiền đặt cọc sẽ KHÔNG được hoàn lại!
            </li>
            <% } %>
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
            <textarea name="otherReason" id="otherReason" placeholder="Vui lòng nhập lý do cụ thể..."></textarea>
        </div>

        <div class="actions">
            <a href="orderHistory" class="btn back-btn"><i class="fas fa-arrow-left"></i> Quay lại</a>
            <button type="button" class="btn cancel-btn" onclick="showConfirmPopup()"><i class="fas fa-times-circle"></i> Xác nhận hủy</button>
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

        <% if (hasDeposit) { %>
        <div style="background: rgba(255, 193, 7, 0.2); padding: 15px; border-radius: 8px; margin: 15px 0; border-left: 4px solid #ffc107;">
            <p style="color: #ffc107; font-weight: 600; margin-bottom: 10px;">
                <i class="fas fa-exclamation-triangle"></i> Lưu ý về tiền đặt cọc:
            </p>
            <ul style="color: #fff; margin-left: 20px; line-height: 1.8;">
                <li>Bạn đã đặt cọc: <strong><%= String.format("%,d", depositAmount) %> VNĐ</strong></li>
                <% if (isCancellingAfterReservationTime) { %>
                <li style="color: #e74c3c; font-weight: 600;">
                    ⚠️ Vì bạn hủy sau thời gian đặt bàn, tiền đặt cọc sẽ KHÔNG được hoàn lại!
                </li>
                <% } else { %>
                <li>Tiền đặt cọc sẽ được hoàn lại khi bạn đến quán và thanh toán đầy đủ</li>
                <li>Nếu hủy sau thời gian đặt bàn, tiền đặt cọc sẽ không được hoàn lại</li>
                <% } %>
            </ul>
        </div>
        <% } %>
        <p style="color: #ffc107; font-size: 0.95em;">
            <i class="fas fa-info-circle"></i> Lưu ý: Vui lòng xem chính sách hủy phía trên để biết chi tiết về phí hủy.
        </p>

        <div class="popup-buttons">
            <button class="confirm-no" onclick="closeConfirmPopup()">
                <i class="fas fa-times"></i> Không, giữ đặt bàn
            </button>
            <button class="confirm-yes" onclick="submitCancellation()">
                <i class="fas fa-check"></i> Có, xác nhận hủy
            </button>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/theme-manager.js"></script>
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
        document.getElementById('popupReason').textContent = reason;

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
</script>
</body>
</html>
