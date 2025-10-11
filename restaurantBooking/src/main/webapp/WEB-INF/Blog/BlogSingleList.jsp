<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Blog - Tica's Tacos</title>
    <link rel="stylesheet" href="css/BlogList.css">
    <style>
        /* Tổng thể */
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #faf6f3;
            margin: 0;
            padding: 0;
        }

        /* Header cố định khi cuộn */
        header.topbar {
            background-color: #a53323;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            z-index: 1000;
            padding: 12px 0;
            color: white;
            box-shadow: 0 2px 6px rgba(0,0,0,0.15);
        }

        header .container {
            display: flex;
            align-items: center;
            justify-content: space-between;
            width: 90%;
            margin: auto;
        }

        .logo {
            margin: 0;
            font-size: 1.4rem;
            font-weight: bold;
        }

        nav ul {
            list-style: none;
            display: flex;
            gap: 25px;
            margin: 0;
            padding: 0;
        }

        nav a {
            color: #fff;
            text-decoration: none;
            transition: 0.3s;
        }

        nav a:hover {
            color: #ffd1b3;
        }

        /* Hero section */
        .hero {
            background-size: cover;
            background-position: center;
            height: 260px;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            color: white;
            margin-top: 70px; /* chừa chỗ cho header cố định */
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

        .hero-content h2 {
            font-size: 2.4rem;
            margin-bottom: 10px;
        }

        /* Danh mục thể loại */
        .category-nav {
            background: #fff4f2;
            padding: 12px 0;
            border-bottom: 1px solid #e0c8c3;
        }

        .category-list {
            display: flex;
            justify-content: center;
            gap: 30px;
            list-style: none;
            margin: 0;
            padding: 0;
        }

        .category-list li a {
            text-decoration: none;
            color: #6b2c20;
            font-weight: 600;
        }

        .category-list li.active a {
            border-bottom: 2px solid #a53323;
            padding-bottom: 3px;
        }

        /* Blog section */
        .blog-section {
            width: 80%;
            max-width: 1100px;
            margin: 40px auto;
        }

        .blog-post {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            margin-bottom: 30px;
            overflow: hidden;
            transition: transform 0.2s ease;
        }

        .blog-post:hover {
            transform: translateY(-4px);
        }

        .blog-img {
            width: 100%;
            height: 320px;
            background-size: cover;
            background-position: center;
        }

        .blog-content {
            padding: 20px 25px;
        }

        .blog-meta {
            color: #a53323;
            font-size: 0.9rem;
            margin-bottom: 6px;
        }

        .blog-content h3 {
            margin: 8px 0 10px;
            color: #38140f;
        }

        .blog-content p {
            color: #4f4f4f;
            line-height: 1.5;
        }

        .read-more {
            display: inline-block;
            margin-top: 10px;
            color: white;
            font-weight: 600;
            text-decoration: none;
            transition: 0.3s;
        }

        .read-more:hover {
            color: white;
        }

        /* Footer */
        footer.footer {
            text-align: center;
            padding: 20px;
            color: #fff;
            background: #a53323;
            margin-top: 40px;
        }
    </style>
</head>
<body>
<!-- HEADER -->
<header class="topbar">
    <div class="container">
        <h1 class="logo">Tica's Tacos</h1>
        <nav>
            <ul>
                <li><a href="#">Trang chủ</a></li>
                <li><a href="#">Đặt bàn</a></li>
                <li><a href="#">Menu</a></li>
                <li><a href="#">Liên hệ</a></li>
            </ul>
        </nav>
    </div>
</header>

<!-- HERO (CÓ ẢNH NỀN) -->
<section class="hero" style="background-image: url('https://images.unsplash.com/photo-1600891964599-f61ba0e24092?auto=format&fit=crop&w=1200&q=80');">
    <div class="overlay"></div>
    <div class="hero-content">
        <h2>Blog & Tin tức</h2>
        <p>Khám phá những câu chuyện, sự kiện và món ăn hấp dẫn tại Tica’s Tacos</p>
    </div>
</section>

<!-- CATEGORY FILTER -->
<section class="category-nav">
    <div class="container">
        <ul class="category-list">
            <c:forEach var="o" items="${blogCate}">
                <li><a href="BlogSingleListController?id=${o.id}">${o.nameCategoryBlog}</a></li>
            </c:forEach>


        </ul>
    </div>
</section>

<!-- BLOG POSTS (Feed Style) -->
<main class="container blog-section">

    <!-- Bài đăng 1 -->
    <c:forEach var="o" items="${postList}">
        <div class="blog-post">
            <div class="blog-img" style="background-image: url('${o.imgUrl}');"></div>
            <div class="blog-content">
                <span class="blog-meta">${o.createdDate} | ${o.createdBy}</span>
                <h3>${o.titleBlogSingle}</h3>
                <p>
                    ${o.contentBlogSingle}
                </p>

            </div>
        </div>
    </c:forEach>


    <!-- Bài đăng 2 -->


</main>

<!-- FOOTER -->
<footer class="footer">
    <p>© 2025 Tica's Tacos. All rights reserved.</p>
</footer>
</body>
</html>