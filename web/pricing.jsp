<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <title>Đăng Ký Gói Dịch Vụ - PetTech</title>
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
                        <c:choose>
                            <c:when test="${not empty sessionScope.user}">
                                <!-- Hiển thị tên và avatar -->
                                <div class="dropdown">
                                    <a class="login-link dropdown-toggle d-flex align-items-center" href="#" role="button"
                                       id="userDropdown" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                        <i class="fa fa-user-circle mr-2" style="font-size: 1.4rem; color: #6d4aff;"></i>
                                        <span style="font-weight: 600;">${sessionScope.user.fullname}</span>
                                    </a>
                                    <div class="dropdown-menu dropdown-menu-right" aria-labelledby="userDropdown">
                                        <a class="dropdown-item" href="authen?action=editprofile"><i class="fa fa-id-card mr-2"></i> Thông tin cá nhân</a>
                                        <a class="dropdown-item" href="mycourses.jsp"><i class="fa fa-book mr-2"></i> Khóa học</a>
                                        <a class="dropdown-item" href="orders.jsp"><i class="fa fa-shopping-bag mr-2"></i> Đơn hàng</a>
                                        <a class="dropdown-item" href="package.jsp"><i class="fa fa-box-open mr-2"></i> Gói dịch vụ</a>
                                        <div class="dropdown-divider"></div>
                                        <a class="dropdown-item text-danger" href="authen?action=logout"><i class="fa fa-sign-out mr-2"></i> Đăng xuất</a>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <!-- Nếu chưa đăng nhập, hiển thị nút đăng nhập/đăng ký -->
                                <a href="authen?action=login" class="login-link d-flex align-items-center mr-3">
                                    <i class="fa fa-sign-in mr-2"></i>
                                    <span>Đăng Nhập</span>
                                </a>
                                <a href="authen?action=signup" class="login-link d-flex align-items-center">
                                    <i class="fa fa-user-plus mr-2"></i>
                                    <span>Đăng Ký</span>
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>

        <nav class="navbar navbar-expand-lg navbar-dark ftco_navbar bg-dark ftco-navbar-light" id="ftco-navbar">
            <div class="container">
                <a class="navbar-brand" href="home"><span class="flaticon-pawprint-1 mr-2"></span>PetTech</a>
                <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#ftco-nav" aria-controls="ftco-nav" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="fa fa-bars"></span> Menu
                </button>
                <div class="collapse navbar-collapse" id="ftco-nav">
                    <ul class="navbar-nav ml-auto">
                        <li class="nav-item"><a href="home" class="nav-link">Trang chủ</a></li>
                        <li class="nav-item active"><a href="course.jsp" class="nav-link">Khóa học</a></li>
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
                        <p>Vui lòng <a href="authen?action=login">đăng nhập</a> nếu bạn đã có tài khoản, hoặc <a href="signup.jsp">đăng ký</a> tài khoản mới để đăng ký gói dịch vụ.</p>
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
                                         <c:if test="${pkg.id == currentPackageId}">current</c:if>
                                         <c:if test="${currentPackageId != null && pkg.id < currentPackageId}">registered</c:if>">

                                             <div class="package-header">
                                                 <h3>${pkg.name}</h3>
                                         </div>

                                         <div class="text-center p-4">
                                             <div class="package-price mb-3">
                                                 <c:choose>
                                                     <c:when test="${pkg.price == 0}">
                                                         <span class="display-4">0₫</span>
                                                     </c:when>
                                                     <c:otherwise>
                                                         <span class="display-4">${pkg.price}₫</span>
                                                         <small class="text-muted">Trọn đời</small>
                                                     </c:otherwise>
                                                 </c:choose>
                                             </div>

                                             <ul class="package-features list-unstyled mb-4">
                                                 <li class="mb-2"><i class="fas fa-paw mr-2"></i>${pkg.description}</li>
                                             </ul>

                                             <div class="package-actions">
                                                 <c:choose>
                                                     <c:when test="${sessionScope.user == null}">
                                                         <a href="authen?action=signup" class="btn btn-package btn-block py-3">
                                                             <i class="fas fa-user-plus mr-2"></i>Đăng ký tài khoản
                                                         </a>
                                                     </c:when>
                                                     <c:otherwise>
                                                         <c:choose>
                                                             <c:when test="${pkg.id == currentPackageId}">
                                                                 <a href="package?action=upgrade&packageId=${pkg.id}" class="btn btn-package btn-block py-3">
                                                                     <i class="fas fa-arrow-up mr-2"></i>Đăng ký ngay
                                                                 </a>
                                                             </c:when>
                                                             <c:when test="${currentPackageId != null && pkg.id < currentPackageId}">
                                                                 <a href="package?action=upgrade&packageId=${pkg.id}" class="btn btn-package btn-block py-3">
                                                                     <i class="fas fa-arrow-up mr-2"></i>Đăng ký ngay
                                                                 </a>
                                                             </c:when>
                                                             
                                                             <c:when test="${currentPackageId != null && pkg.id > currentPackageId}">
                                                                 <a href="package?action=upgrade&packageId=${pkg.id}" class="btn btn-package btn-block py-3">
                                                                     <i class="fas fa-arrow-up mr-2"></i>Đăng ký ngay
                                                                 </a>
                                                             </c:when>
                                                             <c:otherwise>
                                                                 <form action="package" method="post" class="mb-0">
                                                                     <input type="hidden" name="action" value="register">
                                                                     <input type="hidden" name="packageId" value="${pkg.id}">
                                                                     <a href="package?action=upgrade&packageId=${pkg.id}" class="btn btn-package btn-block py-3">
                                                                     <i class="fas fa-arrow-up mr-2"></i> Đăng ký ngay
                                                                 </a>
                                                                 </form>
                                                             </c:otherwise>
                                                         </c:choose>
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

        <footer class="footer">
            <div class="container">
                <div class="row">
                    <div class="col-md-6 col-lg-3 mb-4 mb-md-0">
                        <h2 class="footer-heading">PetTech</h2>
                        <p>Chúng tôi mang đến giải pháp toàn diện cho thú cưng của bạn.</p>
                        <ul class="ftco-footer-social p-0">
                            <li class="ftco-animate"><a href="#" data-toggle="tooltip" data-placement="top" title="Twitter"><span class="fa fa-twitter"></span></a></li>
                            <li class="ftco-animate"><a href="#" data-toggle="tooltip" data-placement="top" title="Facebook"><span class="fa fa-facebook"></span></a></li>
                            <li class="ftco-animate"><a href="#" data-toggle="tooltip" data-placement="top" title="Instagram"><span class="fa fa-instagram"></span></a></li>
                        </ul>
                    </div>
                    <div class="col-md-6 col-lg-3 mb-4 mb-md-0">
                        <h2 class="footer-heading">Tin tức mới nhất</h2>
                        <div class="block-21 mb-4 d-flex">
                            <a class="img mr-4 rounded" style="background-image: url(images/image_1.jpg);"></a>
                            <div class="text">
                                <h3 class="heading"><a href="#">Cách chăm sóc thú cưng mùa hè</a></h3>
                                <div class="meta">
                                    <div><a href="#"><span class="icon-calendar"></span> 21/05/2025</a></div>
                                </div>
                            </div>
                        </div>
                        <div class="block-21 mb-4 d-flex">
                            <a class="img mr-4 rounded" style="background-image: url(images/image_2.jpg);"></a>
                            <div class="text">
                                <h3 class="heading"><a href="#">Khóa học huấn luyện thú cưng mới</a></h3>
                                <div class="meta">
                                    <div><a href="#"><span class="icon-calendar"></span> 15/05/2025</a></div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-3 pl-lg-5 mb-4 mb-md-0">
                        <h2 class="footer-heading">Liên kết nhanh</h2>
                        <ul class="list-unstyled">
                            <li><a href="Home.jsp" class="py-2 d-block">Trang chủ</a></li>
                            <li><a href="course.jsp" class="py-2 d-block">Khóa học</a></li>
                            <li><a href="vet.jsp" class="py-2 d-block">Chuyên gia</a></li>
                            <li><a href="service.jsp" class="py-2 d-block">Sản phẩm</a></li>
                            <li><a href="contact.jsp" class="py-2 d-block">Liên hệ</a></li>
                        </ul>
                    </div>
                    <div class="col-md-6 col-lg-3 mb-4 mb-md-0">
                        <h2 class="footer-heading">Câu hỏi?</h2>
                        <div class="block-23 mb-3">
                            <ul>
                                <li><span class="icon fa fa-map"></span><span class="text">Số 1, Đại Cồ Việt, Hà Nội</span></li>
                                <li><a href="#"><span class="icon fa fa-phone"></span><span class="text">+84 352 138 596</span></a></li>
                                <li><a href="#"><span class="icon fa fa-paper-plane"></span><span class="text">info@pettech.com</span></a></li>
                            </ul>
                        </div>
                    </div>
                </div>
                <div class="row mt-5">
                    <div class="col-md-12 text-center">
                        <p class="copyright">
                            Copyright &copy;<script>document.write(new Date().getFullYear());</script> All rights reserved | PetTech <i class="fa fa-heart" aria-hidden="true"></i>
                        </p>
                    </div>
                </div>
            </div>
        </footer>

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
        <script src="js/main.js"></script>
    </body>
</html>