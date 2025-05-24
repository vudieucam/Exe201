<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Cấp lại mật khẩu - PetTech</title>
    <link rel="stylesheet" href="https://unpkg.com/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <style>
        body {
            background-color: #fff;
            font-family: 'Comic Neue', cursive, sans-serif;
            color: #000;
        }

        .container {
            max-width: 500px;
        }

        .modal-content {
            background-color: #fefefe;
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
        }

        h2.title {
            color: #ff6f61;
            text-align: center;
            font-weight: bold;
        }

        .form-control {
            background-color: rgba(255, 255, 255, 0.95);
            border-radius: 30px;
            padding: 15px;
            border: none;
            font-size: 1rem;
            transition: box-shadow 0.3s;
        }

        .form-control:focus {
            box-shadow: 0 0 10px #ff6f61;
            outline: none;
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

        a.back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #ff6f61;
            font-weight: bold;
            text-decoration: none;
        }

        a.back-link:hover {
            text-decoration: underline;
            color: #ff3b2e;
        }

        .pet-icon {
            font-size: 2.5rem;
            color: #ff6f61;
            text-align: center;
            display: block;
            margin-bottom: 10px;
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
            <h2 class="title">Cấp lại mật khẩu</h2>
            <p class="text-muted">Nhập email để nhận hướng dẫn đặt lại mật khẩu</p>
        </div>

        <!-- Thông báo nếu có -->
        <c:if test="${notification ne null}">
            <div class="alert alert-danger text-center">
                ${notification}
            </div>
        </c:if>

        <!-- Form gửi yêu cầu cấp lại mật khẩu -->
        <form action="authen?action=resetpassword" method="post">
            <div class="mb-3 form-floating">
                <input name="email" type="email" class="form-control" id="email" placeholder="Email của bạn" required>
                <label for="email"><i class="fas fa-envelope"></i> Email</label>
            </div>
            <div class="d-grid">
                <button type="submit" class="btn btn-orange">
                    <i class="fas fa-paper-plane"></i> Kiểm tra
                </button>
            </div>
        </form>

        <a href="login.jsp" class="back-link">
            <i class="fas fa-arrow-left"></i> Quay lại Đăng nhập
        </a>
    </div>
</body>
</html>
