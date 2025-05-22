USE PetTech;
GO

-- 1. Bảng gói dịch vụ
CREATE TABLE service_packages (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(50),
    description NVARCHAR(MAX),
    price DECIMAL(10, 0),
    type NVARCHAR(20) UNIQUE CHECK (type IN (N'free', N'standard', N'pro'))
);

-- 2. Bảng người dùng
CREATE TABLE users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    email NVARCHAR(100) UNIQUE NOT NULL,
    password NVARCHAR(255) NOT NULL,
    phone NVARCHAR(20),
    address NVARCHAR(MAX),
    role NVARCHAR(20) CHECK (role IN (N'customer', N'partner', N'admin')) DEFAULT N'customer',
    service_package_id INT,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (service_package_id) REFERENCES service_packages(id)
);

-- 3. Lịch sử đăng ký gói dịch vụ
CREATE TABLE user_packages (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT,
    service_package_id INT,
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (service_package_id) REFERENCES service_packages(id)
);

-- 4. Bảng khóa học
CREATE TABLE courses (
    id INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(255),
    content NVARCHAR(MAX),
    post_date DATE,
    researcher NVARCHAR(100),
    image_url NVARCHAR(MAX),
    video_url NVARCHAR(MAX)
);

-- 5. Phân loại khóa học
CREATE TABLE course_categories (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100)
);

CREATE TABLE course_category_items (
    id INT IDENTITY(1,1) PRIMARY KEY,
    category_id INT,
    label NVARCHAR(100),
    FOREIGN KEY (category_id) REFERENCES course_categories(id)
);

CREATE TABLE course_category_course (
    id INT IDENTITY(1,1) PRIMARY KEY,
    course_id INT,
    category_item_id INT,
    FOREIGN KEY (course_id) REFERENCES courses(id),
    FOREIGN KEY (category_item_id) REFERENCES course_category_items(id)
);

-- 6. Quyền truy cập khóa học theo gói dịch vụ
CREATE TABLE course_access (
    id INT IDENTITY(1,1) PRIMARY KEY,
    course_id INT,
    service_package_id INT,
    FOREIGN KEY (course_id) REFERENCES courses(id),
    FOREIGN KEY (service_package_id) REFERENCES service_packages(id)
);

-- 7. Sản phẩm
CREATE TABLE products (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255),
    description NVARCHAR(MAX),
    price DECIMAL(12, 0),
    stock INT,
    partner_id INT,
    image_url NVARCHAR(MAX),
    FOREIGN KEY (partner_id) REFERENCES users(id)
);

-- 8. Đơn hàng
CREATE TABLE orders (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT,
    order_date DATETIME DEFAULT GETDATE(),
    total_amount DECIMAL(12, 0),
    commission DECIMAL(12, 0),
    status NVARCHAR(20) CHECK (status IN (N'pending', N'processing', N'completed', N'cancelled')),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 9. Chi tiết đơn hàng
CREATE TABLE order_items (
    id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(12, 0),
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- 10. Thanh toán
CREATE TABLE payments (
    id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT,
    payment_date DATETIME DEFAULT GETDATE(),
    method NVARCHAR(50),
    amount DECIMAL(12, 0),
    FOREIGN KEY (order_id) REFERENCES orders(id)
);

-- 11. Danh mục sản phẩm
CREATE TABLE product_categories (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL
);

-- 12. Liên kết sản phẩm - danh mục
CREATE TABLE product_category_items (
    id INT IDENTITY(1,1) PRIMARY KEY,
    product_id INT NOT NULL,
    category_id INT NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (category_id) REFERENCES product_categories(id)
);
-- Goi dich vu
INSERT INTO service_packages (name, description, price, type)
VALUES 
(N'GÓI MIỄN PHÍ', N'Truy cập cơ bản và diễn đàn cộng đồng', 0, N'free'),
(N'GÓI TIÊU CHUẨN', N'Bao gồm video, bài viết nâng cao và tư vấn định kỳ', 99000, N'standard'),
(N'GÓI CHUYÊN NGHIỆP', N'Toàn quyền truy cập nội dung + ưu đãi đối tác', 199000, N'pro');

-- Nguoi dung
INSERT INTO users (email, password, phone, address, role, service_package_id)
VALUES 
('alice@gmail.com', 'hashed_password_1', '0901234567', N'Hà Nội', 'customer', 1),
('bob@gmail.com', 'hashed_password_2', '0934567890', 'NTP HCM', 'customer', 2),
('partner1@shop.vn', 'hashed_password_3', '0912345678', N'Đà Nẵng', 'partner', NULL),
('admin@pettech.vn', 'hashed_admin_pw', NULL, NULL, 'admin', NULL);

-- Khoa hoc
INSERT INTO courses (title, content, post_date, researcher, image_url, video_url)
VALUES 
(N'Chăm sóc chó con', N'Hướng dẫn từ A-Z cách nuôi chó con', GETDATE(), N'Dr. Trí Nguyễn', NULL, NULL),
(N'Dinh dưỡng cho mèo trưởng thành', N'Lựa chọn thực phẩm phù hợp', GETDATE(), N'Dr. Lệ Hằng', NULL, NULL),
(N'Sơ cứu thú cưng tại nhà', N'Các tình huống thường gặp và cách xử lý', GETDATE(), N'Dr. Dũng Phạm', NULL, NULL);

-- san pham
INSERT INTO products (name, description, price, stock, partner_id, image_url)
VALUES 
(N'Thức ăn cho chó vị gà 5kg', N'Dành cho chó từ 2 tháng tuổi', 350000, 100, 3, NULL),
(N'Cát vệ sinh cho mèo', N'Thấm hút tốt, khử mùi tự nhiên', 120000, 200, 3, NULL),
(N'Sữa tắm thú cưng', N'Chống rụng lông và làm mượt lông', 85000, 150, 3, NULL);

-- don hang + chi tiet
INSERT INTO orders (user_id, order_date, total_amount, commission, status)
VALUES (1, GETDATE(), 350000, 10500, 'pending');

INSERT INTO order_items (order_id, product_id, quantity, price)
VALUES (1, 1, 1, 350000);

-- Thanh toan
INSERT INTO payments (order_id, payment_date, method, amount)
VALUES (1, GETDATE(), 'VNPay', 350000);

-- THEM DU LIEU VAO DANH MUC SAN PHAM
INSERT INTO product_categories (name)
VALUES 
(N'Thức ăn'),
(N'Phụ kiện'),
(N'Ve sinh'),
(N'Thời trang');

-- Liên kết sản phẩm với danh mục
-- Ví dụ: sản phẩm 1 là Thức ăn cho chó → liên kết với danh mục 1 (Thức ăn)
INSERT INTO product_category_items (product_id, category_id)
VALUES 
(1, 1), -- Thức ăn cho chó
(2, 3), -- Cát vệ sinh cho mèo
(3, 3); -- Sữa tắm thú cưng