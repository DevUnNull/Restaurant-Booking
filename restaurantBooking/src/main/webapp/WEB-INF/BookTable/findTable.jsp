<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
<head>
    <meta charset="UTF-8">
    <title>Tìm Bàn</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        /* === THEME VARIABLES === */
        :root {
            /* Dark Mode (Default) */
            --bg-overlay: rgba(0, 0, 0, 0.6);
            --text-primary: #ffffff;
            --text-secondary: #dddddd;
            --box-bg: rgba(94, 23, 23, 0.85);
            --input-border: rgba(255, 255, 255, 0.5);
            --error-bg: rgba(231, 76, 60, 0.1);
            --error-text: #e74c3c;
        }

        body.light-mode {
            /* Light Mode */
            --bg-overlay: rgba(255, 255, 255, 0.92);
            --text-primary: #2c3e50;
            --text-secondary: #34495e;
            --box-bg: rgba(255, 255, 255, 0.95);
            --input-border: rgba(52, 73, 94, 0.3);
            --error-bg: rgba(231, 76, 60, 0.15);
            --error-text: #c0392b;
        }

        /* Copy tất cả CSS từ file gốc */
        body, html {
            margin: 0;
            padding: 0;
            min-height: 100%;
            font-family: 'Montserrat', sans-serif;
            color: var(--text-primary);
            transition: background 0.3s ease, color 0.3s ease;
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
            position: relative;
        }
        .bg-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: var(--bg-overlay);
            transition: background 0.3s ease;
        }
        .bg-container > * {
            position: relative;
            z-index: 1;
        }
        .booking-box {
            background-color: var(--box-bg);
            padding: 40px 50px;
            border-radius: 10px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.5);
            width: 100%;
            max-width: 650px;
            transition: background-color 0.3s ease;
        }

        /* Theme Toggle Button */
        .theme-toggle {
            position: fixed;
            top: 100px;
            right: 20px;
            z-index: 1000;
            background: var(--box-bg);
            border: 2px solid var(--input-border);
            padding: 12px 20px;
            border-radius: 50px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 600;
            color: var(--text-primary);
            box-shadow: 0 4px 15px rgba(0,0,0,0.3);
            transition: all 0.3s ease;
        }
        .theme-toggle:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.4);
        }
        .theme-toggle i {
            font-size: 1.2em;
        }
        .booking-box h2 {
            text-align: center;
            font-size: 2.5em;
            margin-bottom: 30px;
            letter-spacing: 2px;
            font-weight: 700;
            color: var(--text-primary);
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
            color: var(--text-secondary);
            margin-bottom: 8px;
            letter-spacing: 1px;
        }
        .input-with-icon {
            display: flex;
            align-items: center;
            border-bottom: 2px solid var(--input-border);
            padding-bottom: 5px;
            transition: border-color 0.3s ease;
        }
        .input-with-icon i {
            margin-right: 12px;
            font-size: 1.1em;
            color: var(--text-secondary);
        }
        .form-group input, .form-group select, .form-group textarea {
            background: transparent;
            border: none;
            color: var(--text-primary);
            font-size: 1.1em;
            font-family: 'Montserrat', sans-serif;
            width: 100%;
        }
        .form-group select option {
            background: var(--box-bg);
            color: var(--text-primary);
        }
        body.light-mode .form-group select option {
            background: #fff;
            color: #2c3e50;
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
        .error-message {
            color: var(--error-text);
            text-align: center;
            padding: 10px;
            margin-bottom: 15px;
            background: var(--error-bg);
            border-radius: 5px;
            transition: all 0.3s ease;
        }
    </style>
</head>
<body>
<jsp:include page="../views/common/header.jsp" />

<!-- Theme Toggle Button -->
<button class="theme-toggle" id="themeToggle" onclick="toggleTheme()">
    <i class="fas fa-moon" id="themeIcon"></i>
    <span id="themeText">Chế độ tối</span>
</button>

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
                        <button type="button" id="minus-btn" style="background: white; border: 2px solid #e74c3c; color: #e74c3c; width: 35px; height: 35px; border-radius: 50%; cursor: pointer; font-weight: bold; font-size: 1.2em;">-</button>
                        <input type="number" id="guests" name="guests" min="1" max="20" value="2" readonly style="flex: 1; text-align: center;">
                        <button type="button" id="plus-btn" style="background: white; border: 2px solid #e74c3c; color: #e74c3c; width: 35px; height: 35px; border-radius: 50%; cursor: pointer; font-weight: bold; font-size: 1.2em;">+</button>
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

            <!-- Loại sự kiện / Dịch vụ -->
            <div class="form-group">
                <label for="serviceId">Dịch vụ (tùy chọn):</label>
                <div class="input-with-icon">
                    <i class="fas fa-star"></i>
                    <select id="serviceId" name="serviceId">
                        <option value="none">Không chọn dịch vụ</option>
                        <%@ page import="java.util.List, com.fpt.restaurantbooking.models.Service" %>
                        <%
                            List<Service> activeServices = (List<Service>) request.getAttribute("activeServices");
                            if (activeServices != null && !activeServices.isEmpty()) {
                                for (Service service : activeServices) {
                        %>
                        <option value="<%= service.getServiceId() %>">
                            <%= service.getServiceName() %>
                            <% if (service.getPrice() != null && !service.getPrice().isEmpty()) { %>
                            - <%= String.format("%,d", Long.parseLong(service.getPrice().replaceAll("[^0-9]", ""))) %>đ
                            <% } %>
                        </option>
                        <%
                                }
                            }
                        %>
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
    // === THEME MANAGEMENT ===
    function toggleTheme() {
        const body = document.body;
        const themeIcon = document.getElementById('themeIcon');
        const themeText = document.getElementById('themeText');

        body.classList.toggle('light-mode');

        if (body.classList.contains('light-mode')) {
            themeIcon.className = 'fas fa-sun';
            themeText.textContent = 'Chế độ sáng';
            localStorage.setItem('theme', 'light');
        } else {
            themeIcon.className = 'fas fa-moon';
            themeText.textContent = 'Chế độ tối';
            localStorage.setItem('theme', 'dark');
        }
    }

    // Load saved theme on page load
    window.addEventListener('DOMContentLoaded', function() {
        const savedTheme = localStorage.getItem('theme');
        const body = document.body;
        const themeIcon = document.getElementById('themeIcon');
        const themeText = document.getElementById('themeText');

        if (savedTheme === 'light') {
            body.classList.add('light-mode');
            themeIcon.className = 'fas fa-sun';
            themeText.textContent = 'Chế độ sáng';
        }
    });

    // === ORIGINAL SCRIPTS ===
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