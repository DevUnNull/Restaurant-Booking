<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Quản lý khung thời gian</title>

  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/css/bootstrap.min.css">
  <link href="css/TimeDetail.css" rel="stylesheet" type="text/css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">

</head>
<style>
  .sidebar {
    width: 220px;
    background-color: #7a1c1c; /* màu nền đỏ đậm */
    padding: 20px 10px;
    border-top: 3px solid #c0392b; /* viền trên nhẹ màu đỏ sáng hơn */
    min-height: 100vh;
  }

  .sidebar ul {
    list-style: none;
    margin: 6px;
    padding: 5px;
  }

  .sidebar ul li {
    margin-bottom: 20px; /* khoảng cách giữa các dòng */
  }

  .sidebar ul li a {
    text-decoration: none;
    color: #ffffff; /* chữ trắng */
    font-size: 16px;
    font-weight: 500;
    display: block;
    transition: color 0.3s ease, padding-left 0.3s ease;
  }

  .sidebar ul li a:hover {
    color: #ffcc99; /* khi hover chuyển sang màu cam nhạt */
    padding-left: 10px; /* dịch nhẹ sang phải khi hover */
  }
</style>
<body>

<!-- Header -->
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<!-- Sidebar -->
<div class="sidebar">

  <ul>
  <li><a href="ServiceManage">Quản lý dịch vụ</a></li>
  <li><a href="Menu_manage">Quản lý Menu</a></li>
  <li><a href="Voucher">Quản lý Voucher khuyến mãi </a></li>
  <li><a href="Promotion_level">Quản lý khách hàng thân thiết </a></li>
  <li><a href="Timedirect">Quản lý khung giờ </a></li>
  </ul>
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
              <div class="date-badge"><div style="font-size:13px;color:#6b3b36;">Khung giờ mặc định</div><div style="font-size:20px;">—</div></div>
              <div><span class="type-badge" style="background:#f4e7c8;color:#6b3b36;">DEFAULT</span></div>
            </div>

            <div class="slot-desc">Cảm ơn quý khách đã quan tâm — đây là khung giờ phục vụ trong ngày ${localDate} của nhà hàng.</div>

            <div class="time-grid">
              <div class="time-block"><span class="label">Buổi Sáng</span><span class="value">08:00 - 11:30</span></div>
              <div class="time-block"><span class="label">Buổi Trưa</span><span class="value">11:30 - 14:00</span></div>
              <div class="time-block"><span class="label">Buổi Chiều/ Tối</span><span class="value">17:30 - 21:30</span></div>
            </div>

            <div class="slot-footer">
              <div class="slot-note">Bạn có thể thêm ngày đặc biệt hoặc bảo trì để thay đổi khung giờ.</div>
              <div><button class="slot-action" onclick="location.href='Time?create=1'">Thêm ngày mới</button></div>
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
