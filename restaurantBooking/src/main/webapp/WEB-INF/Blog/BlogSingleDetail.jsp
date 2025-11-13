<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết bài viết | Đặt Bàn Nhà Hàng</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <style>
        body {
            font-family: "Segoe UI", sans-serif;
            background-color: #faf9f8;
            margin: 0;
            padding: 0;
        }


        .container {
            max-width: 1000px;
            margin: 40px auto;
            background-color: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            padding: 40px;
        }
        .post-title {
            font-size: 30px;
            color: #a00;
            margin-bottom: 10px;
        }
        .post-meta {
            font-size: 14px;
            color: gray;
            margin-bottom: 25px;
        }
        .post-content img {
            width: 100%;
            border-radius: 10px;
            margin: 20px 0;
        }
        .post-content p {
            line-height: 1.7;
            margin-bottom: 16px;
        }
        footer {
            background-color: #a00;
            color: #fff;
            text-align: center;
            padding: 15px;
            margin-top: 60px;
        }
        .back-btn {
            display: inline-block;
            background-color: #a00;
            color: #fff;
            text-decoration: none;
            padding: 10px 18px;
            border-radius: 6px;
            margin-top: 20px;
        }
        .back-btn:hover {
            background-color: #800000;
        }
        .hero {
            background-size: cover;
            background-position: center;
            height: 260px;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            color: white;
            margin-top: 15px; /* chừa chỗ cho header cố định */
        }
        .hero .overlay {
            position: absolute;
            inset: 0;
            background: rgba(0,0,0,0.45);
        }
        .hero-content {
            position: relative;
            text-align: center;
        }
    </style>
</head>
<body>


    <jsp:include page="/WEB-INF/views/common/header.jsp" />


<section class="hero" style="background-image: url('https://images.unsplash.com/photo-1600891964599-f61ba0e24092?auto=format&fit=crop&w=1200&q=80');">
    <div class="overlay"></div>
    <div class="hero-content">
        <h2>Blog & Tin tức</h2>
        <p>Khám phá những câu chuyện, sự kiện và món ăn hấp dẫn tại Tica’s Tacos</p>
    </div>
</section>

<div class="container">
    <!-- Giả lập dữ liệu bài viết -->
    <h2 class="post-title">${blog.titleBlogSingle}</h2>
    <div class="post-meta">Đăng ngày: ${blog.createdAtBlogSingle} | Tác giả: ${blog.authorNameBlogSingle}</div>

    <div class="post-content">
        <img src="${blog.imgUrl}" alt="Sushi Nhật Bản">
        <p>${blog.descriptionBlogSingle}</p>
    </div>

    <a href="Blog" class="back-btn">← Quay lại Blog</a>
</div>

<footer>
    © 2025 Đặt Bàn Nhà Hàng. All rights reserved.
</footer>

</body>
</html>
