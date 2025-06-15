<%-- 
    Document   : courseAdmin
    Created on : May 31, 2025, 6:21:39 PM
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
            /* Thêm vào phần style */
            .table th {
                position: relative;
                cursor: pointer;
                padding-right: 30px !important;
            }

            .sort-icon {
                position: absolute;
                right: 8px;
                top: 50%;
                transform: translateY(-50%);
                color: #6c757d;
                font-size: 0.8rem;
            }

            .sort-icon:hover {
                color: var(--primary-color);
            }

            .column-search {
                margin-top: 5px;
                width: 100% !important;
            }

            .dataTables_wrapper .dataTables_filter input {
                margin-left: 0.5em;
                border: 1px solid #dee2e6;
                border-radius: 4px;
                padding: 5px 10px;
            }

            .dataTables_wrapper .dataTables_length select {
                border: 1px solid #dee2e6;
                border-radius: 4px;
                padding: 5px;
            }
            /* Thêm vào phần CSS */
            .form-control[readonly] {
                background-color: #f8f9fa;
                border-color: #e9ecef;
                cursor: not-allowed;
            }
            /* Thêm style cho module và lesson */
            .module-card {
                border-left: 4px solid var(--primary-color);
                margin-bottom: 20px;
            }

            .lesson-item {
                padding: 10px;
                border-bottom: 1px solid #eee;
                transition: all 0.2s;
            }

            .lesson-item:hover {
                background-color: #f8f9fa;
            }

            .back-btn {
                margin-bottom: 20px;
            }

            .lesson-item {
                background-color: #ffffff;
                transition: all 0.3s;
            }
            .lesson-item:hover {
                box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            }
            .lesson-header:hover {
                background-color: #f0f4ff;
            }
            .lesson-actions .btn {
                margin-left: 5px;
            }

            /* Style cho drag and drop */
            #moduleListContainer .module-card,
            .lesson-list .lesson-item {
                cursor: move;
            }

            /* Hiệu ứng khi kéo */
            #moduleListContainer .module-card.ui-sortable-helper,
            .lesson-list .lesson-item.ui-sortable-helper {
                transform: rotate(2deg);
                box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            }

            /* Vị trí placeholder khi kéo */
            #moduleListContainer .module-card.ui-sortable-placeholder,
            .lesson-list .lesson-item.ui-sortable-placeholder {
                background-color: #f8f9fa;
                border: 2px dashed #dee2e6;
                visibility: visible !important;
            }

            /* Toast message */
            .toast {
                z-index: 1100;
            }
        </style>

        <script>
            $(document).ready(function () {
                $('#courseTable').DataTable({
                    dom: 'Bfrtip',
                    buttons: [
                        'copy', 'csv', 'excel', 'pdf', 'print'
                    ],
                    columnDefs: [
                        {targets: 0, type: 'num'},
                        {targets: 1, type: 'string'},
                        {targets: 2, type: 'string'},
                        {targets: 3, type: 'string'},
                        {targets: 4, type: 'string'},
                        {targets: [6], orderable: false}
                    ],
                    language: {
                        url: '${pageContext.request.contextPath}/assets/datatables/vi.json'
                    },
                    initComplete: function () {
                        this.api().columns().every(function () {
                            var column = this;
                            var header = $(column.header());
                            if (header.index() !== 6) {
                                var input = $('<input type="text" class="column-search form-control form-control-sm" placeholder="Tìm..."/>')
                                        .appendTo(header)
                                        .on('keyup change', function () {
                                            if (column.search() !== this.value) {
                                                column.search(this.value).draw();
                                            }
                                        });
                                header.css('position', 'relative');
                                $('<span class="sort-icon"><i class="bi bi-arrow-down-up"></i></span>')
                                        .appendTo(header)
                                        .on('click', function () {
                                            column.order(column.order() === 'asc' ? 'desc' : 'asc').draw();
                                        });
                            }
                        });
                    }
                });
                $('.dataTables_filter input').addClass('form-control form-control-sm');
            });
            function deleteCourse(id) {
                if (confirm("Bạn có chắc muốn xóa khóa học này không?")) {
                    window.location.href = 'courseadmin?action=delete&id=' + id;
                }
            }

            function toggleCourseStatus(id) {
                window.location.href = 'courseadmin?action=toggleStatus&id=' + id;
            }

            $(document).ready(function () {
                $('.form-select').select2({
                    minimumResultsForSearch: Infinity
                });
            });
            function openEditCategoryModal(id, name) {
                document.getElementById('editCategoryId').value = id;
                document.getElementById('editCategoryName').value = name;
                document.getElementById('editCategoryForm').action =
                        '${pageContext.request.contextPath}/courseadmin?action=updateCategory';
                var modal = new bootstrap.Modal(document.getElementById('editCategoryModal'));
                modal.show();
            }

            function showCourseModules(courseId) {
                window.location.href = '${pageContext.request.contextPath}/courseadmin?id=' + courseId;
            }


            function backToCourseList() {
                document.querySelector('.tab-content > h2').style.display = 'block';
                document.getElementById('courseTable').style.display = 'table';
                document.querySelector('.filter-section').style.display = 'block';
                document.getElementById('courseModulesSection').style.display = 'none';
            }

            function editLesson(id, title, content, videoUrl, duration) {
                document.getElementById('editLessonId').value = id;
                document.getElementById('editLessonTitle').value = title;
                document.getElementById('editLessonContent').value = content;
                document.getElementById('editLessonVideoUrl').value = videoUrl || '';
                document.getElementById('editLessonDuration').value = duration || 0;

                const modal = new bootstrap.Modal(document.getElementById('editLessonModal'));
                modal.show();
            }
            function confirmDeleteLesson(id, moduleId) {
                const url = 'lessonadmin?action=delete&id=' + id + '&moduleId=' + moduleId;
                document.getElementById('confirmDeleteBtn').href = url;

                const modal = new bootstrap.Modal(document.getElementById('deleteConfirmationModal'));
                modal.show();
            }
// Kích hoạt sắp xếp module bằng drag and drop
            $(document).ready(function () {
                // Sắp xếp module
                $("#moduleListContainer").sortable({
                    update: function (event, ui) {
                        var moduleOrder = $(this).sortable("toArray");
                        var courseId = document.getElementById("courseIdHidden").value;  // ✅ Lấy courseId động

                        $.post("moduleadmin?action=reorder", {
                            courseId: courseId,
                            moduleOrder: moduleOrder
                        }, function (response) {
                            if (response.success) {
                                showToast("Sắp xếp module thành công");
                            } else {
                                showToast("Lỗi khi sắp xếp module", "error");
                            }
                        });
                    }
                });


                // Sắp xếp lesson trong mỗi module
                $(".lesson-list").sortable({
                    update: function (event, ui) {
                        var moduleId = $(this).data("module-id");
                        var lessonOrder = $(this).sortable("toArray");
                        $.post("lessonadmin?action=reorder", {
                            moduleId: moduleId,
                            lessonOrder: lessonOrder
                        }, function (response) {
                            if (response.success) {
                                showToast("Sắp xếp lesson thành công");
                            } else {
                                showToast("Lỗi khi sắp xếp lesson", "error");
                            }
                        });
                    }
                });
            });

            // Hiển thị toast message
            function showToast(message, type = "success") {
                var toast = $('<div class="toast align-items-center text-white bg-' + type +
                        ' border-0 position-fixed bottom-0 end-0 m-3" role="alert">' +
                        '<div class="d-flex">' +
                        '<div class="toast-body">' + message + '</div>' +
                        '<button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>' +
                        '</div></div>');

                $('body').append(toast);
                var bsToast = new bootstrap.Toast(toast[0]);
                bsToast.show();

                setTimeout(function () {
                    toast.remove();
                }, 3000);
            }
        </script>
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
                <div class="col-md-10 p-4 main-content">
                    <!-- Alerts -->
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

                    <!-- Hiển thị danh sách khóa học -->

                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2>Quản Lý Khóa Học</h2>
                        <div>
                            <!-- Nút mở modal thêm danh mục -->
                            <button type="button" class="btn btn-outline-secondary me-2" data-bs-toggle="modal" data-bs-target="#addCategoryModal">
                                <i class="bi bi-folder-plus"></i> Thêm danh mục
                            </button>

                            <a href="${pageContext.request.contextPath}/courseadd" class="btn btn-primary">
                                <i class="bi bi-plus-lg"></i> Thêm khóa học
                            </a>
                        </div>
                    </div>


                    <!-- Bộ lọc -->
                    <div class="card mb-4">
                        <div class="card-body">
                            <form id="filterForm">
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label for="searchInput" class="form-label">Tìm kiếm</label>
                                        <input type="text" class="form-control" id="searchInput" name="search" 
                                               placeholder="Tên khóa học, giảng viên..." value="${param.search}">
                                    </div>
                                    <div class="col-md-3">
                                        <label for="statusFilter" class="form-label">Trạng thái</label>
                                        <select class="form-select" id="statusFilter" name="status">
                                            <option value="">Tất cả</option>
                                            <option value="1" ${param.status == '1' ? 'selected' : ''}>Hoạt động</option>
                                            <option value="0" ${param.status == '0' ? 'selected' : ''}>Không hoạt động</option>
                                        </select>
                                    </div>
                                    <div class="col-md-3">
                                        <label for="categoryFilter" class="form-label">Danh mục</label>
                                        <select class="form-select" id="categoryFilter" name="category">
                                            <option value="">Tất cả</option>
                                            <c:forEach items="${categories}" var="category">
                                                <option value="${category.id}" ${param.category == category.id ? 'selected' : ''}>${category.name}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>
                                <div class="row mt-3">
                                    <div class="col-md-12 text-end">
                                        <button type="submit" class="btn btn-primary me-2">
                                            <i class="bi bi-funnel"></i> Lọc
                                        </button>
                                        <a href="${pageContext.request.contextPath}/courseadmin" class="btn btn-secondary">
                                            <i class="bi bi-arrow-counterclockwise"></i> Reset
                                        </a>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Danh sách khóa học -->
                    <div class="card">
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th>ID</th>
                                            <th>Tên khóa học</th>
                                            <th>Giảng viên</th>
                                            <th>Danh mục</th>
                                            <th>Thời lượng</th>
                                            <th>Trạng thái</th>
                                            <th>Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="c" items="${courses}">
                                            <tr>
                                                <td>${c.id}</td>
                                                <td>
                                                    <strong>${c.title}</strong><br/>
                                                    <a href="${pageContext.request.contextPath}/coursedetailadmin?courseId=${c.id}" class="btn btn-sm btn-link p-0 mt-1">
                                                        Quản lý Module & Lesson
                                                    </a>

                                                </td>
                                                <td>${c.researcher}</td>
                                                <td>
                                                    <c:forEach items="${c.categories}" var="cat">
                                                        <span class="badge bg-info">${cat.name}</span>
                                                    </c:forEach>
                                                </td>
                                                <td>${c.duration}</td>
                                                <td>
                                                    <span class="badge ${c.status == 1 ? 'bg-success' : 'bg-secondary'}">
                                                        ${c.status == 1 ? 'Hoạt động' : 'Không hoạt động'}
                                                    </span>
                                                </td>
                                                <td>
                                                    <div class="d-flex">
                                                        <a href="${pageContext.request.contextPath}/courseedit?id=${c.id}" class="btn btn-sm btn-outline-success me-1" title="Sửa">
                                                            <i class="bi bi-pencil"></i>
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/courseadmin?action=toggleStatus&id=${c.id}"
                                                           class="btn btn-sm ${c.status == 1 ? 'btn-outline-warning' : 'btn-outline-info'} me-1"
                                                           title="${c.status == 1 ? 'Ẩn khóa học' : 'Hiện khóa học'}">
                                                            <i class="bi ${c.status == 1 ? 'bi-eye-slash' : 'bi-eye'}"></i>
                                                        </a>
                                                        <a href="javascript:void(0);" onclick="deleteCourse(${c.id})" class="btn btn-sm btn-outline-danger" title="Xóa khóa học">
                                                            <i class="bi bi-trash"></i>
                                                        </a>
                                                    </div>
                                                </td>

                                            </tr>
                                        </c:forEach>

                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <!-- Modal Thêm Danh Mục -->
                    <div class="modal fade" id="addCategoryModal" tabindex="-1" aria-labelledby="addCategoryModalLabel" aria-hidden="true">
                        <div class="modal-dialog">
                            <!-- ✅ Sửa đường dẫn action về đúng Servlet -->
                            <form method="post" action="${pageContext.request.contextPath}/categorycourse?action=add">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="addCategoryModalLabel">Thêm danh mục khóa học</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                                    </div>
                                    <div class="modal-body">
                                        <div class="mb-3">
                                            <label for="categoryName" class="form-label">Tên danh mục</label>
                                            <input type="text" class="form-control" id="categoryName" name="categoryName" required>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                        <button type="submit" class="btn btn-primary">Thêm danh mục</button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>


                </div>

            </div>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
            <script>


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
                                                            function deleteCourse(id) {
                                                                if (confirm("Bạn có chắc muốn xóa khóa học này không?")) {
                                                                    window.location.href = 'courseadmin?action=deleteCourse&id=' + id;
                                                                }
                                                            }

            </script>
    </body>
</html>