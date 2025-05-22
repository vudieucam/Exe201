<%-- 
    Document   : course_detail
    Created on : May 23, 2025, 3:08:05 AM
    Author     : FPT
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.Course" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>

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
        <% if (errorMessage != null) { %>
        <div class="alert alert-danger" style="padding: 15px; background: #ffebee; color: #c62828; margin: 15px;">
            <%= errorMessage %>
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
        <title><%= course.getTitle() != null ? course.getTitle() : "Chi tiết khóa học" %> | PetTech</title>
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
                    <div class="col-md-6 d-flex justify-content-md-end">
                        <a href="#" class="d-flex align-items-center justify-content-center"><span>Đăng Nhập</span></a>
                        <a href="#" class="d-flex align-items-center justify-content-center"><span>Đăng Ký</span></a>
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
                        <li class="nav-item"><a href="course" class="nav-link">Khóa học</a></li>
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

        <!-- Course Header Section -->
        <section class="course-detail-header">
            <div class="container">
                <div class="row align-items-center">
                    <div class="col-lg-7">
                        <h1 class="course-title"><%= course.getTitle() != null ? course.getTitle() : "Khóa học chăm sóc thú cưng" %></h1>
                        
                        <div class="course-meta">
                            <% if (course.getResearcher() != null && !course.getResearcher().isEmpty()) { %>
                            <div class="meta-item">
                                <i class="fa fa-user"></i>
                                <span>Giảng viên: <%= course.getResearcher() %></span>
                            </div>
                            <% } %>
                            
                            <div class="meta-item">
                                <i class="fa fa-calendar"></i>
                                <span>Ngày đăng: <%= formattedDate %></span>
                            </div>
                            
                            <% if (course.getTime() != null && !course.getTime().isEmpty()) { %>
                            <div class="meta-item">
                                <i class="fa fa-clock-o"></i>
                                <span>Thời lượng: <%= course.getTime() %></span>
                            </div>
                            <% } %>
                        </div>
                    </div>
                    
                    <div class="col-lg-5">
                        <img src="<%= finalImagePath %>" 
                             alt="<%= course.getTitle() != null ? course.getTitle() : "Khóa học thú cưng" %>" 
                             class="course-hero-image"
                             onerror="this.onerror=null; this.src='<%= defaultImage %>'">
                    </div>
                </div>
            </div>
        </section>

        <!-- Course Content Section -->
        <section class="course-content-section">
            <div class="container">
                <div class="row">
                    <div class="col-lg-8">
                        <h2 class="section-title">Nội dung khóa học</h2>
                        
                        <div class="course-content">
                            <% if (course.getContent() != null && !course.getContent().isEmpty()) { %>
                                <%= course.getContent().replace("\n", "<br>") %>
                            <% } else { %>
                                <div class="alert alert-info">
                                    Nội dung khóa học đang được cập nhật. Vui lòng quay lại sau!
                                </div>
                            <% } %>
                        </div>
                        
                        <div class="action-buttons">
                            <a href="enroll?courseId=<%= course.getId() %>" class="btn-enroll">
                                <i class="fa fa-paw"></i> Đăng ký ngay
                            </a>
                            
                            <a href="${pageContext.request.contextPath}/course" class="btn-back">
                                <i class="fa fa-arrow-left"></i> Quay lại danh sách
                            </a>
                        </div>
                    </div>
                    
                    <div class="col-lg-4">
                        <% if (course.getResearcher() != null && !course.getResearcher().isEmpty()) { %>
                        <div class="researcher-card">
                            <div class="researcher-header">
                                <img src="${pageContext.request.contextPath}/images/vet-avatar.jpg" 
                                     alt="<%= course.getResearcher() %>" 
                                     class="researcher-avatar"
                                     onerror="this.src='${pageContext.request.contextPath}/images/default-avatar.jpg'">
                                <div>
                                    <h3 class="researcher-name"><%= course.getResearcher() %></h3>
                                    <p class="researcher-title">Chuyên gia thú y</p>
                                </div>
                            </div>
                            
                            <p>Với nhiều năm kinh nghiệm trong lĩnh vực thú y và huấn luyện thú cưng, <%= course.getResearcher().split(" ")[0] %> sẽ mang đến cho bạn những kiến thức hữu ích nhất.</p>
                        </div>
                        <% } %>
                        
                        <!-- Phần thông tin khóa học phụ -->
                        <div class="card mt-4">
                            <div class="card-body">
                                <h5 class="card-title">
                                    <i class="fa fa-info-circle mr-2"></i> Thông tin khác
                                </h5>
                                
                                <ul class="list-group list-group-flush">
                                    <% if (course.getTime() != null && !course.getTime().isEmpty()) { %>
                                    <li class="list-group-item d-flex justify-content-between align-items-center">
                                        Thời lượng
                                        <span class="badge badge-primary"><%= course.getTime() %></span>
                                    </li>
                                    <% } %>
                                    
                                    <li class="list-group-item d-flex justify-content-between align-items-center">
                                        Mã khóa học
                                        <span>#<%= course.getId() %></span>
                                    </li>
                                </ul>
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