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
                        <li class="nav-item" hidden="">
                            <a class="nav-link" href="${pageContext.request.contextPath}/productsAdmin.jsp">
                                <i class="bi bi-cart"></i>Sản phẩm
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/ordersAdmin.jsp">
                                <i class="bi bi-receipt"></i>Đơn hàng
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/paymentadmin">
                                <i class="bi bi-credit-card"></i>Thanh toán
                            </a>
                        </li>

                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/partnersAdmin.jsp">
                                <i class="bi bi-building"></i>Đối tác
                            </a>
                        </li>
                        <li class="nav-item" hidden="">
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
                                <h1 class="mb-4">Dashboard Quản Trị</h1>

                                <!-- Thống kê tổng quan -->
                                <div class="dashboard-section">
                                    <h4 class="section-title">Tổng quan hệ thống</h4>
                                    <div class="row">
                                        <div class="col-md-3">
                                            <div class="card stat-card bg-primary">
                                                <div class="card-body">
                                                    <h5 class="card-title">Người dùng Online</h5>
                                                    <p class="card-value">${stats.onlineUsers}</p>
                                                    <div class="card-change ${stats.userGrowth >= 0 ? 'positive' : 'negative'}">
                                                        <i class="bi bi-arrow-${stats.userGrowth >= 0 ? 'up' : 'down'}"></i> 
                                                        <fmt:formatNumber value="${Math.abs(stats.userGrowth)}" pattern="#,##0.0"/>% so với tháng trước
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="card stat-card bg-success">
                                                <div class="card-body">
                                                    <h5 class="card-title">Tổng người dùng</h5>
                                                    <p class="card-value">${stats.totalUsers}</p>
                                                    <div class="card-change ${stats.userGrowth >= 0 ? 'positive' : 'negative'}">
                                                        <i class="bi bi-arrow-${stats.userGrowth >= 0 ? 'up' : 'down'}"></i> 
                                                        <fmt:formatNumber value="${Math.abs(stats.userGrowth)}" pattern="#,##0.0"/>% so với tháng trước
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="card stat-card bg-info">
                                                <div class="card-body">
                                                    <h5 class="card-title">Người dùng hoạt động</h5>
                                                    <p class="card-value">${stats.activeUsers}</p>
                                                    <div class="card-change ${stats.userGrowth >= 0 ? 'positive' : 'negative'}">
                                                        <i class="bi bi-arrow-${stats.userGrowth >= 0 ? 'up' : 'down'}"></i> 
                                                        <fmt:formatNumber value="${Math.abs(stats.userGrowth)}" pattern="#,##0.0"/>% so với tháng trước
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="card stat-card bg-warning">
                                                <div class="card-body">
                                                    <h5 class="card-title">Doanh thu tháng</h5>
                                                    <p class="card-value"><fmt:formatNumber value="${stats.monthlyRevenue}" type="currency" currencySymbol="₫"/></p>
                                                    <div class="card-change positive">
                                                        <i class="bi bi-arrow-up"></i> 
                                                        <fmt:formatNumber value="${stats.monthlyRevenue.doubleValue() / stats.totalRevenue.doubleValue() * 100}" pattern="#,##0.0"/>% tổng doanh thu
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Chỉ số hiệu suất kỹ thuật -->
                                <div class="dashboard-section">
                                    <h4 class="section-title">Hiệu suất kỹ thuật</h4>
                                    <div class="row">
                                        <div class="col-md-3">
                                            <div class="card stat-card bg-info">
                                                <div class="card-body">
                                                    <h5 class="card-title">Thời gian tải trang (s)</h5>
                                                    <p class="card-value"><fmt:formatNumber value="${stats.pageLoadTime}" maxFractionDigits="2"/></p>
                                                    <div class="progress progress-thin mt-2">
                                                        <div class="progress-bar bg-white" 
                                                             style="width: ${100 - (stats.pageLoadTime * 20)}%"></div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="card stat-card bg-primary">
                                                <div class="card-body">
                                                    <h5 class="card-title">Phản hồi máy chủ (ms)</h5>
                                                    <p class="card-value"><fmt:formatNumber value="${stats.serverResponseTime}" maxFractionDigits="0"/></p>
                                                    <div class="progress progress-thin mt-2">
                                                        <div class="progress-bar bg-white" 
                                                             style="width: ${100 - (stats.serverResponseTime / 10)}%"></div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="card stat-card bg-warning">
                                                <div class="card-body">
                                                    <h5 class="card-title">Tỉ lệ lỗi</h5>
                                                    <p class="card-value"><fmt:formatNumber value="${stats.errorRate}" type="percent" maxFractionDigits="1"/></p>
                                                    <div class="progress progress-thin mt-2">
                                                        <div class="progress-bar bg-white" 
                                                             style="width: ${stats.errorRate * 100}%"></div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="card stat-card bg-danger">
                                                <div class="card-body">
                                                    <h5 class="card-title">Tỉ lệ thoát</h5>
                                                    <p class="card-value"><fmt:formatNumber value="${stats.bounceRate}" type="percent" maxFractionDigits="1"/></p>
                                                    <div class="progress progress-thin mt-2">
                                                        <div class="progress-bar bg-white" 
                                                             style="width: ${stats.bounceRate * 100}%"></div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- TƯƠNG TÁC NGƯỜI DÙNG -->
                                <div class="dashboard-section">
                                    <h4 class="section-title">Tương tác người dùng</h4>
                                    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4">
                                        <!-- Tỉ lệ nhấp chuột (CTR) -->
                                        <div class="col">
                                            <div class="card chart-card h-100">
                                                <div class="card-header d-flex justify-content-between align-items-center">
                                                    <span><strong>CTR</strong></span>
                                                    <span class="badge bg-primary bg-opacity-10 text-primary">
                                                        <i class="bi bi-arrow-up"></i>
                                                        <fmt:formatNumber value="${stats.clickThroughRate * 100}" pattern="#,##0.0"/>%
                                                    </span>
                                                </div>
                                                <div class="card-body p-2">
                                                    <div class="d-flex align-items-center">
                                                        <div class="text-center flex-shrink-0 me-3" style="width: 80px;">
                                                            <h4 class="mb-0">
                                                                <fmt:formatNumber value="${stats.clickThroughRate * 100}" pattern="#,##0.0"/>%
                                                            </h4>
                                                            <small class="text-muted">Hiện tại</small>
                                                        </div>
                                                        <div class="flex-grow-1">
                                                            <canvas id="ctrChart" style="height: 60px;"></canvas>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Thời gian phiên trung bình -->
                                        <div class="col">
                                            <div class="card h-100 text-center p-3">
                                                <div class="card-header">Thời gian phiên</div>
                                                <div class="card-body d-flex flex-column justify-content-center align-items-center">
                                                    <h4 class="mb-0">
                                                        <fmt:formatNumber value="${stats.avgSessionDuration / 60}" maxFractionDigits="1"/> phút
                                                    </h4>
                                                    <span class="badge mt-2 bg-${stats.avgSessionDuration > 180 ? 'success' : 'warning'}">
                                                        <i class="bi bi-arrow-${stats.avgSessionDuration > 180 ? 'up' : 'down'}"></i>
                                                        ${stats.avgSessionDuration > 180 ? 'Tốt' : 'Cần cải thiện'}
                                                    </span>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Trang mỗi phiên -->
                                        <div class="col">
                                            <div class="card h-100 text-center p-3">
                                                <div class="card-header">Trang mỗi phiên</div>
                                                <div class="card-body d-flex flex-column justify-content-center align-items-center">
                                                    <h4 class="mb-0">
                                                        <fmt:formatNumber value="${stats.pagesPerSession}" maxFractionDigits="1"/>
                                                    </h4>
                                                    <span class="badge mt-2 bg-${stats.pagesPerSession > 3 ? 'success' : 'warning'}">
                                                        <i class="bi bi-arrow-${stats.pagesPerSession > 3 ? 'up' : 'down'}"></i>
                                                        ${stats.pagesPerSession > 3 ? 'Tốt' : 'Cần cải thiện'}
                                                    </span>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Độ cuộn trung bình -->
                                        <div class="col">
                                            <div class="card h-100 text-center p-3">
                                                <div class="card-header">Độ cuộn trung bình</div>
                                                <div class="card-body d-flex flex-column justify-content-center align-items-center">
                                                    <h4 class="mb-0">
                                                        <fmt:formatNumber value="${stats.scrollDepth}" type="percent" maxFractionDigits="0"/>
                                                    </h4>
                                                    <span class="badge mt-2 bg-${stats.scrollDepth > 0.6 ? 'success' : 'warning'}">
                                                        <i class="bi bi-arrow-${stats.scrollDepth > 0.6 ? 'up' : 'down'}"></i>
                                                        ${stats.scrollDepth > 0.6 ? 'Tốt' : 'Cần cải thiện'}
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>


                                <!-- Nguồn lưu lượng truy cập -->
                                <div class="dashboard-section">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="card chart-card">
                                                <div class="card-header">
                                                    Phân bổ người dùng mới & quay lại
                                                </div>
                                                <div class="card-body">
                                                    <div class="chart-container">
                                                        <canvas id="userTypeChart"></canvas>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="card chart-card">
                                                <div class="card-header">
                                                    Nguồn lưu lượng truy cập
                                                </div>
                                                <div class="card-body">
                                                    <div class="chart-container">
                                                        <canvas id="trafficSourceChart"></canvas>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <!-- Tỉ lệ chuyển đổi -->
                                <div class="dashboard-section">
                                    <h4 class="section-title">Tỉ lệ chuyển đổi</h4>
                                    <div class="row">
                                        <div class="col-md-4">
                                            <div class="card stat-card bg-success">
                                                <div class="card-body">
                                                    <h5 class="card-title">Tỉ lệ chuyển đổi chung</h5>
                                                    <p class="card-value"><fmt:formatNumber value="${stats.conversionRate}" type="percent" maxFractionDigits="1"/></p>
                                                    <div class="card-change positive">
                                                        <i class="bi bi-arrow-up"></i> 5% so với tháng trước
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="card stat-card bg-primary">
                                                <div class="card-body">
                                                    <h5 class="card-title">Đăng ký tài khoản</h5>
                                                    <p class="card-value"><fmt:formatNumber value="${stats.signupConversion}" type="percent" maxFractionDigits="1"/></p>
                                                    <div class="card-change positive">
                                                        <i class="bi bi-arrow-up"></i> 3% so với tháng trước
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="card stat-card bg-warning">
                                                <div class="card-body">
                                                    <h5 class="card-title">Mua hàng/Đăng ký</h5>
                                                    <p class="card-value"><fmt:formatNumber value="${stats.purchaseConversion}" type="percent" maxFractionDigits="1"/></p>
                                                    <div class="card-change negative">
                                                        <i class="bi bi-arrow-down"></i> 2% so với tháng trước
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <!-- Biểu đồ thống kê truy cập -->
                                <div class="dashboard-section">
                                    <div class="row">
                                        <div class="col-md-8">
                                            <div class="card chart-card">
                                                <div class="card-header d-flex justify-content-between align-items-center">
                                                    <span>Thống kê truy cập</span>
                                                    <div class="time-filter">
                                                        <button class="btn btn-sm btn-outline-secondary active" data-type="day">Ngày</button>
                                                        <button class="btn btn-sm btn-outline-secondary" data-type="week">Tuần</button>
                                                        <button class="btn btn-sm btn-outline-secondary" data-type="month">Tháng</button>
                                                        <button class="btn btn-sm btn-outline-secondary" data-type="year">Năm</button>
                                                    </div>
                                                </div>
                                                <div class="card-body">
                                                    <div class="chart-container">
                                                        <canvas id="trafficChart"></canvas>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="card chart-card">
                                                <div class="card-header">
                                                    Phân bổ người dùng
                                                </div>
                                                <div class="card-body">
                                                    <div class="chart-container">
                                                        <canvas id="userDistributionChart"></canvas>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Biểu đồ thời gian học tập -->
                                <div class="dashboard-section">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="card chart-card">
                                                <div class="card-header">
                                                    Thời gian học tập trung bình
                                                </div>
                                                <div class="card-body">
                                                    <div class="chart-container">
                                                        <canvas id="learningTimeChart"></canvas>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="card chart-card">
                                                <div class="card-header">
                                                    Tỉ lệ hoàn thành khóa học
                                                </div>
                                                <div class="card-body">
                                                    <div class="chart-container">
                                                        <canvas id="completionRateChart"></canvas>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Top khóa học -->
                                <div class="dashboard-section">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="card table-card">
                                                <div class="card-header">
                                                    Top khóa học xem nhiều
                                                </div>
                                                <div class="card-body">
                                                    <div class="table-responsive">
                                                        <table class="table table-hover">
                                                            <thead>
                                                                <tr>
                                                                    <th>#</th>
                                                                    <th>Tên khóa học</th>
                                                                    <th>Lượt xem</th>
                                                                    <th>Tăng trưởng</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <c:forEach items="${stats.mostViewedCourses}" var="c" varStatus="loop">
                                                                    <tr>
                                                                        <td>${loop.index + 1}</td>
                                                                        <td>${c.title}</td>
                                                                        <td>${c.views}</td>
                                                                        <td>
                                                                            <span class="badge bg-success bg-opacity-10 text-success">
                                                                                <i class="bi bi-arrow-up"></i> 
                                                                                <fmt:formatNumber value="${c.growthRate}" pattern="#,##0"/>%
                                                                            </span>
                                                                        </td>
                                                                    </tr>
                                                                </c:forEach>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="card table-card">
                                                <div class="card-header">
                                                    Top khóa học đánh giá cao
                                                </div>
                                                <div class="card-body">
                                                    <div class="table-responsive">
                                                        <table class="table table-hover">
                                                            <thead>
                                                                <tr>
                                                                    <th>#</th>
                                                                    <th>Tên khóa học</th>
                                                                    <th>Đánh giá</th>
                                                                    <th>Số lượt</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <c:forEach items="${stats.highestRatedCourses}" var="c" varStatus="loop">
                                                                    <tr>
                                                                        <td>${loop.index + 1}</td>
                                                                        <td>${c.title}</td>
                                                                        <td>
                                                                            <div class="d-flex align-items-center">
                                                                                <div class="progress progress-thin w-100 me-2">
                                                                                    <div class="progress-bar bg-warning" style="width: ${c.rating * 20}%"></div>
                                                                                </div>
                                                                                <span>${c.rating}/5</span>
                                                                            </div>
                                                                        </td>
                                                                        <td>${c.enrollments}</td>
                                                                    </tr>
                                                                </c:forEach>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Thống kê chi tiết -->
                                <div class="dashboard-section">
                                    <div class="card table-card">
                                        <div class="card-header d-flex justify-content-between align-items-center">
                                            <span>Thống kê truy cập chi tiết</span>
                                            <div class="btn-group">
                                                <button class="btn btn-sm btn-outline-primary" onclick="exportTableToExcel('statsTable')">Xuất Excel</button>
                                                <button class="btn btn-sm btn-outline-secondary">Tùy chọn</button>
                                            </div>
                                        </div>
                                        <div class="card-body">
                                            <div class="table-responsive">
                                                <table class="table table-hover">
                                                    <thead>
                                                        <tr>
                                                            <th>Ngày</th>
                                                            <th>Lượt truy cập</th>
                                                            <th>Người dùng</th>
                                                            <th>Người dùng mới</th>
                                                            <th>Thời gian TB</th>
                                                            <th>Lượt xem trang</th>
                                                            <th>Tỉ lệ thoát</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach items="${stats.dailyStats}" var="d">
                                                            <tr>
                                                                <td><fmt:formatDate value="${d.date}" pattern="dd/MM/yyyy"/></td>
                                                                <td>${d.visits}</td>
                                                                <td>${d.uniqueVisitors}</td>
                                                                <td>${d.newUsers}</td>
                                                                <td><fmt:formatNumber value="${d.avgDuration / 60}" maxFractionDigits="1"/> phút</td>
                                                                <td>${d.pageViews}</td>
                                                                <td>
                                                                    <div class="progress progress-thin">
                                                                        <div class="progress-bar bg-danger" style="width: ${d.bounceRate * 100}%"></div>
                                                                    </div>
                                                                    <small><fmt:formatNumber value="${d.bounceRate}" type="percent" maxFractionDigits="1"/></small>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>

                                                    </tbody>
                                                </table>
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

        <script>
                                                    const dailyLabels = ${dailyLabels};
                                                    const dailyVisits = ${dailyVisits};
                                                    const dailyUsers = ${dailyUsers};
                                                    const ctrLabels = ${ctrLabels};
                                                    const ctrValues = ${ctrValues};
                                                    const courseTitles = ${courseTitles};
                                                    const avgTimes = ${avgTimes};
                                                    const completionCourseTitles = ${completionCourseTitles};
                                                    const completionRates = ${completionRates};
                                                    const trafficSources = ${trafficSourcesJson};
                                                    const userDistribution = ${userDistributionJson};
        </script>


        <!-- Script chính vẽ biểu đồ -->
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script>
                                                    $(document).ready(function () {
                                                    // Biểu đồ CTR
                                                    const ctrCtx = document.getElementById('ctrChart').getContext('2d');
                                                    new Chart(ctrCtx, {
                                                    type: 'line',
                                                            data: {
                                                            labels: ctrLabels,
                                                                    datasets: [{
                                                                    label: 'CTR (%)',
                                                                            data: ctrValues.map(v => v * 100),
                                                                            borderColor: '#4361ee',
                                                                            backgroundColor: 'rgba(67, 97, 238, 0.1)',
                                                                            fill: true,
                                                                            tension: 0.4
                                                                    }]
                                                            },
                                                            options: {
                                                            plugins: {
                                                            tooltip: {
                                                            callbacks: {
                                                            label: ctx => ctx.parsed.y.toFixed(1) + '%'
                                                            }
                                                            }
                                                            },
                                                                    scales: {
                                                                    y: {
                                                                    beginAtZero: true,
                                                                            ticks: {
                                                                            callback: val => val + '%'
                                                                            }
                                                                    }
                                                                    }
                                                            }
                                                    });
                                                    // Biểu đồ User Type
                                                    const userTypeCtx = document.getElementById('userTypeChart').getContext('2d');
                                                    new Chart(userTypeCtx, {
                                                    type: 'doughnut',
                                                            data: {
                                                            labels: ['Người mới', 'Người quay lại'],
                                                                    datasets: [{
                                                                    data: [${stats.newUsers}, ${stats.returningUsers}],
                                                                            backgroundColor: ['#4361ee', '#4895ef']
                                                                    }]
                                                            },
                                                            options: {
                                                            plugins: {
                                                            legend: {position: 'bottom'}
                                                            }
                                                            }
                                                    });
                                                    // Biểu đồ traffic nguồn
                                                    const trafficCtx = document.getElementById('trafficSourceChart').getContext('2d');
                                                    new Chart(trafficCtx, {
                                                    type: 'bar',
                                                            data: {
                                                            labels: Object.keys(trafficSources),
                                                                    datasets: [{
                                                                    label: 'Nguồn truy cập',
                                                                            data: Object.values(trafficSources),
                                                                            backgroundColor: ['#4361ee', '#4895ef', '#4cc9f0', '#f8961e']
                                                                    }]
                                                            },
                                                            options: {
                                                            scales: {
                                                            y: {beginAtZero: true}
                                                            }
                                                            }
                                                    });
                                                    // Biểu đồ truy cập
                                                    const trafficChartCtx = document.getElementById('trafficChart').getContext('2d');
                                                    new Chart(trafficChartCtx, {
                                                    type: 'line',
                                                            data: {
                                                            labels: dailyLabels,
                                                                    datasets: [
                                                                    {
                                                                    label: 'Lượt truy cập',
                                                                            data: dailyVisits,
                                                                            borderColor: '#4361ee',
                                                                            fill: true,
                                                                            backgroundColor: 'rgba(67, 97, 238, 0.1)'
                                                                    },
                                                                    {
                                                                    label: 'Người dùng',
                                                                            data: dailyUsers,
                                                                            borderColor: '#4cc9f0',
                                                                            fill: true,
                                                                            backgroundColor: 'rgba(76, 201, 240, 0.1)'
                                                                    }
                                                                    ]
                                                            },
                                                            options: {
                                                            scales: {
                                                            y: {beginAtZero: true}
                                                            }
                                                            }
                                                    });
                                                    // Biểu đồ phân bổ người dùng
                                                    const userDistCtx = document.getElementById('userDistributionChart').getContext('2d');
                                                    new Chart(userDistCtx, {
                                                    type: 'pie',
                                                            data: {
                                                            labels: ['Thường', 'Premium', 'Nhân viên', 'Quản trị'],
                                                                    datasets: [{
                                                                    data: [
                                                                            userDistribution.regularUsers || 0,
                                                                            userDistribution.premiumUsers || 0,
                                                                            userDistribution.staffUsers || 0,
                                                                            userDistribution.adminUsers || 0
                                                                    ],
                                                                            backgroundColor: ['#4361ee', '#4895ef', '#4cc9f0', '#f8961e']
                                                                    }]
                                                            },
                                                            options: {
                                                            plugins: {
                                                            legend: {position: 'bottom'}
                                                            }
                                                            }
                                                    });
                                                    // Biểu đồ thời gian học
                                                    const learningTimeCtx = document.getElementById('learningTimeChart').getContext('2d');
                                                    new Chart(learningTimeCtx, {
                                                    type: 'bar',
                                                            data: {
                                                            labels: courseTitles,
                                                                    datasets: [{
                                                                    label: 'Thời gian trung bình (phút)',
                                                                            data: avgTimes,
                                                                            backgroundColor: '#4361ee'
                                                                    }]
                                                            },
                                                            options: {
                                                            scales: {
                                                            y: {
                                                            beginAtZero: true,
                                                                    title: {display: true, text: 'Phút'}
                                                            }
                                                            }
                                                            }
                                                    });
                                                    // Biểu đồ tỉ lệ hoàn thành
                                                    const completionCtx = document.getElementById('completionRateChart').getContext('2d');
                                                    new Chart(completionCtx, {
                                                    type: 'bar',
                                                            data: {
                                                            labels: completionCourseTitles,
                                                                    datasets: [{
                                                                    label: 'Tỉ lệ hoàn thành (%)',
                                                                            data: completionRates.map(r => r * 100),
                                                                            backgroundColor: '#4cc9f0'
                                                                    }]
                                                            },
                                                            options: {
                                                            plugins: {
                                                            tooltip: {
                                                            callbacks: {
                                                            label: ctx => ctx.parsed.y.toFixed(1) + '%'
                                                            }
                                                            }
                                                            },
                                                                    scales: {
                                                                    y: {
                                                                    beginAtZero: true,
                                                                            max: 100,
                                                                            ticks: {
                                                                            callback: val => val + '%'
                                                                            }
                                                                    }
                                                                    }
                                                            }
                                                    });
                                                    });
        </script>

        <script>
            const userDistribution = ${not empty userDistributionJson ? userDistributionJson : '{}'};
            const trafficSources = ${not empty trafficSourcesJson ? trafficSourcesJson : '{}'};
        </script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/2.0.5/FileSaver.min.js"></script>
        <script>
            function exportTableToExcel(tableID) {
            const table = document.getElementById(tableID);
            const wb = XLSX.utils.table_to_book(table, {sheet: "Thống kê"});
            const wbout = XLSX.write(wb, {bookType: 'xlsx', type: 'binary'});
            function s2ab(s) {
            const buf = new ArrayBuffer(s.length);
            const view = new Uint8Array(buf);
            for (let i = 0; i < s.length; i++)
                    view[i] = s.charCodeAt(i) & 0xFF;
            return buf;
            }

            saveAs(new Blob([s2ab(wbout)], {type: "application/octet-stream"}), "ThongKeChiTiet.xlsx");
            }
        </script>

    </body>
</html>