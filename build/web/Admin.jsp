<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

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
        </style>
    </head>
    <body>
        <div class="container-fluid">
            <div class="row">
                <!-- Sidebar -->
                <div class="col-md-2 sidebar p-0">
                    <div class="sidebar-brand">
                        <img src="images/logo_pettech.jpg" alt="Logo">
                        <h4 class="mb-0">PetTech</h4>
                    </div>
                    <ul class="nav flex-column mt-3">
                        <li class="nav-item">
                            <a class="nav-link active" href="admin">
                                <i class="bi bi-speedometer2"></i>Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="userAdmin.jsp">
                                <i class="bi bi-people"></i>Người dùng
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="courseadmin">
                                <i class="bi bi-book"></i>Khóa học
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="productsAdmin.jsp">
                                <i class="bi bi-cart"></i>Sản phẩm
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="ordersAdmin.jsp">
                                <i class="bi bi-receipt"></i>Đơn hàng
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="paymentsAdmin.jsp">
                                <i class="bi bi-credit-card"></i>Thanh toán
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="blogsAdmin.jsp">
                                <i class="bi bi-newspaper"></i>Blog
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="partnersAdmin.jsp">
                                <i class="bi bi-building"></i>Đối tác
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="reports.jsp">
                                <i class="bi bi-graph-up"></i>Báo cáo
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="settings.jsp">
                                <i class="bi bi-gear"></i>Cài đặt
                            </a>
                        </li>
                    </ul>

                    <!-- Admin Profile Section -->
                    <div class="admin-profile">
                        <div class="dropdown">
                            <a href="#" class="dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">
                                <img src="https://via.placeholder.com/40" alt="Admin Avatar" class="admin-avatar">
                                <div class="admin-info">
                                    <div class="admin-name">Admin Name</div>
                                    <div class="admin-role">Quản trị viên</div>
                                </div>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <li><a class="dropdown-item" href="editProfile.jsp">
                                        <i class="bi bi-person me-2"></i>Thông tin cá nhân
                                    </a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item logout" href="authen?action=login">
                                        <i class="bi bi-box-arrow-right me-2"></i>Đăng xuất
                                    </a></li>
                            </ul>
                        </div>
                    </div>
                </div>

                <!-- Main Content -->
                <div class="col-md-10 p-4">
                    <div class="tab-content">
                        <!-- Dashboard Tab -->
                        <div class="tab-pane active" id="dashboard">
                            <h2 class="mb-4">Dashboard Tổng quan</h2>

                            <!-- Stat Cards -->
                            <div class="row mb-4">
                                <div class="col-md-3 mb-3">
                                    <div class="card stat-card bg-dark text-white animate-fade" style="animation-delay: 0.5s">
                                        <div class="card-body">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <div>
                                                    <h5 class="card-title">Thống kê truy cập</h5>

                                                    <!-- Dòng hiển thị số người đang online -->
                                                    <div class="d-flex align-items-center mb-2">
                                                        <span class="badge bg-success me-2" style="width: 10px; height: 10px; border-radius: 50%;"></span>
                                                        <div>
                                                            <span class="small">Đang online:</span>
                                                            <h4 class="mb-0 d-inline-block ms-2">${onlineUsers}</h4>
                                                        </div>
                                                    </div>

                                                    <!-- Dòng hiển thị tổng lượt truy cập -->
                                                    <div class="d-flex align-items-center">
                                                        <span class="badge bg-primary me-2" style="width: 10px; height: 10px; border-radius: 50%;"></span>
                                                        <div>
                                                            <span class="small">Tổng lượt:</span>
                                                            <h4 class="mb-0 d-inline-block ms-2">${totalVisitors}</h4>
                                                        </div>
                                                    </div>

                                                    <!-- Badge hiển thị trạng thái -->
                                                    <c:choose>
                                                        <c:when test="${onlineUsers > 50}">
                                                            <span class="badge bg-success mt-2">Cao điểm</span>
                                                        </c:when>
                                                        <c:when test="${onlineUsers > 20}">
                                                            <span class="badge bg-warning text-dark mt-2">Bình thường</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary mt-2">Thấp điểm</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <i class="bi bi-people fs-1 opacity-50"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-md-3 mb-3">
                                    <div class="card stat-card bg-primary text-white animate-fade" style="animation-delay: 0.1s">
                                        <div class="card-body">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <div>
                                                    <h5 class="card-title">Người dùng</h5>
                                                    <h2 class="card-text">${totalUsers}</h2>
                                                    <span class="badge bg-white text-primary">+12%</span>
                                                </div>
                                                <i class="bi bi-people fs-1 opacity-50"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-3 mb-3">
                                    <div class="card stat-card bg-success text-white animate-fade" style="animation-delay: 0.2s">
                                        <div class="card-body">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <div>
                                                    <h5 class="card-title">Khóa học</h5>
                                                    <h2 class="card-text">${totalCourses}</h2>
                                                    <span class="badge bg-white text-success">+5%</span>
                                                </div>
                                                <i class="bi bi-book fs-1 opacity-50"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-3 mb-3">
                                    <div class="card stat-card bg-info text-white animate-fade" style="animation-delay: 0.3s">
                                        <div class="card-body">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <div>
                                                    <h5 class="card-title">Đơn hàng</h5>
                                                    <h2 class="card-text">${totalOrders}</h2>
                                                    <span class="badge bg-white text-info">-3%</span>
                                                </div>
                                                <i class="bi bi-cart fs-1 opacity-50"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-3 mb-3">
                                    <div class="card stat-card bg-warning text-dark animate-fade" style="animation-delay: 0.4s">
                                        <div class="card-body">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <div>
                                                    <h5 class="card-title">Doanh thu</h5>
                                                    <h2 class="card-text">₫<fmt:formatNumber value="${totalRevenue}" pattern="#,##0.00"/></h2>
                                                    <span class="badge bg-white text-warning">+8%</span>
                                                </div>
                                                <i class="bi bi-currency-dollar fs-1 opacity-50"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>


                            <!-- Recent Activities -->
                            <div class="card mb-4">
                                <div class="card-header">
                                    <h5 class="mb-0">Hoạt động gần đây</h5>
                                </div>
                                <div class="card-body p-0">
                                    <div class="list-group list-group-flush">
                                        <c:forEach var="user" items="${recentUsers}">
                                            <div class="list-group-item border-0 py-3">
                                                <div class="d-flex align-items-center">
                                                    <div class="bg-primary bg-opacity-10 p-2 rounded-circle">
                                                        <i class="bi bi-person-plus text-primary"></i>
                                                    </div>
                                                    <div class="ms-3">
                                                        <h6 class="mb-0">Người dùng mới đăng ký</h6>
                                                        <small class="text-muted">${user.fullname} - <fmt:formatDate value="${user.created_at}" pattern="dd/MM/yyyy HH:mm"/></small>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>

                                        <c:forEach var="order" items="${recentOrders}">
                                            <div class="list-group-item border-0 py-3">
                                                <div class="d-flex align-items-center">
                                                    <div class="bg-success bg-opacity-10 p-2 rounded-circle">
                                                        <i class="bi bi-cart-check text-success"></i>
                                                    </div>
                                                    <div class="ms-3">
                                                        <h6 class="mb-0">Đơn hàng mới</h6>
                                                        <small class="text-muted">Đơn #${order.id} - <fmt:formatNumber value="${order.total_amount}" type="currency" currencySymbol="₫"/></small>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>

                                        <c:forEach var="payment" items="${recentPayments}">
                                            <div class="list-group-item border-0 py-3">
                                                <div class="d-flex align-items-center">
                                                    <div class="bg-info bg-opacity-10 p-2 rounded-circle">
                                                        <i class="bi bi-credit-card text-info"></i>
                                                    </div>
                                                    <div class="ms-3">
                                                        <h6 class="mb-0">Thanh toán mới</h6>
                                                        <small class="text-muted">Số tiền: <fmt:formatNumber value="${payment.amount}" type="currency" currencySymbol="₫"/> - <fmt:formatDate value="${payment.payment_date}" pattern="dd/MM/yyyy HH:mm"/></small>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </div>

                            <!-- Top Courses -->
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="mb-0">Khóa học phổ biến</h5>
                                </div>
                                <div class="card-body p-0">
                                    <div class="table-responsive">
                                        <table class="table table-hover mb-0">
                                            <thead>
                                                <tr>
                                                    <th>Khóa học</th>
                                                    <th>Lượt truy cập</th>
                                                    <th>Tỉ lệ hoàn thành</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="course" items="${popularCourses}">
                                                    <tr>
                                                        <td>
                                                            <div class="d-flex align-items-center">
                                                                <img src="/images/course/course_${course.id}.jpg" class="rounded me-2" width="40" height="40" alt="${course.title}">
                                                                <span>${course.title}</span>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <c:set var="accessCount" value="${courseDAO.getAccessCount(course.id)}"/>
                                                            ${accessCount}
                                                        </td>
                                                        <td>
                                                            <div class="d-flex align-items-center">
                                                                <div class="progress progress-thin w-100 me-2">
                                                                    <c:set var="completionRate" value="${courseDAO.getCompletionRate(course.id)}"/>
                                                                    <div class="progress-bar bg-success" style="width: ${completionRate}%"></div>
                                                                </div>
                                                                <span>${completionRate}%</span>
                                                            </div>
                                                        </td>
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
            </div>

            <!-- Scripts -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
            <script>
                const dailyVisits = ${dailyVisitsJson}; // [{"date":"2025-05-30", "count":120}, ...]
            </script>

            <script>
                // Initialize Select2
                $(document).ready(function () {
                    $('.form-select').select2({
                        minimumResultsForSearch: Infinity
                    });
                    // Initialize charts
                    const visitsCtx = document.getElementById('visitsChart').getContext('2d');
                    const visitsChart = new Chart(visitsCtx, {
                        type: 'line',
                        data: {
                            labels: ['Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7', 'CN'],
                            datasets: [
                                {
                                    label: 'Lượt truy cập',
                                    data: [1200, 1900, 1700, 2100, 2300, 2000, 1800],
                                    borderColor: '#4361ee',
                                    backgroundColor: 'rgba(67, 97, 238, 0.1)',
                                    tension: 0.3,
                                    fill: true
                                },
                                {
                                    label: 'Đăng ký mới',
                                    data: [40, 60, 55, 75, 80, 70, 65],
                                    borderColor: '#4cc9f0',
                                    backgroundColor: 'rgba(76, 201, 240, 0.1)',
                                    tension: 0.3,
                                    fill: true
                                }
                            ]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            plugins: {
                                legend: {
                                    position: 'top',
                                }
                            },
                            scales: {
                                y: {
                                    beginAtZero: true
                                }
                            }
                        }
                    });
                    const packagesCtx = document.getElementById('packagesChart').getContext('2d');
                    const packagesChart = new Chart(packagesCtx, {
                        type: 'doughnut',
                        data: {
                            labels: ['Free', 'Standard', 'Pro'],
                            datasets: [{
                                    data: [35, 40, 25],
                                    backgroundColor: [
                                        '#6c757d',
                                        '#38b000',
                                        '#4361ee'
                                    ],
                                    borderWidth: 0
                                }]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            plugins: {
                                legend: {
                                    position: 'right',
                                }
                            },
                            cutout: '70%'
                        }
                    });
                });

                document.addEventListener('DOMContentLoaded', function () {
                    const tables = document.querySelectorAll('table');

                    tables.forEach(table => {
                        const filters = table.querySelectorAll('thead input, thead select');
                        const rows = table.querySelectorAll('tbody tr');

                        if (!filters.length || !rows.length)
                            return;

                        filters.forEach((filter, i) => {
                            filter.addEventListener('input', () => {
                                const filterValues = Array.from(filters).map(f => f.value.toLowerCase().trim());
                                rows.forEach(row => {
                                    const cells = row.querySelectorAll('td');
                                    let visible = true;
                                    filterValues.forEach((val, j) => {
                                        if (!val)
                                            return;
                                        const text = cells[j]?.textContent?.toLowerCase() || '';
                                        if (!text.includes(val))
                                            visible = false;
                                    });
                                    row.style.display = visible ? '' : 'none';
                                });
                            });
                        });
                    });
                });
            </script>
    </body>
</html>