<!-- Loyalty Customers Management Page (Professional) -->
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Quản lý khách hàng thân thiết</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        :root{
            --wine:#8B0000; /* đỏ rượu vang */
            --gold:#d4af37;
            --bg:#f5f6f7;
            --card:#ffffff;
            --muted:#6c6c6c;
        }
        html,body{height:100%;}
        body {
            background: linear-gradient(180deg, var(--bg), #eef1f2);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color:#222;
            margin:0; padding:0;
        }
        /* Top header (kept from sample) */
        .header{
            background:var(--wine);
            color:#fff;
            padding:16px 24px;
            display:flex;
            align-items:center;
            justify-content:space-between;
            box-shadow:0 2px 8px rgba(0,0,0,0.08);
        }
        .logo{font-weight:800; font-size:20px;}
        .header nav ul{list-style:none; display:flex; gap:18px; margin:0; padding:0;}
        .header nav a{color:#fff; text-decoration:none; font-weight:600; opacity:0.92}
        /* Layout */
        .main-wrapper{display:flex; gap:20px; padding:18px;}
        .sidebar{
            width:240px; background:linear-gradient(180deg,var(--wine), #6a0000);
            color:#fff; border-radius:8px; padding:18px; height:calc(100vh - 84px); box-shadow:0 6px 18px rgba(0,0,0,0.12);
        }
        .sidebar h2{font-size:18px; margin-top:0; margin-bottom:14px}
        .sidebar ul{list-style:none; padding:0}
        .sidebar a{display:block; color:#fff; text-decoration:none; padding:10px 6px; border-radius:6px; margin-bottom:6px; opacity:0.95}
        .sidebar a:hover{background:rgba(255,255,255,0.06); transform:translateX(6px);}
        /* Banner */
        .banner{background-image: linear-gradient(90deg, rgba(139,0,0,0.92), rgba(212,175,55,0.06)), url(''); background-size:cover; border-radius:10px; padding:18px; color:#fff; margin-bottom:16px}
        .banner h1{margin:0; font-size:22px;}
        /* Content panel */
        .content{flex:1}
        .content .panel{background:var(--card); padding:20px; border-radius:10px; box-shadow:0 6px 20px rgba(0,0,0,0.06)}
        .top-actions{display:flex; gap:12px; justify-content:space-between; align-items:center; margin-bottom:16px}
        .controls{display:flex; gap:10px; align-items:center}
        .stat-box{display:flex; gap:12px}
        .stat{background:linear-gradient(180deg,#fff,#f8f8f8); padding:12px 16px; border-radius:8px; min-width:120px; text-align:center; box-shadow:0 3px 8px rgba(0,0,0,0.04)}
        .stat .num{font-weight:700; color:var(--wine); font-size:20px}
        .search-input{width:360px}
        /* User list grid */
        #users-container{display:grid; grid-template-columns:repeat(auto-fill,minmax(300px,1fr)); gap:14px; margin-top:10px}
        .user-card{
            background:linear-gradient(180deg,#fff,#fbfbfb);
            border-radius:12px; padding:14px; border:1px solid rgba(0,0,0,0.04);
            transition: transform 220ms cubic-bezier(.2,.9,.2,1), box-shadow 220ms;
            cursor:pointer; position:relative; overflow:hidden;
        }
        .user-card:hover{transform:translateY(-6px) scale(1.01); box-shadow:0 14px 30px rgba(0,0,0,0.08)}
        .user-card .label-level{position:absolute; right:12px; top:12px; background:var(--gold); color:#111; padding:6px 10px; border-radius:20px; font-weight:700}
        .user-card .avatar{width:56px; height:56px; border-radius:50%; background:linear-gradient(135deg,var(--wine), #b02a2a); display:inline-flex; align-items:center; justify-content:center; color:#fff; font-weight:700; margin-right:12px}
        .user-row{display:flex; align-items:center}
        .user-meta{color:var(--muted); font-size:13px; margin-top:8px}
        .card-actions{display:flex; gap:8px; margin-top:12px}
        .btn-ghost{border:1px solid #ddd; background:transparent; padding:6px 10px; border-radius:8px; font-weight:600; cursor:pointer}
        .btn-primary{background:var(--wine); color:#fff; border:none; padding:8px 12px; border-radius:8px}
        /* Table fallback (for hybrid) */
        .table-area{margin-top:14px}
        table.custom{width:100%; border-collapse:collapse}
        table.custom th, table.custom td{padding:10px; border-bottom:1px solid #eee; text-align:left}

        /* modal */
        .modal{display:none; position:fixed; inset:0; background:rgba(0,0,0,0.45); align-items:center; justify-content:center}
        .modal .modal-inner{background:#fff; padding:18px; border-radius:10px; width:640px; max-width:92%}

        /* responsive */
        @media(max-width:900px){
            .sidebar{display:none}
            .search-input{width:200px}
            .main-wrapper{padding:12px}
        }
    </style>
</head>
<body>
<!-- Header (kept) -->
<div class="header">
    <div class="logo">Restaurant_Booking</div>
    <nav>
        <ul>
            <li><a href="#">Trang chủ</a></li>
            <li><a href="#">Đặt bàn</a></li>
            <li><a href="#">Menu</a></li>
            <li><a href="#">Liên hệ</a></li>
        </ul>
    </nav>
</div>

<div class="main-wrapper">
    <!-- Sidebar (kept) -->
    <aside class="sidebar">
        <h2>Staff Panel</h2>
        <ul>
            <li><a href="#">Dashboard</a></li>
            <li><a href="#">Dịch vụ</a></li>
            <li><a href="#">Quản lý dịch vụ</a></li>
            <li><a href="#">Quản lý đánh giá</a></li>
            <li><a href="#">Quản lý Menu</a></li>
            <li><a href="#">Voucher</a></li>
            <li><a href="#">Khách hàng thân thiết</a></li>
        </ul>
    </aside>

    <!-- Content -->
    <section class="content">
        <div class="banner panel">
            <h1>Danh sách khách hàng thân thiết</h1>
            <p style="opacity:0.9; margin-top:8px">Quản lý, phân loại và chăm sóc khách hàng VIP — giữ chân khách hàng và tăng doanh thu</p>
        </div>

        <div class="panel">
            <div class="top-actions">
                <div class="controls">
                    <div class="stat-box">
                        <div class="stat"><div style="font-size:12px;color:var(--muted)">Tổng khách</div><div class="num" id="statTotal">--</div></div>
                        <div class="stat"><div style="font-size:12px;color:var(--muted)">Cấp 1</div><div class="num" id="stat1">--</div></div>
                        <div class="stat"><div style="font-size:12px;color:var(--muted)">Cấp 2</div><div class="num" id="stat2">--</div></div>
                        <div class="stat"><div style="font-size:12px;color:var(--muted)">Cấp 3</div><div class="num" id="stat3">--</div></div>
                    </div>
                    <div style="width:12px"></div>
                    <div>
                        <label style="font-weight:700;margin-right:8px">Lọc:</label>
                        <select id="filterLevel" onchange="filterByLevel()" style="padding:6px 10px; border-radius:6px;">
                            <option value="all">Tất cả</option>
                            <option value="1">Cấp 1</option>
                            <option value="2">Cấp 2</option>
                            <option value="3">Cấp 3</option>
                        </select>
                    </div>
                </div>

                <div style="display:flex; align-items:center; gap:10px">
                    <input id="searchInput" class="form-control search-input" placeholder="Tìm theo tên / email / SĐT" oninput="debouncedSearch()">
                    <button class="btn btn-outline-secondary" onclick="resetFilters()">Reset</button>
                </div>
            </div>

            <!-- Users grid (hybrid appearance) -->
            <div id="users-container">
                <
                <!-- Sample card (will be generated server-side in JSP or by JS) -->
                <div class="user-card" data-level="1" data-name="Phạm Thị Lan" data-email="lanpham@gmail.com" data-phone="0121111103" data-dob="1991-09-05" data-gender="Female">
                    <div class="user-row">
                        <div class="avatar">PT</div>
                        <div>
                            <div class="user-name">Phạm Thị Lan</div>
                            <div class="user-meta">lanpham@gmail.com • 0121111103</div>
                        </div>
                    </div>
                    <div class="user-meta">Ngày sinh: 1991-09-05 • Giới tính: Female</div>
                    <div class="card-actions">
                        <button class="btn-ghost" onclick="openDetail(this)">Xem</button>
                        <button class="btn-primary">Chỉnh sửa</button>
                    </div>
                    <div class="label-level">Cấp 1</div>
                </div>
            </div>

            <!-- Pagination area (keep server-side pagination script) -->
            <div style="margin-top:18px; display:flex; justify-content:center; align-items:center">
                <nav aria-label="Page navigation example">
                    <ul class="pagination">
                        <li class="page-item"><a class="page-link" href="#" onclick="goToPage(1)">1</a></li>
                        <li class="page-item"><a class="page-link" href="#" onclick="goToPage(2)">2</a></li>
                        <li class="page-item"><a class="page-link" href="#" onclick="goToPage(3)">3</a></li>
                    </ul>
                </nav>
            </div>
        </div>
    </section>
</div>

<!-- Detail modal -->
<div id="detailModal" class="modal" onclick="closeModal(event)">
    <div class="modal-inner" onclick="event.stopPropagation()">
        <h3 id="detailName">Tên</h3>
        <p id="detailEmail">Email</p>
        <p id="detailPhone">SĐT</p>
        <p id="detailDob">Ngày sinh</p>
        <p id="detailGender">Giới tính</p>
        <div style="text-align:right; margin-top:8px"><button class="btn btn-secondary" onclick="closeModal(event)">Đóng</button></div>
    </div>
</div>

<script>
    // keep only pagination navigation function (server-side still recommended)
    function goToPage(page){
        // this function should be wired to server-side pagination, placeholder for client demo
        console.log('Go to page', page);
        // example: window.location.href = 'ManageLoyalty?page=' + page;
    }

    // Filtering + search + animations
    function filterByLevel(){
        const level = document.getElementById('filterLevel').value;
        document.querySelectorAll('#users-container .user-card').forEach(card=>{
            const cardLevel = card.getAttribute('data-level');
            card.style.display = (level==='all' || cardLevel===level) ? 'block' : 'none';
        });
        updateStats();
    }

    function openDetail(btn){
        // btn is the clicked button inside card
        const card = btn.closest('.user-card');
        document.getElementById('detailName').innerText = card.getAttribute('data-name');
        document.getElementById('detailEmail').innerText = 'Email: ' + card.getAttribute('data-email');
        document.getElementById('detailPhone').innerText = 'SĐT: ' + card.getAttribute('data-phone');
        document.getElementById('detailDob').innerText = 'Ngày sinh: ' + card.getAttribute('data-dob');
        document.getElementById('detailGender').innerText = 'Giới tính: ' + card.getAttribute('data-gender');
        document.getElementById('detailModal').style.display = 'flex';
    }
    function closeModal(e){
        document.getElementById('detailModal').style.display = 'none';
    }

    // Search with debounce
    let searchTimer = null;
    function debouncedSearch(){
        clearTimeout(searchTimer);
        searchTimer = setTimeout(()=>{
            const q = document.getElementById('searchInput').value.toLowerCase().trim();
            document.querySelectorAll('#users-container .user-card').forEach(card=>{
                const name = card.getAttribute('data-name').toLowerCase();
                const email = card.getAttribute('data-email').toLowerCase();
                const phone = card.getAttribute('data-phone').toLowerCase();
                const match = name.includes(q) || email.includes(q) || phone.includes(q);
                card.style.display = match ? 'block' : 'none';
            });
            updateStats();
        }, 240);
    }
    function resetFilters(){
        document.getElementById('filterLevel').value = 'all';
        document.getElementById('searchInput').value = '';
        document.querySelectorAll('#users-container .user-card').forEach(c=>c.style.display='block');
        updateStats();
    }

    function updateStats(){
        const cards = Array.from(document.querySelectorAll('#users-container .user-card')).filter(c=>c.style.display!=='none');
        document.getElementById('statTotal').innerText = cards.length;
        document.getElementById('stat1').innerText = cards.filter(c=>c.getAttribute('data-level')==='1').length;
        document.getElementById('stat2').innerText = cards.filter(c=>c.getAttribute('data-level')==='2').length;
        document.getElementById('stat3').innerText = cards.filter(c=>c.getAttribute('data-level')==='3').length;
    }

    // small entrance animation for cards
    window.addEventListener('load', ()=>{
        document.querySelectorAll('#users-container .user-card').forEach((c,i)=>{
            c.style.opacity = 0; c.style.transform = 'translateY(8px)';
            setTimeout(()=>{ c.style.transition = 'opacity 280ms, transform 320ms'; c.style.opacity=1; c.style.transform='translateY(0)'; }, 80*i);
        });
        updateStats();
    });

</script>
</body>
</html>