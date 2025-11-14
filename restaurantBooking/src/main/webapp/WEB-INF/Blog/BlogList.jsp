

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Blog - Tica's Tacos</title>
    <link rel="stylesheet" href="css/BlogList.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
</head>
<body>
<!-- HEADER -->
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<!-- HERO (CÓ ẢNH NỀN) -->
<section class="hero" style="background-image: url('https://images.unsplash.com/photo-1600891964599-f61ba0e24092?auto=format&fit=crop&w=1200&q=80');">
    <div class="overlay"></div>
    <div class="hero-content">
        <h2>Blog & Tin tức</h2>
        <p>Khám phá những câu chuyện, sự kiện và món ăn hấp dẫn tại nhà hàng</p>
    </div>
</section>



<!-- BLOG GRID -->
<main class="container blog-section">
    <div class="blog-grid">

        <!-- ẨM THỰC -->
        <c:forEach var="o" items="${list}">
            <div class="blog-card">
                <div class="blog-img" style="background-image: url('${o.imgUrl}');"></div>
                <div class="blog-info">
                    <span class="meta">Tạo ngày: ${o.createdDate}</span>
                    <h3>${o.nameCategoryBlog}</h3>
                    <p>${o.description}</p>
                    <div class="blog-footer">
                        <a href="BlogSingleList?id=${o.id}" class="read-more">Đọc thêm</a>
                        <span class="comments">💬 5</span>
                    </div>
                </div>
            </div>
        </c:forEach>



    </div>
</main>

<!-- Footer -->
<jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>

