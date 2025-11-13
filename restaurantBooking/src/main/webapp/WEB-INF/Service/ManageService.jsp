<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý dịch vụ</title>
    <link rel="stylesheet" href="styles.css">
    <link rel="stylesheet" href="styless.css">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=Roboto:wght@400;700&display=swap" rel="stylesheet">
    <link href="css/ServiceManage.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">

</head>

<style>
    .action-btn {
        margin-right: 6px; /* tạo khoảng cách giữa 2 nút */
    }
    /* Nút thêm dịch vụ */
    .add-btn {
        background-color: #c0392b; /* Đỏ đậm sang trọng */
        color: #fff; /* Chữ trắng */
        border: none;
        padding: 10px 22px;
        font-size: 16px;
        font-weight: bold;
        border-radius: 8px;
        cursor: pointer;
        float: right; /* Đưa sang phải */
        margin-bottom: 15px;
        box-shadow: 0 4px 10px rgba(192, 57, 43, 0.3);
        transition: all 0.3s ease;
    }

    /* Hiệu ứng hover */
    .add-btn:hover {
        background-color: #e74c3c;
        box-shadow: 0 6px 12px rgba(231, 76, 60, 0.4);
        transform: translateY(-2px);
    }

    /* Khi bấm giữ */
    .add-btn:active {
        background-color: #a93226;
        transform: translateY(0);
    }
    .filter-section {
        position: relative;
        background-image: url('https://images.unsplash.com/photo-1600891964599-f61ba0e24092?auto=format&fit=crop&w=1200&q=80'); /* ảnh banner */
        background-size: cover;
        background-position: center;
        height: 120px;
        border-radius: 10px;
        margin: 20px;
        display: flex;
        align-items: center;
        box-shadow: 0 4px 10px rgba(0,0,0,0.2);
        overflow: hidden;
    }

    /* Lớp phủ mờ */
    .filter-section::before {
        content: "";
        position: absolute;
        inset: 0;
        background: rgba(0,0,0,0.4);
        z-index: 1;
    }

    /* Nội dung bên trong */
    .filter-content {
        position: relative;
        z-index: 2;
        width: 100%;
        display: flex;
        justify-content: space-between;
        align-items: center;
        color: white;
        padding: 0 30px;
    }

    /* Tiêu đề bên trái */
    .filter-title {
        font-size: 26px;
        font-weight: bold;
        margin: 0;
    }

    /* Dropdown + nút bên phải */
    .filter-actions {
        display: flex;
        align-items: center;
        gap: 10px;
    }

    /* Dropdown */
    .category-select {
        padding: 8px 14px;
        border-radius: 6px;
        border: none;
        background: rgba(255,255,255,0.9);
        color: #333;
        font-weight: 500;
    }

    /* Nút thêm */
    .add-btn {
        background-color: #b52a1a;
        color: white;
        border: none;
        padding: 10px 18px;
        border-radius: 6px;
        font-weight: bold;
        cursor: pointer;
        transition: all 0.3s ease;
    }

    .add-btn:hover {
        background-color: #d63a2a;
        transform: translateY(-2px);
    }
    .modal {
        display: none;
        position: fixed;
        z-index: 1000;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        background: rgba(0,0,0,0.5);
    }

    /* Khung popup */
    .modal-content {
        background: #fff;
        margin: 5% auto;
        padding: 20px 30px;
        border-radius: 10px;
        width: 70%;
        max-height: 80vh; /* Giới hạn chiều cao */
        overflow-y: auto; /* Thanh cuộn nếu nhiều món */
        box-shadow: 0 8px 20px rgba(0,0,0,0.3);
    }

    /* Nút X */
    .close {
        float: right;
        font-size: 26px;
        cursor: pointer;
        color: #333;
    }
    .close:hover {
        color: #b52a1a;
    }

    /* Bảng món */
    .combo-items table {
        width: 100%;
        border-collapse: collapse;
    }
    .combo-items th, .combo-items td {
        border: 1px solid #ccc;
        padding: 10px;
    }
    .combo-items th {
        background: #b52a1a;
        color: #fff;
    }
    .menu-grid {
        display: grid;
        grid-template-columns: 1fr 1fr; /* 2 cột */
        gap: 10px 20px; /* khoảng cách giữa các item */
    }

    .menu-grid label {
        display: flex;
        align-items: center;
        background: #fafafa;
        border: 1px solid #ddd;
        border-radius: 6px;
        padding: 8px 10px;
        cursor: pointer;
        transition: all 0.2s ease;
    }

    .menu-grid label:hover {
        background-color: #ffeae7;
        border-color: #b52a1a;
    }

    .menu-grid input[type="checkbox"] {
        margin-right: 10px;
        transform: scale(1.2);
        accent-color: #b52a1a; /* màu đỏ cho checkbox */
    }

</style>

<body>

<div class="main">
    <!-- Header -->
    <jsp:include page="/WEB-INF/views/common/header.jsp" />


    <!-- Wrapper -->
    <div class="main-wrapper">
        <!-- Sidebar -->
        <div class="sidebar">

            <ul>
                <!-- nếu quyền là admin Restaurant thì hiện  -->
                <li><a href="ServiceManage">Quản lý dịch vụ</a></li>
                <li><a href="Menu_manage">Quản lý Menu</a></li>
                <li><a href="Voucher">Quản lý Voucher khuyến mãi </a></li>
                <li><a href="Promotion_level">Quản lý khách hàng thân thiết </a></li>
                <li><a href="Timedirect">Quản lý khung giờ</a></li>
            </ul>
        </div>



        <!-- Content -->
        <div class="content">
            <!-- Banner / Filter Section -->
            <div class="filter-section">
                <div class="filter-content">
                    <h2 class="filter-title">Danh Sách Dịch Vụ</h2>
                    <div class="filter-actions">

                        <button class="add-btn" onclick="openAddModal()">+ Thêm dịch vụ</button>
                    </div>
                </div>
            </div>
            <div id="addModal" class="modal">
                <div class="modal-content">
                    <span class="close" onclick="closeAddModal()">&times;</span>
                    <h2>Thêm dịch vụ</h2>
                    <p id="add-error-message" style="color:red; text-align:center; display:none;"></p>

                    <form action="ServiceAdd" method="post">
                        <div id="step1">
                            <label>Tên dịch vụ:</label>
                            <input type="text" id="add-name" name="serviceName"
                                   value="${param.serviceName != null ? param.serviceName : ''}" >

                            <label>Mã dịch vụ:</label>
                            <input type="text" id="add-code" name="serviceCode">

                            <label>Mô tả:</label>
                            <textarea id="add-description" name="description">${param.description}</textarea>

                            <label>Giá:</label>
                            <input type="number" id="add-price" name="price"
                                   value="${param.price != null ? param.price : ''}">

                            <label>Trạng thái:</label>
                            <select id="add-status" name="status">
                                <option value="ACTIVE" ${param.status == 'ACTIVE' ? 'selected' : ''}>ACTIVE</option>
                                <option value="INACTIVE" ${param.status == 'INACTIVE' ? 'selected' : ''}>INACTIVE</option>
                            </select>

                            <label>Ngày bắt đầu:</label>
                            <input type="date" id="add-start" name="startDate" value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">

                            <label>Ngày kết thúc:</label>
                            <input type="date" id="add-end" name="endDate" value="${param.endDate}">

                            <button type="button" class="action-btn btn-update" onclick="nextStep()">Tiếp theo</button>
                        </div>

                        <!-- 🟩 BƯỚC 2: CHỌN MÓN COMBO -->
                        <div id="comboStep" style="display:none;">
                            <h3 style="text-align:center; color:#b52a1a;">Chọn món cho Combo</h3>
                            <p style="text-align:center; color:#555;">Chọn các món ăn muốn thêm vào combo dịch vụ:</p>

                            <div id="menu-list" style="margin:15px 0;">
                                <p style="text-align:center;">Đang tải danh sách món...</p>
                            </div>

                            <div style="text-align:center; margin-top:20px;">
                                <button type="button" class="action-btn btn-update" onclick="prevStep()">⬅ Quay lại</button>
                                <button type="submit" class="action-btn btn-update">Hoàn tất ➕</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Table -->

            <table>
                <thead>
                <tr>
                    <th>Tên dịch vụ</th>
                    <th>Mã dịch vụ</th>
                    <th>Mô tả</th>
                    <th>Giá (VNĐ)</th>
                    <th>Trạng thái</th>
                    <th>Ngày bắt đầu</th>
                    <th>Ngày kết thúc</th>
                    <th>Người tạo</th>
                    <th>Người cập nhật</th>
                    <th>Hành động</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="o" items="${kakao}">
                    <tr>
                        <td>
                            <c:choose>
                                <c:when test="${fn:length(o.serviceName) > 40}">
                                    ${fn:substring(o.serviceName, 0, 40)}...
                                </c:when>
                                <c:otherwise>
                                    ${o.serviceName}
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>${o.serviceCode}</td>
                        <td>.....</td>
                        <td>${o.price} VND</td>
                        <td class="${o.status eq 'ACTIVE' ? 'status-active' : 'status-inactive'}">
                                ${o.status}
                        </td>
                        <td>${o.startDate}</td>
                        <td>${o.endDate}</td>
                        <td>${o.nameCreated}</td>
                        <td>${o.nameUpdated}</td>
                        <td>
                            <button class="action-btn btn-update"
                                    data-id="${o.serviceId}"

                                    data-name="${o.serviceName}"
                                    data-description="${o.description}"
                                    data-price="${o.price}"
                                    data-status="${o.status}"
                                    data-start="${o.startDate}"
                                    data-end="${o.endDate}"
                                    data-created="${o.nameCreated}"
                                    data-updated="${o.nameUpdated}"
                                    onclick="openUpdateModal(this)">
                                Update
                            </button>
                            <button class="action-btn btn-delete"
                                    data-id="${o.serviceId}"
                                    onclick="openDeleteModal(this)">
                                Delete
                            </button>
                            <button class="action-btn btn-detail"
                                    onclick="openComboPopup(this)"
                                    data-id="${o.serviceId}"
                                    data-name="${o.serviceName}">
                                Combo món
                            </button>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
            <div class="pagination">
                <!-- Pagination -->
                <div style="text-align:center; margin-top: 20px;">
                    <c:if test="${totalPages > 1}">
                        <c:forEach var="i" begin="1" end="${totalPages}">
                            <c:choose>
                                <c:when test="${i == currentPage}">
                                    <span style="margin: 0 5px; font-weight: bold; color: white;">${i}</span>
                                </c:when>
                                <c:otherwise>
                                    <a href="ServiceManage?page=${i}"
                                       style="margin: 0 5px; text-decoration:none; color: black;">
                                            ${i}
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>
<div id="updateModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeModal()">&times;</span>
        <h2>Cập nhật dịch vụ</h2>
        <c:if test="${not empty erkaka}">
            <p style="color: red; font-weight: bold; text-align: center; margin-bottom: 10px;">
                    ${erkaka}
            </p>
            <script>
                // Tự động mở modal khi có lỗi
                window.onload = function () {
                    document.getElementById("updateModal").style.display = "block";
                };
            </script>
        </c:if>
        <form action="ServiceUpdate" method="post">
            <input type="hidden" id="update-id" name="serviceId" value="${param.serviceId != null ? param.serviceId : ''}">

            <label>Tên dịch vụ:</label>
            <input type="text" id="update-name" name="serviceName" value="${param.serviceName != null ? param.serviceName : ''}">

            <label>Mô tả:</label>
            <textarea id="update-description" name="description" > ${param.description != null ? param.description : ''}</textarea>

            <label>Giá:</label>
            <input type="number" id="update-price" name="price" value="${param.price != null ? param.price : ''}">

            <label>Trạng thái:</label>
            <select id="update-status" name="status">
                <option value="ACTIVE" ${param.status != 'ACTIVE' ? param.status : ''} >ACTIVE</option>
                <option value="INACTIVE" ${param.status != 'INACTIVE' ? param.status : ''}>INACTIVE</option>
            </select>

            <label>Ngày bắt đầu:</label>
            <input type="date" id="update-start" name="startDate" value="${param.startDate != null ? param.startDate : ''}">

            <label>Ngày kết thúc:</label>
            <input type="date" id="update-end" name="endDate" value="${param.endDate != null ? param.endDate : ''}">

            <button type="submit" class="action-btn btn-update">Lưu thay đổi</button>
        </form>
    </div>
</div>
<div id="deleteModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeDeleteModal()">&times;</span>
        <h2>Xóa dịch vụ</h2>
        <p>Bạn có chắc chắn muốn xóa dịch vụ này?</p>
        <form action="ServiceDelete" method="post">
            <input type="hidden" id="delete-id" name="serviceId">
            <button type="submit" class="action-btn btn-delete">Xóa</button>
            <button type="button" onclick="closeDeleteModal()">Hủy</button>
        </form>
    </div>
</div>


<!-- Popup Combo món -->
<div id="comboPopup" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeComboPopup()">&times;</span>
        <h2 style="text-align:center; color:#b52a1a;">Thông tin dịch vụ</h2>
        <h3 id="combo-service-name" style="text-align:center; margin-bottom:15px;"></h3>
        <input type="hidden" id="combo-service-id" value="">
        <div id="combo-items" class="combo-items">
            <!-- Danh sách món sẽ được load tại đây -->
            <p style="text-align:center; color:#777;">Đang tải...</p>
        </div>
    </div>
</div>
<div id="addItemPopup" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeAddItemPopup()">&times;</span>
        <h2 style="text-align:center; color:#b52a1a;">Thêm món vào Combo</h2>

        <form id="addItemForm" action="AddItemsToCombo" method="post">
            <input type="hidden" id="comboId" name="serviceId">

            <div id="add-item-list" style="max-height:300px; overflow-y:auto; text-align:center;">
                <p>Đang tải danh sách món...</p>
            </div>

            <div style="margin-top:15px; text-align:center;">
                <button type="submit">✅ Thêm vào combo</button>
                <button type="button" onclick="closeAddItemPopup()"> Hủy</button>
            </div>
        </form>
    </div>
</div>
<script>

    function openComboPopup(btn) {
        const serviceId = btn.dataset.id;
        const serviceName = btn.dataset.name;
        console.log("✅ serviceId:", serviceId);
        console.log("✅ serviceName:", serviceName);
        document.getElementById("combo-service-id").value = serviceId;
        document.getElementById("combo-service-name").innerText = "Dịch vụ: " + serviceName;
        document.getElementById("comboPopup").style.display = "block";

        const container = document.getElementById("combo-items");
        container.innerHTML = "<p style='text-align:center;'>Đang tải...</p>";

        // Gọi servlet JSP hoặc API để lấy danh sách món
        fetch("ServiceItemList?serviceId=" + serviceId)
            .then(res => res.text())
            .then(html => container.innerHTML = html)
            .catch(() => container.innerHTML = "<p style='color:red; text-align:center;'>Lỗi tải dữ liệu!</p>");
    }

    function closeComboPopup() {
        document.getElementById("comboPopup").style.display = "none";
    }

    // Đóng popup khi click ra ngoài
    window.onclick = function(e) {
        const popup = document.getElementById("comboPopup");
        if (e.target === popup) closeComboPopup();
    }
</script>
<script>
    // Mở popup 2
    function openAddItemPopup() {
        const comboId = document.getElementById("combo-service-id").value;


        document.getElementById("comboId").value = comboId;
        const popup = document.getElementById("addItemPopup");
        popup.style.display = "block";

        const container = document.getElementById("add-item-list");
        container.innerHTML = "<p>Đang tải danh sách món...</p>";

        // Gọi servlet đúng với serviceId dạng số
        fetch("AvailableItemsList?serviceId=" + comboId)
            .then(res => res.text())
            .then(html => container.innerHTML = html)
            .catch(() => container.innerHTML = "<p style='color:red;'>Lỗi tải dữ liệu!</p>");
    }

    // Đóng popup 2
    function closeAddItemPopup() {
        document.getElementById("addItemPopup").style.display = "none";
    }

    // Đóng popup khi click ra ngoài
    window.addEventListener('click', function(e) {
        const popup1 = document.getElementById("comboPopup");
        const popup2 = document.getElementById("addItemPopup");
        if (e.target === popup1) closeComboPopup();
        if (e.target === popup2) closeAddItemPopup();
    });
</script>
<script>
    function openDeleteModal(btn) {
        document.getElementById("delete-id").value = btn.dataset.id;
        document.getElementById("deleteModal").style.display = "block";
    }

    function closeDeleteModal() {
        document.getElementById("deleteModal").style.display = "none";
    }

    window.onclick = function (event) {
        if (event.target == document.getElementById("deleteModal")) {
            closeDeleteModal();
        }
        if (event.target == document.getElementById("updateModal")) {
            closeModal();
        }
    }
</script>
<script>function openUpdateModal(btn) {
    document.getElementById("update-id").value = btn.dataset.id;
    document.getElementById("update-name").value = btn.dataset.name;
    document.getElementById("update-description").value = btn.dataset.description;
    document.getElementById("update-price").value = btn.dataset.price;
    document.getElementById("update-status").value = btn.dataset.status;
    document.getElementById("update-start").value = btn.dataset.start;
    document.getElementById("update-end").value = btn.dataset.end;

    document.getElementById("updateModal").style.display = "block";
}
function closeModal() {
    document.getElementById("updateModal").style.display = "none";
}
window.onclick = function (event) {
    if (event.target == document.getElementById("updateModal")) {
        closeModal();
    }
}</script>
<script>
    function openAddModal() {
        document.getElementById("addModal").style.display = "block";
    }

    function closeAddModal() {
        document.getElementById("addModal").style.display = "none";
    }

    // bắt sự kiện click ngoài modal
    window.onclick = function (event) {
        if (event.target == document.getElementById("addModal")) {
            closeAddModal();
        }
        if (event.target == document.getElementById("updateModal")) {
            closeModal();
        }
        if (event.target == document.getElementById("deleteModal")) {
            closeDeleteModal();
        }
    }
</script>
<script>
    function generateRandomCode(length) {
        let result = '';
        const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
        const charactersLength = characters.length;
        for (let i = 0; i < length; i++) {
            result += characters.charAt(Math.floor(Math.random() * charactersLength));
        }
        return result;
    }

    // Khi mở popup "Thêm dịch vụ"
    function openAddModal() {
        document.getElementById("addModal").style.display = "block";

        // Sinh mã random
        const codeField = document.getElementById("add-code");
        codeField.value = generateRandomCode(5);
    }

    // Đóng popup
    function closeAddModal() {
        document.getElementById("addModal").style.display = "none";
    }
</script>
<script>
    function showError(msg) {
        const errorBox = document.getElementById("add-error-message");
        errorBox.textContent = msg;
        errorBox.style.display = "block";
    }

    function clearError() {
        const errorBox = document.getElementById("add-error-message");
        errorBox.textContent = "";
        errorBox.style.display = "none";
    }

    function nextStep() {
        clearError(); // xóa lỗi cũ

        const name = document.getElementById("add-name").value.trim();
        const price = document.getElementById("add-price").value.trim();
        const endDate =  document.getElementById("add-end").value.trim();
        // ✅ Kiểm tra rỗng
        if (!name) {
            showError("Vui lòng nhập tên dịch vụ!");
            return;
        }else if(!price){
            showError("Vui lòng nhập giá dịch vụ!");
            return;
        }else if(!endDate){
            showError("Vui lòng nhập ngày kết thúc dịch vụ!");
            return;
        }




        // Ẩn step 1, hiện step 2
        document.getElementById("step1").style.display = "none";
        document.getElementById("comboStep").style.display = "block";

        // Load danh sách món ăn nếu chưa có
        const menuList = document.getElementById("menu-list");
        if (!menuList.dataset.loaded) {
            fetch('${pageContext.request.contextPath}/MenuList')
                .then(res => res.text())
                .then(html => {
                    menuList.innerHTML = html;
                    menuList.dataset.loaded = "true";
                })
                .catch(() => showError("Không thể tải danh sách món ăn!"));
        }
    }

    function prevStep() {
        clearError();
        document.getElementById("comboStep").style.display = "none";
        document.getElementById("step1").style.display = "block";
    }
</script>
<!-- Thông báo thêm thành công -->
<c:if test="${param.success == '1'}">
    <div id="toastMessage" class="toast toast-success">
        ✅ Đã thêm thành công!
    </div>
</c:if>

<!-- Thông báo xóa thành công -->
<c:if test="${param.deleted == '1'}">
    <div id="toastMessage" class="toast toast-error">
        ❌ Đã xóa thành công!
    </div>
</c:if>

<style>
    .toast {
        position: fixed;
        top: 20px;
        right: 20px;
        z-index: 9999;
        color: white;
        padding: 15px 25px;
        border-radius: 8px;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
        font-weight: bold;
        opacity: 0;
        transform: translateY(-20px);
        transition: opacity 0.5s ease, transform 0.5s ease;
    }
    .toast.show {
        opacity: 1;
        transform: translateY(0);
    }
    .toast-success {
        background-color: #4CAF50; /* xanh lá */
    }
    .toast-error {
        background-color: #dc3545; /* đỏ */
    }
</style>

<script>
    window.addEventListener("DOMContentLoaded", () => {
        const toast = document.getElementById("toastMessage");
        if (toast) {
            setTimeout(() => toast.classList.add("show"), 100);
            setTimeout(() => {
                toast.classList.remove("show");
                setTimeout(() => toast.remove(), 500);
            }, 5000);
        }
    });
</script>
<c:if test="${param.error == '1'}">
    <script>
        window.addEventListener("DOMContentLoaded", function() {
            console.log("⚠️ Phát hiện lỗi error=1 → mở lại popup combo");

            // Lấy serviceId từ param
            const serviceId = "${param.serviceId}";
            const btn = document.querySelector(`[data-id='${param.serviceId}']`);

            if (btn && typeof openComboPopup === "function") {
                openComboPopup(btn);

                // Chờ popup load xong rồi hiển thị thông báo lỗi
                setTimeout(() => {
                    const popup = document.getElementById("comboPopup");
                    const errBox = popup ? popup.querySelector("#errorMessage") : null;

                    if (errBox) {
                        errBox.textContent = "⚠️ Vui lòng chọn ít nhất một món để xóa!";
                        errBox.style.display = "block";
                        errBox.style.opacity = "1";

                        setTimeout(() => {
                            errBox.style.transition = "opacity 0.5s";
                            errBox.style.opacity = "0";
                            setTimeout(() => {
                                errBox.style.display = "none";
                                errBox.style.transition = "";
                            }, 500);
                        }, 4000);
                    }
                }, 800);
            } else {
                console.error("Không tìm thấy nút hoặc hàm openComboPopup");
            }
        });
    </script>
</c:if>
</body>
</html>
