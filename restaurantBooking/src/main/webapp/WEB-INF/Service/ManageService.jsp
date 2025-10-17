<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
</style>

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
                <!-- nếu quyền là admin Restaurant thì hiện  -->
                <li><a href="ServiceManage">Quản lý dịch vụ</a></li>
                <li><a href="Comment">Quản lý đánh giá bình luận</a></li>

                <li><a href="#">Quản lý Menu</a></li>
                <li><a href="Voucher">Quản lý Voucher khuyến mãi </a></li>
                <li><a href="#">Quản lý khách hàng thân thiết </a></li>
            </ul>
        </div>

        <!-- Content -->
        <div class="content">
            <h2>Quản lý dịch vụ</h2>

            <!-- Add button -->
            <button class="add-btn" onclick="openAddModal()">+ Thêm dịch vụ</button>
            <div id="addModal" class="modal">
                <div class="modal-content">
                    <span class="close" onclick="closeAddModal()">&times;</span>
                    <h2>Thêm dịch vụ</h2>
                    <c:if test="${not empty errorMessage}">
                        <script>
                            window.onload = function () {
                                openAddModal(); // ✅ Gọi lại hàm render mã ngẫu nhiên
                            }
                        </script>
                        <p style="color:red;">${errorMessage}</p>
                    </c:if>
                    <form action="ServiceAdd" method="post">
                        <label>Tên dịch vụ:</label>
                        <input type="text" id="add-name" name="serviceName"
                               value="${param.serviceName != null ? param.serviceName : ''}" >

                        <label>Mã dịch vụ:</label>
                        <input type="text" id="add-code" name="serviceCode"
                        >

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
                        <input type="date" id="add-start" name="startDate" value="${param.startDate}">

                        <label>Ngày kết thúc:</label>
                        <input type="date" id="add-end" name="endDate" value="${param.endDate}">

                        <button type="submit" class="action-btn btn-update">Thêm dịch vụ</button>
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
                        <td>${o.serviceName}</td>
                        <td>${o.serviceCode}</td>
                        <td>${o.description}</td>
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
                                    <span style="margin: 0 5px; font-weight: bold; color: #b23627;">${i}</span>
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

</body>
</html>
