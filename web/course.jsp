<%-- 
    Document   : about
    Created on : May 21, 2025, 11:32:22 PM
    Author     : FPT
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="java.util.List, model.Course" %>
<%@ page import="java.util.List, java.util.ArrayList" %>
<%
    List<Course> courses = (List<Course>) request.getAttribute("courses");
    if (courses == null) {
        courses = new ArrayList<>(); // Không còn lỗi biên dịch
    }
    System.out.println("DEBUG: Số khóa học trong JSP = " + courses.size());
%>


<!DOCTYPE html>
<html lang="en">
    <head>
        <title>PetTech</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

        <link href="https://fonts.googleapis.com/css?family=Montserrat:200,300,400,500,600,700,800&display=swap" rel="stylesheet">

        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">

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

            /* Style tổng thể */
            .course-section {
                background-color: #f9f5ff;
                padding: 60px 0;
            }

            .course-header {
                text-align: center;
                margin-bottom: 40px;
                position: relative;
            }

            .course-header h2 {
                font-size: 2.5rem;
                color: #6d4aff;
                font-weight: 700;
                display: inline-block;
                background: linear-gradient(90deg, #ff9a9e 0%, #fad0c4 100%);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                position: relative;
                z-index: 1;
            }

            .course-header h2:after {
                content: "🐾";
                position: absolute;
                right: -40px;
                top: -15px;
                font-size: 2rem;
            }

            .course-header h2:before {
                content: "🐾";
                position: absolute;
                left: -40px;
                top: -15px;
                font-size: 2rem;
            }

            /* Card khóa học */
            .course-card {
                background: white;
                border-radius: 15px;
                overflow: hidden;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
                transition: all 0.3s ease;
                margin-bottom: 30px;
                border: none;
                height: 100%;
                display: flex;
                flex-direction: column;
            }

            .course-card:hover {
                transform: translateY(-10px);
                box-shadow: 0 15px 35px rgba(0,0,0,0.15);
            }

            .course-img-container {
                height: 200px;
                overflow: hidden;
                position: relative;
            }

            .course-img {
                width: 100%;
                height: 100%;
                object-fit: cover;
                transition: transform 0.5s ease;
            }

            .course-card:hover .course-img {
                transform: scale(1.1);
            }

            .course-badge {
                position: absolute;
                top: 15px;
                right: 15px;
                background: #ff6b81;
                color: white;
                padding: 5px 10px;
                border-radius: 20px;
                font-size: 0.8rem;
                font-weight: bold;
            }

            .course-body {
                padding: 20px;
                flex-grow: 1;
                display: flex;
                flex-direction: column;
            }

            .course-title {
                font-size: 1.3rem;
                color: #3a3a3a;
                margin-bottom: 10px;
                font-weight: 600;
            }

            .course-meta {
                display: flex;
                align-items: center;
                margin-bottom: 15px;
                color: #6d4aff;
                font-size: 0.9rem;
            }

            .course-meta i {
                margin-right: 5px;
            }

            .course-desc {
                color: #666;
                margin-bottom: 20px;
                flex-grow: 1;
            }

            .course-btn {
                background: linear-gradient(135deg, #FF9E57, #FF6B35, #D2691E);
                border: none;
                border-radius: 50px;
                padding: 10px 25px;
                color: white;
                font-weight: 700;
                text-transform: uppercase;
                font-size: 0.85rem;
                letter-spacing: 1px;
                transition: all 0.4s ease;
                align-self: flex-start;
                box-shadow: 0 4px 12px rgba(255, 153, 51, 0.3);
                background-size: 200% auto;
            }

            .course-btn:hover {
                background-position: right center;
                box-shadow: 0 6px 18px rgba(255, 107, 53, 0.5);
                transform: scale(1.05);
                color: #fff;
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
            /* Style cho input search */
            .search-form .form-control {
                border-radius: 50px 0 0 50px;
                border: 1px solid #FFD6A0;
                padding: 10px 20px;
                font-size: 1rem;
                box-shadow: none;
            }

            /* Nút tìm kiếm nâu-cam dễ thương */
            .search-form .btn {
                background: linear-gradient(45deg, #FFA630, #D2691E);
                color: white;
                border: none;
                border-radius: 0 50px 50px 0;
                padding: 10px 25px;
                font-size: 1.1rem;
                font-weight: bold;
                box-shadow: 0 4px 10px rgba(210, 105, 30, 0.3);
                transition: all 0.3s ease;
            }

            .search-form .btn:hover {
                background: linear-gradient(45deg, #FF6B35, #B25C1D);
                transform: translateY(-2px);
                box-shadow: 0 6px 15px rgba(210, 105, 30, 0.4);
            }


            /* Cute Brown-Orange Pagination Style */
            .pagination .page-link {
                color: #B25C1D;
                background-color: #FFF3E0;
                border: 1px solid #FFB74D;
                border-radius: 50% !important;
                width: 42px;
                height: 42px;
                text-align: center;
                line-height: 38px;
                font-weight: bold;
                margin: 0 5px;
                transition: all 0.3s ease-in-out;
                box-shadow: 0 4px 8px rgba(178, 92, 29, 0.2);
            }

            .pagination .page-link:hover {
                background-color: #FFB74D;
                color: white;
                transform: translateY(-2px);
            }

            .pagination .page-item.active .page-link {
                background-color: #D2691E;
                color: white;
                border-color: #D2691E;
                box-shadow: 0 4px 10px rgba(210, 105, 30, 0.3);
                transform: scale(1.05);
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
        </style>

        <script>
            $(document).ready(function () {
                // Hiệu ứng loading khi click vào phân trang hoặc tìm kiếm
                $('.page-link, .search-form button').click(function () {
                    $('#ftco-loader').addClass('show');
                });
            });
        </script>

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
        <nav class="navbar navbar-expand-lg navbar-dark ftco_navbar bg-dark ftco-navbar-light" id="ftco-navbar">
            <div class="container">
                <a class="navbar-brand" href="home"><span class="flaticon-pawprint-1 mr-2"></span>PetTech</a>
                <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#ftco-nav" aria-controls="ftco-nav" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="fa fa-bars"></span> Menu
                </button>
                <div class="collapse navbar-collapse" id="ftco-nav">
                    <ul class="navbar-nav ml-auto">
                        <li class="nav-item active"><a href="home" class="nav-link">Trang chủ</a></li>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="course" id="coursesDropdown" role="button" data-toggle="dropdown">
                                Khóa học
                            </a>
                            <div class="dropdown-menu" aria-labelledby="coursesDropdown">
                                <div class="dropdown-header">
                                    <i class="fa fa-book mr-2"></i>Danh mục khóa học
                                </div>
                                <c:forEach items="${featuredCourses}" var="course" end="8">
                                    <a class="dropdown-item" href="coursedetail?id=${course.id}">
                                        ${fn:substring(course.title, 0, 50)}${fn:length(course.title) > 50 ? '...' : ''}
                                    </a>
                                </c:forEach>
                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item text-center view-all-btn" href="course">
                                    <i class="fa fa-arrow-right mr-2"></i>Xem tất cả
                                </a>
                            </div>
                        </li>
                        <li class="nav-item"><a href="vet.jsp" class="nav-link">Chuyên gia</a></li>
                        <li class="nav-item"><a href="service.jsp" class="nav-link">Sản phẩm</a></li>
                        <li class="nav-item"><a href="gallery.jsp" class="nav-link">Thú cưng</a></li>
                        <li class="nav-item"><a href="package" class="nav-link">Gói dịch vụ</a></li>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="blog" id="blogDropdown" role="button" data-toggle="dropdown">
                                Tin tức
                            </a>
                            <div class="dropdown-menu blog-dropdown" aria-labelledby="blogDropdown">
                                <c:forEach items="${featuredCategories}" var="category">
                                    <a class="dropdown-item" href="blog?category=${category.categoryId}">
                                        <i class="fa fa-paw mr-2"></i>${category.categoryName}
                                    </a>
                                </c:forEach>
                                <div class="dropdown-divider"></div>
                                <a class="view-all" href="blog">
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


        <section class="course-section">
            <!-- Thêm vào đầu section course-section -->
            <div class="container mb-5">
                <div class="row justify-content-center">
                    <div class="col-md-8">
                        <form action="course" method="get" class="search-form">
                            <div class="input-group">
                                <input type="text" class="form-control" name="search" placeholder="Tìm kiếm khóa học..." 
                                       value="${param.search}">
                                <button class="btn" type="submit">
                                    <i class="fa fa-search"></i>
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <div class="container">
                <div class="course-header">
                    <h2>Danh Sách Khóa Học</h2>
                </div>

                <div class="row">
                    <% if (courses != null && !courses.isEmpty()) { %>
                    <% for (Course course : courses) { %>
                    <div class="col-lg-4 col-md-6 mb-4">
                        <div class="course-card">

                            <div class="course-img-container">
                                <%
                                    // Xử lý đường dẫn ảnh an toàn
                                    String imageUrl = course.getImageUrl();
                                    String defaultImage = request.getContextPath() + "/images/corgin-1.jpg";

                                    // Xây dựng đường dẫn ảnh cuối cùng
                                    String finalImagePath;
                                    if (imageUrl != null && !imageUrl.isEmpty()) {
                                        // Nếu URL ảnh đã bắt đầu bằng / hoặc http
                                        if (imageUrl.startsWith("/") || imageUrl.startsWith("http")) {
                                            finalImagePath = imageUrl.startsWith("/") ? request.getContextPath() + imageUrl : imageUrl;
                                        } else {
                                            // Nếu URL ảnh là relative path không có / đầu
                                            finalImagePath = request.getContextPath() + "/" + imageUrl;
                                        }
                                    } else {
                                        finalImagePath = defaultImage;
                                    }
                                %>

                                <img src="<%= finalImagePath%>" 
                                     alt="<%= course.getTitle()%>" 
                                     class="course-img"
                                     onerror="this.onerror=null; this.src='<%= defaultImage%>'">




                            </div>
                            <div class="course-body">
                                <h3 class="course-title"><%= course.getTitle()%></h3>

                                <div class="course-meta">
                                    <i class="fa fa-clock-o"></i> <%= course.getTime() != null ? course.getTime() : "Đang cập nhật"%>
                                </div>

                                <% if (course.getResearcher() != null && !course.getResearcher().isEmpty()) {%>
                                <div class="course-meta">
                                    <i class="fa fa-user"></i> <%= course.getResearcher()%>
                                </div>
                                <% } %>

                                <p class="course-desc">
                                    <% if (course.getContent() != null) {
                                            if (course.getContent().length() > 100) {%>
                                    <%= course.getContent().substring(0, 100)%>...
                                    <% } else {%>
                                    <%= course.getContent()%>
                                    <% }
                                    } else { %>
                                    Nội dung đang được cập nhật...
                                    <% }%>
                                </p>

                                <div class="course-meta">
                                    <i class="fa fa-calendar"></i> <%= course.getTime() != null ? course.getTime() : ""%>
                                </div>

                                <a href="${pageContext.request.contextPath}/coursedetail?id=<%= course.getId()%>" class="course-btn">
                                    Xem chi tiết <i class="fa fa-arrow-right"></i>
                                </a>

                            </div>
                        </div>
                    </div>
                    <% } %>
                    <% } else { %>
                    <div class="col-12 text-center">
                        <div class="alert alert-info" style="background-color: #e2d9ff; border-color: #6d4aff; color: #3a3a3a;">
                            <i class="fa fa-paw"></i> Hiện chưa có khóa học nào. Vui lòng quay lại sau!
                        </div>
                    </div>
                    <% }%>
                </div>
            </div>
            <!-- Thêm sau phần hiển thị danh sách khóa học -->
            <div class="row mt-5">
                <div class="col-12">
                    <nav aria-label="Page navigation">
                        <ul class="pagination justify-content-center">
                            <c:if test="${currentPage > 1}">
                                <li class="page-item">
                                    <a class="page-link" href="course?page=${currentPage - 1}" aria-label="Previous">
                                        <span aria-hidden="true">&laquo;</span>
                                    </a>
                                </li>
                            </c:if>

                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link" href="course?page=${i}">${i}</a>
                                </li>
                            </c:forEach>

                            <c:if test="${currentPage < totalPages}">
                                <li class="page-item">
                                    <a class="page-link" href="course?page=${currentPage + 1}" aria-label="Next">
                                        <span aria-hidden="true">&raquo;</span>
                                    </a>
                                </li>
                            </c:if>
                        </ul>
                    </nav>
                </div>
            </div>
        </section>



        <!-- Newsletter -->
        <section class="newsletter-section">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-md-8 text-center">
                        <div class="course-header">
                            <h2>Đăng ký nhận khóa học</h2>
                            <p>Nhận thông tin mới nhất về khóa học, sản phẩm và ưu đãi đặc biệt từ PetTech</p>
                        </div>
                        <form class="form-inline justify-content-center" action="package" method="get">
                            <div class="form-group mx-sm-3 mb-2">
                                <input type="email" class="form-control" name="email" placeholder="Nhập email của bạn">
                            </div>
                            <button type="submit" class="btn btn-primary mb-2">Đăng ký ngay</button>
                        </form>

                    </div>
                </div>
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



        <!-- loader -->
        <div id="ftco-loader" class="show fullscreen"><svg class="circular" width="48px" height="48px"><circle class="path-bg" cx="24" cy="24" r="22" fill="none" stroke-width="4" stroke="#eeeeee"/><circle class="path" cx="24" cy="24" r="22" fill="none" stroke-width="4" stroke-miterlimit="10" stroke="#F96D00"/></svg></div>


        <script src="js/jquery.min.js"></script>
        <script src="js/jquery-migrate-3.0.1.min.js"></script>
        <script src="js/popper.min.js"></script>
        <script src="js/bootstrap.min.js"></script>
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


    </body>
</html>