<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@ page import="model.User" %>
<%@ page import="dal.PackageDAO" %>
<%@ page import="dal.UserDAO" %>
<%@ page import="model.SendMailOK" %>
<%@ page import="java.util.UUID" %>
<%@ page import="javax.mail.MessagingException" %>

<%
    User pendingUser = (User) session.getAttribute("pendingUser");

    if (pendingUser != null) {
        UserDAO userDAO = new UserDAO();
        PackageDAO packageDAO = new PackageDAO();

        String token = UUID.randomUUID().toString();
        pendingUser.setVerificationToken(token);
        pendingUser.setStatus(false);
        pendingUser.setRoleId(1);

        if (userDAO.register(pendingUser)) {
            String verificationLink = request.getScheme() + "://"
                    + request.getServerName() + ":"
                    + request.getServerPort()
                    + request.getContextPath()
                    + "/authen?action=verify&token=" + token;

            String packageName = packageDAO.getServicePackageNameById(pendingUser.getServicePackageId());

            String emailBody = "<!DOCTYPE html>"
                    + "<html lang='vi'>"
                    + "<head><meta charset='UTF-8'><style>"
                    + "body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #fffaf4; color: #333; padding: 20px; }"
                    + ".container { max-width: 600px; margin: auto; background-color: #fff; border-radius: 12px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); padding: 20px; }"
                    + "h2 { color: #ff6600; }"
                    + ".button { display: inline-block; background-color: #ff9966; color: white; padding: 10px 20px; border-radius: 8px; text-decoration: none; font-weight: bold; }"
                    + ".footer { font-size: 13px; color: #888; margin-top: 30px; line-height: 1.6; }"
                    + ".footer strong { color: #555; }"
                    + "</style></head>"
                    + "<body><div class='container'>"
                    + "<h2>🎉 Chào mừng bạn đến với PetTech! 🐾</h2>"
                    + "<p>Xin chào <strong>" + pendingUser.getFullname() + "</strong>,</p>"
                    + "<p>Bạn đã đăng ký gói <strong>" + packageName + "</strong>.</p>"
                    + "<p>Vui lòng xác minh tài khoản tại liên kết sau:</p>"
                    + "<p><a class='button' href='" + verificationLink + "'>🔐 Xác minh tài khoản</a></p>"
                    + "<div class='footer'>📞 Hỗ trợ: 0352 138 596<br>❤️ PetTech Team</div>"
                    + "</div></body></html>";

            try {
                SendMailOK.send(
                        "smtp.gmail.com",
                        pendingUser.getEmail(),
                        "vdc120403@gmail.com",
                        "ednn nwbo zbyq gahs",
                        "Xác minh tài khoản PetTech",
                        emailBody
                );
                session.setAttribute("notification", "Đăng ký thành công! Vui lòng kiểm tra email để kích hoạt tài khoản.");
            } catch (MessagingException ex) {
                session.setAttribute("error", "Gửi email thất bại: " + ex.getMessage());
            }

            session.removeAttribute("pendingUser");
            session.removeAttribute("oldEmail");
            session.removeAttribute("oldFullname");
            session.removeAttribute("oldPhone");

%>
<meta http-equiv="refresh" content="5; URL=authen?action=login" />
<%        } else {
            session.setAttribute("error", "Đăng ký thất bại. Vui lòng thử lại.");
            response.sendRedirect("signup.jsp?packageId=" + pendingUser.getServicePackageId());
            return;
        }
    }
%>

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
                <%-- Gửi thông báo về login.jsp --%>
                <%
                    session.setAttribute("notification", "Đăng ký thành công! Vui lòng kiểm tra email để kích hoạt tài khoản.");
                %>
                <meta http-equiv="refresh" content="5; URL=authen?action=login" />
                <h2><i class="fas fa-paw pet-paw"></i> Thanh Toán Thành Công!</h2>
                <p class="lead">Cảm ơn bạn đã nâng cấp gói dịch vụ tại PetTech</p>

                <div class="success-message">
                    <h3>${successMessage}</h3>
                    <p>Tên gói: ${pkg.name}</p>
                    <p>Mô tả: ${pkg.description}</p>
                    <p>Giá: ${pkg.price}₫</p>
                    <p>Phương thức thanh toán: 
                        <c:choose>
                            <c:when test="${paymentMethod == 'momo'}">Ví MoMo</c:when>
                            <c:when test="${paymentMethod == 'bank'}">Chuyển khoản ngân hàng</c:when>
                            <c:otherwise>Thanh toán khi nhận dịch vụ</c:otherwise>
                        </c:choose>
                    </p>
                </div>

                <p>Bạn có thể bắt đầu sử dụng các tính năng mới ngay bây giờ!</p>

                <a href="authen?action=login" class="btn btn-back">
                    <i class="fas fa-home"></i> Quay Về Trang Gói Dịch Vụ
                </a>
            </div>
        </div>
    </body>
</html>