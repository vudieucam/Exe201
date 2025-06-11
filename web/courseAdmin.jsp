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
        <pre>${modules}</pre>
        <h3>Debug Information</h3>
        <p>Current Course: ${currentCourse != null ? currentCourse.title : 'null'}</p>
        <p>Modules Count: ${modules != null ? modules.size() : 'null'}</p>
        <p>Categories Count: ${categories != null ? categories.size() : 'null'}</p>
        <c:if test="${not empty modules}">
            <h3>Module đầu tiên: ${modules[0].title}</h3>
        </c:if>

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

                    <c:choose>
                        <c:when test="${not empty currentCourse}">
                            <!-- Hiển thị chi tiết khóa học -->
                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <div>
                                    <h2>${currentCourse.title}</h2>
                                    <div class="d-flex gap-3">
                                        <span class="text-muted"><i class="bi bi-person"></i> ${currentCourse.researcher}</span>
                                        <span class="text-muted"><i class="bi bi-clock"></i> ${currentCourse.duration} </span>
                                        <span class="badge ${currentCourse.status == 1 ? 'bg-success' : 'bg-secondary'}">
                                            ${currentCourse.status == 1 ? 'Hoạt động' : 'Không hoạt động'}
                                        </span>
                                    </div>
                                </div>
                                <div>
                                    <a href="${pageContext.request.contextPath}/courseedit?id=${currentCourse.id}" class="btn btn-primary me-2">
                                        <i class="bi bi-pencil"></i> Sửa khóa học
                                    </a>
                                    <a href="${pageContext.request.contextPath}/courseadmin" class="btn btn-secondary">
                                        <i class="bi bi-arrow-left"></i> Quay lại
                                    </a>
                                </div>
                            </div>

                            <!-- Thông tin mô tả khóa học -->
                            <div class="card mb-4">
                                <div class="card-body">
                                    <h5 class="card-title">Mô tả khóa học</h5>
                                    <p class="card-text">${currentCourse.description}</p>
                                </div>
                            </div>

                            <!-- Danh sách Module -->
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h4>Danh sách Modules</h4>
                                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addModuleModal">
                                    <i class="bi bi-plus"></i> Thêm Module
                                </button>
                            </div>

                            <c:if test="${not empty modules}">
                                <div class="accordion module-accordion" id="modulesAccordion">
                                    <c:forEach var="module" items="${modules}" varStatus="loop">
                                        <div class="card mb-3" id="module-${module.id}">
                                            <div class="card-header" id="moduleHeading-${loop.index}">
                                                <div class="d-flex justify-content-between align-items-center">
                                                    <button class="btn btn-link text-decoration-none flex-grow-1 text-start" 
                                                            type="button" data-bs-toggle="collapse" 
                                                            data-bs-target="#moduleCollapse-${loop.index}" 
                                                            aria-expanded="true" 
                                                            aria-controls="moduleCollapse-${loop.index}">
                                                        <h5 class="mb-0 d-flex align-items-center">
                                                            <i class="bi bi-chevron-down me-2"></i>
                                                            ${module.title}
                                                        </h5>
                                                    </button>
                                                    <div class="d-flex">
                                                        <span class="badge ${module.status == 1 ? 'bg-success' : 'bg-secondary'} me-2">
                                                            ${module.status == 1 ? 'Hiển thị' : 'Ẩn'}
                                                        </span>
                                                        <button class="btn btn-sm btn-outline-primary me-2" 
                                                                onclick="openEditModuleModal(${module.id}, '${module.title}', '${module.description}')">
                                                            <i class="bi bi-pencil"></i>
                                                        </button>
                                                        <a href="moduleadmin?action=toggleStatus&id=${module.id}&courseId=${currentCourse.id}" 
                                                           class="btn btn-sm ${module.status == 1 ? 'btn-outline-warning' : 'btn-outline-success'} me-2">
                                                            <i class="bi ${module.status == 1 ? 'bi-eye-slash' : 'bi-eye'}"></i>
                                                        </a>
                                                        <a href="moduleadmin?action=delete&id=${module.id}&courseId=${currentCourse.id}" 
                                                           class="btn btn-sm btn-outline-danger" 
                                                           onclick="return confirm('Bạn có chắc muốn xóa module này?')">
                                                            <i class="bi bi-trash"></i>
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                            <div id="moduleCollapse-${loop.index}" 
                                                 class="collapse ${loop.first ? 'show' : ''}" 
                                                 aria-labelledby="moduleHeading-${loop.index}" 
                                                 data-bs-parent="#modulesAccordion">
                                                <div class="card-body">
                                                    <p class="text-muted">${module.description}</p>

                                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                                        <h6>Bài học</h6>
                                                        <button class="btn btn-sm btn-success" 
                                                                onclick="openAddLessonModal(${module.id})">
                                                            <i class="bi bi-plus"></i> Thêm Lesson
                                                        </button>
                                                    </div>

                                                    <c:if test="${not empty module.lessons}">
                                                        <div class="list-group">
                                                            <c:forEach var="lesson" items="${module.lessons}">
                                                                <div class="list-group-item lesson-item mb-2" id="lesson-${lesson.id}">
                                                                    <div class="d-flex justify-content-between align-items-center">
                                                                        <div>
                                                                            <h6 class="mb-1">${lesson.title}</h6>
                                                                            <small class="text-muted">
                                                                                Thời lượng: ${lesson.duration}
                                                                                <span class="mx-2">|</span>
                                                                                Trạng thái: 
                                                                                <span class="badge ${lesson.status == 1 ? 'bg-success' : 'bg-secondary'}">
                                                                                    ${lesson.status == 1 ? 'Hiển thị' : 'Ẩn'}
                                                                                </span>
                                                                            </small>
                                                                        </div>
                                                                        <div>
                                                                            <button class="btn btn-sm btn-outline-primary me-1" 
                                                                                    onclick="openEditLessonModal(${lesson.id}, '${lesson.title}', '${lesson.content}', '${lesson.videoUrl}', ${lesson.duration})">
                                                                                <i class="bi bi-pencil"></i>
                                                                            </button>
                                                                            <a href="lessonadmin?action=toggleStatus&id=${lesson.id}&moduleId=${module.id}" 
                                                                               class="btn btn-sm ${lesson.status == 1 ? 'btn-outline-warning' : 'btn-outline-success'} me-1">
                                                                                <i class="bi ${lesson.status == 1 ? 'bi-eye-slash' : 'bi-eye'}"></i>
                                                                            </a>
                                                                            <button class="btn btn-sm btn-outline-danger" 
                                                                                    onclick="confirmDeleteLesson(${lesson.id}, ${module.id})">
                                                                                <i class="bi bi-trash"></i>
                                                                            </button>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </c:forEach>
                                                        </div>
                                                    </c:if>
                                                    <c:if test="${empty module.lessons}">
                                                        <div class="alert alert-info">Chưa có bài học nào trong module này.</div>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:if>

                            <c:if test="${empty modules}">
                                <div class="alert alert-info">Khóa học này chưa có module nào.</div>
                            </c:if>
                        </c:when>

                        <c:otherwise>
                            <!-- Hiển thị danh sách khóa học -->
                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <h2>Quản Lý Khóa Học</h2>
                                <a href="${pageContext.request.contextPath}/courseadd" class="btn btn-primary">
                                    <i class="bi bi-plus-lg"></i> Thêm khóa học
                                </a>
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
                                                <c:forEach var="course" items="${courses}">
                                                    <tr>
                                                        <td>${course.id}</td>
                                                        <td>
                                                            <!-- Thay thế các dòng hiện tại -->
                                                            <a href="${pageContext.request.contextPath}/courseadmin?id=${course.id}" class="text-primary fw-bold">
                                                                ${course.title}
                                                            </a>
                                                        </td>
                                                        <td>${course.researcher}</td>
                                                        <td>
                                                            <c:forEach items="${course.categories}" var="cat" varStatus="loop">
                                                                <span class="badge bg-info">${cat.name}</span>
                                                            </c:forEach>
                                                        </td>
                                                        <td>${course.duration} </td>
                                                        <td>
                                                            <span class="badge ${course.status == 1 ? 'bg-success' : 'bg-secondary'}">
                                                                ${course.status == 1 ? 'Hoạt động' : 'Không hoạt động'}
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <div class="d-flex">
                                                                <a href="${pageContext.request.contextPath}/courseadmin?id=${course.id}" 
                                                                   class="btn btn-sm btn-outline-primary me-1" title="Xem chi tiết">
                                                                    <i class="bi bi-eye"></i>
                                                                </a>
                                                                <a href="${pageContext.request.contextPath}/courseedit?id=${course.id}" 
                                                                   class="btn btn-sm btn-outline-success me-1" title="Sửa">
                                                                    <i class="bi bi-pencil"></i>
                                                                </a>
                                                                <a href="${pageContext.request.contextPath}/courseadmin?action=toggleStatus&id=${course.id}" 
                                                                   class="btn btn-sm ${course.status == 1 ? 'btn-outline-warning' : 'btn-outline-info'}" 
                                                                   title="${course.status == 1 ? 'Ẩn khóa học' : 'Hiện khóa học'}">
                                                                    <i class="bi ${course.status == 1 ? 'bi-eye-slash' : 'bi-eye'}"></i>
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

                            <!-- Phân trang -->
                            <nav class="mt-4">
                                <ul class="pagination justify-content-center">
                                    <c:if test="${currentPage > 1}">
                                        <li class="page-item">
                                            <a class="page-link" href="?page=${currentPage - 1}&search=${param.search}&status=${param.status}&category=${param.category}">Trước</a>
                                        </li>
                                    </c:if>

                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                                            <a class="page-link" href="?page=${i}&search=${param.search}&status=${param.status}&category=${param.category}">${i}</a>
                                        </li>
                                    </c:forEach>

                                    <c:if test="${currentPage < totalPages}">
                                        <li class="page-item">
                                            <a class="page-link" href="?page=${currentPage + 1}&search=${param.search}&status=${param.status}&category=${param.category}">Tiếp</a>
                                        </li>
                                    </c:if>
                                </ul>
                            </nav>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <!-- Add Module Modal -->
        <div class="modal fade" id="addModuleModal" tabindex="-1" aria-labelledby="addModuleModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="addModuleModalLabel">Thêm Module mới</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form action="${pageContext.request.contextPath}/moduleadmin" method="POST">
                        <input type="hidden" name="action" value="add">
                        <input type="hidden" name="courseId" value="${currentCourse.id}">
                        <div class="modal-body">
                            <div class="mb-3">
                                <label for="moduleTitle" class="form-label">Tên Module <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="moduleTitle" name="title" required>
                            </div>
                            <div class="mb-3">
                                <label for="moduleDescription" class="form-label">Mô tả</label>
                                <textarea class="form-control" id="moduleDescription" name="description" rows="3"></textarea>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-primary">Thêm Module</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Edit Module Modal -->
        <div class="modal fade" id="editModuleModal" tabindex="-1" aria-labelledby="editModuleModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="editModuleModalLabel">Chỉnh sửa Module</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form action="${pageContext.request.contextPath}/moduleadmin" method="post">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" id="editModuleId" name="id">
                        <input type="hidden" name="courseId" value="${currentCourse.id}">
                        <div class="modal-body">
                            <div class="mb-3">
                                <label for="editModuleTitle" class="form-label">Tên Module <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="editModuleTitle" name="title" required>
                            </div>
                            <div class="mb-3">
                                <label for="editModuleDescription" class="form-label">Mô tả</label>
                                <textarea class="form-control" id="editModuleDescription" name="description" rows="3"></textarea>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Add Lesson Modal -->
        <div class="modal fade" id="addLessonModal" tabindex="-1" aria-labelledby="addLessonModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="addLessonModalLabel">Thêm Lesson mới</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form action="${pageContext.request.contextPath}/lessonadmin" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="action" value="add">
                        <input type="hidden" id="addLessonModuleId" name="moduleId">
                        <div class="modal-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="lessonTitle" class="form-label">Tên Lesson <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" id="lessonTitle" name="title" required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="lessonDuration" class="form-label">Thời lượng <span class="text-danger">*</span></label>
                                        <input type="number" class="form-control" id="lessonDuration" name="duration" min="1" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="lessonVideoUrl" class="form-label">URL Video</label>
                                        <input type="url" class="form-control" id="lessonVideoUrl" name="videoUrl">
                                    </div>
                                    <div class="mb-3">
                                        <label for="lessonFiles" class="form-label">Tài liệu đính kèm</label>
                                        <input type="file" class="form-control" id="lessonFiles" name="files" multiple>
                                    </div>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label for="lessonContent" class="form-label">Nội dung <span class="text-danger">*</span></label>
                                <textarea class="form-control" id="lessonContent" name="content" rows="5" required></textarea>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-primary">Thêm Lesson</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Edit Lesson Modal -->
        <div class="modal fade" id="editLessonModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <form action="${pageContext.request.contextPath}/lessonadmin" method="post">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="lessonId" id="editLessonId">
                        <div class="modal-header">
                            <h5 class="modal-title">Chỉnh sửa bài học</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label">Tên bài học <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" name="title" id="editLessonTitle" required>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Thời lượng  <span class="text-danger">*</span></label>
                                        <input type="number" class="form-control" name="duration" id="editLessonDuration" min="1" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label">Video URL</label>
                                        <input type="url" class="form-control" name="videoUrl" id="editLessonVideoUrl">
                                    </div>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Nội dung <span class="text-danger">*</span></label>
                                <textarea class="form-control" name="content" id="editLessonContent" rows="5" required></textarea>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
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
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        Bạn có chắc chắn muốn xóa mục này không? Hành động này không thể hoàn tác.
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <a id="confirmDeleteBtn" href="#" class="btn btn-danger">Xóa</a>
                    </div>
                </div>

            </div>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
            <script>
                                                                                        // Mở modal chỉnh sửa module
                                                                                        function openEditModuleModal(id, title, description) {
                                                                                            document.getElementById('editModuleId').value = id;
                                                                                            document.getElementById('editModuleTitle').value = title;
                                                                                            document.getElementById('editModuleDescription').value = description || '';

                                                                                            const modal = new bootstrap.Modal(document.getElementById('editModuleModal'));
                                                                                            modal.show();
                                                                                        }

                                                                                        // Mở modal thêm lesson
                                                                                        function openAddLessonModal(moduleId) {
                                                                                            document.getElementById('addLessonModuleId').value = moduleId;

                                                                                            const modal = new bootstrap.Modal(document.getElementById('addLessonModal'));
                                                                                            modal.show();
                                                                                        }

                                                                                        // Mở modal chỉnh sửa lesson
                                                                                        function openEditLessonModal(id, title, content, videoUrl, duration) {
                                                                                            document.getElementById('editLessonId').value = id;
                                                                                            document.getElementById('editLessonTitle').value = title;
                                                                                            document.getElementById('editLessonContent').value = content;
                                                                                            document.getElementById('editLessonVideoUrl').value = videoUrl || '';
                                                                                            document.getElementById('editLessonDuration').value = duration || 0;

                                                                                            const modal = new bootstrap.Modal(document.getElementById('editLessonModal'));
                                                                                            modal.show();
                                                                                        }

                                                                                        // Xác nhận xóa lesson
                                                                                        function confirmDeleteLesson(id, moduleId) {
                                                                                            const deleteUrl = `lessonadmin?action=delete&id=${id}&moduleId=${moduleId}`;
                                                                                            document.getElementById('confirmDeleteBtn').href = deleteUrl;

                                                                                            const modal = new bootstrap.Modal(document.getElementById('deleteConfirmationModal'));
                                                                                            modal.show();
                                                                                        }

                                                                                        // Tự động focus vào input đầu tiên khi mở modal
                                                                                        document.getElementById('addModuleModal').addEventListener('shown.bs.modal', function () {
                                                                                            document.getElementById('moduleTitle').focus();
                                                                                        });

                                                                                        document.getElementById('addLessonModal').addEventListener('shown.bs.modal', function () {
                                                                                            document.getElementById('lessonTitle').focus();
                                                                                        });

                                                                                        document.getElementById('editModuleModal').addEventListener('shown.bs.modal', function () {
                                                                                            document.getElementById('editModuleTitle').focus();
                                                                                        });

                                                                                        document.getElementById('editLessonModal').addEventListener('shown.bs.modal', function () {
                                                                                            document.getElementById('editLessonTitle').focus();
                                                                                        });
            </script>
    </body>
</html>