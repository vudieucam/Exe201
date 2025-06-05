<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>  <!-- nếu dùng fn:length -->

<%@page contentType="text/html" pageEncoding="UTF-8"%>


<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>PetTech Admin Dashboard</title>
        <!-- CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
        <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/jquery.dataTables.min.css"/>
        <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet">

        <!-- JS -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
        <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
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

                    <!-- Admin Profile -->
                    <div class="admin-profile">
                        <c:if test="${not empty sessionScope.user}">
                            <div class="dropdown">
                                <a href="#" class="dropdown-toggle" data-bs-toggle="dropdown" id="profileDropdown">
                                    <img src="${pageContext.request.contextPath}/images/anh-AN.jpg" alt="Admin Avatar" class="admin-avatar">
                                    <div class="admin-info">
                                        <div class="admin-name">${sessionScope.user.fullName}</div>
                                        <div class="admin-role">
                                            <c:choose>
                                                <c:when test="${sessionScope.user.roleId == 2}">Quản trị viên</c:when>
                                                <c:when test="${sessionScope.user.roleId == 3}">Nhân viên</c:when>
                                                <c:otherwise>Người dùng</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </a>
                                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="profileDropdown">
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/authen?action=editprofile"><i class="bi bi-person me-2"></i>Hồ sơ</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item logout" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right me-2"></i>Đăng xuất</a></li>
                                </ul>
                            </div>
                        </c:if>
                    </div>
                </div>

                <!-- Main Content -->
                <div class="col-md-10 p-4">
                    <!-- DEBUG THÔNG TIN -->
                    <div class="alert alert-warning">
                        <strong>DEBUG:</strong><br>
                        Session User: ${sessionScope.user != null ? sessionScope.user.email : 'null'}<br>
                        User Role: ${sessionScope.user != null ? sessionScope.user.roleId : 'null'}<br>
                        Stats tồn tại? ${not empty stats ? 'YES' : 'NO'}<br>
                        Total Users: ${not empty stats.totalUsers ? stats.totalUsers : 'null'}<br>
                        DailyStats size: 
                        <c:choose>
                            <c:when test="${not empty stats.dailyStats}">
                                ${fn:length(stats.dailyStats)}
                            </c:when>
                            <c:otherwise>null</c:otherwise>
                        </c:choose>
                    </div>

                    <div class="tab-content">
                        <!-- Kiểm tra quyền truy cập -->
                        <c:if test="${empty sessionScope.user || (sessionScope.user.roleId ne 2 && sessionScope.user.roleId ne 3)}">
                            <div class="alert alert-danger">
                                Bạn không có quyền truy cập trang này. Vui lòng <a href="${pageContext.request.contextPath}/login.jsp">đăng nhập</a> với tài khoản admin.
                            </div>
                        </c:if>

                        <c:if test="${not empty sessionScope.user && (sessionScope.user.roleId eq 2 || sessionScope.user.roleId eq 3)}">
                            <!-- Thông báo -->
                            <c:if test="${not empty success}">
                                <div class="alert alert-success alert-dismissible fade show">
                                    ${success}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                                <c:remove var="success" scope="session"/>
                            </c:if>

                            <c:if test="${not empty error}">
                                <div class="alert alert-danger alert-dismissible fade show">
                                    ${error}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                                <c:remove var="error" scope="session"/>
                            </c:if>

                            <h2 class="mb-4">Dashboard Thống kê</h2>
                            <p class="text-muted mb-4">Dữ liệu được cập nhật lần cuối: <span id="lastUpdated"><fmt:formatDate value="<%= new java.util.Date()%>" pattern="HH:mm dd/MM/yyyy" /></span></p>

                            <!-- Thống kê tổng quan -->
                            <div class="row mb-4">
                                <div class="col-md-3">
                                    <div class="stat-card bg-primary text-white p-3 rounded-3">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div>
                                                <h6 class="mb-1">Người dùng Online</h6>
                                                <h3 class="mb-0">${not empty stats.onlineUsers ? stats.onlineUsers : 0}</h3>
                                            </div>
                                            <i class="bi bi-people-fill fs-1 opacity-50"></i>
                                        </div>
                                        <div class="mt-2">
                                            <small class="d-block"><i class="bi bi-arrow-up"></i> ${not empty stats.activeUsers ? stats.activeUsers : 0} người hoạt động</small>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-md-3">
                                    <div class="stat-card bg-success text-white p-3 rounded-3">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div>
                                                <h6 class="mb-1">Tổng người dùng</h6>
                                                <h3 class="mb-0"><fmt:formatNumber value="${not empty stats.totalUsers ? stats.totalUsers : 0}" /></h3>
                                            </div>
                                            <i class="bi bi-person-plus-fill fs-1 opacity-50"></i>
                                        </div>
                                        <div class="mt-2">
                                            <small class="d-block"><i class="bi bi-graph-up"></i> ${not empty stats.userGrowth ? stats.userGrowth : 0}% tăng trưởng</small>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-md-3">
                                    <div class="stat-card bg-warning text-dark p-3 rounded-3">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div>
                                                <h6 class="mb-1">Tổng khóa học</h6>
                                                <h3 class="mb-0">${not empty stats.totalCourses ? stats.totalCourses : 0}</h3>
                                            </div>
                                            <i class="bi bi-book-half fs-1 opacity-50"></i>
                                        </div>
                                        <div class="mt-2">
                                            <small class="d-block"><i class="bi bi-check-circle"></i> ${not empty stats.activeCourses ? stats.activeCourses : 0} khóa đang hoạt động</small>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-md-3">
                                    <div class="stat-card bg-danger text-white p-3 rounded-3">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div>
                                                <h6 class="mb-1">Doanh thu tháng</h6>
                                                <h3 class="mb-0"><fmt:formatNumber value="${not empty stats.monthlyRevenue ? stats.monthlyRevenue : 0}" type="currency" currencySymbol="VND"/></h3>
                                            </div>
                                            <i class="bi bi-currency-dollar fs-1 opacity-50"></i>
                                        </div>
                                        <div class="mt-2">
                                            <small class="d-block"><i class="bi bi-cash-stack"></i> Tổng: <fmt:formatNumber value="${not empty stats.totalRevenue ? stats.totalRevenue : 0}" type="currency" currencySymbol="VND"/></small>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Biểu đồ thống kê -->
                            <div class="row mb-4">
                                <div class="col-md-8">
                                    <div class="card h-100">
                                        <div class="card-header d-flex justify-content-between align-items-center">
                                            <h5 class="mb-0">Thống kê truy cập 30 ngày</h5>
                                            <div class="btn-group btn-group-sm">
                                                <button class="btn btn-outline-secondary active" onclick="updateChart('visits')">Lượt truy cập</button>
                                                <button class="btn btn-outline-secondary" onclick="updateChart('users')">Người dùng</button>
                                                <button class="btn btn-outline-secondary" onclick="updateChart('duration')">Thời gian</button>
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
                                    <div class="card h-100">
                                        <div class="card-header">
                                            <h5 class="mb-0">Phân bố người dùng</h5>
                                        </div>
                                        <div class="card-body">
                                            <div class="chart-container">
                                                <canvas id="userDistributionChart"></canvas>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Top khóa học -->
                            <div class="row mb-4">
                                <div class="col-md-6">
                                    <div class="card h-100">
                                        <div class="card-header">
                                            <h5 class="mb-0">Top khóa học xem nhiều</h5>
                                        </div>
                                        <div class="card-body">
                                            <div class="table-responsive">
                                                <table class="table table-hover">
                                                    <thead>
                                                        <tr>
                                                            <th>#</th>
                                                            <th>Tên khóa học</th>
                                                            <th>Lượt xem</th>
                                                            <th>Thời lượng TB</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach items="${stats.mostViewedCourses}" var="course" varStatus="loop">
                                                            <tr>
                                                                <td>${loop.index + 1}</td>
                                                                <td>${course.title}</td>
                                                                <td><fmt:formatNumber value="${course.views}" /></td>
                                                                <td>
                                                                    <c:set var="hours" value="${course.avgViewDuration / 3600}"/>
                                                                    <c:set var="minutes" value="${(course.avgViewDuration % 3600) / 60}"/>
                                                                    <fmt:formatNumber value="${hours}" maxFractionDigits="0"/>h<fmt:formatNumber value="${minutes}" maxFractionDigits="0"/>m
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
                                    <div class="card h-100">
                                        <div class="card-header">
                                            <h5 class="mb-0">Top khóa học đánh giá cao</h5>
                                        </div>
                                        <div class="card-body">
                                            <div class="table-responsive">
                                                <table class="table table-hover">
                                                    <thead>
                                                        <tr>
                                                            <th>#</th>
                                                            <th>Tên khóa học</th>
                                                            <th>Đánh giá</th>
                                                            <th>Học viên</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach items="${stats.highestRatedCourses}" var="course" varStatus="loop">
                                                            <tr>
                                                                <td>${loop.index + 1}</td>
                                                                <td>${course.title}</td>
                                                                <td>
                                                                    <div class="d-flex align-items-center">
                                                                        <div class="progress progress-thin w-100 me-2">
                                                                            <div class="progress-bar bg-warning" 
                                                                                 <c:if test="${not empty course.rating}">
                                                                                     <div class="progress-bar" style="width: ${course.rating * 20}%"></div>
                                                                            </c:if>

                                                                        </div>
                                                                        <small>${course.rating}/5</small>
                                                                    </div>
                                                                </td>
                                                                <td><fmt:formatNumber value="${course.enrollments}" /></td>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Chi tiết thống kê ngày -->
                            <div class="card mb-4">
                                <div class="card-header d-flex justify-content-between align-items-center">
                                    <h5 class="mb-0">Chi tiết thống kê theo ngày</h5>
                                    <div class="input-group" style="width: 250px;">
                                        <input type="date" id="dateFilter" class="form-control form-control-sm" 
                                               value="<fmt:formatDate value="<%= new java.util.Date()%>" pattern="yyyy-MM-dd" />">
                                        <button class="btn btn-outline-primary btn-sm" onclick="filterByDate()">
                                            <i class="bi bi-filter"></i>
                                        </button>
                                    </div>
                                </div>
                                <div class="card-body">
                                    <div class="table-responsive">
                                        <table class="table table-striped" id="dailyStatsTable">
                                            <thead>
                                                <tr>
                                                    <th>Ngày</th>
                                                    <th>Lượt truy cập</th>
                                                    <th>Người dùng</th>
                                                    <th>Người dùng mới</th>
                                                    <th>Thời gian TB (phút)</th>
                                                    <th>Lượt xem trang</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${stats.dailyStats}" var="day">
                                                    <tr>
                                                        <td><fmt:formatDate value="${day.date}" pattern="dd/MM/yyyy"/></td>
                                                        <td><fmt:formatNumber value="${day.visits}"/></td>
                                                        <td><fmt:formatNumber value="${day.uniqueVisitors}"/></td>
                                                        <td><fmt:formatNumber value="${day.newUsers}"/></td>
                                                        <td><fmt:formatNumber value="${day.avgDuration / 60}" maxFractionDigits="1"/></td>
                                                        <td><fmt:formatNumber value="${day.pageViews}"/></td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>

        <!-- Script cho biểu đồ -->
        <script>
            document.addEventListener('DOMContentLoaded', function() {
            console.log('DOM fully loaded');
            // Debug: Kiểm tra dữ liệu stats
            try {
            console.log('Checking stats data:', ${not empty stats ? stats : 'null'});
            // Chỉ khởi tạo biểu đồ nếu có dữ liệu
            if (typeof ${stats} !== 'undefined' && ${stats} !== null) {
            initializeCharts();
            initializeDataTable();
            } else {
            console.error('Stats data is not available');
            }
            } catch (e) {
            console.error('Error initializing charts:', e);
            showErrorAlert('Đã xảy ra lỗi khi tải dữ liệu biểu đồ');
            }

            // Tự động làm mới dữ liệu mỗi 5 phút
            setTimeout(() => {
            window.location.reload();
            }, 300000);
            });
            function initializeCharts() {
            console.log('Initializing charts...');
            // Biểu đồ traffic
            const trafficCtx = document.getElementById('trafficChart')?.getContext('2d');
            if (trafficCtx) {
            const labels = [
            <c:forEach items="${stats.dailyStats}" var="day" varStatus="loop">
            '<fmt:formatDate value="${day.date}" pattern="dd/MM"/>'<c:if test="${!loop.last}">,</c:if>
            </c:forEach>
            ];
            window.trafficChart = new Chart(trafficCtx, {
            type: 'line',
                    data: {
                    labels: labels,
                            datasets: [{
                            label: 'Lượt truy cập',
                                    data: [
            <c:forEach items="${stats.dailyStats}" var="day" varStatus="loop">
                ${day.visits}<c:if test="${!loop.last}">,</c:if>
            </c:forEach>
                                    ],
                                    backgroundColor: 'rgba(67, 97, 238, 0.1)',
                                    borderColor: '#4361ee',
                                    borderWidth: 2,
                                    tension: 0.3,
                                    fill: true
                            }]
                    },
                    options: {
                    responsive: true,
                            maintainAspectRatio: false,
                            plugins: {
                            legend: {
                            position: 'top'
                            }
                            },
                            scales: {
                            y: {
                            beginAtZero: true
                            }
                            }
                    }
            });
            }

            // Biểu đồ phân bố người dùng
            const userCtx = document.getElementById('userDistributionChart')?.getContext('2d');
            if (userCtx) {
            new Chart(userCtx, {
            type: 'doughnut',
                    data: {
                    labels: ['Người dùng thường', 'Người dùng Premium', 'Quản trị viên', 'Nhân viên'],
                            datasets: [{
                            data: [
            ${not empty stats.userActivity.regularUsers ? stats.userActivity.regularUsers : 0},
            ${not empty stats.userActivity.premiumUsers ? stats.userActivity.premiumUsers : 0},
            ${not empty stats.userActivity.adminUsers ? stats.userActivity.adminUsers : 0},
            ${not empty stats.userActivity.staffUsers ? stats.userActivity.staffUsers : 0}
                            ],
                                    backgroundColor: ['#4361ee', '#4895ef', '#3f37c9', '#4cc9f0'],
                                    borderWidth: 1
                            }]
                    },
                    options: {
                    responsive: true,
                            maintainAspectRatio: false,
                            plugins: {
                            legend: {
                            position: 'right'
                            }
                            }
                    }
            });
            }
            }

            function initializeDataTable() {
            console.log('Initializing data table...');
            if ($.fn.DataTable) {
            $('#dailyStatsTable').DataTable({
            "order": [[0, "desc"]],
                    "language": {
                    "lengthMenu": "Hiển thị _MENU_ bản ghi mỗi trang",
                            "zeroRecords": "Không tìm thấy bản ghi nào",
                            "info": "Hiển thị trang _PAGE_ của _PAGES_",
                            "infoEmpty": "Không có bản ghi nào",
                            "infoFiltered": "(đã lọc từ _MAX_ bản ghi)",
                            "search": "Tìm kiếm:",
                            "paginate": {
                            "first": "Đầu",
                                    "last": "Cuối",
                                    "next": "Tiếp",
                                    "previous": "Trước"
                            }
                    }
            });
            } else {
            console.error('DataTables plugin not loaded');
            }
            }

            window.updateChart = function(type) {
            if (!window.trafficChart) {
            console.error('Traffic chart not initialized');
            return;
            }

            switch (type) {
            case 'visits':
                    trafficChart.data.datasets[0].data = [
            <c:forEach items="${stats.dailyStats}" var="day" varStatus="loop">
                ${day.visits}<c:if test="${!loop.last}">,</c:if>
            </c:forEach>
            ];
            trafficChart.data.datasets[0].label = 'Lượt truy cập';
            break;
            case 'users':
                    trafficChart.data.datasets[0].data = [
            <c:forEach items="${stats.dailyStats}" var="day" varStatus="loop">
                ${day.uniqueVisitors}<c:if test="${!loop.last}">,</c:if>
            </c:forEach>
            ];
            trafficChart.data.datasets[0].label = 'Người dùng';
            break;
            case 'duration':
                    trafficChart.data.datasets[0].data = [
            <c:forEach items="${stats.dailyStats}" var="day" varStatus="loop">
                ${day.avgDuration / 60}<c:if test="${!loop.last}">,</c:if>
            </c:forEach>
            ];
            trafficChart.data.datasets[0].label = 'Thời gian TB (phút)';
            break;
            }
            trafficChart.update();
            }

            window.filterByDate = function() {
            const date = document.getElementById('dateFilter').value;
            console.log('Filtering by date:', date);
            const formattedDate = formatDateForComparison(date);
            const table = $('#dailyStatsTable').DataTable();
            table.search(formattedDate).draw();
            }

            function formatDateForComparison(dateString) {
            const date = new Date(dateString);
            const day = date.getDate().toString().padStart(2, '0');
            const month = (date.getMonth() + 1).toString().padStart(2, '0');
            return `${day}/${month}`;
                }

                function showErrorAlert(message) {
                const errorDiv = document.createElement('div');
                errorDiv.className = 'alert alert-danger';
                errorDiv.textContent = message;
                document.querySelector('.tab-content').prepend(errorDiv);
                }
        </script>
    </body>
</html>