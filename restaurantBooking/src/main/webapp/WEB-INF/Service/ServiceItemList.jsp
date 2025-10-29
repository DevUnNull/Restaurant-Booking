<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<form id="comboForm" action="DeleteItemsFromCombo" method="post">
    <div style="display: flex; gap: 20px; align-items: flex-start; justify-content: center;">

        <!-- BẢNG TRÁI: DANH SÁCH MÓN -->
        <table border="1" width="70%" style="border-collapse:collapse; text-align:center;">
            <tr style="background-color:#f5f5f5;">
                <th>Chọn</th>
                <th>Tên món</th>
            </tr>

            <c:forEach var="i" items="${items}">
                <tr>
                    <td>
                        <input type="checkbox" name="selectedItems" value="${i.itemId}">
                    </td>
                    <td>${i.itemName}</td>
                </tr>
            </c:forEach>
        </table>

        <!-- BẢNG PHẢI: HÀNH ĐỘNG -->
        <table border="1" style="border-collapse:collapse; text-align:center; width: 25%;">
            <tr style="background-color:#f5f5f5;">
                <th>Hành động</th>
            </tr>
            <tr>
                <td>
                    <button type="submit" onclick="return confirmDelete()">🗑️ Xóa món đã chọn</button>
                </td>
            </tr>
            <tr>
                <td>
                    <button type="button" onclick="addItem()">➕ Thêm món</button>
                </td>
            </tr>
        </table>

    </div>


    <div style="margin-top:15px; text-align:right;">
        <button type="button" onclick="saveAndClose()">💾 Lưu</button>
    </div>

</form>
<script>
    function saveAndClose() {
        document.getElementById("comboPopup").style.display = "none";
        location.reload(); // reload lại trang hiện tại (nếu ServiceManage là trang này)
    }
</script>
<script>
    // Hàm xác nhận trước khi submit form
    function confirmDelete() {
        const checkboxes = document.querySelectorAll('input[name="selectedItems"]:checked');
        if (checkboxes.length === 0) {
            alert("Vui lòng chọn ít nhất một món để xóa!");
            return false; // Ngăn form submit
        }

        return confirm("Bạn có chắc muốn xóa " + checkboxes.length + " món này không?");
    }

    // Hàm thêm món (vẫn giữ nguyên, không liên quan đến form)
    function addItem(itemId) {
        alert("Thêm món cho ID: " + itemId);
        // Ví dụ: mở popup hoặc gọi hàm khác để thêm món
    }
</script>