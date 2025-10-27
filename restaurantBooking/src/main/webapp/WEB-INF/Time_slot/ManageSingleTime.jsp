<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Quản lý khung thời gian</title>
  <link rel="stylesheet" href="styles.css">
  <link rel="stylesheet" href="styless.css">
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=Roboto:wght@400;700&display=swap" rel="stylesheet">
  <link href="css/ServiceManage.css" rel="stylesheet" type="text/css" />

  <style>
    .content-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    .action-btn {
      margin-right: 6px;
    }
    .add-btn {
      background-color: #c0392b;
      color: #fff;
      border: none;
      padding: 10px 22px;
      font-size: 16px;
      font-weight: bold;
      border-radius: 8px;
      cursor: pointer;
      float: right;
      margin-bottom: 15px;
      box-shadow: 0 4px 10px rgba(192,57,43,0.3);
      transition: all 0.3s ease;
    }
    .add-btn:hover { background-color: #e74c3c; transform: translateY(-2px); }

    .btn-edit {
      background-color: #2980b9;
      color: white;
      border: none;
      padding: 6px 12px;
      border-radius: 5px;
      cursor: pointer;
    }
    .btn-block {
      background-color: #e67e22;
      color: white;
      border: none;
      padding: 6px 12px;
      border-radius: 5px;
      cursor: pointer;
    }
    .btn-edit:hover { background-color: #3498db; }
    .btn-block:hover { background-color: #d35400; }
    /* nhỏ gọn cho modal add */
    #addDateModal .modal-content { width: 520px; }
    #addDateModal label { font-weight: 600; }
    #addDateModal input[type="date"], #addDateModal input[type="time"], #addDateModal textarea {
      padding:6px; border-radius:6px; border:1px solid #ccc; font-size:14px;
    }
  </style>
</head>

<body>
<div class="main">
  <!-- Header -->
  <div class="header">
    <div class="logo">Restaurant_Booking</div>
    <nav>
      <ul>
        <li><a href="#">Trang chủ</a></li>
        <li><a href="#">Đặt bàn</a></li>
        <li><a href="#">Menu</a></li>
        <li><a href="#">Liên hệ</a></li>
        <li><a href="#">Giỏ hàng (0)</a></li>
      </ul>
    </nav>
  </div>

  <!-- Wrapper -->
  <div class="main-wrapper">
    <!-- Sidebar -->
    <div class="sidebar">
      <h2>Staff Panel</h2>
      <ul>
        <li><a href="#">Dashboard</a></li>
        <li><a href="ServiceList">Dịch vụ</a></li>
        <li><a href="ServiceManage">Quản lý dịch vụ</a></li>
        <li><a href="#">Quản lý đánh giá bình luận</a></li>
        <li><a href="TimeManage" class="active">Quản lý khung thời gian</a></li>
        <li><a href="#">Quản lý Menu</a></li>
        <li><a href="Voucher">Quản lý Voucher khuyến mãi</a></li>
        <li><a href="#">Quản lý khách hàng thân thiết</a></li>
      </ul>
    </div>

    <!-- Content -->
    <div class="content">
      <div class="content-header">
        <h2>Quản lý khung thời gian</h2>
        <button class="add-btn" onclick="openAddDateModal()">+ Thêm ngày mới</button>
      </div>
      <table>
        <thead>
        <tr>
          <th>ID</th>
          <th>Ngày áp dụng</th>
          <th>Loại ngày</th>
          <th>Mô tả</th>
          <th>Sáng</th>
          <th>Chiều</th>
          <th>Tối</th>
          <th>Thời gian cập nhật</th>
          <th>người cập nhật</th>
          <th>Hành động</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="o" items="${timeSlots}">
          <tr>
            <td>${o.slotId}</td>
            <td>${o.applicableDate}</td>
            <td>${o.name_Category}</td>
            <td>......</td>
            <td>${o.morning_start_time} - ${o.morning_end_time}</td>
            <td>${o.afternoon_start_time} - ${o.afternoon_end_time}</td>
            <td>${o.evening_start_time} - ${o.evening_end_time}</td>
            <td>${o.updated_at}</td>
            <td>${o.updated_name}</td>

            <td>
              <!-- Nút Sửa -->
              <button class="btn-edit"
                      data-id="${o.slotId}"
                      data-description="${o.description}"
                      data-updated-by="${sessionScope.userId}"
                      data-morning-start="${o.morning_start_time}"
                      data-morning-end="${o.morning_end_time}"
                      data-afternoon-start="${o.afternoon_start_time}"
                      data-afternoon-end="${o.afternoon_end_time}"
                      data-evening-start="${o.evening_start_time}"
                      data-evening-end="${o.evening_end_time}"
                      onclick="openEditModal(this)">
                Sửa
              </button>

              <!-- Nút Block -->
              <button class="btn-block"
                      data-id="${o.slotId}"
                      onclick="openBlockModal(this)">
                Block
              </button>
            </td>
          </tr>
        </c:forEach>

        </tbody>
      </table>
    </div>
  </div>
</div>

<!-- Modal sửa -->
<div id="editModal" class="modal">
  <div class="modal-content">
    <span class="close" onclick="closeEditModal()">&times;</span>
    <h2>Cập nhật khung giờ</h2>

    <form action="TimeUpdate" method="post" class="edit-form">
      <!-- ID và updated_by -->
      <input type="hidden" id="edit-id" name="slot_id">
      <input type="hidden" id="updated-by" name="updated_by">

      <div class="form-flex">
        <!-- Cột 1: Thời gian -->
        <div class="time-section">
          <label>Buổi sáng:</label>
          <input type="time" id="morning-start" name="morning_start_time"> -
          <input type="time" id="morning-end" name="morning_end_time"><br>

          <label>Buổi chiều:</label>
          <input type="time" id="afternoon-start" name="afternoon_start_time"> -
          <input type="time" id="afternoon-end" name="afternoon_end_time"><br>

          <label>Buổi tối:</label>
          <input type="time" id="evening-start" name="evening_start_time"> -
          <input type="time" id="evening-end" name="evening_end_time">
        </div>

        <!-- Cột 2: Mô tả -->
        <div class="desc-section">
          <label for="edit-description">Mô tả:</label>
          <textarea id="edit-description" name="slot_description" rows="7" placeholder="Nhập mô tả chi tiết..."></textarea>
        </div>
      </div>

      <button type="submit" class="action-btn btn-update">Lưu thay đổi</button>
    </form>
  </div>
</div>


<!-- Modal Block -->
<div id="blockModal" class="modal">
  <div class="modal-content">
    <span class="close" onclick="closeBlockModal()">&times;</span>
    <h2>Block ngày</h2>
    <p>Bạn có chắc muốn chặn ngày này không?</p>
    <form action="TimeBlock" method="post">
      <input type="hidden" id="block-id" name="slot_id">
      <button type="submit" class="btn-block">Xác nhận</button>
      <button type="button" onclick="closeBlockModal()">Hủy</button>
    </form>
  </div>
</div>
<!-- ========== Modal: Thêm ngày mới ========== -->
<div id="addDateModal" class="modal">
  <div class="modal-content calendar-content">
    <span class="close" onclick="closeAddDateModal()">&times;</span>
    <h2>Thêm / Chỉnh ngày</h2>

    <p id="addDateError" style="color: #c0392b; font-weight: bold; display:none;"></p>

    <!-- Form chính để chọn ngày + hành động -->
    <div>
      <label>Chọn ngày:</label><br>
      <input type="date" id="add-date" required><br><br>

      <label>Hành động:</label><br>
      <label><input type="radio" name="actionType" value="BLOCK"> Block ngày</label>
      <label style="margin-left:16px;"><input type="radio" name="actionType" value="EDIT"> Edit giờ (special)</label>
    </div>

    <!-- FORM 1: BLOCK -->
    <div id="blockFields" style="display:none; margin-top:12px;">
      <form id="blockForm" method="post" action="BlockTime">
        <input type="hidden" name="applicable_date" id="block-date">
        <input type="hidden" name="updated_by" id="block-updated-by" value="${sessionScope.userId}">
        <div style="margin-top:10px;">
          <label>Mô tả:</label><br>
          <textarea name="slot_description" rows="4" style="width:100%" required></textarea>
        </div>
      </form>
    </div>

    <!-- FORM 2: EDIT -->
    <form id="editForm" method="post" action="ManageTime">
    <div id="editFields" style="display:none; margin-top:12px;">

        <input type="hidden" name="applicable_date" id="edit-date">
        <input type="hidden" name="updated_by" id="edit-updated-by">

        <hr>
        <div>
          <strong>Buổi sáng</strong><br>
          <input type="time" name="morning_start_time" > -
          <input type="time" name="morning_end_time" >
        </div>

        <div style="margin-top:8px;">
          <strong>Buổi chiều</strong><br>
          <input type="time" name="afternoon_start_time" > -
          <input type="time" name="afternoon_end_time" >
        </div>

        <div style="margin-top:8px;">
          <strong>Buổi tối</strong><br>
          <input type="time" name="evening_start_time" > -
          <input type="time" name="evening_end_time" >
        </div>

        <div style="margin-top:10px;">
          <label>Mô tả:</label><br>
          <textarea name="slot_description" rows="4" style="width:100%" required></textarea>
        </div>

    </div>
  </form>
    <!-- Nút xác nhận -->
    <div style="margin-top:12px; display:flex; justify-content:flex-end; gap:8px;">
      <button type="button" onclick="closeAddDateModal()" style="padding:8px 12px;border-radius:6px;">Hủy</button>
      <button type="button" onclick="submitAddDate()" class="add-btn" style="padding:8px 14px;">Xác nhận</button>
    </div>
  </div>
</div>

<script>
  function openEditModal(btn) {
    // Gán các giá trị ẩn
    document.getElementById("edit-id").value = btn.dataset.id;
    document.getElementById("updated-by").value = btn.dataset.updatedBy;

    // Gán mô tả (nếu có)
    document.getElementById("edit-description").value = btn.dataset.description || "";

    // Gán giá trị các khung giờ
    document.getElementById("morning-start").value = btn.dataset.morningStart || "";
    document.getElementById("morning-end").value = btn.dataset.morningEnd || "";
    document.getElementById("afternoon-start").value = btn.dataset.afternoonStart || "";
    document.getElementById("afternoon-end").value = btn.dataset.afternoonEnd || "";
    document.getElementById("evening-start").value = btn.dataset.eveningStart || "";
    document.getElementById("evening-end").value = btn.dataset.eveningEnd || "";

    // Hiển thị popup
    document.getElementById("editModal").style.display = "block";
  }

  function closeEditModal() {
    document.getElementById("editModal").style.display = "none";
  }

  function openBlockModal(btn) {
    document.getElementById("block-id").value = btn.dataset.id;
    document.getElementById("blockModal").style.display = "block";
  }

  function closeBlockModal() {
    document.getElementById("blockModal").style.display = "none";
  }

  // Đóng modal khi click ra ngoài
  window.onclick = function(event) {
    if (event.target === document.getElementById("editModal")) closeEditModal();
    if (event.target === document.getElementById("blockModal")) closeBlockModal();
  }
</script>
<script>
  function openAddDateModal() {
    const today = new Date().toISOString().slice(0,10);
    document.getElementById('add-date').value = today;

    document.querySelectorAll('input[name="actionType"]').forEach(r => r.checked = false);
    document.getElementById('blockFields').style.display = 'none';
    document.getElementById('editFields').style.display = 'none';
    document.getElementById('addDateError').style.display = 'none';
    document.getElementById('addDateModal').style.display = 'block';
  }

  function closeAddDateModal() {
    document.getElementById('addDateModal').style.display = 'none';
  }

  document.addEventListener('change', function(e) {
    if (e.target && e.target.name === 'actionType') {
      const v = document.querySelector('input[name="actionType"]:checked').value;
      document.getElementById('blockFields').style.display = (v === 'BLOCK') ? 'block' : 'none';
      document.getElementById('editFields').style.display  = (v === 'EDIT')  ? 'block' : 'none';
      document.getElementById('addDateError').style.display = 'none';
    }
  });

  function isPastDate(dateString) {
    const selected = new Date(dateString);
    selected.setHours(0,0,0,0);
    const today = new Date();
    today.setHours(0,0,0,0);
    return selected < today;
  }

  function submitAddDate() {
    const dateVal = document.getElementById('add-date').value;
    const actionRadio = document.querySelector('input[name="actionType"]:checked');
    const errorEl = document.getElementById('addDateError');

    if (!actionRadio) {
      errorEl.textContent = 'Vui lòng chọn hành động (Block hoặc Edit).';
      errorEl.style.display = 'block';
      return;
    }

    const action = actionRadio.value;

    if (!dateVal) {
      errorEl.textContent = 'Vui lòng chọn ngày.';
      errorEl.style.display = 'block';
      return;
    }

    if (isPastDate(dateVal)) {
      errorEl.textContent = 'Ngày bạn chọn đã qua. Vui lòng chọn ngày hiện tại hoặc tương lai.';
      errorEl.style.display = 'block';
      return;
    }

    if (action === 'BLOCK') {
      // Gán giá trị ngày và user rồi submit form thật
      document.getElementById('block-date').value = dateVal;
      document.getElementById('block-updated-by').value = document.getElementById('add-updated-by')?.value || '';
      document.getElementById('blockForm').submit();
    }
    else if (action === 'EDIT') {
      // Gán giá trị ngày và user rồi submit form thật
      document.getElementById('edit-date').value = dateVal;
      document.getElementById('edit-updated-by').value = document.getElementById('add-updated-by')?.value || '';

      // Kiểm tra các giờ (tùy chọn, giữ nguyên logic cũ)
      const ms = document.querySelector('#editForm [name="morning_start_time"]').value;
      const me = document.querySelector('#editForm [name="morning_end_time"]').value;
      const as = document.querySelector('#editForm [name="afternoon_start_time"]').value;
      const ae = document.querySelector('#editForm [name="afternoon_end_time"]').value;
      const es = document.querySelector('#editForm [name="evening_start_time"]').value;
      const ee = document.querySelector('#editForm [name="evening_end_time"]').value;


      if (!ms && !as && !es) {
        errorEl.textContent = 'Vui lòng nhập ít nhất 1 khung giờ cho ngày này.';
        errorEl.style.display = 'block';
        return;
      }

      const checkPair = (s,e) => (!!s && !!e) || (!s && !e);
      if (!checkPair(ms,me) || !checkPair(as,ae) || !checkPair(es,ee)) {
        errorEl.textContent = 'Mỗi buổi cần nhập cả thời gian bắt đầu và kết thúc hoặc để trống cả hai.';
        errorEl.style.display = 'block';
        return;
      }

      document.getElementById('editForm').submit();
    }
  }
</script>
<c:if test="${actionType == 'EDIT'}">
  <script>
    document.addEventListener("DOMContentLoaded", function() {
      document.getElementById('addDateModal').style.display = 'block';
      document.querySelector('input[name="actionType"][value="EDIT"]').checked = true;
      document.getElementById('editFields').style.display = 'block';
    });
  </script>
</c:if>
<c:if test="${not empty er}">
  <script>
    document.addEventListener("DOMContentLoaded", function() {
      // mở modal + show lỗi
      const modal = document.getElementById('addDateModal');
      const errorEl = document.getElementById('addDateError');

      modal.style.display = 'block';
      errorEl.textContent = '${er}';
      errorEl.style.display = 'block';
    });
  </script>
</c:if>

</body>
</html>
