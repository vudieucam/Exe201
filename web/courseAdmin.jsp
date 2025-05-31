<%-- 
    Document   : courseAdmin
    Created on : May 31, 2025, 6:21:39 PM
    Author     : FPT
--%>


<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


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
                    <div class="tab-content">

                        <!-- Courses Tab -->
                        <div class="tab-pane show active" id="courses">

                            <h2 class="mb-4">Quản lý Khóa học</h2>

                            <!-- Filter Section -->
                            <div class="filter-section">
                                <div class="row">

                                    <div class="col-md-3">
                                        <label class="form-label filter-title">Tìm kiếm</label>
                                        <div class="input-group">
                                            <input type="text" class="form-control" id="course-search" placeholder="Tìm kiếm..." oninput="filterCourseTable(this, 1)">
                                            <button class="btn btn-primary" type="button">
                                                <i class="bi bi-search"></i>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="card">
                                <div class="card-header d-flex justify-content-between align-items-center">
                                    <div>
                                        <button class="btn btn-primary me-2" data-bs-toggle="modal" data-bs-target="#addCourseModal">
                                            <i class="bi bi-plus-circle me-1"></i> Thêm khóa học
                                        </button>

                                    </div>
                                    <div>
                                        <div class="btn-group">
                                            <button class="btn btn-sm btn-outline-secondary active">Tất cả (86)</button>
                                            <button class="btn btn-sm btn-outline-secondary">Đang hoạt động (72)</button>
                                            <button class="btn btn-sm btn-outline-secondary">Bản nháp (8)</button>
                                            <button class="btn btn-sm btn-outline-secondary">Lưu trữ (6)</button>
                                        </div>
                                    </div>
                                </div>
                                <div class="card-body">
                                    <div class="table-responsive">
                                        <table class="table table-hover" id="courses-table">
                                            <thead>
                                                <tr>
                                                    <th style="width: 50px">#</th>
                                                    <th>Khóa học</th>
                                                    <th>Giảng viên</th>
                                                    <th>Danh mục</th>
                                                    <th>Học viên</th>
                                                    <th>Đánh giá</th>
                                                    <th>Trạng thái</th>
                                                    <th style="width: 100px">Hành động</th>
                                                </tr>
                                                <tr>
                                                    <th style="width: 50px">
                                                        <input type="text" class="form-control form-control-sm" placeholder="#" 
                                                               oninput="filterCourseTable(this, 0)" />
                                                    </th>
                                                    <th>
                                                        <input type="text" class="form-control form-control-sm" placeholder="Tên khóa học" 
                                                               oninput="filterCourseTable(this, 1)" />
                                                    </th>
                                                    <th>
                                                        <input type="text" class="form-control form-control-sm" placeholder="Giảng viên" 
                                                               oninput="filterCourseTable(this, 2)" />
                                                    </th>
                                                    <th>
                                                        <select class="form-select form-select-sm" onchange="filterCourseTable(this, 3)">
                                                            <option value="">Tất cả</option>
                                                            <option value="Lập trình">Lập trình</option>
                                                            <option value="Thiết kế">Thiết kế</option>
                                                            <option value="Kinh doanh">Kinh doanh</option>
                                                            <option value="Ngôn ngữ">Ngôn ngữ</option>
                                                        </select>
                                                    </th>
                                                    <th>
                                                        <input type="text" class="form-control form-control-sm" placeholder="Số lượng" 
                                                               oninput="filterCourseTable(this, 4)" />
                                                    </th>
                                                    <th>
                                                        <input type="text" class="form-control form-control-sm" placeholder="Điểm" 
                                                               oninput="filterCourseTable(this, 5)" />
                                                    </th>
                                                    <th>
                                                        <select class="form-select form-select-sm" onchange="filterCourseTable(this, 6)">
                                                            <option value="">Tất cả</option>
                                                            <option value="Đang hoạt động">Đang hoạt động</option>
                                                            <option value="Bản nháp">Bản nháp</option>
                                                            <option value="Lưu trữ">Lưu trữ</option>
                                                        </select>
                                                    </th>
                                                    <th style="width: 100px"></th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr>
                                                    <td>1</td>
                                                    <td>
                                                        <div class="d-flex align-items-center">
                                                            <img src="https://via.placeholder.com/40" class="rounded me-2" width="40" height="40">
                                                            <div>
                                                                <h6 class="mb-0">Lập trình Python cơ bản</h6>
                                                                <small class="text-muted">12 bài học</small>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>Nguyễn Văn A</td>
                                                    <td><span class="badge bg-primary">Lập trình</span></td>
                                                    <td>1,245</td>
                                                    <td>
                                                        <div class="d-flex align-items-center">
                                                            <i class="bi bi-star-fill text-warning me-1"></i>
                                                            <span>4.8</span>
                                                        </div>
                                                    </td>
                                                    <td><span class="status-badge status-active">Đang hoạt động</span></td>
                                                    <td>
                                                        <button class="btn btn-sm btn-outline-primary action-btn">
                                                            <i class="bi bi-eye"></i>
                                                        </button>
                                                        <button class="btn btn-sm btn-outline-secondary action-btn">
                                                            <i class="bi bi-pencil"></i>
                                                        </button>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>2</td>
                                                    <td>
                                                        <div class="d-flex align-items-center">
                                                            <img src="https://via.placeholder.com/40" class="rounded me-2" width="40" height="40">
                                                            <div>
                                                                <h6 class="mb-0">Thiết kế UI/UX</h6>
                                                                <small class="text-muted">15 bài học</small>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>Trần Thị B</td>
                                                    <td><span class="badge bg-success">Thiết kế</span></td>
                                                    <td>876</td>
                                                    <td>
                                                        <div class="d-flex align-items-center">
                                                            <i class="bi bi-star-fill text-warning me-1"></i>
                                                            <span>4.7</span>
                                                        </div>
                                                    </td>
                                                    <td><span class="status-badge status-active">Đang hoạt động</span></td>
                                                    <td>
                                                        <button class="btn btn-sm btn-outline-primary action-btn">
                                                            <i class="bi bi-eye"></i>
                                                        </button>
                                                        <button class="btn btn-sm btn-outline-secondary action-btn">
                                                            <i class="bi bi-pencil"></i>
                                                        </button>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>3</td>
                                                    <td>
                                                        <div class="d-flex align-items-center">
                                                            <img src="https://via.placeholder.com/40" class="rounded me-2" width="40" height="40">
                                                            <div>
                                                                <h6 class="mb-0">Marketing Online</h6>
                                                                <small class="text-muted">10 bài học</small>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>Lê Văn C</td>
                                                    <td><span class="badge bg-info">Kinh doanh</span></td>
                                                    <td>654</td>
                                                    <td>
                                                        <div class="d-flex align-items-center">
                                                            <i class="bi bi-star-fill text-warning me-1"></i>
                                                            <span>4.5</span>
                                                        </div>
                                                    </td>
                                                    <td><span class="status-badge status-active">Đang hoạt động</span></td>
                                                    <td>
                                                        <button class="btn btn-sm btn-outline-primary action-btn">
                                                            <i class="bi bi-eye"></i>
                                                        </button>
                                                        <button class="btn btn-sm btn-outline-secondary action-btn">
                                                            <i class="bi bi-pencil"></i>
                                                        </button>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>4</td>
                                                    <td>
                                                        <div class="d-flex align-items-center">
                                                            <img src="https://via.placeholder.com/40" class="rounded me-2" width="40" height="40">
                                                            <div>
                                                                <h6 class="mb-0">Tiếng Anh giao tiếp</h6>
                                                                <small class="text-muted">20 bài học</small>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>Phạm Thị D</td>
                                                    <td><span class="badge bg-warning">Ngôn ngữ</span></td>
                                                    <td>1,532</td>
                                                    <td>
                                                        <div class="d-flex align-items-center">
                                                            <i class="bi bi-star-fill text-warning me-1"></i>
                                                            <span>4.9</span>
                                                        </div>
                                                    </td>
                                                    <td><span class="status-badge status-active">Đang hoạt động</span></td>
                                                    <td>
                                                        <button class="btn btn-sm btn-outline-primary action-btn">
                                                            <i class="bi bi-eye"></i>
                                                        </button>
                                                        <button class="btn btn-sm btn-outline-secondary action-btn">
                                                            <i class="bi bi-pencil"></i>
                                                        </button>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>5</td>
                                                    <td>
                                                        <div class="d-flex align-items-center">
                                                            <img src="https://via.placeholder.com/40" class="rounded me-2" width="40" height="40">
                                                            <div>
                                                                <h6 class="mb-0">Machine Learning</h6>
                                                                <small class="text-muted">18 bài học</small>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>Hoàng Văn E</td>
                                                    <td><span class="badge bg-primary">Lập trình</span></td>
                                                    <td>723</td>
                                                    <td>
                                                        <div class="d-flex align-items-center">
                                                            <i class="bi bi-star-fill text-warning me-1"></i>
                                                            <span>4.6</span>
                                                        </div>
                                                    </td>
                                                    <td><span class="status-badge status-draft">Bản nháp</span></td>
                                                    <td>
                                                        <button class="btn btn-sm btn-outline-primary action-btn">
                                                            <i class="bi bi-eye"></i>
                                                        </button>
                                                        <button class="btn btn-sm btn-outline-secondary action-btn">
                                                            <i class="bi bi-pencil"></i>
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



                        <!-- Add Course Modal -->
                        <div class="modal fade" id="addCourseModal" tabindex="-1" aria-labelledby="addCourseModalLabel" aria-hidden="true">
                            <div class="modal-dialog modal-lg">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="addCourseModalLabel">Thêm khóa học mới</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <form>
                                            <div class="row mb-3">
                                                <div class="col-md-6">
                                                    <label for="courseName" class="form-label">Tên khóa học</label>
                                                    <input type="text" class="form-control" id="courseName" required>
                                                </div>
                                                <div class="col-md-6">
                                                    <label for="courseCategory" class="form-label">Danh mục</label>
                                                    <select class="form-select" id="courseCategory" required>
                                                        <option value="">Chọn danh mục</option>
                                                        <option value="programming">Lập trình</option>
                                                        <option value="design">Thiết kế</option>
                                                        <option value="business">Kinh doanh</option>
                                                        <option value="language">Ngôn ngữ</option>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="row mb-3">
                                                <div class="col-md-6">
                                                    <label for="courseInstructor" class="form-label">Giảng viên</label>
                                                    <select class="form-select" id="courseInstructor" required>
                                                        <option value="">Chọn giảng viên</option>
                                                        <option value="1">Nguyễn Văn A</option>
                                                        <option value="2">Trần Thị B</option>
                                                        <option value="3">Lê Văn C</option>
                                                    </select>
                                                </div>
                                                <div class="col-md-6">
                                                    <label for="courseLevel" class="form-label">Cấp độ</label>
                                                    <select class="form-select" id="courseLevel" required>
                                                        <option value="">Chọn cấp độ</option>
                                                        <option value="beginner">Cơ bản</option>
                                                        <option value="intermediate">Trung cấp</option>
                                                        <option value="advanced">Nâng cao</option>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="mb-3">
                                                <label for="courseDescription" class="form-label">Mô tả khóa học</label>
                                                <textarea class="form-control" id="courseDescription" rows="3" required></textarea>
                                            </div>
                                            <div class="mb-3">
                                                <label for="courseThumbnail" class="form-label">Ảnh đại diện</label>
                                                <input class="form-control" type="file" id="courseThumbnail" accept="image/*">
                                            </div>
                                            <div class="row mb-3">
                                                <div class="col-md-4">
                                                    <label for="coursePrice" class="form-label">Giá (VND)</label>
                                                    <input type="number" class="form-control" id="coursePrice" min="0">
                                                </div>
                                                <div class="col-md-4">
                                                    <label for="courseDiscount" class="form-label">Giảm giá (%)</label>
                                                    <input type="number" class="form-control" id="courseDiscount" min="0" max="100">
                                                </div>
                                                <div class="col-md-4">
                                                    <label for="courseStatus" class="form-label">Trạng thái</label>
                                                    <select class="form-select" id="courseStatus" required>
                                                        <option value="draft">Bản nháp</option>
                                                        <option value="active">Đang hoạt động</option>
                                                        <option value="archived">Lưu trữ</option>
                                                    </select>
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                        <button type="button" class="btn btn-primary">Lưu khóa học</button>
                                    </div>
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



                                                            function filterCourseTable(input, columnIndex) {
                                                                const filter = input.value.toUpperCase();
                                                                const table = document.getElementById("courses-table");
                                                                const rows = table.getElementsByTagName("tr");

                                                                // Bắt đầu từ 2 để bỏ qua 2 hàng header
                                                                for (let i = 2; i < rows.length; i++) {
                                                                    const cell = rows[i].getElementsByTagName("td")[columnIndex];
                                                                    if (cell) {
                                                                        let txtValue = cell.textContent || cell.innerText;

                                                                        // Xử lý đặc biệt cho cột đánh giá
                                                                        if (columnIndex === 5) {
                                                                            const ratingSpan = cell.querySelector('span');
                                                                            if (ratingSpan) {
                                                                                txtValue = ratingSpan.textContent || ratingSpan.innerText;
                                                                            }
                                                                        }

                                                                        // Xử lý đặc biệt cho cột trạng thái
                                                                        if (columnIndex === 6) {
                                                                            const statusSpan = cell.querySelector('.status-badge');
                                                                            if (statusSpan) {
                                                                                txtValue = statusSpan.textContent || statusSpan.innerText;
                                                                            }
                                                                        }

                                                                        if (txtValue.toUpperCase().indexOf(filter) > -1) {
                                                                            rows[i].style.display = "";
                                                                        } else {
                                                                            rows[i].style.display = "none";
                                                                        }
                                                                    }
                                                                }
                                                            }


        </script>
    </body>
</html>
