<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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

            <!-- Hiển thị thông báo từ session -->
            <c:if test="${not empty sessionScope.notification}">
                <div class="alert alert-success alert-dismissible fade show">
                    ${sessionScope.notification}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <c:remove var="notification" scope="session"/>
            </c:if>

            <c:if test="${not empty sessionScope.error}">
                <div class="alert alert-danger alert-dismissible fade show">
                    ${sessionScope.error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <c:remove var="error" scope="session"/>
            </c:if>

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
                            <p class="text-danger fw-bold">Phí: 99,000đ/tháng</p>
                        </c:when>
                        <c:when test="${param.packageId == '3'}">
                            <h4 class="text-warning">GÓI CHUYÊN NGHIỆP</h4>
                            <p><i class="fas fa-paw"></i> Truy cập tất cả khóa học và dịch vụ cao cấp</p>
                            <p class="text-danger fw-bold">Phí: 199,000đ/tháng</p>
                        </c:when>
                    </c:choose>
                </div>
            </c:if>

            <c:choose>
                <c:when test="${empty param.packageId}">
                    <c:set var="packageId" value="1" />
                </c:when>
                <c:otherwise>
                    <c:set var="packageId" value="${param.packageId}" />
                </c:otherwise>
            </c:choose>

            <form action="package" method="post">
                <input type="hidden" name="action" value="payAndRegister">
                <input type="hidden" name="packageId" value="${packageId}">

                <!-- Thêm trường paymentMethod với giá trị phù hợp -->
                <input type="hidden" name="paymentMethod" value="${packageId == 1 ? 'free' : 'paypal'}">

                <div class="mb-3 form-floating">
                    <input type="email" class="form-control ${not empty sessionScope.emailError ? 'is-invalid' : ''}" 
                           id="email" name="email" placeholder="ten@example.com" 
                           value="${sessionScope.oldEmail}" required>
                    <label for="email"><i class="fas fa-envelope"></i> Email</label>
                    <c:if test="${not empty sessionScope.emailError}">
                        <div class="invalid-feedback">${sessionScope.emailError}</div>
                    </c:if>
                </div>

                <div class="mb-3 form-floating">
                    <input type="text" class="form-control ${not empty sessionScope.fullnameError ? 'is-invalid' : ''}" 
                           id="fullname" name="fullname" placeholder="Họ và tên" 
                           value="${sessionScope.oldFullname}" required>
                    <label for="fullname"><i class="fas fa-user"></i> Họ và tên</label>
                    <c:if test="${not empty sessionScope.fullnameError}">
                        <div class="invalid-feedback">${sessionScope.fullnameError}</div>
                    </c:if>
                </div>

                <div class="mb-3 form-floating">
                    <input type="text" class="form-control ${not empty sessionScope.phoneError ? 'is-invalid' : ''}" 
                           id="phone" name="phone" placeholder="Số điện thoại" 
                           value="${sessionScope.oldPhone}" required>
                    <label for="phone"><i class="fas fa-phone"></i> Số điện thoại</label>
                    <c:if test="${not empty sessionScope.phoneError}">
                        <div class="invalid-feedback">${sessionScope.phoneError}</div>
                    </c:if>
                </div>

                <div class="mb-3 form-floating">
                    <input type="password" class="form-control ${not empty sessionScope.passwordError ? 'is-invalid' : ''}" 
                           id="password" name="password" placeholder="Mật khẩu" required minlength="8" maxlength="32">
                    <label for="password"><i class="fas fa-lock"></i> Mật khẩu (8-32 ký tự)</label>
                    <c:if test="${not empty sessionScope.passwordError}">
                        <div class="invalid-feedback">${sessionScope.passwordError}</div>
                    </c:if>
                </div>

                <div class="mb-3 form-floating">
                    <input type="password" class="form-control" id="confirm_password" 
                           name="confirm_password" placeholder="Nhập lại mật khẩu" required minlength="8" maxlength="32">
                    <label for="confirm_password"><i class="fas fa-lock"></i> Nhập lại mật khẩu</label>
                </div>

                <!-- Thêm trường address vào form -->
                <div class="mb-3 form-floating">
                    <input type="text" class="form-control" id="address" name="address" 
                           placeholder="Địa chỉ" value="${sessionScope.oldAddress}" required>
                    <label for="address"><i class="fas fa-map-marker-alt"></i> Địa chỉ</label>
                </div>

                <div class="d-grid mb-3">
                    <button class="btn btn-orange" type="submit"><i class="fas fa-user-plus"></i> Đăng ký</button>
                </div>

                <div class="text-center">
                    <span class="text-muted">Đã có tài khoản?</span>
                    <a href="authen?action=login">Đăng nhập</a>
                </div>
            </form>
        </div>

        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Xác nhận mật khẩu trước khi submit
            document.querySelector('form').addEventListener('submit', function (e) {
                const password = document.getElementById('password').value;
                const confirmPassword = document.getElementById('confirm_password').value;

                if (password !== confirmPassword) {
                    e.preventDefault();
                    alert('Mật khẩu nhập lại không khớp!');
                    document.getElementById('confirm_password').focus();
                }
            });
        </script>
    </body>
</html>

<%-- Xóa session tạm sau khi hiển thị xong --%>
<%-- Xóa session tạm sau khi hiển thị xong --%>
<c:remove var="emailError" scope="session"/>
<c:remove var="phoneError" scope="session"/>
<c:remove var="passwordError" scope="session"/>
<c:remove var="fullnameError" scope="session"/>
<c:remove var="addressError" scope="session"/>
<c:remove var="oldEmail" scope="session"/>
<c:remove var="oldFullname" scope="session"/>
<c:remove var="oldPhone" scope="session"/>
<c:remove var="oldAddress" scope="session"/>
