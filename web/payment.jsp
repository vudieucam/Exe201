<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>


<c:set var="fromRegistration" value="${fromRegistration}" />
<!DOCTYPE html>
<html>
    <head>
        <title>Thanh Toán Nâng Cấp Gói - PetTech</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
        <style>
            body {
                background-color: #FFF8DC;
                font-family: 'Comic Neue', cursive, sans-serif;
            }

            .payment-container {
                max-width: 800px;
                margin: 30px auto;
                background: white;
                border-radius: 20px;
                box-shadow: 0 10px 30px rgba(210, 105, 30, 0.1);
                padding: 30px;
                border: 3px solid #FFA07A;
            }

            .package-card {
                background: #FFF8DC;
                border-radius: 15px;
                padding: 20px;
                margin-bottom: 20px;
                border-left: 5px solid #D2691E;
            }

            .payment-methods .method {
                display: flex;
                align-items: center;
                padding: 15px;
                border: 2px solid #eee;
                border-radius: 10px;
                margin-bottom: 10px;
                cursor: pointer;
                transition: all 0.3s;
            }

            .payment-methods .method:hover {
                border-color: #D2691E;
                background: #FFF8DC;
            }

            .payment-methods .method i {
                font-size: 2rem;
                color: #D2691E;
                margin-right: 15px;
            }

            .btn-confirm {
                background: #D2691E;
                color: white;
                border: none;
                border-radius: 30px;
                padding: 12px 30px;
                font-size: 1.1rem;
                font-weight: bold;
                transition: all 0.3s;
            }

            .btn-confirm:hover {
                background: #FF8C00;
                transform: scale(1.05);
            }

            .pet-paw {
                color: #D2691E;
                font-size: 1.5rem;
                margin-right: 10px;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="payment-container">
                <h2 class="text-center mb-4"><i class="fas fa-paw pet-paw"></i> Thanh Toán Nâng Cấp Gói</h2>

                <div class="package-card">
                    <h4><i class="fas fa-box-open"></i> Gói Đang Nâng Cấp</h4>
                    <hr>
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h3 class="text-warning">${pkg.name}</h3>
                            <p class="mb-1"><i class="fas fa-paw"></i> ${pkg.description}</p>
                        </div>
                        <div class="text-right">
                            <h3 class="text-danger">${pkg.price}₫</h3>
                            <small class="text-muted">Trọn đời</small>
                        </div>
                    </div>
                </div>

                <form action="package" method="post">
                    <input type="hidden" name="action" value="${fromRegistration ? 'payAndRegister' : 'upgrade'}">

                    <input type="hidden" name="packageId" value="${pkg.id}">

                    <h4 class="mt-4 mb-3"><i class="fas fa-credit-card pet-paw"></i> Phương Thức Thanh Toán</h4>

                    <div class="payment-methods">
                        <label class="method">
                            <input type="radio" name="paymentMethod" value="momo" checked>
                            <i class="fas fa-mobile-alt"></i>
                            <div>
                                <h5 class="mb-1">Ví MoMo</h5>
                                <p class="mb-0 text-muted">Thanh toán qua ứng dụng MoMo</p>
                            </div>
                        </label>

                        <label class="method">
                            <input type="radio" name="paymentMethod" value="bank">
                            <i class="fas fa-university"></i>
                            <div>
                                <h5 class="mb-1">Chuyển Khoản Ngân Hàng</h5>
                                <p class="mb-0 text-muted">Chuyển khoản qua Internet Banking</p>
                            </div>
                        </label>

                        <label class="method">
                            <input type="radio" name="paymentMethod" value="cod">
                            <i class="fas fa-money-bill-wave"></i>
                            <div>
                                <h5 class="mb-1">Thanh Toán Khi Nhận Dịch Vụ</h5>
                                <p class="mb-0 text-muted">Nhân viên sẽ liên hệ để xác nhận</p>
                            </div>
                        </label>
                    </div>

                    <div class="text-center mt-4">
                        <button type="submit" class="btn btn-confirm">
                            <i class="fas fa-check-circle"></i> Xác Nhận Thanh Toán
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </body>
</html>
