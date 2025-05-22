use PetTech2
Go 
-- 1. bang goi dich vu
CREATE TABLE service_packages (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(50),
    description TEXT,
    price DECIMAL(10, 0),
    type VARCHAR(20) UNIQUE CHECK (type IN ('free', 'standard', 'pro'))
);

-- 2. bang nguoi dung
CREATE TABLE users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    role VARCHAR(20) CHECK (role IN ('customer', 'partner', 'admin')) DEFAULT 'customer',
    service_package_id INT,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (service_package_id) REFERENCES service_packages(id)
);

-- 3. lich su dang ky goi dich vu
CREATE TABLE user_packages (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT,
    service_package_id INT,
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (service_package_id) REFERENCES service_packages(id)
);

-- 4. bang khoa hc
CREATE TABLE courses (
    id INT IDENTITY(1,1) PRIMARY KEY,
    title VARCHAR(255),
    content TEXT,
    post_date DATE,
    researcher VARCHAR(100),
    image_url TEXT,
    video_url TEXT
);

-- 5. phan loai khoa hc
CREATE TABLE course_categories (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE course_category_items (
    id INT IDENTITY(1,1) PRIMARY KEY,
    category_id INT,
    label VARCHAR(100),
    FOREIGN KEY (category_id) REFERENCES course_categories(id)
);

CREATE TABLE course_category_course (
    id INT IDENTITY(1,1) PRIMARY KEY,
    course_id INT,
    category_item_id INT,
    FOREIGN KEY (course_id) REFERENCES courses(id),
    FOREIGN KEY (category_item_id) REFERENCES course_category_items(id)
);

-- 6. quyen truy cap khoa hc theo goi dich vu
CREATE TABLE course_access (
    id INT IDENTITY(1,1) PRIMARY KEY,
    course_id INT,
    service_package_id INT,
    FOREIGN KEY (course_id) REFERENCES courses(id),
    FOREIGN KEY (service_package_id) REFERENCES service_packages(id)
);

-- 7. san pham
CREATE TABLE products (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(255),
    description TEXT,
    price DECIMAL(12, 0),
    stock INT,
    partner_id INT,
    image_url TEXT
);

-- 8. don hang
CREATE TABLE orders (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT,
    order_date DATETIME DEFAULT GETDATE(),
    total_amount DECIMAL(12, 0),
    commission DECIMAL(12, 0),
    status VARCHAR(20) CHECK (status IN ('pending', 'processing', 'completed', 'cancelled')),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 9. chi tiet don hang
CREATE TABLE order_items (
    id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(12, 0),
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- 10. thanh toan
CREATE TABLE payments (
    id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT,
    payment_date DATETIME DEFAULT GETDATE(),
    method VARCHAR(50),
    amount DECIMAL(12, 0),
    FOREIGN KEY (order_id) REFERENCES orders(id)
);

-- Goi dich vu
INSERT INTO service_packages (name, description, price, type)
VALUES 
('GÓI MIỄN PHÍ', 'Truy cập cơ bản và diễn đàn cộng đồng', 0, 'free'),
('GÓI TIÊU CHUẨN', 'Bao gồm video, bài viết nâng cao và tư vấn định kỳ', 99000, 'standard'),
('GÓI CHUYÊN NGHIỆP', 'Toàn quyền truy cập nội dung + ưu đãi đối tác', 199000, 'pro');

-- Nguoi dung
INSERT INTO users (email, password, phone, address, role, service_package_id)
VALUES 
('alice@gmail.com', 'hashed_password_1', '0901234567', 'Hà Nội', 'customer', 1),
('bob@gmail.com', 'hashed_password_2', '0934567890', 'TP HCM', 'customer', 2),
('partner1@shop.vn', 'hashed_password_3', '0912345678', 'Đà Nẵng', 'partner', NULL),
('admin@pettech.vn', 'hashed_admin_pw', NULL, NULL, 'admin', NULL);

-- Khoa hoc
INSERT INTO courses (title, content, post_date, researcher, image_url, video_url)
VALUES 
('Chăm sóc chó con', 'Hướng dẫn từ A-Z cách nuôi chó con', GETDATE(), 'Dr. Trí Nguyễn', NULL, NULL),
('Dinh dưỡng cho mèo trưởng thành', 'Lựa chọn thực phẩm phù hợp', GETDATE(), 'Dr. Lệ Hằng', NULL, NULL),
('Sơ cứu thú cưng tại nhà', 'Các tình huống thường gặp và cách xử lý', GETDATE(), 'Dr. Dũng Phạm', NULL, NULL);

-- san pham
INSERT INTO products (name, description, price, stock, partner_id, image_url)
VALUES 
('Thức ăn cho chó vị gà 5kg', 'Dành cho chó từ 2 tháng tuổi', 350000, 100, 3, NULL),
('Cát vệ sinh cho mèo', 'Thấm hút tốt, khử mùi tự nhiên', 120000, 200, 3, NULL),
('Sữa tắm thú cưng', 'Chống rụng lông và làm mượt lông', 85000, 150, 3, NULL);

-- don hang + chi tiet
INSERT INTO orders (user_id, order_date, total_amount, commission, status)
VALUES (1, GETDATE(), 350000, 10500, 'pending');

INSERT INTO order_items (order_id, product_id, quantity, price)
VALUES (1, 1, 1, 350000);

-- Thanh toan
INSERT INTO payments (order_id, payment_date, method, amount)
VALUES (1, GETDATE(), 'VNPay', 350000);