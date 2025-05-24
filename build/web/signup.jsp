<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng Ký Tài Khoản - PetTech</title>
    <link rel="stylesheet" href="https://unpkg.com/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <style>
        body {
            background-color: #fff;
            font-family: 'Comic Neue', cursive, sans-serif;
            color: #000;
        }

        .container {
            max-width: 600px;
        }

        h2.title {
            color: #ff6f61;
        }

        .form-control {
            background-color: rgba(255, 255, 255, 0.9);
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

        .btn-orange {
            background-color: #ff6f61;
            color: white;
            border: none;
            border-radius: 30px;
            padding: 12px;
            font-weight: bold;
            font-size: 1.1rem;
            transition: background-color 0.3s;
        }

        .btn-orange:hover {
            background-color: #ff3b2e;
        }

        .pet-icon {
            font-size: 2.5rem;
            color: #ff6f61;
        }

        a {
            color: #ff6f61;
            font-weight: bold;
            text-decoration: none;
        }

        a:hover {
            text-decoration: underline;
            color: #ff3b2e;
        }

        @media (max-width: 768px) {
            body {
                padding: 10px;
            }
        }
    </style>
</head>
<body>
    <div class="container my-5 p-4 bg-light bg-opacity-75 rounded-4 shadow-lg">
        <div class="text-center mb-4">
            <i class="fas fa-paw pet-icon"></i>
            <h2 class="title fw-bold">Đăng ký tài khoản PetTech</h2>
            <p class="text-muted">Yêu thương thú cưng từ hôm nay!</p>
        </div>
        <form action="authen?action=register" method="post" class="px-2">
            <div class="mb-3 form-floating">
                <input type="email" class="form-control" id="email" name="email" placeholder="ten@example.com" required>
                <label for="email"><i class="fas fa-envelope"></i> Email</label>
            </div>
            <div class="mb-3 form-floating">
                <input type="text" class="form-control" id="fullname" name="fullname" placeholder="Họ và tên" required>
                <label for="fullname"><i class="fas fa-user"></i> Họ và tên</label>
            </div>
            <div class="mb-3 form-floating">
                <input type="text" class="form-control" id="phone" name="phone" placeholder="Số điện thoại" required>
                <label for="phone"><i class="fas fa-phone"></i> Số điện thoại</label>
            </div>
            <div class="mb-3 form-floating">
                <input type="text" class="form-control" id="address" name="address" placeholder="Địa chỉ" required>
                <label for="address"><i class="fas fa-home"></i> Địa chỉ</label>
            </div>
            <div class="mb-3 form-floating">
                <input type="password" class="form-control" id="password" name="password" placeholder="Mật khẩu" required>
                <label for="password"><i class="fas fa-lock"></i> Mật khẩu</label>
            </div>
            <div class="mb-3 form-floating">
                <input type="password" class="form-control" id="confirm_password" name="confirm_password" placeholder="Nhập lại mật khẩu" required>
                <label for="confirm_password"><i class="fas fa-lock"></i> Nhập lại mật khẩu</label>
            </div>
            <div class="d-grid mb-3">
                <button class="btn btn-orange" type="submit"><i class="fas fa-user-plus"></i> Đăng ký</button>
            </div>
            <div class="text-center">
                <span class="text-muted">Đã có tài khoản?</span>
                <a href="login.jsp">Đăng nhập</a>
            </div>
        </form>
    </div>
</body>
</html>
