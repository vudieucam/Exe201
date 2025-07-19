<%-- 
    Document   : cancel_payment
    Created on : Jul 10, 2025, 5:07:40 PM
    Author     : FPT
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thmeleaf.org">
<head>
    <!-- Google tag (gtag.js) -->
        <script async src="https://www.googletagmanager.com/gtag/js?id=G-3BE5RLS31D"></script>
        <script>
            window.dataLayer = window.dataLayer || [];
            function gtag() {
                dataLayer.push(arguments);
            }
            gtag('js', new Date());

            gtag('config', 'G-3BE5RLS31D');
        </script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán thất bại</title>
    <link rel="stylesheet" href="" th:href="@{/css/style.css}">
</head>
<body>
    <div class="main-box">
        <h4 class="payment-titlte">Thanh toán thất bại</h4>
        <p>Nếu có bất kỳ câu hỏi nào, hãy gửi email tới <a href="mailto:support@payos.vn">support@payos.vn</a></p>
        <a href="/" id="return-page-btn">Trở về trang Tạo Link thanh toán</a>
    </div>
    <script src="script.js"></script>
</body>
</html>