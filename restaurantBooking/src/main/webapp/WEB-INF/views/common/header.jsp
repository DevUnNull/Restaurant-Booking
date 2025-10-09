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
            <c:if test="${sessionScope.userRole == 3}"><li><a href="${pageContext.request.contextPath}/#">Đặt Bàn</a></li></c:if>
           <c:if test="${sessionScope.userRole == 2}">
               <li class="user-dropdown">
                   <div class="user-button" onclick="toggleUserDropdown()">
                       <span class="user-name">Booking Management</span>
                       <i class="fas fa-chevron-down"></i>
                   </div>
                   <div id="userDropdown" class="dropdown-content">
                       <a href="${pageContext.request.contextPath}/ServiceList">
                           <i class="fas fa-user"></i>Service Management
                       </a>
                       <a href="${pageContext.request.contextPath}/my-reservations">
                           <i class="fas fa-calendar-alt"></i>Menu Management
                       </a>
                       <a href="${pageContext.request.contextPath}/change-password">
                           <i class="fas fa-key"></i>Deal Management
                       </a><a href="${pageContext.request.contextPath}/BlogController">
                       <i class="fas fa-key"></i>Blog Management
                   </a><a href="${pageContext.request.contextPath}/change-password">
                       <i class="fas fa-key"></i>Customer Loyalty Management
                   </a>
                   </div>
               </li>
           </c:if>
            <li><a href="${pageContext.request.contextPath}/contact">Liên Hệ</a></li>
            <li><a href="${pageContext.request.contextPath}/cart">Cart (<span id="cart-count">0</span>)</a></li>
            
            <!-- Conditional user authentication section -->
            <c:choose>
                <c:when test="${not empty sessionScope.currentUser}">
                    <!-- User is logged in - show dropdown -->
                    <li class="user-dropdown">
                        <div class="user-button" onclick="toggleUserDropdown()">
                            <span class="user-name">${sessionScope.currentUser.fullName}</span>
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <div id="userDropdown" class="dropdown-content">
                            <a href="${pageContext.request.contextPath}/profile">
                                <i class="fas fa-user"></i> Hồ Sơ
                            </a>
                            <a href="${pageContext.request.contextPath}/my-reservations">
                                <i class="fas fa-calendar-alt"></i> Đặt Bàn Của Tôi
                            </a>
                            <a href="${pageContext.request.contextPath}/change-password">
                                <i class="fas fa-key"></i> Đổi Mật Khẩu
                            </a>
                            <div class="dropdown-divider"></div>
                            <a href="${pageContext.request.contextPath}/logout" class="logout-link">
                                <i class="fas fa-sign-out-alt"></i> Đăng Xuất
                            </a>
                        </div>
                    </li>
                </c:when>
                <c:otherwise>
                    <!-- User is not logged in - show login/register links -->
                    <li><a href="${pageContext.request.contextPath}/register">Đăng Ký</a></li>
                    <li><a href="${pageContext.request.contextPath}/login">Đăng Nhập</a></li>
                </c:otherwise>
            </c:choose>
        </ul>
    </nav>
</header>

<script>
function toggleUserDropdown() {
    const dropdown = document.getElementById('userDropdown');
    const userButton = document.querySelector('.user-button');
    dropdown.classList.toggle('show');
    userButton.classList.toggle('active');
}

function toggleMobileMenu() {
    const mobileNav = document.getElementById('mobileNav');
    const toggle = document.querySelector('.mobile-menu-toggle');
    mobileNav.classList.toggle('show');
    toggle.classList.toggle('active');
}

// Close dropdown when clicking outside
document.addEventListener('click', function(event) {
    const userDropdown = document.getElementById('userDropdown');
    const userButton = document.querySelector('.user-button');
    
    if (userDropdown && userButton && !userButton.contains(event.target)) {
        userDropdown.classList.remove('show');
        userButton.classList.remove('active');
    }
});
</script>