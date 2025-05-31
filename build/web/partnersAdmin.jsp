<%-- 
    Document   : partnersAdmin
    Created on : May 31, 2025, 6:28:44 PM
    Author     : FPT
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản Lý Đối Tác - PetShop Admin</title>
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
                        <img src="images/logo_pettech.jpg" alt="Logo">
                        <h4 class="mb-0">PetTech</h4>
                    </div>
                    <ul class="nav flex-column mt-3">
                        <li class="nav-item">
                            <a class="nav-link active" href="Admin.jsp">
                                <i class="bi bi-speedometer2"></i>Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="userAdmin.jsp">
                                <i class="bi bi-people"></i>Người dùng
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="courseAdmin.jsp">
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
                        <h2>Quản Lý Đối Tác</h2>
                    </div>

                    <!-- Filter Section -->
                    <div class="filter-section">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="form-label filter-title">Loại đối tác</label>
                                <select class="form-select" id="partner-type-filter">
                                    <option value="all">Tất cả loại</option>
                                    <option value="education">Giáo dục</option>
                                    <option value="technology">Công nghệ</option>
                                    <option value="business">Kinh doanh</option>
                                    <option value="other">Khác</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label filter-title">Trạng thái</label>
                                <select class="form-select" id="partner-status-filter">
                                    <option value="all">Tất cả trạng thái</option>
                                    <option value="active">Đang hợp tác</option>
                                    <option value="inactive">Ngừng hợp tác</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label filter-title">Quốc gia</label>
                                <select class="form-select" id="partner-country-filter">
                                    <option value="all">Tất cả quốc gia</option>
                                    <option value="vn">Việt Nam</option>
                                    <option value="us">Mỹ</option>
                                    <option value="uk">Anh</option>
                                    <option value="jp">Nhật Bản</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label filter-title">Tìm kiếm</label> 
                                <div class="input-group"> 
                                    <input type="text" class="form-control" id="partner-search" placeholder="Tên đối tác..."> 
                                    <button class="btn btn-primary" type="button" id="partner-search-btn"> 
                                        <i class="bi bi-search"></i> 
                                    </button> 
                                </div> 
                            </div> 
                        </div> 
                    </div>

                    <!-- Partners Table -->
                    <div class="card"> 
                        <div class="card-header d-flex justify-content-between align-items-center"> 
                            <div> 
                                <button class="btn btn-primary me-2" data-bs-toggle="modal" data-bs-target="#addPartnerModal"> 
                                    <i class="bi bi-plus-circle me-1"></i> Thêm đối tác 
                                </button> 
                                <button class="btn btn-outline-secondary"> 
                                    <i class="bi bi-download me-1"></i> Xuất Excel 
                                </button> 
                            </div> 
                            <div> 
                                <div class="btn-group"> 
                                    <button class="btn btn-sm btn-outline-secondary active">Tất cả (24)</button> 
                                    <button class="btn btn-sm btn-outline-secondary">Đang hợp tác (18)</button> 
                                    <button class="btn btn-sm btn-outline-secondary">Ngừng hợp tác (6)</button> 
                                </div> 
                            </div> 
                        </div> 
                        <div class="card-body"> 
                            <div class="table-responsive"> 
                                <table class="table table-hover" id="partners-table"> 
                                    <thead> 
                                        <tr> 
                                            <th style="width: 50px">#</th> 
                                            <th>Đối tác</th> 
                                            <th>Loại</th> 
                                            <th>Quốc gia</th> 
                                            <th>Ngày hợp tác</th> 
                                            <th>Dự án</th> 
                                            <th>Trạng thái</th> 
                                            <th style="width: 120px">Hành động</th> 
                                        </tr> 
                                    </thead> 
                                    <tbody> 
                                        <tr> 
                                            <td>1</td> 
                                            <td> 
                                                <div class="d-flex align-items-center"> 
                                                    <img src="https://via.placeholder.com/40" class="rounded me-2" width="40" height="40"> 
                                                    <div> 
                                                        <h6 class="mb-0">Công ty ABC Tech</h6> 
                                                        <small class="text-muted">contact@abctech.com</small> 
                                                    </div> 
                                                </div> 
                                            </td> 
                                            <td><span class="badge bg-primary">Công nghệ</span></td> 
                                            <td>Việt Nam</td> 
                                            <td>15/05/2022</td> 
                                            <td>5</td> 
                                            <td><span class="status-badge status-active">Đang hợp tác</span></td> 
                                            <td> 
                                                <button class="btn btn-sm btn-outline-primary action-btn"> 
                                                    <i class="bi bi-eye"></i> 
                                                </button> 
                                                <button class="btn btn-sm btn-outline-success action-btn"> 
                                                    <i class="bi bi-pencil"></i> 
                                                </button> 
                                                <button class="btn btn-sm btn-outline-danger action-btn"> 
                                                    <i class="bi bi-trash"></i> 
                                                </button> 
                                            </td> 
                                        </tr> 
                                        <tr> 
                                            <td>2</td> 
                                            <td> 
                                                <div class="d-flex align-items-center"> 
                                                    <img src="https://via.placeholder.com/40" class="rounded me-2" width="40" height="40"> 
                                                    <div> 
                                                        <h6 class="mb-0">Đại học XYZ</h6> 
                                                        <small class="text-muted">info@xyz.edu.vn</small> 
                                                    </div> 
                                                </div> 
                                            </td> 
                                            <td><span class="badge bg-info">Giáo dục</span></td> 
                                            <td>Mỹ</td> 
                                            <td>22/08/2021</td> 
                                            <td>3</td> 
                                            <td><span class="status-badge status-active">Đang hợp tác</span></td> 
                                            <td> 
                                                <button class="btn btn-sm btn-outline-primary action-btn"> 
                                                    <i class="bi bi-eye"></i> 
                                                </button> 
                                                <button class="btn btn-sm btn-outline-success action-btn"> 
                                                    <i class="bi bi-pencil"></i> 
                                                </button> 
                                                <button class="btn btn-sm btn-outline-danger action-btn"> 
                                                    <i class="bi bi-trash"></i> 
                                                </button> 
                                            </td> 
                                        </tr> 
                                        <tr> 
                                            <td>3</td> 
                                            <td> 
                                                <div class="d-flex align-items-center"> 
                                                    <img src="https://via.placeholder.com/40" class="rounded me-2" width="40" height="40"> 
                                                    <div> 
                                                        <h6 class="mb-0">Tập đoàn DEF</h6> 
                                                        <small class="text-muted">partner@defgroup.com</small> 
                                                    </div> 
                                                </div> 
                                            </td> 
                                            <td><span class="badge bg-success">Kinh doanh</span></td> 
                                            <td>Nhật Bản</td> 
                                            <td>10/03/2020</td> 
                                            <td>7</td> 
                                            <td><span class="status-badge status-inactive">Ngừng hợp tác</span></td> 
                                            <td> 
                                                <button class="btn btn-sm btn-outline-primary action-btn"> 
                                                    <i class="bi bi-eye"></i> 
                                                </button> 
                                                <button class="btn btn-sm btn-outline-success action-btn"> 
                                                    <i class="bi bi-pencil"></i> 
                                                </button> 
                                                <button class="btn btn-sm btn-outline-danger action-btn"> 
                                                    <i class="bi bi-trash"></i> 
                                                </button> 
                                            </td> 
                                        </tr> 
                                        <tr> 
                                            <td>4</td> 
                                            <td> 
                                                <div class="d-flex align-items-center"> 
                                                    <img src="https://via.placeholder.com/40" class="rounded me-2" width="40" height="40"> 
                                                    <div> 
                                                        <h6 class="mb-0">Công ty GHI Solutions</h6> 
                                                        <small class="text-muted">support@ghisolutions.com</small> 
                                                    </div> 
                                                </div> 
                                            </td> 
                                            <td><span class="badge bg-warning">Khác</span></td> 
                                            <td>Anh</td> 
                                            <td>05/12/2022</td> 
                                            <td>2</td> 
                                            <td><span class="status-badge status-active">Đang hợp tác</span></td> 
                                            <td> 
                                                <button class="btn btn-sm btn-outline-primary action-btn"> 
                                                    <i class="bi bi-eye"></i> 
                                                </button> 
                                                <button class="btn btn-sm btn-outline-success action-btn"> 
                                                    <i class="bi bi-pencil"></i> 
                                                </button> 
                                                <button class="btn btn-sm btn-outline-danger action-btn"> 
                                                    <i class="bi bi-trash"></i> 
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

        <!-- Add Partner Modal -->
        <div class="modal fade" id="addPartnerModal" tabindex="-1" aria-labelledby="addPartnerModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="addPartnerModalLabel">Thêm đối tác mới</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form>
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="partner-name" class="form-label">Tên đối tác</label>
                                    <input type="text" class="form-control" id="partner-name" placeholder="Nhập tên đối tác">
                                </div>
                                <div class="col-md-6">
                                    <label for="partner-email" class="form-label">Email</label>
                                    <input type="email" class="form-control" id="partner-email" placeholder="Nhập email đối tác">
                                </div>
                            </div>
                            
                            <div class="row mb-3">
                                <div class="col-md-4">
                                    <label for="partner-type" class="form-label">Loại đối tác</label>
                                    <select class="form-select" id="partner-type">
                                        <option value="education">Giáo dục</option>
                                        <option value="technology">Công nghệ</option>
                                        <option value="business">Kinh doanh</option>
                                        <option value="other">Khác</option>
                                    </select>
                                </div>
                                <div class="col-md-4">
                                    <label for="partner-country" class="form-label">Quốc gia</label>
                                    <select class="form-select" id="partner-country">
                                        <option value="vn">Việt Nam</option>
                                        <option value="us">Mỹ</option>
                                        <option value="uk">Anh</option>
                                        <option value="jp">Nhật Bản</option>
                                    </select>
                                </div>
                                <div class="col-md-4">
                                    <label for="partner-status" class="form-label">Trạng thái</label>
                                    <select class="form-select" id="partner-status">
                                        <option value="active">Đang hợp tác</option>
                                        <option value="inactive">Ngừng hợp tác</option>
                                    </select>
                                </div>
                            </div>
                            
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="partner-date" class="form-label">Ngày hợp tác</label>
                                    <input type="date" class="form-control" id="partner-date">
                                </div>
                                <div class="col-md-6">
                                    <label for="partner-projects" class="form-label">Số dự án hợp tác</label>
                                    <input type="number" class="form-control" id="partner-projects" placeholder="Nhập số dự án">
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="partner-logo" class="form-label">Logo đối tác</label>
                                <input class="form-control" type="file" id="partner-logo">
                            </div>
                            
                            <div class="mb-3">
                                <label for="partner-description" class="form-label">Mô tả đối tác</label>
                                <textarea class="form-control" id="partner-description" rows="5" placeholder="Nhập mô tả về đối tác..."></textarea>
                            </div>
                            
                            <div class="mb-3">
                                <label for="partner-website" class="form-label">Website</label>
                                <input type="url" class="form-control" id="partner-website" placeholder="https://example.com">
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="button" class="btn btn-primary">Lưu lại</button>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Filter functionality
            document.getElementById('partner-search-btn').addEventListener('click', function() {
                const searchText = document.getElementById('partner-search').value.toLowerCase();
                const typeFilter = document.getElementById('partner-type-filter').value;
                const statusFilter = document.getElementById('partner-status-filter').value;
                const countryFilter = document.getElementById('partner-country-filter').value;
                
                const rows = document.querySelectorAll('#partners-table tbody tr');
                
                rows.forEach(row => {
                    const name = row.querySelector('td:nth-child(2) h6').textContent.toLowerCase();
                    const type = row.querySelector('td:nth-child(3) span').textContent;
                    const country = row.querySelector('td:nth-child(4)').textContent;
                    const status = row.querySelector('td:nth-child(7) span').textContent;
                    
                    const matchSearch = name.includes(searchText);
                    const matchType = typeFilter === 'all' || 
                        (typeFilter === 'education' && type === 'Giáo dục') ||
                        (typeFilter === 'technology' && type === 'Công nghệ') ||
                        (typeFilter === 'business' && type === 'Kinh doanh') ||
                        (typeFilter === 'other' && type === 'Khác');
                    
                    const matchStatus = statusFilter === 'all' || 
                        (statusFilter === 'active' && status === 'Đang hợp tác') ||
                        (statusFilter === 'inactive' && status === 'Ngừng hợp tác');
                    
                    const matchCountry = countryFilter === 'all' || 
                        (countryFilter === 'vn' && country === 'Việt Nam') ||
                        (countryFilter === 'us' && country === 'Mỹ') ||
                        (countryFilter === 'uk' && country === 'Anh') ||
                        (countryFilter === 'jp' && country === 'Nhật Bản');
                    
                    if (matchSearch && matchType && matchStatus && matchCountry) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                });
            });
        </script>
    </body>
</html>