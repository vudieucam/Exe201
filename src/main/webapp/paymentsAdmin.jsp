<%-- 
    Document   : paymentsAdmin
    Created on : May 31, 2025, 6:28:44 PM
    Author     : FPT
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản Lý Thanh Toán - PetShop Admin</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
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
                            <a class="nav-link" href="${pageContext.request.contextPath}/blogadmin">
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
                                <li><a class="dropdown-item logout" href="home">
                                    <i class="bi bi-box-arrow-right me-2"></i>Đăng xuất
                                </a></li>
                            </ul>
                        </div>
                    </div>
                </div>


                <!-- Main Content -->
                <div class="col-md-10 p-4">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2>Quản Lý Thanh Toán</h2>
                    </div>

                    <!-- Filter Section -->
                    <div class="filter-section">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="form-label filter-title">Trạng thái</label>
                                <select class="form-select" id="payment-status-filter">
                                    <option value="all">Tất cả trạng thái</option>
                                    <option value="success">Thành công</option>
                                    <option value="pending">Đang chờ</option>
                                    <option value="failed">Thất bại</option>
                                    <option value="refunded">Hoàn tiền</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label filter-title">Phương thức</label>
                                <select class="form-select" id="payment-method-filter">
                                    <option value="all">Tất cả phương thức</option>
                                    <option value="bank">Chuyển khoản</option>
                                    <option value="card">Thẻ tín dụng</option>
                                    <option value="paypal">PayPal</option>
                                    <option value="momo">Momo</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label filter-title">Khoảng thời gian</label>
                                <select class="form-select" id="payment-date-filter">
                                    <option value="all">Tất cả thời gian</option>
                                    <option value="today">Hôm nay</option>
                                    <option value="week">Tuần này</option>
                                    <option value="month">Tháng này</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label filter-title">Tìm kiếm</label>
                                <div class="input-group">
                                    <input type="text" class="form-control" id="payment-search" placeholder="Mã thanh toán...">
                                    <button class="btn btn-primary" type="button" id="search-btn">
                                        <i class="bi bi-search"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Payments Table -->
                    <div class="card">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <div>
                                <button class="btn btn-outline-secondary me-2" id="advanced-filter-btn">
                                    <i class="bi bi-funnel me-1"></i> Lọc nâng cao
                                </button>
                                <button class="btn btn-outline-secondary" id="export-excel-btn">
                                    <i class="bi bi-download me-1"></i> Xuất Excel
                                </button>
                            </div>
                            <div>
                                <div class="btn-group">
                                    <button class="btn btn-sm btn-outline-secondary active">Tất cả (298)</button>
                                    <button class="btn btn-sm btn-outline-secondary">Thành công (265)</button>
                                    <button class="btn btn-sm btn-outline-secondary">Đang chờ (18)</button>
                                    <button class="btn btn-sm btn-outline-secondary">Thất bại (15)</button>
                                </div>
                            </div>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-hover" id="payments-table">
                                    <thead>
                                        <tr>
                                            <th style="width: 50px">#</th>
                                            <th>Mã thanh toán</th>
                                            <th>Đơn hàng</th>
                                            <th>Khách hàng</th>
                                            <th>Số tiền</th>
                                            <th>Phương thức</th>
                                            <th>Ngày thanh toán</th>
                                            <th>Trạng thái</th>
                                            <th style="width: 100px">Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>1</td>
                                            <td>PAY-2306001</td>
                                            <td>ORD-2306001</td>
                                            <td>Nguyễn Văn A</td>
                                            <td>₫3,450,000</td>
                                            <td><span class="badge bg-primary">Chuyển khoản</span></td>
                                            <td>15/06/2023 09:30</td>
                                            <td><span class="status-badge status-active">Thành công</span></td>
                                            <td>
                                                <button class="btn btn-sm btn-outline-primary action-btn" data-bs-toggle="modal" data-bs-target="#paymentDetailModal">
                                                    <i class="bi bi-eye"></i>
                                                </button>
                                                <button class="btn btn-sm btn-outline-secondary action-btn">
                                                    <i class="bi bi-receipt"></i>
                                                </button>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>2</td>
                                            <td>PAY-2306002</td>
                                            <td>ORD-2306002</td>
                                            <td>Trần Thị B</td>
                                            <td>₫1,500,000</td>
                                            <td><span class="badge bg-success">Thẻ tín dụng</span></td>
                                            <td>14/06/2023 14:15</td>
                                            <td><span class="status-badge status-pending">Đang chờ</span></td>
                                            <td>
                                                <button class="btn btn-sm btn-outline-primary action-btn" data-bs-toggle="modal" data-bs-target="#paymentDetailModal">
                                                    <i class="bi bi-eye"></i>
                                                </button>
                                                <button class="btn btn-sm btn-outline-secondary action-btn">
                                                    <i class="bi bi-receipt"></i>
                                                </button>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>3</td>
                                            <td>PAY-2306003</td>
                                            <td>ORD-2306003</td>
                                            <td>Lê Văn C</td>
                                            <td>₫5,200,000</td>
                                            <td><span class="badge bg-info">Momo</span></td>
                                            <td>13/06/2023 10:45</td>
                                            <td><span class="status-badge status-active">Thành công</span></td>
                                            <td>
                                                <button class="btn btn-sm btn-outline-primary action-btn" data-bs-toggle="modal" data-bs-target="#paymentDetailModal">
                                                    <i class="bi bi-eye"></i>
                                                </button>
                                                <button class="btn btn-sm btn-outline-secondary action-btn">
                                                    <i class="bi bi-receipt"></i>
                                                </button>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>4</td>
                                            <td>PAY-2306004</td>
                                            <td>ORD-2306004</td>
                                            <td>Phạm Thị D</td>
                                            <td>₫250,000</td>
                                            <td><span class="badge bg-warning">PayPal</span></td>
                                            <td>12/06/2023 16:20</td>
                                            <td><span class="status-badge status-inactive">Thất bại</span></td>
                                            <td>
                                                <button class="btn btn-sm btn-outline-primary action-btn" data-bs-toggle="modal" data-bs-target="#paymentDetailModal">
                                                    <i class="bi bi-eye"></i>
                                                </button>
                                                <button class="btn btn-sm btn-outline-secondary action-btn">
                                                    <i class="bi bi-receipt"></i>
                                                </button>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>5</td>
                                            <td>PAY-2306005</td>
                                            <td>ORD-2306005</td>
                                            <td>Hoàng Văn E</td>
                                            <td>₫7,800,000</td>
                                            <td><span class="badge bg-info">Momo</span></td>
                                            <td>11/06/2023 11:10</td>
                                            <td><span class="status-badge status-active">Thành công</span></td>
                                            <td>
                                                <button class="btn btn-sm btn-outline-primary action-btn" data-bs-toggle="modal" data-bs-target="#paymentDetailModal">
                                                    <i class="bi bi-eye"></i>
                                                </button>
                                                <button class="btn btn-sm btn-outline-secondary action-btn">
                                                    <i class="bi bi-receipt"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>

                            <!-- Pagination -->
                            <nav aria-label="Page navigation" class="mt-3">
                                <ul class="pagination justify-content-center">
                                    <li class="page-item disabled">
                                        <a class="page-link" href="#" tabindex="-1" aria-disabled="true">
                                            <i class="bi bi-chevron-left"></i>
                                        </a>
                                    </li>
                                    <li class="page-item active"><a class="page-link" href="#">1</a></li>
                                    <li class="page-item"><a class="page-link" href="#">2</a></li>
                                    <li class="page-item"><a class="page-link" href="#">3</a></li>
                                    <li class="page-item"><a class="page-link" href="#">4</a></li>
                                    <li class="page-item"><a class="page-link" href="#">5</a></li>
                                    <li class="page-item">
                                        <a class="page-link" href="#">
                                            <i class="bi bi-chevron-right"></i>
                                        </a>
                                    </li>
                                </ul>
                            </nav>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Payment Detail Modal -->
        <div class="modal fade" id="paymentDetailModal" tabindex="-1" aria-labelledby="paymentDetailModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="paymentDetailModalLabel">Chi tiết thanh toán #PAY-2306001</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="row mb-4">
                            <div class="col-md-6">
                                <h6>Thông tin khách hàng</h6>
                                <div class="card p-3">
                                    <p class="mb-1"><strong>Họ tên:</strong> Nguyễn Văn A</p>
                                    <p class="mb-1"><strong>Email:</strong> nguyenvana@gmail.com</p>
                                    <p class="mb-1"><strong>SĐT:</strong> 0987654321</p>
                                    <p class="mb-0"><strong>Địa chỉ:</strong> 123 Đường ABC, Quận 1, TP.HCM</p>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <h6>Thông tin thanh toán</h6>
                                <div class="card p-3">
                                    <p class="mb-1"><strong>Mã thanh toán:</strong> PAY-2306001</p>
                                    <p class="mb-1"><strong>Mã đơn hàng:</strong> ORD-2306001</p>
                                    <p class="mb-1"><strong>Ngày thanh toán:</strong> 15/06/2023 09:30</p>
                                    <p class="mb-1"><strong>Phương thức:</strong> Chuyển khoản</p>
                                    <p class="mb-0"><strong>Trạng thái:</strong> <span class="status-badge status-active">Thành công</span></p>
                                </div>
                            </div>
                        </div>

                        <h6>Chi tiết giao dịch</h6>
                        <div class="table-responsive mb-4">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Mã giao dịch</th>
                                        <th>Ngân hàng</th>
                                        <th>Số tài khoản</th>
                                        <th>Người nhận</th>
                                        <th>Số tiền</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>TRANS-2306001</td>
                                        <td>Vietcombank</td>
                                        <td>***1234</td>
                                        <td>Công ty TNHH PetShop</td>
                                        <td>₫3,450,000</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="card p-3 mb-3">
                                    <h6>Ghi chú thanh toán</h6>
                                    <p class="mb-0">Thanh toán cho đơn hàng ORD-2306001 gồm 2 sản phẩm</p>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="card p-3">
                                    <h6>Tổng cộng</h6>
                                    <div class="d-flex justify-content-between mb-2">
                                        <span>Tổng đơn hàng:</span>
                                        <span>₫3,450,000</span>
                                    </div>
                                    <div class="d-flex justify-content-between mb-2">
                                        <span>Phí thanh toán:</span>
                                        <span>₫0</span>
                                    </div>
                                    <div class="d-flex justify-content-between fw-bold">
                                        <span>Tổng thanh toán:</span>
                                        <span>₫3,450,000</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                        <button type="button" class="btn btn-primary">In biên lai</button>
                        <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#updatePaymentStatusModal">Cập nhật trạng thái</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Update Payment Status Modal -->
        <div class="modal fade" id="updatePaymentStatusModal" tabindex="-1" aria-labelledby="updatePaymentStatusModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="updatePaymentStatusModalLabel">Cập nhật trạng thái thanh toán</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form>
                            <div class="mb-3">
                                <label for="payment-status" class="form-label">Trạng thái hiện tại</label>
                                <input type="text" class="form-control" id="current-payment-status" value="Thành công" readonly>
                            </div>
                            <div class="mb-3">
                                <label for="new-payment-status" class="form-label">Cập nhật trạng thái</label>
                                <select class="form-select" id="new-payment-status">
                                    <option value="success">Thành công</option>
                                    <option value="pending">Đang chờ</option>
                                    <option value="failed">Thất bại</option>
                                    <option value="refunded">Hoàn tiền</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="payment-note" class="form-label">Ghi chú</label>
                                <textarea class="form-control" id="payment-note" rows="3"></textarea>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="button" class="btn btn-primary">Cập nhật</button>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Filter functionality
            document.getElementById('search-btn').addEventListener('click', function() {
                const searchText = document.getElementById('payment-search').value.toLowerCase();
                const statusFilter = document.getElementById('payment-status-filter').value;
                const methodFilter = document.getElementById('payment-method-filter').value;
                const dateFilter = document.getElementById('payment-date-filter').value;
                
                const rows = document.querySelectorAll('#payments-table tbody tr');
                
                rows.forEach(row => {
                    const paymentCode = row.querySelector('td:nth-child(2)').textContent.toLowerCase();
                    const customerName = row.querySelector('td:nth-child(4)').textContent.toLowerCase();
                    const status = row.querySelector('td:nth-child(8) span').textContent;
                    const method = row.querySelector('td:nth-child(6) span').textContent;
                    
                    const matchSearch = paymentCode.includes(searchText) || customerName.includes(searchText);
                    const matchStatus = statusFilter === 'all' || 
                        (statusFilter === 'success' && status === 'Thành công') ||
                        (statusFilter === 'pending' && status === 'Đang chờ') ||
                        (statusFilter === 'failed' && status === 'Thất bại') ||
                        (statusFilter === 'refunded' && status === 'Hoàn tiền');
                    
                    const matchMethod = methodFilter === 'all' || 
                        (methodFilter === 'bank' && method === 'Chuyển khoản') ||
                        (methodFilter === 'card' && method === 'Thẻ tín dụng') ||
                        (methodFilter === 'paypal' && method === 'PayPal') ||
                        (methodFilter === 'momo' && method === 'Momo');
                    
                    if (matchSearch && matchStatus && matchMethod) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                });
            });
            
            // Advanced filter button
            document.getElementById('advanced-filter-btn').addEventListener('click', function() {
                alert('Chức năng lọc nâng cao sẽ được mở rộng trong phiên bản sau');
            });
            
            // Export Excel button
            document.getElementById('export-excel-btn').addEventListener('click', function() {
                alert('Chức năng xuất Excel sẽ được triển khai sau');
            });
        </script>
    </body>
</html>