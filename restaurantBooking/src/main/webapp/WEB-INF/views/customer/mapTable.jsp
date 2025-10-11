<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map, java.util.LinkedHashMap, java.util.Arrays, java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sơ đồ Bàn Nhà hàng</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body, html {
            font-family: 'Montserrat', sans-serif;
            background-image: linear-gradient(rgba(0, 0, 0, 0.7), rgba(0, 0, 0, 0.7)),
            url('https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?q=80&w=2070&auto=format&fit=crop');
            background-position: center;
            background-size: cover;
            background-attachment: fixed;
            color: #f0f0f0;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: flex-start;
            padding: 20px;
        }
        .container {
            width: 95%;
            max-width: 1200px;
            background-color: rgba(20, 10, 10, 0.75);
            backdrop-filter: blur(8px);
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.37);
            border: 1px solid rgba(255, 255, 255, 0.18);
            margin-bottom: 30px;
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
        .controls {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 15px;
            margin-bottom: 30px;
            padding: 20px;
            background-color: rgba(0, 0, 0, 0.5);
            border-radius: 10px;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }
        .controls label {
            font-size: 1.1em;
            font-weight: 500;
            color: #fff;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .controls select, .controls input[type="number"] {
            padding: 10px 15px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 8px;
            font-size: 1em;
            background: rgba(0, 0, 0, 0.4);
            color: #fff;
            font-family: 'Montserrat', sans-serif;
            outline: none;
        }
        .controls select { min-width: 180px; }
        .controls select:focus, .controls input[type="number"]:focus { border-color: #e74c3c; }
        .controls input[type="number"]:invalid { border-color: #e74c3c; }
        .btn-search {
            background: #e74c3c;
            color: white;
            border: none;
            padding: 12px 25px;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .btn-search:hover {
            background: #c0392b;
            transform: translateY(-2px);
            box-shadow: 0 4px 10px rgba(0,0,0,0.2);
        }
        .error-message {
            color: #e74c3c;
            font-size: 0.9em;
            text-align: center;
            margin-top: 10px;
        }
        .legend {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 20px;
            margin-top: 20px;
            padding: 15px;
            background-color: rgba(0, 0, 0, 0.5);
            border-radius: 10px;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }
        .legend-item {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.95em;
        }
        .legend-color {
            width: 25px;
            height: 25px;
            border-radius: 5px;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        .legend-color.red { background-color: #e74c3c; }
        .legend-color.green { background-color: #28a745; }
        .legend-color.yellow { background-color: #ffc107; }
        .legend-color.grey { background-color: #6c757d; }
        .restaurant-map {
            width: 100%;
            max-width: 900px;
            aspect-ratio: 1 / 0.8;
            margin: 30px auto;
            position: relative;
            background-color: rgba(255, 255, 255, 0.05);
            border-radius: 15px;
            border: 2px solid rgba(255, 255, 255, 0.1);
            overflow: hidden;
        }
        .kitchen, .sushi-bar, .office {
            background-color: rgba(100, 100, 100, 0.2);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 5px;
            position: absolute;
            display: flex;
            justify-content: center;
            align-items: center;
            color: rgba(255,255,255,0.7);
            font-size: 0.8em;
        }
        .kitchen { top: 42%; right: 2%; width: 45%; height: 35%; }
        .sushi-bar { top: 2%; right: 2%; width: 45%; height: 35%; }
        .office { bottom: 2%; left: 2%; width: 45%; height: 35%; }
        .dining-area {
            position: absolute;
            background-color: rgba(255, 255, 255, 0.03);
            border-radius: 5px;
            border: 1px dashed rgba(255, 255, 255, 0.1);
            display: flex;
            justify-content: center;
            align-items: center;
            color: rgba(255,255,255,0.7);
            font-size: 0.8em;
        }
        .indoor-dining { top: 2%; left: 2%; width: 45%; height: 35%; }
        .upper-outdoor-dining { top: 2%; left: 53%; width: 45%; height: 35%; }
        .lower-outdoor-dining { bottom: 2%; left: 53%; width: 45%; height: 35%; }
        .table {
            position: absolute;
            width: 5%;
            padding-bottom: 5%;
            background-color: rgba(108, 117, 125, 0.5);
            border: 2px solid rgba(255, 255, 255, 0.3);
            border-radius: 8px;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 0.7em;
            font-weight: bold;
            color: #fff;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .table:hover { transform: scale(1.05); }
        .table.booked { background-color: #e74c3c; border-color: #c0392b; }
        .table.available-match { background-color: #28a745; border-color: #218838; }
        .table.available-nomatch { background-color: #ffc107; border-color: #e0a800; }
        .table.default { background-color: rgba(108,117,125,0.5); }
        .table-11 { top: 5%; left: 5%; }
        .table-12 { top: 5%; left: 15%; }
        .table-13 { top: 5%; left: 29%; }
        .table-14 { top: 5%; left: 39%; }
        .table-15 { top: 15%; left: 5%; }
        .table-16 { top: 15%; left: 15%; }
        .table-17 { top: 15%; left: 29%; }
        .table-18 { top: 15%; left: 39%; }
        .table-19 { top: 25%; left: 5%; }
        .table-110 { top: 25%; left: 15%; }
        .table-111 { top: 25%; left: 29%; }
        .table-112 { top: 25%; left: 39%; }
        .table-21 { top: 5%; left: 56%; }
        .table-22 { top: 5%; left: 66%; }
        .table-23 { top: 5%; left: 80%; }
        .table-24 { top: 5%; left: 90%; }
        .table-25 { top: 15%; left: 56%; }
        .table-26 { top: 15%; left: 66%; }
        .table-27 { top: 15%; left: 80%; }
        .table-28 { top: 15%; left: 90%; }
        .table-29 { top: 25%; left: 56%; }
        .table-210 { top: 25%; left: 66%; }
        .table-211 { top: 25%; left: 80%; }
        .table-212 { top: 25%; left: 90%; }
        .table-41 { bottom: 25%; left: 56%; }
        .table-42 { bottom: 25%; left: 66%; }
        .table-43 { bottom: 25%; left: 80%; }
        .table-44 { bottom: 25%; left: 90%; }
        .table-45 { bottom: 15%; left: 56%; }
        .table-46 { bottom: 15%; left: 66%; }
        .table-47 { bottom: 15%; left: 80%; }
        .table-48 { bottom: 15%; left: 90%; }
        .table-49 { bottom: 5%; left: 56%; }
        .table-410 { bottom: 5%; left: 66%; }
        .table-411 { bottom: 5%; left: 80%; }
        .table-412 { bottom: 5%; left: 90%; }
        .table-31 { bottom: 25%; left: 5%; }
        .table-32 { bottom: 25%; left: 15%; }
        .table-33 { bottom: 25%; left: 29%; }
        .table-34 { bottom: 25%; left: 39%; }
        .table-35 { bottom: 15%; left: 5%; }
        .table-36 { bottom: 15%; left: 15%; }
        .table-37 { bottom: 15%; left: 29%; }
        .table-38 { bottom: 15%; left: 39%; }
        .table-39 { bottom: 5%; left: 5%; }
        .table-310 { bottom: 5%; left: 15%; }
        .table-311 { bottom: 5%; left: 29%; }
        .table-312 { bottom: 5%; left: 39%; }

        /* TOOLTIP STYLES */
        .table-tooltip {
            position: fixed;
            background: white;
            color: #333;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.4);
            z-index: 10000;
            min-width: 280px;
            pointer-events: auto;
            opacity: 0;
            transition: opacity 0.3s ease;
            border: 2px solid #667eea;
        }
        .table-tooltip.show {
            opacity: 1;
        }
        .tooltip-header {
            font-size: 1.2em;
            font-weight: 700;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #f0f0f0;
            color: #333;
        }
        .tooltip-info {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        .tooltip-row {
            display: flex;
            align-items: center;
            gap: 10px;
            color: #555;
            font-size: 0.95em;
        }
        .tooltip-row i {
            color: #667eea;
            width: 20px;
        }
        .tooltip-row.error {
            color: #e74c3c;
        }
        .tooltip-row.error i {
            color: #e74c3c;
        }
        .tooltip-button {
            margin-top: 15px;
            padding: 12px 20px;
            background: #28a745;
            color: white;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            font-size: 1em;
            cursor: pointer;
            transition: background 0.3s ease;
            width: 100%;
            font-family: 'Montserrat', sans-serif;
        }
        .tooltip-button:hover {
            background: #218838;
        }
        .tooltip-button.disabled {
            background: #6c757d;
            cursor: not-allowed;
        }
    </style>
</head>
<body>
<div class="container">
    <h2><i class="fas fa-map-marked-alt"></i> Sơ đồ Bàn Nhà hàng</h2>

    <form action="" method="get" class="controls">
        <label for="floorSelect"><i class="fas fa-layer-group"></i> Chọn tầng:</label>
        <select name="floor" id="floorSelect" onchange="this.form.submit()">
            <option value="all">Tất cả tầng</option>
            <option value="indoor" <%= "indoor".equals(request.getParameter("floor")) ? "selected" : "" %>>Tầng 1</option>
            <option value="upper_outdoor" <%= "upper_outdoor".equals(request.getParameter("floor")) ? "selected" : "" %>>Tầng 2</option>
            <option value="lower_outdoor" <%= "lower_outdoor".equals(request.getParameter("floor")) ? "selected" : "" %>>Tầng 3</option>
            <option value="office" <%= "office".equals(request.getParameter("floor")) ? "selected" : "" %>>Tầng 4</option>
        </select>

        <label for="capacityInput"><i class="fas fa-users"></i> Số người:</label>
        <input type="number" name="capacity" id="capacityInput" min="1" max="20"
               value="<%= request.getParameter("capacity") != null ? request.getParameter("capacity") : "2" %>"
               required readonly>
    </form>
    <div id="error-message" class="error-message" style="display: none;"></div>

    <div class="legend">
        <div class="legend-item"><span class="legend-color red"></span> Đã có người đặt</div>
        <div class="legend-item"><span class="legend-color green"></span> Trống & phù hợp</div>
        <div class="legend-item"><span class="legend-color yellow"></span> Trống & không phù hợp</div>
        <div class="legend-item"><span class="legend-color grey"></span> Trống (chưa chọn tầng/số người)</div>
    </div>

    <div class="restaurant-map">
        <%
            // Dữ liệu bàn
            Map<String, Map<String, Object>> tableConfigurations = new LinkedHashMap<>();
            List<String> indoor = Arrays.asList("11:4","12:4", "13:2", "14:6", "15:4", "16:4",    "17:2", "18:6", "19:8", "110:8", "111:4", "112:2");
            List<String> upper = Arrays.asList("21:4", "22:4", "23:2", "24:6", "25:4", "26:4","27:2", "28:6", "29:8", "210:8", "211:4", "212:2");
            List<String> lower = Arrays.asList("41:4","42:4","43:2","44:6","45:4","46:4","47:2","48:6","49:8","410:8","411:4","412:2");
            List<String> office = Arrays.asList("31:4", "32:4", "33:2", "34:6", "35:4", "36:4","37:2", "38:6", "39:8", "310:8", "311:4", "312:2");


            for (String s : indoor) {
                String[] p = s.split(":");
                Map<String, Object> c = new LinkedHashMap<>();
                c.put("floor", "indoor");
                c.put("capacity", Integer.parseInt(p[1]));
                tableConfigurations.put(p[0], c);
            }
            for (String s : upper) {
                String[] p = s.split(":");
                Map<String, Object> c = new LinkedHashMap<>();
                c.put("floor", "upper_outdoor");
                c.put("capacity", Integer.parseInt(p[1]));
                tableConfigurations.put(p[0], c);
            }
            for (String s : lower) {
                String[] p = s.split(":");
                Map<String, Object> c = new LinkedHashMap<>();
                c.put("floor", "lower_outdoor");
                c.put("capacity", Integer.parseInt(p[1]));
                tableConfigurations.put(p[0], c);
            }
            for (String s : office) {
                String[] p = s.split(":");
                Map<String, Object> c = new LinkedHashMap<>();
                c.put("floor", "office");
                c.put("capacity", Integer.parseInt(p[1]));
                tableConfigurations.put(p[0], c);
            }

            // Bàn đã đặt với thông tin chi tiết
            Map<String, Map<String, String>> currentBookings = new LinkedHashMap<>();
            Map<String, String> booking1 = new LinkedHashMap<>();
            booking1.put("date", "01/10/2025");
            booking1.put("time", "18:00 - 20:00");
            currentBookings.put("11", booking1);

            Map<String, String> booking2 = new LinkedHashMap<>();
            booking2.put("date", "01/10/2025");
            booking2.put("time", "19:00 - 21:00");
            currentBookings.put("14", booking2);

            Map<String, String> booking3 = new LinkedHashMap<>();
            booking3.put("date", "02/10/2025");
            booking3.put("time", "17:30 - 19:30");
            currentBookings.put("22", booking3);

            Map<String, String> booking4 = new LinkedHashMap<>();
            booking4.put("date", "01/10/2025");
            booking4.put("time", "20:00 - 22:00");
            currentBookings.put("34", booking4);

            Map<String, String> booking5 = new LinkedHashMap<>();
            booking5.put("date", "03/10/2025");
            booking5.put("time", "18:30 - 20:30");
            currentBookings.put("412", booking5);

            // Xử lý tham số
            String selectedFloor = request.getParameter("floor");
            if (selectedFloor == null || selectedFloor.isEmpty()) {
                selectedFloor = "all";
            }
            int requiredCapacity = 2;
            String errorMessage = "";
            try {
                String capacityParam = request.getParameter("capacity");
                if (capacityParam != null && !capacityParam.isEmpty()) {
                    requiredCapacity = Integer.parseInt(capacityParam);
                    if (requiredCapacity < 1) {
                        errorMessage = "Số người phải lớn hơn 0.";
                    }
                }
            } catch (NumberFormatException e) {
                errorMessage = "Vui lòng nhập số người hợp lệ.";
            }
        %>

        <div class="dining-area indoor-dining">Tầng 1</div>
        <div class="dining-area upper-outdoor-dining">Tầng 2</div>
        <div class="dining-area lower-outdoor-dining">Tầng 3</div>
        <div class="office">Tầng 4</div>

        <%
            if (!errorMessage.isEmpty()) {
                out.println("<script>document.getElementById('error-message').style.display = 'block';");
                out.println("document.getElementById('error-message').innerText = '" + errorMessage + "';</script>");
            }

            for (Map.Entry<String, Map<String, Object>> entry : tableConfigurations.entrySet()) {
                String tableId = entry.getKey();
                String tableFloor = (String) entry.getValue().get("floor");
                int tableCapacity = (Integer) entry.getValue().get("capacity");
                String tableClass = "table table-" + tableId;

                String status = "default";
                String bookingDate = "";
                String bookingTime = "";

                if (currentBookings.containsKey(tableId)) {
                    tableClass += " booked";
                    status = "booked";
                    bookingDate = currentBookings.get(tableId).get("date");
                    bookingTime = currentBookings.get(tableId).get("time");
                } else if (errorMessage.isEmpty()) {
                    if (selectedFloor.equals("all") || tableFloor.equals(selectedFloor)) {
                        if (tableCapacity >= requiredCapacity) {
                            tableClass += " available-match";
                            status = "available-match";
                        } else {
                            tableClass += " available-nomatch";
                            status = "available-nomatch";
                        }
                    } else {
                        tableClass += " default";
                    }
                } else {
                    tableClass += " default";
                }

                boolean show = selectedFloor.equals("all") || tableFloor.equals(selectedFloor);
                if (show) {
                    out.println("<div class='" + tableClass + "' " +
                            "data-table-id='" + tableId + "' " +
                            "data-capacity='" + tableCapacity + "' " +
                            "data-status='" + status + "' " +
                            "data-booking-date='" + bookingDate + "' " +
                            "data-booking-time='" + bookingTime + "' " +
                            "data-required-capacity='" + requiredCapacity + "'>" +
                            tableId + " (" + tableCapacity + ")</div>");
                }
            }
        %>
    </div>
</div>

<!-- Tooltip Element -->
<div class="table-tooltip" id="tableTooltip"></div>

<script>
    const tooltip = document.getElementById('tableTooltip');
    const tables = document.querySelectorAll('.table');
    let currentTable = null;
    let hideTimeout = null;

    tables.forEach(table => {
        table.addEventListener('mouseenter', function(e) {
            // Hủy timeout ẩn nếu có
            if (hideTimeout) {
                clearTimeout(hideTimeout);
                hideTimeout = null;
            }

            currentTable = this;
            showTooltip(e, this);
        });

        table.addEventListener('mouseleave', function(e) {
            // Delay trước khi ẩn để kiểm tra xem có di chuyển sang tooltip không
            hideTimeout = setTimeout(() => {
                if (!tooltip.matches(':hover')) {
                    hideTooltip();
                    currentTable = null;
                }
            }, 50);
        });
    });

    // Khi chuột vào tooltip, hủy việc ẩn
    tooltip.addEventListener('mouseenter', function() {
        if (hideTimeout) {
            clearTimeout(hideTimeout);
            hideTimeout = null;
        }
    });

    // Khi chuột rời khỏi tooltip
    tooltip.addEventListener('mouseleave', function() {
        hideTimeout = setTimeout(() => {
            if (!currentTable || !currentTable.matches(':hover')) {
                hideTooltip();
                currentTable = null;
            }
        }, 50);
    });

    function showTooltip(e, tableElement) {
        const tableId = tableElement.getAttribute('data-table-id');
        const capacity = tableElement.getAttribute('data-capacity');
        const status = tableElement.getAttribute('data-status');
        const bookingDate = tableElement.getAttribute('data-booking-date');
        const bookingTime = tableElement.getAttribute('data-booking-time');
        const requiredCapacity = tableElement.getAttribute('data-required-capacity');

        let content = '';

        if (status === 'booked') {
            // Bàn đã đặt - KHÔNG có nút đặt bàn
            content = `
                    <div class="tooltip-header">Bàn ${tableId}</div>
                    <div class="tooltip-info">
                        <div class="tooltip-row">
                            <i class="fas fa-hashtag"></i>
                            <span>Số bàn: ${tableId}</span>
                        </div>
                        <div class="tooltip-row">
                            <i class="fas fa-user-friends"></i>
                            <span>Sức chứa: ${capacity} người</span>
                        </div>
                        <div class="tooltip-row">
                            <i class="fas fa-calendar-alt"></i>
                            <span>Ngày đặt: ${bookingDate}</span>
                        </div>
                        <div class="tooltip-row">
                            <i class="fas fa-clock"></i>
                            <span>Thời gian: ${bookingTime}</span>
                        </div>
                        <div class="tooltip-row error">
                            <i class="fas fa-exclamation-circle"></i>
                            <span>Bàn này đã được đặt</span>
                        </div>
                    </div>
                `;
        } else if (status === 'available-match') {
            // Bàn phù hợp - CÓ nút đặt bàn
            content = `
                    <div class="tooltip-header">Bàn ${tableId}</div>
                    <div class="tooltip-info">
                        <div class="tooltip-row">
                            <i class="fas fa-hashtag"></i>
                            <span>Số bàn: ${tableId}</span>
                        </div>
                        <div class="tooltip-row">
                            <i class="fas fa-user-friends"></i>
                            <span>Sức chứa: ${capacity} người</span>
                        </div>
                        <div class="tooltip-row">
                            <i class="fas fa-check-circle"></i>
                            <span>Phù hợp với yêu cầu ${requiredCapacity} người</span>
                        </div>
                    </div>
                    <button class="tooltip-button" onclick="bookTable('${tableId}', ${capacity})">
                        <i class="fas fa-calendar-check"></i> ĐẶT BÀN
                    </button>
                `;
        } else if (status === 'available-nomatch') {
            // Bàn không phù hợp - CÓ nút đặt bàn nhưng thông số sai màu đỏ
            content = `
                    <div class="tooltip-header">Bàn ${tableId}</div>
                    <div class="tooltip-info">
                        <div class="tooltip-row">
                            <i class="fas fa-hashtag"></i>
                            <span>Số bàn: ${tableId}</span>
                        </div>
                        <div class="tooltip-row error">
                            <i class="fas fa-user-friends"></i>
                            <span>Sức chứa: ${capacity} người</span>
                        </div>
                        <div class="tooltip-row error">
                            <i class="fas fa-exclamation-triangle"></i>
                            <span>Không phù hợp (yêu cầu ${requiredCapacity} người)</span>
                        </div>
                    </div>
                    <button class="tooltip-button disabled" onclick="alert('Bàn này không phù hợp với số lượng khách của bạn!')">
                        <i class="fas fa-times-circle"></i> ĐẶT BÀN
                    </button>
                `;
        } else {
            // Bàn mặc định
            content = `
                    <div class="tooltip-header">Bàn ${tableId}</div>
                    <div class="tooltip-info">
                        <div class="tooltip-row">
                            <i class="fas fa-hashtag"></i>
                            <span>Số bàn: ${tableId}</span>
                        </div>
                        <div class="tooltip-row">
                            <i class="fas fa-user-friends"></i>
                            <span>Sức chứa: ${capacity} người</span>
                        </div>
                    </div>
                `;
        }

        tooltip.innerHTML = content;
        tooltip.classList.add('show');
        tooltip.style.pointerEvents = 'auto';

        // Đặt vị trí tooltip cố định gần bàn
        const rect = tableElement.getBoundingClientRect();
        const x = rect.right + 15;
        const y = rect.top;

        tooltip.style.left = x + 'px';
        tooltip.style.top = y + 'px';
    }

    function hideTooltip() {
        tooltip.classList.remove('show');
        tooltip.style.pointerEvents = 'none';
    }

    function bookTable(tableId, capacity) {
        alert('Đặt bàn ' + tableId + ' thành công!\\nSức chứa: ' + capacity + ' người');
        // Có thể chuyển hướng đến trang xác nhận
        // window.location.href = 'confirm-booking.jsp?tableId=' + tableId;
    }
</script>
</body>
</html>