<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Danh sách bàn đã đặt</title>

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
        }

        .container {
            width: 90%;
            max-width: 1000px; /* Tăng chiều rộng cho phù hợp với bảng */
            margin: 40px auto;
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

        /* --- SEARCH & FILTER SECTION --- */
        .filter-section {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            margin-bottom: 30px;
            padding: 20px;
            background-color: rgba(0, 0, 0, 0.3);
            border-radius: 10px;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .search-box {
            flex: 1;
            min-width: 250px;
            position: relative;
        }

        .search-box input {
            width: 100%;
            padding: 12px 45px 12px 15px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 8px;
            background: rgba(0, 0, 0, 0.4);
            color: #fff;
            font-family: 'Montserrat', sans-serif;
            font-size: 1em;
            outline: none;
            transition: border-color 0.3s ease;
        }

        .search-box input:focus {
            border-color: #e74c3c;
        }

        .search-box input::placeholder {
            color: rgba(255, 255, 255, 0.5);
        }

        .search-box i {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: rgba(255, 255, 255, 0.5);
        }

        .filter-group {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .filter-group label {
            color: #fff;
            font-weight: 500;
            white-space: nowrap;
        }

        .filter-group select {
            padding: 10px 15px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 8px;
            background: rgba(0, 0, 0, 0.4);
            color: #fff;
            font-family: 'Montserrat', sans-serif;
            outline: none;
            cursor: pointer;
            min-width: 150px;
        }

        .filter-group select:focus {
            border-color: #e74c3c;
        }

        .sort-buttons {
            display: flex;
            gap: 10px;
        }

        .sort-btn {
            padding: 10px 15px;
            background: rgba(23, 162, 184, 0.3);
            border: 1px solid #17a2b8;
            color: #17a2b8;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .sort-btn:hover {
            background: #17a2b8;
            color: white;
        }

        .sort-btn.active {
            background: #17a2b8;
            color: white;
        }

        /* --- Table Styling --- */
        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin-bottom: 30px;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(0,0,0,0.3);
            background-color: rgba(255, 255, 255, 0.08);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        table th, table td {
            border-bottom: 1px solid rgba(255, 255, 255, 0.15);
            padding: 18px 15px;
            text-align: center;
            vertical-align: middle;
        }

        table th {
            background: #e74c3c; /* Accent color */
            color: white;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.95em;
        }

        table tr:last-child td {
            border-bottom: none;
        }

        table tbody tr {
            transition: background-color 0.3s ease;
        }

        table tbody tr:hover {
            background-color: rgba(255, 255, 255, 0.05);
        }

        /* --- Status Badges --- */
        .status {
            font-weight: bold;
            padding: 6px 12px;
            border-radius: 20px; /* Pill shape */
            font-size: 0.9em;
            display: inline-block;
            min-width: 120px;
        }

        .pending {
            background-color: rgba(255, 193, 7, 0.2); /* Yellow */
            color: #ffc107;
            border: 1px solid #ffc107;
        }

        .confirmed {
            background-color: rgba(40, 167, 69, 0.2); /* Green */
            color: #28a745;
            border: 1px solid #28a745;
        }

        .done {
            background-color: rgba(108, 117, 125, 0.2); /* Gray */
            color: #6c757d;
            border: 1px solid #6c757d;
        }

        /* --- Action Buttons --- */
        .btn {
            background: #17a2b8; /* Cyan */
            color: white;
            border: none;
            padding: 9px 18px;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 500;
            transition: background-color 0.3s ease, transform 0.2s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .btn:hover {
            background: #117a8b;
            transform: translateY(-2px);
        }

        .back-link-container {
            text-align: center;
            margin-top: 20px;
        }

        .no-results {
            text-align: center;
            padding: 40px;
            color: rgba(255, 255, 255, 0.6);
            font-size: 1.1em;
        }

    </style>
</head>
<body>
<div class="container">
    <h2><i class="fas fa-history"></i> Lịch sử đặt bàn</h2>

    <!-- SEARCH & FILTER SECTION -->
    <div class="filter-section">
        <div class="search-box">
            <input type="text" id="searchInput" placeholder="Tìm kiếm theo mã đặt bàn, số bàn...">
            <i class="fas fa-search"></i>
        </div>

        <div class="filter-group">
            <label for="statusFilter"><i class="fas fa-filter"></i> Trạng thái:</label>
            <select id="statusFilter">
                <option value="all">Tất cả</option>
                <option value="pending">Đang chờ</option>
                <option value="confirmed">Đã xác nhận</option>
                <option value="done">Hoàn tất</option>
            </select>
        </div>

        <div class="sort-buttons">
            <button class="sort-btn active" id="sortDateBtn" onclick="sortByDate()">
                <i class="fas fa-calendar-alt"></i> Sắp xếp theo ngày
            </button>
            <button class="sort-btn" id="sortTimeBtn" onclick="sortByTime()">
                <i class="fas fa-clock"></i> Sắp xếp theo giờ
            </button>
        </div>
    </div>

    <table id="bookingTable">
        <thead>
        <tr>
            <th>Mã đặt bàn</th>
            <th>Ngày</th>
            <th>Giờ</th>
            <th>Số bàn</th>
            <th>Số người</th>
            <th>Trạng thái</th>
            <th>Hành động</th>
        </tr>
        </thead>
        <tbody id="bookingTableBody">
        <tr data-status="pending" data-date="2025-09-15" data-time="18:30">
            <td>DB001</td>
            <td>2025-09-15</td>
            <td>18:30</td>
            <td>Bàn 05</td>
            <td>4</td>
            <td><span class="status pending">⏳ Đang chờ</span></td>
            <td><a href="#" class="btn"><i class="fas fa-eye"></i> Chi tiết</a></td>
        </tr>
        <tr data-status="confirmed" data-date="2025-09-10" data-time="12:00">
            <td>DB002</td>
            <td>2025-09-10</td>
            <td>12:00</td>
            <td>Bàn 02</td>
            <td>2</td>
            <td><span class="status confirmed">✅ Đã xác nhận</span></td>
            <td><a href="#" class="btn"><i class="fas fa-eye"></i> Chi tiết</a></td>
        </tr>
        <tr data-status="done" data-date="2025-09-05" data-time="19:00">
            <td>DB003</td>
            <td>2025-09-05</td>
            <td>19:00</td>
            <td>Bàn 08</td>
            <td>6</td>
            <td><span class="status done">✔️ Hoàn tất</span></td>
            <td><a href="#" class="btn"><i class="fas fa-eye"></i> Chi tiết</a></td>
        </tr>
        </tbody>
    </table>

    <div id="noResults" class="no-results" style="display: none;">
        <i class="fas fa-search" style="font-size: 3em; margin-bottom: 15px; opacity: 0.3;"></i>
        <p>Không tìm thấy kết quả phù hợp</p>
    </div>

    <div class="back-link-container">
        <a href="trangchu.jsp" class="btn" style="background-color: #6c757d;"><i class="fas fa-home"></i> Quay về trang chủ</a>
    </div>
</div>

<script>
    const searchInput = document.getElementById('searchInput');
    const statusFilter = document.getElementById('statusFilter');
    const tableBody = document.getElementById('bookingTableBody');
    const noResults = document.getElementById('noResults');
    const sortDateBtn = document.getElementById('sortDateBtn');
    const sortTimeBtn = document.getElementById('sortTimeBtn');

    let currentSortOrder = 'desc'; // desc = mới nhất trước

    // Tìm kiếm
    searchInput.addEventListener('input', function() {
        filterTable();
    });

    // Lọc theo trạng thái
    statusFilter.addEventListener('change', function() {
        filterTable();
    });

    function filterTable() {
        const searchTerm = searchInput.value.toLowerCase().trim();
        const statusValue = statusFilter.value;
        const rows = tableBody.getElementsByTagName('tr');
        let visibleCount = 0;

        for (let row of rows) {
            const cells = row.getElementsByTagName('td');
            const rowStatus = row.getAttribute('data-status');

            // Lấy nội dung các cột để tìm kiếm
            const code = cells[0].textContent.toLowerCase();
            const date = cells[1].textContent.toLowerCase();
            const time = cells[2].textContent.toLowerCase();
            const table = cells[3].textContent.toLowerCase();

            const matchesSearch = !searchTerm ||
                code.includes(searchTerm) ||
                date.includes(searchTerm) ||
                time.includes(searchTerm) ||
                table.includes(searchTerm);

            const matchesStatus = statusValue === 'all' || rowStatus === statusValue;

            if (matchesSearch && matchesStatus) {
                row.style.display = '';
                visibleCount++;
            } else {
                row.style.display = 'none';
            }
        }

        // Hiển thị thông báo nếu không có kết quả
        if (visibleCount === 0) {
            noResults.style.display = 'block';
        } else {
            noResults.style.display = 'none';
        }
    }

    // Sắp xếp theo ngày
    function sortByDate() {
        sortTable('date');
        sortDateBtn.classList.add('active');
        sortTimeBtn.classList.remove('active');
    }

    // Sắp xếp theo giờ
    function sortByTime() {
        sortTable('time');
        sortTimeBtn.classList.add('active');
        sortDateBtn.classList.remove('active');
    }

    function sortTable(type) {
        const rows = Array.from(tableBody.getElementsByTagName('tr'));

        rows.sort((a, b) => {
            let aValue, bValue;

            if (type === 'date') {
                aValue = new Date(a.getAttribute('data-date'));
                bValue = new Date(b.getAttribute('data-date'));
            } else if (type === 'time') {
                const aTime = a.getAttribute('data-time');
                const bTime = b.getAttribute('data-time');
                aValue = convertTimeToMinutes(aTime);
                bValue = convertTimeToMinutes(bTime);
            }

            // Đảo chiều sắp xếp
            if (currentSortOrder === 'asc') {
                return aValue > bValue ? 1 : -1;
            } else {
                return aValue < bValue ? 1 : -1;
            }
        });

        // Đảo chiều cho lần sort tiếp theo
        currentSortOrder = currentSortOrder === 'asc' ? 'desc' : 'asc';

        // Xóa và thêm lại các hàng đã sắp xếp
        rows.forEach(row => tableBody.appendChild(row));

        // Giữ nguyên filter sau khi sort
        filterTable();
    }

    function convertTimeToMinutes(time) {
        const parts = time.split(':');
        return parseInt(parts[0]) * 60 + parseInt(parts[1]);
    }
</script>
</body>
</html>