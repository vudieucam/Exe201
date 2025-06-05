<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Trang Đăng Nhập Thú Cưng</title>
        <link rel="stylesheet" href="https://unpkg.com/bootstrap@5.3.2/dist/css/bootstrap.min.css">
        <!-- Thêm icon Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
        <style>
            /* Nền phù hợp chủ đề thú cưng */
            body {
                background-color: #ffffff;
                margin: 0;
                padding: 0;
                font-family: 'Comic Neue', cursive, sans-serif;
                color: #000; /* Đổi màu chữ thành đen cho dễ đọc trên nền trắng */
            }




            /* Container thông báo */
            .notification-container {
                width: 100%;
                text-align: center;
                position: fixed;
                top: 20px;
                left: 50%;
                transform: translateX(-50%);
                z-index: 1050;
            }

            /* Nội dung thông báo */
            .notification {
                display: inline-block;
                margin: 0 auto;
                border-radius: 10px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
                width: auto;
                max-width: 80%;
                padding: 15px 20px;
                font-weight: bold;
                font-size: 1.1rem;
            }

            /* Thay đổi màu nền cho thông báo */
            .notification.alert-info {
                background-color: #ffe4e1; /* Màu hồng nhẹ nhàng */
                color: #333;
            }

            /* Phần tiêu đề chính */
            h2.display-5 {
                color: #ff6f61; /* Màu coral dễ thương */
            }

            /* Link đăng ký và quên mật khẩu */
            a {
                color: #ff6f61;
                font-weight: bold;
                transition: color 0.3s;
            }
            a:hover {
                color: #ff3b2e;
                text-decoration: underline;
            }

            /* Form đăng nhập */
            .form-control {
                background-color: rgba(255, 255, 255, 0.8);
                border-radius: 20px;
                padding: 15px;
                border: none;
                font-size: 1rem;
                transition: box-shadow 0.3s;
            }
            .form-control:focus {
                box-shadow: 0 0 10px #ff6f61;
                outline: none;
                background-color: #fff;
            }

            /* Button đăng nhập */
            .btn-primary {
                background-color: #ff6f61;
                border: none;
                border-radius: 30px;
                padding: 15px;
                font-size: 1.2rem;
                transition: background-color 0.3s;
            }
            .btn-primary:hover {
                background-color: #ff3b2e;
            }

            /* Các nút social login */
            .btn-google {
                background-color: #db4437;
                color: #fff;
                border-radius: 30px;
                padding: 12px;
                font-weight: bold;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
                transition: background-color 0.3s;
            }
            .btn-google:hover {
                background-color: #a33a2d;
            }

            /* Thêm biểu tượng thú cưng nhỏ */
            .pet-icon {
                font-size: 2rem;
                color: #ff6f61;
                margin-bottom: 15px;
            }

            /* Responsive padding */
            @media(max-width: 768px){
                body {
                    padding: 10px;
                }
            }
        </style>
    </head>
    <body>
        <c:set var="cookie" value="${pageContext.request.cookies}"/>

        <!-- Biểu tượng thú cưng -->
        <div class="text-center mt-4">
            <i class="fas fa-paw pet-icon"></i>
            <h2 class="display-5 fw-bold">Chào mừng đến với PetTech</h2>
        </div>

        <!-- Thông báo -->
        <%-- Hiển thị thông báo thành công từ reset password --%>
        <c:if test="${not empty success}">
            <div class="alert alert-success" style="width: fit-content; margin: 20px auto; text-align: center;">
                <span>${not empty success ? success : sessionScope.success}</span>
            </div>
            <% session.removeAttribute("success"); %>
        </c:if>

        <c:if test="${not empty notification || not empty sessionScope.notification}">
            <div class="notification-container">
                <div class="alert alert-info notification">
                    <span>${not empty notification ? notification : sessionScope.notification}</span>
                </div>
            </div>
            <%
                session.removeAttribute("notification");
            %>
        </c:if>
        <script>
            setTimeout(function () {
                var notificationContainer = document.querySelector('.notification-container');
                if (notificationContainer) {
                    notificationContainer.remove();
                }
            }, 3000);
        </script>

        <!-- Form đăng nhập -->
        <div class="container my-4 py-4 bg-light bg-opacity-75 rounded-4 shadow-lg" style="max-width: 500px;">
            <form action="authen?action=login" method="post" class="px-4">
                <div class="text-center mb-4">
                    <i class="fas fa-dog fa-3x" style="color:#ff6f61;"></i>
                    <h3 class="mt-3 text-dark">Đăng nhập để yêu thương thú cưng cùng PetTech</h3>
                </div>
                <div class="mb-3 form-floating">
                    <input type="email" class="form-control" id="email" name="email" placeholder="tên@example.com" value="${cookie.cEmail.value}" required>
                    <label for="email"><i class="fas fa-envelope"></i> Email</label>
                </div>
                <div class="mb-3 form-floating">
                    <input type="password" class="form-control" id="password" name="password" placeholder="Mật khẩu" value="${cookie.cPassword.value}" required>
                    <label for="password"><i class="fas fa-lock"></i> Mật khẩu</label>
                </div>
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="remember_me" name="remember_me">
                        <label class="form-check-label" for="remember_me">Nhớ mật khẩu</label>
                    </div>
                    <a href="authen?action=resetpassword" class="small">Quên mật khẩu?</a>
                </div>
                <div class="d-grid mb-3">
                    <button class="btn btn-primary" type="submit"><i class="fas fa-sign-in-alt"></i> Đăng nhập</button>
                </div>
                <div class="text-center my-3 text-muted">Hoặc</div>
                <div class="d-grid mb-3">
                    <a href="https://accounts.google.com/o/oauth2/auth?scope=email profile openid&redirect_uri=http://localhost:9999/Baby_Shop_Online/login&response_type=code&client_id=948721200719-o51t8pjgou45comhj4834njb1sdmafov.apps.googleusercontent.com&approval_prompt=force" class="btn btn-google">
                        <i class="fab fa-google"></i> Đăng nhập với Google
                    </a>
                </div>
                <a href="package" class="btn btn-warning w-100 mt-2">
                    <i class="fas fa-user-plus"></i> Đăng ký ngay
                </a>
                <!-- Bạn có thể thêm các biểu tượng hoặc nút khác như Facebook, Zalo nếu cần -->
            </form>
        </div>
    </body>
</html>
