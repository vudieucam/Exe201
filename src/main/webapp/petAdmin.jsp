<%-- 
    Document   : petAdmin
    Created on : Jun 29, 2025, 12:24:37 PM
    Author     : FPT
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <link rel="icon" type="image/png" href="images/logo_pettech.jpg">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý Thú cưng - PetTech Admin</title>
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
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/paymentadmin">
                                <i class="bi bi-credit-card"></i>Thanh toán
                            </a>
                        </li>

                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/partneradmin">
                                <i class="bi bi-building"></i>Đối tác
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/petadmin">
                                <i class="bi bi-building"></i>Thú cưng
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
                        <li class="nav-item" >
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
                <c:if test="${empty categories}">
                    <div class="alert alert-warning">Không có danh mục nào.</div>
                </c:if>
                <c:if test="${empty pets}">
                    <div class="alert alert-warning">Không có thú cưng nào.</div>
                </c:if>


                <h3 class="mb-4">📂 Quản lý danh mục Thú cưng</h3>
                <form action="petcategoryadmin" method="post" class="row g-3 mb-3">
                    <div class="col-md-4">
                        <input type="text" class="form-control" name="name" placeholder="Tên danh mục" required>
                    </div>
                    <div class="col-md-4">
                        <input type="text" class="form-control" name="description" placeholder="Mô tả">
                    </div>
                    <div class="col-md-4">
                        <button class="btn btn-success" name="action" value="add">Thêm danh mục</button>
                    </div>
                </form>
                <table class="table table-bordered table-hover">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Tên</th>
                            <th>Mô tả</th>
                            <th>Trạng thái</th>
                            <th>Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="cat" items="${categories}">
                            <tr>
                                <td>${cat.id}</td>
                                <td>${cat.name}</td>
                                <td>${cat.description}</td>
                                <td>${cat.status ? 'Hiển thị' : 'Ẩn'}</td>
                                <td>
                                    <form action="petcategoryadmin" method="post" class="d-inline">
                                        <input type="hidden" name="id" value="${cat.id}"/>
                                        <button class="btn btn-sm btn-warning" name="action" value="toggle">${cat.status ? 'Ẩn' : 'Hiện'}</button>
                                        <button class="btn btn-sm btn-danger" name="action" value="delete" onclick="return confirm('Xoá danh mục này?')">Xoá</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <hr class="my-4">

                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2>🐶 Quản lý Thú cưng</h2>
                    <div>
                        <button class="btn btn-primary me-2" data-bs-toggle="modal" data-bs-target="#addPetModal">
                            <i class="bi bi-plus-lg"></i> Thêm thú cưng
                        </button>
                        <a href="exportPetExcel" class="btn btn-outline-primary">
                            <i class="bi bi-file-earmark-excel"></i> Xuất Excel
                        </a>
                    </div>
                </div>

                <div class="card">
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover mb-0">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Ảnh</th>
                                        <th>Tên</th>
                                        <th>Danh mục</th>
                                        <th>Tuổi</th>
                                        <th>Giới tính</th>
                                        <th>Trạng thái</th>
                                        <th>Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="pet" items="${pets}">
                                        <tr>
                                            <td>${pet.id}</td>
                                            <td>
                                                <img src="${pageContext.request.contextPath}/${pet.primaryImage}" class="img-thumbnail" style="width: 80px; height: 60px; object-fit: cover">
                                            </td>
                                            <td>${pet.name}</td>
                                            <td>${pet.categoryName}</td>
                                            <td>${pet.age}</td>
                                            <td>${pet.gender}</td>
                                            <td>
                                                <span class="badge ${pet.status ? 'bg-success' : 'bg-secondary'}">
                                                    ${pet.status ? 'Hiển thị' : 'Ẩn'}
                                                </span>
                                            </td>
                                            <td>
                                                <a class="btn btn-sm btn-outline-primary action-btn" href="petadmin?action=edit&id=${pet.id}">
                                                    <i class="bi bi-pencil"></i>
                                                </a>
                                                <a class="btn btn-sm btn-outline-warning action-btn" href="petadmin?action=toggle&id=${pet.id}">
                                                    <i class="bi ${pet.status ? 'bi-eye-slash' : 'bi-eye'}"></i>
                                                </a>
                                                <a class="btn btn-sm btn-outline-danger action-btn" onclick="confirmDelete(${pet.id})">
                                                    <i class="bi bi-trash"></i>
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Modal thêm thú cưng -->
                <div class="modal fade" id="addPetModal" tabindex="-1" aria-labelledby="addPetModalLabel" aria-hidden="true">
                    <div class="modal-dialog modal-lg">
                        <form action="petadmin" method="post" enctype="multipart/form-data" class="modal-content">
                            <input type="hidden" name="action" value="add">
                            <div class="modal-header">
                                <h5 class="modal-title" id="addPetModalLabel">Thêm Thú Cưng</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body">
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label class="form-label">Tên</label>
                                        <input type="text" class="form-control" name="name" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Danh mục</label>
                                        <select class="form-select" name="categoryId" required>
                                            <c:forEach var="cat" items="${categories}">
                                                <option value="${cat.id}">${cat.name}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label">Tuổi</label>
                                        <input type="number" class="form-control" name="age">
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label">Giới tính</label>
                                        <select class="form-select" name="gender">
                                            <option value="Đực">Đực</option>
                                            <option value="Cái">Cái</option>
                                            <option value="Khác">Khác</option>
                                        </select>
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label">Giống</label>
                                        <input type="text" class="form-control" name="breed">
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Màu lông</label>
                                        <input type="text" class="form-control" name="color">
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Cân nặng</label>
                                        <input type="text" class="form-control" name="weight">
                                    </div>
                                    <div class="col-md-12">
                                        <label class="form-label">Ảnh đại diện</label>
                                        <input type="file" class="form-control" name="image" accept="image/*" required>
                                    </div>
                                    <div class="col-md-12">
                                        <label class="form-label">Mô tả</label>
                                        <textarea class="form-control" name="description" rows="3"></textarea>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                <button type="submit" class="btn btn-primary">Lưu</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                                    function confirmDelete(id) {
                                                        Swal.fire({
                                                            title: 'Bạn chắc chắn muốn xoá?',
                                                            icon: 'warning',
                                                            showCancelButton: true,
                                                            confirmButtonColor: '#d33',
                                                            cancelButtonText: 'Hủy',
                                                            confirmButtonText: 'Xoá'
                                                        }).then((result) => {
                                                            if (result.isConfirmed) {
                                                                window.location.href = 'petadmin?action=delete&id=' + id;
                                                            }
                                                        });
                                                    }
        </script>
    </body>

</html>