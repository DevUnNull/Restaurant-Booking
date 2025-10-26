<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Quản lý Voucher</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body {
      background-color: #f8f9fa;
      font-family: 'Segoe UI', sans-serif;
    }
    .header {
      background-color: #b23627;
      color: #fff;
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 15px 40px;
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      z-index: 1000;
    }

    .header .logo {
      font-size: 2rem;
      font-weight: 700;
      letter-spacing: 1px;
    }

    .header nav ul {
      list-style: none;
      display: flex;
      margin: 0;
      padding: 0;
    }

    .header nav ul li {
      margin-left: 25px;
    }

    .header nav ul li a {
      color: #fff;
      text-decoration: none;
      font-weight: 500;
      transition: 0.3s;
    }

    .header nav ul li a:hover {
      text-decoration: underline;
      color: #ffcccb;
    }
    .sidebar {
      width: 250px;
      background-color: #8c2a1f;
      position: fixed;
      top: 65px;
      bottom: 0;
      left: 0;
      color: #fff;
      padding-top: 20px;
      overflow-y: auto;
    }

    .sidebar h2 {
      font-size: 1.2rem;
      text-align: center;
      margin-bottom: 20px;
      color: #fff;
    }

    .sidebar ul {
      list-style: none;
      padding: 0;
      margin: 0;
    }

    .sidebar ul li {
      margin-bottom: 5px;
    }

    .sidebar ul li a {
      display: block;
      color: #fff;
      text-decoration: none;
      padding: 12px 20px;
      transition: 0.3s;
    }

    .sidebar ul li a:hover, .sidebar ul li a.active {
      background-color: #91291e;
    }
    .content {
      margin-left: 250px;
      margin-top: 70px;
      padding: 20px;
    }

    /* Bộ lọc dạng select */
    .filter-section {
      display: flex;
      justify-content: space-between;
      align-items: center;
      background-color: #fff;
      border-radius: 8px;
      box-shadow: 0 2px 6px rgba(0,0,0,0.1);
      padding: 15px 20px;
      margin-bottom: 25px;
    }
    .filter-section h3 {
      margin: 0;
      color: #8b0000;
      font-weight: 600;
    }
    .voucher-select {
      position: relative;
      top: -9px;
      left: 27px;
      border: 2px solid #a52a2a;
      border-radius: 6px;
      padding: 8px 12px;
      color: #8b0000;
      font-weight: 500;
      background-color: #fff;
      transition: 0.2s;
    }
    .voucher-select:focus {
      outline: none;
      border-color: #8b0000;
      box-shadow: 0 0 5px rgba(165,42,42,0.4);
    }

    .card-voucher {
      border-radius: 10px;
      overflow: hidden;
      box-shadow: 0 2px 6px rgba(0,0,0,0.1);
      transition: transform .2s ease;
      background: #fff;
    }
    .card-voucher:hover {
      transform: translateY(-4px);
    }
    .card-voucher .card-body {
      padding: 15px;
    }
    .badge-status {
      font-size: .8rem;
    }
    .btn-add {
      background-color: #a52a2a;
      color: #fff;
    }
    .btn-add:hover {
      background-color: #8b0000;
    }
    .is-invalid {
      border-color: #dc3545 !important;
      box-shadow: 0 0 0 0.1rem rgba(220,53,69,.25);
    }
    .card-voucher {
      border-radius: 10px;
      overflow: hidden;
      box-shadow: 0 2px 6px rgba(0,0,0,0.1);
      transition: transform .2s ease;
      background: #fff;
      height: 100%; /* Chiều cao đầy đủ trong cột */
      display: flex;
      flex-direction: column;
    }

    .card-voucher .card-body {
      display: flex;
      flex-direction: column;
      height: 100%;
    }

    .card-voucher .card-text {
      flex-grow: 1; /* đẩy các nút xuống cuối */
      color: #555;
      font-size: 0.95rem;
    }

    .card-voucher:hover {
      transform: translateY(-4px);
    }

    .card-voucher h5 {
      font-size: 1.1rem;
      font-weight: 600;
      color: #8b0000;
      margin-bottom: 10px;
    }
  </style>
</head>
<body>

<!-- Header -->
<%--<div class="header">--%>
<%--  <h1>Restaurant Booking - Quản lý Voucher</h1>--%>
<%--  <div>--%>
<%--    <a href="#" style="color:#fff; text-decoration:none; margin-right:15px;">Trang chủ</a>--%>
<%--    <a href="#" style="color:#fff; text-decoration:none; margin-right:15px;">Đặt bàn</a>--%>
<%--    <a href="#" style="color:#fff; text-decoration:none;">Menu</a>--%>
<%--    <a href="#" style="color:#fff; text-decoration:none;">Voucher</a>--%>
<%--  </div>--%>
<%--</div>--%>
<div class="header">
  <div class="logo">Restaurant_Booking</div>
  <nav>
    <ul>
      <li><a href="#">Trang chủ</a></li>
      <li><a href="#">Đặt bàn</a></li>
      <li><a href="#">Menu</a></li>
      <li><a href="Voucher" class="active">Voucher</a></li>
    </ul>
  </nav>
</div>

<%--<ul>--%>
<%--  <li><a href="#">Dashboard</a></li>--%>
<%--  <li><a href="ServiceList">Dịch vụ</a></li>--%>
<%--  <!-- nếu quyền là admin Restaurant thì hiện  -->--%>
<%--  <li><a href="ServiceManage">Quản lý dịch vụ</a></li>--%>
<%--  <li><a href="Comment">Quản lý đánh giá bình luận</a></li>--%>

<%--  <li><a href="#">Quản lý Menu</a></li>--%>
<%--  <li><a href="Voucher">Quản lý Voucher khuyến mãi </a></li>--%>
<%--  <li><a href="#">Quản lý khách hàng thân thiết </a></li>--%>
<%--  <li><a href="Blog">Quản lý Blog</a></li>--%>
<%--</ul>--%>
<!-- Sidebar -->
<div class="sidebar">
  <h2>Staff Panel</h2>
  <ul>
    <li><a href="#">Dashboard</a></li>
    <li><a href="ServiceList">Dịch vụ</a></li>
    <li><a href="ServiceManage">Quản lý dịch vụ</a></li>
    <li><a href="Comment">Quản lý đánh giá bình luận</a></li>
    <li><a href="#">Quản lý Menu</a></li>
    <li><a href="Voucher" class="active">Quản lý Voucher khuyến mãi</a></li>
    <li><a href="#">Quản lý khách hàng thân thiết</a></li>
  </ul>
</div>

<!-- Content -->
<div class="content">

  <!-- Bộ lọc voucher -->
  <div class="filter-section">
    <h3>Danh sách Voucher</h3>

    <div>
      <form action="Voucher" method="get">
        <select name="idlevel"  class="voucher-select" id="voucherLevel" onchange="this.form.submit()">
          <option value="1" ${kaku == 1 ? 'selected' : ''}>Voucher cấp 1</option>
          <option value="2" ${kaku == 2 ? 'selected' : ''}>Voucher cấp 2</option>
          <option value="3" ${kaku == 3 ? 'selected' : ''}>Voucher cấp 3</option>
        </select>
        <button type="submit" hidden></button>
      </form>

      <button class="btn btn-add ms-3">+ Thêm voucher mới</button>
    </div>
  </div>
  <!-- Modal Thêm Voucher -->
  <div class="modal fade" id="addVoucherModal" tabindex="-1" aria-labelledby="addVoucherLabel" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <form action="AddVoucher" method="post">
          <div class="modal-header">
            <h5 class="modal-title" id="addVoucherLabel">Thêm Voucher Mới</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
          </div>


          <div class="modal-body">

            <div id="addErrorMsg" class="alert alert-danger d-none"></div>
            <input type="hidden" name="action" value="add">

            <div class="mb-3">
              <label for="addVoucherName" class="form-label">Tên voucher</label>
              <input type="text" class="form-control" id="addVoucherName" name="promotionName" value="${param.promotionName != null ? param.promotionName : ''}" >
            </div>

            <div class="mb-3">
              <label for="addVoucherDescription" class="form-label">Mô tả</label>
              <input type="text" class="form-control" id="addVoucherDescription" name="description" value="${param.description != null ? param.description : ''}">
            </div>

            <div class="mb-3">
              <label for="addVoucherDiscount" class="form-label">Phần trăm giảm (%)</label>
              <input type="number" class="form-control" id="addVoucherDiscount" name="discount_percentage" min="0" max="100" value="${param.discount_percentage != null ? param.discount_percentage : ''}">
            </div>

            <div class="mb-3">
              <label for="addVoucherAmount" class="form-label">Số tiền giảm (nếu có)</label>
              <input type="number" class="form-control" id="addVoucherAmount" name="discount_amount" placeholder="Nhập số tiền giảm..." value="${param.discount_amount != null ? param.discount_amount : ''}">
            </div>

            <div class="mb-3">
              <label class="form-label">Thời gian hiệu lực</label>
              <div class="d-flex gap-2">
                <input type="date" class="form-control" id="addVoucherStart" name="start_date" value="${param.start_date != null ? param.start_date : ''}" >
                <input type="date" class="form-control" id="addVoucherEnd" name="end_date" value="${param.end_date != null ? param.end_date : ''}" >
              </div>
            </div>

            <div class="mb-3">
              <label for="addVoucherStatus" class="form-label">Trạng thái</label>
              <select class="form-select" id="addVoucherStatus" name="status">
                <option value="ACTIVE">ACTIVE</option>
                <option value="INACTIVE">INACTIVE</option>
              </select>
            </div>
<input type="hidden" name="created_by" value="${sessionScope.userId}">
            <div class="mb-3">
              <label for="addVoucherLevel" class="form-label">Cấp độ Voucher</label>
              <select class="form-select" id="addVoucherLevel" name="promotion_level_id" >
                <option value="1">Cấp 1</option>
                <option value="2">Cấp 2</option>
                <option value="3">Cấp 3</option>
              </select>
            </div>
          </div>


          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
            <button type="submit" class="btn btn-add">Thêm mới</button>
          </div>
        </form>
      </div>
    </div>
  </div>

  <div class="row g-4" id="voucherList">
    <c:forEach var="o" items="${promotions}">
      <div class="col-md-4 col-sm-6">
        <div class="card-voucher h-100">
          <div class="card-body d-flex flex-column">
            <h5 class="card-title">${o.promotionName}</h5>
            <p class="card-text flex-grow-1">
                ${o.description}. Hạn dùng ${o.start_date} - ${o.end_date}
            </p>
            <div class="d-flex justify-content-between align-items-center">
              <span class="badge bg-success badge-status">${o.status}</span>
              <small class="text-muted">${o.discount_percentage}%</small>
            </div>
            <div class="mt-3 d-flex justify-content-between">
              <button class="btn btn-sm btn-primary btn-edit"
                      data-id="${o.promotion_id}"
                      data-name="${o.promotionName}"
                      data-desc="${o.description}"
                      data-discount="${o.discount_percentage}"
                      data-start="${o.start_date}"
                      data-end="${o.end_date}">

                Sửa
              </button>
              <button class="btn btn-sm btn-danger btn-delete"
                      data-id="${o.promotion_id}"
                      data-name="${o.promotionName}">
                Xóa
              </button>
            </div>
          </div>
        </div>
      </div>
    </c:forEach>
  </div>


</div>



<!-- Modal Sửa Voucher -->
<div class="modal fade" id="editVoucherModal" tabindex="-1" aria-labelledby="editVoucherLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">

      <form action="Voucher" method="post">
        <div class="modal-header">
          <h5 class="modal-title" id="editVoucherLabel">Sửa thông tin Voucher</h5>


          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
        </div>
        <div class="modal-body">
          <div id="editErrorMsg" class="alert alert-danger d-none"></div>
          <input type="hidden" name="action" value="update">
          <input type="hidden" name="id" id="voucherId" value="${param.id != null ? param.id : ''}">

          <div class="mb-3">
            <label for="voucherName" class="form-label">Tên voucher</label>
            <input type="text" class="form-control" id="voucherName" name="promotionName" value="${param.promotionName != null ? param.promotionName : ''}" >
          </div>

          <div class="mb-3">
            <label for="voucherDescription" class="form-label">Mô tả</label>
         <input    class="form-control" id="voucherDescription" name="description"  rows="2" value="${param.description != null ? param.description : ''}">
          </div>

          <div class="mb-3">
            <label for="voucherDiscount" class="form-label">Phần trăm giảm</label>
            <input type="number" class="form-control" id="voucherDiscount" name="discount_percentage" min="0" max="100" value="${param.discount_percentage != null ? param.discount_percentage : ''}">
          </div>
<input type="hidden" name="updated_by" value="${sessionScope.userId}">

          <div class="mb-3">
            <label class="form-label">Thời gian hiệu lực</label>
            <div class="d-flex gap-2">
              <input type="date" class="form-control" id="voucherStart" name="start_date"value="${param.start_date != null ? param.start_date : ''}">
              <input type="date" class="form-control" id="voucherEnd" name="end_date" value="${param.end_date != null ? param.end_date : ''}">
            </div>
          </div>
          <div class="mb-3">
            <label for="addVoucherLevel" class="form-label">Cấp độ Voucher</label>
            <select class="form-select" id="addVoucherLevel" name="promotion_level_id" >
              <option value="1">Cấp 1</option>
              <option value="2">Cấp 2</option>
              <option value="3">Cấp 3</option>
            </select>
          </div>

        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
          <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- Modal Xóa Voucher -->
<div class="modal fade" id="deleteVoucherModal" tabindex="-1" aria-labelledby="deleteVoucherLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <form action="DeleteVoucher" method="post">
        <div class="modal-header">
          <h5 class="modal-title text-danger" id="deleteVoucherLabel">Xác nhận xóa voucher</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
        </div>
        <div class="modal-body">
          <input type="hidden" name="action" value="delete">
          <input type="hidden" name="id" id="deleteVoucherId">
          <p>Bạn có chắc chắn muốn xóa voucher <strong id="deleteVoucherName"></strong> không?</p>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
          <button type="submit" class="btn btn-danger">Xóa</button>
        </div>
      </form>
    </div>
  </div>
</div>
<div class="d-flex justify-content-center mt-4">
  <nav aria-label="Voucher pagination">
    <ul class="pagination">
      <c:if test="${currentPage > 1}">
        <li class="page-item">
          <a class="page-link" href="Voucher?page=${currentPage - 1}">Trước</a>
        </li>
      </c:if>

      <c:forEach var="i" begin="1" end="${totalPages}">
        <li class="page-item ${i == currentPage ? 'active' : ''}">
          <a class="page-link" href="Voucher?page=${i}">${i}</a>
        </li>
      </c:forEach>

      <c:if test="${currentPage < totalPages}">
        <li class="page-item">
          <a class="page-link" href="Voucher?page=${currentPage + 1}">Sau</a>
        </li>
      </c:if>
    </ul>
  </nav>
</div>
<script>
  document.addEventListener("DOMContentLoaded", function() {

    // ✅ Chỉ tạo 1 instance modal duy nhất
    const editModal = new bootstrap.Modal(document.getElementById("editVoucherModal"));

    // ====== 1️⃣ Xử lý nút “Sửa” ======
    document.querySelectorAll(".btn-edit").forEach(btn => {
      btn.addEventListener("click", () => {
        // Gán dữ liệu vào form
        document.getElementById("voucherId").value = btn.dataset.id;
        document.getElementById("voucherName").value = btn.dataset.name;
        document.getElementById("voucherDescription").value = btn.dataset.desc;
        document.getElementById("voucherDiscount").value = btn.dataset.discount;
        document.getElementById("voucherStart").value = btn.dataset.start;
        document.getElementById("voucherEnd").value = btn.dataset.end;

        // Mở modal
        editModal.show();
      });
    });

    // ====== 2️⃣ Nếu có lỗi từ servlet ======
    <% if (request.getAttribute("errorMessage") != null) { %>
    const errorMsg = "<%= request.getAttribute("errorMessage") %>";
    const errorDiv = document.getElementById("editErrorMsg");
    errorDiv.classList.remove("d-none");
    errorDiv.textContent = errorMsg;
    // ⚡ Mở lại modal để hiển thị lỗi
    editModal.show();
    <% } %>

  });
</script>
<script>
  document.addEventListener("DOMContentLoaded", function() {
    const editButtons = document.querySelectorAll(".btn-edit");
    const deleteButtons = document.querySelectorAll(".btn-delete");
    const deleteModal = new bootstrap.Modal(document.getElementById('deleteVoucherModal'));

    // Nút SỬA
    editButtons.forEach(btn => {
      btn.addEventListener("click", () => {
        document.getElementById("voucherId").value = btn.dataset.id;
        document.getElementById("voucherName").value = btn.dataset.name;
        document.getElementById("voucherDescription").value = btn.dataset.desc;
        document.getElementById("voucherDiscount").value = btn.dataset.discount;
        document.getElementById("voucherStart").value = btn.dataset.start;
        document.getElementById("voucherEnd").value = btn.dataset.end;
        editModal.show();
      });
    });

    // Nút XÓA
    deleteButtons.forEach(btn => {
      btn.addEventListener("click", () => {
        document.getElementById("deleteVoucherId").value = btn.dataset.id;
        document.getElementById("deleteVoucherName").textContent = btn.dataset.name;
        deleteModal.show();
      });
    });
  });
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
  // JavaScript thay đổi nội dung khi chọn cấp voucher
  document.getElementById("voucherLevel").addEventListener("change", function() {
    const selected = this.value;
    // TODO: thêm code load danh sách voucher tương ứng cấp
    console.log("Đang chọn:", selected);
  });
</script>
<script>
  document.addEventListener("DOMContentLoaded", function() {
    // Modal thêm voucher
    const addModal = new bootstrap.Modal(document.getElementById("addVoucherModal"));
    document.querySelector(".btn-add").addEventListener("click", () => {
      addModal.show();
    });
  });
</script>
<script>
  document.addEventListener("DOMContentLoaded", function() {
    <% if (request.getAttribute("errorMessageee") != null) { %>
    const errorMsg = "<%= request.getAttribute("errorMessageee") %>";
    const errorDiv = document.getElementById("addErrorMsg");

    // Gỡ class ẩn và hiển thị lỗi
    errorDiv.classList.remove("d-none");
    errorDiv.textContent = errorMsg;

    // Mở lại modal "Thêm voucher"
    const addModal = new bootstrap.Modal(document.getElementById('addVoucherModal'));
    addModal.show();
    <% } %>
  });
</script>
</body>
</html>
