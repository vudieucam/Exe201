<%-- 
    Document   : courseEdit
    Created on : Jun 2, 2025, 3:58:02 PM
    Author     : FPT
--%>

<%-- 
    Document   : courseAdd
    Created on : Jun 2, 2025, 3:57:53 PM
    Author     : FPT
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:if test="${empty sessionScope.user}">
    <c:redirect url="authen?action=login"/>
</c:if>
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
                                <img src="${not empty sessionScope.user.avatar ? sessionScope.user.avatar : 'https://via.placeholder.com/40'}" 
                                     alt="Admin Avatar" class="admin-avatar">
                                <div class="admin-info">
                                    <div class="admin-name">${sessionScope.user.fullname}</div>
                                    <div class="admin-role">
                                        <c:choose>
                                            <c:when test="${sessionScope.user.roleId == 2}">Quản trị viên</c:when>
                                            <c:when test="${sessionScope.user.roleId == 3}">Admin</c:when>
                                            <c:otherwise>Nhân viên</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <li><a class="dropdown-item" href="editProfile.jsp">
                                        <i class="bi bi-person me-2"></i>Thông tin cá nhân
                                    </a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item logout" href="authen?action=logout">
                                        <i class="bi bi-box-arrow-right me-2"></i>Đăng xuất
                                    </a></li>
                            </ul>
                        </div>
                    </div>
                </div>

                <!-- Main Content -->
                <div class="col-md-10 p-4">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2>Chỉnh sửa Khóa học</h2>
                        <a href="courseadmin" class="btn btn-secondary">Quay lại</a>
                    </div>

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

                    <form action="courseadmin" method="POST" enctype="multipart/form-data" class="needs-validation" novalidate>
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="id" value="${currentCourse.id}">

                        <div class="card mb-4">
                            <div class="card-header">
                                <h4>Thông tin cơ bản</h4>
                            </div>
                            <div class="card-body">
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label class="form-label">ID Khóa học</label>
                                        <input type="text" class="form-control" value="${currentCourse.id}" readonly>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Tên khóa học <span class="text-danger">*</span></label>
                                        <input type="text" name="title" class="form-control" value="${currentCourse.title}" required>
                                        <div class="invalid-feedback">Vui lòng nhập tên khóa học</div>
                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label class="form-label">Giảng viên <span class="text-danger">*</span></label>
                                        <input type="text" name="researcher" class="form-control" value="${currentCourse.researcher}" required>
                                        <div class="invalid-feedback">Vui lòng nhập tên giảng viên</div>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Danh mục <span class="text-danger">*</span></label>
                                        <select name="categoryId" class="form-select" required>
                                            <option value="">-- Chọn danh mục --</option>
                                            <c:forEach items="${categories}" var="category">
                                                <option value="${category.id}" ${currentCourse.categoryId == category.id ? 'selected' : ''}>
                                                    ${category.name}
                                                </option>
                                            </c:forEach>
                                        </select>
                                        <div class="invalid-feedback">Vui lòng chọn danh mục</div>
                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label class="form-label">Ảnh hiện tại</label>
                                        <c:choose>
                                            <c:when test="${not empty currentCourse.imageUrl}">
                                                <div>
                                                    <img src="${pageContext.request.contextPath}/${currentCourse.imageUrl}" 
                                                         alt="Ảnh khóa học" style="max-height: 100px;">
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="text-muted">Chưa có ảnh</div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Cập nhật ảnh đại diện</label>
                                        <input type="file" name="thumbnail" class="form-control" accept="image/*">
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Nội dung chi tiết <span class="text-danger">*</span></label>
                                    <textarea name="content" class="form-control" rows="5" required>${not empty currentCourse.content ? fn:escapeXml(currentCourse.content) : ''}</textarea>
                                    <div class="invalid-feedback">Vui lòng nhập nội dung khóa học</div>
                                </div>

                                <div class="row mb-3">
                                    <div class="col-md-3">
                                        <label class="form-label">Thời lượng <span class="text-danger">*</span></label>
                                        <input type="text" name="time" class="form-control" 
                                               value="${not empty currentCourse.time ? currentCourse.time : ''}" required>
                                        <div class="invalid-feedback">Vui lòng nhập thời lượng</div>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label">Trạng thái <span class="text-danger">*</span></label>
                                        <select name="status" class="form-select" required>
                                            <option value="1" ${currentCourse.status == 1 ? 'selected' : ''}>Active</option>
                                            <option value="0" ${currentCourse.status == 0 ? 'selected' : ''}>Inactive</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Modules Section -->
                        <div class="card mb-4">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <h4>Modules</h4>
                                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addModuleModal">
                                    <i class="bi bi-plus"></i> Thêm Module
                                </button>
                            </div>
                            <div class="card-body">
                                <c:choose>
                                    <c:when test="${not empty modules}">
                                        <div class="accordion" id="modulesAccordion">
                                            <c:forEach items="${modules}" var="module">
                                                <c:set var="lessons" value="${module.lessons}" />
                                                <div class="accordion-item mb-2">
                                                    <h2 class="accordion-header" id="heading${module.id}">
                                                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" 
                                                                data-bs-target="#collapse${module.id}" aria-expanded="false">
                                                            ${module.title}
                                                            <span class="badge bg-primary ms-2">${not empty lessons ? fn:length(lessons) : 0} bài học</span>
                                                        </button>
                                                    </h2>
                                                    <div id="collapse${module.id}" class="accordion-collapse collapse" 
                                                         aria-labelledby="heading${module.id}" data-bs-parent="#modulesAccordion">
                                                        <div class="accordion-body">
                                                            <div class="d-flex justify-content-between mb-3">
                                                                <p class="mb-0">${module.description}</p>
                                                                <div>
                                                                    <button type="button" class="btn btn-sm btn-outline-primary" 
                                                                            onclick="editModule(${module.id}, '${fn:escapeXml(module.title)}', '${fn:escapeXml(module.description)}')">
                                                                        <i class="bi bi-pencil"></i> Sửa
                                                                    </button>
                                                                    <button type="button" class="btn btn-sm btn-outline-danger" 
                                                                            onclick="confirmDeleteModule(${module.id})">
                                                                        <i class="bi bi-trash"></i> Xóa
                                                                    </button>
                                                                </div>
                                                            </div>

                                                            <!-- Lessons List -->
                                                            <div class="module-lesson mt-3">
                                                                <h5 class="d-flex justify-content-between align-items-center">
                                                                    <span>Bài học</span>
                                                                    <button type="button" class="btn btn-sm btn-primary" 
                                                                            data-bs-toggle="modal" data-bs-target="#addLessonModal${module.id}">
                                                                        <i class="bi bi-plus"></i> Thêm bài học
                                                                    </button>
                                                                </h5>

                                                                <c:choose>
                                                                    <c:when test="${not empty lessons}">
                                                                        <div class="list-group">
                                                                            <c:forEach items="${lessons}" var="lesson">
                                                                                <div class="list-group-item lesson-item">
                                                                                    <div class="d-flex justify-content-between align-items-center">
                                                                                        <div>
                                                                                            <h6 class="mb-1">${lesson.title}</h6>
                                                                                            <c:if test="${not empty lesson.videoUrl}">
                                                                                                <small><a href="${lesson.videoUrl}" target="_blank">Xem video</a></small>
                                                                                            </c:if>
                                                                                        </div>
                                                                                        <div>
                                                                                            <button type="button" class="btn btn-sm btn-outline-primary"
                                                                                                    onclick="editLesson(${lesson.id}, '${fn:escapeXml(lesson.title)}', '${fn:escapeXml(lesson.content)}', '${not empty lesson.videoUrl ? fn:escapeXml(lesson.videoUrl) : ''}')">
                                                                                                <i class="bi bi-pencil"></i>
                                                                                            </button>
                                                                                            <button type="button" class="btn btn-sm btn-outline-danger"
                                                                                                    onclick="confirmDeleteLesson(${lesson.id})">
                                                                                                <i class="bi bi-trash"></i>
                                                                                            </button>
                                                                                        </div>
                                                                                    </div>
                                                                                </div>
                                                                            </c:forEach>
                                                                        </div>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <p class="text-muted">Chưa có bài học nào trong module này</p>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <p class="text-muted">Khóa học này chưa có module nào</p>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div class="text-end">
                            <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                            <a href="courseadmin" class="btn btn-secondary">Hủy bỏ</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Add Module Modal -->
        <div class="modal fade" id="addModuleModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <form action="courseadmin" method="POST">
                        <input type="hidden" name="action" value="addModule">
                        <input type="hidden" name="courseId" value="${currentCourse.id}">
                        <div class="modal-header">
                            <h5 class="modal-title">Thêm Module mới</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="mb-3">
                                <label class="form-label">Tên Module <span class="text-danger">*</span></label>
                                <input type="text" name="title" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Mô tả</label>
                                <textarea name="description" class="form-control" rows="3"></textarea>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                            <button type="submit" class="btn btn-primary">Thêm Module</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Edit Module Modal -->
        <div class="modal fade" id="editModuleModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <form action="courseadmin" method="POST">
                        <input type="hidden" name="action" value="updateModule">
                        <input type="hidden" name="moduleId" id="editModuleId">
                        <div class="modal-header">
                            <h5 class="modal-title">Chỉnh sửa Module</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="mb-3">
                                <label class="form-label">Tên Module <span class="text-danger">*</span></label>
                                <input type="text" name="title" id="editModuleTitle" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Mô tả</label>
                                <textarea name="description" id="editModuleDescription" class="form-control" rows="3"></textarea>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                            <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Add Lesson Modal (dynamic - one for each module) -->
        <c:if test="${not empty modules}">
            <c:forEach items="${modules}" var="module">
                <div class="modal fade" id="addLessonModal${module.id}" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <form action="courseadmin" method="POST">
                                <input type="hidden" name="action" value="addLesson">
                                <input type="hidden" name="moduleId" value="${module.id}">
                                <div class="modal-header">
                                    <h5 class="modal-title">Thêm bài học mới</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <div class="mb-3">
                                        <label class="form-label">Tên bài học <span class="text-danger">*</span></label>
                                        <input type="text" name="title" class="form-control" required>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Nội dung <span class="text-danger">*</span></label>
                                        <textarea name="content" class="form-control" rows="5" required></textarea>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Video URL (nếu có)</label>
                                        <input type="url" name="videoUrl" class="form-control" placeholder="https://youtube.com/watch?v=...">
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                    <button type="submit" class="btn btn-primary">Thêm bài học</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </c:if>

        <!-- Edit Lesson Modal -->
        <div class="modal fade" id="editLessonModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <form action="courseadmin" method="POST">
                        <input type="hidden" name="action" value="updateLesson">
                        <input type="hidden" name="lessonId" id="editLessonId">
                        <div class="modal-header">
                            <h5 class="modal-title">Chỉnh sửa bài học</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="mb-3">
                                <label class="form-label">Tên bài học <span class="text-danger">*</span></label>
                                <input type="text" name="title" id="editLessonTitle" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Nội dung <span class="text-danger">*</span></label>
                                <textarea name="content" id="editLessonContent" class="form-control" rows="5" required></textarea>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Video URL (nếu có)</label>
                                <input type="url" name="videoUrl" id="editLessonVideoUrl" class="form-control" placeholder="https://youtube.com/watch?v=...">
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                            <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Delete Confirmation Modal -->
        <div class="modal fade" id="deleteConfirmationModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Xác nhận xóa</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p>Bạn có chắc chắn muốn xóa mục này không? Hành động này không thể hoàn tác.</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <a id="confirmDeleteBtn" href="#" class="btn btn-danger">Xóa</a>
                    </div>
                </div>
            </div>
        </div>

        <!-- JavaScript -->
        <script>
            // Form validation
            (function () {
                'use strict'
                var forms = document.querySelectorAll('.needs-validation')
                Array.prototype.slice.call(forms)
                        .forEach(function (form) {
                            form.addEventListener('submit', function (event) {
                                if (!form.checkValidity()) {
                                    event.preventDefault()
                                    event.stopPropagation()
                                }
                                form.classList.add('was-validated')
                            }, false)
                        })
            })()

            // Module functions
            function editModule(id, title, description) {
                document.getElementById('editModuleId').value = id;
                document.getElementById('editModuleTitle').value = title;
                document.getElementById('editModuleDescription').value = description;

                var modal = new bootstrap.Modal(document.getElementById('editModuleModal'));
                modal.show();
            }

            function confirmDeleteModule(id) {
                document.getElementById('confirmDeleteBtn').href = 'courseadmin?action=deleteModule&id=' + id;

                var modal = new bootstrap.Modal(document.getElementById('deleteConfirmationModal'));
                modal.show();
            }

            // Lesson functions
            function editLesson(id, title, content, videoUrl) {
                document.getElementById('editLessonId').value = id;
                document.getElementById('editLessonTitle').value = title;
                document.getElementById('editLessonContent').value = content;
                document.getElementById('editLessonVideoUrl').value = videoUrl || '';

                var modal = new bootstrap.Modal(document.getElementById('editLessonModal'));
                modal.show();
            }

            function confirmDeleteLesson(id) {
                document.getElementById('confirmDeleteBtn').href = 'courseadmin?action=deleteLesson&id=' + id;

                var modal = new bootstrap.Modal(document.getElementById('deleteConfirmationModal'));
                modal.show();
            }
        </script>  
