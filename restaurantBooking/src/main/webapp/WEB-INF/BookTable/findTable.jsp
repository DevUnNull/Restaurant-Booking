<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
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
        
        /* Slot Selection Styles */
        .slot-selection {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }
        .slot-button {
            padding: 12px 20px;
            border: 2px solid var(--input-border);
            border-radius: 8px;
            background: transparent;
            color: var(--text-primary);
            cursor: pointer;
            transition: all 0.3s ease;
            text-align: left;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 1em;
        }
        .slot-button:hover:not(.slot-blocked):not(.slot-selected) {
            border-color: #e74c3c;
            background: rgba(231, 76, 60, 0.1);
        }
        .slot-button.slot-selected {
            border-color: #e74c3c;
            background: rgba(231, 76, 60, 0.2);
            font-weight: bold;
        }
        .slot-button.slot-special {
            border-color: #f39c12;
            background: rgba(243, 156, 18, 0.15);
        }
        .slot-button.slot-blocked {
            border-color: #555;
            background: rgba(0, 0, 0, 0.3);
            color: #888;
            cursor: not-allowed;
            opacity: 0.6;
        }
        .slot-time {
            font-size: 0.9em;
            color: var(--text-secondary);
            font-weight: normal;
        }
        .slot-button.slot-blocked .slot-time {
            color: #666;
        }
        
        /* Date Input Warning */
        .date-input-wrapper {
            position: relative;
            width: 100%;
        }
        .date-warning-icon {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            color: #f39c12;
            font-size: 1.2em;
            pointer-events: none;
            display: none;
        }
        .date-warning-icon.show {
            display: block;
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
                <div class="input-with-icon date-input-wrapper">
                    <i class="fas fa-calendar-alt"></i>
                    <input type="date" id="date" name="date" required>
                    <i class="fas fa-exclamation-triangle date-warning-icon" id="dateWarning" title="Ngày này có slot đặc biệt hoặc bị chặn"></i>
                </div>
            </div>

            <!-- Slot Selection -->
            <div class="form-group full-width">
                <label>Chọn Slot:</label>
                <div class="slot-selection" id="slotSelection">
                    <button type="button" class="slot-button" data-slot="MORNING" id="slotMorning">
                        <span>
                            <i class="fas fa-sun"></i> Slot Sáng
                            <span class="slot-time" id="morningTime">--:-- - --:--</span>
                        </span>
                    </button>
                    <button type="button" class="slot-button" data-slot="AFTERNOON" id="slotAfternoon">
                        <span>
                            <i class="fas fa-cloud-sun"></i> Slot Chiều
                            <span class="slot-time" id="afternoonTime">--:-- - --:--</span>
                        </span>
                    </button>
                    <button type="button" class="slot-button" data-slot="EVENING" id="slotEvening">
                        <span>
                            <i class="fas fa-moon"></i> Slot Tối
                            <span class="slot-time" id="eveningTime">--:-- - --:--</span>
                        </span>
                    </button>
                </div>
                <input type="hidden" id="slot" name="slot" required>
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

            <button type="submit" class="search-btn" id="submitBtn">Tìm Bàn Trống</button>
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

    // === LOCAL STORAGE MANAGEMENT ===
    const STORAGE_KEY = 'findTableFormData';
    
    function saveFormData() {
        try {
            const dateEl = document.getElementById('date');
            const slotEl = document.getElementById('slot');
            const guestsEl = document.getElementById('guests');
            const floorEl = document.getElementById('floor');
            const serviceEl = document.getElementById('serviceId');
            const specialEl = document.getElementById('specialRequest');
            
            if (dateEl && slotEl && guestsEl && floorEl && serviceEl && specialEl) {
                const formData = {
                    date: dateEl.value || '',
                    slot: slotEl.value || '',
                    guests: guestsEl.value || '2',
                    floor: floorEl.value || '1',
                    serviceId: serviceEl.value || 'none',
                    specialRequest: specialEl.value || ''
                };
                localStorage.setItem(STORAGE_KEY, JSON.stringify(formData));
            }
        } catch (e) {
            console.error('Error saving form data:', e);
        }
    }
    
    function loadFormData() {
        try {
            const dateEl = document.getElementById('date');
            const guestsEl = document.getElementById('guests');
            const floorEl = document.getElementById('floor');
            const serviceEl = document.getElementById('serviceId');
            const specialEl = document.getElementById('specialRequest');
            
            let formData = null;
            
            // Ưu tiên load từ session (nếu có) - từ servlet đã lưu khi submit
            <%
            HttpSession sessionObj = request.getSession();
            String sessionDate = (String) sessionObj.getAttribute("requiredDate");
            String sessionSlot = (String) sessionObj.getAttribute("requiredSlot");
            Object sessionGuestsObj = sessionObj.getAttribute("guestCount");
            Object sessionFloorObj = sessionObj.getAttribute("floor");
            Object sessionServiceIdObj = sessionObj.getAttribute("selectedServiceId");
            String sessionSpecialRequest = (String) sessionObj.getAttribute("specialRequest");
            
            String sessionGuests = sessionGuestsObj != null ? sessionGuestsObj.toString() : null;
            String sessionFloor = sessionFloorObj != null ? sessionFloorObj.toString() : null;
            String sessionServiceId = sessionServiceIdObj != null ? sessionServiceIdObj.toString() : null;
            %>
            
            <% 
            if (sessionDate != null || sessionGuests != null) { 
                // Escape special characters for JavaScript
                String escapedSpecialRequest = "";
                if (sessionSpecialRequest != null) {
                    escapedSpecialRequest = sessionSpecialRequest
                        .replace("\\", "\\\\")
                        .replace("'", "\\'")
                        .replace("\"", "\\\"")
                        .replace("\n", "\\n")
                        .replace("\r", "\\r");
                }
            %>
            // Có dữ liệu từ session, ưu tiên dùng
            var sessionData = {
                date: '<%= sessionDate != null ? sessionDate : "" %>',
                slot: '<%= sessionSlot != null ? sessionSlot : "" %>',
                guests: '<%= sessionGuests != null ? sessionGuests : "2" %>',
                floor: '<%= sessionFloor != null ? sessionFloor : "1" %>',
                serviceId: '<%= sessionServiceId != null ? sessionServiceId : "none" %>',
                specialRequest: '<%= escapedSpecialRequest %>'
            };
            formData = sessionData;
            <% 
            } else { 
            %>
            // Không có session, load từ localStorage
            const saved = localStorage.getItem(STORAGE_KEY);
            if (saved) {
                formData = JSON.parse(saved);
            }
            <% } %>
            
            // Áp dụng dữ liệu vào form
            if (formData) {
                if (formData.date && dateEl) dateEl.value = formData.date;
                if (formData.guests && guestsEl) guestsEl.value = formData.guests;
                if (formData.floor && floorEl) floorEl.value = formData.floor;
                if (formData.serviceId && serviceEl) {
                    serviceEl.value = formData.serviceId;
                }
                if (formData.specialRequest && specialEl) {
                    specialEl.value = formData.specialRequest;
                }
                
                // Load slot sau khi load date
                if (formData.date) {
                    loadSlotsForDate(formData.date, formData.slot);
                }
            }
        } catch (e) {
            console.error('Error loading form data:', e);
        }
    }
    
    // === SLOT MANAGEMENT ===
    let currentSlotData = null;
    let selectedSlot = null;
    
    function formatTime(timeStr) {
        if (!timeStr) return '--:--';
        // Format từ "08:00:00" thành "08:00"
        return timeStr.substring(0, 5);
    }
    
    function loadSlotsForDate(date, preSelectSlot) {
        if (!date) return;
        if (preSelectSlot === undefined) preSelectSlot = null;
        
        fetch('findTable?date=' + encodeURIComponent(date))
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.json();
            })
            .then(data => {
                currentSlotData = data;
                
                // Update morning slot
                const morningBtn = document.getElementById('slotMorning');
                const morningTime = document.getElementById('morningTime');
                if (morningBtn && morningTime) {
                    if (data.morning && !data.morning.blocked) {
                        morningTime.textContent = formatTime(data.morning.startTime) + ' - ' + formatTime(data.morning.endTime);
                        morningBtn.classList.remove('slot-blocked');
                        if (data.categoryId === 2) {
                            morningBtn.classList.add('slot-special');
                        } else {
                            morningBtn.classList.remove('slot-special');
                        }
                    } else {
                        morningTime.textContent = 'Không khả dụng';
                        morningBtn.classList.add('slot-blocked');
                        morningBtn.classList.remove('slot-special');
                    }
                }
                
                // Update afternoon slot
                const afternoonBtn = document.getElementById('slotAfternoon');
                const afternoonTime = document.getElementById('afternoonTime');
                if (afternoonBtn && afternoonTime) {
                    if (data.afternoon && !data.afternoon.blocked) {
                        afternoonTime.textContent = formatTime(data.afternoon.startTime) + ' - ' + formatTime(data.afternoon.endTime);
                        afternoonBtn.classList.remove('slot-blocked');
                        if (data.categoryId === 2) {
                            afternoonBtn.classList.add('slot-special');
                        } else {
                            afternoonBtn.classList.remove('slot-special');
                        }
                    } else {
                        afternoonTime.textContent = 'Không khả dụng';
                        afternoonBtn.classList.add('slot-blocked');
                        afternoonBtn.classList.remove('slot-special');
                    }
                }
                
                // Update evening slot
                const eveningBtn = document.getElementById('slotEvening');
                const eveningTime = document.getElementById('eveningTime');
                if (eveningBtn && eveningTime) {
                    if (data.evening && !data.evening.blocked) {
                        eveningTime.textContent = formatTime(data.evening.startTime) + ' - ' + formatTime(data.evening.endTime);
                        eveningBtn.classList.remove('slot-blocked');
                        if (data.categoryId === 2) {
                            eveningBtn.classList.add('slot-special');
                        } else {
                            eveningBtn.classList.remove('slot-special');
                        }
                    } else {
                        eveningTime.textContent = 'Không khả dụng';
                        eveningBtn.classList.add('slot-blocked');
                        eveningBtn.classList.remove('slot-special');
                    }
                }
                
                // Show/hide warning icon
                const warningIcon = document.getElementById('dateWarning');
                if (warningIcon) {
                    if (data.hasWarning) {
                        warningIcon.classList.add('show');
                    } else {
                        warningIcon.classList.remove('show');
                    }
                }
                
                // Pre-select slot if provided
                if (preSelectSlot) {
                    selectSlot(preSelectSlot);
                } else if (!selectedSlot || !document.getElementById('slot').value) {
                    // Auto-select first available slot
                    if (data.morning && !data.morning.blocked) {
                        selectSlot('MORNING');
                    } else if (data.afternoon && !data.afternoon.blocked) {
                        selectSlot('AFTERNOON');
                    } else if (data.evening && !data.evening.blocked) {
                        selectSlot('EVENING');
                    }
                }
            })
            .catch(error => {
                console.error('Error loading slots:', error);
                // Fallback: show default slots if API fails
                const morningBtn = document.getElementById('slotMorning');
                const afternoonBtn = document.getElementById('slotAfternoon');
                const eveningBtn = document.getElementById('slotEvening');
                if (morningBtn) {
                    document.getElementById('morningTime').textContent = '08:00 - 11:30';
                    morningBtn.classList.remove('slot-blocked');
                }
                if (afternoonBtn) {
                    document.getElementById('afternoonTime').textContent = '12:00 - 17:00';
                    afternoonBtn.classList.remove('slot-blocked');
                }
                if (eveningBtn) {
                    document.getElementById('eveningTime').textContent = '18:00 - 21:00';
                    eveningBtn.classList.remove('slot-blocked');
                }
                // Auto-select first slot
                if (!selectedSlot && morningBtn && !morningBtn.classList.contains('slot-blocked')) {
                    selectSlot('MORNING');
                }
            });
    }
    
    function selectSlot(slotType) {
        // Check if slot is blocked
        if (currentSlotData) {
            const slotData = currentSlotData[slotType.toLowerCase()];
            if (slotData && slotData.blocked) {
                return; // Cannot select blocked slot
            }
        }
        
        // Remove previous selection
        document.querySelectorAll('.slot-button').forEach(btn => {
            btn.classList.remove('slot-selected');
        });
        
        // Add selection to clicked button
        const slotId = 'slot' + slotType.charAt(0) + slotType.slice(1).toLowerCase();
        const btn = document.getElementById(slotId);
        if (btn && !btn.classList.contains('slot-blocked')) {
            btn.classList.add('slot-selected');
            const slotInput = document.getElementById('slot');
            if (slotInput) {
                slotInput.value = slotType;
            }
            selectedSlot = slotType;
            saveFormData();
        }
    }
    
    // Load saved data on page load - Gộp tất cả vào một DOMContentLoaded
    window.addEventListener('DOMContentLoaded', function() {
        try {
            // === THEME MANAGEMENT ===
            const savedTheme = localStorage.getItem('theme');
            const body = document.body;
            const themeIcon = document.getElementById('themeIcon');
            const themeText = document.getElementById('themeText');

            if (savedTheme === 'light' && body && themeIcon && themeText) {
                body.classList.add('light-mode');
                themeIcon.className = 'fas fa-sun';
                themeText.textContent = 'Chế độ sáng';
            }
            
            // === ORIGINAL SCRIPTS ===
            const minusBtn = document.getElementById('minus-btn');
            const plusBtn = document.getElementById('plus-btn');
            const guestsInput = document.getElementById('guests');
            const dateInput = document.getElementById('date');

            // Set default date to today
            const today = new Date().toISOString().split('T')[0];
            if (dateInput) {
                if (!dateInput.value) {
                    dateInput.value = today;
                }
                dateInput.min = today;
            }

            // Load slots when date changes
            if (dateInput) {
                dateInput.addEventListener('change', function() {
                    loadSlotsForDate(this.value);
                    saveFormData();
                });
            }

            // Slot button clicks
            document.querySelectorAll('.slot-button').forEach(btn => {
                btn.addEventListener('click', function() {
                    if (!this.classList.contains('slot-blocked')) {
                        const slotType = this.getAttribute('data-slot');
                        selectSlot(slotType);
                    }
                });
            });

            if (minusBtn && guestsInput) {
                minusBtn.addEventListener('click', (e) => {
                    e.preventDefault();
                    let currentValue = parseInt(guestsInput.value);
                    if (currentValue > 1) {
                        guestsInput.value = currentValue - 1;
                        saveFormData();
                    }
                });
            }

            if (plusBtn && guestsInput) {
                plusBtn.addEventListener('click', (e) => {
                    e.preventDefault();
                    let currentValue = parseInt(guestsInput.value);
                    if (currentValue < 20) {
                        guestsInput.value = currentValue + 1;
                        saveFormData();
                    }
                });
            }
            
            // === FORM VALIDATION ===
            const form = document.querySelector('form.search-form');
            if (form) {
                form.addEventListener('submit', function(e) {
                    const slotInput = document.getElementById('slot');
                    if (!slotInput || !slotInput.value) {
                        e.preventDefault();
                        e.stopPropagation();
                        alert('Vui lòng chọn một slot thời gian!');
                        return false;
                    }
                    // Lưu lại dữ liệu vào localStorage trước khi submit để giữ lại khi quay lại
                    saveFormData();
                    return true;
                });
            }
            
            // Save form data on other field changes
            const floorSelect = document.getElementById('floor');
            const serviceSelect = document.getElementById('serviceId');
            const specialRequestTextarea = document.getElementById('specialRequest');
            
            if (floorSelect) {
                floorSelect.addEventListener('change', saveFormData);
            }
            if (serviceSelect) {
                serviceSelect.addEventListener('change', saveFormData);
            }
            if (specialRequestTextarea) {
                specialRequestTextarea.addEventListener('input', saveFormData);
            }
            
            // Load saved form data
            loadFormData();
            
            // Get final date value and load slots
            const dateValue = document.getElementById('date') ? document.getElementById('date').value : null;
            const finalDateValue = dateValue || today;
            
            if (!dateValue && dateInput) {
                dateInput.value = finalDateValue;
            }
            
            // Always load slots for the current date value
            loadSlotsForDate(finalDateValue);
        } catch (error) {
            console.error('Error initializing page:', error);
        }
    });
</script>
</body>
</html>