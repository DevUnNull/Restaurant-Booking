<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Quản lý khung thời gian</title>

  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
  <style>
    /* ---------- chung (giữ header/sidebar như cũ) ---------- */
    body {
      margin: 0;
      font-family: "Helvetica Neue", Arial, sans-serif;
      background: #f6f6f6;
    }

    .top-header {
      background: #a92e28;
      color: #fff;
      padding: 18px 24px;
      position: fixed;
      left: 0; right: 0; top: 0;
      z-index: 1000;
    }
    .top-header .brand { font-weight:700; font-size:28px; }

    .sidebar {
      width: 230px;
      background: #7b1c1c;
      color: #fff;
      position: fixed;
      top: 68px; bottom: 0;
      padding: 20px 12px;
      overflow-y: auto;
    }
    .sidebar .nav-item { padding:8px 6px; border-radius:4px; margin-bottom:6px; }
    .sidebar .nav-item:hover { background: rgba(255,255,255,0.06); cursor:pointer; }

    .content {
      margin-left: 230px;
      padding-top: 68px;
      padding-left: 24px;
      padding-right: 24px;
      padding-bottom: 40px;
    }

    /* ---------- banner overlay (giữ y nguyên) ---------- */
    .banner {
      margin-top: 18px;
      background: url('https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=1600&q=60') center/cover no-repeat;
      border-radius: 6px;
      padding: 28px 20px;
      color: #fff;
      box-shadow: 0 2px 6px rgba(0,0,0,0.08);
      display: flex;
      justify-content: space-between;
      align-items: center;
      position: relative;
      overflow: hidden;
    }
    .banner::before {
      content:"";
      position:absolute; top:0; left:0; width:100%; height:100%;
      background: rgba(123,28,28,0.55); /* rượu vang mờ */
      z-index:1;
    }
    .banner > * { position: relative; z-index:2; }
    .banner .title { font-size:26px; font-weight:700; text-shadow:0 1px 2px rgba(0,0,0,0.4); }
    .banner .actions .btn { background: rgba(255,255,255,0.9); color:#7b1c1c; border:none; margin-left:8px; border-radius:6px; }

    /* ---------- body mới: card layout ---------- */
    .slots-area {
      margin-top: 22px;
      display: grid;
      grid-template-columns: repeat(auto-fit,minmax(320px,1fr));
      gap: 18px;
    }

    .slot-card {
      background: linear-gradient(180deg, rgba(255,255,255,0.02), rgba(255,255,255,0.00));
      border: 1px solid rgba(123,28,28,0.12);
      border-radius: 12px;
      padding: 18px;
      box-shadow: 0 8px 20px rgba(0,0,0,0.06);
      overflow: hidden;
    }

    .slot-header {
      display:flex;
      align-items:center;
      justify-content:space-between;
      margin-bottom:12px;
    }

    .date-badge {
      font-weight:800;
      font-size:18px;
      color: #7b1c1c;
      display:flex;
      align-items:center;
      gap:10px;
    }
    .type-badge {
      padding:6px 10px;
      border-radius: 999px;
      font-weight:700;
      font-size:13px;
      color: #fff;
      display:inline-block;
      box-shadow: 0 2px 6px rgba(0,0,0,0.12);
    }
    .type-special { background: linear-gradient(90deg,#c48a2a,#f0c75e); color:#3b1d00; } /* vàng kim */
    .type-maint { background: linear-gradient(90deg,#5a2b21,#8b3a34); } /* cam nâu */

    .slot-desc {
      color: #3b2a2a;
      font-size:14px;
      margin-bottom:14px;
      min-height:44px;
    }

    .time-grid {
      display:flex;
      gap:8px;
      flex-wrap:wrap;
      margin-bottom:12px;
    }
    .time-block {
      flex: 1 1 30%;
      min-width:120px;
      border-radius:8px;
      padding:10px;
      background: rgba(255,255,255,0.02);
      border: 1px solid rgba(0,0,0,0.04);
    }
    .time-block .label { font-size:12px; color:#6b3b36; font-weight:700; margin-bottom:6px; display:block; }
    .time-block .value { font-size:15px; color:#2b1b1b; font-weight:600; }

    .slot-footer {
      display:flex;
      justify-content:space-between;
      align-items:center;
      margin-top:8px;
    }
    .slot-note {
      font-size:13px;
      color:#6b3b36;
    }
    .slot-action {
      background: transparent;
      border: 1px solid rgba(123,28,28,0.12);
      color:#7b1c1c;
      padding:8px 12px;
      border-radius:8px;
      cursor:pointer;
    }

    /* huy nen khi ko co data */
    .no-data {
      background: #fffaf3;
      border: 1px solid rgba(196,138,42,0.18);
      padding:18px;
      border-radius:10px;
      color:#6b3b36;
      font-weight:600;
      text-align:center;
      box-shadow:0 6px 18px rgba(196,138,42,0.06);
    }

    /* footer thank you */
    .thankyou {
      margin-top:26px;
      text-align:center;
      padding:20px 18px;
      border-radius:10px;
      background: linear-gradient(90deg, rgba(123,28,28,0.06), rgba(196,138,42,0.03));
      color:#7b1c1c;
      border: 1px solid rgba(123,28,28,0.08);
      position:relative;
      overflow:hidden;
    }
    .thankyou .ornament {
      position:absolute;
      left:10px; right:10px; top:0;
      height:4px;
      background: linear-gradient(90deg,#c48a2a40,#ffffff00,#c48a2a40);
      opacity:0.25;
      transform:skewX(-12deg);
    }
    .thankyou h4 { margin:8px 0 6px 0; font-weight:800; color:#7b1c1c; }
    .thankyou p { margin:0; color:#61302d; font-size:14px; }

    @media (max-width:900px) {
      .content { margin-left:0; padding-left:12px; padding-right:12px; }
      .sidebar { display:none; }
    }
  </style>
</head>
<body>

<!-- Header -->
<jsp:include page="/WEB-INF/views/common/header.jsp" />


<!-- Sidebar -->
<div class="sidebar">
  <h4 style="text-align:center;margin-top:0;">Staff Panel</h4>
  <div class="nav-item">Dashboard</div>
  <li><a href="ServiceManage">Quản lý dịch vụ</a></li>
  <li><a href="Menu_manage">Quản lý Menu</a></li>
  <li><a href="Voucher">Quản lý Voucher khuyến mãi </a></li>
  <li><a href="Promotion_level">Quản lý khách hàng thân thiết </a></li>
  <li><a href="Timedirect">Quản lý khung giờ </a></li>
</div>

<!-- Content -->
<div class="content">

  <!-- Banner -->
  <div class="banner">
    <div class="title">Quản lý khung thời gian</div>
    <div class="actions">
      <button class="btn">Khai Vị</button>
      <button class="btn">+ Thêm mục mới</button>
    </div>
  </div>

  <!-- NEW BODY: list các slot dưới dạng card -->
  <div style="margin-top:20px;">






    <div style="height:18px;"></div>

    <div class="slots-area">
      <!-- một card mẫu hiển thị khung giờ mặc định -->
      <div class="slot-card">
        <div class="slot-header">
          <div class="date-badge"><div style="font-size:13px;color:#6b3b36;">Khung giờ hoạt động của nhà hàng</div><div style="font-size:20px;">—</div></div>
          <div><span class="type-badge" style="background:#f4e7c8;color:#6b3b36;">DEFAULT</span></div>
        </div>

        <div class="slot-desc">Cảm ơn quý khách đã quan tâm — đây là khung giờ phục vụ trong ngày ${localDate} của nhà hàng.</div>

        <div class="time-grid">
          <div class="time-block"><span class="label">Buổi Sáng</span><span class="value">${time.morning_start_time} - ${time.morning_end_time}</span></div>
          <div class="time-block"><span class="label">Buổi Trưa</span><span class="value">${time.afternoon_start_time} - ${time.afternoon_end_time}</span></div>
          <div class="time-block"><span class="label">Buổi Chiều/ Tối</span><span class="value">${time.evening_start_time} - ${time.evening_end_time}</span></div>
        </div>

        <div class="slot-footer">
          <div class="slot-note">Bạn có thể thêm ngày đặc biệt hoặc bảo trì để thay đổi khung giờ.</div>
          <div><button class="slot-action" onclick="location.href='Time?create=1'">Thêm ngày mới</button></div>
        </div>
      </div>
    </div>
    <div class="slots-area">
      <!-- một card mẫu hiển thị khung giờ mặc định -->
      <div class="slot-card">
        <div class="slot-header">
          <div class="date-badge"><div style="font-size:13px;color:#6b3b36;">${time.description}</div><div style="font-size:20px;">—</div></div>

        </div>






      </div>
    </div>



    <!-- thank you -->
    <div class="thankyou">
      <div class="ornament"></div>
      <h4>Cảm ơn quý khách</h4>
      <p>Cảm ơn bạn đã quan tâm đến nhà hàng. Chúng tôi luôn nỗ lực mang đến trải nghiệm ẩm thực tốt nhất — hẹn gặp bạn tại bàn!</p>
    </div>
  </div>

</div>
</body>
</html>
