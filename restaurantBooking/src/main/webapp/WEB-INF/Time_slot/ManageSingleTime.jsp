<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý khung thời gian</title>
    <link rel="stylesheet" href="styles.css">
    <link rel="stylesheet" href="styless.css">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=Roboto:wght@400;700&display=swap"
          rel="stylesheet">
    <link href="css/ServiceManage.css" rel="stylesheet" type="text/css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
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
            box-shadow: 0 4px 10px rgba(192, 57, 43, 0.3);
            transition: all 0.3s ease;
        }

        .add-btn:hover {
            background-color: #e74c3c;
            transform: translateY(-2px);
        }

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

        .btn-edit:hover {
            background-color: #3498db;
        }

        .btn-block:hover {
            background-color: #d35400;
        }

        /* nhỏ gọn cho modal add */
        #addDateModal .modal-content {
            width: 520px;
        }

        #addDateModal label {
            font-weight: 600;
        }

        #addDateModal input[type="date"], #addDateModal input[type="time"], #addDateModal textarea {
            padding: 6px;
            border-radius: 6px;
            border: 1px solid #ccc;
            font-size: 14px;
        }
        .btn-delete {
            background-color: #e74c3c;  /* Màu đỏ */
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-delete:hover {
            background-color: #c0392b;  /* Đỏ đậm hơn khi hover */
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(231, 76, 60, 0.3);
        }

        .btn-delete:active {
            transform: translateY(0);
            box-shadow: 0 2px 4px rgba(231, 76, 60, 0.2);
        }
        .pagination a, .pagination span {
            display: inline-block;
            padding: 6px 10px;
            margin: 0 3px;
            border: 1px solid #ccc;
            border-radius: 5px;
            text-decoration: none;
            color: #333;
        }
        .pagination span.active {
            background-color: #007bff;
            color: #fff;
            font-weight: bold;
            border-color: #007bff;
        }
        .pagination a:hover {
            background-color: #f0f0f0;
        }
    </style>
</head>

<body>
<div class="main">
    <!-- Header -->
    <jsp:include page="/WEB-INF/views/common/header.jsp"/>

    <!-- Wrapper -->
    <div class="main-wrapper">
        <!-- Sidebar -->
        <div class="sidebar">
            <h2>Staff Panel</h2>
            <ul>
                <li><a href="#">Dashboard</a></li>
                <li><a href="ServiceManage">Quản lý dịch vụ</a></li>
                <li><a href="Menu_manage">Quản lý Menu</a></li>
                <li><a href="Voucher">Quản lý Voucher khuyến mãi </a></li>
                <li><a href="Promotion_level">Quản lý khách hàng thân thiết </a></li>
                <li><a href="Timedirect">Quản lý khung giờ </a></li>
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
                            <c:if test="${o.category_id == 2}">
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
                                        data-category-id="${o.category_id}"
                                        data-category-name="${o.name_Category}"
                                        data-applicable-date="${o.applicableDate}"
                                        onclick="openEditModal(this)">
                                    Sửa
                                </button>



                                <!-- Nút Block -->
                                <button class="btn-block"
                                        data-id="${o.slotId}"
                                        onclick="openBlockModal(this)">
                                    Block
                                </button>
                            </c:if>

                            <button class="btn-delete"
                                    data-id="${o.slotId}"
                                    onclick="openDeleteModal(this)">
                                Xóa
                            </button>
                        </td>
                    </tr>
                </c:forEach>

                </tbody>
            </table>
            <div style="text-align:center; margin-top:15px;">
                <c:if test="${totalPages > 1}">
                    <div class="pagination">
                        <!-- Nút Previous -->
                        <c:if test="${currentPage > 1}">
                            <a href="ManageTime?page=${currentPage - 1}">«</a>
                        </c:if>

                        <!-- Số trang -->
                        <c:forEach var="i" begin="1" end="${totalPages}">
                            <c:choose>
                                <c:when test="${i == currentPage}">
                                    <span class="active">${i}</span>
                                </c:when>
                                <c:otherwise>
                                    <a href="ManageTime?page=${i}">${i}</a>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>

                        <!-- Nút Next -->
                        <c:if test="${currentPage < totalPages}">
                            <a href="ManageTime?page=${currentPage + 1}">»</a>
                        </c:if>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</div>
<!-- Modal xóa -->
<div id="deleteModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeDeleteModal()">&times;</span>
        <h2>Xác nhận xóa</h2>
        <p>Bạn có chắc chắn muốn xóa ngày này không?</p>

        <form action="DeleteTimeSingle" method="post">
            <!-- Truyền slot_id cần xóa -->
            <input type="hidden" id="delete-id" name="slot_id">


            <div class="btn-container">
                <button type="submit" class="btn-confirm">Xác nhận</button>
                <button type="button" onclick="closeDeleteModal()">Hủy</button>
            </div>
        </form>
    </div>
</div>
<!-- Modal sửa -->
<div id="editModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeEditModal()">&times;</span>
        <h2>Cập nhật khung giờ</h2>
        <p id="editError" style="color: #c0392b; font-weight: bold; display:none;"></p>
        <form action="TimeUpdate" method="post" class="edit-form">
            <!-- ID và updated_by -->
            <label for="edit-date">Ngày áp dụng:</label>
            <input type="date" id="edit-date" name="applicable_date" readonly>
            <input type="hidden" id="edit-id" name="slot_id">
            <input type="hidden" id="updated-by" name="updated_by" value="${sessionScope.userId}">

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
                    <textarea id="edit-description" name="slot_description" rows="7"
                              placeholder="Nhập mô tả chi tiết..."></textarea>
                </div>
                <div class="momu">
                    <label for="edit-description">Mô tả:</label>
                    <input type="text" id="edit-category-name" name="category_name" readonly>
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
        <p id="blockError" style="color: #c0392b; font-weight: bold; display:none;"></p>
        <p>Bạn có chắc muốn chặn ngày này không?</p>
        <form action="TimeBlock" method="post">
            <input type="hidden" id="block-id" name="slot_id">
            <input type="hidden" id="created_by" name="updated_by" value="${sessionScope.userId}">
            <div class="desc-section">
                <label for="edit-description">Mô tả:</label>
                <textarea id="edit-description" name="slot_description" rows="7"
                          placeholder="Nhập mô tả chi tiết..."></textarea>
            </div>
            <button type="submit" class="btn-block">Xác nhận</button>
            <button type="button" onclick="closeBlockModal()">Hủy</button>
        </form>
    </div>
</div>
<!-- ========== Modal: Thêm ngày mới ========== -->
<!-- ========== Modal: Thêm ngày mới ========== -->
<div id="addDateModal" class="modal">
    <div class="modal-content calendar-content">
        <span class="close" onclick="closeAddDateModal()">&times;</span>
        <h2>Thêm / Chỉnh ngày</h2>

        <!-- hidden userId để JS dùng -->
        <input type="hidden" id="add-updated-by" value="${sessionScope.userId}">

        <p id="addDateError" style="color: #c0392b; font-weight: bold; display:none;"></p>

        <!-- Chỉ có 2 nút hành động -->
        <div>
            <label>Chọn hành động:</label><br>
            <label><input type="radio" name="actionType" value="BLOCK"> Block ngày</label>
            <label style="margin-left:16px;"><input type="radio" name="actionType" value="EDIT"> Edit giờ
                (special)</label>
        </div>

        <!-- FORM 1: BLOCK -->
        <form id="blockForm" method="post" action="BlockTime" style="display:none; margin-top:12px;">
            <label>Chọn ngày:</label><br>
            <input type="date" name="applicable_date" id="block-applicable-date" required><br><br>

            <input type="hidden" name="updated_by" id="block-updated-by" value="${sessionScope.userId}">

            <div style="margin-top:10px;">
                <label>Mô tả:</label><br>
                <textarea name="slot_description" rows="4" style="width:100%" required></textarea>
            </div>
        </form>

        <!-- FORM 2: EDIT -->
        <form id="editForm" method="post" action="ManageTime" style="display:none; margin-top:12px;">
            <label>Chọn ngày:</label><br>
            <input type="date" name="applicable_date" id="edit-applicable-date" required>

            <input type="hidden" name="updated_by" id="edit-updated-by" value="${sessionScope.userId}">

            <hr>
            <div>
                <strong>Buổi sáng</strong><br>
                <input type="time" name="morning_start_time"> -
                <input type="time" name="morning_end_time">
            </div>

            <div style="margin-top:8px;">
                <strong>Buổi chiều</strong><br>
                <input type="time" name="afternoon_start_time"> -
                <input type="time" name="afternoon_end_time">
            </div>

            <div style="margin-top:8px;">
                <strong>Buổi tối</strong><br>
                <input type="time" name="evening_start_time"> -
                <input type="time" name="evening_end_time">
            </div>

            <div style="margin-top:10px;">
                <label>Mô tả:</label><br>
                <textarea name="slot_description" rows="4" style="width:100%" required></textarea>
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
    function openAddDateModal() {
        const today = new Date().toISOString().slice(0, 10);

        // Reset form
        document.querySelectorAll('input[name="actionType"]').forEach(r => r.checked = false);
        document.getElementById('blockForm').style.display = 'none';
        document.getElementById('editForm').style.display = 'none';
        document.getElementById('addDateError').style.display = 'none';

        // Reset và set min date cho cả 2 input
        const blockDateInput = document.getElementById('block-applicable-date');
        const editDateInput = document.getElementById('edit-applicable-date');

        blockDateInput.value = '';
        editDateInput.value = '';
        blockDateInput.min = today;
        editDateInput.min = today;

        document.getElementById('addDateModal').style.display = 'block';
    }

    function closeAddDateModal() {
        document.getElementById('addDateModal').style.display = 'none';
    }

    document.addEventListener('change', function (e) {
        if (e.target && e.target.name === 'actionType') {
            const v = e.target.value;
            const today = new Date().toISOString().slice(0, 10);

            if (v === 'BLOCK') {
                document.getElementById('blockForm').style.display = 'block';
                document.getElementById('editForm').style.display = 'none';
                // Set ngày hiện tại và min cho form block
                document.getElementById('block-applicable-date').value = today;
                document.getElementById('block-applicable-date').min = today;
            } else if (v === 'EDIT') {
                document.getElementById('blockForm').style.display = 'none';
                document.getElementById('editForm').style.display = 'block';
                // Set ngày hiện tại và min cho form edit
                document.getElementById('edit-applicable-date').value = today;
                document.getElementById('edit-applicable-date').min = today;
            }

            document.getElementById('addDateError').style.display = 'none';
        }
    });

    function isPastDate(dateString) {
        const selected = new Date(dateString);
        selected.setHours(0, 0, 0, 0);
        const today = new Date();
        today.setHours(0, 0, 0, 0);
        return selected < today;
    }

    function submitAddDate() {
        const actionRadio = document.querySelector('input[name="actionType"]:checked');
        const errorEl = document.getElementById('addDateError');

        if (!actionRadio) {
            errorEl.textContent = 'Vui lòng chọn hành động (Block hoặc Edit).';
            errorEl.style.display = 'block';
            return;
        }

        const action = actionRadio.value;
        const userId = document.getElementById('add-updated-by')?.value || '';

        if (action === 'BLOCK') {
            const dateVal = document.getElementById('block-applicable-date').value;

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

            document.getElementById('block-updated-by').value = userId;
            document.getElementById('blockForm').submit();

        } else if (action === 'EDIT') {
            const dateVal = document.getElementById('edit-applicable-date').value;

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

            const ms = document.querySelector('#editForm [name="morning_start_time"]').value;
            const me = document.querySelector('#editForm [name="morning_end_time"]').value;
            const as = document.querySelector('#editForm [name="afternoon_start_time"]').value;
            const ae = document.querySelector('#editForm [name="afternoon_end_time"]').value;
            const es = document.querySelector('#editForm [name="evening_start_time"]').value;
            const ee = document.querySelector('#editForm [name="evening_end_time"]').value;

            if (!ms || !me || !as || !ae || !es || !ee) {
                errorEl.textContent = 'Vui lòng nhập đầy đủ tất cả 6 khung giờ (bắt đầu và kết thúc cho 3 buổi).';
                errorEl.style.display = 'block';
                return;
            }



            document.getElementById('edit-updated-by').value = userId;
            document.getElementById('editForm').submit();
        }
    }
</script>

<!-- Mở modal nếu đang ở chế độ EDIT -->
<c:if test="${actionType == 'EDIT'}">
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const today = new Date().toISOString().slice(0, 10);
            document.getElementById('addDateModal').style.display = 'block';
            document.querySelector('input[name="actionType"][value="EDIT"]').checked = true;
            document.getElementById('editForm').style.display = 'block';
            document.getElementById('edit-applicable-date').value = today;
            document.getElementById('edit-applicable-date').min = today;
        });
    </script>
</c:if>

<script>
    function openEditModal(btn) {
        // Gán các giá trị ẩn
        document.getElementById("edit-id").value = btn.dataset.id;
        document.getElementById("updated-by").value = btn.dataset.updatedBy;

        // Gán mô tả
        document.getElementById("edit-description").value = btn.dataset.description || "";
        document.getElementById("edit-date").value = btn.dataset.applicableDate || "";
        // Gán giá trị các khung giờ
        document.getElementById("morning-start").value = btn.dataset.morningStart || "";
        document.getElementById("morning-end").value = btn.dataset.morningEnd || "";
        document.getElementById("afternoon-start").value = btn.dataset.afternoonStart || "";
        document.getElementById("afternoon-end").value = btn.dataset.afternoonEnd || "";
        document.getElementById("evening-start").value = btn.dataset.eveningStart || "";
        document.getElementById("evening-end").value = btn.dataset.eveningEnd || "";

        // 🆕 Gán category_id
        const catIdEl = document.getElementById("edit-category-id");
        if (catIdEl) {
            catIdEl.value = btn.dataset.categoryId || "";
        }
        const catNameEl = document.getElementById("edit-category-name");
        if (catNameEl) {
            catNameEl.value = btn.dataset.categoryName || "";
        }

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
    window.onclick = function (event) {
        if (event.target === document.getElementById("editModal")) closeEditModal();
        if (event.target === document.getElementById("blockModal")) closeBlockModal();
    }
</script>
<script>

    function openDeleteModal(btn) {
        document.getElementById("delete-id").value = btn.dataset.id;
        document.getElementById("deleteModal").style.display = "block";
    }

    function closeDeleteModal() {
        document.getElementById("deleteModal").style.display = "none";
    }

    // Tùy chọn: đóng modal khi click ra ngoài
    window.onclick = function (event) {
        const modal = document.getElementById("deleteModal");
        if (event.target === modal) {
            modal.style.display = "none";
        }
    };

</script>
<!-- ========== SCRIPT ========== -->

<c:if test="${not empty er}">
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            // mở modal + show lỗi
            const modal = document.getElementById('addDateModal');
            const errorEl = document.getElementById('addDateError');

            modal.style.display = 'block';
            errorEl.textContent = '${er}';
            errorEl.style.display = 'block';
        });
    </script>
    <script>
        window.addEventListener("DOMContentLoaded", function () {
            <%-- Nếu có lỗi khi sửa --%>
            <% if (request.getAttribute("openEditModal") != null) { %>
            document.getElementById("editModal").style.display = "block";
            document.getElementById("edit-description").value = "<%= request.getAttribute("slot_description") != null ? request.getAttribute("slot_description") : "" %>";
            document.getElementById("edit-id").value = "<%= request.getAttribute("slot_id") %>";
            <% } %>

            <%-- Nếu có lỗi khi block --%>
            <% if (request.getAttribute("openBlockModal") != null) { %>
            document.getElementById("blockModal").style.display = "block";
            document.getElementById("block-id").value = "<%= request.getAttribute("slot_id") %>";
            <% } %>
        });
    </script>
</c:if>
<!-- ========== SCRIPT XỬ LÝ LỖI ========== -->
<c:if test="${not empty er}">
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            // mở modal addDate + show lỗi
            const modal = document.getElementById('addDateModal');
            const errorEl = document.getElementById('addDateError');

            modal.style.display = 'block';
            errorEl.textContent = '${er}';
            errorEl.style.display = 'block';
        });
    </script>
</c:if>




<!-- XỬ LÝ LỖI CHO BLOCK MODAL -->
<c:if test="${openBlockModal != null}">
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            document.getElementById("blockModal").style.display = "block";
            document.getElementById("block-id").value = "${slot_id}";

            // Hiển thị lỗi
            <c:if test="${not empty errorBlock}">
            const blockErrorEl = document.getElementById("blockError");
            blockErrorEl.textContent = "${errorBlock}";
            blockErrorEl.style.display = "block";
            </c:if>
        });
    </script>
</c:if>
<c:if test="${not empty er}">
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const modal = document.getElementById('addDateModal');
            const errorEl = document.getElementById('addDateError');
            modal.style.display = 'block';
            errorEl.textContent = '${er}';
            errorEl.style.display = 'block';
        });
    </script>
</c:if>

<!-- Lỗi cho Edit Modal -->
<c:if test="${openEditModal != null}">
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            // Mở modal
            document.getElementById("editModal").style.display = "block";

            // Điền dữ liệu vào form
            document.getElementById("edit-id").value = "${slot_id != null ? slot_id : ''}";
            document.getElementById("edit-description").value = "${slot_description != null ? slot_description : ''}";
            document.getElementById("morning-start").value = "${morning_start_time != null ? morning_start_time : ''}";
            document.getElementById("morning-end").value = "${morning_end_time != null ? morning_end_time : ''}";
            document.getElementById("afternoon-start").value = "${afternoon_start_time != null ? afternoon_start_time : ''}";
            document.getElementById("afternoon-end").value = "${afternoon_end_time != null ? afternoon_end_time : ''}";
            document.getElementById("evening-start").value = "${evening_start_time != null ? evening_start_time : ''}";
            document.getElementById("evening-end").value = "${evening_end_time != null ? evening_end_time : ''}";
            document.getElementById("edit-category-name").value = "${category_name != null ? category_name : ''}";
            document.getElementById("edit-date").value = "${applicable_date != null ? applicable_date : ''}";

            // Hiển thị lỗi
            <c:if test="${not empty errorEdit}">
            const editErrorEl = document.getElementById("editError");
            editErrorEl.textContent = "${errorEdit}";
            editErrorEl.style.display = "block";
            </c:if>
        });
    </script>
</c:if>

<!-- Lỗi cho Block Modal -->
<c:if test="${openBlockModal != null}">
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            // Mở modal
            document.getElementById("blockModal").style.display = "block";

            // Điền dữ liệu
            document.getElementById("block-id").value = "${slot_id != null ? slot_id : ''}";
            document.getElementById("block-description").value = "${slot_description != null ? slot_description : ''}";

            // Hiển thị lỗi
            <c:if test="${not empty errorBlock}">
            const blockErrorEl = document.getElementById("blockError");
            blockErrorEl.textContent = "${errorBlock}";
            blockErrorEl.style.display = "block";
            </c:if>
        });
    </script>
</c:if>

<!-- giữ nguyên giá trị cho form edit trong thêm ngày mới  -->
<!-- Khi có lỗi EDIT -->
<c:if test="${actionType == 'EDIT'}">
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            // mở modal + hiển thị lỗi
            const modal = document.getElementById('addDateModal');
            const errorEl = document.getElementById('addDateError');
            modal.style.display = 'block';
            errorEl.textContent = '${er}';
            errorEl.style.display = 'block';

            // chọn actionType = EDIT và hiển thị form
            document.querySelector('input[name="actionType"][value="EDIT"]').checked = true;
            document.getElementById('editForm').style.display = 'block';

            // điền lại dữ liệu người nhập
            document.querySelector('#editForm [name="applicable_date"]').value = "${applicable_date}";
            document.querySelector('#editForm [name="morning_start_time"]').value = "${morning_start_time}";
            document.querySelector('#editForm [name="morning_end_time"]').value = "${morning_end_time}";
            document.querySelector('#editForm [name="afternoon_start_time"]').value = "${afternoon_start_time}";
            document.querySelector('#editForm [name="afternoon_end_time"]').value = "${afternoon_end_time}";
            document.querySelector('#editForm [name="evening_start_time"]').value = "${evening_start_time}";
            document.querySelector('#editForm [name="evening_end_time"]').value = "${evening_end_time}";
            document.querySelector('#editForm [name="slot_description"]').value = "${slot_description}";
        });
    </script>
</c:if>

<!-- Khi có lỗi BLOCK -->
<c:if test="${actionType == 'BLOCK'}">
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const modal = document.getElementById('addDateModal');
            const errorEl = document.getElementById('addDateError');

            // Mở modal và hiển thị lỗi
            modal.style.display = 'block';
            errorEl.textContent = '${er}';
            errorEl.style.display = 'block';

            // Chọn actionType = BLOCK và hiển thị form
            document.querySelector('input[name="actionType"][value="BLOCK"]').checked = true;
            document.getElementById('blockForm').style.display = 'block';

            // Gán lại giá trị người nhập
            document.querySelector('#blockForm [name="applicable_date"]').value = "${applicable_datee}";
            document.querySelector('#blockForm [name="slot_description"]').value = "${slot_descriptionn}";
        });
    </script>
</c:if>
<!-- Khi có lỗi EDIT ô nhập thơi gian bị null  -->
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const editForm = document.getElementById("editForm");
        const errorEl = document.getElementById("addDateError");
        const modal = document.getElementById("addDateModal");

        editForm.addEventListener("submit", function (e) {
            // Lấy các input time
            const times = [
                editForm.querySelector("[name='morning_start_time']").value,
                editForm.querySelector("[name='morning_end_time']").value,
                editForm.querySelector("[name='afternoon_start_time']").value,
                editForm.querySelector("[name='afternoon_end_time']").value,
                editForm.querySelector("[name='evening_start_time']").value,
                editForm.querySelector("[name='evening_end_time']").value
            ];

            // Kiểm tra xem có cái nào trống không
            const hasEmpty = times.some(t => !t || t.trim() === "");

            if (hasEmpty) {
                e.preventDefault(); // Ngăn không gửi form
                // Hiển thị popup lỗi
                modal.style.display = "block";
                errorEl.textContent = "Vui lòng nhập đầy đủ tất cả 6 khung giờ (sáng, chiều, tối)";
                errorEl.style.display = "block";
                return false;
            }
        });
    });
</script>
</body>
</html>
