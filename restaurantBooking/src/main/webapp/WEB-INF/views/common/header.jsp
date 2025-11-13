<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<header style="background: #ad0505">
    <div class="logo">
        <a href="${pageContext.request.contextPath}/">
            <h1>Fine Dining</h1>
        </a>
    </div>
    <nav>
        <ul>
            <li><a href="${pageContext.request.contextPath}/">Trang Chủ</a></li>
<%--            <li><a href="${pageContext.request.contextPath}/Blog">Blog nhà Hàng</a></li>--%>
            <li><a href="${pageContext.request.contextPath}/menu">Thực Đơn</a></li>
            <li><a href="${pageContext.request.contextPath}/findTable">Đặt Bàn</a></li>
            <li><a href="${pageContext.request.contextPath}/Blog"> Blog nhà Hàng</a></li>
            <c:if test="${sessionScope.userRole ==3}">
                <li>   <a href="${pageContext.request.contextPath}/TimeTable"></i> Quản lý khung giờ</a></li>
            </c:if>

            <%-- Booking Management Dropdown (Role 2) --%>
            <c:if test="${sessionScope.userRole == 2}">
                <li class="user-dropdown">
                    <div class="user-button" onclick="toggleDropdown('bookingDropdown')">
                        <span class="user-name">Quản lý nhà hàng</span>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div id="bookingDropdown" class="dropdown-content">
                        <a href="${pageContext.request.contextPath}/ServiceManage"><i class="fas fa-concierge-bell"></i>
                            Quản lý dịch vụ</a>
                        <a href="${pageContext.request.contextPath}/OrderManagement"><i class="fas fa-receipt"></i> Quản lý đơn hàng</a>
                        <a href="${pageContext.request.contextPath}/Menu_manage"><i class="fas fa-utensils"></i> Quản lý menu</a>
                        <a href="${pageContext.request.contextPath}/Voucher"><i class="fas fa-tags"></i> Quản lý voucher</a>
                        <a href="${pageContext.request.contextPath}/Promotion_level"><i class="fas fa-users"></i> Quản lý khách hàng</a>
                        <a href="${pageContext.request.contextPath}/Timedirect"><i class="fas fa-clock"></i> Quản lý khung giờ</a>
                    </div>
                </li>
            </c:if>

            <%-- Report Dropdown (Admin & Manager - Role 1 & 4) --%>
            <c:if test="${sessionScope.userRole == 1 || sessionScope.userRole == 4}">
                <li class="user-dropdown">
                    <div class="user-button" onclick="toggleDropdown('hrDropdown')">
                        <span class="user-name">Quản lý nhân sự</span>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div id="hrDropdown" class="dropdown-content">
                        <a href="${pageContext.request.contextPath}/EmployeeList">Quản Lý Nhân Sự</a>
                        <a href="${pageContext.request.contextPath}/WorkSchedule">Phân lịch làm việc</a>
                        <a href="#">Lịch làm việc</a>
                        <a href="CustomerList">Thêm nhân viên</a>
                    </div>
                </li>

                <li class="user-dropdown">
                    <div class="user-button" onclick="toggleDropdown('reportDropdown')">
                        <span class="user-name">Báo cáo</span>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div id="reportDropdown" class="dropdown-content">
                        <a href="${pageContext.request.contextPath}/overview-report">Báo cáo tổng quan</a>
                        <a href="${pageContext.request.contextPath}/service-report">Báo cáo theo dịch vụ</a>
                        <a href="${pageContext.request.contextPath}/staff-report">Báo cáo nhân viên</a>
                        <a href="${pageContext.request.contextPath}/user-report">Báo cáo người dùng</a>
                        <a href="${pageContext.request.contextPath}/cancel-report">Báo cáo lịch hủy</a>
                    </div>
                </li>
            </c:if>
            <c:if test="sessionScope.userRole == 3">
                <li><a href="${pageContext.request.contextPath}/Timedirect">Khung giờ hoạt động</a></li>
                <li><a href="${pageContext.request.contextPath}/cart">Cart (<span id="cart-count">0</span>)</a></li>
            </c:if>


            <li><a href="${pageContext.request.contextPath}/about">Giới Thiệu</a></li>


            <c:choose>
                <c:when test="${not empty sessionScope.currentUser}">
                    <li class="user-dropdown">
                        <div class="user-button" onclick="toggleDropdown('userDropdown')">
                            <span class="user-name">${sessionScope.currentUser.fullName}</span>
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <div id="userDropdown" class="dropdown-content">
                            <a href="${pageContext.request.contextPath}/profile"><i class="fas fa-user"></i> Hồ Sơ</a>
                            <a href="${pageContext.request.contextPath}/orderHistory"><i class="fas fa-calendar-alt"></i> Đặt Bàn Của Tôi</a>
                            <a href="${pageContext.request.contextPath}/change-password"><i class="fas fa-key"></i> Đổi Mật Khẩu</a>
                            <div class="dropdown-divider"></div>
                            <a href="${pageContext.request.contextPath}/logout" class="logout-link"><i
                                    class="fas fa-sign-out-alt"></i> Đăng Xuất</a>
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
        document.querySelectorAll('.dropdown-content.show').forEach(openDropdown => {
            if (openDropdown.id !== dropdownId) {
                openDropdown.classList.remove('show');
            }
        });

        const dropdown = document.getElementById(dropdownId);
        if (dropdown) {
            dropdown.classList.toggle('show');
        }
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
    window.addEventListener('click', function (event) {
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