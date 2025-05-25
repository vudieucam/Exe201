<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Thanh Toán Thành Công - PetTech</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <style>
        body {
            background-color: #FFF8DC;
            font-family: 'Comic Neue', cursive, sans-serif;
        }
        
        .success-container {
            max-width: 600px;
            margin: 50px auto;
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(210, 105, 30, 0.1);
            padding: 30px;
            text-align: center;
            border: 3px solid #4CAF50;
        }
        
        .success-icon {
            font-size: 5rem;
            color: #4CAF50;
            margin-bottom: 20px;
        }
        
        .package-info {
            background: #FFF8DC;
            border-radius: 15px;
            padding: 20px;
            margin: 20px 0;
            border-left: 5px solid #D2691E;
        }
        
        .btn-back {
            background: #D2691E;
            color: white;
            border: none;
            border-radius: 30px;
            padding: 12px 30px;
            font-size: 1.1rem;
            font-weight: bold;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
            margin-top: 20px;
        }
        
        .btn-back:hover {
            background: #FF8C00;
            transform: scale(1.05);
            color: white;
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
        <div class="success-container">
            <div class="success-icon">
                <i class="fas fa-check-circle"></i>
            </div>
            
            <h2><i class="fas fa-paw pet-paw"></i> Thanh Toán Thành Công!</h2>
            <p class="lead">Cảm ơn bạn đã nâng cấp gói dịch vụ tại PetTech</p>
            
            <div class="package-info">
                <h4><i class="fas fa-box-open"></i> Gói Dịch Vụ Mới</h4>
                <h3 class="text-warning">${pkg.name}</h3>
                <p><i class="fas fa-paw"></i> ${pkg.description}</p>
                <h4 class="text-success">${pkg.price}₫</h4>
                
                <hr>
                
                <p><i class="fas fa-credit-card"></i> Phương thức thanh toán: 
                <span class="font-weight-bold">
                    <c:choose>
                        <c:when test="${paymentMethod == 'momo'}">Ví MoMo</c:when>
                        <c:when test="${paymentMethod == 'bank'}">Chuyển khoản ngân hàng</c:when>
                        <c:otherwise>Thanh toán khi nhận dịch vụ</c:otherwise>
                    </c:choose>
                </span></p>
            </div>
            
            <p>Bạn có thể bắt đầu sử dụng các tính năng mới ngay bây giờ!</p>
            
            <a href="authen?action=login" class="btn btn-back">
                <i class="fas fa-home"></i> Quay Về Trang Gói Dịch Vụ
            </a>
        </div>
    </div>
</body>
</html>