<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ Sơ Cá Nhân - Restaurant Booking</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/profile.css">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=Roboto:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
</head>
<body>
    <!-- Header -->
    <jsp:include page="../common/header.jsp" />
    
    <!-- Main Content -->
    <main>
        <!-- Loading overlay -->
        <div id="loading" class="loading">
            <div class="spinner"></div>
        </div>
        
        <div class="profile-container">
        <div class="profile-card">
            <!-- Profile Header -->
            <div class="profile-header">
                <div class="profile-header-content">
                    <div class="avatar-container">
                        <c:choose>
                            <c:when test="${not empty currentUser.avatar}">
                                <img src="${pageContext.request.contextPath}/uploads/avatars/${currentUser.avatar}" 
                                     alt="Avatar" class="avatar" id="currentAvatar">
                            </c:when>
                            <c:otherwise>
                                <img src="https://ui-avatars.com/api/?name=${currentUser.fullName}&background=random&size=120" 
                                     alt="Avatar" class="avatar" id="currentAvatar">
                            </c:otherwise>
                        </c:choose>
                        <button type="button" class="avatar-upload-btn" onclick="document.getElementById('avatarFile').click()">
                            <i class="fas fa-camera"></i>
                        </button>
                    </div>
                    <div class="profile-info">
                        <h2 class="profile-name">${currentUser.fullName}</h2>
                        <p class="profile-email">${currentUser.email}</p>
                        <div class="profile-meta">
                            <div class="meta-item">
                                <i class="fas fa-user-tag"></i>
                                <span>
                                    <c:choose>
                                        <c:when test="${currentUser.roleId == 1}">Quản trị viên</c:when>
                                        <c:when test="${currentUser.roleId == 2}">Nhân viên</c:when>
                                        <c:otherwise>Khách hàng</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            <div class="meta-item">
                            <i class="fas fa-calendar-alt"></i>
                            <span>${currentUser.createdAt.dayOfMonth}-${currentUser.createdAt.monthValue}-${currentUser.createdAt.year} ${currentUser.createdAt.hour}:${currentUser.createdAt.minute}</span>
                        </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Profile Body -->
            <div class="profile-body">
                <!-- Edit Profile Form -->
                
                <!-- Edit Profile Form -->
                <form id="profileForm" action="${pageContext.request.contextPath}/profile" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="update">
                    <input type="file" id="avatarFile" name="avatar" accept="image/*" style="display: none;">
                    
                    <div class="form-section">
                        <h3 class="section-title">
                            <i class="fas fa-edit"></i>
                            Chỉnh Sửa Hồ Sơ
                        </h3>
                        
                        <div class="form-group">
                            <label for="fullName" class="form-label">Họ và tên *</label>
                            <input type="text" class="form-control" id="fullName" name="fullName" 
                                   value="${currentUser.fullName}" required>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="email" class="form-label">Email *</label>
                                <input type="email" class="form-control" id="email" 
                                       value="${currentUser.email}" readonly disabled
                                       style="background-color: #f5f5f5; cursor: not-allowed;">
                                <small class="form-text text-muted">Email không thể thay đổi</small>
                            </div>
                            <div class="form-group">
                                <label for="phoneNumber" class="form-label">Số điện thoại *</label>
                                <input type="tel" class="form-control" id="phoneNumber" name="phoneNumber" 
                                       value="${currentUser.phoneNumber}" required>
                            </div>
                        </div>
                    </div>
                    
                    <div class="btn-group">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i>
                            Lưu Thay Đổi
                        </button>
                        <button type="button" class="btn btn-outline" onclick="resetForm()">
                            <i class="fas fa-undo"></i>
                            Hủy
                        </button>
                    </div>
                </form>
                

            </div>
        </div>
    </div>
    
    </main>
    
    <!-- Footer -->
    <jsp:include page="../common/footer.jsp" />
    
    <!-- Alert Container for notifications -->
    <div id="alert-container" class="alert-container"></div>
    
    <!-- Toast Handler -->
    <jsp:include page="../common/toast-handler.jsp" />
    
    <script>
        // Form validation
        document.getElementById('profileForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const fullName = document.getElementById('fullName').value.trim();
            const email = document.getElementById('email').value.trim();
            const phoneNumber = document.getElementById('phoneNumber').value.trim();
            
            // Validation
            if (!fullName || !email || !phoneNumber) {
                showToast('Vui lòng điền đầy đủ thông tin', 'error');
                return;
            }
            
            // Email validation
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email)) {
                showToast('Email không hợp lệ', 'error');
                return;
            }
            
            // Phone validation (Vietnamese format)
            const phoneRegex = /^0[35789][0-9]{8}$/;
            if (!phoneRegex.test(phoneNumber)) {
                showToast('Số điện thoại không hợp lệ', 'error');
                return;
            }
            
            // Show loading
            showLoading();
            
            // Submit form
            this.submit();
        });
        
        // Avatar preview handling
        document.getElementById('avatarFile').addEventListener('change', function(e) {
            const file = e.target.files[0];
            if (file) {
                // Validate file
                const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/webp'];
                const maxSize = 5 * 1024 * 1024; // 5MB
                
                if (!allowedTypes.includes(file.type)) {
                    showToast('Định dạng file không hợp lệ. Chỉ chấp nhận: JPG, JPEG, PNG, GIF, WEBP', 'error');
                    return;
                }
                
                if (file.size > maxSize) {
                    showToast('File quá lớn. Kích thước tối đa 5MB', 'error');
                    return;
                }
                
                // Show preview
                const reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('currentAvatar').src = e.target.result;
                };
                reader.readAsDataURL(file);
                
                showToast('Ảnh đại diện đã được chọn. Nhấn "Lưu Thay Đổi" để cập nhật.', 'success');
            }
        });
        
        // Reset form
        function resetForm() {
            document.getElementById('profileForm').reset();
            window.location.reload();
        }
        
        // Show toast notification
        function showToast(message, type = 'success') {
            const toast = document.createElement('div');
            toast.className = `toast toast-${type}`;
            toast.textContent = message;
            
            document.body.appendChild(toast);
            
            // Show toast
            setTimeout(() => toast.classList.add('show'), 100);
            
            // Hide toast
            setTimeout(() => {
                toast.classList.remove('show');
                setTimeout(() => document.body.removeChild(toast), 300);
            }, 3000);
        }
        
        // Show loading overlay
        function showLoading() {
            document.getElementById('loading').classList.add('show');
        }
        
        // Hide loading overlay
        function hideLoading() {
            document.getElementById('loading').classList.remove('show');
        }
        
        // Handle avatar upload response
        window.addEventListener('load', function() {
            hideLoading();
            
            // Check for success message in URL
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.get('success') === 'true') {
                showToast('Cập nhật thành công!', 'success');
            }
        });
        
        // Drag and drop for avatar upload
        const avatarContainer = document.querySelector('.avatar-container');
        
        avatarContainer.addEventListener('dragover', function(e) {
            e.preventDefault();
            this.classList.add('dragover');
        });
        
        avatarContainer.addEventListener('dragleave', function(e) {
            e.preventDefault();
            this.classList.remove('dragover');
        });
        
        avatarContainer.addEventListener('drop', function(e) {
            e.preventDefault();
            this.classList.remove('dragover');
            
            const file = e.dataTransfer.files[0];
            if (file) {
                // Validate file
                const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/webp'];
                const maxSize = 5 * 1024 * 1024; // 5MB
                
                if (!allowedTypes.includes(file.type)) {
                    showToast('Định dạng file không hợp lệ. Chỉ chấp nhận: JPG, JPEG, PNG, GIF, WEBP', 'error');
                    return;
                }
                
                if (file.size > maxSize) {
                    showToast('File quá lớn. Kích thước tối đa 5MB', 'error');
                    return;
                }
                
                // Show preview and update file input
                const reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('currentAvatar').src = e.target.result;
                };
                reader.readAsDataURL(file);
                
                // Update the file input
                const dt = new DataTransfer();
                dt.items.add(file);
                document.getElementById('avatarFile').files = dt.files;
                
                showToast('Ảnh đại diện đã được chọn. Nhấn "Lưu Thay Đổi" để cập nhật.', 'success');
            }
        });
        
        // Auto-hide toasts after page load
        setTimeout(function() {
            const toasts = document.querySelectorAll('.toast');
            toasts.forEach(toast => {
                setTimeout(() => {
                    toast.classList.remove('show');
                    setTimeout(() => toast.remove(), 300);
                }, 2000);
            });
        }, 1000);
    </script>
</body>
</html>