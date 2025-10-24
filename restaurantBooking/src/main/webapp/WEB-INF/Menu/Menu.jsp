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
                padding: 25px 40px;
                margin: 8px 10px 10px 1px;
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
                top: 111px;
                bottom: 0;
                left: 0;
                color: #fff;
                padding-top: 44px;
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
                position: relative;
                background-image: url('https://images.unsplash.com/photo-1600891964599-f61ba0e24092?auto=format&fit=crop&w=1200&q=80');
                background-size: cover;
                background-position: center;
                display: flex;
                justify-content: space-between;
                align-items: center;
                background-color: #fff;
                border-radius: 8px;
                box-shadow: 0 2px 6px rgba(0,0,0,0.1);
                padding: 15px 20px;
                margin-bottom: 25px;
                margin-top: 37px;
            }
            .filter-section::before {
                content: "";
                position: absolute;
                top: 0; left: 0; right: 0; bottom: 0;
                background-color: rgba(140,0,0,0.5); /* 0.5 = mờ 50%, chỉnh tùy ý */
                z-index: 0;
                border-radius: 8px;
            }

            /* đảm bảo nội dung nằm trên lớp mờ */
            .filter-section > * {
                position: relative;
                z-index: 1;
            }
            .filter-section h3 {
                margin: 0;
                color: white;
                font-weight: 600;
            }
            .voucher-select {
                position: relative;
                top: -9px;
                left: 8px;
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
            <div class="filter-section" >
                <h3>Danh sách Voucher</h3>

                <div>
                    <form action="Menu_manage" method="get">
                        <select name="categoryId"  class="voucher-select" id="menuCategorySelect" onchange="this.form.submit()">
                            <c:forEach var="o" items="${listMenuCategory}">
                                <option value="${o.id_menuCategory}" ${kaku == o.id_menuCategory ? 'selected' : ''}>${o.categoryName}</option>
                            </c:forEach>

                        </select>
                        <button type="submit" hidden></button>
                    </form>

                    <button class="btn btn-add ms-3">+ Thêm món mới</button>
                </div>
            </div>
        <!-- Modal Thêm Voucher -->
        <div class="modal fade" id="addMenuModal" tabindex="-1" aria-labelledby="addVoucherLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <form action="AddMenu" method="post" >
                        <div class="modal-header">
                            <h5 class="modal-title" id="addVoucherLabel">Thêm Món Mới</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                        </div>
                        <div class="modal-body">
                            <div id="addErrorMsg" class="alert alert-danger d-none"></div>
                        <input type="hidden" name="action" value="add">
                        <div class="mb-3">
                            <label for="addMenuName" class="form-label">Tên món</label>
                            <input type="text" class="form-control" id="addMenuName" name="itemName" value="${param.itemName != null ? param.itemName : ''}">
                        </div>
                        <div class="mb-3">
                            <label for="addDishCode" class="form-label">Mã món</label>
                            <input type="text" class="form-control" id="addDishCode" name="code_dish" value="${param.code_dish != null ? param.code_dish : ''}" readonly>
                        </div>
                        <div class="mb-3">
                            <label for="addMenuDescription" class="form-label">Mô tả</label>
                            <textarea class="form-control" id="menuDescription" name="description" rows="2">${param.description != null ? param.description : ''}</textarea>
                        </div>
                        <div class="mb-3">
                            <label for="addMenuPrice" class="form-label">Giá</label>
                            <input type="number" class="form-control" id="addMenuPrice" name="price" min="0" value="${param.price != null ? param.price : ''}">
                        </div>
                        <div class="mb-3">
                            <label for="addDishImage" class="form-label">Ảnh món ăn</label>
                            <div class="mb-2 text-center">
                                <img id="imagePreview" src="${param.imageUrl != null ? param.imageUrl : '/images/no-image.png'}" alt="Xem trước ảnh" class="img-thumbnail" style="max-width:200px; max-height:200px;">
                            </div>
                            <input type="file" class="form-control" id="addDishImage" name="imageFile" accept="image/*" onchange="previewImage(event)">
                        </div>
                        <div class="mb-3">
                            <label for="addMenuStatus" class="form-label">Trạng thái</label>
                            <select class="form-select" id="addMenuStatus" name="status">
                                <option value="AVAILABLE" ${param.status == 'AVAILABLE' ? 'selected' : ''}>AVAILABLE</option>
                                <option value="UNAVAILABLE" ${param.status == 'UNAVAILABLE' ? 'selected' : ''}>UNAVAILABLE</option>
                                <option value="ARCHIVED" ${param.status == 'ARCHIVED' ? 'selected' : ''}>ARCHIVED</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="addMenuCategory" class="form-label">Thể loại</label>
                            <select class="form-select" id="addMenuCategory" name="categoryId">
                                <c:forEach var="o" items="${listMenuCategory}">
                                    <option value="${o.id_menuCategory}">${o.categoryName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <input type="hidden" name="created_by" value="${sessionScope.userId}">
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
                <c:forEach var="o" items="${menuList}">
                    <div class="col-md-4 col-sm-6">
                        <div class="card-voucher h-100">
                            <!-- Hình ảnh voucher -->
                            <img src="${pageContext.request.contextPath}/images/${o.imageUrl != null ? o.imageUrl : 'no-image.png'}"
                                 class="card-img-top"
                                 alt="Voucher Image"
                                 style="height:180px; object-fit:cover;">

                            <div class="card-body d-flex flex-column">
                                <h5 class="card-title">${o.itemName}</h5>
                                <h6 class="card-title">Mã món: ${o.itemCode}</h6>
                                <p class="card-text flex-grow-1">
                                        ${o.description}.  Thời gian tạo:  ${o.created_At}
                                </p>
                                <div class="d-flex justify-content-between align-items-center">
                                    <span class="badge bg-success badge-status">${o.status}</span>
                                    <small class="text-muted">Giá: <strong>${o.price}</strong> </small>
                                </div>
                                <div class="mt-3 d-flex justify-content-between">
                                    <button class="btn btn-sm btn-primary btn-edit"
                                            data-id="${o.itemId}"
                                            data-name="${o.itemName}"
                                            data-desc="${o.description}"
                                            data-price="${o.price}"
                                            data-code="${o.itemCode}"
                                            data-image="${o.imageUrl}"
                                            data-status="${o.status}"
                                            data-category="${o.category_name}">

                                        Sửa
                                    </button>
                                    <button class="btn btn-sm btn-danger btn-delete"
                                            data-id="${o.itemId}"
                                            data-name="${o.itemName}">
                                        Xóa
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>


    </div>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const editButtons = document.querySelectorAll(".btn-edit");
            const deleteButtons = document.querySelectorAll(".btn-delete");

            const editModal = new bootstrap.Modal(document.getElementById('editMenuModal'));
            const deleteModal = new bootstrap.Modal(document.getElementById('deleteMenuModal'));

            // Nút SỬA
            editButtons.forEach(btn => {
                btn.addEventListener("click", () => {
                    const id = btn.dataset.id || '';
                    const name = btn.dataset.name || '';
                    const desc = btn.dataset.desc || '';
                    const price = btn.dataset.price || '';
                    const code = btn.dataset.code || '';
                    const image = btn.dataset.image || '';
                    const status = btn.dataset.status || 'AVAILABLE';
                    const category = btn.dataset.category || '';

                    document.getElementById("menuIdEdit").value = id;
                    document.getElementById("menuNameEdit").value = name;
                    document.getElementById("menuDescriptionEdit").value = desc;
                    document.getElementById("priceEdit").value = price;
                    document.getElementById("menuCodeEdit").value = code;

                    document.getElementById("menuStatusEdit").value = status;
                    document.getElementById("menuCategoryEdit").value = category;

                    const preview = document.getElementById("imagePreviewEdit");
                    if (preview && image) {
                        preview.src = `${ctx}/images/${image}`;
                    }

                    editModal.show();
                });

            });

            // Nút XÓA
            deleteButtons.forEach(btn => {
                btn.addEventListener("click", () => {
                    document.getElementById("deleteMenuId").value = btn.dataset.id;
                    document.getElementById("deleteMenuName").textContent = btn.dataset.name;

                    deleteModal.show();
                });
            });
        });
    </script>
    <script>
        function previewImage(event) {
            const reader = new FileReader();
            reader.onload = function(){
                const output = document.getElementById('imagePreview');
                output.src = reader.result;
            };
            reader.readAsDataURL(event.target.files[0]);
        }
    </script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // JavaScript thay đổi nội dung khi chọn cấp voucher
        document.getElementById("menuCategorySelect").addEventListener("change", function() {
            const selected = this.value;
            // TODO: thêm code load danh sách voucher tương ứng cấp
            console.log("Đang chọn:", selected);
        });
    </script>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            // Modal thêm voucher
            const addModal = new bootstrap.Modal(document.getElementById("addMenuModal"));
            document.querySelector(".btn-add").addEventListener("click", () => {
                addModal.show();
            });
        });
    </script>


    <!-- Modal Sửa Voucher -->
    <div class="modal fade" id="editMenuModal" tabindex="-1" aria-labelledby="editVoucherLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">

                <!-- CHÚ Ý: enctype để upload file -->
                <form action="Menu_manage" method="post" >
                    <div class="modal-header">
                        <h5 class="modal-title" id="editVoucherLabel">Sửa món ăn</h5>
                            <c:if test="${not empty errorMessage}">
                            <script>
                                window.addEventListener("load", function() {
                                    var modal = new bootstrap.Modal(document.getElementById("editMenuModal"));
                                    modal.show();
                                    document.getElementById("editErrorMsg").classList.remove("d-none");
                                    document.getElementById("editErrorMsg").innerText = "${errorMessage}";
                                });
                            </script>
                        </c:if>

                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                    </div>
                    <div class="modal-body">
                        <div id="editErrorMsg" class="alert alert-danger d-none"></div>

                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="id" id="menuIdEdit" value="${param.id != null ? param.id : ''}">



                        <div class="mb-3">
                            <label for="menuCode" class="form-label">Mã món</label>
                            <input type="text" class="form-control" id="menuCodeEdit" name="itemCode" value="${param.itemCode != null ? param.itemCode : ''}" readonly>
                        </div>

                        <div class="mb-3">
                            <label for="menuName" class="form-label">Tên món</label>
                            <input type="text" class="form-control" id="menuNameEdit" name="menuName" value="${param.menuName != null ? param.menuName : ''}" >
                        </div>

                        <div class="mb-3">
                            <label for="menuDescription" class="form-label">Mô tả</label>
                            <textarea class="form-control" id="menuDescriptionEdit" name="description" rows="2">${param.description != null ? param.description : ''}</textarea>
                        </div>

                        <div class="mb-3">
                            <label for="price" class="form-label">Giá</label>
                            <input type="number" class="form-control" id="priceEdit" name="price"  value="${param.price != null ? param.price : ''}">
                        </div>

                        <div class="mb-3">
                            <label for="addDishImage" class="form-label">Ảnh món ăn</label>
                            <div class="mb-2 text-center">
                                <img id="imagePreview" src="${param.imageUrl != null ? param.imageUrl : '/images/no-image.png'}" alt="Xem trước ảnh" class="img-thumbnail" style="max-width:200px; max-height:200px;">
                            </div>
                            <input type="file" class="form-control" id="menuImageEdit" name="imageFile" accept="image/*" onchange="previewImage(event)">
                            <small class="text-muted">Nếu không chọn file mới, ảnh cũ sẽ được giữ.</small>
                        </div>

                        <div class="mb-3">
                            <label for="addMenuStatus" class="form-label">Trạng thái</label>
                            <select class="form-select" id="menuStatusEdit" name="status">
                                <option value="AVAILABLE">AVAILABLE</option>
                                <option value="UNAVAILABLE">UNAVAILABLE</option>
                                <option value="ARCHIVED">ARCHIVED</option>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label for="addMenuCategory" class="form-label">Thể loại</label>
                            <select class="form-select" id="menuCategoryEdit" name="categoryId">
                                <c:forEach var="o" items="${listMenuCategory}">
                                    <option value="${o.id_menuCategory}">${o.categoryName}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <input type="hidden" name="updated_by" value="${sessionScope.userId}">
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const modals = document.querySelectorAll('.modal');
            modals.forEach(modal => {
                modal.addEventListener('hidden.bs.modal', function () {
                    document.querySelectorAll('.modal-backdrop').forEach(e => e.remove());
                    document.body.classList.remove('modal-open');
                    document.body.style.overflow = '';
                });
            });
        });
    </script>

    <!-- Modal Xóa Voucher -->
    <div class="modal fade" id="deleteMenuModal" tabindex="-1" aria-labelledby="deleteVoucherLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <form action="DeleteMenu" method="post">
                    <div class="modal-header">
                        <h5 class="modal-title text-danger" id="deleteVoucherLabel">Xác nhận xóa voucher</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="id" id="deleteMenuId">
                        <p>Bạn có chắc chắn muốn xóa voucher <strong id="deleteMenuName"></strong> không?</p>
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
                        <a class="page-link" href="Menu_manage?categoryId=${kaku}&page=${currentPage - 1}">Trước</a>
                    </li>
                </c:if>

                <c:forEach var="i" begin="1" end="${totalPages}">
                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                        <a class="page-link" href="Menu_manage?categoryId=${kaku}&page=${i}">${i}</a>
                    </li>
                </c:forEach>

                <c:if test="${currentPage < totalPages}">
                    <li class="page-item">
                        <a class="page-link" href="Menu_manage?categoryId=${kaku}&page=${currentPage + 1}">Sau</a>
                    </li>
                </c:if>
            </ul>
        </nav>
    </div>
    <script>
        // ✅ Hàm sinh mã món ngẫu nhiên
        function generateDishCode() {
            const randomNum = Math.floor(10000 + Math.random() * 90000);
            return "MON" + randomNum;
        }

        document.addEventListener("DOMContentLoaded", function () {
            const addModalElement = document.getElementById("addMenuModal");
            if (!addModalElement) return;

            const addModal = new bootstrap.Modal(addModalElement);
            const codeInput = document.getElementById("addDishCode");
            const form = addModalElement.querySelector("form");
            const addButton = document.querySelector(".btn-add"); // nút "Thêm món mới"

            // ✅ Khi modal mở → reset form + ẩn lỗi cũ + sinh mã mới
            addModalElement.addEventListener("show.bs.modal", function () {


                // Sinh mã món mới
                if (codeInput) {
                    codeInput.value = generateDishCode();
                }
            });

            // ✅ Khi modal đóng → dọn dẹp
            addModalElement.addEventListener("hidden.bs.modal", function () {
                if (form) form.reset();
                if (codeInput) codeInput.value = "";
                const err = document.getElementById("addErrorMsg");
                if (err) {
                    err.classList.add("d-none");
                    err.textContent = "";
                }
                // Loại bỏ backdrop dư (fix lỗi modal bị đen mờ)
                document.querySelectorAll('.modal-backdrop').forEach(e => e.remove());
                document.body.classList.remove('modal-open');
                document.body.style.overflow = '';
            });

            // ✅ Nút “Thêm món mới” mở modal
            if (addButton) {
                addButton.addEventListener("click", function (e) {
                    e.preventDefault();
                    addModal.show();
                });
            }
        });


    </script>

    <%
        String errorMsg = (String) request.getAttribute("errorMessageee");
        if (errorMsg != null && !errorMsg.trim().isEmpty()) {
    %>
    <script>
        window.addEventListener("load", function() {
            const modalElement = document.getElementById("addMenuModal");
            const addModal = new bootstrap.Modal(modalElement);
            const errorDiv = document.getElementById("addErrorMsg");

            if (errorDiv) {
                errorDiv.classList.remove("d-none");
                errorDiv.textContent = "<%= errorMsg.replace("\"", "\\\"") %>";
            }

            addModal.show();
        });
    </script>
    <% } %>

    </body>
    </html>
