<%-- 
    Document   : Home
    Created on : May 21, 2025, 10:39:14 PM
    Author     : FPT
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@page import="model.User" %>

<%@page import="model.Course" %>
<%@page import="model.Course" %>
<%@page import="model.CourseModule" %>
<%@page import="model.CourseLesson" %>
<%@page import="dal.CourseDAO" %>
<%@page import="java.util.List" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Date" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <title>PetTech</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

        <link href="https://fonts.googleapis.com/css?family=Montserrat:200,300,400,500,600,700,800&display=swap" rel="stylesheet">

        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

        <link rel="stylesheet" href="css/animate.css">

        <link rel="stylesheet" href="css/owl.carousel.min.css">
        <link rel="stylesheet" href="css/owl.theme.default.min.css">
        <link rel="stylesheet" href="css/magnific-popup.css">

        <link rel="stylesheet" href="css/bootstrap-datepicker.css">
        <link rel="stylesheet" href="css/jquery.timepicker.css">

        <link rel="stylesheet" href="css/flaticon.css">
        <link rel="stylesheet" href="css/style.css">


        <link href="https://fonts.googleapis.com/css2?family=Comic+Neue:wght@400;700&family=Poppins:wght@400;600&display=swap" rel="stylesheet">


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

            /* css profile */

            body {
                font-family: 'Poppins', sans-serif;
            }

            .login-link.dropdown-toggle {
                font-weight: 600;
                font-size: 1.05rem;
                color: #4a2c82;
                padding: 6px 12px;
                border-radius: 30px;
                transition: background 0.3s ease;
                background-color: transparent;
            }

            .login-link.dropdown-toggle:hover {
                background-color: #f5f0ff;
                color: #6d4aff;
            }

            /* Dropdown đẹp nhẹ nhàng */
            .dropdown-menu {
                min-width: 220px;
                background-color: #fef6fb;
                border: 1px solid #ecd9f9;
                border-radius: 16px;
                box-shadow: 0 4px 16px rgba(0, 0, 0, 0.08);
                padding: 0;
                animation: fadeDown 0.25s ease;
            }

            /* Menu item */
            .dropdown-item {
                padding: 10px 16px;
                font-size: 0.95rem;
                font-weight: 500;
                color: #5a3e85;
                display: flex;
                align-items: center;
                transition: all 0.2s ease;
                background-color: transparent;
            }

            .dropdown-item i {
                width: 20px;
                margin-right: 10px;
                color: #6d4aff;
            }

            .dropdown-item:hover {
                background-color: #f3edff;
                color: #6d4aff;
                padding-left: 22px;
            }

            .dropdown-divider {
                border-color: #eee;
            }

            .dropdown-item.text-danger {
                color: #d9534f;
            }

            .dropdown-item.text-danger:hover {
                background-color: #fff5f5;
                color: #c9302c;
            }

            @keyframes fadeDown {
                from {
                    opacity: 0;
                    transform: translateY(-10px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
            /* Style cho input search */
            .search-form .form-control {
                border-radius: 50px 0 0 50px;
                border: 1px solid #FFD6A0;
                padding: 10px 20px;
                font-size: 1rem;
                box-shadow: none;
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
                color: #8B5E3C;
                font-weight: 700;
                display: inline-block;
                background: linear-gradient(90deg, #8B5E3C, #D99863);
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
                background: #C46C3B;
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
                color: #8B5E3C;
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
                background: linear-gradient(90deg, #8B5E3C 0%, #D99863 100%);
                border: none;
                border-radius: 50px;
                padding: 10px 25px;
                color: white;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 1px;
                font-size: 0.8rem;
                transition: all 0.3s ease;
                align-self: flex-start;
            }

            .course-btn:hover {
                transform: translateY(-3px);
                box-shadow: 0 5px 15px rgba(109, 74, 255, 0.4);
                color: white;
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

            /* Hero Section */
            .hero-wrap {
                position: relative;
                height: 100vh;
                min-height: 600px;
                background-size: cover;
                background-position: center;
                display: flex;
                align-items: center;
            }

            .hero-wrap .overlay {
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: rgba(0, 0, 0, 0.4);
            }

            .hero-wrap .container {
                position: relative;
                z-index: 1;
            }

            .hero-wrap h1 {
                font-size: 3.5rem;
                font-weight: 700;
                color: white;
                margin-bottom: 20px;
                text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
            }

            .hero-wrap p {
                font-size: 1.5rem;
                color: white;
                margin-bottom: 20px;
                text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.3);
            }

            /* Features Section - Updated */
            .features-section {
                padding: 80px 0;
                background-color: #f8f9fa;
            }

            .section-title {
                text-align: center;
                margin-bottom: 60px;
            }

            .section-title h2 {
                font-size: 2.5rem;
                color: #8B5E3C;
                position: relative;
                display: inline-block;
                padding-bottom: 15px;
            }

            .section-title h2:after {
                content: "";
                position: absolute;
                bottom: 0;
                left: 50%;
                transform: translateX(-50%);
                width: 80px;
                height: 3px;
            }
            .section-title p {
                color: #666;
                font-size: 1.1rem;
                margin-top: 15px;
            }

            .feature-card {
                background: white;
                border-radius: 15px;
                padding: 30px;
                text-align: center;
                box-shadow: 0 10px 30px rgba(0,0,0,0.05);
                transition: all 0.3s ease;
                height: 100%;
                margin-bottom: 30px;
                border: 1px solid rgba(109, 74, 255, 0.1);
            }

            .feature-card:hover {
                transform: translateY(-10px);
                box-shadow: 0 15px 35px rgba(0,0,0,0.1);
                border-color: rgba(109, 74, 255, 0.3);
            }

            .feature-icon {
                width: 90px;
                height: 90px;
                margin: 0 auto 25px;
                background: linear-gradient(90deg, #8B5E3C 0%, #D99863 100%);
                box-shadow: 0 10px 20px rgba(139, 94, 60, 0.2);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-size: 36px;
                box-shadow: 0 10px 20px rgba(109, 74, 255, 0.2);
            }

            .feature-card h3 {
                font-size: 1.4rem;
                color: #3a3a3a;
                margin-bottom: 15px;
                font-weight: 600;
            }

            .feature-card p {
                color: #666;
                margin-bottom: 20px;
            }
            /* Nút chính: Khám phá ngay, Đăng ký ngay */
            .btn.btn-primary {
                background: linear-gradient(90deg, #8B5E3C, #D99863) !important;
                color: white !important;
                border: none !important;
                font-weight: 600;
                transition: all 0.3s ease;
            }

            .btn.btn-primary:hover {
                background: linear-gradient(90deg, #7A4C2D, #CB8A55) !important;
                box-shadow: 0 5px 15px rgba(139, 94, 60, 0.3);
                color: white !important;
            }

            /* Nút outline (nếu có) ví dụ: Xem tất cả khóa học */
            .btn.btn-outline-primary {
                border-color: #8B5E3C !important;
                color: #8B5E3C !important;
            }

            .btn.btn-outline-primary:hover {
                background: #8B5E3C !important;
                color: white !important;
            }
            .feature-link {
                display: inline-flex;
                align-items: center;
                color: #8B5E3C;
                font-weight: 600;
                text-decoration: none;
                transition: all 0.3s ease;
            }

            .feature-link i {
                margin-left: 5px;
                transition: all 0.3s ease;
            }

            .feature-link:hover {
                color: #D99863;
            }

            .feature-link:hover i {
                transform: translateX(5px);
            }
            /* Testimonials */
            .testimonial-card {
                border: none;
                border-radius: 10px;
                padding: 30px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.05);
                height: 100%;
                transition: all 0.3s ease;
            }

            .testimonial-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            }

            .testimonial-img {
                width: 80px;
                height: 80px;
                border-radius: 50%;
                object-fit: cover;
                margin-bottom: 15px;
                border: 3px solid #8B5E3C;
            }

            /* Newsletter */
            .newsletter-section {
                background-color: #f8f9fa;
                padding: 60px 0;
                border-top: 1px solid #dee2e6;
                border-bottom: 1px solid #dee2e6;
            }

            .newsletter-section h2 {
                font-size: 2rem;
                color: #3a3a3a;
                margin-bottom: 15px;
            }

            .newsletter-section p {
                color: #666;
                margin-bottom: 30px;
            }

            .newsletter-section .form-control {
                height: 50px;
                border-radius: 50px;
                padding: 0 20px;
                border: 1px solid #ddd;
            }

            .newsletter-section .btn {
                height: 50px;
                border-radius: 50px;
                padding: 0 30px;
                background: #8B5E3C;
                color: white;
                font-weight: 600;
                border: none;
            }

            .newsletter-section .btn:hover {
                background: #5a3ae6;
            }
            /* Mặc định: màu nâu cam */
            .ftco-footer-social a span {
                color: #8B5E3C !important;
                font-size: 1.2rem;
                transition: color 0.3s ease, transform 0.3s ease;
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
                        <li class="nav-item"><a href="expert" class="nav-link">Chuyên gia</a></li>
                        <li class="nav-item"><a href="product" class="nav-link">Sản phẩm</a></li>
                        <li class="nav-item"><a href="pet" class="nav-link">Thú cưng</a></li>
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


        <!-- Hero Section -->
        <div class="hero-wrap js-fullheight" style="background-image: url('images/10b.jpg');" data-stellar-background-ratio="0.5">
            <div class="overlay"></div>
            <div class="container">
                <div class="row no-gutters slider-text js-fullheight align-items-center justify-content-center" data-scrollax-parent="true">
                    <div class="col-md-11 ftco-animate text-center">
                        <h1 class="mb-4">Chăm sóc thú cưng một cách chuyên nghiệp</h1>
                        <p class="mb-4">PetTech mang đến giải pháp toàn diện cho người yêu thú cưng</p>
                        <p>
                            <a href="course" class="btn btn-primary mr-md-4 py-3 px-4">Khám phá ngay</a>
                            <a href="package" class="btn btn-white py-3 px-4">Gói dịch vụ</a>
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Features Section - Updated HTML -->
        <section class="features-section">
            <div class="container">
                <div class="course-header">
                    <h2>Tại sao chọn PetTech?</h2>
                    <p>Chúng tôi mang đến giải pháp toàn diện cho việc chăm sóc thú cưng của bạn</p>
                </div>

                <div class="row">
                    <div class="col-lg-4 col-md-6">
                        <div class="feature-card">
                            <div class="feature-icon">
                                <i class="fas fa-graduation-cap"></i>
                            </div>
                            <h3>Khóa học chất lượng</h3>
                            <p>Học từ các chuyên gia hàng đầu về chăm sóc thú cưng với phương pháp hiện đại, dễ hiểu.</p>
                            <a href="course" class="feature-link">
                                Xem thêm <i class="fas fa-arrow-right"></i>
                            </a>
                        </div>
                    </div>

                    <div class="col-lg-4 col-md-6">
                        <div class="feature-card">
                            <div class="feature-icon">
                                <i class="fas fa-shopping-bag"></i>
                            </div>
                            <h3>Sản phẩm chính hãng</h3>
                            <p>Cung cấp các sản phẩm chăm sóc thú cưng chất lượng từ các thương hiệu uy tín.</p>
                            <a href="products" class="feature-link">
                                Xem thêm <i class="fas fa-arrow-right"></i>
                            </a>
                        </div>
                    </div>

                    <div class="col-lg-4 col-md-6">
                        <div class="feature-card">
                            <div class="feature-icon">
                                <i class="fas fa-headset"></i>
                            </div>
                            <h3>Hỗ trợ 24/7</h3>
                            <p>Đội ngũ chuyên gia luôn sẵn sàng tư vấn và giải đáp mọi thắc mắc của bạn.</p>
                            <a href="contact" class="feature-link">
                                Xem thêm <i class="fas fa-arrow-right"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Featured Courses -->
        <section class="course-section">
            <div class="container">
                <div class="course-header">
                    <h2>Khóa học nổi bật</h2>
                    <p>Các khóa học được yêu thích nhất tại PetTech</p>
                </div>

                <div class="row">
                    <c:forEach var="course" items="${featuredCourses}">
                        <div class="col-lg-4 col-md-6 mb-4">
                            <div class="course-card">
                                <div class="course-img-container">
                                    <c:choose>
                                        <c:when test="${not empty course.imageUrl}">
                                            <img src="${pageContext.request.contextPath}${course.imageUrl}" 
                                                 alt="${course.title}" 
                                                 class="course-img"
                                                 onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/images/corgin-1.jpg'">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/images/corgin-1.jpg" 
                                                 alt="${course.title}" 
                                                 class="course-img">
                                        </c:otherwise>
                                    </c:choose>
                                    <span class="course-badge">Mới</span>
                                </div>
                                <div class="course-body">
                                    <h3 class="course-title">${course.title}</h3>
                                    <div class="course-meta">
                                        <i class="fa fa-clock-o"></i> ${not empty course.time ? course.time : 'Đang cập nhật'}
                                    </div>
                                    <c:if test="${not empty course.researcher}">
                                        <div class="course-meta">
                                            <i class="fa fa-user"></i> ${course.researcher}
                                        </div>
                                    </c:if>
                                    <p class="course-desc">
                                        <c:choose>
                                            <c:when test="${not empty course.content && fn:length(course.content) > 100}">
                                                ${fn:substring(course.content, 0, 100)}...
                                            </c:when>
                                            <c:when test="${not empty course.content}">
                                                ${course.content}
                                            </c:when>
                                            <c:otherwise>
                                                Nội dung đang được cập nhật...
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                    <a href="${pageContext.request.contextPath}/coursedetail?id=${course.id}" class="course-btn">
                                        Xem chi tiết <i class="fa fa-arrow-right"></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
                <div class="row mt-4">
                    <div class="col text-center">
                        <a href="course" class="btn btn-outline-primary px-4 py-2">Xem tất cả khóa học</a>
                    </div>
                </div>
            </div>
        </section>


        <!-- Testimonials -->
        <section class="ftco-section bg-light">
            <div class="container">
                <div class="row justify-content-center pb-5 mb-3">
                    <div class="col-md-7 heading-section text-center ftco-animate">
                        <div class="course-header">
                            <h2>Học viên nói gì về chúng tôi</h2>
                            <p>Những phản hồi từ học viên đã tham gia các khóa học tại PetTech</p>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-4 ftco-animate">
                        <div class="testimonial-card text-center">
                            <img src="images/staff-5.jpg" class="testimonial-img" alt="Nguyen Van B">
                            <h5>Nguyen Van B</h5>
                            <div class="text-warning mb-3">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                            </div>
                            <p>"Khóa học chăm sóc chó con rất hữu ích, giúp mình tự tin hơn khi nuôi bé Cún nhà mình."</p>
                        </div>
                    </div>
                    <div class="col-md-4 ftco-animate">
                        <div class="testimonial-card text-center">
                            <img src="images/staff-7.jpg" class="testimonial-img" alt="Ngoc A">
                            <h5>Ngoc A</h5>
                            <div class="text-warning mb-3">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star-half-alt"></i>
                            </div>
                            <p>"Nội dung bài giảng dễ hiểu, hình ảnh minh họa sinh động. Mình đã áp dụng thành công cho bé Mèo nhà mình."</p>
                        </div>
                    </div>
                    <div class="col-md-4 ftco-animate">
                        <div class="testimonial-card text-center">
                            <img src="images/staff-8.jpg" class="testimonial-img" alt="Minh C">
                            <h5>Minh C</h5>
                            <div class="text-warning mb-3">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                            </div>
                            <p>"Giảng viên nhiệt tình, luôn sẵn sàng giải đáp thắc mắc. Mình sẽ đăng ký thêm các khóa học khác."</p>
                        </div>
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


        <script>
            $(document).ready(function () {
                $('#userDropdown').on('click', function (e) {
                    e.preventDefault();
                    console.log("Click ok");
                });
            });
        </script>


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

        <script>
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
        </script>
    </body>
</html>
