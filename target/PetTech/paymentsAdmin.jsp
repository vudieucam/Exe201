<%-- 
    Document   : paymentsAdmin
    Created on : May 31, 2025, 6:28:44 PM
    Author     : FPT
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<fmt:setLocale value="vi_VN" />


<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <link rel="icon" type="image/png" href="images/logo_pettech.jpg">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản Lý Thanh Toán - PetShop Admin</title>
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

                <!-- MAIN CONTENT -->
                <!-- Main Content -->
                <div class="col-md-10 p-4">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2>Quản Lý Thanh Toán</h2>
                    </div>
                    <!-- Thông báo -->
                    <c:if test="${not empty success}">
                        <div class="alert alert-success">${success}</div>
                    </c:if>
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">${error}</div>
                    </c:if>

                    <!-- Bộ lọc đơn giản -->
                    <div class="row g-3 mb-3">
                        <div class="col-md-3">
                            <label class="form-label">Trạng thái</label>
                            <select class="form-select" id="payment-status-filter">
                                <option value="all">Tất cả</option>
                                <c:forEach var="p" items="${pendingPayments}">
                                    <c:if test="${not empty p.status}">
                                        <c:if test="${not fn:contains(statusOptions, p.status)}">
                                            <c:set var="statusOptions" value="${statusOptions}${p.status}," scope="request"/>
                                            <option value="${p.status}">${p.status}</option>
                                        </c:if>
                                    </c:if>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-3">
                            <label class="form-label">Phương thức</label>
                            <select class="form-select" id="payment-method-filter">
                                <option value="all">Tất cả</option>
                                <c:forEach var="p" items="${pendingPayments}">
                                    <c:if test="${not empty p.paymentMethod}">
                                        <c:if test="${not fn:contains(methodOptions, p.paymentMethod)}">
                                            <c:set var="methodOptions" value="${methodOptions}${p.paymentMethod}," scope="request"/>
                                            <option value="${p.paymentMethod}">${p.paymentMethod}</option>
                                        </c:if>
                                    </c:if>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-3">
                            <label class="form-label">Tìm kiếm</label>
                            <div class="input-group">
                                <input type="text" class="form-control" id="payment-search" placeholder="Mã thanh toán...">
                                <button class="btn btn-primary" type="button" id="search-btn">
                                    <i class="bi bi-search"></i>
                                </button>
                            </div>
                        </div>
                    </div>


                    <!-- Bảng thanh toán -->
                    <div class="card">
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-hover" id="payments-table">
                                    <thead>
                                        <tr>
                                            <th>#</th>
                                            <th>Mã thanh toán</th>
                                            <th>User ID</th>
                                            <th>Gói</th>
                                            <th>Số tiền</th>
                                            <th>Phương thức</th>
                                            <th>Ngày thanh toán</th>
                                            <th>Trạng thái</th>
                                            <th>Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="p" items="${payments}" varStatus="st">
                                            <tr>
                                                <td>${st.index + 1}</td>
                                                <td>${p.id}</td>           <!-- Mã thanh toán -->
                                                <td>
                                                    <a href="userdetail?uid=${p.userId}" class="text-decoration-none text-primary">
                                                        ${p.userId}
                                                    </a>
                                                </td>

                                                <td>${p.servicePackageId}</td>

                                                <!-- Số tiền -->
                                                <td><fmt:formatNumber value="${p.amount}" pattern="#,##0 '₫'"/></td>

                                                <td>${p.paymentMethod}</td>
                                                <td><fmt:formatDate value="${p.paymentDate}" pattern="dd/MM/yyyy HH:mm"/></td>

                                                <!-- Badge trạng thái -->
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${p.status == 'waiting_admin_confirm'}">
                                                            <span class="status-badge status-warning">Chờ&nbsp;duyệt</span>
                                                        </c:when>
                                                        <c:when test="${p.status == 'completed'}">
                                                            <span class="status-badge status-active">Hoàn&nbsp;tất</span>
                                                        </c:when>
                                                        <c:when test="${p.status == 'failed'}">
                                                            <span class="status-badge status-inactive">Thất&nbsp;bại</span>
                                                        </c:when>
                                                        <c:when test="${p.status == 'refunded'}">
                                                            <span class="status-badge status-warning">Hoàn&nbsp;tiền</span>
                                                        </c:when>
                                                        <c:when test="${p.status == 'pending'}">
                                                            <span class="status-badge status-secondary">Khách&nbsp;chưa&nbsp;xác&nbsp;nhận</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="status-badge status-secondary">${p.status}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>


                                                <!-- Hành động -->
                                                <td>
                                                    <!-- =========== CHỜ DUYỆT =========== -->
                                                    <c:if test="${p.status == 'waiting_admin_confirm'}">
                                                        <!-- Duyệt -->
                                                        <form action="paymentadmin" method="post" class="d-inline">
                                                            <input type="hidden" name="action" value="approve"/>
                                                            <input type="hidden" name="paymentId" value="${p.id}"/>
                                                            <button type="submit" class="btn btn-sm btn-success"
                                                                    onclick="return confirm('Duyệt giao dịch #${p.id}?');">
                                                                ✅ Duyệt
                                                            </button>
                                                        </form>

                                                        <!-- Huỷ -->
                                                        <button class="btn btn-sm btn-danger"
                                                                onclick="openReason('reject', ${p.id})">
                                                            ❌ Huỷ
                                                        </button>
                                                    </c:if>

                                                    <!-- =========== HOÀN TIỀN (chỉ khi completed) =========== -->
                                                    <c:if test="${p.status == 'completed'}">
                                                        <button class="btn btn-sm btn-warning"
                                                                onclick="openReason('refund', ${p.id})">
                                                            💸 Hoàn&nbsp;tiền
                                                        </button>
                                                    </c:if>

                                                    <!-- Các trạng thái khác → không thao tác -->
                                                    <c:if test="${p.status != 'waiting_admin_confirm' && p.status != 'completed'}">—</c:if>
                                                    </td>
                                                </tr>
                                        </c:forEach>
                                    </tbody>

                                </table>
                            </div>
                        </div>
                        <!-- Modal nhập lý do Reject / Refund -->
                        <div class="modal fade" id="reasonModal" tabindex="-1">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <form action="paymentadmin" method="post">
                                        <input type="hidden" name="action" id="modal-action">
                                        <input type="hidden" name="paymentId" id="modal-id">
                                        <div class="modal-header">
                                            <h5 class="modal-title" id="modal-title">Lý do</h5>
                                        </div>
                                        <div class="modal-body">
                                            <textarea name="reason" class="form-control" rows="3" required
                                                      placeholder="Nhập lý do..."></textarea>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Đóng</button>
                                            <button type="submit" class="btn btn-primary">Xác&nbsp;nhận</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                                                    // Lọc bảng thanh toán theo trạng thái / phương thức / mã
                                                                    document.getElementById('search-btn').addEventListener('click', filterTable);
                                                                    document.getElementById('payment-status-filter').addEventListener('change', filterTable);
                                                                    document.getElementById('payment-method-filter').addEventListener('change', filterTable);

                                                                    function filterTable() {
                                                                        const search = document.getElementById('payment-search').value.toLowerCase();
                                                                        const statusFilter = document.getElementById('payment-status-filter').value.toLowerCase();
                                                                        const methodFilter = document.getElementById('payment-method-filter').value.toLowerCase();

                                                                        document.querySelectorAll('#payments-table tbody tr').forEach(row => {
                                                                            const code = row.children[1].innerText.toLowerCase(); // mã thanh toán
                                                                            const rowMethod = row.children[5].innerText.toLowerCase(); // phương thức
                                                                            const badge = row.children[7].querySelector('.badge'); // badge status
                                                                            const rowStatus = badge ? badge.innerText.toLowerCase() : '';

                                                                            const matchSearch = code.includes(search);
                                                                            const matchStatus = statusFilter === 'all' || rowStatus.includes(statusFilter);
                                                                            const matchMethod = methodFilter === 'all' || rowMethod === methodFilter;

                                                                            row.style.display = (matchSearch && matchStatus && matchMethod) ? '' : 'none';
                                                                        });
                                                                    }
        </script>

    </body>
</html>