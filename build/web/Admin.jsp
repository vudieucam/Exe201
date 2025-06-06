<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page import="java.util.Date" %>


<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
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
                            <a class="nav-link" href="${pageContext.request.contextPath}/userAdmin.jsp">
                                <i class="bi bi-people"></i>Người dùng
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/courseadmin">
                                <i class="bi bi-book"></i>Khóa học
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
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/paymentsAdmin.jsp">
                                <i class="bi bi-credit-card"></i>Thanh toán
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/blogsAdmin.jsp">
                                <i class="bi bi-newspaper"></i>Blog
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/partnersAdmin.jsp">
                                <i class="bi bi-building"></i>Đối tác
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/reports.jsp">
                                <i class="bi bi-graph-up"></i>Báo cáo
                            </a>
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
                                                    <div class="card-change positive">
                                                        <i class="bi bi-arrow-up"></i> 12% so với hôm qua
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="card stat-card bg-success">
                                                <div class="card-body">
                                                    <h5 class="card-title">Tổng người dùng</h5>
                                                    <p class="card-value">${stats.totalUsers}</p>
                                                    <div class="card-change positive">
                                                        <i class="bi bi-arrow-up"></i> ${stats.userGrowth}% so với tháng trước
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="card stat-card bg-info">
                                                <div class="card-body">
                                                    <h5 class="card-title">Người dùng hoạt động</h5>
                                                    <p class="card-value">${stats.activeUsers}</p>
                                                    <div class="card-change positive">
                                                        <i class="bi bi-arrow-up"></i> 8% so với tuần trước
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
                                                        <i class="bi bi-arrow-up"></i> 15% so với tháng trước
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Biểu đồ thống kê truy cập -->
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
                                        <!-- Thay thế phần biểu đồ tỉ lệ hoàn thành bằng biểu đồ cột ngang -->
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
                                                                                <i class="bi bi-arrow-up"></i> ${loop.index * 5 + 10}%
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
                                                                        <td>${loop.index * 3 + 15}</td>
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
                                                <button class="btn btn-sm btn-outline-primary">Xuất Excel</button>
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
                                                                        <div class="progress-bar bg-danger" style="width: ${30 + (d.visits % 20)}%"></div>
                                                                    </div>
                                                                    <small>${30 + (d.visits % 20)}%</small>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <script>
                                    document.addEventListener('DOMContentLoaded', function () {
                                        // ==================== BIỂU ĐỒ LƯỢNG TRUY CẬP ====================
                                        const initTrafficChart = () => {
                                            const trafficCtx = document.getElementById('trafficChart')?.getContext('2d');
                                            if (!trafficCtx)
                                                return null;

                                            return new Chart(trafficCtx, {
                                                type: 'bar',
                                                data: {
                                                    labels: [],
                                                    datasets: [
                                                        {
                                                            label: 'Lượt truy cập',
                                                            data: [],
                                                            backgroundColor: 'rgba(67, 97, 238, 0.7)',
                                                            borderColor: '#4361ee',
                                                            borderWidth: 1,
                                                            type: 'bar',
                                                            order: 1
                                                        },
                                                        {
                                                            label: 'Người dùng',
                                                            data: [],
                                                            borderColor: '#4895ef',
                                                            backgroundColor: 'transparent',
                                                            borderWidth: 2,
                                                            type: 'line',
                                                            tension: 0.3,
                                                            order: 0
                                                        }
                                                    ]
                                                },
                                                options: {
                                                    responsive: true,
                                                    maintainAspectRatio: false,
                                                    plugins: {
                                                        legend: {
                                                            position: 'top',
                                                        },
                                                        tooltip: {
                                                            mode: 'index',
                                                            intersect: false
                                                        }
                                                    },
                                                    scales: {
                                                        x: {
                                                            grid: {
                                                                display: false
                                                            },
                                                            title: {
                                                                display: true,
                                                                text: 'Thời gian'
                                                            }
                                                        },
                                                        y: {
                                                            grid: {
                                                                color: 'rgba(0, 0, 0, 0.05)'
                                                            },
                                                            title: {
                                                                display: true,
                                                                text: 'Số lượng'
                                                            },
                                                            beginAtZero: true
                                                        }
                                                    }
                                                }
                                            });
                                        };

                                        // Hàm cập nhật biểu đồ traffic
                                        const updateTrafficChart = (chart, filterType) => {
                                            let labels = [];
                                            let visitsData = [];
                                            let usersData = [];
                                            let xAxisTitle = 'Thời gian';

                                            // Tạo dữ liệu giả lập tùy theo filter type
                                            switch (filterType) {
                                                case 'day':
                                                    labels = Array.from({length: 24}, (_, i) => `${i.toString().padStart(2, '0')}:00`);
                                                    visitsData = Array.from({length: 24}, () => Math.floor(Math.random() * 100) + 50);
                                                    usersData = Array.from({length: 24}, () => Math.floor(Math.random() * 80) + 30);
                                                    xAxisTitle = 'Giờ trong ngày';
                                                    break;

                                                case 'week':
                                                    const today = new Date();
                                                    const firstDayOfWeek = new Date(today.setDate(today.getDate() - today.getDay() + 1));

                                                    labels = [];
                                                    for (let i = 0; i < 4; i++) {
                                                        const startDate = new Date(firstDayOfWeek);
                                                        startDate.setDate(startDate.getDate() - (i * 7));
                                                        const endDate = new Date(startDate);
                                                        endDate.setDate(endDate.getDate() + 6);

                                                        const startStr = `${startDate.getDate()}/${startDate.getMonth() + 1}`;
                                                                                const endStr = `${endDate.getDate()}/${endDate.getMonth() + 1}`;
                                                                                                        labels.push(`Tuần ${4 - i} (${startStr}-${endStr})`);
                                                                                                    }

                                                                                                    labels.reverse();
                                                                                                    visitsData = Array.from({length: 4}, () => Math.floor(Math.random() * 1000) + 500);
                                                                                                    usersData = Array.from({length: 4}, () => Math.floor(Math.random() * 800) + 400);
                                                                                                    xAxisTitle = 'Tuần';
                                                                                                    break;

                                                                                                case 'month':
                                                                                                    const monthToday = new Date();
                                                                                                    const daysInMonth = new Date(monthToday.getFullYear(), monthToday.getMonth() + 1, 0).getDate();
                                                                                                    const weekCount = Math.ceil(daysInMonth / 7);

                                                                                                    labels = Array.from({length: weekCount}, (_, i) => `Tuần ${i+1}`);
                                                                                                    visitsData = Array.from({length: weekCount}, () => Math.floor(Math.random() * 1000) + 500);
                                                                                                    usersData = Array.from({length: weekCount}, () => Math.floor(Math.random() * 800) + 400);
                                                                                                    xAxisTitle = 'Tuần trong tháng';
                                                                                                    break;

                                                                                                case 'year':
                                                                                                    labels = ['Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6',
                                                                                                        'Tháng 7', 'Tháng 8', 'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12'];
                                                                                                    visitsData = Array.from({length: 12}, () => Math.floor(Math.random() * 3000) + 1500);
                                                                                                    usersData = Array.from({length: 12}, () => Math.floor(Math.random() * 2500) + 1000);
                                                                                                    xAxisTitle = 'Tháng trong năm';
                                                                                                    break;
                                                                                            }

                                                                                            // Cập nhật dữ liệu và tiêu đề trục x
                                                                                            chart.data.labels = labels;
                                                                                            chart.data.datasets[0].data = visitsData;
                                                                                            chart.data.datasets[1].data = usersData;
                                                                                            chart.options.scales.x.title.text = xAxisTitle;
                                                                                            chart.update();
                                                                                        };

                                                                                        // ==================== BIỂU ĐỒ PHÂN BỐ NGƯỜI DÙNG ====================
                                                                                        const initUserDistributionChart = () => {
                                                                                            const userDistCtx = document.getElementById('userDistributionChart')?.getContext('2d');
                                                                                            if (!userDistCtx)
                                                                                                return;

                                                                                            new Chart(userDistCtx, {
                                                                                                type: 'doughnut',
                                                                                                data: {
                                                                                                    labels: ['Thường', 'Premium', 'Admin', 'Staff'],
                                                                                                    datasets: [{
                                                                                                            data: [
                                    ${userDistribution.regularUsers != null ? userDistribution.regularUsers : 0},
                                    ${userDistribution.premiumUsers != null ? userDistribution.premiumUsers : 0},
                                    ${userDistribution.adminUsers != null ? userDistribution.adminUsers : 0},
                                    ${userDistribution.staffUsers != null ? userDistribution.staffUsers : 0}
                                                                                                            ],
                                                                                                            backgroundColor: [
                                                                                                                '#4361ee',
                                                                                                                '#4895ef',
                                                                                                                '#3f37c9',
                                                                                                                '#4cc9f0'
                                                                                                            ],
                                                                                                            borderWidth: 1
                                                                                                        }]
                                                                                                },
                                                                                                options: {
                                                                                                    responsive: true,
                                                                                                    maintainAspectRatio: false,
                                                                                                    plugins: {
                                                                                                        legend: {
                                                                                                            position: 'right',
                                                                                                        }
                                                                                                    }
                                                                                                }
                                                                                            });
                                                                                        };

                                                                                        // ==================== BIỂU ĐỒ THỜI GIAN HỌC ====================
                                                                                        const initLearningTimeChart = () => {
                                                                                            const learningTimeCtx = document.getElementById('learningTimeChart')?.getContext('2d');
                                                                                            if (!learningTimeCtx)
                                                                                                return;

                                                                                            new Chart(learningTimeCtx, {
                                                                                                type: 'bar',
                                                                                                data: {
                                                                                                    labels: ${not empty courseTitles ? courseTitles : '["No Data"]'},
                                                                                                    datasets: [{
                                                                                                            label: 'Phút',
                                                                                                            data: ${not empty avgTimes ? avgTimes : '[0]'},
                                                                                                            backgroundColor: 'rgba(67, 97, 238, 0.7)',
                                                                                                            borderColor: '#4361ee',
                                                                                                            borderWidth: 1
                                                                                                        }]
                                                                                                },
                                                                                                options: {
                                                                                                    responsive: true,
                                                                                                    maintainAspectRatio: false,
                                                                                                    scales: {
                                                                                                        x: {
                                                                                                            grid: {
                                                                                                                display: false
                                                                                                            }
                                                                                                        },
                                                                                                        y: {
                                                                                                            title: {
                                                                                                                display: true,
                                                                                                                text: 'Phút'
                                                                                                            }
                                                                                                        }
                                                                                                    }
                                                                                                }
                                                                                            });
                                                                                        };

                                                                                        // ==================== BIỂU ĐỒ TỈ LỆ HOÀN THÀNH ====================
                                                                                        const initCompletionRateChart = () => {
                                                                                            const completionRateCtx = document.getElementById('completionRateChart')?.getContext('2d');
                                                                                            if (!completionRateCtx)
                                                                                                return;

                                                                                            new Chart(completionRateCtx, {
                                                                                                type: 'radar',
                                                                                                data: {
                                                                                                    labels: ${not empty completionCourseTitles ? completionCourseTitles : '["No Data"]'},
                                                                                                    datasets: [{
                                                                                                            label: 'Tỉ lệ hoàn thành (%)',
                                                                                                            data: ${not empty completionRates ? completionRates : '[0]'},
                                                                                                            backgroundColor: 'rgba(72, 149, 239, 0.2)',
                                                                                                            borderColor: '#4895ef',
                                                                                                            pointBackgroundColor: '#4895ef',
                                                                                                            pointBorderColor: '#fff',
                                                                                                            pointHoverBackgroundColor: '#fff',
                                                                                                            pointHoverBorderColor: '#4895ef'
                                                                                                        }]
                                                                                                },
                                                                                                options: {
                                                                                                    responsive: true,
                                                                                                    maintainAspectRatio: false,
                                                                                                    scales: {
                                                                                                        r: {
                                                                                                            angleLines: {
                                                                                                                display: true
                                                                                                            },
                                                                                                            suggestedMin: 0,
                                                                                                            suggestedMax: 100,
                                                                                                            ticks: {
                                                                                                                stepSize: 20
                                                                                                            }
                                                                                                        }
                                                                                                    }
                                                                                                }
                                                                                            });
                                                                                        };

                                                                                        // ==================== KHỞI TẠO TẤT CẢ BIỂU ĐỒ ====================
                                                                                        const initAllCharts = () => {
                                                                                            // Khởi tạo biểu đồ traffic và thiết lập sự kiện
                                                                                            const trafficChart = initTrafficChart();
                                                                                            if (trafficChart) {
                                                                                                // Xử lý sự kiện click cho các nút lọc thời gian
                                                                                                const timeFilterButtons = document.querySelectorAll('.time-filter .btn');
                                                                                                timeFilterButtons.forEach(button => {
                                                                                                    button.addEventListener('click', function () {
                                                                                                        timeFilterButtons.forEach(btn => btn.classList.remove('active'));
                                                                                                        this.classList.add('active');
                                                                                                        updateTrafficChart(trafficChart, this.getAttribute('data-type'));
                                                                                                    });
                                                                                                });

                                                                                                // Khởi tạo dữ liệu ban đầu (ngày)
                                                                                                updateTrafficChart(trafficChart, 'day');
                                                                                            }

                                                                                            // Khởi tạo các biểu đồ khác
                                                                                            initUserDistributionChart();
                                                                                            initLearningTimeChart();
                                                                                            initCompletionRateChart();
                                                                                        };

                                                                                        // Chạy khởi tạo tất cả biểu đồ
                                                                                        initAllCharts();
                                                                                    });
                                </script>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
    </body>
</html>