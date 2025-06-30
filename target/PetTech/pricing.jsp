<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN" />
<fmt:setBundle basename="messages" />


<!DOCTYPE html>
<html lang="en">

    <head>
        <!-- Google tag (gtag.js) -->
        <script async src="https://www.googletagmanager.com/gtag/js?id=G-J33JSNL2QG"></script>
        <script>
            window.dataLayer = window.dataLayer || [];
            function gtag() {
                dataLayer.push(arguments);
            }
            gtag('js', new Date());
            gtag('config', 'G-J33JSNL2QG');</script>
        <title>Đăng Ký Gói Dịch Vụ - PetTech</title>
        <meta charset="utf-8">
        <link rel="icon" type="image/png" href="images/logo_pettech.jpg">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

        <link href="https://fonts.googleapis.com/css?family=Montserrat:200,300,400,500,600,700,800&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="css/animate.css">
        <link rel="stylesheet" href="css/owl.carousel.min.css">
        <link rel="stylesheet" href="css/owl.theme.default.min.css">
        <link rel="stylesheet" href="css/magnific-popup.css">
        <link rel="stylesheet" href="css/bootstrap-datepicker.css">
        <link rel="stylesheet" href="css/jquery.timepicker.css">
        <link rel="stylesheet" href="css/flaticon.css">
        <link rel="stylesheet" href="css/style.css">

        <style>
            .navbar-brand {
                font-weight: 800;
                font-size: 1.6rem;
                background: linear-gradient(90deg, #8B5E3C, #D99863);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
            }

            /* Màu chữ trong menu */
            .navbar-nav .nav-link {
                color: #8B5E3C !important;
                font-weight: 600;
                position: relative;
            }

            .navbar-nav .nav-link:hover,
            .navbar-nav .nav-item.active .nav-link {
                color: #D99863 !important;
            }

            /* Hiệu ứng gạch chân khi hover */
            .navbar-nav .nav-link::after {
                content: "";
                display: block;
                width: 0;
                height: 2px;
                background: #D99863;
                transition: width 0.3s;
                position: absolute;
                bottom: 0;
                left: 0;
            }

            .navbar-nav .nav-link:hover::after {
                width: 100%;
            }
            /* Responsive */
            @media (max-width: 768px) {
                .course-header h2 {
                    font-size: 2rem;
                }

                .course-header h2:after,
                .course-header h2:before {
                    font-size: 1.5rem;
                    top: -10px;
                }

                .course-header h2:after {
                    right: -30px;
                }

                .course-header h2:before {
                    left: -30px;
                }
            }

            .course-card {
                transition: all 0.3s ease;
                transform: translateY(0);
            }

            .course-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 15px 35px rgba(0,0,0,0.15);
                z-index: 10;
            }
            /* Dropdown Mega Menu - PetTech */
            .mega-menu {
                width: 850px;
                left: -200px !important;
                border: none;
                box-shadow: 0 10px 30px rgba(0,0,0,0.15);
                border-radius: 0 0 15px 15px;
                overflow: hidden;
            }

            .course-item {
                transition: all 0.3s ease;
                border-radius: 8px;
                margin: 3px;
            }

            .course-item:hover {
                background-color: #f8f5ff;
                transform: translateY(-3px);
                box-shadow: 0 5px 15px rgba(109, 74, 255, 0.1);
            }

            .course-thumbnail {
                width: 60px;
                height: 60px;
                object-fit: cover;
                border-radius: 8px;
                border: 2px solid #e2d9ff;
            }

            .course-title {
                font-size: 14px;
                font-weight: 600;
                color: #4a2c82;
                line-height: 1.3;
            }

            .course-author {
                font-size: 12px;
                color: #a37aff;
            }

            .text-purple {
                color: #6d4aff !important;
            }

            .btn-view-all {
                display: inline-block;
                color: #e67e22 !important; /* Màu cam */
                font-weight: 600;
                padding: 5px 15px;
                border-radius: 20px;
                transition: all 0.3s;
                text-decoration: none;
                background-color: #fff4e6;
            }

            .btn-view-all:hover {
                color: #d35400 !important;
                background-color: #ffe8cc;
                transform: translateX(5px);
            }

            /* Mobile responsive */
            @media (max-width: 992px) {
                .mega-menu {
                    width: 100% !important;
                    left: 0 !important;
                }

                .course-item {
                    border-bottom: 1px solid #eee;
                    border-radius: 0;
                    margin: 0;
                }

                .course-thumbnail {
                    width: 50px;
                    height: 50px;
                }
            }
            /* Dropdown đơn giản - chỉ hiển thị title */
            .dropdown-menu {
                min-width: 250px;
                border: none;
                box-shadow: 0 5px 15px rgba(0,0,0,0.1);
                border-radius: 8px;
                padding: 0;
            }

            .dropdown-header {
                color: #6d4aff;
                font-weight: 600;
                padding: 10px 15px;
                background-color: #f8f5ff;
                border-bottom: 1px solid #e2d9ff;
            }

            .dropdown-item {
                padding: 10px 15px;
                color: #4a2c82;
                transition: all 0.2s;
                border-bottom: 1px solid #f0f0f0;
            }

            .dropdown-item:hover {
                background-color: #f3edff;
                color: #6d4aff;
                padding-left: 20px;
            }

            .view-all-btn {
                color: #e67e22 !important; /* Màu cam */
                font-weight: 600;
                background-color: #fff4e6;
            }

            .view-all-btn:hover {
                background-color: #ffe8cc !important;
            }
            .login-link {
                color: #fff;
                font-weight: 600;
                font-size: 1.05rem;
                text-decoration: none;
                padding: 6px 10px;
                transition: all 0.2s ease;
            }

            .login-link i {
                font-size: 1.1rem;
                color: #fff;
                margin-right: 6px;
            }

            .login-link:hover {
                text-decoration: underline;
            }
            :root {
                --primary-color: #D2691E; /* Màu cam nâu chủ đạo */
                --secondary-color: #FFA07A; /* Màu cam nhạt */
                --accent-color: #FF8C00; /* Màu cam đậm */
                --light-color: #FFF8DC; /* Màu nền nhẹ */
            }

            .package-card {
                border-radius: 20px;
                overflow: hidden;
                transition: all 0.3s ease;
                border: 2px solid var(--primary-color);
                background-color: white;
                box-shadow: 0 10px 20px rgba(210, 105, 30, 0.1);
            }

            .package-card:hover {
                transform: translateY(-10px);
                box-shadow: 0 15px 30px rgba(210, 105, 30, 0.2);
            }

            .package-header {
                background-color: var(--primary-color);
                color: white;
                padding: 20px;
                text-align: center;
            }

            .package-price {
                font-size: 2.5rem;
                font-weight: bold;
                color: var(--primary-color);
                margin: 20px 0;
            }

            .package-features {
                list-style: none;
                padding: 0;
            }

            .package-features li {
                padding: 10px;
                border-bottom: 1px dashed #eee;
                position: relative;
                padding-left: 30px;
            }

            .package-features li:before {
                content: "🐾";
                position: absolute;
                left: 0;
            }

            .btn-package {
                background-color: var(--primary-color);
                border: none;
                border-radius: 30px;
                padding: 12px 30px;
                font-weight: bold;
                color: white;
                transition: all 0.3s;
            }

            .btn-package:hover {
                background-color: var(--accent-color);
                transform: scale(1.05);
            }

            .pet-icon {
                font-size: 2rem;
                color: var(--primary-color);
                margin-right: 10px;
            }

            .section-title {
                color: var(--primary-color);
                position: relative;
                padding-bottom: 15px;
            }

            .section-title:after {
                content: "";
                position: absolute;
                bottom: 0;
                left: 50%;
                transform: translateX(-50%);
                width: 100px;
                height: 3px;
                background-color: var(--secondary-color);
            }

            .cute-banner {
                background-color: var(--light-color);
                border-radius: 15px;
                padding: 20px;
                border-left: 5px solid var(--primary-color);
                margin-bottom: 30px;
            }

            .cute-banner h3 {
                color: var(--primary-color);
            }

            .cute-banner .fa-paw {
                color: var(--accent-color);
                margin-right: 10px;
            }
            .btn-package:disabled {
                background-color: #6c757d;
                cursor: not-allowed;
            }

            .btn-package.upgrade {
                background-color: #28a745;
            }

            .btn-package.register {
                background-color: #007bff;
            }

            .package-card.current {
                border: 3px solid var(--accent-color);
                transform: scale(1.02);
            }

            .package-card.registered {
                opacity: 0.8;
            }
            .package-card {
                border-radius: 15px;
                overflow: hidden;
                transition: all 0.3s ease;
                border: 2px solid #D2691E;
                background-color: white;
                box-shadow: 0 5px 15px rgba(0,0,0,0.1);
                height: 100%;
            }

            .package-card.current {
                border: 3px solid #FF8C00;
                transform: scale(1.02);
                box-shadow: 0 10px 25px rgba(210, 105, 30, 0.2);
            }

            .package-card.registered {
                opacity: 0.8;
                border-color: #6c757d;
            }

            .package-header {
                background-color: #D2691E;
                color: white;
                padding: 20px;
                text-align: center;
            }

            .package-price .display-4 {
                font-weight: bold;
                color: #D2691E;
            }

            .btn-package {
                background-color: #D2691E;
                border: none;
                color: white;
                transition: all 0.3s;
            }

            .btn-package:hover {
                background-color: #FF8C00;
                transform: translateY(-2px);
            }
            /* Hover: nâu cam sáng + hiệu ứng nhún */
            .ftco-footer-social a:hover span {
                color: #D99863 !important;
                transform: scale(1.2);
            }
            .footer-heading {
                position: relative;
                display: inline-block;
                padding-bottom: 10px;
                font-weight: 700;
                font-size: 1.2rem;
                color: #8B5E3C !important; /* Ghi đè màu xanh */
            }

            .footer-heading::after {
                content: "";
                position: absolute;
                bottom: 0;
                left: 0;
                width: 50px;
                height: 3px;
                background: linear-gradient(90deg, #8B5E3C, #D99863) !important;
            }
            /* Blog */
            /* Blog styles */
            .blog-entry {
                background: #fff;
                border-radius: 15px;
                overflow: hidden;
                transition: all 0.3s ease;
                box-shadow: 0 5px 15px rgba(0,0,0,0.05);
                margin-bottom: 30px;
            }

            .blog-entry:hover {
                transform: translateY(-10px);
                box-shadow: 0 15px 30px rgba(0,0,0,0.1);
            }

            .blog-entry .block-20 {
                height: 250px;
                background-size: cover;
                background-position: center center;
                transition: all 0.3s ease;
            }

            .blog-entry:hover .block-20 {
                transform: scale(1.05);
            }

            .blog-entry .text {
                padding: 25px;
            }

            .blog-entry .text .meta {
                margin-bottom: 15px;
            }

            .blog-entry .text .meta div {
                display: inline-block;
                margin-right: 15px;
                color: #8B5E3C;
                font-size: 14px;
            }

            .blog-entry .text .meta div a {
                color: #8B5E3C;
                text-decoration: none;
            }

            .blog-entry .text .meta div a:hover {
                color: #D99863;
            }

            .blog-entry .text .meta-chat {
                color: #D99863;
            }

            .blog-entry .text .heading {
                font-size: 18px;
                margin-bottom: 15px;
            }

            .blog-entry .text .heading a {
                color: #333;
                text-decoration: none;
                transition: all 0.3s ease;
            }

            .blog-entry .text .heading a:hover {
                color: #D99863;
            }

            /* Pagination */
            .block-27 ul {
                padding: 0;
                margin: 0;
            }

            .block-27 ul li {
                display: inline-block;
                margin: 0 5px;
                list-style: none;
            }

            .block-27 ul li a,
            .block-27 ul li span {
                display: inline-block;
                width: 40px;
                height: 40px;
                line-height: 40px;
                text-align: center;
                border-radius: 50%;
                background: #f8f5ff;
                color: #8B5E3C;
                text-decoration: none;
                transition: all 0.3s ease;
            }

            .block-27 ul li a:hover,
            .block-27 ul li span.active {
                background: #D99863;
                color: #fff;
            }

            /* Blog detail */
            .ftco-degree-bg {
                padding: 5rem 0;
            }

            .blog-detail img.img-fluid {
                border-radius: 15px;
                margin-bottom: 30px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            }

            .blog-detail h2 {
                color: #8B5E3C;
                margin-bottom: 20px;
            }

            .blog-detail p {
                margin-bottom: 20px;
                line-height: 1.8;
                color: #555;
            }

            .tag-widget .tagcloud a {
                display: inline-block;
                padding: 8px 15px;
                background: #f8f5ff;
                color: #8B5E3C;
                border-radius: 20px;
                margin: 0 5px 10px 0;
                text-decoration: none;
                transition: all 0.3s ease;
            }

            .tag-widget .tagcloud a:hover {
                background: #D99863;
                color: #fff;
            }

            .about-author {
                border-radius: 15px;
                padding: 30px;
                margin: 50px 0;
            }

            .about-author .bio img {
                width: 120px;
                height: 120px;
                border-radius: 50%;
                object-fit: cover;
                border: 5px solid #f8f5ff;
            }

            .about-author .desc h3 {
                color: #8B5E3C;
                margin-bottom: 15px;
            }

            .comment-list {
                padding: 0;
                margin: 0;
                list-style: none;
            }

            .comment-list .comment {
                margin-bottom: 30px;
            }

            .comment-list .vcard {
                width: 80px;
                float: left;
            }

            .comment-list .vcard img {
                width: 80px;
                height: 80px;
                border-radius: 50%;
                object-fit: cover;
                border: 5px solid #f8f5ff;
            }

            .comment-list .comment-body {
                margin-left: 100px;
            }

            .comment-list .comment-body h3 {
                color: #8B5E3C;
                margin-bottom: 10px;
            }

            .comment-list .comment-body .meta {
                color: #999;
                margin-bottom: 15px;
                font-size: 14px;
            }

            .comment-list .comment-body .reply {
                color: #D99863;
                text-decoration: none;
                font-weight: 600;
            }

            .comment-list .comment-body .reply:hover {
                text-decoration: underline;
            }

            .comment-list .children {
                padding-left: 80px;
                margin-top: 30px;
                list-style: none;
            }

            /* Sidebar */
            .sidebar-box {
                margin-bottom: 30px;
                padding: 25px;
                background: #fff;
                border-radius: 15px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            }

            .sidebar-box h3 {
                color: #8B5E3C;
                margin-bottom: 20px;
                font-size: 20px;
            }

            .search-form .form-group {
                position: relative;
            }

            .search-form .form-group input {
                padding-left: 40px;
                border-radius: 20px;
                border: 1px solid #f0f0f0;
                background: #f8f5ff;
            }

            .search-form .form-group .fa {
                position: absolute;
                top: 12px;
                left: 15px;
                color: #8B5E3C;
            }

            .categories li {
                margin-bottom: 10px;
                padding-bottom: 10px;
                border-bottom: 1px dashed #f0f0f0;
            }

            .categories li:last-child {
                margin-bottom: 0;
                padding-bottom: 0;
                border-bottom: none;
            }

            .categories li a {
                color: #555;
                text-decoration: none;
                transition: all 0.3s ease;
            }

            .categories li a:hover {
                color: #D99863;
            }

            .categories li .fa {
                color: #D99863;
                float: right;
                margin-top: 5px;
            }

            .block-21 {
                display: flex;
                margin-bottom: 20px;
            }

            .block-21 .blog-img {
                width: 100px;
                height: 80px;
                border-radius: 10px;
                background-size: cover;
                background-position: center center;
            }

            .block-21 .text {
                width: calc(100% - 100px);
                padding-left: 15px;
            }

            .block-21 .text .heading {
                font-size: 16px;
                margin-bottom: 10px;
            }

            .block-21 .text .heading a {
                color: #333;
                text-decoration: none;
                transition: all 0.3s ease;
            }

            .block-21 .text .heading a:hover {
                color: #D99863;
            }

            .block-21 .text .meta {
                font-size: 12px;
                color: #999;
            }

            .block-21 .text .meta a {
                color: #999;
                text-decoration: none;
            }

            .block-21 .text .meta a:hover {
                color: #D99863;
            }

            .tagcloud a {
                display: inline-block;
                padding: 5px 12px;
                background: #f8f5ff;
                color: #8B5E3C;
                border-radius: 20px;
                margin: 0 5px 10px 0;
                text-decoration: none;
                transition: all 0.3s ease;
                font-size: 12px !important;
            }

            .tagcloud a:hover {
                background: #D99863;
                color: #fff;
            }

            /* Dropdown menu for blog categories in navbar */
            .navbar-nav .dropdown-menu.blog-dropdown {
                min-width: 250px;
                border: none;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
                border-radius: 10px;
                padding: 15px;
            }

            .navbar-nav .dropdown-menu.blog-dropdown .dropdown-item {
                padding: 8px 15px;
                border-radius: 5px;
                margin-bottom: 5px;
                transition: all 0.3s;
            }

            .navbar-nav .dropdown-menu.blog-dropdown .dropdown-item:hover {
                background-color: #f8f5ff;
                padding-left: 20px;
            }

            .navbar-nav .dropdown-menu.blog-dropdown .dropdown-item:last-child {
                margin-bottom: 0;
            }

            .navbar-nav .dropdown-menu.blog-dropdown .view-all {
                display: block;
                text-align: center;
                margin-top: 10px;
                color: #D99863;
                font-weight: 600;
                text-decoration: none;
            }

            .navbar-nav .dropdown-menu.blog-dropdown .view-all:hover {
                text-decoration: underline;
            }

            /*description goi dich vu */
            /* Loại bỏ hoàn toàn background và các hiệu ứng không cần thiết */
            .package-features {
                list-style: none;
                padding-left: 0;
                margin-left: 0;
            }

            .package-features li {
                background: none !important;
                border: none !important;
                box-shadow: none !important;
                padding: 8px 0 8px 25px !important;
                margin-bottom: 8px;
                position: relative;
                color: #6b4b2f;
                text-align: left;
            }

            /* Giữ lại icon chân chó */
            .package-features li:before {
                content: "🐾";
                position: absolute;
                left: 0;
                top: 8px;
            }

            /* Điều chỉnh icon check/x */
            .package-features li i {
                margin-right: 8px;
                font-size: 16px;
            }

            /* Loại bỏ hiệu ứng hover */
            .package-features li:hover {
                background: none !important;
                transform: none !important;
                padding-left: 25px !important;
            }

            /* Đảm bảo không có khoảng cách thừa */
            .package-features-container {
                padding: 0;
                margin: 0;
            }
        </style>
    </head>
    <body>
        <!-- Top bar -->
        <div class="wrap">
            <div class="container">
                <div class="row">
                    <div class="col-md-6 d-flex align-items-center">
                        <p class="mb-0 phone pl-md-2">
                            <a href="#" class="mr-2"><span class="fa fa-phone mr-1"></span> 0352138596</a> 
                            <a href="#"><span class="fa fa-paper-plane mr-1"></span> PetTech@email.com</a>
                        </p>
                    </div>
                    <div class="col-md-6 d-flex justify-content-md-end align-items-center">
                        <c:choose>
                            <c:when test="${not empty sessionScope.user}">
                                <!-- Hiển thị tên người dùng và nút đăng xuất -->
                                <div class="d-flex align-items-center">
                                    <a class="login-link d-flex align-items-center mr-3" href="authen?action=editprofile">
                                        <i class="fa fa-user-circle mr-2" style="font-size: 1.4rem; color: #6d4aff;"></i>
                                        <span style="font-weight: 600;">${sessionScope.user.fullname}</span>
                                    </a>
                                    <a class="login-link text-danger d-flex align-items-center" href="authen?action=logout">
                                        <i class="fa fa-sign-out mr-2"></i>
                                        <span>Đăng Xuất</span>
                                    </a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <!-- Nếu chưa đăng nhập, hiển thị nút đăng nhập/đăng ký -->
                                <a href="authen?action=login" class="login-link d-flex align-items-center mr-3">
                                    <i class="fa fa-sign-in mr-2"></i>
                                    <span>Đăng Nhập</span>
                                </a>
                                <a href="package" class="login-link d-flex align-items-center">
                                    <i class="fa fa-user-plus mr-2"></i>
                                    <span>Đăng Ký</span>
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>

        <!-- Navbar -->
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark ftco-navbar-light" id="ftco-navbar">
            <div class="container">
                <a class="navbar-brand" href="home">
                    <span class="flaticon-pawprint-1 mr-2"></span>PetTech
                </a>

                <!-- Nút menu mobile -->
                <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#ftco-nav"
                        aria-controls="ftco-nav" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="fa fa-bars"></span> Menu
                </button>

                <!-- Menu chính -->
                <div class="collapse navbar-collapse" id="ftco-nav">
                    <ul class="navbar-nav ml-auto">
                        <li class="nav-item active"><a href="home" class="nav-link">Trang chủ</a></li>

                        <!-- Khóa học Dropdown -->
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="courseDropdown" role="button"
                               data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                Khóa học
                            </a>
                            <div class="dropdown-menu" aria-labelledby="courseDropdown">
                                <div class="dropdown-header">
                                    <i class="fa fa-book mr-2"></i>Danh mục khóa học
                                </div>
                                <c:forEach items="${courseCategories}" var="category">
                                    <a class="dropdown-item" href="course?categoryId=${category.id}">
                                        ${category.name}
                                    </a>
                                </c:forEach>
                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item text-center" href="course">
                                    <i class="fa fa-arrow-right mr-2"></i>Xem tất cả
                                </a>
                            </div>
                        </li>

                        <li class="nav-item"><a href="expert" class="nav-link">Chuyên gia</a></li>
                        <li class="nav-item"><a href="product" class="nav-link">Sản phẩm</a></li>
                        <li class="nav-item"><a href="pet" class="nav-link">Thú cưng</a></li>
                        <li class="nav-item"><a href="package" class="nav-link">Gói dịch vụ</a></li>

                        <!-- Tin tức Dropdown -->
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="blogDropdown" role="button"
                               data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                Tin tức
                            </a>
                            <div class="dropdown-menu" aria-labelledby="blogDropdown">
                                <c:forEach items="${featuredCategories}" var="category">
                                    <a class="dropdown-item" href="blog?category=${category.categoryId}">
                                        <i class="fa fa-paw mr-2"></i>${category.categoryName}
                                    </a>
                                </c:forEach>
                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item text-center" href="blog">
                                    <i class="fa fa-arrow-right mr-2"></i>Xem tất cả
                                </a>
                            </div>
                        </li>

                        <li class="nav-item"><a href="contact" class="nav-link">Liên hệ</a></li>
                    </ul>
                </div>
            </div>
        </nav>
        <!-- END nav -->

        <section class="ftco-section bg-light">
            <div class="container">
                <div class="row justify-content-center pb-5 mb-3">
                    <div class="col-md-7 heading-section text-center ftco-animate">
                        <h2 class="mb-4 section-title">Các Gói Dịch Vụ Của Chúng Tôi</h2>
                        <p>Lựa chọn gói dịch vụ phù hợp với nhu cầu của bạn và thú cưng</p>
                    </div>
                </div>

                <c:if test="${sessionScope.user == null}">
                    <div class="cute-banner">
                        <h3><i class="fas fa-paw"></i>Bạn chưa đăng nhập</h3>
                        <p>Vui lòng <a href="authen?action=login">đăng nhập</a> nếu bạn đã có tài khoản, hoặc <a href="authen?action=signup">đăng ký</a> tài khoản mới để đăng ký gói dịch vụ.</p>
                    </div>
                </c:if>

                <c:if test="${sessionScope.user != null}">
                    <div class="cute-banner">
                        <h3><i class="fas fa-paw"></i>Xin chào ${sessionScope.user.fullname}!</h3>
                        <p>Bạn đang sử dụng gói: 
                            <c:choose>
                                <c:when test="${sessionScope.user.servicePackageId == 1}">
                                    <span class="badge badge-primary">GÓI MIỄN PHÍ</span>
                                </c:when>
                                <c:when test="${sessionScope.user.servicePackageId == 2}">
                                    <span class="badge badge-success">GÓI TIÊU CHUẨN</span>
                                </c:when>
                                <c:when test="${sessionScope.user.servicePackageId == 3}">
                                    <span class="badge badge-warning">GÓI CHUYÊN NGHIỆP</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-secondary">Chưa đăng ký gói</span>
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                </c:if>

                <c:set var="currentPackageId" value="${sessionScope.user.servicePackageId}" />

                <div class="row justify-content-center">
                    <c:choose>
                        <c:when test="${empty packages}">
                            <div class="col-12 text-center">
                                <div class="alert alert-warning">
                                    Hiện không có gói dịch vụ nào khả dụng
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="pkg" items="${packages}">
                                <div class="col-md-4 mb-4 ftco-animate">
                                    <div class="package-card
                                         <c:if test="${pkg.id == currentPackageId}"> current</c:if>
                                         <c:if test="${currentPackageId != null && pkg.id < currentPackageId}"> registered</c:if>">

                                             <div class="package-header">
                                                 <h3>${pkg.name}</h3>
                                         </div>

                                         <div class="text-center p-4">
                                             <div class="package-price mb-3">
                                                 <c:choose>
                                                     <c:when test="${pkg.price == 0}">
                                                         <span class="display-4"><fmt:formatNumber value="${pkg.price}" type="number" groupingUsed="true" />₫</span>

                                                     </c:when>
                                                     <c:otherwise>
                                                         <span class="display-4">
                                                             <fmt:formatNumber value="${pkg.price}" type="number" groupingUsed="true" />
                                                             ₫
                                                         </span>
                                                         <small class="text-muted">/Tháng</small>
                                                     </c:otherwise>

                                                 </c:choose>
                                             </div>

                                             <ul class="package-features list-unstyled mb-4">
                                                 <c:choose>
                                                     <c:when test="${pkg.id == 1}">
                                                         <li><i></i>Truy cập bài viết cơ bản (giới hạn)</li>
                                                         <li><i></i>Tham gia thảo luận các bài viết</li>
                                                         <li><i></i>Bài viết nâng cao theo loại thú cưng</li>
                                                         <li><i></i>Khóa học cơ bản</li>
                                                             </c:when>

                                                     <c:when test="${pkg.id == 2}">
                                                         <li><i></i>Truy cập bài viết cơ bản</li>
                                                         <li><i></i>Tham gia thảo luận các bài viết</li>
                                                         <li><i></i>Video hướng dẫn không giới hạn</li>
                                                         <li><i></i>Bài viết nâng cao theo loại thú cưng</li>
                                                         <li><i></i>Khóa học cơ bản</li>
                                                         <li><i></i>Tư vấn chuyên gia 1 lần/Tuần</li>
                                                             </c:when>

                                                     <c:when test="${pkg.id == 3}">
                                                         <li><i></i>Truy cập bài viết cơ bản</li>
                                                         <li><i></i>Tham gia thảo luận các bài viết</li>
                                                         <li><i></i>Video hướng dẫn không giới hạn</li>
                                                         <li><i></i>Bài viết nâng cao theo loại thú cưng</li>
                                                         <li><i></i>Tất cả khóa học cơ bản & nâng cao</li>
                                                         <li><i></i>Tư vấn 1-1 không giới hạn</li>
                                                         <li><i></i>Tài liệu độc quyền</li>
                                                         <li><i></i>Ưu đãi 10% sản phẩm từ hệ thống</li>
                                                             </c:when>
                                                         </c:choose>
                                             </ul>

                                             <div class="package-actions">
                                                 <c:choose>
                                                     <c:when test="${sessionScope.user == null}">
                                                         <a href="package?action=select&packageId=${pkg.id}" class="btn btn-package btn-block py-3">
                                                             <i class="fas fa-user-plus mr-2"></i>Đăng ký tài khoản
                                                         </a>
                                                     </c:when>
                                                     <c:otherwise>
                                                         <a href="package?action=upgrade&packageId=${pkg.id}" class="btn btn-package btn-block py-3">
                                                             <i class="fas fa-arrow-up mr-2"></i>
                                                             <c:choose>
                                                                 <c:when test="${pkg.id == currentPackageId}">Đang sử dụng</c:when>
                                                                 <c:otherwise>Đăng ký ngay</c:otherwise>
                                                             </c:choose>
                                                         </a>
                                                     </c:otherwise>
                                                 </c:choose>
                                             </div>

                                         </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>

        </section>

        <!-- Footer -->
        <footer class="footer">
            <div class="container">
                <div class="row">
                    <div class="col-md-6 col-lg-3 mb-4 mb-md-0">
                        <h2 class="footer-heading">PetTech</h2>
                        <p>Hệ thống đào tạo và cung cấp giải pháp chăm sóc thú cưng hàng đầu Việt Nam.</p>
                        <ul class="ftco-footer-social p-0">
                            <li class="ftco-animate"><a href="#"><span class="fab fa-facebook-f"></span></a></li>
                            <li class="ftco-animate"><a href="#"><span class="fab fa-instagram"></span></a></li>
                            <li class="ftco-animate"><a href="#"><span class="fab fa-youtube"></span></a></li>
                        </ul>
                    </div>
                    <div class="col-md-6 col-lg-3 mb-4 mb-md-0">
                        <h2 class="footer-heading">Liên kết nhanh</h2>
                        <ul class="list-unstyled">
                            <li><a href="home" class="py-2 d-block">Trang chủ</a></li>
                            <li><a href="course" class="py-2 d-block">Khóa học</a></li>
                            <li><a href="products" class="py-2 d-block">Sản phẩm</a></li>
                            <li><a href="pricing" class="py-2 d-block">Gói dịch vụ</a></li>
                        </ul>
                    </div>
                    <div class="col-md-6 col-lg-3 mb-4 mb-md-0">
                        <h2 class="footer-heading">Hỗ trợ</h2>
                        <ul class="list-unstyled">
                            <li><a href="faq" class="py-2 d-block">Câu hỏi thường gặp</a></li>
                            <li><a href="contact" class="py-2 d-block">Liên hệ</a></li>
                            <li><a href="policy" class="py-2 d-block">Chính sách bảo mật</a></li>
                            <li><a href="terms" class="py-2 d-block">Điều khoản dịch vụ</a></li>
                        </ul>
                    </div>
                    <div class="col-md-6 col-lg-3 mb-4 mb-md-0">
                        <h2 class="footer-heading">Liên hệ</h2>
                        <div class="block-23 mb-3">
                            <ul>
                                <li><span class="icon fa fa-map"></span><span class="text">Khu CNC Láng Hòa Lạc</span></li>
                                <li><a href="#"><span class="icon fa fa-phone"></span><span class="text">+84 352 138 596</span></a></li>
                                <li><a href="#"><span class="icon fa fa-paper-plane"></span><span class="text">pettech@email.com</span></a></li>
                            </ul>
                        </div>
                    </div>
                </div>
                <div class="row mt-5">
                    <div class="col-md-12 text-center">
                        <p class="copyright">
                            Copyright &copy;<script>document.write(new Date().getFullYear());</script> Bản quyền thuộc về PetTech
                        </p>
                    </div>
                </div>
            </div>
        </footer>

        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="js/jquery-migrate-3.0.1.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
        <script src="js/jquery.easing.1.3.js"></script>
        <script src="js/jquery.waypoints.min.js"></script>
        <script src="js/jquery.stellar.min.js"></script>
        <script src="js/jquery.animateNumber.min.js"></script>
        <script src="js/bootstrap-datepicker.js"></script>
        <script src="js/jquery.timepicker.min.js"></script>
        <script src="js/owl.carousel.min.js"></script>
        <script src="js/jquery.magnific-popup.min.js"></script>
        <script src="js/scrollax.min.js"></script>
        <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBVWaKrjvy3MaE7SQ74_uJiULgl1JY0H2s&sensor=false"></script>
        <script src="js/google-map.js"></script>
        <script src="js/main.js"></script>

        <!-- Custom JavaScript -->
        <script>
                                $(document).ready(function () {
                                // Back to top button
                                $(window).scroll(function () {
                                if ($(this).scrollTop() > 300) {
                                $('.back-to-top').fadeIn('slow');
                                } else {
                                $('.back-to-top').fadeOut('slow');
                                }
                                });
                                        $('.back-to-top').click(function (e) {
                                e.preventDefault();
                                        $('html, body').animate({scrollTop: 0}, 500);
                                        return false;
                                });
                                        $('#userDropdown').on('click', function (e) {
                                e.preventDefault();
                                        console.log("Click ok");
                                });
        </script>

    </body>
</html>