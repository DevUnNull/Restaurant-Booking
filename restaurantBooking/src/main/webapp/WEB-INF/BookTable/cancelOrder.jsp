<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map, java.util.LinkedHashMap, java.util.List, java.util.ArrayList" %>
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
            /* THAY THẾ BẰNG URL ẢNH NỀN CỦA BẠN */
            background-image: linear-gradient(rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.6)), url('https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?q=80&w=2070&auto=format&fit=crop');
            background-position: center;
            background-size: cover;
            background-attachment: fixed;
            color: #f0f0f0;
            min-height: 100vh;
            display: flex; /* Dùng flexbox để căn giữa nội dung */
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        .container {
            width: 90%;
            max-width: 700px; /* Tăng chiều rộng để chứa chính sách */
            background-color: rgba(20, 10, 10, 0.75); /* Frosted glass effect */
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
            font-size: 2.5em;
            font-weight: 700;
            letter-spacing: 2px;
            text-transform: uppercase;
            text-shadow: 2px 2px 8px rgba(0,0,0,0.5);
        }

        form {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        label {
            font-size: 1.1em;
            font-weight: 600;
            color: #fff;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        select, textarea {
            padding: 12px 15px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 8px;
            font-size: 1em;
            background: rgba(0, 0, 0, 0.4); /* Darker background for inputs */
            color: #fff;
            font-family: 'Montserrat', sans-serif;
            outline: none;
            transition: border-color 0.3s ease;
            -webkit-appearance: none; /* Remove default dropdown arrow on WebKit browsers */
            -moz-appearance: none; /* Remove default dropdown arrow on Firefox */
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='%23e74c3c'%3E%3Cpath d='M7 10l5 5 5-5z'/%3E%3C/svg%3E"); /* Custom arrow for select */
            background-repeat: no-repeat;
            background-position: right 15px center;
            background-size: 20px;
        }

        select:focus, textarea:focus {
            border-color: #e74c3c; /* Accent color on focus */
        }

        textarea {
            min-height: 120px;
            resize: vertical; /* Allow vertical resizing */
            background-image: none;
        }

        option {
            background-color: #333; /* Dark background for options */
            color: #fff;
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
            justify-content: flex-end; /* Căn nút Hủy sang phải */
            gap: 15px; /* Khoảng cách giữa các nút */
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
            text-decoration: none; /* Cho thẻ <a> */
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 10px rgba(0,0,0,0.2);
        }

        .cancel-btn {
            background: #e74c3c; /* Màu đỏ nổi bật cho hủy */
            color: white;
        }
        .cancel-btn:hover {
            background: #c0392b;
        }

        .back-btn {
            background-color: #6c757d; /* Màu xám cho nút quay lại */
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
<div class="container">
    <h2><i class="fas fa-ban"></i> Hủy đặt bàn</h2>

    <!-- CHÍNH SÁCH HỦY -->
    <div class="policy-section">
        <h3><i class="fas fa-info-circle"></i> Chính sách hủy đặt bàn</h3>
        <ul>
            <li>Miễn phí hủy nếu hủy trước 24 giờ so với giờ đặt bàn</li>
            <li>Hủy trong vòng 12-24 giờ: Phí hủy 50,000 VNĐ</li>
            <li>Hủy trong vòng 12 giờ: Phí hủy 100,000 VNĐ</li>
            <li>Không hoàn lại tiền đặt cọc nếu hủy sau giờ đặt bàn</li>
            <li>Vui lòng cung cấp lý do hủy để chúng tôi cải thiện dịch vụ</li>
        </ul>
    </div>

    <form id="cancelForm">
        <label for="bookingId"><i class="fas fa-clipboard-list"></i> Chọn đơn đặt bàn muốn hủy:</label>
        <select name="bookingId" id="bookingId" required>
            <option value="">-- Chọn đơn đặt bàn --</option>
            <%
                // Dữ liệu giả định cho các đơn hàng có thể hủy
                // Trong thực tế, bạn sẽ lấy từ database những đơn có trạng thái 'pending' hoặc 'confirmed'
                Map<String, List<Object>> allOrdersData = (Map<String, List<Object>>) session.getAttribute("allOrdersData");
                if (allOrdersData == null) {
                    // Khởi tạo dữ liệu mẫu nếu chưa có (tương tự trang chi tiết)
                    allOrdersData = new LinkedHashMap<>();
                    List<Object> order1 = new ArrayList<>();
                    order1.add("2025-09-15"); order1.add("18:30"); order1.add("Bàn 05"); order1.add(4); order1.add("pending"); order1.add("GIAM10"); order1.add(new LinkedHashMap<String, Object[]>());
                    allOrdersData.put("DB001", order1);

                    List<Object> order2 = new ArrayList<>();
                    order2.add("2025-09-10"); order2.add("12:00"); order2.add("Bàn 02"); order2.add(2); order2.add("confirmed"); order2.add(null); order2.add(new LinkedHashMap<String, Object[]>());
                    allOrdersData.put("DB002", order2);

                    List<Object> order3 = new ArrayList<>();
                    order3.add("2025-09-05"); order3.add("19:00"); order3.add("Bàn 08"); order3.add(6); order3.add("done"); order3.add("GIAM10"); order3.add(new LinkedHashMap<String, Object[]>());
                    allOrdersData.put("DB003", order3);

                    session.setAttribute("allOrdersData", allOrdersData);
                }

                // Lọc ra các đơn hàng có thể hủy (pending hoặc confirmed)
                for (Map.Entry<String, List<Object>> entry : allOrdersData.entrySet()) {
                    String orderId = entry.getKey();
                    List<Object> orderData = entry.getValue();
                    String status = (String) orderData.get(4);

                    if ("pending".equals(status) || "confirmed".equals(status)) {
                        String orderDate = (String) orderData.get(0);
                        String orderTime = (String) orderData.get(1);
                        String tableNumber = (String) orderData.get(2);
                        int guests = (int) orderData.get(3);
                        out.println("<option value=\"" + orderId + "\" data-date=\"" + orderDate + "\" data-time=\"" + orderTime + "\" data-table=\"" + tableNumber + "\" data-guests=\"" + guests + "\">" + orderId + " - " + tableNumber + " - " + orderTime + " (" + orderDate + ")</option>");
                    }
                }
            %>
        </select>

        <label for="reasonSelect"><i class="fas fa-comment-alt"></i> Lý do hủy:</label>
        <select name="reasonSelect" id="reasonSelect" required>
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
            <a href="lichsudat.jsp" class="btn back-btn"><i class="fas fa-arrow-left"></i> Quay lại</a>
            <button type="button" class="btn cancel-btn" onclick="showConfirmPopup()"><i class="fas fa-times-circle"></i> Xác nhận hủy</button>
        </div>
    </form>
</div>

<!-- POPUP XÁC NHẬN -->
<div class="popup-overlay" id="confirmPopup">
    <div class="popup-content">
        <h3><i class="fas fa-exclamation-triangle"></i> Xác nhận hủy bàn</h3>
        <p>Bạn có chắc chắn muốn hủy đặt bàn này không?</p>

        <div class="booking-info" id="popupBookingInfo">
            <!-- Thông tin đặt bàn sẽ được điền vào đây bằng JavaScript -->
        </div>

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

<script>
    const reasonSelect = document.getElementById('reasonSelect');
    const otherReasonContainer = document.getElementById('otherReasonContainer');
    const otherReasonTextarea = document.getElementById('otherReason');
    const bookingSelect = document.getElementById('bookingId');
    const confirmPopup = document.getElementById('confirmPopup');
    const popupBookingInfo = document.getElementById('popupBookingInfo');

    // Hiển thị textarea khi chọn "Lý do khác"
    reasonSelect.addEventListener('change', function() {
        if (this.value === 'other') {
            otherReasonContainer.style.display = 'block';
            otherReasonTextarea.required = true;
        } else {
            otherReasonContainer.style.display = 'none';
            otherReasonTextarea.required = false;
            otherReasonTextarea.value = '';
        }
    });

    function showConfirmPopup() {
        // Kiểm tra form hợp lệ
        const form = document.getElementById('cancelForm');
        if (!form.checkValidity()) {
            form.reportValidity();
            return;
        }

        // Lấy thông tin đặt bàn được chọn
        const selectedOption = bookingSelect.options[bookingSelect.selectedIndex];
        const bookingId = selectedOption.value;
        const date = selectedOption.getAttribute('data-date');
        const time = selectedOption.getAttribute('data-time');
        const table = selectedOption.getAttribute('data-table');
        const guests = selectedOption.getAttribute('data-guests');

        // Lấy lý do hủy
        let reason = reasonSelect.value;
        if (reason === 'other') {
            reason = otherReasonTextarea.value;
        }

        // Điền thông tin vào popup
        popupBookingInfo.innerHTML = `
                <p><strong><i class="fas fa-hashtag"></i> Mã đặt bàn:</strong> ${bookingId}</p>
                <p><strong><i class="fas fa-calendar-alt"></i> Ngày:</strong> ${date}</p>
                <p><strong><i class="fas fa-clock"></i> Giờ:</strong> ${time}</p>
                <p><strong><i class="fas fa-chair"></i> Bàn:</strong> ${table}</p>
                <p><strong><i class="fas fa-users"></i> Số người:</strong> ${guests}</p>
                <p><strong><i class="fas fa-comment"></i> Lý do:</strong> ${reason}</p>
            `;

        // Hiển thị popup
        confirmPopup.classList.add('show');
    }

    function closeConfirmPopup() {
        confirmPopup.classList.remove('show');
    }

    function submitCancellation() {
        // Gửi form đến server
        const form = document.getElementById('cancelForm');
        form.action = 'xulyhuydatban.jsp';
        form.method = 'post';
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