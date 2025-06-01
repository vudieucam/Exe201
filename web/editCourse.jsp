<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page import="model.Course"%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chỉnh sửa khóa học - PetTech Admin</title>
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

            .form-control, .form-select {
                border-radius: 8px;
                padding: 10px 15px;
                border: 1px solid #ced4da;
            }

            .form-control:focus, .form-select:focus {
                border-color: var(--primary-color);
                box-shadow: 0 0 0 0.25rem rgba(67, 97, 238, 0.25);
            }

            .btn-primary {
                background-color: var(--primary-color);
                border-color: var(--primary-color);
                padding: 10px 20px;
                border-radius: 8px;
            }

            .btn-primary:hover {
                background-color: var(--secondary-color);
                border-color: var(--secondary-color);
            }

            .btn-secondary {
                border-radius: 8px;
                padding: 10px 20px;
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

            .admin-profile {
                margin-top: auto;
                padding: 15px;
                border-top: 1px solid rgba(255, 255, 255, 0.1);
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

            .edit-course-container {
                background-color: white;
                border-radius: 15px;
                padding: 25px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            }

            .course-thumbnail-preview {
                width: 100%;
                height: 200px;
                object-fit: cover;
                border-radius: 10px;
                margin-bottom: 15px;
                border: 1px dashed #ddd;
            }

            .action-buttons {
                display: flex;
                justify-content: space-between;
                margin-top: 20px;
            }

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
                            <a class="nav-link" href="Admin.jsp">
                                <i class="bi bi-speedometer2"></i>Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="userAdmin.jsp">
                                <i class="bi bi-people"></i>Người dùng
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="courseAdmin.jsp">
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
                        <h2><i class="bi bi-pencil-square me-2"></i> Chỉnh sửa khóa học</h2>
                        <a href="${pageContext.request.contextPath}/courseadmin?action=list" class="btn btn-outline-secondary">
                            <i class="bi bi-arrow-left me-1"></i> Quay lại
                        </a>
                    </div>

                    <div class="edit-course-container">
                        <form action="${pageContext.request.contextPath}/courseadmin?action=update" method="POST" enctype="multipart/form-data">
                            <input type="hidden" name="id" value="${course.id}">

                            <!-- Course Thumbnail Preview -->
                            <div class="text-center mb-4">
                                <img id="thumbnailPreview" src="${course.imageUrl}" alt="Course Thumbnail" class="course-thumbnail-preview">
                            </div>

                            <div class="row mb-3">
                                <div class="col-md-8">
                                    <label for="courseName" class="form-label">Tên khóa học</label>
                                    <input type="text" class="form-control" id="courseName" name="title" value="${course.title}" required>
                                </div>
                                <div class="col-md-4">
                                    <label for="courseThumbnail" class="form-label">Thay đổi ảnh đại diện</label>
                                    <input class="form-control" type="file" id="courseThumbnail" name="thumbnail" accept="image/*" onchange="previewThumbnail(this)">
                                </div>
                            </div>

                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="courseInstructor" class="form-label">Giảng viên</label>
                                    <input type="text" class="form-control" id="courseInstructor" name="researcher" value="${course.researcher}" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="courseTime" class="form-label">Thời lượng</label>
                                    <input type="text" class="form-control" id="courseTime" name="time" value="${course.time}" required>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="courseDescription" class="form-label">Nội dung khóa học</label>
                                <textarea class="form-control" id="courseDescription" name="content" rows="8" required>${course.content}</textarea>
                            </div>

                            <div class="row mb-4">
                                <div class="col-md-6">
                                    <label for="courseStatus" class="form-label">Trạng thái</label>
                                    <select class="form-select" id="courseStatus" name="status" required>
                                        <option value="1" ${course.status == 1 ? 'selected' : ''}>Đang hoạt động</option>
                                        <option value="0" ${course.status == 0 ? 'selected' : ''}>Đã ẩn</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Ngày đăng</label>
                                    <input type="text" class="form-control" value="${course.postDate}" readonly>
                                </div>
                            </div>

                            <div class="action-buttons">
                                <button type="button" class="btn btn-outline-danger" onclick="confirmDelete(${course.id})">
                                    <i class="bi bi-trash me-1"></i> Xóa khóa học
                                </button>
                                <div>
                                    <a href="${pageContext.request.contextPath}/courseadmin?action=list" class="btn btn-secondary me-2">
                                        <i class="bi bi-x-circle me-1"></i> Hủy bỏ
                                    </a>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="bi bi-save me-1"></i> Lưu thay đổi
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                    <!-- Modal thêm module -->
                    <div class="modal fade" id="addModuleModal" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <form action="${pageContext.request.contextPath}/courseadmin?action=addModule" method="POST">
                                    <input type="hidden" name="courseId" value="${course.id}">
                                    <div class="modal-header">
                                        <h5 class="modal-title">Thêm Module mới</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <div class="mb-3">
                                            <label for="moduleTitle" class="form-label">Tên module</label>
                                            <input type="text" class="form-control" id="moduleTitle" name="title" required>
                                        </div>
                                        <div class="mb-3">
                                            <label for="moduleDescription" class="form-label">Mô tả</label>
                                            <textarea class="form-control" id="moduleDescription" name="description" rows="3"></textarea>
                                        </div>
                                        <div class="mb-3">
                                            <label for="moduleOrder" class="form-label">Thứ tự</label>
                                            <input type="number" class="form-control" id="moduleOrder" name="orderIndex" min="1" required>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                        <button type="submit" class="btn btn-primary">Lưu module</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- Modal thêm bài học -->
                    <div class="modal fade" id="addLessonModal" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <form action="${pageContext.request.contextPath}/courseadmin?action=addLesson" method="POST">
                                    <input type="hidden" name="moduleId" id="lessonModuleId" value="">
                                    <div class="modal-header">
                                        <h5 class="modal-title">Thêm bài học mới</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <div class="mb-3">
                                            <label for="lessonTitle" class="form-label">Tên bài học</label>
                                            <input type="text" class="form-control" id="lessonTitle" name="title" required>
                                        </div>
                                        <div class="mb-3">
                                            <label for="lessonContent" class="form-label">Nội dung</label>
                                            <textarea class="form-control" id="lessonContent" name="content" rows="5"></textarea>
                                        </div>
                                        <div class="mb-3">
                                            <label for="lessonVideo" class="form-label">URL video</label>
                                            <input type="url" class="form-control" id="lessonVideo" name="videoUrl">
                                        </div>
                                        <div class="mb-3">
                                            <label for="lessonDuration" class="form-label">Thời lượng (phút)</label>
                                            <input type="number" class="form-control" id="lessonDuration" name="duration" min="1" required>
                                        </div>
                                        <div class="mb-3">
                                            <label for="lessonOrder" class="form-label">Thứ tự</label>
                                            <input type="number" class="form-control" id="lessonOrder" name="orderIndex" min="1" required>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                        <button type="submit" class="btn btn-primary">Lưu bài học</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>


                </div>
            </div>
        </div>

        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                    function previewThumbnail(input) {
                                        if (input.files && input.files[0]) {
                                            const reader = new FileReader();
                                            reader.onload = function (e) {
                                                document.getElementById('thumbnailPreview').src = e.target.result;
                                            };
                                            reader.readAsDataURL(input.files[0]);
                                        }
                                    }

                                    function confirmDelete(courseId) {
                                        if (confirm('Bạn có chắc chắn muốn xóa khóa học này?')) {
                                            window.location.href = '${pageContext.request.contextPath}/courseadmin?action=delete&id=' + courseId;
                                        }
                                    }

                                    // Set moduleId khi click nút thêm bài học
                                    function setModuleForLesson(moduleId) {
                                        document.getElementById('lessonModuleId').value = moduleId;
                                    }

        </script>
    </body>
</html>