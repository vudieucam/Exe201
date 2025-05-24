<%-- 
Document   : course_detail
Created on : May 23, 2025, 3:08:05 AM
Author     : FPT
--%>

<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@page import="model.Course" %>
<%@page import="model.CourseModule" %>
<%@page import="model.CourseLesson" %>
<%@page import="dal.CourseDAO" %>
<%@page import="java.util.List" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Date" %>

<%
    System.out.println("JSP - Course object: " + request.getAttribute("course"));
%>

<%
// Phần 1: Kiểm tra course có tồn tại không
    Course course = (Course) request.getAttribute("course");
    if (course == null) {
        String errorMessage = (String) request.getSession().getAttribute("errorMessage");
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <title>Lỗi - Không tìm thấy khóa học | PetTech</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://fonts.googleapis.com/css?family=Montserrat:200,300,400,500,600,700,800&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <style>
            .error-container {
                text-align: center;
                padding: 100px 20px;
            }
            .error-container h3 {
                color: #4a2c82;
                margin-bottom: 20px;
            }
            .btn-primary {
                background: #6d4aff;
                color: white;
                padding: 10px 20px;
                border-radius: 5px;
                text-decoration: none;
                display: inline-block;
            }
        </style>
    </head>
    <body>
        <% if (errorMessage != null) {%>
        <div class="alert alert-danger" style="padding: 15px; background: #ffebee; color: #c62828; margin: 15px;">
            <%= errorMessage%>
        </div>
        <%
                request.getSession().removeAttribute("errorMessage");
            }
        %>
        <div class="error-container">
            <h3>Không tìm thấy khóa học</h3>
            <a href="${pageContext.request.contextPath}/course" class="btn-primary">
                Quay lại danh sách khóa học
            </a>
        </div>
    </body>
</html>
<%
        return;
    }

// Phần 2: Xử lý dữ liệu khi course tồn tại
// Định dạng ngày đăng
    String formattedDate = "Đang cập nhật";
    try {
        if (course.getPostDate() != null && !course.getPostDate().isEmpty()) {
            SimpleDateFormat dbFormat = new SimpleDateFormat("yyyy-MM-dd");
            Date date = dbFormat.parse(course.getPostDate());
            SimpleDateFormat displayFormat = new SimpleDateFormat("dd/MM/yyyy");
            formattedDate = displayFormat.format(date);
        }
    } catch (Exception e) {
        System.out.println("Lỗi định dạng ngày: " + e.getMessage());
    }

// Xử lý đường dẫn ảnh
    String imageUrl = course.getImageUrl();
    String defaultImage = request.getContextPath() + "/images/corgi-course.jpg";
    String finalImagePath;

    if (imageUrl != null && !imageUrl.isEmpty()) {
        if (imageUrl.startsWith("/") || imageUrl.startsWith("http")) {
            finalImagePath = imageUrl.startsWith("/") ? request.getContextPath() + imageUrl : imageUrl;
        } else {
            finalImagePath = request.getContextPath() + "/" + imageUrl;
        }
    } else {
        finalImagePath = defaultImage;
    }
%>


<!DOCTYPE html>
<html lang="vi">
    <head>
        <title><%= course.getTitle() != null ? course.getTitle() : "Chi tiết khóa học"%> | PetTech</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

        <link href="https://fonts.googleapis.com/css?family=Montserrat:200,300,400,500,600,700,800&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/animate.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/owl.carousel.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/owl.theme.default.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/magnific-popup.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap-datepicker.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery.timepicker.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/flaticon.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

        <style>
            /* Main Course Detail Styles */
            .course-detail-header {
                background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
                padding: 60px 0 40px;
                position: relative;
                overflow: hidden;
            }

            .course-detail-header:before {
                content: "";
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background-image: url('${pageContext.request.contextPath}/images/paw-pattern.png');
                opacity: 0.05;
                z-index: 0;
            }

            .course-title {
                font-size: 2.5rem;
                color: #4a2c82;
                font-weight: 700;
                margin-bottom: 20px;
                position: relative;
                z-index: 1;
            }

            .course-title:after {
                content: "🐾";
                margin-left: 15px;
            }

            .course-meta {
                display: flex;
                flex-wrap: wrap;
                gap: 20px;
                margin-bottom: 30px;
                z-index: 1;
                position: relative;
            }

            .meta-item {
                display: flex;
                align-items: center;
                background: rgba(255,255,255,0.8);
                padding: 8px 15px;
                border-radius: 30px;
                box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            }

            .meta-item i {
                margin-right: 8px;
                color: #6d4aff;
            }

            .course-hero-image {
                border-radius: 15px;
                overflow: hidden;
                box-shadow: 0 15px 30px rgba(0,0,0,0.1);
                height: 350px;
                object-fit: cover;
                width: 100%;
            }

            /* Course Content Section */
            .course-content-section {
                padding: 60px 0;
            }

            .section-title {
                font-size: 1.8rem;
                color: #4a2c82;
                margin-bottom: 30px;
                position: relative;
                padding-bottom: 15px;
            }

            .section-title:after {
                content: "";
                position: absolute;
                bottom: 0;
                left: 0;
                width: 80px;
                height: 4px;
                background: linear-gradient(90deg, #6d4aff 0%, #a37aff 100%);
                border-radius: 2px;
            }

            .course-content {
                font-size: 1.1rem;
                line-height: 1.8;
                color: #555;
                margin-bottom: 40px;
            }

            .course-content p {
                margin-bottom: 20px;
            }

            /* Researcher Info */
            .researcher-card {
                background: white;
                border-radius: 15px;
                padding: 30px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.05);
                margin-top: 40px;
                border-left: 5px solid #6d4aff;
            }

            .researcher-header {
                display: flex;
                align-items: center;
                margin-bottom: 20px;
            }

            .researcher-avatar {
                width: 80px;
                height: 80px;
                border-radius: 50%;
                object-fit: cover;
                margin-right: 20px;
                border: 3px solid #e2d9ff;
            }

            .researcher-name {
                font-size: 1.5rem;
                color: #4a2c82;
                margin-bottom: 5px;
            }

            .researcher-title {
                color: #6d4aff;
                font-weight: 500;
            }

            /* Action Buttons */
            .action-buttons {
                margin-top: 40px;
                display: flex;
                gap: 15px;
                flex-wrap: wrap;
            }

            .btn-enroll {
                background: linear-gradient(90deg, #6d4aff 0%, #a37aff 100%);
                color: white;
                border: none;
                padding: 12px 30px;
                border-radius: 50px;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 1px;
                transition: all 0.3s ease;
            }

            .btn-enroll:hover {
                transform: translateY(-3px);
                box-shadow: 0 10px 20px rgba(109, 74, 255, 0.3);
                color: white;
                text-decoration: none;
            }

            .btn-back {
                background: white;
                color: #6d4aff;
                border: 2px solid #6d4aff;
                padding: 12px 30px;
                border-radius: 50px;
                font-weight: 600;
                transition: all 0.3s ease;
                text-decoration: none;
            }

            .btn-back:hover {
                background: #f5f2ff;
                color: #4a2c82;
                text-decoration: none;
            }

            /* Responsive Adjustments */
            @media (max-width: 768px) {
                .course-title {
                    font-size: 2rem;
                }

                .course-hero-image {
                    height: 250px;
                    margin-bottom: 30px;
                }

                .researcher-header {
                    flex-direction: column;
                    text-align: center;
                }

                .researcher-avatar {
                    margin-right: 0;
                    margin-bottom: 15px;
                }

                .action-buttons {
                    justify-content: center;
                }
            }

            /* Paw theme */
            .course-title:after {
                content: "🐾";
                margin-left: 10px;
            }

            .meta-item {
                background: #fff0f7;
                border: 1px solid #ffd9e6;
            }

            .lesson-item:hover {
                background: #f8e1f0 !important;
            }

            .researcher-avatar {
                border: 3px solid #ffb3d9;
            }

            /* Nút Next/Previous */
            .lesson-navigation .btn-primary {
                background: #ff85b2;
                border-color: #ff85b2;
            }

            .lesson-navigation .btn-primary:hover {
                background: #ff6699;
            }

            /* Main Course Detail Styles */
            .course-detail-header {
                background: linear-gradient(135deg, #f5f7fa 0%, #e3f2fd 100%);
                padding: 60px 0 40px;
                position: relative;
                overflow: hidden;
            }

            .course-detail-header:before {
                content: "";
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background-image: url('${pageContext.request.contextPath}/images/paw-pattern.png');
                opacity: 0.05;
                z-index: 0;
            }

            .course-title {
                font-size: 2.5rem;
                color: #4a2c82;
                font-weight: 700;
                margin-bottom: 20px;
                position: relative;
                z-index: 1;
            }

            .course-meta {
                display: flex;
                flex-wrap: wrap;
                gap: 15px;
                margin-bottom: 30px;
                z-index: 1;
                position: relative;
            }

            .meta-item {
                display: flex;
                align-items: center;
                background: rgba(255,255,255,0.9);
                padding: 8px 15px;
                border-radius: 30px;
                box-shadow: 0 3px 10px rgba(0,0,0,0.05);
                font-size: 0.9rem;
            }

            .meta-item i {
                margin-right: 8px;
                color: #6d4aff;
            }

            .course-hero-image {
                border-radius: 15px;
                overflow: hidden;
                box-shadow: 0 15px 30px rgba(0,0,0,0.1);
                height: 250px;
                object-fit: cover;
                width: 100%;
                border: 5px solid white;
            }

            /* Course Sidebar */
            .course-sidebar {
                background: white;
                border-radius: 15px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.05);
                overflow: hidden;
                margin-bottom: 30px;
            }

            .sidebar-header {
                padding: 15px 20px;
                background: linear-gradient(90deg, #6d4aff 0%, #a37aff 100%);
                color: white;
                display: flex;
                align-items: center;
            }

            .sidebar-header h4 {
                margin: 0;
                font-size: 1.1rem;
                display: flex;
                align-items: center;
            }

            .sidebar-header .badge {
                background: rgba(255,255,255,0.2);
                margin-left: auto;
            }

            .modules-list {
                padding: 10px 0;
            }

            .module-item {
                border-bottom: 1px solid #eee;
            }

            .module-header {
                padding: 12px 20px;
                display: flex;
                align-items: center;
                cursor: pointer;
                transition: all 0.3s;
            }

            .module-header:hover {
                background: #f9f5ff;
            }

            .module-header i {
                color: #6d4aff;
                margin-right: 10px;
            }

            .lessons-list {
                padding-left: 40px;
            }

            .lesson-item {
                display: flex;
                align-items: center;
                padding: 10px 15px;
                color: #555;
                text-decoration: none;
                transition: all 0.3s;
                border-left: 3px solid transparent;
            }

            .lesson-item:hover, .lesson-item.active {
                background: #f3edff;
                color: #4a2c82;
                border-left-color: #6d4aff;
            }

            .lesson-item i {
                margin-right: 10px;
                color: #a37aff;
            }

            .lesson-item.active i {
                color: #6d4aff;
            }

            .lesson-duration {
                font-size: 0.8rem;
                color: #888;
                margin-left: auto;
            }

            /* Lesson Content */
            .lesson-content {
                background: white;
                border-radius: 15px;
                padding: 30px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            }

            .lesson-title {
                color: #4a2c82;
                margin-bottom: 25px;
                padding-bottom: 15px;
                border-bottom: 2px solid #f0e9ff;
            }

            .lesson-text {
                line-height: 1.8;
                color: #555;
            }

            .lesson-text img {
                max-width: 100%;
                height: auto;
                border-radius: 10px;
                margin: 20px 0;
            }

            /* Attachments */
            .attachments-list {
                border: 1px solid #eee;
                border-radius: 10px;
                overflow: hidden;
            }

            .attachment-item {
                display: flex;
                align-items: center;
                padding: 12px 15px;
                border-bottom: 1px solid #eee;
            }

            .attachment-item:last-child {
                border-bottom: none;
            }

            .attachment-item i {
                font-size: 1.5rem;
                color: #e74c3c;
                margin-right: 15px;
            }

            /* Discussion */
            .discussion-section {
                background: white;
                border-radius: 15px;
                padding: 30px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.05);
                margin-top: 30px;
            }

            .discussion-item {
                display: flex;
                padding: 15px 0;
                border-bottom: 1px solid #eee;
            }

            .user-avatar {
                width: 50px;
                height: 50px;
                border-radius: 50%;
                overflow: hidden;
                margin-right: 15px;
            }

            .user-avatar img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            .discussion-content {
                flex: 1;
            }

            .user-name {
                font-weight: 600;
                color: #4a2c82;
            }

            .discussion-text {
                margin: 8px 0;
            }

            .discussion-meta {
                font-size: 0.85rem;
                color: #888;
            }

            /* Researcher Card */
            .researcher-card {
                background: white;
                border-radius: 15px;
                padding: 25px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.05);
                margin-bottom: 30px;
                border-left: 5px solid #6d4aff;
            }

            .researcher-header {
                display: flex;
                align-items: center;
                margin-bottom: 15px;
            }

            .researcher-avatar {
                width: 70px;
                height: 70px;
                border-radius: 50%;
                object-fit: cover;
                margin-right: 20px;
                border: 3px solid #e2d9ff;
            }

            .researcher-name {
                font-size: 1.3rem;
                color: #4a2c82;
                margin-bottom: 5px;
            }

            .researcher-title {
                color: #6d4aff;
                font-weight: 500;
                font-size: 0.9rem;
            }

            /* Responsive */
            @media (max-width: 992px) {
                .course-sidebar {
                    margin-bottom: 40px;
                }

                .course-title {
                    font-size: 2rem;
                }

                .course-hero-image {
                    margin-top: 20px;
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
            .search-bar-container {
                background: #f8f9fa;
                padding: 15px 0;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            }

            .search-form {
                max-width: 600px;
                margin: 0 auto;
            }

            .search-form .input-group {
                box-shadow: 0 2px 10px rgba(109, 74, 255, 0.1);
            }

            .search-form .form-control {
                border-radius: 50px 0 0 50px;
                border: 1px solid #e2d9ff;
                padding: 10px 20px;
            }

            .search-form .btn {
                border-radius: 0 50px 50px 0;
                padding: 10px 20px;
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

            /* Thay các màu xanh bằng màu nâu cam */

            /* Header */
            .course-detail-header {
                background: linear-gradient(135deg, #f5f7fa 0%, #fef0e7 100%);
            }

            .course-title {
                color: #d35400;
            }

            .meta-item i {
                color: #e67e22;
            }

            /* Sidebar */
            .sidebar-header {
                background: linear-gradient(90deg, #e67e22 0%, #f39c12 100%);
            }

            .module-header i {
                color: #e67e22;
            }

            .lesson-item:hover, .lesson-item.active {
                background: #fff4e6;
                color: #d35400;
                border-left-color: #e67e22;
            }

            /* Nút */
            .btn-enroll {
                background: linear-gradient(90deg, #e67e22 0%, #f39c12 100%);
            }

            .btn-enroll:hover {
                box-shadow: 0 10px 20px rgba(230, 126, 34, 0.3);
            }

            .btn-back {
                color: #e67e22;
                border: 2px solid #e67e22;
            }

            /* Discussion */
            .user-name {
                color: #d35400;
            }

            /* Researcher card */
            .researcher-card {
                border-left: 5px solid #e67e22;
            }

            .researcher-title {
                color: #e67e22;
            }
            .paw-icon {
                color: #8b4513; /* Màu nâu đậm cho hình paw */
            }
            /* Nút tìm kiếm cute nâu-cam */
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



        </style>

    </head>
    <body>

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
                        <a href="authen?action=login" class="login-link d-flex align-items-center mr-3">
                            <i class="fa fa-sign-in mr-2"></i>
                            <span>Đăng Nhập</span>
                        </a>
                        <a href="authen?action=signup" class="login-link d-flex align-items-center">
                            <i class="fa fa-user-plus mr-2"></i>
                            <span>Đăng Ký</span>
                        </a>
                    </div>

                </div>
            </div>
        </div>

        <nav class="navbar navbar-expand-lg navbar-dark ftco_navbar bg-dark ftco-navbar-light" id="ftco-navbar">
            <div class="container">
                <a class="navbar-brand" href="${pageContext.request.contextPath}/Home.jsp"><span class="flaticon-pawprint-1 mr-2"></span>PetTech</a>
                <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#ftco-nav" aria-controls="ftco-nav" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="fa fa-bars"></span> Menu
                </button>
                <div class="collapse navbar-collapse" id="ftco-nav">
                    <ul class="navbar-nav ml-auto">
                        <li class="nav-item"><a href="Home.jsp" class="nav-link">Trang chủ</a></li>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="coursedetail" id="coursesDropdown" role="button" 
                               data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
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
                        <li class="nav-item"><a href="blog.jsp" class="nav-link">Tin tức</a></li>
                        <li class="nav-item"><a href="contact.jsp" class="nav-link">Liên hệ</a></li>
                    </ul>
                </div>
            </div>
        </nav>

        <!-- Course Header Section -->
        <section class="course-detail-header">
            <!-- Thêm vào sau phần navbar -->
            <div class="search-bar-container">
                <div class="container">
                    <form action="course" method="get" class="search-form">
                        <div class="input-group">
                            <input type="text" class="form-control" name="search" placeholder="Tìm kiếm khóa học khác..." 
                                   value="${param.search}">
                            <button class="btn" type="submit">
                                <i class="fa fa-search"></i>
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <div class="container">
                <div class="container">
                    <div class="row align-items-center">
                        <div class="col-lg-7">
                            <% if (course != null) {%>
                            <title><%= course.getTitle() != null ? course.getTitle() : "Chi tiết khóa học"%> | PetTech</title>

                            <!-- Tiêu đề khóa học -->
                            <h1 class="course-title" style="
                                color: #FF6B35;
                                font-weight: 700;
                                margin-bottom: 20px;
                                font-size: 2.3rem;
                                text-shadow: 1px 1px 3px rgba(0,0,0,0.08);
                                font-family: 'Montserrat', cursive;
                                ">
                                🐶 <span style="color: #FFA630;">
                                    <%= course.getTitle() != null ? course.getTitle().toUpperCase() : "KHÓA HỌC THÚ CƯNG"%>
                                </span> 🐱
                            </h1>

                            <% } else { %>
                            <title>Lỗi - Không tìm thấy khóa học | PetTech</title>
                            <% } %>

                            <!-- Thông tin khóa học -->
                            <div class="course-meta" style="
                                 display: flex;
                                 flex-wrap: wrap;
                                 gap: 10px;
                                 align-items: center;
                                 font-family: 'Montserrat', sans-serif;
                                 ">
                                <% if (course.getResearcher() != null && !course.getResearcher().isEmpty()) {%>
                                <div class="meta-item" style="
                                     background-color: #FFE8CC;
                                     border: 2px dashed #FF9F1C;
                                     padding: 8px 16px;
                                     border-radius: 50px;
                                     font-size: 0.95rem;
                                     display: flex;
                                     align-items: center;
                                     gap: 6px;
                                     ">
                                    <i class="fa fa-user" style="color: #FF6B35; font-size: 1.1rem;"></i>
                                    <span><strong>Giảng viên:</strong> <span style="color: #FF6B35; font-size: 1rem;"><%= course.getResearcher()%></span></span>
                                </div>
                                <% }%>

                                <div class="meta-item" style="
                                     background-color: #FFE8CC;
                                     border: 2px dashed #FF9F1C;
                                     padding: 8px 16px;
                                     border-radius: 50px;
                                     font-size: 0.95rem;
                                     display: flex;
                                     align-items: center;
                                     gap: 6px;
                                     ">
                                    <i class="fa fa-calendar" style="color: #FF6B35; font-size: 1.1rem;"></i>
                                    <span><strong>Ngày đăng:</strong> <span style="color: #FF6B35; font-size: 1rem;"><%= formattedDate%></span></span>
                                </div>

                                <% if (course.getTime() != null && !course.getTime().isEmpty()) {%>
                                <div class="meta-item" style="
                                     background-color: #FFE8CC;
                                     border: 2px dashed #FF9F1C;
                                     padding: 8px 16px;
                                     border-radius: 50px;
                                     font-size: 0.95rem;
                                     display: flex;
                                     align-items: center;
                                     gap: 6px;
                                     ">
                                    <i class="fa fa-clock-o" style="color: #FF6B35; font-size: 1.1rem;"></i>
                                    <span><strong>Thời lượng:</strong> <span style="color: #FF6B35; font-size: 1rem;"><%= course.getTime()%></span></span>
                                </div>
                                <% }%>

                                <div class="meta-item" style="
                                     background-color: #FFE8CC;
                                     border: 2px dashed #FF9F1C;
                                     padding: 8px 16px;
                                     border-radius: 50px;
                                     font-size: 0.95rem;
                                     display: flex;
                                     align-items: center;
                                     gap: 6px;
                                     ">
                                    <i class="fa fa-paw" style="color: #FF6B35; font-size: 1.1rem;"></i>
                                    <span><strong>Dành cho:</strong> <span style="color: #FF6B35; font-size: 1rem;">Chó 🐕 / Mèo 🐈</span></span>
                                </div>
                            </div>
                        </div>

                        <div class="col-lg-5">
                            <img src="<%= finalImagePath%>" 
                                 alt="<%= course.getTitle() != null ? course.getTitle() : "Khóa học thú cưng"%>" 
                                 class="course-hero-image"
                                 style="
                                 border: 4px solid #FFA630;
                                 border-radius: 20px;
                                 box-shadow: 0 10px 20px rgba(255, 166, 48, 0.3);
                                 height: 300px;
                                 object-fit: cover;
                                 width: 100%;
                                 "
                                 onerror="this.onerror=null; this.src='<%= defaultImage%>'">
                        </div>
                    </div>
                </div>

            </div>
        </section>

        <!-- Course Content Section -->
        <section class="course-content-section">
            <div class="container">
                <div class="row">
                    <!-- Sidebar với danh sách bài học -->
                    <div class="col-lg-4">
                        <div class="course-sidebar">
                            <div class="sidebar-header">
                                <h4><i class="fa fa-list-ul mr-2"></i>Nội dung khóa học</h4>
                                <span class="badge badge-pill badge-primary">${modules.size()} chương</span>
                            </div>

                            <div class="modules-list">
                                <c:forEach items="${modules}" var="module">
                                    <div class="module-item">
                                        <div class="module-header" data-toggle="collapse" data-target="#module-${module.id}">
                                            <i class="fa fa-folder-open"></i>
                                            <span>${module.title}</span>
                                            <span class="badge badge-light ml-auto">
                                                ${fn:length(moduleLessonsMap[module.id])} bài
                                            </span>
                                        </div>

                                        <div class="lessons-list collapse show" id="module-${module.id}">
                                            <c:forEach items="${moduleLessonsMap[module.id]}" var="lesson">
                                                <c:set var="isActive" value="${currentLesson != null && currentLesson.id == lesson.id}"/>
                                                <a href="?id=${course.id}&lesson=${lesson.id}" 
                                                   class="lesson-item ${isActive ? 'active' : ''}">
                                                    <i class="fa ${not empty lesson.videoUrl ? 'fa-play-circle' : 'fa-file-text'}"></i>
                                                    <span>${lesson.title}</span>
                                                    <c:if test="${lesson.duration > 0}">
                                                        <span class="lesson-duration">${lesson.duration} phút</span>
                                                    </c:if>
                                                </a>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>

                        <!-- Phần researcher card giữ nguyên -->
                    </div>

                    <!-- Nội dung bài học -->
                    <div class="col-lg-8">
                        <c:choose>
                            <c:when test="${currentLesson != null}">
                                <div class="lesson-content">
                                    <h2 class="lesson-title">${currentLesson.title}</h2>

                                    <c:if test="${not empty currentLesson.videoUrl}">
                                        <div class="lesson-video embed-responsive embed-responsive-16by9 mb-4">
                                            <iframe class="embed-responsive-item" src="${currentLesson.videoUrl}" allowfullscreen></iframe>
                                        </div>
                                    </c:if>

                                    <div class="lesson-text">
                                        <c:choose>
                                            <c:when test="${not empty currentLesson.content}">
                                                <c:out value="${currentLesson.content}" escapeXml="false" />
                                            </c:when>
                                            <c:otherwise>
                                                <div class="alert alert-info">
                                                    Nội dung bài học đang được cập nhật. Vui lòng quay lại sau!
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <!-- Navigation buttons -->
                                    <%-- Lấy id của bài học hiện tại từ URL --%>
                                    <c:if test="${previousLesson != null}">
                                        <a href="coursedetail?id=${course.id}&lesson=${previousLesson.id}" class="btn btn-outline-primary">
                                            ← Bài trước
                                        </a>
                                    </c:if>

                                    <c:if test="${nextLesson != null}">
                                        <a href="coursedetail?id=${course.id}&lesson=${nextLesson.id}" class="btn btn-primary float-end">
                                            Bài tiếp theo →
                                        </a>
                                    </c:if>


                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-warning">
                                    Khóa học này chưa có nội dung chi tiết. Vui lòng quay lại sau!
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <!-- Discussion Section -->
                        <div class="discussion-section mt-5">
                            <h4><i class="fa fa-comments"></i> Thảo luận</h4>
                            <div class="discussion-form">
                                <textarea class="form-control" placeholder="Bạn có câu hỏi gì về bài học không?"></textarea>
                                <button class="btn btn-primary mt-2">Gửi câu hỏi</button>
                            </div>

                            <div class="discussion-list mt-3">
                                <div class="discussion-item">
                                    <div class="user-avatar">
                                        <img src="${pageContext.request.contextPath}/images/user-avatar.jpg" alt="User">
                                    </div>
                                    <div class="discussion-content">
                                        <div class="user-name">Nguyễn Văn A</div>
                                        <div class="discussion-text">Bài học rất hay và bổ ích. Cảm ơn giảng viên!</div>
                                        <div class="discussion-meta">
                                            <span class="text-muted">2 ngày trước</span>
                                            <a href="#" class="ml-3">Trả lời</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>




        <footer class="footer">
            <div class="container">
                <div class="row">
                    <div class="col-md-6 col-lg-3 mb-4 mb-md-0">
                        <h2 class="footer-heading">PetTech</h2>
                        <p>A small river named Duden flows by their place and supplies it with the necessary regelialia.</p>
                        <ul class="ftco-footer-social p-0">
                            <li class="ftco-animate"><a href="#" data-toggle="tooltip" data-placement="top" title="Twitter"><span class="fa fa-twitter"></span></a></li>
                            <li class="ftco-animate"><a href="#" data-toggle="tooltip" data-placement="top" title="Facebook"><span class="fa fa-facebook"></span></a></li>
                            <li class="ftco-animate"><a href="#" data-toggle="tooltip" data-placement="top" title="Instagram"><span class="fa fa-instagram"></span></a></li>
                        </ul>
                    </div>
                    <div class="col-md-6 col-lg-3 mb-4 mb-md-0">
                        <h2 class="footer-heading">Latest News</h2>
                        <div class="block-21 mb-4 d-flex">
                            <a class="img mr-4 rounded" style="background-image: url(${pageContext.request.contextPath}/images/image_1.jpg);"></a>
                            <div class="text">
                                <h3 class="heading"><a href="#">Even the all-powerful Pointing has no control about</a></h3>
                                <div class="meta">
                                    <div><a href="#"><span class="icon-calendar"></span> April 7, 2020</a></div>
                                    <div><a href="#"><span class="icon-person"></span> Admin</a></div>
                                    <div><a href="#"><span class="icon-chat"></span> 19</a></div>
                                </div>
                            </div>
                        </div>
                        <div class="block-21 mb-4 d-flex">
                            <a class="img mr-4 rounded" style="background-image: url(${pageContext.request.contextPath}/images/image_2.jpg);"></a>
                            <div class="text">
                                <h3 class="heading"><a href="#">Even the all-powerful Pointing has no control about</a></h3>
                                <div class="meta">
                                    <div><a href="#"><span class="icon-calendar"></span> April 7, 2020</a></div>
                                    <div><a href="#"><span class="icon-person"></span> Admin</a></div>
                                    <div><a href="#"><span class="icon-chat"></span> 19</a></div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-3 pl-lg-5 mb-4 mb-md-0">
                        <h2 class="footer-heading">Quick Links</h2>
                        <ul class="list-unstyled">
                            <li><a href="#" class="py-2 d-block">Home</a></li>
                            <li><a href="#" class="py-2 d-block">About</a></li>
                            <li><a href="#" class="py-2 d-block">Services</a></li>
                            <li><a href="#" class="py-2 d-block">Works</a></li>
                            <li><a href="#" class="py-2 d-block">Blog</a></li>
                            <li><a href="#" class="py-2 d-block">Contact</a></li>
                        </ul>
                    </div>
                    <div class="col-md-6 col-lg-3 mb-4 mb-md-0">
                        <h2 class="footer-heading">Have a Questions?</h2>
                        <div class="block-23 mb-3">
                            <ul>
                                <li><span class="icon fa fa-map"></span><span class="text">203 Fake St. Mountain View, San Francisco, California, USA</span></li>
                                <li><a href="#"><span class="icon fa fa-phone"></span><span class="text">+2 392 3929 210</span></a></li>
                                <li><a href="#"><span class="icon fa fa-paper-plane"></span><span class="text">info@yourdomain.com</span></a></li>
                            </ul>
                        </div>
                    </div>
                </div>
                <div class="row mt-5">
                    <div class="col-md-12 text-center">

                        <p class="copyright"><!-- Link back to Colorlib can't be removed. Template is licensed under CC BY 3.0. -->
                            Copyright &copy;<script>document.write(new Date().getFullYear());</script> All rights reserved | This template is made with <i class="fa fa-heart" aria-hidden="true"></i> by <a href="https://colorlib.com" target="_blank">Colorlib.com</a>
                            <!-- Link back to Colorlib can't be removed. Template is licensed under CC BY 3.0. --></p>
                    </div>
                </div>
            </div>
        </footer>

        <!-- loader -->
        <div id="ftco-loader" class="show fullscreen"><svg class="circular" width="48px" height="48px"><circle class="path-bg" cx="24" cy="24" r="22" fill="none" stroke-width="4" stroke="#eeeeee"/><circle class="path" cx="24" cy="24" r="22" fill="none" stroke-width="4" stroke-miterlimit="10" stroke="#F96D00"/></svg></div>



        <script>
            // Thêm hiệu ứng khi click vào module
            $(document).ready(function () {
                $('.module-header').click(function () {
                    $(this).find('i').toggleClass('fa-folder-open fa-folder');
                });
            });
            $(document).ready(function () {
                // Hiệu ứng loading khi click vào phân trang hoặc tìm kiếm
                $('.page-link, .search-form button').click(function () {
                    $('#ftco-loader').addClass('show');
                });
            });
        </script>



        <script src="${pageContext.request.contextPath}/js/jquery.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/jquery-migrate-3.0.1.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/popper.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/jquery.easing.1.3.js"></script>
        <script src="${pageContext.request.contextPath}/js/jquery.waypoints.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/jquery.stellar.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/jquery.animateNumber.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/bootstrap-datepicker.js"></script>
        <script src="${pageContext.request.contextPath}/js/jquery.timepicker.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/owl.carousel.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/jquery.magnific-popup.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/scrollax.min.js"></script>
        <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBVWaKrjvy3MaE7SQ74_uJiULgl1JY0H2s&sensor=false"></script>
        <script src="${pageContext.request.contextPath}/js/google-map.js"></script>
        <script src="${pageContext.request.contextPath}/js/main.js"></script>

    </body>
</html>