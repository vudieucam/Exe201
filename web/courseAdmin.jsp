<%-- 
    Document   : courseAdmin
    Created on : May 31, 2025, 6:21:39 PM
    Author     : FPT
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Course" %>
<%@page import="model.CourseModule" %>
<%@page import="model.CourseLesson" %>
<%@page import="dal.CourseDAO" %>
<%@page import="java.util.List" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Date" %>


<%
    // Khởi tạo DAO
    CourseDAO courseDAO = new CourseDAO();

    // Xử lý courseId
    int courseId = 0;
    try {
        String courseIdParam = request.getParameter("id");
        if (courseIdParam != null && !courseIdParam.isEmpty()) {
            courseId = Integer.parseInt(courseIdParam);
        }
    } catch (NumberFormatException e) {
        // Xử lý khi ID không hợp lệ
        request.setAttribute("error", "ID khóa học không hợp lệ");
    }

    // Lấy danh sách courses từ request attribute hoặc từ DAO
    List<Course> courses = (List<Course>) request.getAttribute("courses");
    if (courses == null) {
        courses = courseDAO.getAllCourses();
    }

    // Lấy danh sách modules nếu đang edit course
    List<CourseModule> modules = null;
    Course currentCourse = null;
    if (courseId > 0) {
        try {
            currentCourse = courseDAO.getCourseDetails(courseId);
            modules = courseDAO.getCourseModules(courseId);

            // Kiểm tra course có tồn tại không
            if (currentCourse == null) {
                request.setAttribute("error", "Không tìm thấy khóa học với ID: " + courseId);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi khi tải thông tin khóa học: " + e.getMessage());
        }
    }
%>


<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>PetTech Admin Dashboard</title>
        <!-- CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
        <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/jquery.dataTables.min.css"/>
        <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet">

        <!-- JS -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script> <!-- ĐÃ THÊM -->
        <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
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
        </style>
        <!-- Thêm phần script để xử lý AJAX -->
        <script>
            $(document).ready(function () {
                $('#courseTable').DataTable({
                    dom: 'Bfrtip',
                    buttons: [
                        'copy', 'csv', 'excel', 'pdf', 'print'
                    ],
                    columnDefs: [
                        {targets: 0, type: 'num'}, // Cột ID sắp xếp số
                        {targets: 1, type: 'string'}, // Cột Tên khóa học sắp xếp chuỗi
                        {targets: 2, type: 'string'}, // Cột Giảng viên sắp xếp chuỗi
                        {targets: 3, type: 'string'}, // Cột Danh mục sắp xếp chuỗi
                        {targets: 4, type: 'string'}, // Cột Thời lượng sắp xếp chuỗi
                        {targets: [6], orderable: false} // Tắt sắp xếp cho cột hành động
                    ],
                    language: {
                        url: '${pageContext.request.contextPath}/assets/datatables/vi.json'
                    },
                    initComplete: function () {
                        // Thêm ô tìm kiếm cho từng cột
                        this.api().columns().every(function () {
                            var column = this;
                            var header = $(column.header());

                            // Chỉ thêm search cho các cột không phải hành động
                            if (header.index() !== 6) {
                                var input = $('<input type="text" class="column-search form-control form-control-sm" placeholder="Tìm..."/>')
                                        .appendTo(header)
                                        .on('keyup change', function () {
                                            if (column.search() !== this.value) {
                                                column.search(this.value).draw();
                                            }
                                        });

                                // Thêm icon sort cho header
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

                // Style cho phần search
                $('.dataTables_filter input').addClass('form-control form-control-sm');
            });
            // Function to edit module
            function editModule(moduleId, title, description) {
                document.getElementById('editModuleId').value = moduleId;
                document.getElementById('editModuleTitle').value = title;
                document.getElementById('editModuleDescription').value = description;
                var editModal = new bootstrap.Modal(document.getElementById('editModuleModal'));
                editModal.show();
            }

            // Function to delete module
            function deleteModule(moduleId) {
                if (confirm('Bạn có chắc chắn muốn xóa module này? Tất cả bài học trong module cũng sẽ bị xóa.')) {
                    window.location.href = 'courseadmin?action=deleteModule&id=' + moduleId;
                }
            }

            // Function to edit lesson
            function editLesson(lessonId, title, content, videoUrl) {
                document.getElementById('editLessonId').value = lessonId;
                document.getElementById('editLessonTitle').value = title;
                document.getElementById('editLessonContent').value = content;
                document.getElementById('editLessonVideoUrl').value = videoUrl || '';
                var editModal = new bootstrap.Modal(document.getElementById('editLessonModal'));
                editModal.show();
            }

            // Function to delete lesson
            function deleteLesson(lessonId) {
                if (confirm('Bạn có chắc chắn muốn xóa bài học này?')) {
                    window.location.href = 'courseadmin?action=deleteLesson&id=' + lessonId;
                }
            }
            function deleteCourse(id) {
                if (confirm("Bạn có chắc muốn xóa khóa học này không?")) {
                    window.location.href = 'courseadmin?action=delete&id=' + id;
                }
            }

            function toggleCourseStatus(id) {
                window.location.href = 'courseadmin?action=toggleStatus&id=' + id;
            }
            // Initialize Select2
            $(document).ready(function () {
                $('.form-select').select2({
                    minimumResultsForSearch: Infinity
                });
            });
            // Xử lý khi click nút chỉnh sửa danh mục
            function openEditCategoryModal(id, name) {
                document.getElementById('editCategoryId').value = id;
                document.getElementById('editCategoryName').value = name;

                // Cập nhật action cho form
                document.getElementById('editCategoryForm').action =
                        '${pageContext.request.contextPath}/courseadmin?action=updateCategory';

                // Mở modal
                var modal = new bootstrap.Modal(document.getElementById('editCategoryModal'));
                modal.show();
            }
        </script>
    </head>
    <body>
        <div class="container-fluid">
            <div class="row">
                <!-- Sidebar -->
                <%@include file="sidebar.jsp" %>
                <!-- Main Content -->
                <div class="col-md-10 p-4">
                    <div class="tab-content">
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
                        <!-- Courses Tab -->

                        <h2 class="mb-4">Quản lý Khóa học</h2>

                        <!-- Filter Section -->
                        <div class="filter-section mb-4">
                            <div class="row">
                                <div class="col-md-8">
                                    <div class="d-flex gap-2">
                                        <a href="${pageContext.request.contextPath}/courseadmin?action=add" class="btn btn-primary">
                                            <i class="bi bi-plus-circle me-1"></i> Thêm khóa học
                                        </a>


                                        <!-- Nút thêm danh mục -->
                                        <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addCategoryModal">
                                            <i class="bi bi-tags me-1"></i> Quản lý Danh mục
                                        </button>
                                    </div>
                                </div>


                            </div>
                        </div>

                        <!-- Course List -->
                        <div class="card mb-4">
                            <div class="card-header">
                                <h4>Danh sách Khóa học</h4>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table id="courseTable" class="table table-hover table-striped">
                                        <thead class="table-light">
                                            <tr>
                                                <th width="5%">ID</th>
                                                <th width="27%">Tên khóa học</th>
                                                <th width="15%">Giảng viên</th>
                                                <th width="18%">Danh mục</th>
                                                <th width="12%">Thời lượng</th>
                                                <th width="10%">Trạng thái</th>
                                                <th width="20%">Hành động</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${courses}" var="course">
                                                <tr>
                                                    <td>${course.id}</td>
                                                    <td>
                                                        <a href="courseadmin?action=update&id=${course.id}" class="text-primary fw-bold">
                                                            ${course.title}
                                                        </a>
                                                    </td>
                                                    <td>${course.researcher}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty course.categories}">
                                                                <c:forEach items="${course.categories}" var="cat" varStatus="status">
                                                                    ${cat.name}<c:if test="${!status.last}">, </c:if>
                                                                </c:forEach>
                                                            </c:when>
                                                            <c:otherwise>
                                                                Chưa phân loại
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>

                                                    <td>${course.duration}</td>

                                                    <td>
                                                        <span class="badge ${course.status == 1 ? 'bg-success' : 'bg-secondary'}">
                                                            ${course.status == 1 ? 'Active' : 'Inactive'}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <div class="d-flex">
                                                            <a href="courseadmin?action=update&id=${course.id}" 
                                                               class="btn btn-sm btn-outline-primary me-1" title="Sửa">
                                                                <i class="bi bi-pencil"></i>
                                                            </a>
                                                            <button onclick="deleteCourse(${course.id})" 
                                                                    class="btn btn-sm btn-outline-danger me-1" title="Xóa">
                                                                <i class="bi bi-trash"></i>
                                                            </button>
                                                            <button onclick="toggleCourseStatus(${course.id})" 
                                                                    class="btn btn-sm ${course.status == 1 ? 'btn-outline-warning' : 'btn-outline-success'}"
                                                                    title="${course.status == 1 ? 'Ẩn khóa học' : 'Hiện khóa học'}">
                                                                <i class="bi ${course.status == 1 ? 'bi-eye-slash' : 'bi-eye'}"></i>
                                                            </button>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>

                        <!-- Modal Thêm Danh mục -->
                        <div class="modal fade" id="categoryManagementModal" tabindex="-1" aria-hidden="true">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title">Quản lý Danh mục</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <!-- Form thêm danh mục mới -->
                                        <form action="courseadmin" method="POST" class="mb-4">
                                            <input type="hidden" name="action" value="addCategory">
                                            <div class="input-group">
                                                <input type="text" name="categoryName" class="form-control" 
                                                       placeholder="Nhập tên danh mục mới" required>
                                                <button type="submit" class="btn btn-primary">Thêm</button>
                                            </div>
                                        </form>

                                        <!-- Danh sách danh mục hiện có -->
                                        <div class="list-group">
                                            <c:forEach items="${categories}" var="category">
                                                <div class="list-group-item d-flex justify-content-between align-items-center">
                                                    <span>${category.name}</span>
                                                    <div>
                                                        <button class="btn btn-sm btn-outline-primary" 
                                                                onclick="openEditCategoryModal(${category.id}, '${fn:escapeXml(category.name)}')">
                                                            <i class="bi bi-pencil"></i>
                                                        </button>
                                                        <a href="courseadmin?action=deleteCategory&id=${category.id}" 
                                                           class="btn btn-sm btn-outline-danger"
                                                           onclick="return confirm('Bạn có chắc muốn xóa danh mục này?')">
                                                            <i class="bi bi-trash"></i>
                                                        </a>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Modal Chỉnh sửa Danh mục -->
                        <div class="modal fade" id="editCategoryModal" tabindex="-1" aria-hidden="true">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <form id="editCategoryForm" method="POST">
                                        <input type="hidden" name="action" value="updateCategory">
                                        <input type="hidden" name="categoryId" id="editCategoryId">
                                        <div class="modal-header">
                                            <h5 class="modal-title">Chỉnh sửa Danh mục</h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                        </div>
                                        <div class="modal-body">
                                            <div class="mb-3">
                                                <label class="form-label">Tên danh mục</label>
                                                <input type="text" name="categoryName" id="editCategoryName" 
                                                       class="form-control" required>
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

                        <!-- THÊM PHẦN NÀY ĐỂ HIỂN THỊ VÀ QUẢN LÝ MODULE/LESSON -->
                        <!-- Modules Section -->
                        <div class="card mb-4">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <h4>Modules</h4>
                                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addModuleModal">
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
                                                                    <button class="btn btn-sm btn-outline-primary" 
                                                                            onclick="editModule(${module.id}, '${fn:escapeXml(module.title)}', '${fn:escapeXml(module.description)}')">
                                                                        <i class="bi bi-pencil"></i> Sửa
                                                                    </button>
                                                                    <button class="btn btn-sm btn-outline-danger" 
                                                                            onclick="deleteModule(${module.id})">
                                                                        <i class="bi bi-trash"></i> Xóa
                                                                    </button>
                                                                </div>
                                                            </div>

                                                            <!-- Lessons List -->
                                                            <div class="module-lesson mt-3">
                                                                <h5 class="d-flex justify-content-between align-items-center">
                                                                    <span>Bài học</span>
                                                                    <button class="btn btn-sm btn-primary" 
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
                                                                                            <button class="btn btn-sm btn-outline-primary"
                                                                                                    onclick="editLesson(${lesson.id}, '${fn:escapeXml(lesson.title)}', '${fn:escapeXml(lesson.content)}', '${not empty lesson.videoUrl ? fn:escapeXml(lesson.videoUrl) : ''}')">
                                                                                                <i class="bi bi-pencil"></i>
                                                                                            </button>
                                                                                            <button class="btn btn-sm btn-outline-danger"
                                                                                                    onclick="deleteLesson(${lesson.id})">
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


                        <!-- KẾT THÚC PHẦN MODULE/LESSON -->

                    </div>
                </div>
            </div>

            <!-- Add Module Modal -->
            <div class="modal fade" id="addModuleModal" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <form action="${pageContext.request.contextPath}/courseadmin?action=addModule" method="POST">
                            <input type="hidden" name="courseId" value="${not empty course ? course.id : ''}">
                            <div class="modal-header">
                                <h5 class="modal-title">Thêm Module mới</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <div class="mb-3">
                                    <label class="form-label">Tên Module*</label>
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
                        <form action="${pageContext.request.contextPath}/courseadmin?action=updateModule" method="POST">
                            <input type="hidden" name="courseId" value="${not empty course ? course.id : ''}">
                            <input type="hidden" name="moduleId" id="editModuleId">
                            <div class="modal-header">
                                <h5 class="modal-title">Chỉnh sửa Module</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <div class="mb-3">
                                    <label class="form-label">Tên Module*</label>
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
                                <form action="${pageContext.request.contextPath}/courseadmin?action=addLesson" method="POST">
                                    <input type="hidden" name="moduleId" value="${module.id}">
                                    <div class="modal-header">
                                        <h5 class="modal-title">Thêm bài học mới</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <div class="mb-3">
                                            <label class="form-label">Tên bài học*</label>
                                            <input type="text" name="title" class="form-control" required>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Nội dung*</label>
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

            <!-- Edit Lesson Modal (dynamic) -->
            <div class="modal fade" id="editLessonModal" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <form action="${pageContext.request.contextPath}/courseadmin?action=updateLesson" method="POST">
                            <input type="hidden" name="lessonId" id="editLessonId">
                            <div class="modal-header">
                                <h5 class="modal-title">Chỉnh sửa bài học</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <div class="mb-3">
                                    <label class="form-label">Tên bài học*</label>
                                    <input type="text" name="title" id="editLessonTitle" class="form-control" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Nội dung*</label>
                                    <textarea name="content" id="editLessonContent" class="form-control" rows="5" required></textarea>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Video URL (nếu có)</label>
                                    <input type="url" name="videoUrl" id="editLessonVideoUrl" class="form-control">
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
        </div>
        <!-- Scripts -->


    </body>
</html>
