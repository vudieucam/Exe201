<%-- 
    Document   : courseDetailAdmin
    Created on : Jun 12, 2025, 12:09:58 AM
    Author     : FPT
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chi tiết Khóa học - PetTech Admin</title>
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

            .course-image {
                height: 200px;
                object-fit: cover;
                border-radius: 10px;
                margin-bottom: 20px;
            }

            /* Module styling */
            .module-header {
                background-color: #f0f5ff;
                border-radius: 10px;
                padding: 15px 20px;
                margin-bottom: 15px;
            }

            .lesson-item {
                border-left: 3px solid var(--primary-color);
                padding: 10px 15px;
                margin-bottom: 10px;
                background-color: white;
                border-radius: 0 8px 8px 0;
                transition: all 0.3s;
            }

            .lesson-item:hover {
                background-color: #f8f9ff;
                transform: translateX(5px);
            }
            .module-actions {
                display: flex;
                gap: 8px;
                justify-content: flex-end;
            }

            .lesson-actions {
                display: flex;
                gap: 8px;
            }

            .action-icon {
                font-size: 18px;
            }

            /* Tông màu nâu cam đất */
            .text-orange {
                color: #C96F35; /* Cam đất */
            }

            .text-brown {
                color: #7A4E2D; /* Nâu trầm */
            }

            .bg-orange {
                background-color: #C96F35;
            }

            .bg-brown {
                background-color: #7A4E2D;
            }

            .bg-light-brown {
                background-color: #F5E9DE; /* Nâu be nhạt */
            }

            .btn-orange {
                background-color: #C96F35;
                color: white;
            }

            .btn-orange:hover {
                background-color: #B45F2B;
                color: white;
            }

            .border-orange {
                border-color: #C96F35 !important;
            }
            .lesson-content.collapsed {
                max-height: 150px;
                overflow: hidden;
                position: relative;
            }

            .lesson-content.collapsed::after {
                content: "";
                position: absolute;
                bottom: 0;
                left: 0;
                height: 40px;
                width: 100%;
                background: linear-gradient(to bottom, rgba(255,255,255,0), #fff);
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
                        <h2 class="fw-bold text-orange">Chi tiết Khóa học</h2>
                        <div>
                            <a href="courseadmin" class="btn btn-outline-secondary">
                                <i class="bi bi-arrow-left"></i> Quay lại danh sách
                            </a>
                        </div>
                    </div>

                    <!-- Thông báo -->
                    <c:if test="${not empty success}">
                        <div class="alert alert-success alert-dismissible fade show">
                            <i class="bi bi-check-circle me-2"></i> ${success}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show">
                            <i class="bi bi-exclamation-triangle me-2"></i> ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <!-- Thông tin khóa học -->
                    <div class="card mb-4 border-orange">
                        <div class="card-header bg-orange text-white">
                            <h4 class="mb-0"><i class="bi bi-book me-2"></i>Thông tin khóa học</h4>
                        </div>
                        <div class="card-body">
                            <c:set var="imageUrl" value="${course.thumbnailUrl}" />
                            <c:set var="defaultImage" value="${pageContext.request.contextPath}/assets/img/default-course.png" />

                            <c:choose>
                                <c:when test="${not empty imageUrl}">
                                    <c:choose>
                                        <c:when test="${fn:startsWith(imageUrl, '/')}">
                                            <c:set var="finalImagePath" value="${pageContext.request.contextPath}${imageUrl}" />
                                        </c:when>
                                        <c:when test="${fn:startsWith(imageUrl, 'http')}">
                                            <c:set var="finalImagePath" value="${imageUrl}" />
                                        </c:when>
                                        <c:otherwise>
                                            <c:set var="finalImagePath" value="${pageContext.request.contextPath}/uploads/${imageUrl}" />
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                    <c:set var="finalImagePath" value="${defaultImage}" />
                                </c:otherwise>
                            </c:choose>

                            <div class="row">
                                <div class="col-md-4">
                                    <img src="${finalImagePath}"
                                         alt="${course.title}" class="img-fluid rounded shadow"
                                         style="border: 3px solid #FFA630; max-height: 225px; object-fit: cover;"
                                         onerror="this.onerror=null; this.src='${defaultImage}'">
                                </div>
                                <div class="col-md-8">
                                    <h3 class="text-brown">${course.title}</h3>
                                    <div class="d-flex align-items-center mb-3">
                                        <c:forEach items="${course.categories}" var="category">
                                            <span class="badge bg-brown me-2">${category.name}</span>
                                        </c:forEach>
                                        <span class="badge ${course.status == 1 ? 'bg-success' : 'bg-secondary'}">
                                            ${course.status == 1 ? 'Hoạt động' : 'Tạm ẩn'}
                                        </span>
                                    </div>

                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <p><i class="bi bi-person-fill text-orange me-2"></i> <strong>Giảng viên:</strong> ${course.researcher}</p>
                                            <p><i class="bi bi-clock-fill text-orange me-2"></i> <strong>Thời lượng:</strong> ${course.duration}</p>
                                        </div>
                                        <div class="col-md-6">
                                            <p><i class="bi bi-people-fill text-orange me-2"></i> <strong>Học viên:</strong> đang cập nhật</p>
                                            <p><i class="bi bi-star-fill text-orange me-2"></i> <strong>Đánh giá:</strong> đang cập nhật</p>
                                        </div>
                                    </div>

                                    <div class="mb-3">
                                        <p><i class="bi bi-calendar-event text-orange me-2"></i> 
                                            <strong>Ngày tạo:</strong> 
                                            <fmt:formatDate value="${course.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </p>

                                        <p><i class="bi bi-pencil-square text-orange me-2"></i> 
                                            <strong>Ngày chỉnh sửa:</strong> 
                                            <fmt:formatDate value="${course.updatedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </p>

                                        <p><i class="bi bi-currency-dollar text-orange me-2"></i> <strong>Giá:</strong> 
                                            <c:choose>
                                                <c:when test="${!course.isPaid}">
                                                    <span class="badge bg-success">Miễn phí</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-warning text-dark">Có phí</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                    </div>
                                </div>
                            </div>

                            <div class="mt-4">
                                <h5 class="text-brown"><i class="bi bi-card-text me-2"></i>Mô tả khóa học</h5>
                                <div class="p-3 bg-light rounded">${course.content}</div>
                            </div>
                        </div>



                        <!-- Danh sách Module và Lesson -->
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h3 class="text-brown"><i class="bi bi-list-ol me-2"></i>Nội dung khóa học</h3>
                            <button class="btn btn-orange" data-bs-toggle="modal" data-bs-target="#addModuleModal">
                                <i class="bi bi-plus-circle"></i> Thêm Module
                            </button>
                        </div>

                        <c:forEach items="${modules}" var="module" varStatus="loop">
                            <div class="card mb-4">
                                <div class="card-header d-flex justify-content-between align-items-center bg-light-brown">
                                    <div class="d-flex align-items-center">
                                        <h5 class="mb-0 me-3">Module ${loop.index + 1}: ${module.title}</h5>
                                        <span class="badge ${module.status ? 'bg-success' : 'bg-secondary'}">
                                            ${module.status ? 'Hiển thị' : 'Ẩn'}
                                        </span>
                                    </div>
                                    <div class="module-actions">

                                        <button class="btn btn-sm btn-outline-orange" data-bs-toggle="modal" 
                                                data-bs-target="#editModuleModal" 
                                                data-module-id="${module.id}"
                                                data-module-name="${module.title}"
                                                data-module-desc="${module.description}"
                                                data-module-status="${module.status}">
                                            <i class="bi bi-pencil"></i> Sửa
                                        </button>
                                        <a href="module?action=toggleStatus&id=${module.id}&courseId=${course.id}" 
                                           class="btn btn-sm btn-outline-secondary">
                                            <i class="bi ${module.status ? 'bi-eye-slash' : 'bi-eye'}"></i> 
                                            ${module.status ? 'Ẩn' : 'Hiện'}
                                        </a>

                                        <button class="btn btn-sm btn-outline-danger" data-bs-toggle="modal" 
                                                data-bs-target="#deleteModuleModal" data-module-id="${module.id}">
                                            <i class="bi bi-trash"></i> Xóa
                                        </button>
                                    </div>
                                </div>
                                <div class="card-body">
                                    <p class="text-muted">${module.description}</p>

                                    <div class="d-flex justify-content-between align-items-center mt-3 mb-3">
                                        <h6 class="mb-0 text-brown"><i class="bi bi-play-circle me-2"></i>Bài học</h6>
                                        <button class="btn btn-sm btn-orange" data-bs-toggle="modal" 
                                                data-bs-target="#addLessonModal" data-module-id="${module.id}">
                                            <i class="bi bi-plus-circle"></i> Thêm bài học
                                        </button>
                                    </div>

                                    <div class="list-group">
                                        <c:forEach items="${lessonsByModule[module.id]}" var="lesson" varStatus="lessonLoop">
                                            <div class="list-group-item">
                                                <div class="d-flex justify-content-between align-items-center">
                                                    <div>
                                                        <h6 class="mb-1">Bài ${lessonLoop.index + 1}: ${lesson.title}</h6>
                                                        <div class="d-flex">
                                                            <span class="badge bg-light text-dark me-2">
                                                                <i class="bi bi-clock"></i> ${lesson.duration} phút
                                                            </span>
                                                            <span class="badge ${lesson.status ? 'bg-success' : 'bg-secondary'}">
                                                                ${lesson.status ? 'Hiển thị' : 'Ẩn'}
                                                            </span>
                                                        </div>
                                                    </div>
                                                    <div class="lesson-actions">
                                                        <button class="btn btn-sm btn-outline-primary toggle-btn" type="button"
                                                                data-bs-toggle="collapse"
                                                                data-bs-target="#lesson-detail-${lesson.id}"
                                                                aria-expanded="false"
                                                                aria-controls="lesson-detail-${lesson.id}">
                                                            <i class="bi bi-caret-down toggle-icon" id="icon-${lesson.id}"></i>
                                                        </button>

                                                        <!-- Toggle status (Ẩn/Hiện) -->
                                                        <a href="lesson?action=toggleStatus&id=${lesson.id}&moduleId=${module.id}" 
                                                           class="btn btn-sm ${lesson.status ? 'btn-outline-secondary' : 'btn-outline-success'}"
                                                           title="${lesson.status ? 'Ẩn bài học' : 'Hiện bài học'}">
                                                            <i class="bi ${lesson.status ? 'bi-eye-slash' : 'bi-eye'}"></i>
                                                        </a>

                                                        <!-- Edit -->
                                                        <button class="btn btn-sm btn-outline-orange" 
                                                                data-bs-toggle="modal" 
                                                                data-bs-target="#editLessonModal"
                                                                data-lesson-id="${lesson.id}"
                                                                data-lesson-title="${lesson.title}"
                                                                data-lesson-content="${lesson.content}"
                                                                data-lesson-video="${lesson.videoUrl}"
                                                                data-lesson-duration="${lesson.duration}"
                                                                data-lesson-status="${lesson.status}"
                                                                data-module-id="${module.id}">
                                                            <i class="bi bi-pencil"></i>
                                                        </button>



                                                        <!-- Delete -->
                                                        <button class="btn btn-sm btn-outline-danger" data-bs-toggle="modal" 
                                                                data-bs-target="#deleteLessonModal" 
                                                                data-lesson-id="${lesson.id}"
                                                                data-lesson-name="${lesson.title}">
                                                            <i class="bi bi-trash"></i>
                                                        </button>
                                                    </div>


                                                </div>

                                                <div class="collapse mt-3" id="lesson-detail-${lesson.id}">
                                                    <div class="card card-body bg-light">
                                                        <p><strong>Nội dung:</strong></p>

                                                        <div class="lesson-content-wrapper">
                                                            <div class="lesson-content collapsed" id="content-${lesson.id}">
                                                                <c:out value="${lesson.content}" escapeXml="false" />
                                                            </div>
                                                            <button class="btn btn-sm btn-link p-0 mt-2 toggle-content-btn" 
                                                                    type="button" 
                                                                    data-target="content-${lesson.id}">
                                                                Xem thêm
                                                            </button>
                                                        </div>

                                                        <c:if test="${not empty lesson.videoUrl}">
                                                            <div class="mt-3">
                                                                <video controls width="100%">
                                                                    <source src="${lesson.videoUrl}" type="video/mp4">
                                                                    Trình duyệt không hỗ trợ phát video.
                                                                </video>
                                                            </div>
                                                        </c:if>
                                                    </div>
                                                </div>



                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>

                    </div>

                    <!-- Modal Thêm Module -->
                    <div class="modal fade" id="addModuleModal" tabindex="-1" aria-labelledby="addModuleModalLabel" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header bg-orange text-white">
                                    <h5 class="modal-title" id="addModuleModalLabel">Thêm Module mới</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <form action="course" method="POST" enctype="multipart/form-data">
                                    <input type="hidden" name="action" value="add">
                                    <input type="hidden" name="courseId" value="${course.id}">
                                    <div class="modal-body">
                                        <div class="mb-3">
                                            <label for="moduleName" class="form-label">Tên Module</label>
                                            <input type="text" class="form-control" id="moduleName" name="title" required>
                                        </div>
                                        <div class="mb-3">
                                            <label for="moduleDesc" class="form-label">Mô tả</label>
                                            <textarea class="form-control" id="moduleDesc" name="description" rows="3"></textarea>
                                        </div>
                                        <div class="mb-3 form-check">
                                            <input type="checkbox" class="form-check-input" id="moduleStatus" name="status" checked>
                                            <label class="form-check-label" for="moduleStatus">Hiển thị Module</label>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                        <button type="submit" class="btn btn-orange">Lưu Module</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- Modal Sửa Module -->
                    <div class="modal fade" id="editModuleModal" tabindex="-1" aria-labelledby="editModuleModalLabel" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header bg-orange text-white">
                                    <h5 class="modal-title" id="editModuleModalLabel">Chỉnh sửa Module</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <form action="module" method="POST">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" name="courseId" value="${course.id}">
                                    <input type="hidden" id="editModuleId" name="moduleId">
                                    <div class="modal-body">
                                        <div class="mb-3">
                                            <label for="editModuleName" class="form-label">Tên Module</label>
                                            <input type="text" class="form-control" id="editModuleName" name="title" required>
                                        </div>
                                        <div class="mb-3">
                                            <label for="editModuleDesc" class="form-label">Mô tả</label>
                                            <textarea class="form-control" id="editModuleDesc" name="description" rows="3"></textarea>
                                        </div>
                                        <div class="mb-3 form-check">
                                            <input type="checkbox" class="form-check-input" id="editModuleStatus" name="status">
                                            <label class="form-check-label" for="editModuleStatus">Hiển thị Module</label>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                        <button type="submit" class="btn btn-orange">Cập nhật</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- Modal Xóa Module -->
                    <div class="modal fade" id="deleteModuleModal" tabindex="-1" aria-labelledby="deleteModuleModalLabel" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header bg-danger text-white">
                                    <h5 class="modal-title" id="deleteModuleModalLabel">Xác nhận xóa Module</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <form action="module" method="POST">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="courseId" value="${course.id}">
                                    <input type="hidden" id="deleteModuleId" name="id">
                                    <div class="modal-body">
                                        <p>Bạn có chắc chắn muốn xóa Module này? Tất cả bài học trong Module cũng sẽ bị xóa.</p>
                                        <p class="text-danger"><strong>Hành động này không thể hoàn tác!</strong></p>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                        <button type="submit" class="btn btn-danger">Xác nhận xóa</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- Modal Thêm Bài học -->
                    <div class="modal fade" id="addLessonModal" tabindex="-1" aria-labelledby="addLessonModalLabel" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header bg-orange text-white">
                                    <h5 class="modal-title" id="addLessonModalLabel">Thêm Bài học mới</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <form action="lesson" method="POST">
                                    <input type="hidden" name="action" value="add">
                                    <input type="hidden" id="addLessonModuleId" name="moduleId">
                                    <div class="modal-body">
                                        <div class="mb-3">
                                            <label for="lessonName" class="form-label">Tên bài học</label>
                                            <input type="text" class="form-control" id="lessonName" name="title" required>
                                        </div>
                                        <div class="mb-3">
                                            <label for="lessonDuration" class="form-label">Thời lượng (phút)</label>
                                            <input type="number" class="form-control" id="lessonDuration" name="duration" min="1" value="15">
                                        </div>
                                        <div class="mb-3">
                                            <label for="lessonContent" class="form-label">Nội dung</label>
                                            <textarea class="form-control" id="lessonContent" name="content" rows="5"></textarea>
                                        </div>
                                        <div class="mb-3">
                                            <label for="lessonVideo" class="form-label">URL Video (nếu có)</label>
                                            <input type="url" class="form-control" id="lessonVideo" name="videoUrl">
                                        </div>
                                        <div class="mb-3 form-check">
                                            <input type="checkbox" class="form-check-input" id="lessonStatus" name="status" checked>
                                            <label class="form-check-label" for="lessonStatus">Hiển thị bài học</label>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                        <button type="submit" class="btn btn-orange">Lưu bài học</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                    <!-- Modal Sửa Bài học -->
                    <div class="modal fade" id="editLessonModal" tabindex="-1" aria-labelledby="editLessonModalLabel" aria-hidden="true">
                        <div class="modal-dialog modal-lg"> <!-- modal-lg để textarea rộng hơn -->
                            <div class="modal-content">
                                <div class="modal-header bg-orange text-white">
                                    <h5 class="modal-title" id="editLessonModalLabel">Chỉnh sửa Bài học</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <form action="lesson" method="POST">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" id="editLessonId" name="lessonId"> <!-- PHẢI là lessonId -->
                                    <input type="hidden" id="editLessonModuleId" name="moduleId">

                                    <div class="modal-body">
                                        <div class="mb-3">
                                            <label for="editLessonName" class="form-label">Tên bài học</label>
                                            <input type="text" class="form-control" id="editLessonName" name="title" required>
                                        </div>
                                        <div class="mb-3">
                                            <label for="editLessonDuration" class="form-label">Thời lượng (phút)</label>
                                            <input type="number" class="form-control" id="editLessonDuration" name="duration" min="1">
                                        </div>
                                        <div class="mb-3">
                                            <label for="editLessonContent" class="form-label">Nội dung</label>
                                            <textarea class="form-control" id="editLessonContent" name="content" rows="10"></textarea>
                                        </div>
                                        <div class="mb-3">
                                            <label for="editLessonVideo" class="form-label">URL Video (nếu có)</label>
                                            <input type="url" class="form-control" id="editLessonVideo" name="videoUrl">
                                        </div>
                                        <div class="mb-3 form-check">
                                            <input type="checkbox" class="form-check-input" id="editLessonStatus" name="status">
                                            <label class="form-check-label" for="editLessonStatus">Hiển thị bài học</label>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                        <button type="submit" class="btn btn-orange">Cập nhật bài học</button>
                                    </div>
                                </form>

                            </div>
                        </div>
                    </div>

                    <!-- Modal Xóa Bài học -->
                    <div class="modal fade" id="deleteLessonModal" tabindex="-1" aria-labelledby="deleteLessonModalLabel" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header bg-danger text-white">
                                    <h5 class="modal-title" id="deleteLessonModalLabel">Xác nhận xóa Bài học</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <form action="lesson" method="POST">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" id="deleteLessonId" name="moduleId">
                                    <div class="modal-body">
                                        <p>Bạn có chắc chắn muốn xóa bài học: <strong id="deleteLessonName"></strong>?</p>
                                        <p class="text-danger"><strong>Hành động này không thể hoàn tác!</strong></p>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                        <button type="submit" class="btn btn-danger">Xác nhận xóa</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Thêm thư viện CKEditor -->
            <script src="https://cdn.ckeditor.com/4.25.1-lts/standard/ckeditor.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

            <script>
                document.addEventListener("DOMContentLoaded", function () {
                    // --- CKEditor ---
                    if (document.getElementById("lessonContent")) {
                        CKEDITOR.replace("lessonContent");
                    }

                    if (document.getElementById("editLessonContent")) {
                        CKEDITOR.replace("editLessonContent");
                    }
                    const toggleButtons = document.querySelectorAll(".toggle-content-btn");

                    toggleButtons.forEach(button => {
                        button.addEventListener("click", function () {
                            const targetId = this.getAttribute("data-target");
                            const contentDiv = document.getElementById(targetId);
                            contentDiv.classList.toggle("collapsed");

                            this.textContent = contentDiv.classList.contains("collapsed") ? "Xem thêm" : "Thu gọn";
                        });
                    });
                    const editLessonForm = document.querySelector("#editLessonModal form");
                    if (editLessonForm) {
                        editLessonForm.addEventListener("submit", function () {
                            for (const instance in CKEDITOR.instances) {
                                CKEDITOR.instances[instance].updateElement();
                            }
                        });
                    }

                    const addLessonForm = document.querySelector("#addLessonModal form");
                    if (addLessonForm) {
                        addLessonForm.addEventListener("submit", function () {
                            for (const instance in CKEDITOR.instances) {
                                CKEDITOR.instances[instance].updateElement();
                            }
                        });
                    }





                    const deleteModal = document.getElementById('deleteModuleModal');
                    if (deleteModal) {
                        deleteModal.addEventListener('show.bs.modal', function (event) {
                            const button = event.relatedTarget;
                            this.querySelector('#deleteModuleId').value = button.getAttribute('data-module-id');
                        });
                    }

                    // --- Modal xử lý BÀI HỌC ---
                    const addLessonModal = document.getElementById('addLessonModal');
                    if (addLessonModal) {
                        addLessonModal.addEventListener('show.bs.modal', function (event) {
                            const button = event.relatedTarget;
                            this.querySelector('#addLessonModuleId').value = button.getAttribute('data-module-id');
                        });
                    }

                    const deleteLessonModal = document.getElementById('deleteLessonModal');
                    if (deleteLessonModal) {
                        deleteLessonModal.addEventListener('show.bs.modal', function (event) {
                            const button = event.relatedTarget;
                            this.querySelector('#deleteLessonId').value = button.getAttribute('data-lesson-id');
                            this.querySelector('#deleteLessonName').textContent = button.getAttribute('data-lesson-name');
                        });
                    }

                    // --- Tự động đóng alert ---
                    setTimeout(function () {
                        const alerts = document.querySelectorAll('.alert');
                        alerts.forEach(alert => {
                            const bsAlert = new bootstrap.Alert(alert);
                            bsAlert.close();
                        });
                    }, 5000);

                    // --- Xử lý toggle icon ---
                    document.querySelectorAll('.toggle-btn').forEach(function (btn) {
                        const icon = btn.querySelector('.toggle-icon');
                        const targetId = btn.getAttribute('data-bs-target');
                        const collapseEl = document.querySelector(targetId);
                        const bsCollapse = new bootstrap.Collapse(collapseEl, {toggle: false});

                        btn.addEventListener('click', function () {
                            if (collapseEl.classList.contains('show')) {
                                bsCollapse.hide();
                                icon.classList.remove('bi-caret-up');
                                icon.classList.add('bi-caret-down');
                            } else {
                                bsCollapse.show();
                                icon.classList.remove('bi-caret-down');
                                icon.classList.add('bi-caret-up');
                            }
                        });
                    });
                });
                const editModuleModal = document.getElementById('editModuleModal');
                if (editModuleModal) {
                    editModuleModal.addEventListener('show.bs.modal', function (event) {
                        const button = event.relatedTarget;
                        const id = button.getAttribute('data-module-id');
                        const title = button.getAttribute('data-module-name');
                        const desc = button.getAttribute('data-module-desc');
                        const status = button.getAttribute('data-module-status') === 'true';

                        this.querySelector('#editModuleId').value = id;
                        this.querySelector('#editModuleName').value = title;
                        this.querySelector('#editModuleDesc').value = desc;
                        this.querySelector('#editModuleStatus').checked = status;
                    });
                }
                const editLessonModal = document.getElementById('editLessonModal');
                if (editLessonModal) {
                    editLessonModal.addEventListener('show.bs.modal', function (event) {
                        const button = event.relatedTarget;

                        const id = button.getAttribute('data-lesson-id');
                        const title = button.getAttribute('data-lesson-title');
                        const content = button.getAttribute('data-lesson-content');
                        const video = button.getAttribute('data-lesson-video');
                        const duration = button.getAttribute('data-lesson-duration');
                        const status = button.getAttribute('data-lesson-status') === 'true';
                        const moduleId = button.getAttribute('data-module-id');

                        this.querySelector('#editLessonId').value = id;
                        this.querySelector('#editLessonName').value = title;
                        this.querySelector('#editLessonVideo').value = video;
                        this.querySelector('#editLessonDuration').value = duration;
                        this.querySelector('#editLessonModuleId').value = moduleId;
                        this.querySelector('#editLessonStatus').checked = status;

                        // Gán nội dung CKEditor
                        if (CKEDITOR.instances.editLessonContent) {
                            CKEDITOR.instances.editLessonContent.setData(content || '');
                        }
                    });
                }

            </script>

    </body>
</html>