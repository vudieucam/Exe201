<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Đổi mật khẩu - PetTech</title>
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

            .title {
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

            .btn-save {
                background-color: #ff6f61;
                color: white;
                border: none;
                border-radius: 30px;
                padding: 12px;
                font-weight: bold;
                font-size: 1.1rem;
                transition: background-color 0.3s;
            }

            .btn-save:hover {
                background-color: #ff3b2e;
            }

            .pet-icon {
                font-size: 2.5rem;
                color: #ff6f61;
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
            <c:if test="${not empty notification}">
                <div class="alert alert-${success ? 'success' : 'danger'} text-center mt-3" role="alert">
                    ${notification}
                </div>
            </c:if>

            <div class="text-center mb-4">
                <i class="fas fa-paw pet-icon"></i>
                <h2 class="title fw-bold">Đổi mật khẩu</h2>
                <p class="text-muted">Bảo vệ tài khoản để thú cưng luôn an toàn nhé!</p>
            </div>

            <form action="authen?action=changePassword" method="post">
                <div class="mb-3 form-floating">
                    <input type="password" class="form-control" id="oldPassword" name="oldPassword" placeholder="Mật khẩu cũ" required>
                    <label for="oldPassword"><i class="fas fa-lock"></i> Mật khẩu cũ</label>
                </div>

                <div class="mb-3 form-floating">
                    <input type="password" class="form-control" id="newPassword" name="newPassword" placeholder="Mật khẩu mới" required>
                    <label for="newPassword"><i class="fas fa-lock"></i> Mật khẩu mới</label>
                </div>

                <div class="mb-3 form-floating">
                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="Nhập lại mật khẩu mới" required>
                    <label for="confirmPassword"><i class="fas fa-lock"></i> Nhập lại mật khẩu mới</label>
                </div>

                <div class="d-flex justify-content-between mt-4">
                    <!-- Nút quay lại bên trái -->
                    <a href="authen?action=editprofile" class="btn btn-outline-secondary rounded-pill px-4">
                        <i class="fas fa-arrow-left me-2"></i> Quay lại
                    </a>

                    <!-- Nút lưu bên phải -->
                    <button class="btn btn-save" type="submit">
                        <i class="fas fa-save me-1"></i> Lưu
                    </button>
                </div>

            </form>
        </div>

        <!-- Optional JS for auto-redirect after change -->
        <% if (Boolean.TRUE.equals(request.getAttribute("success"))) { %>
        <script>
            setTimeout(function () {
                window.location.href = 'authen?action=login';
            }, 5000);
        </script>
        <% }%>



    </body>
</html>
