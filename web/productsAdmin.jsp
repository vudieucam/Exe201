<%-- 
    Document   : productsAdmin
    Created on : May 31, 2025, 6:28:44 PM
    Author     : FPT
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản Lý Sản Phẩm - PetShop Admin</title>
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
                border-radius: 10px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            }

            .table-responsive {
                border-radius: 10px;
                overflow: hidden;
            }

            .table th {
                background-color: var(--light-color);
                border-top: none;
                font-weight: 600;
                color: var(--dark-color);
            }

            .table td {
                vertical-align: middle;
            }

            .badge {
                padding: 6px 10px;
                font-weight: 500;
                border-radius: 8px;
            }

            .user-avatar {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                object-fit: cover;
                margin-right: 10px;
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

            .action-btn {
                width: 30px;
                height: 30px;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                border-radius: 8px;
                margin: 0 3px;
            }
        </style>
    </head>
    <body>
        <div class="container-fluid">
            <div class="row">
                <!-- Sidebar -->
                <div class="col-md-2 sidebar p-0">
                    <div class="sidebar-brand">
                        <img src="images/logo_petshop.jpg" alt="Logo">
                        <h4 class="mb-0">PetShop</h4>
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
                            <a class="nav-link" href="courseAdmin.jsp">
                                <i class="bi bi-book"></i>Khóa học
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="productsAdmin.jsp">
                                <i class="bi bi-cart"></i>Sản phẩm
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="ordersAdmin.jsp">
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
                </div>

                <!-- Main Content -->
                <div class="col-md-10 p-4">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2>Quản Lý Sản Phẩm</h2>
                        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addProductModal">
                            <i class="bi bi-plus-lg me-1"></i> Thêm sản phẩm
                        </button>
                    </div>

                    <!-- Filter Section -->
                    <div class="filter-section">
                        <div class="row g-3">
                            <div class="col-md-3">
                                <label class="form-label filter-title">Danh mục</label>
                                <select class="form-select" id="categoryFilter">
                                    <option value="">Tất cả danh mục</option>
                                    <option value="food">Thức ăn</option>
                                    <option value="toy">Đồ chơi</option>
                                    <option value="accessory">Phụ kiện</option>
                                    <option value="health">Sức khỏe</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label filter-title">Trạng thái</label>
                                <select class="form-select" id="statusFilter">
                                    <option value="">Tất cả trạng thái</option>
                                    <option value="active">Đang bán</option>
                                    <option value="inactive">Ngừng bán</option>
                                    <option value="out-of-stock">Hết hàng</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label filter-title">Khoảng giá</label>
                                <select class="form-select" id="priceFilter">
                                    <option value="">Tất cả giá</option>
                                    <option value="0-100">Dưới 100k</option>
                                    <option value="100-500">100k - 500k</option>
                                    <option value="500-1000">500k - 1 triệu</option>
                                    <option value="1000+">Trên 1 triệu</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label filter-title">Tìm kiếm</label>
                                <div class="input-group">
                                    <input type="text" class="form-control" id="productSearch" placeholder="Tên sản phẩm...">
                                    <button class="btn btn-primary" type="button" id="searchBtn">
                                        <i class="bi bi-search"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Products Table -->
                    <div class="card">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <div>
                                <button class="btn btn-outline-secondary me-2">
                                    <i class="bi bi-download me-1"></i> Xuất Excel
                                </button>
                            </div>
                            <div>
                                <div class="btn-group">
                                    <button class="btn btn-sm btn-outline-secondary active">Tất cả (42)</button>
                                    <button class="btn btn-sm btn-outline-secondary">Đang bán (35)</button>
                                    <button class="btn btn-sm btn-outline-secondary">Hết hàng (5)</button>
                                    <button class="btn btn-sm btn-outline-secondary">Ngừng bán (2)</button>
                                </div>
                            </div>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover mb-0">
                                    <thead>
                                        <tr>
                                            <th style="width: 50px">#</th>
                                            <th>Sản phẩm</th>
                                            <th>Danh mục</th>
                                            <th>Giá</th>
                                            <th>Tồn kho</th>
                                            <th>Đã bán</th>
                                            <th>Trạng thái</th>
                                            <th style="width: 120px">Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td class="text-center">1</td>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <img src="https://via.placeholder.com/60/e9ecef/6c757d?text=Thức+ăn" class="product-img me-3">
                                                    <div>
                                                        <h6 class="mb-0">Thức ăn cho chó Royal Canin</h6>
                                                        <small class="text-muted">SKU: PET-FD-001</small>
                                                    </div>
                                                </div>
                                            </td>
                                            <td><span class="badge bg-primary">Thức ăn</span></td>
                                            <td>₫250,000</td>
                                            <td>45</td>
                                            <td>125</td>
                                            <td><span class="status-badge status-active">Đang bán</span></td>
                                            <td>
                                                <button class="btn btn-sm btn-outline-primary action-btn">
                                                    <i class="bi bi-eye"></i>
                                                </button>
                                                <button class="btn btn-sm btn-outline-success action-btn" data-bs-toggle="modal" data-bs-target="#editProductModal">
                                                    <i class="bi bi-pencil"></i>
                                                </button>
                                                <button class="btn btn-sm btn-outline-danger action-btn">
                                                    <i class="bi bi-trash"></i>
                                                </button>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="text-center">2</td>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <img src="https://via.placeholder.com/60/e9ecef/6c757d?text=Đồ+chơi" class="product-img me-3">
                                                    <div>
                                                        <h6 class="mb-0">Đồ chơi cho mèo</h6>
                                                        <small class="text-muted">SKU: PET-TOY-002</small>
                                                    </div>
                                                </div>
                                            </td>
                                            <td><span class="badge bg-info">Đồ chơi</span></td>
                                            <td>₫150,000</td>
                                            <td>12</td>
                                            <td>48</td>
                                            <td><span class="status-badge status-active">Đang bán</span></td>
                                            <td>
                                                <button class="btn btn-sm btn-outline-primary action-btn">
                                                    <i class="bi bi-eye"></i>
                                                </button>
                                                <button class="btn btn-sm btn-outline-success action-btn" data-bs-toggle="modal" data-bs-target="#editProductModal">
                                                    <i class="bi bi-pencil"></i>
                                                </button>
                                                <button class="btn btn-sm btn-outline-danger action-btn">
                                                    <i class="bi bi-trash"></i>
                                                </button>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="text-center">3</td>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <img src="https://via.placeholder.com/60/e9ecef/6c757d?text=Phụ+kiện" class="product-img me-3">
                                                    <div>
                                                        <h6 class="mb-0">Vòng cổ chó mèo</h6>
                                                        <small class="text-muted">SKU: PET-ACC-003</small>
                                                    </div>
                                                </div>
                                            </td>
                                            <td><span class="badge bg-warning">Phụ kiện</span></td>
                                            <td>₫120,000</td>
                                            <td>0</td>
                                            <td>15</td>
                                            <td><span class="status-badge status-inactive">Hết hàng</span></td>
                                            <td>
                                                <button class="btn btn-sm btn-outline-primary action-btn">
                                                    <i class="bi bi-eye"></i>
                                                </button>
                                                <button class="btn btn-sm btn-outline-success action-btn" data-bs-toggle="modal" data-bs-target="#editProductModal">
                                                    <i class="bi bi-pencil"></i>
                                                </button>
                                                <button class="btn btn-sm btn-outline-danger action-btn">
                                                    <i class="bi bi-trash"></i>
                                                </button>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="text-center">4</td>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <img src="https://via.placeholder.com/60/e9ecef/6c757d?text=Sức+khỏe" class="product-img me-3">
                                                    <div>
                                                        <h6 class="mb-0">Thuốc tẩy giun cho chó</h6>
                                                        <small class="text-muted">SKU: PET-HL-004</small>
                                                    </div>
                                                </div>
                                            </td>
                                            <td><span class="badge bg-success">Sức khỏe</span></td>
                                            <td>₫180,000</td>
                                            <td>25</td>
                                            <td>87</td>
                                            <td><span class="status-badge status-active">Đang bán</span></td>
                                            <td>
                                                <button class="btn btn-sm btn-outline-primary action-btn">
                                                    <i class="bi bi-eye"></i>
                                                </button>
                                                <button class="btn btn-sm btn-outline-success action-btn" data-bs-toggle="modal" data-bs-target="#editProductModal">
                                                    <i class="bi bi-pencil"></i>
                                                </button>
                                                <button class="btn btn-sm btn-outline-danger action-btn">
                                                    <i class="bi bi-trash"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>

                            <!-- Pagination -->
                            <nav class="mt-3 p-3">
                                <ul class="pagination justify-content-center mb-0">
                                    <li class="page-item disabled">
                                        <a class="page-link" href="#" tabindex="-1">
                                            <i class="bi bi-chevron-left"></i>
                                        </a>
                                    </li>
                                    <li class="page-item active"><a class="page-link" href="#">1</a></li>
                                    <li class="page-item"><a class="page-link" href="#">2</a></li>
                                    <li class="page-item"><a class="page-link" href="#">3</a></li>
                                    <li class="page-item">
                                        <a class="page-link" href="#">
                                            <i class="bi bi-chevron-right"></i>
                                        </a>
                                    </li>
                                </ul>
                            </nav>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Add Product Modal -->
        <div class="modal fade" id="addProductModal" tabindex="-1" aria-labelledby="addProductModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="addProductModalLabel">Thêm sản phẩm mới</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form>
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label for="productName" class="form-label">Tên sản phẩm</label>
                                    <input type="text" class="form-control" id="productName" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="productSKU" class="form-label">SKU</label>
                                    <input type="text" class="form-control" id="productSKU" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="productCategory" class="form-label">Danh mục</label>
                                    <select class="form-select" id="productCategory" required>
                                        <option value="">Chọn danh mục</option>
                                        <option value="food">Thức ăn</option>
                                        <option value="toy">Đồ chơi</option>
                                        <option value="accessory">Phụ kiện</option>
                                        <option value="health">Sức khỏe</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label for="productPrice" class="form-label">Giá bán (₫)</label>
                                    <input type="number" class="form-control" id="productPrice" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="productQuantity" class="form-label">Số lượng tồn kho</label>
                                    <input type="number" class="form-control" id="productQuantity" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="productStatus" class="form-label">Trạng thái</label>
                                    <select class="form-select" id="productStatus" required>
                                        <option value="active">Đang bán</option>
                                        <option value="inactive">Ngừng bán</option>
                                        <option value="draft">Bản nháp</option>
                                    </select>
                                </div>
                                <div class="col-12">
                                    <label for="productDescription" class="form-label">Mô tả sản phẩm</label>
                                    <textarea class="form-control" id="productDescription" rows="3"></textarea>
                                </div>
                                <div class="col-12">
                                    <label for="productImages" class="form-label">Hình ảnh sản phẩm</label>
                                    <input type="file" class="form-control" id="productImages" multiple>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                        <button type="button" class="btn btn-primary">Lưu sản phẩm</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Edit Product Modal -->
        <div class="modal fade" id="editProductModal" tabindex="-1" aria-labelledby="editProductModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="editProductModalLabel">Chỉnh sửa sản phẩm</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form>
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label for="editProductName" class="form-label">Tên sản phẩm</label>
                                    <input type="text" class="form-control" id="editProductName" value="Thức ăn cho chó Royal Canin" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="editProductSKU" class="form-label">SKU</label>
                                    <input type="text" class="form-control" id="editProductSKU" value="PET-FD-001" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="editProductCategory" class="form-label">Danh mục</label>
                                    <select class="form-select" id="editProductCategory" required>
                                        <option value="food" selected>Thức ăn</option>
                                        <option value="toy">Đồ chơi</option>
                                        <option value="accessory">Phụ kiện</option>
                                        <option value="health">Sức khỏe</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label for="editProductPrice" class="form-label">Giá bán (₫)</label>
                                    <input type="number" class="form-control" id="editProductPrice" value="250000" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="editProductQuantity" class="form-label">Số lượng tồn kho</label>
                                    <input type="number" class="form-control" id="editProductQuantity" value="45" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="editProductStatus" class="form-label">Trạng thái</label>
                                    <select class="form-select" id="editProductStatus" required>
                                        <option value="active" selected>Đang bán</option>
                                        <option value="inactive">Ngừng bán</option>
                                        <option value="draft">Bản nháp</option>
                                    </select>
                                </div>
                                <div class="col-12">
                                    <label for="editProductDescription" class="form-label">Mô tả sản phẩm</label>
                                    <textarea class="form-control" id="editProductDescription" rows="3">Thức ăn cao cấp cho chó mọi lứa tuổi, đầy đủ dinh dưỡng</textarea>
                                </div>
                                <div class="col-12">
                                    <label class="form-label">Hình ảnh sản phẩm</label>
                                    <div class="d-flex flex-wrap gap-2">
                                        <img src="https://via.placeholder.com/100/e9ecef/6c757d?text=Ảnh+1" width="100" height="100" class="rounded">
                                        <img src="https://via.placeholder.com/100/e9ecef/6c757d?text=Ảnh+2" width="100" height="100" class="rounded">
                                        <button class="btn btn-outline-primary align-self-center">
                                            <i class="bi bi-plus-lg"></i> Thêm ảnh
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                        <button type="button" class="btn btn-primary">Cập nhật</button>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Simple filter functionality
            document.getElementById('searchBtn').addEventListener('click', function() {
                const searchText = document.getElementById('productSearch').value.toLowerCase();
                const categoryFilter = document.getElementById('categoryFilter').value;
                const statusFilter = document.getElementById('statusFilter').value;
                const priceFilter = document.getElementById('priceFilter').value;
                
                const rows = document.querySelectorAll('tbody tr');
                
                rows.forEach(row => {
                    const name = row.querySelector('h6').textContent.toLowerCase();
                    const category = row.querySelector('td:nth-child(3) span').textContent;
                    const status = row.querySelector('td:nth-child(7) span').textContent;
                    const priceText = row.querySelector('td:nth-child(4)').textContent;
                    const price = parseInt(priceText.replace(/[^\d]/g, ''));
                    
                    const matchSearch = name.includes(searchText);
                    const matchCategory = categoryFilter === '' || 
                        (categoryFilter === 'food' && category === 'Thức ăn') ||
                        (categoryFilter === 'toy' && category === 'Đồ chơi') ||
                        (categoryFilter === 'accessory' && category === 'Phụ kiện') ||
                        (categoryFilter === 'health' && category === 'Sức khỏe');
                    const matchStatus = statusFilter === '' || 
                        (statusFilter === 'active' && status === 'Đang bán') ||
                        (statusFilter === 'inactive' && status === 'Ngừng bán') ||
                        (statusFilter === 'out-of-stock' && status === 'Hết hàng');
                    
                    let matchPrice = true;
                    if (priceFilter === '0-100') {
                        matchPrice = price < 100000;
                    } else if (priceFilter === '100-500') {
                        matchPrice = price >= 100000 && price < 500000;
                    } else if (priceFilter === '500-1000') {
                        matchPrice = price >= 500000 && price < 1000000;
                    } else if (priceFilter === '1000+') {
                        matchPrice = price >= 1000000;
                    }
                    
                    if (matchSearch && matchCategory && matchStatus && matchPrice) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                });
            });
        </script>
    </body>
</html>