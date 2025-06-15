<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN" />
<fmt:setBundle basename="messages" />

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
            .btn-back {
                background-color: #f8f9fa;
                color: #6c757d;
                border: 1px solid #dee2e6;
                padding: 8px 20px;
                border-radius: 8px;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .btn-back:hover {
                background-color: #e9ecef;
                color: #495057;
                border-color: #ced4da;
                transform: translateY(-2px);
            }

            .btn-back i {
                font-size: 14px;
            }

            /* QR Code Section */
            .qr-section {
                margin: 20px 0;
                padding: 20px;
                background: #fffaf5;
                border-radius: 15px;
                border: 2px dashed #D2691E;
                text-align: center;
            }

            .qr-code {
                max-width: 250px;
                margin: 0 auto 15px;
                border: 1px solid #eee;
                padding: 10px;
                background: white;
            }

            .bank-info {
                margin-top: 15px;
                padding: 15px;
                background: #fff0e0;
                border-radius: 10px;
                text-align: left;
            }

            .bank-info h5 {
                color: #D2691E;
                margin-bottom: 10px;
            }

            .bank-info p {
                margin-bottom: 5px;
            }

            .payment-instruction {
                margin-top: 20px;
                padding: 15px;
                background: #f8f5ff;
                border-radius: 10px;
            }

            .payment-instruction ol {
                padding-left: 20px;
                text-align: left;
            }

            .payment-instruction li {
                margin-bottom: 8px;
            }

            /* Hide/show payment methods */
            .payment-method-content {
                display: none;
            }

            .payment-method-content.active {
                display: block;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="payment-container">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <button onclick="window.history.back()" class="btn btn-back">
                        <i class="fas fa-arrow-left"></i> Quay lại
                    </button>
                    <h2 class="text-center mb-0 flex-grow-1"><i class="fas fa-paw pet-paw"></i> Thanh Toán Nâng Cấp Gói</h2>
                </div>

                <div class="package-card">
                    <h4><i class="fas fa-box-open"></i> Gói Đang Nâng Cấp</h4>
                    <hr>
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h3 class="text-warning">${pkg.name}</h3>
                            <p class="mb-1"><i class="fas fa-paw"></i> ${pkg.description}</p>
                        </div>
                        <div class="text-right">
                            <h3 class="text-danger"><fmt:formatNumber value="${pkg.price}" type="number" groupingUsed="true" />₫</h3>
                            <small class="text-muted">/Tháng</small>
                        </div>
                    </div>
                </div>

                <form id="paymentForm" action="package" method="post">
                    <input type="hidden" name="action" value="confirmPayment">
                    <input type="hidden" name="packageId" value="${pkg.id}">

                    <h4 class="mt-4 mb-3"><i class="fas fa-credit-card pet-paw"></i> Phương Thức Thanh Toán</h4>

                    <div class="payment-methods">
                        <label class="method" onclick="showPaymentMethod('momo')">
                            <input type="radio" name="paymentMethod" value="momo" checked>
                            <i class="fas fa-mobile-alt"></i>
                            <div>
                                <h5 class="mb-1">Ví MoMo</h5>
                                <p class="mb-0 text-muted">Thanh toán qua ứng dụng MoMo</p>
                            </div>
                        </label>

                        <label class="method" onclick="showPaymentMethod('bank')">
                            <input type="radio" name="paymentMethod" value="bank">
                            <i class="fas fa-university"></i>
                            <div>
                                <h5 class="mb-1">Chuyển Khoản Ngân Hàng</h5>
                                <p class="mb-0 text-muted">Chuyển khoản qua Internet Banking</p>
                            </div>
                        </label>
                    </div>

                    <!-- MoMo Payment Content -->
                    <div id="momoContent" class="payment-method-content active">
                        <div class="qr-section">
                            <h5><i class="fas fa-qrcode"></i> Quét mã QR để thanh toán qua MoMo</h5>
                            <img src="images/Momo.jpeg" alt="MoMo QR Code" class="qr-code img-fluid">
                            <div class="payment-instruction">
                                <h5><i class="fas fa-info-circle"></i> Hướng dẫn thanh toán:</h5>
                                <ol>
                                    <li>Mở ứng dụng MoMo trên điện thoại</li>
                                    <li>Chọn tính năng "Quét mã QR"</li>
                                    <li>Quét mã QR bên trên</li>
                                    <li>Kiểm tra thông tin thanh toán và xác nhận</li>
                                    <li>Nhấn nút "Xác nhận thanh toán" bên dưới sau khi hoàn tất</li>
                                </ol>
                            </div>
                        </div>
                    </div>

                    <!-- Bank Transfer Content -->
                    <div id="bankContent" class="payment-method-content">
                        <div class="qr-section">
                            <h5><i class="fas fa-university"></i> Thông tin chuyển khoản ngân hàng</h5>
                            <img src="images/MBbank.jpeg" alt="Bank QR Code" class="qr-code img-fluid">
                            <div class="bank-info">
                                <h5><i class="fas fa-info-circle"></i> Thông tin tài khoản:</h5>
                                <p><strong>Ngân hàng:</strong> MBbank</p>
                                <p><strong>Tên tài khoản:</strong> Vu Dieu Cam</p>
                                <p><strong>Số tài khoản:</strong> 0377728031</p>
                                <p><strong>Số tiền:</strong> <fmt:formatNumber value="${pkg.price}" type="number" groupingUsed="true" />₫</p>
                                <p><strong>Nội dung:</strong> PETTECH ${pkg.id} [Số điện thoại của bạn]</p>
                            </div>
                            <div class="payment-instruction">
                                <h5><i class="fas fa-info-circle"></i> Hướng dẫn thanh toán:</h5>
                                <ol>
                                    <li>Chuyển khoản chính xác số tiền như trên</li>
                                    <li>Ghi đúng nội dung chuyển khoản</li>
                                    <li>Giữ lại biên lai giao dịch</li>
                                    <li>Nhấn nút "Xác nhận thanh toán" bên dưới sau khi hoàn tất</li>
                                </ol>
                            </div>
                        </div>
                    </div>

                    <!-- COD Content -->
                    <div id="codContent" class="payment-method-content">
                        <div class="qr-section">
                            <h5><i class="fas fa-truck"></i> Thanh toán khi nhận dịch vụ</h5>
                            <div class="payment-instruction">
                                <p>Sau khi bạn xác nhận, nhân viên PetTech sẽ liên hệ với bạn trong vòng 24 giờ để xác nhận thông tin và hướng dẫn thanh toán.</p>
                                <p>Vui lòng chuẩn bị số tiền <strong><fmt:formatNumber value="${pkg.price}" type="number" groupingUsed="true" />₫</strong> để thanh toán khi nhận dịch vụ.</p>
                            </div>
                        </div>
                    </div>

                    <div class="d-flex justify-content-between mt-4">
                        <button type="submit" class="btn btn-confirm">
                            <i class="fas fa-check-circle"></i> Xác Nhận Thanh Toán
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            function showPaymentMethod(method) {
                // Hide all payment method contents
                document.querySelectorAll('.payment-method-content').forEach(content => {
                    content.classList.remove('active');
                });

                // Show selected payment method content
                document.getElementById(method + 'Content').classList.add('active');
            }

            document.getElementById('paymentForm').addEventListener('submit', function (e) {
                e.preventDefault(); // Ngăn submit mặc định

                // Kiểm tra phương thức thanh toán đã chọn
                const paymentMethod = document.querySelector('input[name="paymentMethod"]:checked');
                if (!paymentMethod) {
                    alert('Vui lòng chọn phương thức thanh toán');
                    return;
                }

                // Hiển thị loading
                const btn = document.querySelector('.btn-confirm');
                const originalText = btn.innerHTML;
                btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';
                btn.disabled = true;

                // Submit form
                this.submit();
            });
        </script>
    </body>
</html>