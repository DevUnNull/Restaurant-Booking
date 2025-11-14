<%--
  Created by IntelliJ IDEA.
  User: Duong Quy Nhan
  Date: 10/11/2025
  Time: 10:10 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
  <head>
      <title>Đơn xin việc</title>
      <link href="css/ServiceManage.css" rel="stylesheet" type="text/css" />
      <link href="css/Employee.css" rel="stylesheet" type="text/css" />
  </head>
  <body>

<%--  thông báo --%>
  <c:if test="${not empty message}">
      <div id="toast">
          <span>${message}</span>
          <button id="closeToast">&times;</button>
      </div>

      <script>
          window.addEventListener("DOMContentLoaded", function() {
              const toast = document.getElementById("toast");
              const closeBtn = document.getElementById("closeToast");
              if (toast) {
                  toast.classList.add("show");

                  // 3s sau thì tự mờ dần
                  setTimeout(() => {
                      toast.classList.remove("show");
                      toast.classList.add("hide");
                  }, 3000);

                  // 4s sau thì biến mất hẳn
                  setTimeout(() => toast.remove(), 4000);

                  // Khi bấm nút X thì ẩn ngay lập tức
                  closeBtn.addEventListener("click", () => {
                      toast.classList.remove("show");
                      toast.classList.add("hide");
                      setTimeout(() => toast.remove(), 500);
                  });
              }
          });
      </script>
  </c:if>


  <div class="main">
      <div class="header">
          <div class="logo">Quản Lý Nhân Sự</div>
          <nav>
              <ul>
                  <li><a href="home">Trang chủ</a></li>
              </ul>
          </nav>
      </div>
      <div class="main-wrapper">
          <!-- Sidebar -->
          <div class="sidebar">
              <ul>
                  <li><a href="EmployeeList">Danh sách nhân viên</a></li>
                  <li><a href="WorkSchedule">Phân lịch làm việc</a></li>
                  <li><a href="WorkTimetable">Lịch làm việc</a></li>
                  <li><a href="CustomerList">Thêm nhân viên</a></li>
              </ul>
          </div>
          <div class="content">
              <h2>Danh sách khách hàng</h2>
              <div class="search-container">
                  <form action="${pageContext.request.contextPath}/CustomerList" method="get">
                      <input type="text" name="keyword" value="${param.keyword}" placeholder="Tìm theo tên, email hoặc số điện thoại" class="search-input">
                      <button type="submit" class="search-button">
                          Tìm kiếm
                      </button>
                  </form>
              </div>

              <!-- Nếu không có dữ liệu -->
              <c:if test="${empty customer}">
                  <div style="color: #777; background-color: #f8f8f8; padding: 15px; border-radius: 8px; text-align: center;">
                       Không tìm thấy kết quả phù hợp cho từ khóa "<b>${fn:escapeXml(param.keyword)}</b>"
                  </div>
                  <br>
                  <a href="CustomerList"
                     style="display: inline-block; padding: 8px 16px; margin-top: 8px;
                  background-color: #4CAF50; color: white; text-decoration: none;
                  border-radius: 6px; transition: 0.2s;">
                      ⬅ Quay lại
                  </a>
              </c:if>
              <c:if test="${not empty customer}">
                  <table>
                      <thead>
                      <tr>
                          <th>ID</th>
                          <th>Họ và tên</th>
                          <th>Email</th>
                          <th>Số điện thoại</th>
                          <th>Hoạt động</th>
                      </tr>
                      </thead>
                      <tbody>
                      <c:forEach var="c" items="${customer}">
                          <tr>
                              <td>${c.userId}</td>
                              <td>${c.fullName}</td>
                              <td>${c.email}</td>
                              <td>${c.phoneNumber}</td>
                              <td>
                                  <a href="AddEmployee?id=${c.userId}" class="link1">Thêm</a>
                                  <a href="#" class="link3" onclick="showDetail(${c.userId})">Chi tiết</a>
                              </td>
                          </tr>
                      </c:forEach>
                      </tbody>
                  </table>
                  <!-- Phân trang -->
                  <div class="pagination">
                      <c:forEach begin="1" end="${totalPages}" var="i">
                          <a href="CustomerList?page=${i}&keyword=${param.keyword}">
                                  ${i}
                          </a>
                      </c:forEach>
                  </div>

                  <!-- Popup hiển thị chi tiết -->
                  <div id="detailModal" class="modal" style="display:none;">
                      <div class="modal-content">
                          <span class="close" onclick="closeDetailModal()">&times;</span>
                          <h2>Chi tiết khách hàng</h2>
                          <div id="detailContent" class="detail-info"></div>
                      </div>
                  </div>
              </c:if>
          </div>
      </div>
  </div>

<script>
    function showDetail(id) {
        // Gửi yêu cầu tới servlet để lấy HTML chi tiết
        fetch('view-employee-detail?id=' + id)
            .then(response => response.text())
            .then(html => {
                // Đổ nội dung vào phần popup
                document.getElementById("detailContent").innerHTML = html;
                document.getElementById("detailModal").style.display = "flex";
            })
            .catch(err => console.error('Error loading detail:', err));
    }

    function closeDetailModal() {
        document.getElementById("detailModal").style.display = "none";
    }
</script>

  </body>
  <style>
      #toast {
          position: fixed;
          top: 20px;
          right: 20px;
          background-color: #4CAF50; /* Màu xanh thành công */
          color: white;
          padding: 12px 20px;
          border-radius: 8px;
          font-weight: 500;
          box-shadow: 0 2px 8px rgba(0,0,0,0.2);
          display: flex;
          align-items: center;
          justify-content: space-between;
          min-width: 260px;
          opacity: 0;
          transform: translateY(-20px);
          transition: opacity 0.5s ease, transform 0.5s ease;
          z-index: 9999;
      }

      #toast.show {
          opacity: 1;
          transform: translateY(0);
      }

      #toast.hide {
          opacity: 0;
          transform: translateY(-20px);
      }

      /* Nút X */
      #toast button {
          background: none;
          border: none;
          color: white;
          font-size: 18px;
          cursor: pointer;
          margin-left: 12px;
          transition: color 0.2s;
      }

      #toast button:hover {
          color: #ddd;
      }
  </style>
</html>
