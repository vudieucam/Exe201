<%-- 
    Document   : userAdmin
    Created on : May 31, 2025, 6:28:44 PM
    Author     : FPT
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản Lý Người Dùng - PetShop Admin</title>
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
                        <h2>Quản Lý Người Dùng</h2>
                        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addUserModal">
                            <i class="bi bi-plus-lg"></i> Thêm người dùng
                        </button>
                    </div>

                    <!-- Filter Section -->
                    <div class="card mb-4">
                        <div class="card-body">
                            <div class="row g-3">
                                <div class="col-md-4">
                                    <label for="searchInput" class="form-label">Tìm kiếm</label>
                                    <input type="text" class="form-control" id="searchInput" placeholder="Tên, email...">
                                </div>
                                <div class="col-md-3">
                                    <label for="roleFilter" class="form-label">Vai trò</label>
                                    <select class="form-select" id="roleFilter">
                                        <option value="">Tất cả</option>
                                        <option value="1">Khách hàng</option>
                                        <option value="2">Nhân viên</option>
                                        <option value="3">Quản trị viên</option>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <label for="statusFilter" class="form-label">Trạng thái</label>
                                    <select class="form-select" id="statusFilter">
                                        <option value="">Tất cả</option>
                                        <option value="active">Hoạt động</option>
                                        <option value="inactive">Không hoạt động</option>
                                    </select>
                                </div>
                                <div class="col-md-2 d-flex align-items-end">
                                    <button class="btn btn-primary w-100" id="filterBtn">Lọc</button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Users Table -->
                    <div class="card">
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover mb-0">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Thông tin</th>
                                            <th>Vai trò</th>
                                            <th>Địa chỉ</th>
                                            <th>Trạng thái</th>
                                            <th>Ngày tạo</th>
                                            <th>Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>1</td>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <img src="https://ui-avatars.com/api/?name=Nguyễn+Văn+A&background=random" class="user-avatar">
                                                    <div>
                                                        <h6 class="mb-0">Nguyễn Văn A</h6>
                                                        <small class="text-muted">nguyenvana@gmail.com</small>
                                                    </div>
                                                </div>
                                            </td>
                                            <td><span class="badge bg-primary">Khách hàng</span></td>
                                            <td>Hà Nội</td>
                                            <td><span class="status-badge status-active">Hoạt động</span></td>
                                            <td>15/05/2023</td>
                                            <td>
                                                <button class="btn btn-sm btn-outline-primary action-btn" data-bs-toggle="modal" data-bs-target="#editUserModal">
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
                                                    <img src="https://ui-avatars.com/api/?name=Trần+Thị+B&background=random" class="user-avatar">
                                                    <div>
                                                        <h6 class="mb-0">Trần Thị B</h6>
                                                        <small class="text-muted">tranthib@gmail.com</small>
                                                    </div>
                                                </div>
                                            </td>
                                            <td><span class="badge bg-warning text-dark">Nhân viên</span></td>
                                            <td>Đà Nẵng</td>
                                            <td><span class="status-badge status-active">Hoạt động</span></td>
                                            <td>20/06/2023</td>
                                            <td>
                                                <button class="btn btn-sm btn-outline-primary action-btn" data-bs-toggle="modal" data-bs-target="#editUserModal">
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
                                                    <img src="https://ui-avatars.com/api/?name=Lê+Văn+C&background=random" class="user-avatar">
                                                    <div>
                                                        <h6 class="mb-0">Lê Văn C</h6>
                                                        <small class="text-muted">levanc@gmail.com</small>
                                                    </div>
                                                </div>
                                            </td>
                                            <td><span class="badge bg-danger">Admin</span></td>
                                            <td>TP.HCM</td>
                                            <td><span class="status-badge status-inactive">Không hoạt động</span></td>
                                            <td>10/04/2023</td>
                                            <td>
                                                <button class="btn btn-sm btn-outline-primary action-btn" data-bs-toggle="modal" data-bs-target="#editUserModal">
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
                        </div>
                    </div>

                    <!-- Pagination -->
                    <nav class="mt-4">
                        <ul class="pagination justify-content-center">
                            <li class="page-item disabled">
                                <a class="page-link" href="#" tabindex="-1">Trước</a>
                            </li>
                            <li class="page-item active"><a class="page-link" href="#">1</a></li>
                            <li class="page-item"><a class="page-link" href="#">2</a></li>
                            <li class="page-item"><a class="page-link" href="#">3</a></li>
                            <li class="page-item">
                                <a class="page-link" href="#">Tiếp</a>
                            </li>
                        </ul>
                    </nav>
                </div>
            </div>
        </div>

        <!-- Add User Modal -->
        <div class="modal fade" id="addUserModal" tabindex="-1" aria-labelledby="addUserModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="addUserModalLabel">Thêm người dùng mới</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form>
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label for="fullname" class="form-label">Họ và tên</label>
                                    <input type="text" class="form-control" id="fullname" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="email" class="form-label">Email</label>
                                    <input type="email" class="form-control" id="email" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="phone" class="form-label">Số điện thoại</label>
                                    <input type="tel" class="form-control" id="phone">
                                </div>
                                <div class="col-md-6">
                                    <label for="password" class="form-label">Mật khẩu</label>
                                    <input type="password" class="form-control" id="password" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="role" class="form-label">Vai trò</label>
                                    <select class="form-select" id="role" required>
                                        <option value="1">Khách hàng</option>
                                        <option value="2">Nhân viên</option>
                                        <option value="3">Quản trị viên</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label for="status" class="form-label">Trạng thái</label>
                                    <select class="form-select" id="status" required>
                                        <option value="active">Hoạt động</option>
                                        <option value="inactive">Không hoạt động</option>
                                    </select>
                                </div>
                                <div class="col-12">
                                    <label for="address" class="form-label">Địa chỉ</label>
                                    <textarea class="form-control" id="address" rows="2"></textarea>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                        <button type="button" class="btn btn-primary">Lưu thông tin</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Edit User Modal -->
        <div class="modal fade" id="editUserModal" tabindex="-1" aria-labelledby="editUserModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="editUserModalLabel">Chỉnh sửa thông tin người dùng</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form>
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label for="editFullname" class="form-label">Họ và tên</label>
                                    <input type="text" class="form-control" id="editFullname" value="Nguyễn Văn A" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="editEmail" class="form-label">Email</label>
                                    <input type="email" class="form-control" id="editEmail" value="nguyenvana@gmail.com" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="editPhone" class="form-label">Số điện thoại</label>
                                    <input type="tel" class="form-control" id="editPhone" value="0987654321">
                                </div>
                                <div class="col-md-6">
                                    <label for="editPassword" class="form-label">Mật khẩu (để trống nếu không đổi)</label>
                                    <input type="password" class="form-control" id="editPassword">
                                </div>
                                <div class="col-md-6">
                                    <label for="editRole" class="form-label">Vai trò</label>
                                    <select class="form-select" id="editRole" required>
                                        <option value="1">Khách hàng</option>
                                        <option value="2" selected>Nhân viên</option>
                                        <option value="3">Quản trị viên</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label for="editStatus" class="form-label">Trạng thái</label>
                                    <select class="form-select" id="editStatus" required>
                                        <option value="active" selected>Hoạt động</option>
                                        <option value="inactive">Không hoạt động</option>
                                    </select>
                                </div>
                                <div class="col-12">
                                    <label for="editAddress" class="form-label">Địa chỉ</label>
                                    <textarea class="form-control" id="editAddress" rows="2">123 Đường ABC, Quận 1, TP.HCM</textarea>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                        <button type="button" class="btn btn-primary">Cập nhật</button>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Simple filter functionality
            document.getElementById('filterBtn').addEventListener('click', function() {
                const searchText = document.getElementById('searchInput').value.toLowerCase();
                const roleFilter = document.getElementById('roleFilter').value;
                const statusFilter = document.getElementById('statusFilter').value;
                
                const rows = document.querySelectorAll('tbody tr');
                
                rows.forEach(row => {
                    const name = row.querySelector('h6').textContent.toLowerCase();
                    const email = row.querySelector('small').textContent.toLowerCase();
                    const role = row.querySelector('td:nth-child(3) span').textContent;
                    const status = row.querySelector('td:nth-child(5) span').textContent;
                    
                    const matchSearch = name.includes(searchText) || email.includes(searchText);
                    const matchRole = roleFilter === '' || 
                        (roleFilter === '1' && role === 'Khách hàng') ||
                        (roleFilter === '2' && role === 'Nhân viên') ||
                        (roleFilter === '3' && role === 'Admin');
                    const matchStatus = statusFilter === '' || 
                        (statusFilter === 'active' && status === 'Hoạt động') ||
                        (statusFilter === 'inactive' && status === 'Không hoạt động');
                    
                    if (matchSearch && matchRole && matchStatus) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                });
            });
        </script>
    </body>
</html>