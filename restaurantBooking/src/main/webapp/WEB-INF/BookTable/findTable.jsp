<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tìm Bàn</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        /* Copy tất cả CSS từ file gốc */
        body, html {
            margin: 0;
            padding: 0;
            min-height: 100%;
            font-family: 'Montserrat', sans-serif;
            color: white;
        }
        .bg-container {
            background-image: url('https://images.unsplash.com/photo-1555939594-58d7cb561ad1?q=80&w=1974&auto=format&fit=crop');
            min-height: 100vh;
            background-position: center;
            background-repeat: no-repeat;
            background-size: cover;
            background-attachment: fixed;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 40px 20px;
        }
        .booking-box {
            background-color: rgba(94, 23, 23, 0.85);
            padding: 40px 50px;
            border-radius: 10px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.5);
            width: 100%;
            max-width: 650px;
        }
        .booking-box h2 {
            text-align: center;
            font-size: 2.5em;
            margin-bottom: 30px;
            letter-spacing: 2px;
            font-weight: 700;
        }
        .search-form {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 25px 35px;
        }
        .form-group {
            display: flex;
            flex-direction: column;
        }
        .form-group.full-width {
            grid-column: 1 / -1;
        }
        .form-group label {
            font-size: 0.8em;
            text-transform: uppercase;
            color: #ddd;
            margin-bottom: 8px;
            letter-spacing: 1px;
        }
        .input-with-icon {
            display: flex;
            align-items: center;
            border-bottom: 2px solid rgba(255, 255, 255, 0.5);
            padding-bottom: 5px;
        }
        .input-with-icon i {
            margin-right: 12px;
            font-size: 1.1em;
        }
        .form-group input, .form-group select, .form-group textarea {
            background: transparent;
            border: none;
            color: white;
            font-size: 1.1em;
            font-family: 'Montserrat', sans-serif;
            width: 100%;
        }
        .form-group select option { background: #5e1717; }
        .search-btn {
            grid-column: 1 / -1;
            padding: 15px;
            background: #e74c3c;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: bold;
            font-size: 1.2em;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-top: 15px;
            transition: background 0.3s ease;
        }
        .search-btn:hover { background: #c0392b; }
        .error-message {
            color: #e74c3c;
            text-align: center;
            padding: 10px;
            margin-bottom: 15px;
            background: rgba(231, 76, 60, 0.1);
            border-radius: 5px;
        }
    </style>
</head>
<body>
<div class="bg-container">
    <div class="booking-box">
        <h2>TÌM BÀN</h2>

        <!-- Hiển thị lỗi nếu có -->
        <% String errorMessage = (String)request.getAttribute("errorMessage"); %>
        <% if (errorMessage != null) { %>
        <div class="error-message">
            <%= errorMessage %>
        </div>
        <% } %>

        <form class="search-form" method="post" action="findTable">
            <!-- Ngày -->
            <div class="form-group">
                <label for="date">Ngày:</label>
                <div class="input-with-icon">
                    <i class="fas fa-calendar-alt"></i>
                    <input type="date" id="date" name="date" required>
                </div>
            </div>

            <!-- Giờ -->
            <div class="form-group">
                <label for="time">Giờ:</label>
                <div class="input-with-icon">
                    <i class="fas fa-clock"></i>
                    <select id="time" name="time" required>
                        <option value="11:00">11:00 AM</option>
                        <option value="11:30">11:30 AM</option>
                        <option value="12:00">12:00 PM</option>
                        <option value="12:30">12:30 PM</option>
                        <option value="17:00">5:00 PM</option>
                        <option value="17:30">5:30 PM</option>
                        <option value="18:00" selected>6:00 PM</option>
                        <option value="18:30">6:30 PM</option>
                        <option value="19:00">7:00 PM</option>
                        <option value="19:30">7:30 PM</option>
                        <option value="20:00">8:00 PM</option>
                    </select>
                </div>
            </div>

            <!-- Số khách -->
            <div class="form-group full-width">
                <label for="guests">Số Khách:</label>
                <div class="input-with-icon">
                    <i class="fas fa-user-friends"></i>
                    <div style="display: flex; align-items: center; gap: 10px; width: 100%;">
                        <button type="button" id="minus-btn" style="background: none; border: 1px solid white; color: white; width: 30px; height: 30px; border-radius: 50%; cursor: pointer;">-</button>
                        <input type="number" id="guests" name="guests" min="1" max="20" value="2" readonly style="flex: 1; text-align: center;">
                        <button type="button" id="plus-btn" style="background: none; border: 1px solid white; color: white; width: 30px; height: 30px; border-radius: 50%; cursor: pointer;">+</button>
                    </div>
                </div>
            </div>

            <!-- Tầng -->
            <div class="form-group">
                <label for="floor">Tầng:</label>
                <div class="input-with-icon">
                    <i class="fas fa-layer-group"></i>
                    <select id="floor" name="floor">
                        <option value="1">Tầng 1</option>
                        <option value="2">Tầng 2</option>
                        <option value="3">Tầng 3</option>
                        <option value="4">Tầng 4</option>
                    </select>
                </div>
            </div>

            <!-- Loại sự kiện -->
            <div class="form-group">
                <label for="eventType">Loại Sự Kiện:</label>
                <div class="input-with-icon">
                    <i class="fas fa-star"></i>
                    <select id="eventType" name="eventType">
                        <option value="regular">Ăn thường</option>
                        <option value="birthday">Sinh nhật</option>
                        <option value="anniversary">Kỷ niệm</option>
                        <option value="business">Tiệc công ty</option>
                        <option value="family">Hợp gia đình</option>
                    </select>
                </div>
            </div>

            <!-- Yêu cầu đặc biệt -->
            <div class="form-group full-width">
                <label for="specialRequest">Yêu Cầu Đặc Biệt (tùy chọn):</label>
                <div class="input-with-icon" style="align-items: flex-start; padding-top: 5px;">
                    <i class="fas fa-comment-dots"></i>
                    <textarea id="specialRequest" name="specialRequest" style="min-height: 60px; resize: vertical;"></textarea>
                </div>
            </div>

            <button type="submit" class="search-btn">Tìm Bàn Trống</button>
        </form>
    </div>
</div>

<script>
    const minusBtn = document.getElementById('minus-btn');
    const plusBtn = document.getElementById('plus-btn');
    const guestsInput = document.getElementById('guests');
    const dateInput = document.getElementById('date');

    // Set default date to today
    const today = new Date().toISOString().split('T')[0];
    dateInput.value = today;
    dateInput.min = today;

    minusBtn.addEventListener('click', (e) => {
        e.preventDefault();
        let currentValue = parseInt(guestsInput.value);
        if (currentValue > 1) {
            guestsInput.value = currentValue - 1;
        }
    });

    plusBtn.addEventListener('click', (e) => {
        e.preventDefault();
        let currentValue = parseInt(guestsInput.value);
        if (currentValue < 20) {
            guestsInput.value = currentValue + 1;
        }
    });
</script>
</body>
</html>