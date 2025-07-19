<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page import="java.util.Date" %>


<!DOCTYPE html>
<html lang="vi">
    <head>

        <meta charset="UTF-8">
        <link rel="icon" type="image/png" href="images/logo_pettech.jpg">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>PetTech Admin Dashboard</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
        <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <style>
            :root {
                --primary-color: #4361ee;
                --secondary-color: #3f37c9;
                --accent-color: #4895ef;
                --dark-color: #1b263b;
                --light-color: #f8f9fa;
                --success-color: #4cc9f0;
                --warning-color: #f8961e;
                --danger-color: #f94144;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: #f5f7fa;
            }

            .sidebar {
                min-height: 100vh;
                background: linear-gradient(135deg, var(--dark-color), var(--secondary-color));
                color: white;
                box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
                transition: all 0.3s;
                display: flex;
                flex-direction: column;
            }

            .sidebar .nav-link {
                color: rgba(255, 255, 255, 0.8);
                border-radius: 5px;
                margin: 5px 10px;
                padding: 10px 15px;
                transition: all 0.3s;
            }

            .sidebar .nav-link:hover,
            .sidebar .nav-link.active {
                color: white;
                background-color: rgba(255, 255, 255, 0.15);
                transform: translateX(5px);
            }

            .sidebar .nav-link i {
                margin-right: 10px;
                font-size: 1.1rem;
            }

            .sidebar-brand {
                padding: 20px;
                display: flex;
                align-items: center;
                justify-content: center;
                border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            }

            .sidebar-brand img {
                height: 40px;
                margin-right: 10px;
            }

            .stat-card {
                border-radius: 15px;
                transition: all 0.3s;
                border: none;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
                overflow: hidden;
                position: relative;
                z-index: 1;
            }

            .stat-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 15px rgba(0, 0, 0, 0.1);
            }

            .stat-card::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: linear-gradient(135deg, rgba(255,255,255,0.2), transparent);
                z-index: -1;
            }

            .card {
                border: none;
                border-radius: 15px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
                transition: all 0.3s;
            }

            .card:hover {
                box-shadow: 0 10px 15px rgba(0, 0, 0, 0.1);
            }

            .card-header {
                background-color: white;
                border-bottom: 1px solid rgba(0, 0, 0, 0.05);
                border-radius: 15px 15px 0 0 !important;
                padding: 15px 20px;
            }

            .table-responsive {
                border-radius: 15px;
                overflow: hidden;
            }

            .table {
                margin-bottom: 0;
            }

            .table th {
                background-color: var(--light-color);
                border-top: none;
                font-weight: 600;
                color: var(--dark-color);
            }

            .table td {
                vertical-align: middle;
                border-top: 1px solid rgba(0, 0, 0, 0.03);
            }

            .badge {
                padding: 6px 10px;
                font-weight: 500;
                border-radius: 8px;
            }

            .btn-primary {
                background-color: var(--primary-color);
                border-color: var(--primary-color);
            }

            .btn-primary:hover {
                background-color: var(--secondary-color);
                border-color: var(--secondary-color);
            }

            .filter-section {
                background-color: white;
                border-radius: 15px;
                padding: 15px;
                margin-bottom: 20px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            }

            .filter-title {
                font-weight: 600;
                margin-bottom: 15px;
                color: var(--dark-color);
            }

            .select2-container--default .select2-selection--multiple {
                border: 1px solid #ced4da;
                border-radius: 8px;
                min-height: 38px;
            }

            .select2-container--default .select2-selection--multiple .select2-selection__choice {
                background-color: var(--primary-color);
                border: none;
                border-radius: 6px;
                color: white;
            }

            .user-avatar {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                object-fit: cover;
                margin-right: 10px;
            }

            .action-btn {
                width: 30px;
                height: 30px;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                border-radius: 8px;
                margin: 0 3px;
                transition: all 0.2s;
            }

            .action-btn:hover {
                transform: scale(1.1);
            }

            .status-badge {
                padding: 5px 10px;
                border-radius: 8px;
                font-size: 0.8rem;
                font-weight: 500;
            }

            .status-active {
                background-color: rgba(40, 167, 69, 0.1);
                color: #28a745;
            }

            .status-inactive {
                background-color: rgba(220, 53, 69, 0.1);
                color: #dc3545;
            }

            .status-pending {
                background-color: rgba(255, 193, 7, 0.1);
                color: #ffc107;
            }

            .tab-content {
                padding: 0 5px;
            }

            .chart-container {
                position: relative;
                height: 250px;
            }

            .progress-thin {
                height: 6px;
                border-radius: 3px;
            }

            /* Animation */
            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(10px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .animate-fade {
                animation: fadeIn 0.5s ease-out forwards;
            }

            /* Admin Profile */
            .admin-profile {
                margin-top: auto;
                padding: 15px;
                border-top: 1px solid rgba(255, 255, 255, 0.1);
            }

            .admin-profile .dropdown-toggle {
                display: flex;
                align-items: center;
                width: 100%;
                color: white;
                text-decoration: none;
                padding: 10px;
                border-radius: 8px;
                transition: all 0.3s;
            }

            .admin-profile .dropdown-toggle:hover {
                background-color: rgba(255, 255, 255, 0.15);
            }

            .admin-profile .dropdown-toggle::after {
                margin-left: auto;
            }

            .admin-profile .dropdown-menu {
                width: 100%;
                border: none;
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
                border-radius: 8px;
                overflow: hidden;
            }

            .admin-profile .dropdown-item {
                padding: 10px 15px;
                color: var(--dark-color);
            }

            .admin-profile .dropdown-item:hover {
                background-color: rgba(67, 97, 238, 0.1);
                color: var(--primary-color);
            }

            .admin-profile .dropdown-item.logout {
                color: var(--danger-color);
            }

            .admin-profile .dropdown-item.logout:hover {
                background-color: rgba(249, 65, 68, 0.1);
            }

            .admin-avatar {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                object-fit: cover;
                margin-right: 10px;
                border: 2px solid rgba(255, 255, 255, 0.3);
            }

            .admin-info {
                line-height: 1.2;
            }

            .admin-name {
                font-weight: 600;
                font-size: 0.95rem;
            }

            .admin-role {
                font-size: 0.8rem;
                opacity: 0.8;
            }

            /* Responsive */
            @media (max-width: 768px) {
                .sidebar {
                    position: fixed;
                    z-index: 1000;
                    width: 250px;
                    transform: translateX(-100%);
                }

                .sidebar.show {
                    transform: translateX(0);
                }

                .main-content {
                    margin-left: 0;
                }

                .navbar-toggler {
                    display: block;
                }

                .admin-profile {
                    margin-top: 20px;
                }
            }
            /* Thêm vào phần style */
            .table th {
                position: relative;
                cursor: pointer;
                padding-right: 30px !important;
            }

            .sort-icon {
                position: absolute;
                right: 8px;
                top: 50%;
                transform: translateY(-50%);
                color: #6c757d;
                font-size: 0.8rem;
            }

            .sort-icon:hover {
                color: var(--primary-color);
            }

            .column-search {
                margin-top: 5px;
                width: 100% !important;
            }

            .dataTables_wrapper .dataTables_filter input {
                margin-left: 0.5em;
                border: 1px solid #dee2e6;
                border-radius: 4px;
                padding: 5px 10px;
            }

            .dataTables_wrapper .dataTables_length select {
                border: 1px solid #dee2e6;
                border-radius: 4px;
                padding: 5px;
            }
            /* Thêm vào phần CSS */
            .form-control[readonly] {
                background-color: #f8f9fa;
                border-color: #e9ecef;
                cursor: not-allowed;
            }

            /*bổ sung cho table*/
            /* Animation cho thẻ thống kê */
            .stat-card {
                transition: all 0.3s ease;
                border-left: 4px solid transparent;
            }

            .stat-card:hover {
                transform: translateY(-3px);
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            }

            .stat-card.bg-primary {
                border-left-color: #3a0ca3;
            }

            .stat-card.bg-success {
                border-left-color: #2d6a4f;
            }

            .stat-card.bg-warning {
                border-left-color: #f8961e;
            }

            .stat-card.bg-danger {
                border-left-color: #d00000;
            }

            /* Biểu đồ */
            .chart-container {
                position: relative;
                height: 300px;
                min-height: 300px;
            }

            /* Bảng */
            .table th {
                position: relative;
                white-space: nowrap;
            }

            .table td {
                vertical-align: middle;
            }

            /* Progress bar mỏng */
            .progress-thin {
                height: 6px;
                border-radius: 3px;
            }

            /* Responsive */
            @media (max-width: 768px) {
                .chart-container {
                    height: 250px;
                }

                .stat-card {
                    margin-bottom: 15px;
                }
            }
            /* New styles for improved dashboard */
            .dashboard-section {
                margin-bottom: 30px;
            }

            .section-title {
                font-weight: 600;
                color: var(--dark-color);
                margin-bottom: 20px;
                padding-bottom: 10px;
                border-bottom: 1px solid rgba(0, 0, 0, 0.1);
            }

            .stat-card {
                border-radius: 12px;
                transition: all 0.3s;
                border: none;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
                overflow: hidden;
                margin-bottom: 20px;
                height: 100%;
            }

            .stat-card .card-body {
                padding: 20px;
            }

            .stat-card .card-title {
                font-size: 0.9rem;
                font-weight: 600;
                color: rgba(255, 255, 255, 0.8);
                margin-bottom: 10px;
            }

            .stat-card .card-value {
                font-size: 1.8rem;
                font-weight: 700;
                color: white;
                margin-bottom: 5px;
            }

            .stat-card .card-change {
                font-size: 0.85rem;
                display: flex;
                align-items: center;
            }

            .stat-card .card-change.positive {
                color: rgba(255, 255, 255, 0.8);
            }

            .stat-card .card-change.negative {
                color: rgba(255, 255, 255, 0.8);
            }

            .chart-card {
                border-radius: 12px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
                border: none;
                margin-bottom: 20px;
                height: 100%;
            }

            .chart-card .card-header {
                background-color: white;
                border-bottom: 1px solid rgba(0, 0, 0, 0.05);
                border-radius: 12px 12px 0 0 !important;
                padding: 15px 20px;
                font-weight: 600;
            }

            .chart-card .card-body {
                padding: 20px;
            }

            .chart-container {
                position: relative;
                height: 300px;
                width: 100%;
            }

            .table-card {
                border-radius: 12px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
                border: none;
                margin-bottom: 20px;
            }

            .table-card .card-header {
                background-color: white;
                border-bottom: 1px solid rgba(0, 0, 0, 0.05);
                border-radius: 12px 12px 0 0 !important;
                padding: 15px 20px;
                font-weight: 600;
            }

            .table-card .table {
                margin-bottom: 0;
            }

            .table-card .table th {
                background-color: #f8f9fa;
                border-top: none;
                font-weight: 600;
                white-space: nowrap;
            }

            .table-card .table td {
                vertical-align: middle;
            }

            .badge-pill {
                border-radius: 10px;
                padding: 5px 10px;
                font-weight: 500;
            }

            .time-filter {
                display: flex;
                gap: 10px;
                margin-bottom: 20px;
            }

            .time-filter .btn {
                border-radius: 8px;
                font-weight: 500;
                padding: 5px 15px;
            }

            .time-filter .btn.active {
                background-color: var(--primary-color);
                color: white;
            }


            /* css update bieu do thong ke*/
            .time-filter {
                display: flex;
                gap: 8px;
            }

            .time-filter .btn {
                border-radius: 20px;
                padding: 2px 12px;
                font-size: 0.8rem;
                border: 1px solid #dee2e6;
            }

            .time-filter .btn.active {
                background-color: #4361ee;
                color: white;
                border-color: #4361ee;
            }

            /* Cải thiện card thống kê */
            .stat-card {
                border-left: 4px solid;
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }

            .stat-card.bg-primary {
                border-left-color: #3a0ca3;
            }
            .stat-card.bg-success {
                border-left-color: #2d6a4f;
            }
            .stat-card.bg-info {
                border-left-color: #1a759f;
            }
            .stat-card.bg-warning {
                border-left-color: #f8961e;
            }
            .stat-card.bg-danger {
                border-left-color: #d00000;
            }

            .stat-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 20px rgba(0,0,0,0.1) !important;
            }

            /* Cải thiện biểu đồ */
            .chart-card .card-header {
                font-weight: 600;
                color: var(--dark-color);
                background-color: white !important;
            }

            .chart-container {
                position: relative;
                height: 300px;
                min-height: 300px;
            }

            /* Hiệu ứng hover cho bảng */
            .table-hover tbody tr {
                transition: background-color 0.2s;
            }

            .table-hover tbody tr:hover {
                background-color: rgba(67, 97, 238, 0.05);
            }

            /* Cải thiện nút lọc thời gian */
            .time-filter .btn {
                transition: all 0.3s;
            }

            .time-filter .btn.active {
                background-color: var(--primary-color);
                color: white;
                box-shadow: 0 2px 5px rgba(67, 97, 238, 0.3);
            }

            /* Responsive cho các card */
            @media (max-width: 768px) {
                .stat-card {
                    margin-bottom: 15px;
                }

                .chart-container {
                    height: 250px;
                }
            }
            .status-badge {
                padding: 4px 8px;
                border-radius: 6px;
                font-size: 0.85rem;
                font-weight: 500;
            }
            .status-active {
                background-color: #d1e7dd;
                color: #0f5132;
            }
            .status-inactive {
                background-color: #f8d7da;
                color: #842029;
            }

        </style>
    </head>
    <body>

        <div class="container-fluid">
            <div class="row">
                <!-- Sidebar -->
                <div class="col-md-2 sidebar p-0">
                    <div class="sidebar-brand">
                        <img src="${pageContext.request.contextPath}/images/logo_pettech.jpg" alt="Logo">
                        <h4 class="mb-0">PetTech</h4>
                    </div>
                    <ul class="nav flex-column mt-3">
                        <li class="nav-item">
                            <a class="nav-link active" href="${pageContext.request.contextPath}/admin">
                                <i class="bi bi-speedometer2"></i>Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/useradmin">
                                <i class="bi bi-people"></i>Người dùng
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/courseadmin">
                                <i class="bi bi-book"></i>Khóa học
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/blogadmin">
                                <i class="bi bi-newspaper"></i>Tin tức
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/packageadmin">
                                <i class="bi bi-newspaper"></i>Gói dịch vụ
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/paymentadmin">
                                <i class="bi bi-credit-card"></i>Thanh toán
                            </a>
                        </li>

                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/partneradmin">
                                <i class="bi bi-building"></i>Đối tác
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/petadmin">
                                <i class="bi bi-building"></i>Thú cưng
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/productsAdmin.jsp">
                                <i class="bi bi-cart"></i>Sản phẩm
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/ordersAdmin.jsp">
                                <i class="bi bi-receipt"></i>Đơn hàng
                            </a>
                        </li>
                        <li class="nav-item" >
                            <a class="nav-link" href="${pageContext.request.contextPath}/reports.jsp">
                                <i class="bi bi-graph-up"></i>Báo cáo
                            </a>
                        </li>
                        <li class="nav-item">
                            <div class="admin-profile">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.user}">
                                        <div class="dropdown">
                                            <a href="#" class="dropdown-toggle d-flex align-items-center" data-bs-toggle="dropdown" aria-expanded="false">

                                                <div class="admin-info text-start">
                                                    <div class="admin-name fw-bold">${sessionScope.user.fullname}</div>
                                                    <div class="admin-role text-muted">
                                                        <c:choose>
                                                            <c:when test="${sessionScope.user.roleId == 1}">Khách hàng</c:when>
                                                            <c:when test="${sessionScope.user.roleId == 2}">Nhân viên</c:when>
                                                            <c:when test="${sessionScope.user.roleId == 3}">Quản trị viên</c:when>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                            </a>
                                            <ul class="dropdown-menu dropdown-menu-end">
                                                <li><a class="dropdown-item" href="authen?action=editprofile">
                                                        <i class="bi bi-person me-2"></i>Thông tin cá nhân
                                                    </a></li>
                                                <li><a class="dropdown-item" href="home">
                                                        <i class="bi bi-house-door me-2"></i>Trang Chủ
                                                    </a></li>
                                                <li><hr class="dropdown-divider"></li>

                                                <li><a class="dropdown-item text-danger" href="authen?action=logout">
                                                        <i class="bi bi-box-arrow-right me-2"></i>Đăng xuất
                                                    </a></li>
                                            </ul>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="authen?action=login" class="login-link d-flex align-items-center me-3">
                                            <i class="fa fa-sign-in me-2"></i>
                                            <span>Đăng Nhập</span>
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </li>
                    </ul>
                </div><!-- comment -->


                <!-- Main Content -->
                <div class="col-md-10 p-4">
                    <div class="container mt-4">
                        <c:choose>
                            <c:when test="${empty sessionScope.user || (sessionScope.user.roleId ne 2 && sessionScope.user.roleId ne 3)}">
                                <div class="alert alert-danger">
                                    Bạn không có quyền truy cập. Vui lòng <a href="${pageContext.request.contextPath}/authen?action=login">đăng nhập</a> bằng tài khoản quản trị.
                                </div>
                            </c:when>
                            <c:otherwise>
                                <h1 class="mb-4">Quản lý Hệ thống</h1>

                                <div class="container-fluid mt-4">

                                    <!-- ====== USERS ====== -->
                                    <h2 class="mb-3">
                                        👥 <a href="${pageContext.request.contextPath}/useradmin" class="text-decoration-none text-dark">
                                            Người dùng
                                        </a> (Tổng: ${fn:length(users)})
                                    </h2>


                                    <div class="card mb-5">
                                        <div class="card-body p-0">
                                            <div class="table-responsive">
                                                <table class="table table-hover mb-0">
                                                    <thead class="table-light">
                                                        <tr>
                                                            <th>ID</th>
                                                            <th>Thông tin</th>
                                                            <th>Vai trò</th>
                                                            <th>Địa chỉ</th>
                                                            <th>Trạng thái</th>
                                                            <th>Ngày tạo</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach var="user" items="${users}" varStatus="loop">
                                                            <c:if test="${loop.index < 10}">
                                                                <tr>
                                                                    <td>${user.id}</td>
                                                                    <td>
                                                                        <div class="d-flex align-items-center">
                                                                            <img src="https://ui-avatars.com/api/?name=${user.fullname}&background=random" class="user-avatar me-2">
                                                                            <div>
                                                                                <h6 class="mb-0">${user.fullname}</h6>
                                                                                <small class="text-muted">${user.email}</small>
                                                                            </div>
                                                                        </div>
                                                                    </td>
                                                                    <td>
                                                                        <c:choose>
                                                                            <c:when test="${user.roleId == 1}">
                                                                                <span class="badge bg-primary">Khách hàng</span>
                                                                            </c:when>
                                                                            <c:when test="${user.roleId == 2}">
                                                                                <span class="badge bg-warning text-dark">Nhân viên</span>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <span class="badge bg-danger">Admin</span>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </td>
                                                                    <td>${user.address}</td>
                                                                    <td>
                                                                        <span class="status-badge ${user.status ? 'status-active' : 'status-inactive'}">
                                                                            ${user.status ? 'Hoạt động' : 'Không hoạt động'}
                                                                        </span>
                                                                    </td>
                                                                    <td>${user.createdAt}</td>
                                                                </tr>
                                                            </c:if>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- ====== COURSES ====== -->
                                    <h2 class="mb-3">
                                        📚 <a href="${pageContext.request.contextPath}/courseadmin" class="text-decoration-none text-dark">
                                            Khóa học
                                        </a> (Tổng: ${fn:length(courses)})
                                    </h2>


                                    <div class="card mb-5">
                                        <div class="card-body p-0">
                                            <div class="table-responsive">
                                                <table class="table table-hover mb-0">
                                                    <thead class="table-light">
                                                        <tr>
                                                            <th>ID</th>
                                                            <th>Tên khóa học</th>
                                                            <th>Giảng viên</th>
                                                            <th>Danh mục</th>
                                                            <th>Thời lượng</th>
                                                            <th>Trạng thái</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach var="c" items="${courses}" varStatus="loop">
                                                            <c:if test="${loop.index < 10}">
                                                                <tr>
                                                                    <td>${c.id}</td>
                                                                    <td>
                                                                        <strong>${c.title}</strong><br/>
                                                                        <a href="${pageContext.request.contextPath}/coursedetailadmin?courseId=${c.id}" class="btn btn-sm btn-link p-0 mt-1">
                                                                            Quản lý Module & Lesson
                                                                        </a>
                                                                    </td>
                                                                    <td>${c.researcher}</td>
                                                                    <td>
                                                                        <c:forEach items="${c.categories}" var="cat">
                                                                            <span class="badge bg-info">${cat.name}</span>
                                                                        </c:forEach>
                                                                    </td>
                                                                    <td>${c.duration}</td>
                                                                    <td>
                                                                        <span class="badge ${c.status == 1 ? 'bg-success' : 'bg-secondary'}">
                                                                            ${c.status == 1 ? 'Hoạt động' : 'Không hoạt động'}
                                                                        </span>
                                                                    </td>
                                                                </tr>
                                                            </c:if>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- ====== PACKAGES ====== -->
                                    <h2 class="mb-3">
                                        📦 <a href="${pageContext.request.contextPath}/packageadmin" class="text-decoration-none text-dark">
                                            Gói dịch vụ
                                        </a> (Tổng: ${fn:length(packages)})
                                    </h2>


                                    <div class="card mb-5">
                                        <div class="card-body p-0">
                                            <div class="table-responsive">
                                                <table class="table table-hover mb-0">
                                                    <thead class="table-light">
                                                        <tr>
                                                            <th>ID</th>
                                                            <th>Tên gói</th>
                                                            <th>Giá</th>
                                                            <th>Loại</th>
                                                            <th>Trạng thái</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach var="pkg" items="${packages}" varStatus="loop">
                                                            <c:if test="${loop.index < 10}">
                                                                <tr>
                                                                    <td>${pkg.id}</td>
                                                                    <td>${pkg.name}</td>
                                                                    <td><fmt:formatNumber value="${pkg.price}" type="number" groupingUsed="true"/>₫</td>
                                                                    <td>${pkg.type}</td>
                                                                    <td>
                                                                        <span class="badge ${pkg.status ? 'bg-success' : 'bg-secondary'}">
                                                                            ${pkg.status ? 'Hiển thị' : 'Ẩn'}
                                                                        </span>
                                                                    </td>
                                                                </tr>
                                                            </c:if>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
    <!-- Script chính vẽ biểu đồ -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</body>
</html>