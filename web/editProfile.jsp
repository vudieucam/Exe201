<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Chỉnh sửa thông tin cá nhân - PetTech</title>
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

            .toggle-btn {
                background: none;
                border: none;
                color: #ff6f61;
                font-weight: bold;
                cursor: pointer;
                margin-bottom: 10px;
            }

            .toggle-btn:hover {
                text-decoration: underline;
            }

            @media (max-width: 768px) {
                body {
                    padding: 10px;
                }
            }

        </style>
        <script>
            document.querySelector("form").addEventListener("submit", function (e) {
                const emailInput = document.getElementById("email");
                if (!emailInput.value.includes("@")) {
                    e.preventDefault();
                    alert("Vui lòng nhập đúng định dạng email!");
                }
            });
        </script>

    </head>
    <body>
        <div class="container my-5 p-4 bg-light bg-opacity-75 rounded-4 shadow-lg">
            <div class="text-center mb-4">
                <i class="fas fa-paw pet-icon"></i>
                <h2 class="title fw-bold">Chỉnh sửa hồ sơ cá nhân</h2>
                <p class="text-muted">Cập nhật thông tin để thú cưng luôn nhận diện bạn nhé!</p>
            </div>
            <form action="home" method="post" class="px-2">
                <div class="mb-3 form-floating">
                    <input type="email" class="form-control" id="email" name="email" value="${user.email}" readonly>
                    <label for="email"><i class="fas fa-envelope"></i> Email</label>
                </div>
                <div class="mb-3 form-floating">
                    <input type="text" class="form-control" id="fullname" name="fullname" value="${user.fullname}" required>
                    <label for="fullname"><i class="fas fa-user"></i> Họ và tên</label>
                </div>
                <div class="mb-3 form-floating">
                    <input type="text" class="form-control" id="phone" name="phone" value="${user.phone}" required>
                    <label for="phone"><i class="fas fa-phone"></i> Số điện thoại</label>
                </div>
                <div class="mb-3 form-floating">
                    <input type="text" class="form-control" id="address" name="address" value="${user.address}" required>
                    <label for="address"><i class="fas fa-home"></i> Địa chỉ</label>
                </div>

                <!-- Nút điều hướng sang trang đổi mật khẩu -->
                <div class="text-end">
                    <a href="authen?action=changepassword" class="toggle-btn">
                        <i class="fas fa-key"></i> Thay đổi mật khẩu
                    </a>
                </div>




                <div class="d-grid mt-4">
                    <button class="btn btn-orange" type="submit"><i class="fas fa-save"></i> Lưu thay đổi</button>
                </div>
            </form>
        </div>

        <script>
            function togglePasswordFields() {
                const section = document.getElementById("password-section");
                section.style.display = section.style.display === "none" ? "block" : "none";
            }
            document.querySelector("form").addEventListener("submit", function () {
                const btn = this.querySelector("button[type='submit']");
                btn.disabled = true;
                btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang kiểm tra...';
            });

        </script>
    </body>
</html>
