-- ===========================================
--          PETTECH DATABASE INIT SCRIPT
--          (Optimized Version)
-- ===========================================

-- Tạo database nếu chưa tồn tại
IF NOT EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = 'PetTech')
BEGIN
    CREATE DATABASE PetTech;
END
GO

USE PetTech;
GO

-- ===========================================
--          DROP ALL TABLES IF EXISTS
-- ===========================================
-- Xóa các bảng có khóa ngoại trước
DROP TABLE IF EXISTS user_progress;
DROP TABLE IF EXISTS lesson_attachments;
DROP TABLE IF EXISTS course_lessons;
DROP TABLE IF EXISTS course_modules;
DROP TABLE IF EXISTS product_category_items;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS course_access;
DROP TABLE IF EXISTS course_category_course;
DROP TABLE IF EXISTS course_category_items;
DROP TABLE IF EXISTS course_images;
DROP TABLE IF EXISTS user_packages;
DROP TABLE IF EXISTS BlogComments;
DROP TABLE IF EXISTS Blogs;
DROP TABLE IF EXISTS BlogCategories;
DROP TABLE IF EXISTS course_reviews;
DROP TABLE IF EXISTS User_Service;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS partners;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS product_categories;
DROP TABLE IF EXISTS course_categories;
DROP TABLE IF EXISTS service_packages;
GO

-- ===========================================
--          TẠO CÁC BẢNG
-- ===========================================

-- ===========================================
--          TẠO LẠI CÁC BẢNG
-- ===========================================

-- 1. Bảng không phụ thuộc (cấp 0)
CREATE TABLE service_packages (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(50) NOT NULL,
    description NVARCHAR(MAX) NOT NULL,
    price DECIMAL(10, 0) NOT NULL,
    type NVARCHAR(20) UNIQUE CHECK (type IN (N'free', N'standard', N'pro')) NOT NULL
);

CREATE TABLE course_categories (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(255) NULL
);

CREATE TABLE product_categories (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL
);

CREATE TABLE BlogCategories (
    category_id INT PRIMARY KEY IDENTITY(1,1),
    category_name NVARCHAR(100) NOT NULL,
    description NVARCHAR(255),
    created_at DATETIME DEFAULT GETDATE()
);

-- 2. Bảng phụ thuộc cấp 1
CREATE TABLE users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    email NVARCHAR(100) NOT NULL UNIQUE CHECK (email LIKE '%@%.%'),
    password NVARCHAR(100) NOT NULL,
    fullname NVARCHAR(100) NOT NULL,
    phone NVARCHAR(20) NOT NULL,
    address NVARCHAR(255) NOT NULL,
    role_id INT DEFAULT 1 CHECK (role_id IN (1, 2, 3)), -- 1: user, 2: staff, 3: admin
    status BIT DEFAULT 1,  -- 1: active, 0: inactive
    created_at DATETIME DEFAULT GETDATE(),
    verification_token NVARCHAR(255),
    service_package_id INT,
    is_active BIT DEFAULT 0,
    activation_token VARCHAR(100),
    token_expiry DATETIME,
    FOREIGN KEY (service_package_id) REFERENCES service_packages(id)
);

CREATE TABLE partners (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) NOT NULL UNIQUE,
    phone NVARCHAR(20) NOT NULL,
    address NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX),
    status BIT DEFAULT 1,
    created_at DATETIME DEFAULT GETDATE()
);

CREATE TABLE courses (
    id INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(255) NOT NULL,
    content NVARCHAR(MAX) NOT NULL,
    post_date DATE NOT NULL,
    researcher NVARCHAR(100) NOT NULL,
    video_url NVARCHAR(MAX),
    status INT DEFAULT 1 CHECK (status IN (0, 1)), -- 0: inactive, 1: active
    duration NVARCHAR(50) NOT NULL,  -- Đổi từ 'time' sang 'duration' cho rõ nghĩa
    thumbnail_url NVARCHAR(255)  -- Thêm thumbnail trực tiếp vào bảng courses
);

-- 3. Bảng phụ thuộc cấp 2
CREATE TABLE course_category_mapping (
    course_id INT NOT NULL,
    category_id INT NOT NULL,
    PRIMARY KEY (course_id, category_id),
    FOREIGN KEY (course_id) REFERENCES courses(id),
    FOREIGN KEY (category_id) REFERENCES course_categories(id)
);

CREATE TABLE course_images (
    id INT IDENTITY(1,1) PRIMARY KEY,
    course_id INT NOT NULL,
    image_url NVARCHAR(255) NOT NULL,
    is_primary BIT DEFAULT 0,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (course_id) REFERENCES courses(id)
);

CREATE TABLE products (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX) NOT NULL,
    price DECIMAL(12, 0) NOT NULL CHECK (price >= 0),
    stock INT NOT NULL CHECK (stock >= 0),
    partner_id INT,
    image_url NVARCHAR(MAX),
    FOREIGN KEY (partner_id) REFERENCES partners(id)
);

CREATE TABLE product_category_mapping (
    product_id INT NOT NULL,
    category_id INT NOT NULL,
    PRIMARY KEY (product_id, category_id),
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (category_id) REFERENCES product_categories(id)
);

CREATE TABLE User_Service (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    package_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status NVARCHAR(50) NOT NULL, -- 'active', 'expired', 'upgraded'
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (package_id) REFERENCES service_packages(id)
);

CREATE TABLE course_modules (
    id INT IDENTITY(1,1) PRIMARY KEY,
    course_id INT NOT NULL,
    title NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX),
    order_index INT NOT NULL,
    FOREIGN KEY (course_id) REFERENCES courses(id)
);

CREATE TABLE Blogs (
    blog_id INT PRIMARY KEY IDENTITY(1,1),
    title NVARCHAR(255) NOT NULL,
    content NVARCHAR(MAX) NOT NULL,
    short_description NVARCHAR(500),
    image_url NVARCHAR(255),
    category_id INT NOT NULL,
    author_id INT,
    author_name NVARCHAR(100) DEFAULT 'Admin',
    view_count INT DEFAULT 0,
    is_featured BIT DEFAULT 0,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (category_id) REFERENCES BlogCategories(category_id)
);

-- 4. Bảng phụ thuộc cấp 3
CREATE TABLE course_lessons (
    id INT IDENTITY(1,1) PRIMARY KEY,
    module_id INT NOT NULL,
    title NVARCHAR(255) NOT NULL,
    content NVARCHAR(MAX),
    video_url NVARCHAR(255),
    duration INT,  -- Thời lượng bài học (phút)
    order_index INT NOT NULL,
    FOREIGN KEY (module_id) REFERENCES course_modules(id)
);

CREATE TABLE orders (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    order_date DATETIME DEFAULT GETDATE(),
    total_amount DECIMAL(12, 0) NOT NULL CHECK (total_amount >= 0),
    commission DECIMAL(12, 0) NOT NULL CHECK (commission >= 0),
    status NVARCHAR(20) NOT NULL CHECK (status IN (N'pending', N'processing', N'completed', N'cancelled')),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 5. Bảng phụ thuộc cấp 4
CREATE TABLE order_items (
    id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    price DECIMAL(12, 0) NOT NULL CHECK (price >= 0),
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

CREATE TABLE payments (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    service_package_id INT NULL,
    order_id INT NULL,
    payment_method VARCHAR(50) NOT NULL CHECK (payment_method IN ('MOMO_QR', 'BANK_QR', 'VNPAY', 'CASH')),
    amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
    payment_date DATETIME DEFAULT GETDATE(),
    status VARCHAR(20) NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'failed', 'refunded')),
    transaction_id VARCHAR(100),
    qr_code_url NVARCHAR(500) NULL,
    bank_account_number VARCHAR(20) NULL,
    bank_name NVARCHAR(100) NULL,
    notes NVARCHAR(500) NULL,
    is_confirmed BIT DEFAULT 0,
    confirmation_code VARCHAR(50),
    confirmation_expiry DATETIME,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (service_package_id) REFERENCES service_packages(id),
    FOREIGN KEY (order_id) REFERENCES orders(id)
);

CREATE TABLE lesson_attachments (
    id INT IDENTITY(1,1) PRIMARY KEY,
    lesson_id INT NOT NULL,
    file_name NVARCHAR(255) NOT NULL,
    file_url NVARCHAR(255) NOT NULL,
    file_size INT,
    FOREIGN KEY (lesson_id) REFERENCES course_lessons(id)
);

CREATE TABLE BlogComments (
    comment_id INT PRIMARY KEY IDENTITY(1,1),
    blog_id INT NOT NULL,
    user_id INT,
    content NVARCHAR(1000) NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (blog_id) REFERENCES Blogs(blog_id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE course_reviews (
    id INT IDENTITY(1,1) PRIMARY KEY,
    course_id INT NOT NULL,
    user_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (course_id) REFERENCES courses(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 6. Bảng phụ thuộc cấp 5
CREATE TABLE user_progress (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    lesson_id INT NOT NULL,
    completed BIT DEFAULT 0,
    completed_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (lesson_id) REFERENCES course_lessons(id)
);

CREATE TABLE course_access (
    course_id INT NOT NULL,
    service_package_id INT NOT NULL,
    PRIMARY KEY (course_id, service_package_id),
    FOREIGN KEY (course_id) REFERENCES courses(id),
    FOREIGN KEY (service_package_id) REFERENCES service_packages(id)
);
CREATE TABLE user_packages (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    service_package_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (service_package_id) REFERENCES service_packages(id)
);
-- ===========================================
--          THÊM DỮ LIỆU MẪU
-- ===========================================

-- 1. Gói dịch vụ (giữ nguyên)
INSERT INTO service_packages (name, description, price, type)
VALUES 
(N'GÓI MIỄN PHÍ', N'Phù hợp với người mới bắt đầu nuôi thú cưng hoặc đang tìm hiểu.', 0, N'free'),
(N'GÓI TIÊU CHUẨN', N'Dành cho người nuôi thú cưng có nhu cầu chăm sóc tốt hơn và học hỏi thêm.', 99000, N'standard'),
(N'GÓI CHUYÊN NGHIỆP', N'Phù hợp với người yêu thú cưng nghiêm túc hoặc kinh doanh nhỏ (pet shop, grooming).', 199000, N'pro');

-- 2. Người dùng (giữ nguyên)
INSERT INTO users (email, password, fullname, phone, address, role_id, status, service_package_id, is_active)
VALUES
('user1@example.com', '123456Aa', N'Nguyễn Văn A', '0912345678', N'123 Đường ABC, Quận 1', 1, 1, 1, 1),
('user2@example.com', '123456Aa', N'Trần Thị B', '0987654321', N'456 Đường XYZ, Quận 2', 1, 1, 2, 0),
('staff1@pettech.com', '123456Aa', N'Nhân viên C', '0909999999', N'789 Đường DEF, Quận 3', 2, 1, 2, 1),
('admin@pettech.com', '123456Aa', N'Quản trị viên D', '0938888888', N'321 Đường GHI, Quận 4', 3, 1, 3, 1),
('user3@example.com', '123456Aa', N'Lê Văn C', '0987654322', N'789 Đường XYZ, Quận 3', 1, 1, 1, 1),
('user4@example.com', '123456Aa', N'Phạm Thị D', '0987654323', N'456 Đường ABC, Quận 4', 1, 1, 2, 1),
('user5@example.com', '123456Aa', N'Trần Văn E', '0987654324', N'123 Đường DEF, Quận 5', 1, 1, 3, 1);

-- 3. Đối tác (giữ nguyên)
INSERT INTO partners (name, email, phone, address, description, status)
VALUES
(N'PetFood Việt Nam', 'petfood@example.com', '0987123456', N'123 Đường Lê Lợi, Hà Nội', N'Nhà cung cấp thức ăn thú cưng hàng đầu', 1),
(N'PetCare Solutions', 'petcare@example.com', '0987765432', N'456 Đường Nguyễn Huệ, TP.HCM', N'Chuyên cung cấp dịch vụ chăm sóc thú cưng', 1);

-- 4. Danh mục khóa học (giữ nguyên)
INSERT INTO course_categories (name)
VALUES
(N'Chăm sóc cơ bản'),
(N'Dinh dưỡng'),
(N'Sức khỏe'),
(N'Huấn luyện');

-- 5. Danh mục sản phẩm (giữ nguyên)
INSERT INTO product_categories (name)
VALUES 
(N'Thức ăn'),
(N'Vệ sinh'),
(N'Phụ kiện');

-- 6. Danh mục blog (giữ nguyên)
INSERT INTO BlogCategories (category_name, description) VALUES
(N'Chăm sóc thú cưng', N'Các bài viết hướng dẫn chăm sóc thú cưng hàng ngày'),
(N'Dinh dưỡng', N'Chế độ ăn uống và dinh dưỡng cho thú cưng'),
(N'Y tế - Sức khỏe', N'Các vấn đề về sức khỏe và y tế thú cưng'),
(N'Đào tạo', N'Cách huấn luyện và đào tạo thú cưng'),
(N'Giống loài', N'Thông tin về các giống thú cưng phổ biến'),
(N'Phụ kiện', N'Đánh giá và giới thiệu phụ kiện cho thú cưng'),
(N'Câu chuyện', N'Những câu chuyện cảm động về thú cưng'),
(N'Sự kiện', N'Các sự kiện liên quan đến thú cưng'),
(N'Kiến thức chung', N'Kiến thức tổng hợp về thú cưng'),
(N'Tin tức PetTech', N'Tin tức và cập nhật từ PetTech');

-- 7. Khóa học (đổi cột time thành duration)
INSERT INTO courses (title, content, post_date, researcher, video_url, status, duration, thumbnail_url)
VALUES 
(N'Chăm sóc chó con', N'Hướng dẫn nuôi dạy chó con toàn diện', GETDATE(), N'Dr. Trí Nguyễn', NULL, 1, N'4 tuần', '/images/course/course_dog.jpg'),
(N'Dinh dưỡng cho mèo trưởng thành', N'Phân tích chế độ ăn và thực phẩm phù hợp cho mèo', GETDATE(), N'Dr. Lệ Hằng', NULL, 1, N'6 tuần', '/images/course/course_cat.jpg'),
(N'Sơ cứu thú cưng tại nhà', N'Hướng dẫn các bước sơ cứu cơ bản cho thú cưng', GETDATE(), N'Dr. Dũng Phạm', NULL, 1, N'3 tháng', '/images/course/course_pet_first_aid.jpg'),
(N'Huấn luyện chó căn bản', N'Hướng dẫn chi tiết các kỹ thuật huấn luyện chó cơ bản', GETDATE(), N'Dr. Thanh Phạm', NULL, 1, N'5 tuần', '/images/course/course_training_dog.jpg'),
(N'Chăm sóc mèo cơ bản', N'Hướng dẫn chi tiết chăm sóc mèo từ thức ăn, vệ sinh, đến sức khỏe.', GETDATE(), N'Dr. Mai Phương', NULL, 1, N'4 tuần', '/images/course/course_cat_care.jpg');

-- 8. Ánh xạ khóa học - danh mục (thay thế bảng course_category_items và course_category_course)
INSERT INTO course_category_mapping (course_id, category_id)
VALUES 
(1, 1), -- Chăm sóc chó con -> Chăm sóc cơ bản
(1, 4), -- Chăm sóc chó con -> Huấn luyện
(2, 2), -- Dinh dưỡng cho mèo -> Dinh dưỡng
(3, 3), -- Sơ cứu -> Sức khỏe
(4, 4), -- Huấn luyện chó -> Huấn luyện
(5, 1), -- Chăm sóc mèo -> Chăm sóc cơ bản
(5, 2); -- Chăm sóc mèo -> Dinh dưỡng

-- 9. Hình ảnh khóa học (bổ sung thêm ảnh phụ)
INSERT INTO course_images (course_id, image_url, is_primary)
VALUES 
(1, '/images/course/course_dog_2.jpg', 0),
(1, '/images/course/course_dog_3.jpg', 0),
(2, '/images/course/course_cat_2.jpg', 0),
(3, '/images/course/course_pet_first_aid_2.jpg', 0),
(4, '/images/course/course_training_dog_2.jpg', 0),
(5, '/images/course/course_cat_care_2.jpg', 0);

-- 10. Sản phẩm (giữ nguyên)
INSERT INTO products (name, description, price, stock, partner_id, image_url)
VALUES 
(N'Thức ăn cho chó vị gà 5kg', N'Dành cho chó từ 2 tháng tuổi trở lên', 350000, 100, 1, '/img/products/dog_food.jpg'),
(N'Cát vệ sinh hữu cơ cho mèo', N'Hấp thụ nhanh và khử mùi tốt', 120000, 150, 1, '/img/products/cat_litter.jpg'),
(N'Sữa tắm thảo dược thú cưng', N'Làm sạch và chống rụng lông', 89000, 200, 2, '/img/products/pet_shampoo.jpg');

-- 11. Ánh xạ sản phẩm - danh mục (đổi tên bảng từ product_category_items)
INSERT INTO product_category_mapping (product_id, category_id)
VALUES 
(1, 1), -- Thức ăn cho chó -> Thức ăn
(2, 2), -- Cát vệ sinh -> Vệ sinh
(3, 2), -- Sữa tắm -> Vệ sinh
(3, 3); -- Sữa tắm -> Phụ kiện

-- 12. Đơn hàng (giữ nguyên)
INSERT INTO orders (user_id, total_amount, commission, status)
VALUES 
(1, 350000, 10500, N'completed'),
(2, 120000, 3600, N'completed'),
(3, 500000, 15000, N'processing');

-- 13. Chi tiết đơn hàng (giữ nguyên)
INSERT INTO order_items (order_id, product_id, quantity, price)
VALUES 
(1, 1, 1, 350000),
(2, 2, 1, 120000),
(3, 1, 1, 350000),
(3, 3, 2, 89000);

-- 14. Thanh toán (giữ nguyên)
INSERT INTO payments (user_id, order_id, payment_method, amount, status, transaction_id)
VALUES 
(1, 1, 'VNPAY', 350000, 'completed', 'VNPAY123456'),
(2, 2, 'MOMO_QR', 120000, 'completed', 'MOMO654321');

-- 15. Blog (giữ nguyên)
INSERT INTO Blogs (title, content, short_description, image_url, category_id, is_featured)
VALUES
(N'10 cách chăm sóc mèo đúng cách', N'Nội dung chi tiết...', N'Hướng dẫn chăm sóc mèo đúng cách', 'images/Blog/blog1.jpg', 1, 1),
(N'Thức ăn tốt nhất cho chó con', N'Nội dung chi tiết...', N'Chọn thức ăn phù hợp cho chó con', 'images/Blog/blog2.jpg', 2, 1),
(N'Dấu hiệu bệnh thường gặp ở mèo', N'Nội dung chi tiết...', N'Nhận biết các dấu hiệu bệnh ở mèo', 'images/Blog/blog3.jpg', 3, 0);

-- 16. Module và bài học (ví dụ cho khóa học 1)
INSERT INTO course_modules (course_id, title, description, order_index)
VALUES
(1, N'Giới thiệu về chó con', N'Thông tin cơ bản và tổng quan khi quyết định nuôi chó con', 1),
(1, N'Dinh dưỡng hợp lý', N'Hướng dẫn lựa chọn chế độ ăn phù hợp theo độ tuổi', 2),
(2, N'Dinh dưỡng cơ bản', N'Hiểu về nhu cầu dinh dưỡng của mèo', 1),
(3, N'Sơ cứu cơ bản', N'Các kỹ thuật sơ cứu ban đầu', 1);

INSERT INTO course_lessons (module_id, title, content, video_url, duration, order_index)
VALUES
(1, N'Bài 1: Tại sao chọn nuôi chó con', N'Nội dung chi tiết...', NULL, 10, 1),
(1, N'Bài 2: Chuẩn bị môi trường sống', N'Nội dung chi tiết...', NULL, 15, 2),
(2, N'Bài 1: Chế độ ăn cho chó con', N'Nội dung chi tiết...', 'https://youtube.com/embed/123', 20, 1),
(3, N'Bài 1: Nhu cầu dinh dưỡng cơ bản', N'Nội dung chi tiết...', NULL, 15, 1),
(4, N'Bài 1: Xử lý vết thương nhỏ', N'Nội dung chi tiết...', 'https://youtube.com/embed/456', 25, 1);

-- 17. Tài liệu đính kèm (giữ nguyên)
INSERT INTO lesson_attachments (lesson_id, file_name, file_url, file_size)
VALUES
(3, N'Hướng dẫn dinh dưỡng.pdf', '/uploads/guides/nutrition.pdf', 1024),
(5, N'Cẩm nang sơ cứu.pdf', '/uploads/guides/first_aid.pdf', 2048);

-- 18. Tiến độ học tập (giữ nguyên)
INSERT INTO user_progress (user_id, lesson_id, completed, completed_at)
VALUES
(1, 1, 1, GETDATE()),
(1, 2, 1, GETDATE()),
(2, 1, 1, GETDATE()),
(3, 4, 1, GETDATE());

-- 19. Đánh giá khóa học (giữ nguyên)
INSERT INTO course_reviews (course_id, user_id, rating, comment)
VALUES
(1, 1, 5, N'Khóa học rất hữu ích'),
(1, 2, 4, N'Nội dung chi tiết, dễ hiểu'),
(2, 3, 5, N'Giảng viên nhiệt tình'),
(3, 4, 4, N'Kiến thức thực tế, áp dụng được ngay');

-- 20. User Service Packages (giữ nguyên)
INSERT INTO User_Service (user_id, package_id, start_date, end_date, status)
VALUES
(1, 1, '2023-01-01', '2023-12-31', 'active'),
(2, 2, '2023-02-01', '2023-08-01', 'active'),
(3, 3, '2023-03-01', '2023-09-01', 'active'),
(4, 2, '2023-04-01', '2023-10-01', 'active'),
(5, 3, '2023-05-01', '2023-11-01', 'active');

-- 21. User Packages History (giữ nguyên)
INSERT INTO user_packages (user_id, service_package_id, start_date, end_date)
VALUES
(1, 1, '2023-01-01', '2023-12-31'),
(2, 2, '2023-02-01', '2023-08-01'),
(3, 3, '2023-03-01', '2023-09-01'),
(4, 2, '2023-04-01', '2023-10-01'),
(5, 3, '2023-05-01', '2023-11-01');

-- 22. Course Access (điều chỉnh theo bảng mới)
INSERT INTO course_access (course_id, service_package_id)
VALUES
(1, 2), (1, 3), -- Chăm sóc chó con cho gói standard và pro
(2, 2), (2, 3), -- Dinh dưỡng mèo
(3, 3),         -- Sơ cứu chỉ cho pro
(4, 3),         -- Huấn luyện chó
(5, 2), (5, 3); -- Chăm sóc mèo

-- 23. Blog Comments (giữ nguyên)
INSERT INTO BlogComments (blog_id, user_id, content)
VALUES
(1, 1, N'Bài viết rất hữu ích, cảm ơn tác giả!'),
(1, 2, N'Tôi đã áp dụng và thấy hiệu quả'),
(2, 3, N'Thông tin chi tiết, dễ hiểu'),
(3, 4, N'Rất hữu ích cho người nuôi mèo như tôi');