<%-- 
    Document   : contact
    Created on : May 21, 2025, 11:33:34 PM
    Author     : FPT
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">

    <head>
        <!-- Google tag (gtag.js) -->
        <script async src="https://www.googletagmanager.com/gtag/js?id=G-3BE5RLS31D"></script>
        <script>
            window.dataLayer = window.dataLayer || [];
            function gtag() {
                dataLayer.push(arguments);
            }
            gtag('js', new Date());

            gtag('config', 'G-3BE5RLS31D');
        </script>
        <title>Liên hệ - PetTech</title>
        <link rel="icon" type="image/png" href="images/logo_pettech.jpg">
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

        <link href="https://fonts.googleapis.com/css2?family=Baloo+2:wght@600&family=Quicksand:wght@400;500&display=swap" rel="stylesheet">

        <link href="https://fonts.googleapis.com/css?family=Montserrat:200,300,400,500,600,700,800&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
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
            body {
                font-family: 'Poppins', 'Montserrat', sans-serif;
                background-color: #FFF9F4;
                color: #4E342E;
                font-size: 16px;
                line-height: 1.6;
            }
            /* Màu nâu cam cho thương hiệu PetTech */
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
            .hero-wrap .overlay {
                background: rgba(139, 94, 60, 0.5);
            }
            h1 {
                font-size: 2.2rem;
            }
            h2, h3, h4 {
                color: #8B5E3C;
                font-weight: 700;
            }
            h2.section-title::after {
                content: " 🐾";
            }
            .about-section, .team-section, .contact-info-section, .contact-form-section {
                padding: 80px 0;
                background-color: #FFF9F0;
            }
            .about-section .container, .team-section .container, .contact-info-section .container {
                max-width: 1000px;
            }
            .btn-send {
                background: linear-gradient(90deg, #8B5E3C, #D99863);
                color: white;
                padding: 10px 24px;
                border-radius: 40px;
                font-weight: 600;
                font-size: 15px;
                transition: all 0.3s ease;
            }
            .btn-send:hover {
                transform: scale(1.03);
                box-shadow: 0 5px 15px rgba(139, 94, 60, 0.3);
            }
            .team-card, .contact-info-card, .contact-form {
                background: #FFF5EC;
                border-radius: 30px;
                box-shadow: 0 10px 30px rgba(139, 94, 60, 0.1);
                transition: 0.3s;
                border: 1px solid rgba(139, 94, 60, 0.1);
                font-size: 15px;
                padding: 25px 20px;
                text-align: center;
            }
            .team-card:hover, .contact-info-card:hover {
                transform: translateY(-5px) scale(1.03);
                box-shadow: 0 12px 35px rgba(139, 94, 60, 0.15);
            }
            .team-img {
                width: 120px;
                height: 120px;
                border-radius: 50%;
                object-fit: cover;
                margin: 0 auto 15px;
                border: 5px solid #FFE6D4;
            }
            .contact-icon {
                font-size: 2rem;
                color: #D99863;
                margin-bottom: 20px;
            }
            .form-control {
                font-size: 15px;
                border-radius: 12px;
                border: 1px solid #E0CFC2;
                padding: 10px 12px;
                margin-bottom: 20px;
            }
            a:hover {
                color: #D99863;
            }

            .text-muted {
                color: #A97457 !important;
            }
            body {
                font-family: 'Quicksand', sans-serif;
                color: #333;
                line-height: 1.7;
                background-color: #fffefc;
            }

            h1, h2, h3, h4, h5, h6 {
                font-family: 'Baloo 2', cursive;
                color: #FF8C42;
                font-weight: 600;
            }

            h2 {
                font-size: 36px;
                margin-bottom: 20px;
                animation: fadeInDown 1s ease-in-out;
            }

            h3 {
                font-size: 24px;
                margin-top: 30px;
            }

            h5 {
                font-size: 20px;
                margin-top: 20px;
                color: #FFB86F;
            }

            p {
                font-size: 16px;
                margin-bottom: 15px;
            }

            /* Animation */
            @keyframes fadeInDown {
                from {
                    opacity: 0;
                    transform: translateY(-20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            /* General Reset */
            body {
                font-family: 'Quicksand', sans-serif;
                background-color: #fffdf9;
                color: #333;
                line-height: 1.7;
            }

            /* Section Header */
            .section-header h2 {
                font-family: 'Baloo 2', cursive;
                font-size: 36px;
                color: #FF8C42;
                margin-bottom: 10px;
            }

            .section-header .subtitle {
                font-size: 16px;
                color: #666;
                font-style: italic;
            }

            /* About Section */
            .about-section {
                padding: 60px 0;
                background-color: #fffaf5;
            }

            .about-content h3 {
                color: #FF8C42;
                font-size: 22px;
                margin-top: 30px;
            }

            .about-content ul {
                list-style: none;
                padding-left: 0;
            }

            .about-content ul li {
                padding-left: 1.5rem;
                position: relative;
                margin-bottom: 10px;
            }

            .about-content ul li::before {
                content: "🐾";
                position: absolute;
                left: 0;
            }

            .quote {
                font-style: italic;
                background: #ffe9d6;
                border-left: 5px solid #FF8C42;
                padding: 15px;
                margin-top: 20px;
                border-radius: 8px;
            }

            /* Team Section */
            .team-section {
                background-color: #fff0e6;
                padding: 60px 0;
            }

            .team-card {
                background-color: #fff;
                border-radius: 16px;
                padding: 25px;
                text-align: center;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
                transition: all 0.3s ease-in-out;
            }

            .team-card:hover {
                transform: translateY(-8px);
                box-shadow: 0 10px 25px rgba(0,0,0,0.15);
            }

            .team-img {
                width: 120px;
                height: 120px;
                object-fit: cover;
                border-radius: 50%;
                border: 4px solid #FFDDCC;
                margin-bottom: 15px;
            }

            .team-card h4 {
                color: #FF8C42;
                margin-bottom: 5px;
                font-weight: 600;
            }

            .team-card .position {
                font-size: 14px;
                color: #888;
                font-style: italic;
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

        </style>
    </head>
    <body>
        <!-- Top bar (giống home.jsp) -->
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

        <!-- About Section -->
        <section class="about-section">
            <div class="container">
                <div class="section-header text-center">
                    <h2>🐶 Về Chúng Tôi - PetTech 🐱</h2>
                    <p class="subtitle">Giải pháp toàn diện cho thú cưng của bạn</p>
                </div>

                <div class="row align-items-center mt-5">
                    <div class="col-md-6">
                        <div class="about-content">
                            <p>PetTech không chỉ là nền tảng cung cấp dịch vụ - mà còn là người bạn đồng hành trung thành với thú cưng của bạn. 
                                Chúng tôi tin rằng mọi thú cưng đều xứng đáng được yêu thương và chăm sóc trọn vẹn nhất. ❤️</p>

                            <h3>🎯 Sứ mệnh của chúng tôi</h3>
                            <p>Thú cưng là một phần của gia đình. PetTech ra đời để:</p>
                            <ul>
                                <li>🐾 Cách mạng hóa nhận thức về chăm sóc thú cưng tại Việt Nam</li>
                                <li>🐾 Thu hẹp khoảng cách giữa kiến thức chuyên môn và người nuôi</li>
                                <li>🐾 Mang lại dịch vụ tốt nhất cho mọi “boss” và “sen”</li>
                            </ul>

                            <h3>💡 Giá Trị Cốt Lõi</h3>
                            <ul>
                                <li><strong>TÂM:</strong> Luôn đặt tình yêu thương động vật lên hàng đầu</li>
                                <li><strong>TẦM:</strong> Dẫn đầu về chất lượng dịch vụ và sáng tạo</li>
                                <li><strong>TÍN:</strong> Uy tín trong từng hành động và sản phẩm</li>
                            </ul>

                            <h3>🤝 Cam kết</h3>
                            <ul>
                                <li>✅ Chất lượng sản phẩm, dịch vụ luôn được kiểm định</li>
                                <li>✅ Hỗ trợ khách hàng tận tâm 24/7</li>
                                <li>✅ Không ngừng đổi mới, cập nhật theo chuẩn quốc tế</li>
                            </ul>

                            <p class="quote">"Chúng tôi không chỉ bán sản phẩm - chúng tôi trao gửi yêu thương. Hãy cùng PetTech viết tiếp câu chuyện vì những trái tim nhỏ bé!"</p>
                        </div>
                    </div>
                    <div class="col-md-6 text-center">
                        <img src="images/logocontact.jpg" alt="Về PetTech" class="img-fluid rounded shadow">
                    </div>
                </div>
            </div>
        </section>
        <!-- START: User Guide Section -->
        <section class="about-section">
            <div class="container">
                <div class="section-header text-center">
                    <h2>📘 Hướng Dẫn Sử Dụng Website PetTech</h2>
                    <p class="subtitle">Cách để bạn dễ dàng hòa nhập cộng đồng yêu thú cưng</p>
                </div>

                <div class="row mt-5">
                    <div class="col-md-12">
                        <div class="about-content">
                            <h3>💡 Giới thiệu ngắn</h3>
                            <p>Website <strong>PetTech</strong> là nền tảng toàn diện dành cho cộng đồng yêu thú cưng – nơi bạn có thể:</p>
                            <ul>
                                <li>Kết nối với chuyên gia & người nuôi khác</li>
                                <li>Tham gia các khóa học huấn luyện – chăm sóc thú cưng</li>
                                <li>Nhận hỗ trợ từ đội ngũ bác sĩ thú y và huấn luyện viên</li>
                                <li>Khám phá sản phẩm dịch vụ tiện ích & cập nhật xu hướng</li>
                            </ul>

                            <h3>📝 I. CÁC BƯỚC TRỞ THÀNH THÀNH VIÊN</h3>
                            <ul>
                                <li><strong>Bước 1:</strong> Truy cập website <a href="https://shop.pettech.io">shop.pettech.io</a></li>
                                <li><strong>Bước 2:</strong> Nhấn "Đăng ký" → chọn gói dịch vụ phù hợp
                                    <ul>
                                        <li><em>Miễn phí:</em> Điền Họ tên, Email, SĐT, Mật khẩu, Địa chỉ</li>
                                        <li><em>Trả phí:</em> Thanh toán rồi điền thông tin như trên</li>
                                    </ul>
                                    Sau đó kiểm tra email để <strong>kích hoạt tài khoản</strong>
                                </li>
                                <li><strong>Bước 3:</strong> Đăng nhập và khám phá!</li>
                            </ul>

                            <h3>🎓 II. SỬ DỤNG KHÓA HỌC</h3>
                            <ul>
                                <li>Vào mục "Khóa học" trên thanh menu</li>
                                <li>Chọn khóa học phù hợp (VD: Huấn luyện chó Poodle)</li>
                                <li>Mỗi khóa có video, tài liệu, bài kiểm tra theo dõi tiến độ</li>
                            </ul>

                            <h3>💬 III. LIÊN HỆ HỖ TRỢ</h3>
                            <ul>
                                <li>Email: <a href="mailto:pettech2495@gmail.com">pettech2495@gmail.com</a></li>
                                <li>Hotline: <a href="tel:0352138596">0352 138 596</a> (giờ hành chính)</li>
                            </ul>

                            <h3>🤝 IV. QUYỀN LỢI THÀNH VIÊN</h3>
                            <ul>
                                <li>✅ Truy cập đầy đủ khóa học</li>
                                <li>✅ Nhận chứng chỉ hoàn thành</li>
                                <li>✅ Ưu đãi giảm giá khóa sau</li>
                                <li>✅ Tư vấn trực tiếp từ chuyên gia</li>
                                <li>✅ Cập nhật tài liệu mới mỗi tuần</li>
                            </ul>

                            <h3>🧡 V. CAM KẾT CỦA PETTECH</h3>
                            <p class="quote">"Chúng tôi không chỉ cung cấp dịch vụ – mà còn trao gửi yêu thương đến thú cưng bạn yêu quý. Hãy để PetTech đồng hành cùng bạn!"</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <!-- END: User Guide Section -->

        <!-- Team Section -->
        <section class="team-section">
            <div class="container">
                <div class="section-header text-center">
                    <h2>🌟 Đội Ngũ Của Chúng Tôi 🌟</h2>
                    <p class="subtitle">Những trái tim tận tụy phía sau PetTech</p>
                </div>

                <div class="row justify-content-center mt-4">
                    <!-- Team Member -->
                    <div class="col-md-4 mb-4">
                        <div class="team-card">
                            <img src="images/dinh.jpg" alt="CEO" class="team-img">
                            <h4>Lê Đỗ Đình</h4>
                            <p class="position">CEO & Nhà sáng lập</p>
                            <p>Chuyên gia huấn luyện thú cưng với 10 năm kinh nghiệm</p>
                        </div>
                    </div>
                    <!-- Member 2 -->
                    <div class="col-md-4 mb-4">
                        <div class="team-card">
                            <img src="images/nam.jpg" alt="Nguyễn Viết Hải Nam" class="team-img">
                            <h4>Nguyễn Viết Hải Nam</h4>
                            <p class="position">Giám đốc đào tạo</p>
                            <p>Chuyên gia dinh dưỡng và sức khỏe thú cưng</p>
                        </div>
                    </div>

                    <!-- Member 3 -->
                    <div class="col-md-4 mb-4">
                        <div class="team-card">
                            <img src="images/chi.jpg" alt="Nguyễn Quỳnh Chi" class="team-img">
                            <h4>Nguyễn Quỳnh Chi</h4>
                            <p class="position">Giám đốc sản phẩm</p>
                            <p>Chuyên gia về các sản phẩm chăm sóc thú cưng</p>
                        </div>
                    </div>

                    <!-- Member 4 -->
                    <div class="col-md-4 mb-4">
                        <div class="team-card">
                            <img src="images/cam.jpg" alt="Vũ Diệu Cẩm" class="team-img">
                            <h4>Vũ Diệu Cẩm</h4>
                            <p class="position">Trưởng phòng công nghệ</p>
                            <p>Phát triển hệ thống và ứng dụng cho PetTech</p>
                        </div>
                    </div>

                    <!-- Member 5 -->
                    <div class="col-md-4 mb-4">
                        <div class="team-card">
                            <img src="images/hien.jpg" alt="Nguyễn Thúy Hiền" class="team-img">
                            <h4>Nguyễn Thúy Hiền</h4>
                            <p class="position">Trưởng phòng chăm sóc khách hàng</p>
                            <p>Hỗ trợ và tư vấn cho khách hàng 24/7</p>
                        </div>
                    </div>

                    <!-- More members -->
                    <!-- Copy similar blocks for other team members -->
                </div>
            </div>
        </section>




        <!-- Contact Info Section -->
        <section class="contact-info-section">
            <div class="container">
                <div class="row justify-content-center mb-5">
                    <div class="col-md-7 text-center">
                        <h2 class="mb-4" style="color: #8B5E3C;">Thông tin liên hệ</h2>
                        <p>Chúng tôi luôn sẵn sàng hỗ trợ bạn</p>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-4">
                        <div class="contact-info-card">
                            <div class="contact-icon">
                                <i class="fas fa-map-marker-alt"></i>
                            </div>
                            <h4>Địa chỉ</h4>
                            <p>Trường Đại Học FPT - Khu CNC Láng Hòa Lạc</p>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="contact-info-card">
                            <div class="contact-icon">
                                <i class="fas fa-phone-alt"></i>
                            </div>
                            <h4>Điện thoại</h4>
                            <p>0352 138 596 (Hỗ trợ 24/7)</p>
                            <p>0243 623 1234 (Văn phòng)</p>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="contact-info-card">
                            <div class="contact-icon">
                                <i class="fas fa-envelope"></i>
                            </div>
                            <h4>Email</h4>
                            <p>pettech@gmail.com</p>
                            <p>support@gmail.com</p>
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
                                <li><a href="#"><span class="icon fa fa-paper-plane"></span><span class="text">pettech.gmail.com</span></a></li>
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
