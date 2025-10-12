<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.time.LocalDate" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Find a Table</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
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
        .form-group input:focus, .form-group select:focus, .form-group textarea:focus {
            outline: none;
        }
        .form-group textarea {
            resize: vertical;
            min-height: 60px;
            font-size: 0.95em;
        }
        .form-group textarea::placeholder {
            color: rgba(255, 255, 255, 0.5);
        }
        input::-webkit-calendar-picker-indicator {
            filter: invert(1);
            cursor: pointer;
        }
        .form-group select option { background: #5e1717; }

        .guest-stepper {
            display: flex;
            align-items: center;
            justify-content: space-between;
            width: 100%;
        }
        .guest-stepper button {
            background: none;
            border: 1px solid white;
            color: white;
            width: 30px;
            height: 30px;
            border-radius: 50%;
            font-size: 1.2em;
            cursor: pointer;
            transition: background 0.2s;
        }
        .guest-stepper button:hover { background: rgba(255,255,255,0.2); }
        .guest-stepper input[type="number"] {
            text-align: center;
            -moz-appearance: textfield;
        }
        .guest-stepper input::-webkit-outer-spin-button,
        .guest-stepper input::-webkit-inner-spin-button {
            -webkit-appearance: none;
            margin: 0;
        }

        /* ƯU ĐÃI */
        .promotion-section {
            grid-column: 1 / -1;
            background: rgba(255, 193, 7, 0.15);
            border: 2px solid rgba(255, 193, 7, 0.5);
            border-radius: 8px;
            padding: 20px;
            margin-top: 10px;
        }
        .promotion-section h3 {
            color: #ffc107;
            font-size: 1.1em;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .promotion-cards {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }
        .promo-card {
            background: rgba(0, 0, 0, 0.3);
            border: 2px solid transparent;
            border-radius: 8px;
            padding: 15px;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
        }
        .promo-card:hover {
            border-color: #ffc107;
            transform: translateY(-2px);
        }
        .promo-card.selected {
            border-color: #ffc107;
            background: rgba(255, 193, 7, 0.2);
        }
        .promo-card input[type="radio"] {
            position: absolute;
            opacity: 0;
        }
        .promo-title {
            font-weight: 700;
            font-size: 1em;
            margin-bottom: 5px;
            color: #ffc107;
        }
        .promo-desc {
            font-size: 0.85em;
            color: rgba(255, 255, 255, 0.8);
        }

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
    </style>
</head>
<body>
<div class="bg-container">
    <div class="booking-box">
        <h2>FIND A TABLE</h2>
        <form class="search-form" method="get" action="findTable">

            <div class="form-group">
                <label for="date">Date:</label>
                <div class="input-with-icon">
                    <i class="fas fa-calendar-alt"></i>
                    <input type="date" id="date" name="date" required value="<%= LocalDate.now() %>">
                </div>
            </div>

            <div class="form-group">
                <label for="time">Time:</label>
                <div class="input-with-icon">
                    <i class="fas fa-clock"></i>
                    <select id="time" name="time" required>
                        <option value="17:00">5:00 PM</option>
                        <option value="17:30">5:30 PM</option>
                        <option value="18:00">6:00 PM</option>
                        <option value="18:30">6:30 PM</option>
                        <option value="19:00" selected>7:00 PM</option>
                        <option value="19:30">7:30 PM</option>
                        <option value="20:00">8:00 PM</option>
                        <option value="20:30">8:30 PM</option>
                        <option value="21:00">9:00 PM</option>
                    </select>
                </div>
            </div>

            <div class="form-group full-width">
                <label for="guests">Guests:</label>
                <div class="input-with-icon">
                    <i class="fas fa-user-friends"></i>
                    <div class="guest-stepper">
                        <button type="button" id="minus-btn">-</button>
                        <input type="number" id="guests" name="guests" min="1" max="20" value="2" readonly>
                        <button type="button" id="plus-btn">+</button>
                    </div>
                </div>
            </div>

            <!-- LOẠI HÌNH ĐẶT TIỆC -->
            <div class="form-group full-width">
                <label for="eventType">Loại hình đặt chỗ:</label>
                <div class="input-with-icon">
                    <i class="fas fa-star"></i>
                    <select id="eventType" name="eventType">
                        <option value="regular">Ăn thường</option>
                        <option value="birthday">Sinh nhật</option>
                        <option value="anniversary">Kỷ niệm</option>
                        <option value="business">Tiệc công ty</option>
                        <option value="date">Hẹn hò</option>
                        <option value="family">Họp gia đình</option>
                        <option value="other">Khác</option>
                    </select>
                </div>
            </div>

            <!-- YÊU CẦU ĐẶC BIỆT -->
            <div class="form-group full-width">
                <label for="specialRequest">Yêu cầu đặc biệt (tùy chọn):</label>
                <div class="input-with-icon" style="align-items: flex-start; padding-top: 5px;">
                    <i class="fas fa-comment-dots"></i>
                    <textarea id="specialRequest" name="specialRequest" placeholder="VD: Bàn gần cửa sổ, cần ghế em bé, không dùng hành..."></textarea>
                </div>
            </div>

            <!-- ƯU ĐÃI -->
            <div class="promotion-section">
                <h3><i class="fas fa-gift"></i> Chọn ưu đãi (tùy chọn)</h3>
                <div class="promotion-cards">
                    <label class="promo-card">
                        <input type="radio" name="promotion" value="none" checked>
                        <div class="promo-title">Không áp dụng</div>
                        <div class="promo-desc">Không sử dụng ưu đãi</div>
                    </label>

                    <label class="promo-card">
                        <input type="radio" name="promotion" value="lunch">
                        <div class="promo-title">Giảm 15% Giờ vàng</div>
                        <div class="promo-desc">11:00 - 14:00 các ngày trong tuần</div>
                    </label>

                    <label class="promo-card">
                        <input type="radio" name="promotion" value="happy_hour">
                        <div class="promo-title">Happy Hour 20%</div>
                        <div class="promo-desc">17:00 - 18:30 hàng ngày</div>
                    </label>

                    <label class="promo-card">
                        <input type="radio" name="promotion" value="birthday">
                        <div class="promo-title">Sinh nhật miễn phí</div>
                        <div class="promo-desc">Tặng bánh sinh nhật + 10% off</div>
                    </label>
                </div>
            </div>

            <button type="submit" class="search-btn">Find Available Tables</button>
        </form>
    </div>
</div>

<script>
    const minusBtn = document.getElementById('minus-btn');
    const plusBtn = document.getElementById('plus-btn');
    const guestsInput = document.getElementById('guests');

    minusBtn.addEventListener('click', () => {
        let currentValue = parseInt(guestsInput.value);
        if (currentValue > 1) {
            guestsInput.value = currentValue - 1;
        }
    });

    plusBtn.addEventListener('click', () => {
        let currentValue = parseInt(guestsInput.value);
        if (currentValue < 20) {
            guestsInput.value = currentValue + 1;
        }
    });

    // Xử lý chọn ưu đãi
    const promoCards = document.querySelectorAll('.promo-card');
    const promoRadios = document.querySelectorAll('input[name="promotion"]');

    promoRadios.forEach(radio => {
        radio.addEventListener('change', function() {
            promoCards.forEach(card => card.classList.remove('selected'));
            this.closest('.promo-card').classList.add('selected');
        });
    });

    // Click vào card để chọn
    promoCards.forEach(card => {
        card.addEventListener('click', function() {
            const radio = this.querySelector('input[type="radio"]');
            radio.checked = true;
            radio.dispatchEvent(new Event('change'));
        });
    });

    // Đánh dấu card đầu tiên khi load
    document.querySelector('.promo-card').classList.add('selected');
</script>
</body>
</html>