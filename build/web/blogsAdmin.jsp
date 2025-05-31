<%-- 
    Document   : blogsAdmin
    Created on : May 31, 2025, 6:28:44 PM
    Author     : FPT
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản Lý Blog - PetShop Admin</title>
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
                        <h2>Quản Lý Blog</h2>
                    </div>

                    <!-- Filter Section -->
                    <div class="filter-section">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="form-label filter-title">Danh mục</label>
                                <select class="form-select" id="blog-category-filter">
                                    <option value="all">Tất cả danh mục</option>
                                    <option value="technology">Công nghệ</option>
                                    <option value="education">Giáo dục</option>
                                    <option value="business">Kinh doanh</option>
                                    <option value="tips">Mẹo hay</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label filter-title">Trạng thái</label>
                                <select class="form-select" id="blog-status-filter">
                                    <option value="all">Tất cả trạng thái</option>
                                    <option value="published">Đã xuất bản</option>
                                    <option value="draft">Bản nháp</option>
                                    <option value="archived">Lưu trữ</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label filter-title">Tác giả</label>
                                <select class="form-select" id="blog-author-filter">
                                    <option value="all">Tất cả tác giả</option>
                                    <option value="1">Nguyễn Văn A</option>
                                    <option value="2">Trần Thị B</option>
                                    <option value="3">Admin</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label filter-title">Tìm kiếм</label>
                                <div class="input-group">
                                    <input type="text" class="form-control" id="blog-search" placeholder="Tiêu đề bài viết...">
                                    <button class="btn btn-primary" type="button" id="blog-search-btn">
                                        <i class="bi bi-search"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Blogs Table -->
                    <div class="card">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <div>
                                <button class="btn btn-primary me-2" data-bs-toggle="modal" data-bs-target="#addBlogModal">
                                    <i class="bi bi-plus-circle me-1"></i> Thêm bài viết
                                </button>
                                <button class="btn btn-outline-secondary" id="advanced-filter-btn">
                                    <i class="bi bi-funnel me-1"></i> Lọc nâng cao
                                </button>
                            </div>
                            <div>
                                <div class="btn-group">
                                    <button class="btn btn-sm btn-outline-secondary active">Tất cả (76)</button>
                                    <button class="btn btn-sm btn-outline-secondary">Đã xuất bản (62)</button>
                                    <button class="btn btn-sm btn-outline-secondary">Bản nháp (8)</button>
                                    <button class="btn btn-sm btn-outline-secondary">Lưu trữ (6)</button>
                                </div>
                            </div>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-hover" id="blogs-table">
                                    <thead>
                                        <tr>
                                            <th style="width: 50px">#</th>
                                            <th>Tiêu đề</th>
                                            <th>Danh mục</th>
                                            <th>Tác giả</th>
                                            <th>Lượt xem</th>
                                            <th>Ngày đăng</th>
                                            <th>Trạng thái</th>
                                            <th style="width: 120px">Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>1</td>
                                            <td>10 xu hướng công nghệ 2023</td>
                                            <td><span class="badge bg-primary">Công nghệ</span></td>
                                            <td>Nguyễn Văn A</td>
                                            <td>1,245</td>
                                            <td>15/06/2023</td>
                                            <td><span class="status-badge status-active">Đã xuất bản</span></td>
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
                                            <td>Học Python trong 30 ngày</td>
                                            <td><span class="badge bg-info">Giáo dục</span></td>
                                            <td>Trần Thị B</td>
                                            <td>876</td>
                                            <td>14/06/2023</td>
                                            <td><span class="status-badge status-active">Đã xuất bản</span></td>
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
                                            <td>Chiến lược marketing 2023</td>
                                            <td><span class="badge bg-success">Kinh doanh</span></td>
                                            <td>Admin</td>
                                            <td>1,024</td>
                                            <td>13/06/2023</td>
                                            <td><span class="status-badge status-active">Đã xuất bản</span></td>
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
                                            <td>Mẹo học lập trình hiệu quả</td>
                                            <td><span class="badge bg-warning">Mẹo hay</span></td>
                                            <td>Nguyễn Văn A</td>
                                            <td>2,156</td>
                                            <td>12/06/2023</td>
                                            <td><span class="status-badge status-active">Đã xuất bản</span></td>
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
                                            <td>5</td>
                                            <td>Cách chăm sóc thú cưng mùa hè</td>
                                            <td><span class="badge bg-warning">Mẹo hay</span></td>
                                            <td>Trần Thị B</td>
                                            <td>3,542</td>
                                            <td>10/06/2023</td>
                                            <td><span class="status-badge status-active">Đã xuất bản</span></td>
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
                                    <li class="page-item"><a class="page-link" href="#">4</a></li>
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

        <!-- Add Blog Modal -->
        <div class="modal fade" id="addBlogModal" tabindex="-1" aria-labelledby="addBlogModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="addBlogModalLabel">Thêm bài viết mới</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form>
                            <div class="row mb-3">
                                <div class="col-md-8">
                                    <label for="blog-title" class="form-label">Tiêu đề bài viết</label>
                                    <input type="text" class="form-control" id="blog-title" placeholder="Nhập tiêu đề bài viết">
                                </div>
                                <div class="col-md-4">
                                    <label for="blog-category" class="form-label">Danh mục</label>
                                    <select class="form-select" id="blog-category">
                                        <option value="technology">Công nghệ</option>
                                        <option value="education">Giáo dục</option>
                                        <option value="business">Kinh doanh</option>
                                        <option value="tips">Mẹo hay</option>
                                    </select>
                                </div>
                            </div>

                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="blog-author" class="form-label">Tác giả</label>
                                    <select class="form-select" id="blog-author">
                                        <option value="1">Nguyễn Văn A</option>
                                        <option value="2">Trần Thị B</option>
                                        <option value="3">Admin</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label for="blog-status" class="form-label">Trạng thái</label>
                                    <select class="form-select" id="blog-status">
                                        <option value="published">Đã xuất bản</option>
                                        <option value="draft">Bản nháp</option>
                                        <option value="archived">Lưu trữ</option>
                                    </select>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="blog-image" class="form-label">Ảnh đại diện</label>
                                <input class="form-control" type="file" id="blog-image">
                            </div>

                            <div class="mb-3">
                                <label for="blog-content" class="form-label">Nội dung bài viết</label>
                                <textarea class="form-control" id="blog-content" rows="10" placeholder="Nhập nội dung bài viết..."></textarea>
                            </div>

                            <div class="mb-3">
                                <label for="blog-tags" class="form-label">Tags</label>
                                <input type="text" class="form-control" id="blog-tags" placeholder="Nhập tags, cách nhau bằng dấu phẩy">
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="button" class="btn btn-primary">Lưu nháp</button>
                        <button type="button" class="btn btn-success">Xuất bản</button>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Filter functionality
            document.getElementById('blog-search-btn').addEventListener('click', function () {
                const searchText = document.getElementById('blog-search').value.toLowerCase();
                const categoryFilter = document.getElementById('blog-category-filter').value;
                const statusFilter = document.getElementById('blog-status-filter').value;
                const authorFilter = document.getElementById('blog-author-filter').value;

                const rows = document.querySelectorAll('#blogs-table tbody tr');

                rows.forEach(row => {
                    const title = row.querySelector('td:nth-child(2)').textContent.toLowerCase();
                    const category = row.querySelector('td:nth-child(3) span').textContent;
                    const author = row.querySelector('td:nth-child(4)').textContent;
                    const status = row.querySelector('td:nth-child(7) span').textContent;

                    const matchSearch = title.includes(searchText);
                    const matchCategory = categoryFilter === 'all' ||
                            (categoryFilter === 'technology' && category === 'Công nghệ') ||
                            (categoryFilter === 'education' && category === 'Giáo dục') ||
                            (categoryFilter === 'business' && category === 'Kinh doanh') ||
                            (categoryFilter === 'tips' && category === 'Mẹo hay');

                    const matchStatus = statusFilter === 'all' ||
                            (statusFilter === 'published' && status === 'Đã xuất bản') ||
                            (statusFilter === 'draft' && status === 'Bản nháp') ||
                            (statusFilter === 'archived' && status === 'Lưu trữ');

                    const matchAuthor = authorFilter === 'all' ||
                            (authorFilter === '1' && author === 'Nguyễn Văn A') ||
                            (authorFilter === '2' && author === 'Trần Thị B') ||
                            (authorFilter === '3' && author === 'Admin');

                    if (matchSearch && matchCategory && matchStatus && matchAuthor) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                });
            });

            // Advanced filter button
            document.getElementById('advanced-filter-btn').addEventListener('click', function () {
                alert('Chức năng lọc nâng cao sẽ được mở rộng trong phiên bản sau');
            });
        </script>
    </body>
</html>