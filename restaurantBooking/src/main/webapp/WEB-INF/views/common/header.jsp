<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<header>
    <div class="logo">
        <a href="${pageContext.request.contextPath}/">
            <h1>Đặt Bàn Nhà Hàng</h1>
        </a>
    </div>
    <nav>
        <ul>
            <li><a href="${pageContext.request.contextPath}/">Trang Chủ</a></li>
            <li><a href="${pageContext.request.contextPath}/menu">Thực Đơn</a></li>
            <li><a href="${pageContext.request.contextPath}/findViewTable">Đặt Bàn</a></li>

            <%-- Booking Management Dropdown (Role 2) --%>
            <c:if test="${sessionScope.userRole == 2}">
                <li class="user-dropdown">
                    <div class="user-button" onclick="toggleDropdown('bookingDropdown')">
                        <span class="user-name">Booking Management</span>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div id="bookingDropdown" class="dropdown-content">
                        <a href="${pageContext.request.contextPath}/ServiceList"><i class="fas fa-concierge-bell"></i> Service Management</a>
                        <a href="${pageContext.request.contextPath}/Menu_manage"><i class="fas fa-utensils"></i> Menu Management</a>
                        <a href="${pageContext.request.contextPath}/Voucher"><i class="fas fa-tags"></i> Quản lý Voucher</a>
                        <a href="${pageContext.request.contextPath}/###"><i class="fas fa-users"></i> Quản lý khách hàng</a>
                        <a href="${pageContext.request.contextPath}/###"><i class="fas fa-clock"></i> Quản lý khung giờ</a>
                        <a href="${pageContext.request.contextPath}/Blog"><i class="fas fa-newspaper"></i> Blog Nhà Hàng</a>
                    </div>
                </li>
            </c:if>

            <%-- HR Management Dropdown (Chỉ Admin - Role 1) --%>
            <c:if test="${sessionScope.userRole == 1}">
                <li class="user-dropdown">
                    <div class="user-button" onclick="toggleDropdown('hrDropdown')">
                        <span class="user-name">Quản lý nhân sự</span>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div id="hrDropdown" class="dropdown-content">
                        <a href="${pageContext.request.contextPath}/EmployeeList">Quản Lý Nhân Sự</a>
                        <a href="#">Phân lịch làm việc</a>
                        <a href="#">Lịch làm việc</a>
                        <a href="#">Đơn xin việc</a>
                    </div>
                </li>
            </c:if>

            <%-- Report Dropdown (Admin & Manager - Role 1 & 4) --%>
            <c:if test="${sessionScope.userRole == 1 || sessionScope.userRole == 4}">
                <li class="user-dropdown">
                    <div class="user-button" onclick="toggleDropdown('reportDropdown')">
                        <span class="user-name">Report</span>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div id="reportDropdown" class="dropdown-content">
                        <a href="${pageContext.request.contextPath}/OverviewReport">Overview Report</a>
                        <a href="${pageContext.request.contextPath}/ServiceReport">Service Reports</a>
                        <a href="${pageContext.request.contextPath}/StaffReport">Staff Report</a>
                        <a href="${pageContext.request.contextPath}/UserReport">User Report</a>
                        <a href="${pageContext.request.contextPath}/Cancel">Cancel Request</a>
                    </div>
                </li>
            </c:if>

            <li><a href="${pageContext.request.contextPath}/contact">Liên Hệ</a></li>
            <li><a href="${pageContext.request.contextPath}/cart">Cart (<span id="cart-count">0</span>)</a></li>

            <c:choose>
                <c:when test="${not empty sessionScope.currentUser}">
                    <li class="user-dropdown">
                        <div class="user-button" onclick="toggleDropdown('profileDropdown')">
                            <span class="user-name">${sessionScope.currentUser.fullName}</span>
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <div id="profileDropdown" class="dropdown-content">
                            <a href="${pageContext.request.contextPath}/profile"><i class="fas fa-user"></i> Hồ Sơ</a>
                            <a href="${pageContext.request.contextPath}/my-reservations"><i class="fas fa-calendar-alt"></i> Đặt Bàn Của Tôi</a>
                            <a href="${pageContext.request.contextPath}/change-password"><i class="fas fa-key"></i> Đổi Mật Khẩu</a>
                            <div class="dropdown-divider"></div>
                            <a href="${pageContext.request.contextPath}/logout" class="logout-link"><i class="fas fa-sign-out-alt"></i> Đăng Xuất</a>
                        </div>
                    </li>
                </c:when>
                <c:otherwise>
                    <li><a href="${pageContext.request.contextPath}/register">Đăng Ký</a></li>
                    <li><a href="${pageContext.request.contextPath}/login">Đăng Nhập</a></li>
                </c:otherwise>
            </c:choose>
        </ul>
    </nav>
</header>


<script>
    // Hàm duy nhất để bật/tắt bất kỳ dropdown nào bằng ID của nó
    function toggleDropdown(dropdownId) {
        const dropdown = document.getElementById(dropdownId);
        const userButton = dropdown.previousElementSibling;

        // Đóng tất cả các dropdown khác trước khi mở cái mới
        // Điều này đảm bảo chỉ có một dropdown được mở tại một thời điểm
        closeAllDropdowns(dropdownId);

        dropdown.classList.toggle('show');
        userButton.classList.toggle('active');
    }

    // Hàm để đóng tất cả các dropdown đang mở, trừ cái có ID được chỉ định
    function closeAllDropdowns(exceptId = null) {
        const dropdowns = document.querySelectorAll('.dropdown-content');
        dropdowns.forEach(dropdown => {
            if (dropdown.id !== exceptId && dropdown.classList.contains('show')) {
                dropdown.classList.remove('show');
                const button = dropdown.previousElementSibling;
                if (button) {
                    button.classList.remove('active');
                }
            }
        });
    }

    // Đóng dropdown khi click ra bên ngoài
    window.addEventListener('click', function(event) {
        if (!event.target.closest('.user-button')) {
            closeAllDropdowns();
        }
    });

    function toggleMobileMenu() {
        const mobileNav = document.getElementById('mobileNav');
        const toggle = document.querySelector('.mobile-menu-toggle');
        mobileNav.classList.toggle('show');
        toggle.classList.toggle('active');
    }
</script>