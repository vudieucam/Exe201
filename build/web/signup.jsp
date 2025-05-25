<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
            
            <c:if test="${param.packageId != null}">
                <div class="package-info mb-4 p-3 rounded" style="background-color: #FFF8DC; border-left: 5px solid #ff6f61;">
                    <h5><i class="fas fa-box-open"></i> Đăng ký với gói:</h5>
                    <c:choose>
                        <c:when test="${param.packageId == '1'}">
                            <h4 class="text-primary">GÓI MIỄN PHÍ</h4>
                            <p><i class="fas fa-paw"></i> Truy cập các khóa học cơ bản</p>
                        </c:when>
                        <c:when test="${param.packageId == '2'}">
                            <h4 class="text-success">GÓI TIÊU CHUẨN</h4>
                            <p><i class="fas fa-paw"></i> Truy cập tất cả khóa học tiêu chuẩn</p>
                        </c:when>
                        <c:when test="${param.packageId == '3'}">
                            <h4 class="text-warning">GÓI CHUYÊN NGHIỆP</h4>
                            <p><i class="fas fa-paw"></i> Truy cập tất cả khóa học và dịch vụ cao cấp</p>
                        </c:when>
                    </c:choose>
                </div>
            </c:if>
            <form action="authen?action=confirmRegister" method="post">
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
                    <div class="mb-3">
                        <label for="packageId" class="form-label fw-bold text-primary">Chọn gói dịch vụ:</label>
                        <select class="form-select" id="packageId" name="packageId" required>
                            <c:forEach var="pkg" items="${packages}">
                                <option value="${pkg.id}" <c:if test="${param.packageId == pkg.id}">selected</c:if>>
                                    ${pkg.name} - ${pkg.price}₫
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <button class="btn btn-orange" type="submit"><i class="fas fa-user-plus"></i> Đăng ký</button>
                </div>
                <div class="text-center">
                    <span class="text-muted">Đã có tài khoản?</span>
                    <a href="authen?action=login">Đăng nhập</a>
                </div>
            </form>
        </div>
    </body>
</html>
