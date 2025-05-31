<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Chờ Xác nhận Thanh toán</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            text-align: center;
            padding: 50px;
        }
        .container {
            background-color: white;
            border-radius: 10px;
            padding: 30px;
            max-width: 600px;
            margin: 0 auto;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .success-icon {
            color: #FFA500;
            font-size: 50px;
            margin-bottom: 20px;
        }
        .confirmation-code {
            background-color: #FFF8DC;
            padding: 10px;
            border-radius: 5px;
            font-size: 18px;
            margin: 20px 0;
            display: inline-block;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="success-icon">
            <i class="fas fa-clock"></i>
        </div>
        <h2>Thanh toán của bạn đang chờ xác nhận</h2>
        <p>Chúng tôi đã nhận được yêu cầu thanh toán của bạn và đang chờ xác nhận từ quản trị viên.</p>
        
        <p>Mã xác nhận của bạn:</p>
        <div class="confirmation-code">
            ${confirmationCode}
        </div>
        
        <p>Vui lòng kiểm tra email <strong>${sessionScope.user.email}</strong> để theo dõi tiến trình xác nhận.</p>
        <p>Bạn sẽ nhận được email thông báo khi thanh toán được xác nhận thành công.</p>
        
        <p>Nếu bạn có bất kỳ câu hỏi nào, vui lòng liên hệ với bộ phận hỗ trợ khách hàng của chúng tôi.</p>
        
        <a href="home" class="btn btn-primary">Về Trang chủ</a>
    </div>
</body>
</html>