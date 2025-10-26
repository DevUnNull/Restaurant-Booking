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

        /* HEADER WITH NAVIGATION */
        .header-section {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            flex-wrap: wrap;
            gap: 15px;
        }

        h2 {
            color: #fff;
            font-size: 2.5em;
            font-weight: 700;
            letter-spacing: 2px;
            text-transform: uppercase;
            text-shadow: 2px 2px 8px rgba(0,0,0,0.5);
            flex: 1;
            min-width: 300px;
        }

        .nav-buttons {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .btn-nav {
            padding: 12px 20px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            font-size: 0.95em;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-family: 'Montserrat', sans-serif;
            text-decoration: none;
        }

        .btn-back {
            background: #6c757d;
            color: white;
        }

        .btn-back:hover {
            background: #5a6268;
            transform: translateY(-2px);
            box-shadow: 0 4px 10px rgba(0,0,0,0.3);
        }

        .btn-order {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-order:hover {
            background: linear-gradient(135deg, #5568d3 0%, #65408a 100%);
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
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
        .controls select:focus, .controls input[type="number"]:focus { border-color: #667eea; }
        .controls input[type="number"]:invalid { border-color: #e74c3c; }

        .error-message {
            color: #e74c3c;
            font-size: 0.9em;
            text-align: center;
            margin-top: 10px;
            padding: 10px;
            background: rgba(231, 76, 60, 0.2);
            border-radius: 8px;
            border: 1px solid rgba(231, 76, 60, 0.4);
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
        .table-1 { top: 5%; left: 5%; }
        .table-2 { top: 5%; left: 15%; }
        .table-3 { top: 5%; left: 29%; }
        .table-4 { top: 5%; left: 39%; }
        .table-5 { top: 15%; left: 5%; }
        .table-6 { top: 15%; left: 15%; }
        .table-7 { top: 15%; left: 29%; }
        .table-8 { top: 15%; left: 39%; }
        .table-9 { top: 25%; left: 5%; }
        .table-10 { top: 25%; left: 15%; }
        .table-11 { top: 25%; left: 29%; }
        .table-12 { top: 25%; left: 39%; }
        .table-13 { top: 5%; left: 56%; }
        .table-14 { top: 5%; left: 66%; }
        .table-15 { top: 5%; left: 80%; }
        .table-16 { top: 5%; left: 90%; }
        .table-17 { top: 15%; left: 56%; }
        .table-18 { top: 15%; left: 66%; }
        .table-19 { top: 15%; left: 80%; }
        .table-20 { top: 15%; left: 90%; }
        .table-21 { top: 25%; left: 56%; }
        .table-22 { top: 25%; left: 66%; }
        .table-23 { top: 25%; left: 80%; }
        .table-24 { top: 25%; left: 90%; }
        .table-37 { bottom: 25%; left: 56%; }
        .table-38 { bottom: 25%; left: 66%; }
        .table-39 { bottom: 25%; left: 80%; }
        .table-40 { bottom: 25%; left: 90%; }
        .table-41 { bottom: 15%; left: 56%; }
        .table-42 { bottom: 15%; left: 66%; }
        .table-43 { bottom: 15%; left: 80%; }
        .table-44 { bottom: 15%; left: 90%; }
        .table-45 { bottom: 5%; left: 56%; }
        .table-46 { bottom: 5%; left: 66%; }
        .table-47 { bottom: 5%; left: 80%; }
        .table-48 { bottom: 5%; left: 90%; }
        .table-25 { bottom: 25%; left: 5%; }
        .table-26 { bottom: 25%; left: 15%; }
        .table-27 { bottom: 25%; left: 29%; }
        .table-28 { bottom: 25%; left: 39%; }
        .table-29 { bottom: 15%; left: 5%; }
        .table-30 { bottom: 15%; left: 15%; }
        .table-31 { bottom: 15%; left: 29%; }
        .table-32 { bottom: 15%; left: 39%; }
        .table-33 { bottom: 5%; left: 5%; }
        .table-34 { bottom: 5%; left: 15%; }
        .table-35 { bottom: 5%; left: 29%; }
        .table-36 { bottom: 5%; left: 39%; }

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

        /* RESPONSIVE */
        @media (max-width: 768px) {
            h2 {
                font-size: 1.8em;
                text-align: center;
            }
            .header-section {
                flex-direction: column;
                align-items: stretch;
            }
            .nav-buttons {
                justify-content: center;
            }
            .btn-nav {
                flex: 1;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <!-- HEADER WITH NAVIGATION -->
    <div class="header-section">
        <h2><i class="fas fa-map-marked-alt"></i> Sơ đồ Bàn Nhà hàng</h2>
        <div class="nav-buttons">
            <a href="findViewTable" class="btn-nav btn-back">
                <i class="fas fa-arrow-left"></i> Quay lại
            </a>
            <a href="orderItems" class="btn-nav btn-order">
                <i class="fas fa-utensils"></i> Đặt món ăn
            </a>
        </div>
    </div>

    <!-- FLOOR SELECTION FORM -->
    <form action="findTableMap" method="get" class="controls">
        <input type="hidden" name="date" value="<%= request.getAttribute("requiredDate") %>">
        <input type="hidden" name="time" value="<%= request.getAttribute("requiredTime") %>">

        <label for="floorSelect"><i class="fas fa-layer-group"></i> Chọn tầng:</label>
        <select name="floor" id="floorSelect" onchange="this.form.submit()">
            <option value="all" <%= "all".equals(request.getParameter("floor")) ? "selected" : "" %>>Tất cả tầng</option>
            <option value="1" <%= "1".equals(request.getParameter("floor")) ? "selected" : "" %>>Tầng 1</option>
            <option value="2" <%= "2".equals(request.getParameter("floor")) ? "selected" : "" %>>Tầng 2</option>
            <option value="3" <%= "3".equals(request.getParameter("floor")) ? "selected" : "" %>>Tầng 3</option>
            <option value="4" <%= "4".equals(request.getParameter("floor")) ? "selected" : "" %>>Tầng 4</option>
        </select>

        <label for="capacityInput"><i class="fas fa-users"></i> Số người:</label>
        <input type="number" name="guests" id="capacityInput" min="1" max="20"
               value="<%= request.getAttribute("guestCount") != null ? request.getAttribute("guestCount") : "2" %>"
               required readonly>
    </form>

    <!-- ERROR MESSAGE -->
    <div id="error-message" class="error-message" style="display: <%= request.getAttribute("errorMessage") != null ? "block" : "none" %>;">
        <%= request.getAttribute("errorMessage") != null ? request.getAttribute("errorMessage") : "" %>
    </div>

    <!-- LEGEND -->
    <div class="legend">
        <div class="legend-item"><span class="legend-color red"></span> Đã có người đặt</div>
        <div class="legend-item"><span class="legend-color green"></span> Trống & phù hợp</div>
        <div class="legend-item"><span class="legend-color yellow"></span> Trống & không phù hợp</div>
        <div class="legend-item"><span class="legend-color grey"></span> Trống (chưa chọn tầng/số người)</div>
    </div>

    <!-- RESTAURANT MAP -->
    <div class="restaurant-map">
        <div class="dining-area indoor-dining">Tầng 1</div>
        <div class="dining-area upper-outdoor-dining">Tầng 2</div>
        <div class="dining-area lower-outdoor-dining">Tầng 4</div>
        <div class="office">Tầng 3</div>

        <%
            Map<Integer, Map<String, Object>> tableStatusMap = (Map<Integer, Map<String, Object>>) request.getAttribute("tableStatusMap");
            String selectedFloorParam = request.getParameter("floor");
            String requiredCapacityParam = request.getAttribute("guestCount") != null ? request.getAttribute("guestCount").toString() : "2";

            if (tableStatusMap != null) {
                for (Map.Entry<Integer, Map<String, Object>> entry : tableStatusMap.entrySet()) {
                    int tableId = entry.getKey();
                    Map<String, Object> tableDetails = entry.getValue();
                    String status = (String) tableDetails.get("status");
                    boolean match = (Boolean) tableDetails.get("match");
                    int capacity = (Integer) tableDetails.get("capacity");
                    int floor = (Integer) tableDetails.get("floor");

                    String tableClass = "table table-" + tableId;

                    if ("booked".equals(status)) {
                        tableClass += " booked";
                    } else if (match) {
                        tableClass += " available-match";
                    } else {
                        tableClass += " available-nomatch";
                    }

                    boolean show = "all".equals(selectedFloorParam) || String.valueOf(floor).equals(selectedFloorParam);

                    if (show) {
                        out.println("<div class='" + tableClass + "' " +
                                "data-table-id='" + tableId + "' " +
                                "data-capacity='" + capacity + "' " +
                                "data-status='" + status + "' " +
                                "data-required-capacity='" + requiredCapacityParam + "'>" +
                                "Bàn " + tableId + " (" + capacity + ")</div>");
                    }
                }
            }
        %>
    </div>
</div>

<div class="table-tooltip" id="tableTooltip"></div>

<script>
    const tooltip = document.getElementById('tableTooltip');
    const tables = document.querySelectorAll('.table');
    let currentTable = null;
    let hideTimeout = null;

    tables.forEach(table => {
        table.addEventListener('mouseenter', function(e) {
            if (hideTimeout) {
                clearTimeout(hideTimeout);
                hideTimeout = null;
            }
            currentTable = this;
            showTooltip(e, this);
        });

        table.addEventListener('mouseleave', function(e) {
            hideTimeout = setTimeout(() => {
                if (!tooltip.matches(':hover')) {
                    hideTooltip();
                    currentTable = null;
                }
            }, 50);
        });
    });

    tooltip.addEventListener('mouseenter', function() {
        if (hideTimeout) {
            clearTimeout(hideTimeout);
            hideTimeout = null;
        }
    });

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
        const requiredCapacity = tableElement.getAttribute('data-required-capacity');

        const isBooked = tableElement.classList.contains('booked');
        const isAvailableMatch = tableElement.classList.contains('available-match');
        const isAvailableNoMatch = tableElement.classList.contains('available-nomatch');

        let content = '';

        if (isBooked) {
            content = '<div class="tooltip-header">Bàn ' + tableId + '</div>' +
                '<div class="tooltip-info">' +
                '<div class="tooltip-row"><i class="fas fa-hashtag"></i><span>Số bàn: ' + tableId + '</span></div>' +
                '<div class="tooltip-row"><i class="fas fa-user-friends"></i><span>Sức chứa: ' + capacity + ' người</span></div>' +
                '<div class="tooltip-row error"><i class="fas fa-exclamation-circle"></i><span>Bàn này đã được đặt</span></div>' +
                '</div>';
        } else if (isAvailableMatch) {
            content = '<div class="tooltip-header">Bàn ' + tableId + '</div>' +
                '<div class="tooltip-info">' +
                '<div class="tooltip-row"><i class="fas fa-hashtag"></i><span>Số bàn: ' + tableId + '</span></div>' +
                '<div class="tooltip-row"><i class="fas fa-user-friends"></i><span>Sức chứa: ' + capacity + ' người</span></div>' +
                '<div class="tooltip-row"><i class="fas fa-check-circle"></i><span>Phù hợp với yêu cầu ' + requiredCapacity + ' người</span></div>' +
                '</div>' +
                '<button class="tooltip-button" onclick="addTableToCart(' + tableId + ', ' + capacity + ')">' +
                '<i class="fas fa-cart-plus"></i> THÊM BÀN</button>';
        } else if (isAvailableNoMatch) {
            content = '<div class="tooltip-header">Bàn ' + tableId + '</div>' +
                '<div class="tooltip-info">' +
                '<div class="tooltip-row"><i class="fas fa-hashtag"></i><span>Số bàn: ' + tableId + '</span></div>' +
                '<div class="tooltip-row error"><i class="fas fa-user-friends"></i><span>Sức chứa: ' + capacity + ' người</span></div>' +
                '<div class="tooltip-row error"><i class="fas fa-exclamation-triangle"></i><span>Không phù hợp (yêu cầu ' + requiredCapacity + ' người)</span></div>' +
                '</div>' +
                '<button class="tooltip-button" onclick="addTableToCart(' + tableId + ', ' + capacity + ')">' +
                '<i class="fas fa-cart-plus"></i> VẪN THÊM BÀN</button>';
        } else {
            content = '<div class="tooltip-header">Bàn ' + tableId + '</div>' +
                '<div class="tooltip-info">' +
                '<div class="tooltip-row"><i class="fas fa-hashtag"></i><span>Số bàn: ' + tableId + '</span></div>' +
                '<div class="tooltip-row"><i class="fas fa-user-friends"></i><span>Sức chứa: ' + capacity + ' người</span></div>' +
                '</div>';
        }

        tooltip.innerHTML = content;
        tooltip.classList.add('show');
        tooltip.style.pointerEvents = 'auto';

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

    async function addTableToCart(tableId, capacity) {
        try {
            const response = await fetch('addTable', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'tableId=' + encodeURIComponent(tableId)
            });

            const result = await response.json();

            if (result.success) {
                alert(result.message || 'Thêm bàn thành công!');
                const tableElem = document.querySelector(`.table[data-table-id='${tableId}']`);
                if (tableElem) {
                    tableElem.classList.remove('available-match', 'available-nomatch');
                    tableElem.classList.add('booked');
                    tableElem.style.cursor = 'not-allowed';
                }
            } else {
                alert(result.message || 'Không thể thêm bàn.');
            }
        } catch (error) {
            console.error('Lỗi:', error);
            alert('Có lỗi xảy ra khi thêm bàn.');
        } finally {
            hideTooltip();
        }
    }
</script>

</body>
</html>