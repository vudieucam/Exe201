<%@page import="model.Blog"%>
<%@page import="model.BlogCategory"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản Lý Blog - PetShop Admin</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
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
            /* Thêm style cho modal */
            .modal-content {
                border-radius: 15px;
                border: none;
            }
            .modal-header {
                border-bottom: none;
                padding-bottom: 0;
            }
            .modal-footer {
                border-top: none;
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
            .blog-image {
                width: 80px;
                height: 60px;
                object-fit: cover;
                border-radius: 5px;
            }

            .table th, .table td {
                white-space: nowrap;
                text-overflow: ellipsis;
                overflow: hidden;
                max-width: 200px;
            }

            .table td {
                padding: 12px 15px;
            }
        </style>
    </head>
    <body>
        <div class="container-fluid">
            <div class="row">
                <!-- Sidebar -->
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
                        <h2>Quản Lý Blog</h2>
                        <div>
                            <button class="btn btn-primary me-2" data-bs-toggle="modal" data-bs-target="#addBlogModal">
                                <i class="bi bi-plus-lg"></i> Thêm bài viết
                            </button>
                            <a href="blogcategory" class="btn btn-success">
                                <i class="bi bi-list-ul"></i> Quản lý danh mục
                            </a>
                        </div>
                    </div>

                    <!-- Filter Section (Tương tự trang user) -->
                    <div class="card mb-4">
                        <div class="card-body">
                            <form action="blogadmin" method="get">
                                <div class="row g-3">
                                    <div class="col-md-4">
                                        <label for="search" class="form-label">Tìm kiếm</label>
                                        <input type="text" class="form-control" id="search" name="search" 
                                               placeholder="Tìm theo tiêu đề, nội dung..." value="${param.search}">
                                    </div>
                                    <div class="col-md-3">
                                        <label for="statusFilter" class="form-label">Trạng thái</label>
                                        <select class="form-select" id="statusFilter" name="statusFilter">
                                            <option value="">Tất cả</option>
                                            <option value="active" ${param.statusFilter eq 'active' ? 'selected' : ''}>Hiển thị</option>
                                            <option value="inactive" ${param.statusFilter eq 'inactive' ? 'selected' : ''}>Ẩn</option>
                                        </select>
                                    </div>
                                    <div class="col-md-3">
                                        <label for="featuredFilter" class="form-label">Nổi bật</label>
                                        <select class="form-select" id="featuredFilter" name="featuredFilter">
                                            <option value="">Tất cả</option>
                                            <option value="featured" ${param.featuredFilter eq 'featured' ? 'selected' : ''}>Nổi bật</option>
                                            <option value="normal" ${param.featuredFilter eq 'normal' ? 'selected' : ''}>Bình thường</option>
                                        </select>
                                    </div>
                                    <div class="col-md-2 d-flex align-items-end">
                                        <button type="submit" class="btn btn-primary w-100">
                                            <i class="bi bi-funnel"></i> Lọc
                                        </button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Blogs Table -->
                    <div class="card">
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover mb-0">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Hình ảnh</th>
                                            <th>Tiêu đề</th>
                                            <th>Danh mục</th>
                                            <th>Tác giả</th>
                                            <th>Lượt xem</th>
                                            <th>Nổi bật</th>
                                            <th>Trạng thái</th>
                                            <th>Ngày tạo</th>
                                            <th>Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="blog" items="${blogs}">
                                            <tr>
                                                <td>${blog.blogId}</td>
                                                <td>
                                                    <c:if test="${not empty blog.imageUrl}">
                                                        <img src="${pageContext.request.contextPath}/${blog.imageUrl}" class="blog-image" alt="Blog Image">
                                                    </c:if>

                                                </td>
                                                <td>${blog.title}</td>
                                                <td>${blog.categoryName}</td>
                                                <td>${blog.authorName}</td>
                                                <td>${blog.viewCount}</td>
                                                <td>
                                                    <span class="badge ${blog.isFeatured ? 'bg-success' : 'bg-secondary'}">
                                                        ${blog.isFeatured ? 'Có' : 'Không'}
                                                    </span>

                                                </td>
                                                <td>
                                                    <span class="badge ${blog.status == 1 ? 'bg-success' : 'bg-secondary'}">
                                                        ${blog.status == 1 ? 'Hiển thị' : 'Ẩn'}
                                                    </span>

                                                </td>
                                                <td><fmt:formatDate value="${blog.createdAt}" pattern="dd/MM/yyyy"/></td>
                                                <td>
                                                    <button class="btn btn-sm btn-outline-primary action-btn edit-btn"
                                                            data-bs-toggle="modal" data-bs-target="#editBlogModal"
                                                            data-id="${blog.blogId}"
                                                            data-title="${blog.title}"
                                                            data-shortdescription="${blog.shortDescription}"
                                                            data-content="${blog.content}"
                                                            data-categoryid="${blog.categoryId}"
                                                            data-authorname="${blog.authorName}"
                                                            data-imageurl="${blog.imageUrl}"
                                                            data-isfeatured="${blog.isFeatured}"
                                                            data-status="${blog.status}">
                                                        <i class="bi bi-pencil"></i>
                                                    </button>
                                                    <button class="btn btn-sm btn-outline-warning action-btn" 
                                                            onclick="toggleBlogStatus(${blog.blogId})">
                                                        <i class="bi ${blog.status == 1 ? 'bi-eye-slash' : 'bi-eye'}"></i>
                                                    </button>
                                                    <button class="btn btn-sm btn-outline-danger action-btn" 
                                                            onclick="confirmDelete(${blog.blogId})">
                                                        <i class="bi bi-trash"></i>
                                                    </button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <!-- Pagination -->
                    <nav class="mt-4">
                        <ul class="pagination justify-content-center">
                            <c:if test="${currentPage > 1}">
                                <li class="page-item">
                                    <a class="page-link" href="blogadmin?page=${currentPage-1}&search=${param.search}&statusFilter=${param.statusFilter}&featuredFilter=${param.featuredFilter}">Trước</a>
                                </li>
                            </c:if>

                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${currentPage eq i ? 'active' : ''}">
                                    <a class="page-link" href="blogadmin?page=${i}&search=${param.search}&statusFilter=${param.statusFilter}&featuredFilter=${param.featuredFilter}">${i}</a>
                                </li>
                            </c:forEach>

                            <c:if test="${currentPage < totalPages}">
                                <li class="page-item">
                                    <a class="page-link" href="blogadmin?page=${currentPage+1}&search=${param.search}&statusFilter=${param.statusFilter}&featuredFilter=${param.featuredFilter}">Tiếp</a>
                                </li>
                            </c:if>
                        </ul>
                    </nav>
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
                    <form action="blogadmin" method="POST" enctype="multipart/form-data">

                        <input type="hidden" name="action" value="insert">
                        <div class="modal-body">
                            <div class="row g-3">
                                <div class="col-md-12">
                                    <label for="title" class="form-label">Tiêu đề</label>
                                    <input type="text" class="form-control" id="title" name="title" required>
                                </div>
                                <div class="col-md-12">
                                    <label for="shortDescription" class="form-label">Mô tả ngắn</label>
                                    <textarea class="form-control" id="shortDescription" name="shortDescription" rows="2" required></textarea>
                                </div>
                                <div class="col-md-12">
                                    <label for="content" class="form-label">Nội dung</label>
                                    <textarea class="form-control" id="content" name="content" rows="15" required style="min-height: 300px;"></textarea>
                                </div>
                                <div class="col-md-6">
                                    <label for="categoryId" class="form-label">Danh mục</label>
                                    <select class="form-select" id="categoryId" name="categoryId" required>
                                        <c:forEach var="category" items="${categories}">
                                            <option value="${category.categoryId}">${category.categoryName}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label for="authorName" class="form-label">Tác giả</label>
                                    <input type="text" class="form-control" id="authorName" name="authorName" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="imageFile" class="form-label">Tải ảnh</label>
                                    <input type="file" class="form-control" id="imageFile" name="imageFile" accept="image/*">

                                </div>
                                <div class="col-md-6">
                                    <label for="isFeatured" class="form-label">Nổi bật</label>
                                    <select class="form-select" id="isFeatured" name="isFeatured" required>
                                        <option value="false">Không</option>
                                        <option value="true">Có</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label for="status" class="form-label">Trạng thái</label>
                                    <select class="form-select" id="status" name="status" required>
                                        <option value="true">Hiển thị</option>
                                        <option value="false">Ẩn</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                            <button type="submit" class="btn btn-primary">Lưu bài viết</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Edit Blog Modal -->
        <div class="modal fade" id="editBlogModal" tabindex="-1" aria-labelledby="editBlogModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="editBlogModalLabel">Chỉnh sửa bài viết</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form action="blogadmin" method="POST" enctype="multipart/form-data">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" id="editBlogId" name="id">
                        <div class="modal-body">
                            <div class="row g-3">
                                <div class="col-md-12">
                                    <label for="editTitle" class="form-label">Tiêu đề</label>
                                    <input type="text" class="form-control" id="editTitle" name="title" required>
                                </div>
                                <div class="col-md-12">
                                    <label for="editShortDescription" class="form-label">Mô tả ngắn</label>
                                    <textarea class="form-control" id="editShortDescription" name="shortDescription" rows="2" required></textarea>
                                </div>
                                <div class="col-md-12">
                                    <label for="editContent" class="form-label">Nội dung</label>
                                    <textarea class="form-control" id="content" name="content" rows="15" required style="min-height: 300px;"></textarea>
                                </div>
                                <div class="col-md-6">
                                    <label for="editCategoryId" class="form-label">Danh mục</label>
                                    <select class="form-select" id="editCategoryId" name="categoryId" required>
                                        <c:forEach var="category" items="${categories}">
                                            <option value="${category.categoryId}">${category.categoryName}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label for="editAuthorName" class="form-label">Tác giả</label>
                                    <input type="text" class="form-control" id="editAuthorName" name="authorName" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="editImageFile" class="form-label">Tải ảnh từ máy</label>
                                    <input type="file" class="form-control" id="editImageFile" name="imageFile" accept="image/*">
                                    <input type="hidden" id="editExistingImageUrl" name="existingImageUrl" value="">
                                </div>

                                <div class="col-md-6">
                                    <label for="editIsFeatured" class="form-label">Nổi bật</label>
                                    <select class="form-select" id="editIsFeatured" name="isFeatured" required>
                                        <option value="false">Không</option>
                                        <option value="true">Có</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label for="editStatus" class="form-label">Trạng thái</label>
                                    <select class="form-select" id="editStatus" name="status" required>
                                        <option value="true">Hiển thị</option>
                                        <option value="false">Ẩn</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                            <button type="submit" class="btn btn-primary">Cập nhật</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                                                // JavaScript tương tự trang user
                                                                document.addEventListener('DOMContentLoaded', function () {
                                                                    // Xử lý modal chỉnh sửa
                                                                    const editButtons = document.querySelectorAll('.edit-btn');
                                                                    editButtons.forEach(button => {
                                                                        button.addEventListener('click', () => {
                                                                            document.getElementById('editBlogId').value = button.getAttribute('data-id');
                                                                            document.getElementById('editTitle').value = button.getAttribute('data-title');
                                                                            document.getElementById('editShortDescription').value = button.getAttribute('data-shortdescription');
                                                                            document.getElementById('editContent').value = button.getAttribute('data-content');
                                                                            document.getElementById('editCategoryId').value = button.getAttribute('data-categoryid');
                                                                            document.getElementById('editAuthorName').value = button.getAttribute('data-authorname');
                                                                            document.getElementById('editExistingImageUrl').value = button.getAttribute('data-imageurl');
                                                                            document.getElementById('editIsFeatured').value = button.getAttribute('data-isfeatured') === 'true' ? 'true' : 'false';
                                                                            document.getElementById('editStatus').value = button.getAttribute('data-status') === 'true' ? 'true' : 'false';
                                                                        });
                                                                    });
                                                                });

                                                                function toggleBlogStatus(blogId) {
                                                                    if (confirm('Bạn có chắc muốn thay đổi trạng thái bài viết này?')) {
                                                                        window.location.href = 'blogadmin?action=toggle&id=' + blogId;
                                                                    }
                                                                }

                                                                function confirmDelete(blogId) {
                                                                    Swal.fire({
                                                                        title: 'Bạn có chắc chắn?',
                                                                        text: "Bạn sẽ không thể hoàn tác hành động này!",
                                                                        icon: 'warning',
                                                                        showCancelButton: true,
                                                                        confirmButtonColor: '#d33',
                                                                        cancelButtonColor: '#3085d6',
                                                                        confirmButtonText: 'Xóa',
                                                                        cancelButtonText: 'Hủy'
                                                                    }).then((result) => {
                                                                        if (result.isConfirmed) {
                                                                            window.location.href = 'blogadmin?action=delete&id=' + blogId;
                                                                        }
                                                                    });
                                                                }
        </script>
    </body>
</html>