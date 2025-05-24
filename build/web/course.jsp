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
                        <a href="#" class="login-link d-flex align-items-center mr-3">
                            <i class="fa fa-sign-in mr-2"></i>
                            <span>Đăng Nhập</span>
                        </a>
                        <a href="#" class="login-link d-flex align-items-center">
                            <i class="fa fa-user-plus mr-2"></i>
                            <span>Đăng Ký</span>
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <nav class="navbar navbar-expand-lg navbar-dark ftco_navbar bg-dark ftco-navbar-light" id="ftco-navbar">
            <div class="container">
                <a class="navbar-brand" href="index.html"><span class="flaticon-pawprint-1 mr-2"></span>PetTech</a>
                <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#ftco-nav" aria-controls="ftco-nav" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="fa fa-bars"></span> Menu
                </button>
                <div class="collapse navbar-collapse" id="ftco-nav">
                    <ul class="navbar-nav ml-auto">
                        <li class="nav-item active"><a href="Home.jsp" class="nav-link">Trang chủ</a></li>

                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="course" id="coursesDropdown" role="button" 
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
                        <li class="nav-item"><a href="pricing.jsp" class="nav-link">Gói dịch vụ</a></li>
                        <li class="nav-item"><a href="blog.jsp" class="nav-link">Tin tức</a></li>
                        <li class="nav-item"><a href="contact.jsp" class="nav-link">Liên hệ</a></li>
                    </ul>
                </div>
            </div>
        </nav>



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

                                <img src="<%= finalImagePath %>" 
                                     alt="<%= course.getTitle() %>" 
                                     class="course-img"
                                     onerror="this.onerror=null; this.src='<%= defaultImage %>'">




                            </div>
                            <div class="course-body">
                                <h3 class="course-title"><%= course.getTitle() %></h3>

                                <div class="course-meta">
                                    <i class="fa fa-clock-o"></i> <%= course.getTime() != null ? course.getTime() : "Đang cập nhật" %>
                                </div>

                                <% if (course.getResearcher() != null && !course.getResearcher().isEmpty()) { %>
                                <div class="course-meta">
                                    <i class="fa fa-user"></i> <%= course.getResearcher() %>
                                </div>
                                <% } %>

                                <p class="course-desc">
                                    <% if (course.getContent() != null) { 
                                        if (course.getContent().length() > 100) { %>
                                    <%= course.getContent().substring(0, 100) %>...
                                    <% } else { %>
                                    <%= course.getContent() %>
                                    <% } 
                                    } else { %>
                                    Nội dung đang được cập nhật...
                                    <% } %>
                                </p>

                                <div class="course-meta">
                                    <i class="fa fa-calendar"></i> <%= course.getTime() != null ? course.getTime() : "" %>
                                </div>

                                <a href="${pageContext.request.contextPath}/coursedetail?id=<%= course.getId() %>" class="course-btn">
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
                    <% } %>
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



        <footer class="footer">
            <div class="container">
                <div class="row">
                    <div class="col-md-6 col-lg-3 mb-4 mb-md-0">
                        <h2 class="footer-heading">Petsitting</h2>
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
                            <a class="img mr-4 rounded" style="background-image: url(images/image_1.jpg);"></a>
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
                            <a class="img mr-4 rounded" style="background-image: url(images/image_2.jpg);"></a>
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