<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<form id="comboForm" action="DeleteItemsFromCombo" method="post">

    <div id="errorMessage"
         style="display:none;
            background-color:#f8d7da;
            color:#721c24;
            border:1px solid #f5c6cb;
            padding:10px 15px;
            margin-bottom:10px;
            border-radius:5px;
            text-align:center;
            font-weight:bold;">
    </div>
    <div style="display: flex; gap: 20px; align-items: flex-start; justify-content: center;">

        <!-- BẢNG TRÁI: DANH SÁCH MÓN -->

        <table border="1" width="70%" style="border-collapse:collapse; text-align:center;">
            <tr style="background-color:#f5f5f5;">
                <th>Chọn</th>
                <th>Tên món</th>

            </tr>
            <input  type="hidden" name="serviceId" value="${serviceId}"/>
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
                    <button type="submit" > Xóa món đã chọn</button>
                </td>
            </tr>
            <tr>
                <td>
                    <button type="button" onclick="openAddItemPopup()"> Thêm món</button>
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

