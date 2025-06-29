<%-- 
    Document   : partnersAdmin
    Created on : May 31, 2025, 6:28:44 PM
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

                <!-- Main Content -->
                <div class="col-md-10 p-4">
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">${error}</div>
                    </c:if>

                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2>Quản Lý Đối Tác</h2>
                    </div>

                    <!-- Filter Section -->
                    <div class="filter-section">
                        <div class="row">
                            <!-- Loại đối tác -->
                            <div class="col-md-3">
                                <label class="form-label filter-title">Loại đối tác</label>
                                <select class="form-select" id="partner-type-filter">
                                    <option value="all">Tất cả loại</option>
                                    <c:forEach var="t" items="${types}">
                                        <option value="${t}">
                                            <c:choose>
                                                <c:when test="${t eq 'Giáo Dục'}">Giáo Dục</c:when>
                                                <c:when test="${t eq 'Công Nghệ'}">Công Nghệ</c:when>
                                                <c:when test="${t eq 'Kinh doanh'}">Kinh doanh</c:when>
                                                <c:when test="${t eq 'Chuyên Gia'}">Chuyên Gia</c:when>
                                                <c:otherwise>Khác</c:otherwise>
                                            </c:choose>
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- Trạng thái -->
                            <div class="col-md-3">
                                <label class="form-label filter-title">Trạng thái</label>
                                <select class="form-select" id="partner-status-filter">
                                    <option value="all">Tất cả trạng thái</option>
                                    <option value="active">Đang hợp tác</option>
                                    <option value="inactive">Ngừng hợp tác</option>
                                </select>
                            </div>

                            <!-- Quốc gia -->
                            <div class="col-md-3">
                                <label class="form-label filter-title">Quốc gia</label>
                                <select class="form-select" id="partner-country-filter">
                                    <option value="all">Tất cả quốc gia</option>
                                    <c:forEach var="c" items="${countries}">
                                        <option value="${c}">${c}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- Tìm kiếm -->
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
                                <a href="ExportPartnerExcelServlet" class="btn btn-outline-secondary">
                                    <i class="bi bi-download me-1"></i> Xuất Excel
                                </a>

                            </div> 
                            <div> 
                                <div class="btn-group"> 
                                    <button class="btn btn-sm btn-outline-secondary active">Tất cả (${totalPartners})</button> 
                                    <button class="btn btn-sm btn-outline-secondary">Đang hợp tác (${activePartners})</button> 
                                    <button class="btn btn-sm btn-outline-secondary">Ngừng hợp tác (${inactivePartners})</button> 
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
                                            <th style="width: 160px">Hành động</th> 
                                        </tr> 
                                    </thead> 
                                    <tbody>
                                        <c:forEach var="p" items="${partners}" varStatus="loop">
                                            <tr>
                                                <td>${loop.index + 1}</td>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <img src="${p.logoUrl}" class="rounded me-2" width="40" height="40">
                                                        <div>
                                                            <h6 class="mb-0">${p.name}</h6>
                                                            <small class="text-muted">${p.email}</small>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <span class="badge
                                                          <c:choose>
                                                              <c:when test="${p.partnerType eq 'Giáo Dục'}">bg-info</c:when>
                                                              <c:when test="${p.partnerType eq 'Công Nghệ'}">bg-primary</c:when>
                                                              <c:when test="${p.partnerType eq 'Kinh doanh'}">bg-success</c:when>
                                                              <c:when test="${p.partnerType eq 'Chuyên Gia'}">bg-dark</c:when>
                                                              <c:otherwise>bg-warning</c:otherwise>
                                                          </c:choose>">
                                                        ${p.partnerType}
                                                    </span>
                                                </td>

                                                <td>${p.country}</td>
                                                <td><fmt:formatDate value="${p.partnershipDate}" pattern="dd/MM/yyyy"/></td>
                                                <td>${p.projectCount}</td>
                                                <td>
                                                    <span class="status-badge
                                                          ${p.status ? 'status-active' : 'status-inactive'}">
                                                        ${p.status ? 'Đang hợp tác' : 'Ngừng hợp tác'}
                                                    </span>
                                                </td>
                                                <td>
                                                    <!-- Sửa -->
                                                    <button class="btn btn-sm btn-outline-warning action-btn me-1" title="Sửa" 
                                                            data-bs-toggle="modal" data-bs-target="#editPartnerModal"
                                                            data-id="${p.id}" data-name="${p.name}" data-email="${p.email}"
                                                            data-phone="${p.phone}" data-address="${p.address}"
                                                            data-description="${p.description}" data-country="${p.country}"
                                                            data-type="${p.partnerType}" data-date="${p.partnershipDate}"
                                                            data-count="${p.projectCount}" data-logo="${p.logoUrl}"
                                                            data-website="${p.website}" data-status="${p.status}">
                                                        <i class="bi bi-pencil"></i>
                                                    </button>

                                                    <!-- Ẩn/Hiện -->
                                                    <form method="post" action="partneradmin" style="display:inline-block;">
                                                        <input type="hidden" name="action" value="toggle"/>
                                                        <input type="hidden" name="id" value="${p.id}"/>
                                                        <input type="hidden" name="status" value="${not p.status}"/>
                                                        <button class="btn btn-sm btn-outline-primary action-btn" title="Ẩn/Hiện">
                                                            <i class="bi ${p.status ? 'bi-eye-slash' : 'bi-eye'}"></i>
                                                        </button>
                                                    </form>

                                                    <!-- Xóa -->
                                                    <form method="post" action="partneradmin" style="display:inline-block;">
                                                        <input type="hidden" name="action" value="delete"/>
                                                        <input type="hidden" name="id" value="${p.id}"/>
                                                        <button class="btn btn-sm btn-outline-danger action-btn" onclick="return confirm('Xóa đối tác này?')" title="Xóa">
                                                            <i class="bi bi-trash"></i>
                                                        </button>
                                                    </form>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>

                                </table> 
                            </div>

                            <!-- Pagination -->
                            <nav aria-label="Page navigation" class="mt-3">
                                <ul class="pagination justify-content-center">
                                    <c:if test="${currentPage > 1}">
                                        <li class="page-item">
                                            <a class="page-link" href="partneradmin?page=${currentPage - 1}">
                                                <i class="bi bi-chevron-left"></i>
                                            </a>
                                        </li>
                                    </c:if>

                                    <c:forEach var="i" begin="1" end="${totalPages}">
                                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                                            <a class="page-link" href="partneradmin?page=${i}">${i}</a>
                                        </li>
                                    </c:forEach>

                                    <c:if test="${currentPage < totalPages}">
                                        <li class="page-item">
                                            <a class="page-link" href="partneradmin?page=${currentPage + 1}">
                                                <i class="bi bi-chevron-right"></i>
                                            </a>
                                        </li>
                                    </c:if>
                                </ul>
                            </nav>
                        </div>
                    </div>


                    <div class="card mt-5">
                        <div class="card-header d-flex justify-content-between align-items-center"> 
                            <h5 class="mb-0">Danh sách Chuyên Gia</h5>
                            <button class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#editExpertModal">
                                <i class="bi bi-plus-circle me-1"></i> Thêm Chuyên Gia
                            </button>
                            <a href="ExportExpertExcelServlet" class="btn btn-outline-secondary ms-2">
                                <i class="bi bi-download me-1"></i> Xuất Chuyên Gia
                            </a>

                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle">
                                    <thead class="table-light text-center">
                                        <tr>
                                            <th>#</th>
                                            <th>Họ tên</th>
                                            <th>Vị trí</th>
                                            <th>Đối tác</th>
                                            <th>Email</th>
                                            <th>Facebook</th>
                                            <th>Trạng thái</th>
                                            <th class="text-nowrap">Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="e" items="${experts}" varStatus="loop">
                                            <c:if test="${e.partner.partnerType eq 'Chuyên Gia'}">
                                                <tr class="${!e.status ? 'table-secondary' : ''}">
                                                    <td class="text-center">${loop.index + 1}</td>
                                                    <td>
                                                        <div class="d-flex align-items-center">
                                                            <img src="${e.imageUrl}" class="rounded-circle me-2" width="40" height="40">
                                                            <div>
                                                                <strong>${e.fullName}</strong><br/>
                                                                <small class="text-muted">${e.position}</small>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>${e.position}</td>
                                                    <td>${e.partner.name}</td>
                                                    <td>${e.partner.email}</td>
                                                    <td class="text-center">
                                                        <c:if test="${not empty e.facebookUrl}">
                                                            <a href="${e.facebookUrl}" target="_blank" class="text-primary fs-5">
                                                                <i class="bi bi-facebook"></i>
                                                            </a>
                                                        </c:if>
                                                    </td>
                                                    <td class="text-center">
                                                        <span class="badge ${e.status ? 'bg-success' : 'bg-secondary'}">
                                                            ${e.status ? 'Hiển thị' : 'Đã ẩn'}
                                                        </span>
                                                    </td>
                                                    <td class="text-center text-nowrap">
                                                        <div class="d-flex justify-content-center gap-1">
                                                            <!-- Sửa -->
                                                            <button class="btn btn-sm btn-outline-primary"
                                                                    data-bs-toggle="modal" data-bs-target="#editExpertModal"
                                                                    data-id="${e.id}"
                                                                    data-fullname="${e.fullName}"
                                                                    data-position="${e.position}"
                                                                    data-bio="${e.bio}"
                                                                    data-image="${e.imageUrl}"
                                                                    data-facebook="${e.facebookUrl}"
                                                                    data-twitter="${e.twitterUrl}"
                                                                    data-instagram="${e.instagramUrl}"
                                                                    data-google="${e.googleUrl}"
                                                                    data-partner="${e.partner.id}">
                                                                <i class="bi bi-pencil"></i>
                                                            </button>

                                                            <!-- Ẩn / Hiện -->
                                                            <form action="partneradmin" method="post">
                                                                <input type="hidden" name="action" value="toggleExpertStatus"/>
                                                                <input type="hidden" name="id" value="${e.id}"/>
                                                                <input type="hidden" name="status" value="${not e.status}"/>
                                                                <button class="btn btn-sm btn-outline-secondary" title="Ẩn/Hiện">
                                                                    <i class="bi ${e.status ? 'bi-eye-slash' : 'bi-eye'}"></i>
                                                                </button>
                                                            </form>

                                                            <!-- Xóa -->
                                                            <form action="partneradmin" method="post"
                                                                  onsubmit="return confirm('Bạn chắc chắn muốn xóa chuyên gia này?')">
                                                                <input type="hidden" name="action" value="deleteExpert"/>
                                                                <input type="hidden" name="id" value="${e.id}"/>
                                                                <button class="btn btn-sm btn-outline-danger" title="Xóa">
                                                                    <i class="bi bi-trash"></i>
                                                                </button>
                                                            </form>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>


                </div>
            </div>
        </div>


        <!-- Modal thêm đối tác -->
        <div class="modal fade" id="addPartnerModal" tabindex="-1" role="dialog" aria-labelledby="addPartnerModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg" role="document">
                <form method="post" action="partneradmin">
                    <input type="hidden" name="action" value="add"/>
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Thêm đối tác</h5>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Đóng">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>

                        <div class="modal-body">
                            <div class="form-group">
                                <label>Tên đối tác</label>
                                <input type="text" name="name" class="form-control" required/>
                            </div>

                            <div class="form-group">
                                <label>Email</label>
                                <input type="email" name="email" class="form-control" required/>
                            </div>

                            <div class="form-group">
                                <label>Số điện thoại</label>
                                <input type="text" name="phone" class="form-control" required/>
                            </div>

                            <div class="form-group">
                                <label>Địa chỉ</label>
                                <input type="text" name="address" class="form-control" required/>
                            </div>

                            <div class="form-group">
                                <label>Mô tả</label>
                                <textarea name="description" class="form-control"></textarea>
                            </div>

                            <div class="form-group">
                                <label>Phân loại đối tác</label>
                                <select id="edit-type" name="partner_type" class="form-control" required>
                                    <option value="Giáo Dục">Giáo Dục</option>
                                    <option value="Công Nghệ">Công Nghệ</option>
                                    <option value="Kinh doanh">Kinh doanh</option>
                                    <option value="Chuyên Gia">Chuyên Gia</option>
                                    <option value="Khác">Khác</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label>Quốc gia</label>
                                <input type="text" name="country" class="form-control"/>
                            </div>

                            <div class="form-group">
                                <label>Ngày hợp tác</label>
                                <input type="date" name="partnership_date" class="form-control" required/>
                            </div>

                            <div class="form-group">
                                <label>Số dự án hợp tác</label>
                                <input type="number" name="project_count" class="form-control" value="0" min="0"/>
                            </div>

                            <div class="form-group">
                                <label>Link logo (URL)</label>
                                <input type="text" name="logo_url" class="form-control"/>
                            </div>

                            <div class="form-group">
                                <label>Website</label>
                                <input type="text" name="website" class="form-control"/>
                            </div>

                            <div class="form-group">
                                <label>Trạng thái</label>
                                <select name="status" class="form-control">
                                    <option value="active">Hiển thị</option>
                                    <option value="inactive">Ẩn</option>
                                </select>
                            </div>
                        </div>

                        <div class="modal-footer">
                            <button type="submit" class="btn btn-success">Thêm mới</button>
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
        <!-- Modal Sửa -->
        <div class="modal fade" id="editPartnerModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <form method="post" action="partneradmin">
                    <input type="hidden" name="action" value="edit"/>
                    <input type="hidden" name="id" id="edit-id"/>
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Cập nhật đối tác</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <div class="mb-3">
                                <label>Tên đối tác</label>
                                <input type="text" id="edit-name" name="name" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label>Email</label>
                                <input type="email" id="edit-email" name="email" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label>Số điện thoại</label>
                                <input type="text" id="edit-phone" name="phone" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label>Địa chỉ</label>
                                <input type="text" id="edit-address" name="address" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label>Mô tả</label>
                                <textarea id="edit-description" name="description" class="form-control"></textarea>
                            </div>
                            <div class="mb-3">
                                <label>Phân loại đối tác</label>
                                <select id="edit-type" name="partner_type" class="form-control" required>
                                    <option value="Giáo Dục">Giáo Dục</option>
                                    <option value="Công Nghệ">Công Nghệ</option>
                                    <option value="Kinh doanh">Kinh doanh</option>
                                    <option value="Chuyên Gia">Chuyên Gia</option>
                                    <option value="Khác">Khác</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label>Quốc gia</label>
                                <input type="text" id="edit-country" name="country" class="form-control">
                            </div>
                            <div class="mb-3">
                                <label>Ngày hợp tác</label>
                                <input type="date" id="edit-date" name="partnership_date" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label>Số dự án hợp tác</label>
                                <input type="number" id="edit-count" name="project_count" class="form-control" min="0" required>
                            </div>
                            <div class="mb-3">
                                <label>Link logo (URL)</label>
                                <input type="text" id="edit-logo" name="logo_url" class="form-control">
                            </div>
                            <div class="mb-3">
                                <label>Website</label>
                                <input type="text" id="edit-website" name="website" class="form-control">
                            </div>
                            <div class="mb-3">
                                <label>Trạng thái</label>
                                <select id="edit-status" name="status" class="form-control">
                                    <option value="active">Hiển thị</option>
                                    <option value="inactive">Ẩn</option>
                                </select>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button class="btn btn-success" type="submit">Lưu</button>
                            <button class="btn btn-secondary" data-bs-dismiss="modal" type="button">Hủy</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
        <!-- Modal Thêm / Sửa Chuyên Gia -->
        <div class="modal fade" id="editExpertModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <form method="post" action="partneradmin" class="modal-content">
                    <input type="hidden" name="action" value="editExpert" id="expert-action" />
                    <input type="hidden" name="id" id="expert-id" />

                    <div class="modal-header">
                        <h5 class="modal-title">Cập nhật chuyên gia</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>

                    <div class="modal-body row g-3">
                        <div class="col-md-6">
                            <label>Họ tên</label>
                            <input type="text" name="full_name" id="expert-fullname" class="form-control" required />
                        </div>

                        <div class="col-md-6">
                            <label>Vị trí</label>
                            <input type="text" name="position" id="expert-position" class="form-control" />
                        </div>

                        <div class="col-12">
                            <label>Tiểu sử</label>
                            <textarea name="bio" id="expert-bio" rows="3" class="form-control"></textarea>
                        </div>

                        <div class="col-md-6">
                            <label>Ảnh đại diện (URL)</label>
                            <input type="text" name="image_url" id="expert-image" class="form-control" />
                        </div>

                        <div class="col-md-6">
                            <label>Đối tác liên kết</label>
                            <select name="partner_id" id="expert-partner" class="form-select">
                                <c:forEach var="p" items="${partners}">
                                    <c:if test="${p.partnerType eq 'Chuyên Gia'}">
                                        <option value="${p.id}">${p.name}</option>
                                    </c:if>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label>Facebook</label>
                            <input type="text" name="facebook_url" id="expert-facebook" class="form-control" />
                        </div>

                    </div>

                    <div class="modal-footer">
                        <button type="submit" class="btn btn-success">Lưu</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    </div>
                </form>
            </div>
        </div>


        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                                                      // Filter functionality
                                                                      document.getElementById('partner-search-btn').addEventListener('click', function () {
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
                                                                                      (typeFilter === 'Giáo Dục' && type === 'Giáo Dục') ||
                                                                                      (typeFilter === 'Công Nghệ' && type === 'Công Nghệ') ||
                                                                                      (typeFilter === 'Kinh doanh' && type === 'Kinh doanh') ||
                                                                                      (typeFilter === 'Chuyên Gia' && type === 'Chuyên Gia') ||
                                                                                      (typeFilter === 'Khác' && type === 'Khác');


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
        <script>
            /* fill edit modal */
            document.getElementById('editPartnerModal').addEventListener('show.bs.modal', e => {
                const b = e.relatedTarget;                // nút pencil
                ['id', 'name', 'email', 'phone', 'address', 'description',
                    'country', 'type', 'date', 'count', 'logo', 'website', 'status']
                        .forEach(k => {
                            const inp = document.getElementById('edit-' + k);
                            if (inp)
                                inp.value = b.dataset[k] ?? '';
                        });
            });
        </script>

    </body>
</html>