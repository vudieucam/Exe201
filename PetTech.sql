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
DROP TABLE IF EXISTS product_category_mapping;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS course_access;
DROP TABLE IF EXISTS course_category_mapping;
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
DROP TABLE IF EXISTS audit_log;
GO

-- ===========================================
--          TẠO CÁC BẢNG (THEO THỨ TỰ PHỤ THUỘC)
-- ===========================================

-- 1. Bảng không phụ thuộc (cấp 0)
CREATE TABLE service_packages (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(50) NOT NULL,
    description NVARCHAR(MAX) NOT NULL,
    price DECIMAL(10, 0) NOT NULL,
    type NVARCHAR(20) UNIQUE CHECK (type IN (N'free', N'standard', N'pro')) NOT NULL,
    status BIT DEFAULT 1 -- 1: active, 0: inactive
);

CREATE TABLE course_categories (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(255) NULL,
    status BIT DEFAULT 1 -- 1: active, 0: inactive
);

CREATE TABLE product_categories (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    status BIT DEFAULT 1 -- 1: active, 0: inactive
);

CREATE TABLE BlogCategories (
    category_id INT PRIMARY KEY IDENTITY(1,1),
    category_name NVARCHAR(100) NOT NULL,
    description NVARCHAR(255),
    created_at DATETIME DEFAULT GETDATE(),
    status BIT DEFAULT 1 -- 1: active, 0: inactive
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
    status BIT DEFAULT 1, -- 1: active, 0: inactive
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
    duration NVARCHAR(50) NOT NULL,
    thumbnail_url NVARCHAR(255),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    is_paid BIT DEFAULT 0, -- 0: free, 1: paid
);

-- 3. Bảng phụ thuộc cấp 2
CREATE TABLE course_category_mapping (
    course_id INT NOT NULL,
    category_id INT NOT NULL,
    status BIT DEFAULT 1, -- 1: active, 0: inactive
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
    status BIT DEFAULT 1, -- 1: active, 0: inactive
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
    status BIT DEFAULT 1, -- 1: active, 0: inactive
    FOREIGN KEY (partner_id) REFERENCES partners(id)
);

CREATE TABLE product_category_mapping (
    product_id INT NOT NULL,
    category_id INT NOT NULL,
    status BIT DEFAULT 1, -- 1: active, 0: inactive
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
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    status BIT DEFAULT 1, -- 1: active, 0: inactive
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
    status BIT DEFAULT 1, -- 1: active, 0: inactive
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
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    status BIT DEFAULT 1, -- 1: active, 0: inactive
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
    status BIT DEFAULT 1, -- 1: active, 0: inactive
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
    status BIT DEFAULT 1, -- 1: active, 0: inactive
    FOREIGN KEY (lesson_id) REFERENCES course_lessons(id)
);

CREATE TABLE BlogComments (
    comment_id INT PRIMARY KEY IDENTITY(1,1),
    blog_id INT NOT NULL,
    user_id INT,
    content NVARCHAR(1000) NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    status BIT DEFAULT 1, -- 1: active, 0: inactive
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
    status BIT DEFAULT 1, -- 1: active, 0: inactive
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
    status BIT DEFAULT 1, -- 1: active, 0: inactive
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (lesson_id) REFERENCES course_lessons(id)
);

CREATE TABLE course_access (
    course_id INT NOT NULL,
    service_package_id INT NOT NULL,
    status BIT DEFAULT 1, -- 1: active, 0: inactive
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
    status BIT DEFAULT 1, -- 1: active, 0: inactive
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (service_package_id) REFERENCES service_packages(id)
);

-- Bảng audit log
CREATE TABLE audit_log (
    id INT IDENTITY(1,1) PRIMARY KEY,
    table_name NVARCHAR(50) NOT NULL,
    record_id INT NOT NULL,
    action NVARCHAR(20) NOT NULL, -- 'CREATE', 'UPDATE', 'DELETE'
    old_values NVARCHAR(MAX),
    new_values NVARCHAR(MAX),
    changed_by INT NOT NULL,
    changed_at DATETIME DEFAULT GETDATE(),
    status BIT DEFAULT 1, -- 1: active, 0: inactive
    FOREIGN KEY (changed_by) REFERENCES users(id)
);

-- ===========================================
--          THÊM DỮ LIỆU MẪU (ĐÃ CẬP NHẬT)
-- ===========================================

-- 1. Gói dịch vụ (đã thêm status)
INSERT INTO service_packages (name, description, price, type, status)
VALUES 
(N'GÓI MIỄN PHÍ', N'Phù hợp với người mới bắt đầu nuôi thú cưng hoặc đang tìm hiểu.', 0, N'free', 1),
(N'GÓI TIÊU CHUẨN', N'Dành cho người nuôi thú cưng có nhu cầu chăm sóc tốt hơn và học hỏi thêm.', 99000, N'standard', 1),
(N'GÓI CHUYÊN NGHIỆP', N'Phù hợp với người yêu thú cưng nghiêm túc hoặc kinh doanh nhỏ (pet shop, grooming).', 199000, N'pro', 1);

-- 2. Danh mục khóa học (đã thêm status)
INSERT INTO course_categories (name, status)
VALUES
(N'Chăm sóc cơ bản', 1),
(N'Dinh dưỡng', 1),
(N'Sức khỏe', 1),
(N'Huấn luyện', 1);

-- 3. Danh mục sản phẩm (đã thêm status)
INSERT INTO product_categories (name, status)
VALUES 
(N'Thức ăn', 1),
(N'Vệ sinh', 1),
(N'Phụ kiện', 1);

-- 4. Danh mục blog (đã thêm status)
INSERT INTO BlogCategories (category_name, description, status) VALUES
(N'Chăm sóc thú cưng', N'Các bài viết hướng dẫn chăm sóc thú cưng hàng ngày', 1),
(N'Dinh dưỡng', N'Chế độ ăn uống và dinh dưỡng cho thú cưng', 1),
(N'Y tế - Sức khỏe', N'Các vấn đề về sức khỏe và y tế thú cưng', 1),
(N'Đào tạo', N'Cách huấn luyện và đào tạo thú cưng', 1),
(N'Giống loài', N'Thông tin về các giống thú cưng phổ biến', 1),
(N'Phụ kiện', N'Đánh giá và giới thiệu phụ kiện cho thú cưng', 1),
(N'Câu chuyện', N'Những câu chuyện cảm động về thú cưng', 1),
(N'Sự kiện', N'Các sự kiện liên quan đến thú cưng', 1),
(N'Kiến thức chung', N'Kiến thức tổng hợp về thú cưng', 1),
(N'Tin tức PetTech', N'Tin tức và cập nhật từ PetTech', 1);

-- 5. Đối tác (đã có status)
INSERT INTO partners (name, email, phone, address, description, status)
VALUES
(N'PetFood Việt Nam', 'petfood@example.com', '0987123456', N'123 Đường Lê Lợi, Hà Nội', N'Nhà cung cấp thức ăn thú cưng hàng đầu', 1),
(N'PetCare Solutions', 'petcare@example.com', '0987765432', N'456 Đường Nguyễn Huệ, TP.HCM', N'Chuyên cung cấp dịch vụ chăm sóc thú cưng', 1);

-- 6. Người dùng (đã có status)
INSERT INTO users (email, password, fullname, phone, address, role_id, status, service_package_id, is_active)
VALUES
('user1@example.com', '123456Aa', N'Nguyễn Văn A', '0912345678', N'123 Đường ABC, Quận 1', 1, 1, 1, 1),
('user2@example.com', '123456Aa', N'Trần Thị B', '0987654321', N'456 Đường XYZ, Quận 2', 1, 1, 2, 0),
('staff1@pettech.com', '123456Aa', N'Nhân viên C', '0909999999', N'789 Đường DEF, Quận 3', 2, 1, 2, 1),
('admin@pettech.com', '123456Aa', N'Quản trị viên D', '0938888888', N'321 Đường GHI, Quận 4', 3, 1, 3, 1),
('user3@example.com', '123456Aa', N'Lê Văn C', '0987654322', N'789 Đường XYZ, Quận 3', 1, 1, 1, 1),
('user4@example.com', '123456Aa', N'Phạm Thị D', '0987654323', N'456 Đường ABC, Quận 4', 1, 1, 2, 1),
('user5@example.com', '123456Aa', N'Trần Văn E', '0987654324', N'123 Đường DEF, Quận 5', 1, 1, 3, 1);

-- 7. Khóa học (đã thêm is_paid và price)
INSERT INTO courses (title, content, post_date, researcher, video_url, status, duration, thumbnail_url, is_paid)
VALUES 
(N'Cách chăm sóc chó con 3 tháng tuổi đầu tiên', N'Sau khi sinh, chó con cũng cần được chăm sóc đặc biệt...', GETDATE(), N'Dr. Nam Nguyễn', NULL, 1, N'4 tuần', '/images/course/course1.jpg', 0),
(N'Cách chăm sóc mèo con', N'Để có được một chú mèo khỏe mạnh và đáng yêu...', GETDATE(), N'Dr. Hiền Nguyễn', NULL, 1, N'6 tuần', '/images/course/course2.jpg', 0),
(N'Cách vệ sinh cho chó', N'Thú cưng được chăm sóc thường xuyên sẽ luôn sạch sẽ...', GETDATE(), N'Dr. Chi Nguyễn', NULL, 1, N'3 tháng', '/images/course/course3.jpg', 0),
(N'Huấn luyện chó căn bản', N'Hướng dẫn chi tiết các kỹ thuật huấn luyện chó cơ bản', GETDATE(), N'Dr. Thanh Phạm', NULL, 1, N'5 tuần', '/images/course/course4.jpg', 1),
(N'Chăm sóc mèo cơ bản', N'Hướng dẫn chi tiết chăm sóc mèo từ thức ăn, vệ sinh, đến sức khỏe.', GETDATE(), N'Dr. Mai Phương', NULL, 1, N'4 tuần', '/images/course/course5.jpg', 1);

-- 8. Ánh xạ khóa học - danh mục (đã thêm status)
INSERT INTO course_category_mapping (course_id, category_id, status)
VALUES 
(1, 1, 1), -- Chăm sóc chó con -> Chăm sóc cơ bản
(1, 4, 1), -- Chăm sóc chó con -> Huấn luyện
(2, 2, 1), -- Dinh dưỡng cho mèo -> Dinh dưỡng
(3, 3, 1), -- Sơ cứu -> Sức khỏe
(4, 4, 1), -- Huấn luyện chó -> Huấn luyện
(5, 1, 1), -- Chăm sóc mèo -> Chăm sóc cơ bản
(5, 2, 1); -- Chăm sóc mèo -> Dinh dưỡng

-- 9. Hình ảnh khóa học (đã thêm status)
INSERT INTO course_images (course_id, image_url, is_primary, status)
VALUES 
(1, '/images/course/course_dog_2.jpg', 0, 1),
(1, '/images/course/course_dog_3.jpg', 0, 1),
(2, '/images/course/course_cat_2.jpg', 0, 1),
(3, '/images/course/course_pet_first_aid_2.jpg', 0, 1),
(4, '/images/course/course_training_dog_2.jpg', 0, 1),
(5, '/images/course/course_cat_care_2.jpg', 0, 1);

-- 10. Sản phẩm (đã thêm status)
INSERT INTO products (name, description, price, stock, partner_id, image_url, status)
VALUES 
(N'Thức ăn cho chó vị gà 5kg', N'Dành cho chó từ 2 tháng tuổi trở lên', 350000, 100, 1, '/img/products/dog_food.jpg', 1),
(N'Cát vệ sinh hữu cơ cho mèo', N'Hấp thụ nhanh và khử mùi tốt', 120000, 150, 1, '/img/products/cat_litter.jpg', 1),
(N'Sữa tắm thảo dược thú cưng', N'Làm sạch và chống rụng lông', 89000, 200, 2, '/img/products/pet_shampoo.jpg', 1);

-- 11. Ánh xạ sản phẩm - danh mục (đã thêm status)
INSERT INTO product_category_mapping (product_id, category_id, status)
VALUES 
(1, 1, 1), -- Thức ăn cho chó -> Thức ăn
(2, 2, 1), -- Cát vệ sinh -> Vệ sinh
(3, 2, 1), -- Sữa tắm -> Vệ sinh
(3, 3, 1); -- Sữa tắm -> Phụ kiện

-- 12. Module khóa học (đã thêm status)
INSERT INTO course_modules (course_id, title, description, order_index, status)
VALUES
(1, N'Module 1: Những cách chăm sóc chó con mới đẻ cần ghi nhớ', N'Như các bạn đã biết, chó con mới đẻ thường có sức khỏe khá yếu...', 1, 1),
(1, N'Module 2: Một số lưu ý về chế độ dinh dưỡng cho chó con mới đẻ', N'Hướng dẫn lựa chọn chế độ ăn phù hợp theo độ tuổi', 2, 1),
(2, N'Module 1: Cách chăm sóc mèo con mới đẻ vẫn còn mẹ', N'Hiểu về cách chăm sóc cho mèo con mới đẻ', 1, 1),
(2, N'Module 2: Cách chăm sóc mèo con mới đẻ mất mẹ', N'Để chăm sóc mèo con mới đẻ mất mẹ...', 2, 1),
(2, N'Module 3: Các loại sữa bột tốt cho mèo con', N'Các loại sữa công thức phù hợp cho mèo con...', 3, 1),
(2, N'Module 4: Lưu ý khi chăm sóc mèo con mới đẻ', N'- Không nên để mèo nằm khi ăn...', 4, 1),
(3, N'Module 1: Vệ sinh cho chó trước khi tắm', N'Xem bài học bên dưới...', 1, 1),
(4, N'Module 2: Lưu ý khi chăm sóc mèo con mới đẻ', N'- Không nên để mèo nằm khi ăn...', 1, 1);

-- 13. Bài học (đã thêm status)
INSERT INTO course_lessons (module_id, title, content, video_url, duration, order_index, status)
VALUES
(1, N'Bài 1. Vệ sinh ổ đẻ cho các chú cún con đảm bảo sạch sẽ', 
N'Sau khi trải qua quá trình sinh, chó mẹ thường dành phần lớn thời gian để nghỉ ngơi bên cạnh đàn con của mình, chỉ rời khỏi để đi vệ sinh hoặc ăn uống. 
Chúng ta có thể tận dụng thời gian này để làm vệ sinh, quét dọn và thay khăn lót ổ đẻ. 
Đảm bảo môi trường ổ đẻ khô ráo và thoáng mát là cách giúp ngăn ngừa sự phát triển của vi khuẩn và bảo vệ sức khỏe cho chó con non nớt.
Tuy nhiên, các bạn cần lưu ý không nên lót quá nhiều lớp vải trong ổ đẻ. 
Điều này giúp tránh tình trạng chó con chưa mở mắt gặp khó khăn trong việc tìm hiểu phương hướng và không thể tìm đến chó mẹ để bú.', NULL, 10, 1, 1),
(1, N'Bài 2. Chú ý làm sạch cơ thể cho cún con mới sinh', N'Hầu hết chó con khi mới sinh ra sẽ có lớp nhầy nhớt hoặc vết bẩn từ nước ối. 
Để làm sạch, bạn nên sử dụng một khăn mềm thấm nước ấm và nhẹ nhàng lau cho đến khi sạch. 
Đây là một bước quan trọng trong quá trình chăm sóc chó con mới sinh.
Chó con sau khi sinh ra rất nhỏ bé và yếu đuối, tương tự như một đứa trẻ. 
Nếu bạn không có kinh nghiệm trong việc nuôi chó con mới sinh, hãy tìm hiểu kỹ càng và thực hiện nhẹ nhàng từng bước chăm sóc.
Trong những ngày đầu, chó con sẽ có cuống rốn còn dính trên bụng. 
Bạn không nên cắt nó quá sớm vì điều này có thể gây ra xuất huyết và chảy máu cho chó con. 
Hãy để cuống rốn tự teo dần theo thời gian và không cần lo lắng về điều này.', NULL, 15, 2, 1),
(1, N'Bài 3. Hỗ trợ giúp chó con tập bú mẹ nếu cần', N'Chó con khi mới sinh ra thường rất yếu đuối, không thể đi lại và chưa mở mắt. Thời gian mà chó con mới mở mắt thường là ít nhất 11 ngày (tùy thuộc vào số lượng con sinh ra trong một lứa).
Chó con cần phải dò dẫm và chui rúc xung quanh để tìm vú mẹ và sau đó mới có thể bú sữa. Để hỗ trợ chó con trong việc tìm và bú vú mẹ, bạn có thể áp dụng phương pháp nuôi chó con mới sinh dưới đây:

Bước 1: Nhẹ nhàng bế chó con lên và đặt miệng của chúng gần núm vú của chó mẹ.
Bước 2: Sử dụng một ngón tay nhỏ và cắt móng sạch sẽ, sau đó đặt nhẹ nhàng ngón tay trong miệng của chó con và đặt miệng chúng vào núm vú của chó mẹ. Cuối cùng, từ từ rút ngón tay ra khỏi miệng chó con.
Bước 3: Vắt ra vài giọt sữa từ vú của chó mẹ, sau đó bôi nhẹ nhàng lên mũi của chó con. Chó con sẽ theo mùi sữa và tìm đường đến vú của chó mẹ.

Bằng cách sử dụng phương pháp trên, bạn có thể nuôi chó con mới sinh một cách tốt nhất, giúp chúng phát triển khỏe mạnh và tăng trưởng nhanh chóng.', NULL, 20, 3, 1),
(1, N'Bài 4. Điều chỉnh nhiệt độ ổ nằm', N'Trong quá trình tìm hiểu về cách chăm sóc chó con mới sinh, quan trọng là bạn hiểu rằng chó con cần được nuôi ở một môi trường có nhiệt độ ấm áp. Do đó, khi chuẩn bị ổ đẻ, chó mẹ thường chọn những nơi kín đáo và ấm áp.
Nếu chó mẹ sinh con vào mùa lạnh, bạn cần hỗ trợ bằng cách sử dụng các thiết bị sưởi ấm, máy điều hòa và che chắn khỏi gió. Nhiệt độ lý tưởng cho khu vực ổ đẻ là khoảng 27 độ C và độ ẩm dưới 80%.

Ngoài ra, bạn cũng cần lưu ý về việc kiểm tra nhu cầu về nhiệt độ của chó con. Nếu nhiệt độ phù hợp, chó con sẽ ngủ ngon, không kêu nhiều và khoảng cách giữa chúng sẽ đều nhau.

Nếu ổ đẻ quá nóng, chó con sẽ nằm xa nhau, kêu và quậy nhiều. Nếu ổ đẻ quá lạnh, chó con sẽ rúc vào nhau. Vì vậy, dựa vào những dấu hiệu này, chúng ta cần tạo một môi trường sống thích hợp nhất để giúp chó con mới sinh phát triển.', NULL, 15, 4, 1),
(1, N'Bài 5. Phòng bệnh, thăm khám cho chó con mới đẻ định kỳ', N'Cùng chúng mình tìm hiểu các cách phòng chống hiệu quả và an toàn để chó con mới đẻ không mắc những loại bệnh nguy hiểm nhé.

* Ngừa bệnh rối loạn tiêu hóa
Việc vệ sinh khu vực sinh dục và hậu môn của chó mẹ là việc vô cùng cần thiết. Dịch hậu sản hay phân từ đây sẽ tạo điều kiện cho vi trùng, vi khuẩn dễ dàng xâm nhập và việc khó tiêu hóa ở chó con sẽ diễn ra thường xuyên.
Ngoài ra, để ngăn ngừa việc rối loạn tiêu hóa, bạn có thể cho chó con mới sinh uống thêm men Biosuptin 2 lần/1 ngày, mỗi lần uống 2-4 giọt. Loại men này sẽ giải quyết tình trạng chướng bụng, sữa thừa và sữa viêm.
Bạn cũng nên quan sát và chú ý tình trạng vú viêm ở chó con. Nếu diễn ra, chó con sẽ bị đau bụng và thở gấp. Đây sẽ là tiền đề để bệnh rối loạn tiêu hóa phát triển. Vì vậy, hãy kiểm tra thường xuyên nhé.

* Ngừa bệnh hô hấp 
Bệnh hô hấp thường xuất hiện và phát triển tại môi trường bụi bẩn, nhiệt độ hay việc chó mẹ lâu ngày không được vệ sinh dẫn đến mắc bệnh nấm. Vì vậy, để ngăn ngừa loại bệnh này, bạn hãy lưu ý một số chú ý sau nhé:
Vệ sinh đầu ti của chó mẹ 4 tiếng / 1 lần
Làm sạch cơ thể chó mẹ để hạn chế việc xâm nhập của vi trùng, vi khuẩn
Thắp bóng sưởi đủ nhiệt để giữ ấm cho chó con
Thường xuyên làm sạch và thay ổ vì chó con đái rất nhiều

Hãy thực hiện tốt các bước trên nếu không muốn thú cưng bị mắc bệnh và không muốn mầm bệnh này lây lan nhanh chóng ra các chú chó khác trong đàn nhé!', NULL, 10, 5, 1),
(1, N'Bài 6. Chó con mới đẻ cần được tiêm phòng', N'Dù trong sữa mẹ có nhiều kháng thể có lợi cho sức khỏe nhưng bạn vẫn nên đưa thú cưng đi tiêm phòng bởi đây chính là phương pháp an toàn và hiệu quả nhất để phòng bệnh và tăng sức đề kháng cho chó con.

Trước khi tiêm phòng, bạn nên hỏi cặn kẽ bác sĩ về kế hoạch tiêm để có thể thực hiện đầy đủ, đúng thời gian. Mũi tiêm đúng thời điểm sẽ phát huy hết công dụng và có thể bảo vệ tốt sức khỏe cho chó con.', NULL, 5, 6, 1),
(1, N'Bài 7. Hướng dẫn cách chăm sóc chó con mới đẻ tập ăn dặm', N'Sau một thời gian cho con bú, sữa của chó mẹ sẽ dần cạn kiệt và không đủ cung cấp dinh dưỡng cho chó con. Đồng thời, chó con cũng đang phát triển và cần nạp nhiều năng lượng hơn.
Khi chó con mở mắt được vài ngày, bạn có thể bắt đầu cho chúng làm quen với việc ăn dặm bằng món cháo nấu loãng với thịt. Sau khi chó con đã quen tiêu hóa các thức ăn ngoài, hãy bổ sung thêm rau, củ trong khẩu phần ăn của chúng hàng ngày.', NULL, 5, 7, 1),
(2, N'Bài 1: Chế độ dinh dưỡng cho chó con mới đẻ', N'Để chăm sóc chó con mới đẻ và đảm bảo sự phát triển tốt, các bạn cần chú ý cung cấp cho chúng nguồn dinh dưỡng đa dạng. Dưới đây là những gợi ý để chăm sóc chó con mới đẻ:

Trong 4 ngày đầu, bạn nên để chó con được bú sữa mẹ hoàn toàn để nhận kháng thể cần thiết. Hãy đảm bảo cho chó con được bú mẹ khoảng 2 tiếng một lần, mỗi lần khoảng 2-3 tiếng.

Từ 5-10 ngày tuổi, bạn có thể kết hợp cho chó con bú sữa mẹ và sữa công thức ấm để bổ sung dinh dưỡng.

Sau 11 ngày tuổi, bạn có thể bắt đầu cho chó con ăn cháo thịt bằm để cung cấp dưỡng chất và tăng cường sức đề kháng.

Ngoài ra, bạn cần lưu ý những điểm sau khi chăm sóc chó con:

Trong quá trình chăm sóc chó con mới đẻ, không chỉ quan tâm đến việc cho chúng bú mà còn cần theo dõi sự phát triển của chúng.
Nếu có điều kiện, nên sử dụng cân điện tử để theo dõi cân nặng của chó con hoặc để ý đến những con yếu hơn trong đàn. Nếu có con nhẹ cần được bổ sung sữa mẹ nhiều hơn, hãy đảm bảo chúng được bú thêm.
Để đảm bảo chăm sóc tốt nhất, hãy bổ sung rau củ chứa chất xơ và vitamin, nhằm thúc đẩy quá trình hình thành khung xương và phát triển sự trao đổi chất của chó con.
Luôn lưu ý rằng việc chăm sóc chó con mới đẻ đòi hỏi sự quan tâm và tận tâm. Do đó nếu có bất kỳ vấn đề nào, nên tham khảo ý kiến của bác sĩ thú y để đảm bảo sức khỏe và phát triển tốt cho chó con.
Trong trường hợp chó con kêu nhiều, có thể chúng đang đói do nguồn sữa mẹ không đủ. Bạn có thể bổ sung sữa công thức bằng cách đổ lên đĩa để chó con tự liếm. Một số loại sữa phù hợp gồm có:

PetAg Esbilac sữa bột 340gr cho chó sơ sinh: Sản phẩm này cung cấp dinh dưỡng hoàn hảo cho sự tăng trưởng, phù hợp sử dụng cho chó con từ 3 tháng tuổi trở lên, khi chúng đã có khả năng tiêu hóa thức ăn chó. Ngoài việc cung cấp chất dinh dưỡng, sữa còn hỗ trợ tăng cường hệ thống miễn dịch cho chó, giúp chúng có sức đề kháng cao để chống lại các bệnh phổ biến ở thú cưng.

Royal Canin BabyDog Milk sữa bột cho chó sơ sinh: Sản phẩm được bổ sung protein dễ tiêu hóa được lựa chọn kỹ lưỡng và có hàm lượng lactose gần tương tự như sữa chó mẹ. Điều này đặc biệt phù hợp với hệ tiêu hóa của chó con, vì nó không chứa tinh bột. Đặc biệt, sản phẩm được bổ sung Fructo-Oligo-Saccharides (FOS) giúp duy trì hệ thống tiêu hoá cân bằng và khỏe mạnh.

Dr.Kyan Predogen sữa bột cho chó: Sản phẩm được tạo ra theo công thức của WONDER LIFE PHARMA. Nó giúp cung cấp khẩu phần ăn ngon miệng hơn cho chó, bồi bổ cơ thể và cung cấp những dưỡng chất cần thiết để thú cưng phát triển toàn diện.

Trên đây là chia sẻ cách chăm sóc chó con mới đẻ của PetTech. Nếu bạn có nhu cầu mua sữa hay các sản phẩm thức ăn cho vật nuôi của mình, hãy liên hệ PetTech để được tư vấn.', 'https://youtube.com/embed/123', 20, 1, 1),
(3, N'Bài 1: Khi mèo mẹ sinh nở', N'Khi mèo mẹ gần chuyển dạ bạn nên chuẩn bị cho chúng một ổ để êm ái và gần gũi, nói chuyện với chúng để mèo nhà bạn yên tâm chuyển dạ.
Nhưng đặc biệt khi lúc sinh, bạn nên đứng quan sát từ xa, hạn chế việc lại gần gây mất tập trung cho mèo mẹ. Song, bạn nên chuẩn bị một tô cháo loãng để mèo mẹ lấy lại sức sau khi sinh.', NULL, 3, 1, 1),
(3, N'Bài 2: Dinh dưỡng cho mèo mẹ', N'Sau khi sinh xong là thời điểm bạn nên quan tâm đến chế độ dinh dưỡng của chúng bởi mèo mẹ đang cần nhiều sữa để cho mèo con, Thế nên, bạn nên cung cấp những loại thức ăn cho mèo hoặc thực phẩm mềm, dễ tiêu hóa có chứa hàm lượng tinh bột, protein và các dưỡng chất cần thiết khác.', 'https://youtube.com/embed/456', 2, 2, 1),
(3, N'Bài 3: Dinh dưỡng cho mèo con', N'Với mèo con sau dinh thì chất dinh dưỡng tốt nhất đó chính là sữa mẹ, vì thế ở giai đoạn này bạn không cần can thiệp quá nhiều về chế độ dinh dưỡng của chúng. Nhưng bạn cũng phải quan sát nếu mèo mẹ không đủ sữa cung cấp thì bạn có thể hỗ trợ nguồn sữa ngoài cho chúng.', 'https://youtube.com/embed/456', 2, 3, 1),
(3, N'Bài 4: Tập cho mèo con đi vệ sinh', N'Việc tập cho mèo con đi vệ sinh thường là thiên chức của mèo mẹ, nhưng bạn cũng có thể hỗ trợ chúng bằng việc đặt mèo con vào khay cát chuyên dụng để mèo nhận biết được vị trí và để mèo tập cào cát và lấp chất thải.
Bạn hãy kiên nhẫn lập lại việc này khoảng 3 - 4 lần thì mèo con sẽ tự nhận biết và trở thành thói quen, giúp việc chăm sóc mèo trở nên dễ dàng hơn.', 'https://youtube.com/embed/456', 2, 4, 1),
(4, N'Bài 1: Làm ổ cho mèo', N'Với mèo con mất mẹ bạn cần chú ý và cẩn thận nhiều hơn, bạn nên làm tổ cho mèo con phải thật sự đủ ấm và an toàn, tránh các tác động của tự nhiên hay các vật nuôi khác.
Tốt nhất bạn nên sử dụng các hộp giấy có thành cao để làm ổ cho mèo, bên trong có lót chăn hay vải mềm để tạo sự thoải mái cho mèo và phải đảm bảo mức nhiệt độ khoảng 37 độ C để giữ ấm cho mèo.', 'https://youtube.com/embed/456', 2, 1, 1),
(4, N'Bài 2: Cho mèo con uống sữa', N'Với giai đoạn này thì sữa là nguồn dinh dưỡng thiết yếu dành cho chúng. Nếu không có nguồn sữa mẹ thì bạn có thể cung cấp từ nguồn sữa ngoài theo chế độ sau:
- Mèo con dưới 2 tuần tuổi: Bạn nên cho mèo con dùng sữa 3 lần/ngày và lượng sữa là 2-5ml/lần.
- Mèo con dưới 4 tuần tuổi: Cho mèo dùng 4-5 lần mỗi ngày và khoảng 7ml/lần.
- Mèo 2-3 tháng tuổi: Ngoài sữa bạn có thể tập cho chúng các loại thức ăn mềm, tần suất dùng sữa giảm lại (2 lần/ngày).', 'https://youtube.com/embed/456', 5, 2, 1),
(5, N'Sữa Bột Bio Milk For Pet cho mèo sơ sinh', N'Sữa bột Bio Milk For Pet là loại sữa được sử dụng phổ biến cho mèo sơ sinh, mèo dưới 2 tháng tuổi, đây là một loại sữa thay thế của Bio Pharmachemie Việt Nam. Loại sữa này được sản xuất với quy trình khép kín và được nhiều chuyên gia đánh giá cao.

Thành phần của sữa bột Bio Milk For Pet bao gồm các chất dinh dưỡng như Protein, chất béo, chất xơ, canxi, vitamin (A, E, B1, B12,...),..

Với thành phần có các chất dinh dưỡng thiết yếu như vậy, có tác dụng giúp cho các bé có được một hệ tiêu hóa ổn định, bổ sung đầy đủ các chất dinh dưỡng cần thiết.

Hướng dẫn sử dụng:
- Cho mèo con dưới 1 tháng tuổi: Hoàn tan 1 muỗng cafe (5g) sữa với 20ml nước ấm, cho mèo bú ngày 4-5 lần.
- Mèo con từ 1 - 2 tháng tuổi: 1 muỗng cafe (5g) sữa với 15ml nước ấm, bạn có thể đúc hoặc cho mèo tự uống ngày 3-4 lần.

Giá bán: 35.000 đồng/100gr', 'https://youtube.com/embed/456', 5, 1, 1),
(5, N'Sữa bột cho mèo con Petlac', N'Sữa bột cho mèo con Petlac có nguồn gốc đến từ nước Mỹ, thích hợp cho mèo sơ sinh, mèo con. Nó đóng vai trò như một lại sữa mẹ giúp cho mèo con có đầy đủ chất dinh dưỡng cần thiết và dòng sữa được các chuyên gia khuyên dùng cho mèo con khi mèo mẹ mất sữa hoặc mèo con mất mẹ.

Thành phần của sữa bột cho mèo con Petlac cũng đầy đủ các chất dinh dưỡng như bột sữa sấy khô, dầu thực vật, bột kem béo, khoáng chất, vitamin (A, B12, E, D3,...) và một số thành phần dưỡng chất khác.

Sữa bột này có hương vị thơm ngon, mèo con dễ uống, cung cấp các chất dinh dưỡng đầy đủ, đảm bảo cho mèo con mau lớn, phát triển toàn diện.

Hướng dẫn sử dụng:
- Cho mèo sơ sinh: Pha sữa theo tỉ lệ 1 sữa, 2 nước, mỗi ngày cho mèo bú 15ml – 25ml sữa PetLac 5 – 6 lần, cho bú lại sau mỗi 2 – 3 giờ.
- Cho mèo con, lớn hơn 2 tháng: Pha theo tỉ lệ 1 - 4 tùy theo khẩu vị và nhu cầu dinh dưỡng của mèo.

Giá bán: 250.000 đồng/300gr', 'https://youtube.com/embed/456', 7, 2, 1),
(5, N'Sữa Royal Canin Babycat Milk', N'Sữa Royal Canin Babycat Milk là dòng sản phẩm sữa được sử dụng riêng cho mèo con từ 0 đến 2 tháng tuổi với công thức sản xuất mới từ nhà máy sản xuất của nước Pháp xinh đẹp. Hiện nay dòng sản phẩm sữa này đang phổ biến trên thị trường và nhiều khách hàng tin dùng về chất lượng của sữa này.

Thành phần chính của sữa này bao gồm các thành phần: Protein sữa, chất béo sữa, dầu thực vật, dầu cá và khoáng chất. Ngoài ra còn có các chất phụ gia dinh dưỡng như vitamin (A, D3, E1, E2, E4, E5, E6, E8) và chất chống oxy hóa.

Với thành phần đầy đủ các chất dinh dưỡng cho mèo con nhằm giúp cho mèo phát triển cơ thể hài hòa, cân đối và khỏe mạnh, có một hệ tiêu hóa ổn định, giúp cho mèo hấp thụ các chất dinh dưỡng nhanh hơn và trong dầu cá bổ sung DHA giúp cho mèo có một hệ thần kinh phát triển.

Hướng dẫn sử dụng: Pha 10ml bột kèm với 20ml nước ấm

Giá bán: 561.000 đồng/300gr', 'https://youtube.com/embed/456', 8, 3, 1),
(5, N'Sữa bột cho mèo Dr.Kyan Precaten', N'Khi nhắc đến thương hiệu Dr.Kyan Penaten là một thương hiệu nổi tiếng về các sản phẩm của thú cưng và sữa bột cho mèo của thương hiệu này được sản xuất từ công nghệ của Wonder Life Pharma, một trong số những công ty phát triển hàng đầu của Mỹ với công thức riêng biệt.
Thích hợp cho mèo sơ sính đến mèo con 1 - 2  tháng tuổi.

Thành phần của sữa bột cho mèo Dr.Kyan Precaten đầy đủ các chất dinh dưỡng thiết yếu cho mèo như sữa bột nguyên kem, sữa bột gầy, chất xơ, protein, vitamin (C, K1, B6, B1, B2, D3, A, B12, Axit Pantothenic),...

Công dụng của dòng sữa này giúp cho mèo kích thích thèm ăn, xương chắc khỏe, bộ lông mềm mượt hơn, chất xơ tự nhiên giúp hệ tiêu hóa khỏe mạnh.

Hướng dẫn sử dụng:
- Cho mèo dưới 1 tháng tuổi: Pha 3 muỗng sữa bột vào 30ml nước ấm, chia thành 4-6 lần, cho bú hoặc để mèo tự ăn hết trong ngày.
- Cho mèo từ 1 - 2 tháng tuổi: Pha 6 muỗng sữa bột với 60ml nước ấm, chia thành 3-3 lần ăn trong ngày .

Giá bán: 180.000 đồng/400gr', 'https://youtube.com/embed/456', 7, 4, 1),
(5, N'Sữa bột Birthright cho mèo con', N'Đây là sản phẩm sữa bột đến từ nhãn hàng Ralco Nutrition của Mỹ, được xem là một sản phẩm sữa bột thay thế sữa mẹ cho mèo con sơ sính đến 2 tháng tuổi. Dòng sữa này sản xuất bổ sung các chất dinh dưỡng hoàn chỉnh cho mèo con.

Thành phần chính của sữa: Whey sấy khô, sữa tách béo sấy khô, chất béo, dầu dừa, các loại axit amin, vitamin (B12, A, D3, E, K), khoáng chất và các loại tinh dầu tự nhiên với hàm lượng như dòng sữa mẹ.

Birthright có tác dụng bổ sung các chất dinh dưỡng cho mèo con khi mèo con bị bỏ rơi hoắc mất mẹ, mèo mẹ bị mất sữa do đàn con quá đông, hạn chế mèo con bị thấp còi, chậm lớn và biếng ăn.

Hướng dẫn sử dụng:
- Cho mèo con dưới 1 tháng tuổi: hòa 1 muỗng cafe sữa với 20ml nước ấm, cho bú ngày 4-5 lần.
- Cho mèo từ 1-2 tháng tuổi: hòa 1 muỗng cafe (5g) sữa với 15ml nước ấm, cho ăn ngày 3-4 lần.

Giá bán: 35.000 đồng/100gr', 'https://youtube.com/embed/456', 2, 5, 1),
(5, N'Sữa bột CocoKat Milk Replacer', N'Sữa bột CocoKat Milk Replacer khá nổi tiếng và có nguồn gốc từ Thái Lan được sản xuất với 95% là sữa bột nguyên chất nên được nhiều bạn nuôi thú cưng ưa chuộng.

Thành phần chính: 95% sữa bột nguyên chất và 5% chất bổ sung đường huyết có hàm lượng protein đạt trên 20% có trong sữa.

Công dụng chính của dòng sữa này giúp cho mèo cân đối và dễ tiêu hóa, thay thế cho sữa mẹ trong trường hợp sữa mẹ không đủ do đàn con quá đông.


* Hỗ trợ mèo con đi vệ sinh
Bạn cũng nên đặt mèo con vào khay cát vệ sinh để mèo tập cào và lấp chất thải sau khi vệ sinh. Việc này sẽ giúp mèo nhận biết được nơi vệ sinh và những việc cần làm trước và sau đi vệ sinh. Việc này sẽ giúp bạn nhẹ nhàng hơn trong việc vệ sinh của mèo.

* Nên tránh âu yếm vuốt ve khi mèo còn quá nhỏ
Việc âu yếm chúng thường xuyên là điều không nên vì cơ thể chúng còn nhỏ, đề kháng còn yếu nên việc làm này có thể khiến chúng khó thích nghi và chậm phát triển so với bình thường.', 'https://youtube.com/embed/456', 2, 6, 1),
(6, N'Bài 1: Tiêm phòng cho mèo con', N'Tiêm phòng cho mèo con từ nhỏ là cách chúng ta bảo vệ sức khỏe cho mèo con, giúp chúng có hệ miễn dịch tốt nhất.

Trước khi đưa mèo về, bạn hãy kiểm tra kỹ càng tình trạng sức khỏe và tìm hiểu cẩn thận những mũi tiêm mà mèo đã được tiêm như: vacxin phòng bệnh care, parvo, dại…
Nếu mèo con chưa được tiêm phòng, bạn hãy nhanh chóng mang chúng đến những cơ sở thú ý để được bác sĩ thực hiện tiêm phòng.
Những mũi tiêm phòng không chỉ giúp chúng có sức đề kháng tốt mà còn hạn chế tỷ lệ mắc bệnh nguy hiểm cho đàn mèo con sau này.
Bạn không nên thực hiện tiêm phòng cho mèo trong giai đoạn làm quen và tiếp xúc với môi trường mới vì nó sẽ không đem lại hiệu quả cao.', 'https://youtube.com/embed/456', 2, 1, 1),
(6, N'Bài 2: Tẩy giun và diệt bọ chét cho mèo con', N'Tẩy giun cho mèo từ sớm để loại bỏ giun từ mèo mẹ sang mèo con. Mỗi cách tẩy giun phụ thuộc vào độ tuổi sẽ có quy trình cùng sản phẩm hỗ trợ khác nhau.

Vì vậy, hãy đưa ra những lựa chọn đúng đắn để chú mèo được khỏe mạnh.

Ví dụ, phương pháp để diệt bọ chét và sâu là sử dụng sản phẩm như: Stronghold của Anh, Revolution của Mỹ…để thoa lên phần da ở sau gáy, tối đa 2 lần một tháng.', 'https://youtube.com/embed/456', 2, 2, 1),
(6, N'Bài 3: Huấn luyện và các bệnh thường gặp ở mèo con', N'Huấn luyện mèo con đi vệ sinh đúng chỗ:

Bước 1: Cho mèo ngồi vào bên trong, ngửi và kiểm tra khay vệ sinh của mèo.

Bước 2: Ngay sau khi ăn và ngủ dậy, hãy cho mèo vào một trong các nhà vệ sinh. Nếu bạn nhận thấy mèo có dấu hiệu cần rời đi, hoặc nếu bạn đang đánh hơi hoặc ngồi xổm ở một vị trí cụ thể, hãy nhấc nó lên và cho vào bồn cầu.

Bước 3:Thưởng cho mèo nếu bạn nhận thấy mèo đi vệ sinh trong khay.

Bước 4: Nếu mèo gặp khó khăn khi đi vệ sinh, đừng trừng phạt hay la mắng mèo. Làm như vậy sẽ chỉ dẫn đến căng thẳng và lo lắng, điều này sẽ làm trầm trọng thêm vấn đề và khiến việc sử dụng cát để huấn luyện mèo trở nên khó khăn hơn.', 'https://youtube.com/embed/456', 10, 3, 1),
(6, N'Bài 4: Các bệnh thường gặp ở mèo con', N'
- Sán dây: Bác sĩ thú y thường điều trị sán dây ở mèo con bị bọ chét truyền bệnh. Tuy nhiên, bạn có thể được yêu cầu lấy mẫu phân mèo con vì bạn dễ bị nhiễm các loại ký sinh trùng khác như nấm ngoài da.

- Nhiễm trùng đường hô hấp trên: Nhiễm trùng đường hô hấp trên bao gồm vi-rút viêm ống thở ở mèo và vi-rút calicivirus ở mèo. Cả hai loại vi-rút đều có vắc-xin cốt lõi. Vi rút này gây ra hắt hơi, sổ mũi và viêm kết mạc (thường được gọi là đau mắt đỏ).

- Bệnh viêm phúc mạc ở mèo (FIP): Đây là bệnh phổ biến ở những khu vực nhiều mèo, nhưng cũng xảy ra ở mèo con có khuynh hướng di truyền. Tiếp xúc với coronavirus có thể gây ra nhiều loại bệnh, nhưng một số con mèo bị nhiễm thực sự có thể phát triển FIP vì virus cần phải đột biến để gây bệnh. Khuyết điểm là khi đã nhiễm bệnh sẽ chết.

PetTech đã gửi đến bạn thông tin về cách nuôi và chăm sóc mèo con mới đẻ đơn giản nhất. Nếu bạn đang chuẩn bị nuôi một chú mèo thì lượng kiến thức này là vô cùng cần thiết nhé!', 'https://youtube.com/embed/456', 2, 4, 1),
(7, N'Bài 1: Các bước vệ sinh cho chó', N'
1. Chuẩn bị dụng cụ. Bạn nên xếp sẵn đồ đạc trước khi bắt đầu chải chuốt cho cún cưng nhằm tạo điều kiện thuận lợi cho cả hai.
- Chải lông cho chó trước. Bạn nên thực hiện hằng ngày hoặc cách ngày để bộ lông của chó luôn bóng mượt. Cách chải nhanh đơn giản không thể gỡ rối hết vì những chỗ lông chó bị kẹt trong lược dễ bị bỏ qua. Bạn nên chải thật kỹ trước khi vệ sinh cho thú cưng vì phần lông rối sẽ khó xử lý hơn sau khi khô ráo. Bắt đầu chải từ phần đầu dọc xuống cơ thể. Cẩn thận khi chải lông phần bụng vì đây là khu vực nhạy cảm, cũng như không nên bỏ sót lông đuôi. Trong lúc chải lông, gặp phần nào rối thì bạn cần dùng lược xử lý triệt để. Không nên chỉ tập trung chải một chỗ khiến chú cún rát da. Thay vào đó, bạn có thể thử nghiệm lên vùng da nhạy cảm của mình để hiểu rõ cảm giác của thú cưng
Bạn có thể dùng bàn chải dành cho ngựa hoặc găng tay để chải lông cho giống chó lông ngắn.

  Đối với chó lông dài thì nên chải bằng lược thép, bàn chải mát-xa, bàn chải nhựa, hoặc bàn chải được thiết kế loại bỏ lớp lông rụng bên dưới.

  Dù là loại bàn chải nào, chúng phải có tác dụng gỡ phần lông rụng và tán đều dầu từ da sang toàn bộ lông chó.

  Cho chú cún giải lao nếu cần. Bạn không nên tạo áp lực cho chúng, vì điều này rất dễ tạo nên trải nghiệm không tốt khiến cho việc chải chuốt sau này trở nên khó khăn hơn. Bạn có thể mang lại niềm vui cho thú cưng bằng cách cho chúng giải lao, khen ngợi, thưởng đồ ăn, vuốt ve, và thậm chí là chơi đùa với chúng.
2. Bước này cực kỳ quan trọng đối với chó con, những chú cún được huấn luyện từ nhỏ để làm quen với thao tác này.

  Cắt bỏ phần lông rối không thể gỡ ra được. Lông bù xù nhiều có thể kéo mạnh da chó mỗi khi di chuyển khiến chúng cảm thấy đau đớn. Nếu không thể gỡ rối, bạn có thể cắt bớt hoặc cạo phần lông đó, tùy vào khoảng cách có gần bề mặt da hay không. Bạn nên cẩn thận khi dùng kéo cắt để tránh làm tổn thương bản thân và/hoặc thú cưng. Cắt song song với chiều mọc của lông để tránh tình trạng lông mọc lởm chởm.

  Nếu không chắc mình có thể loại bỏ phần lông rối một cách an toàn, bạn nên đưa chú cún đến gặp người chuyên vệ sinh cho chó để họ thực hiện thao tác này.

  Đôi lúc phần lông rối xoắn chặt và ép vào da chó gây nhiễm khuẩn dưới lớp lông. Nếu nghi ngờ viêm nhiễm, bạn cần đưa chú cún đi khám bác sĩ thú y càng sớm càng tốt.

  Triệu chứng nhiễm khuẩn có thể quan sát bằng mắt thường đó là đỏ tấy và ẩm ướt, trong trường hợp nặng có thể rỉ mủ. Chú cún có thể gặm hoặc gãi vào khu vực này vì rất ngứa.

3. Vệ sinh mắt cho chó. Giống chó lông trắng hoặc có mắt to hay chảy nước mắt (Chó Bắc Kinh, chó Púc, chó Phốc sóc, v.v…) cần được chăm sóc cẩn thận hơn những giống khác. Tùy vào từng giống chó, bạn có thể loại bỏ ghèn mắt tích tụ trong hốc mắt. Còn chó lông dài hoặc lông trắng cần lưu ý đặc biệt phải lau sạch chất nhầy trên lông, vì nước mắt chảy ra có thể bám lại trên lông. Bạn có thể mua sản phẩm dùng để vệ sinh "gỉ mắt" tại cửa hàng vật nuôi.

  Đôi mắt khỏe mạnh cần phải trong suốt và không có dấu hiệu kích ứng hoặc dịch tiết bất thường.

  Không nên tự tỉa lông xung quanh mắt vì bạn có thể làm tổn thương thú cưng. Hãy đưa chúng đến bác sĩ thú y hoặc người chăm sóc chuyên nghiệp để làm thay.

4. Vệ sinh tai cho chó. Tai có thể xuất hiện ít ráy tai, nhưng không nên có mùi lạ. Để vệ sinh tai cho chó, bạn dùng bông gòn thấm dung dịch vệ sinh (mua tại cửa hàng vật nuôi) rồi lau sạch bụi bẩn và ráy tai phía trong, nhưng không nên chà mạnh làm cho thú cưng bị đau. Ngoài ra, bạn cũng không nên lau quá sâu bên trong tai. Nguyên tắc vệ sinh là chỉ lau những gì mà bạn thấy.

  Làm ấm dung dịch vệ sinh tai bằng nhiệt độ cơ thể trước khi dùng cho thú cưng. Nhúng chai dung dịch vào nước ấm, giống như khi làm ấm bình sữa em bé.

  Sau khi dùng bông gòn hoặc khăn ẩm lau sạch tai, bạn nên tiếp tục lấy bông gòn hoặc khăn khô thấm nhẹ nước còn sót lại.

5. Chải răng cho chó. Bạn nên vệ sinh răng cho vật nuôi hằng ngày bằng kem đánh răng dành cho chó để giúp chúng có được hàm răng và nướu khỏe mạnh. Không nên dùng sản phẩm dành cho người. Kem đánh răng dành cho người có thể gây ngộ độc cho chó vì có chất fluoride . Nếu chú chó cắn bạn, bạn KHÔNG NÊN cố gắng chải răng cho chúng. Trong khi chải răng cho chó, nếu bất cứ lúc nào chúng cảm thấy khó chịu, bạn nên nghỉ một lúc để giúp chú cún bình tĩnh lại.

  Bắt đầu bằng cách cho một lượng nhỏ kem đánh răng lên ngón tay và thoa đều lên hàm răng chó trong vài giây. Thưởng cho chú cún vì đã cho phép bạn làm điều này.

  Sau khi chà kem đánh răng khoảng 20-30 giây, bạn có thể chuyển sang dùng gạc hoặc bàn chải ngón tay mua tại cửa hàng vật nuôi, sau đó dùng bàn chải dành cho chó.

  Trong mọi trường hợp, bạn cần dỗ dành chú cún hợp tác để chúng có trải nghiệm tốt đẹp thay vì cảm thấy căng thẳng.

6. Cắt móng cho chó. Nếu không được cắt, móng sẽ mọc dài và đâm vào đệm thịt hoặc siết chặt ngón chân gây tổn hại khớp xương. Bạn cần cắt tỉa móng cho chó thường xuyên để duy trì độ dài thích hợp, tùy thuộc vào tốc độ mọc của móng. Nếu bạn nghe tiếng móng chạm đất thì có nghĩa là móng đã mọc quá dài. [5]

  Dùng kìm cắt móng bấm một ít đầu móng (15 mm). Đối với chó con hoặc chó nhỏ thì bạn có thể dùng kìm dành cho người dạng kìm kéo thay vì kìm xén. Ngoài ra, bạn cũng nên chọn loại kìm với kích thước phù hợp dành cho chó con.

  Nếu móng có màu trong suốt, bạn sẽ thấy phần màu hồng nơi có mạch máu. Tránh cắt vào phần này mà chỉ tỉa phần móng cứng không màu.

*Lưu ý đặc biệt với móng có màu sậm để tránh cắt phải mạch máu. Thực hiện chậm rãi, và mỗi lần chỉ nên cắt từng ít một. Máy tỉa thường an toàn và không làm tổn thương thịt mềm, vì mỗi lần chỉ cắt một phần nhỏ của móng. Dùng dụng cụ tỉa an toàn dành cho thú cưng không có dây, vì loại có dây sẽ không ngừng hoạt động khi chạm vào lông.

Nếu cắt quá sâu và đụng phải mạch máu, bạn có thể dùng bột cầm máu, bột bắp, hoặc bột mì dặm lên vết thương để ngăn máu không tiếp tục chảy.', 'https://youtube.com/embed/456', 45, 1, 1),
(7, N'Bài 2: Tắm cho chó', N'
1. Chuẩn bị dụng cụ. Bạn cần xếp sẵn vật dụng thay vì chạy quanh đi tìm đồ đạc trong lúc chú cún đang ướt đẫm người. Hơn nữa, bạn nên mặc quần áo mà bạn không ngại bị bẩn vì sẽ không tránh khỏi bị ướt. Sau đó, bạn hãy chuẩn bị ít nhất những dụng cụ sau: 
	
	Dầu gội dành cho chó
	Thức ăn vặt
	Vài chiếc khăn

	Bước 1: Trải một chiếc khăn lên cạnh bồn để nước không văng ra ngoài, còn những khăn khác dùng để lau khô thú cưng.

	Bước 2: Trải miếng chống trượt dưới đáy bồn. Bề mặt của bồn tắm thường rất trơn trượt nếu dính xà phòng. Để chú cún không bị trượt ngã, bạn nên trải khăn hoặc miếng chống trượt dưới đáy bồn.

	Bước 3: Xả nước ấm vào bồn. Nước nóng có thể làm tổn hại đến da chó, đặc biệt nếu chúng có lông ngắn. Không nên xả nước khi chú cún đang ở trong bồn vì điều này có thể làm chúng căng thẳng. Bạn nên dành thời gian tập cho thú cưng làm quen với âm thanh của tiếng nước chảy bằng món ăn ưa thích của chúng. Luôn thực hiện từ từ để tránh gây áp lực cho chú cún và khó khăn cho cả hai.
	(Bạn có thể hòa một ít dầu gội vào 20 lít nước âm ấm để rút gọn quy trình.)

	*Bảo vệ chú chó trong bồn tắm. Một số con chó muốn chạy ra ngoài trong lúc tắm. Nếu thú cưng có hành vi như vậy, bạn có thể mua dây xích đặc biệt dành cho chó tại cửa hàng vật nuôi. Loại dây này được gắn vào thành tường bằng miếng hút và giữ thú cưng ở vị trí cố định trong lúc tắm rửa.
2. Thay vòng cổ thông thường bằng loại không thấm màu ra bộ lông hoặc bị hư hại khi gặp nước.
	
	Làm ướt lông cho chú cún kỹ lưỡng. Bạn cần bảo đảm toàn bộ phần lông ướt đều trước khi thoa dầu gội. Nếu chó không sợ hãi, bạn có thể dùng vòi nước và bộ điều áp nước gắn lên vòi. Điều này khá hữu ích với chó có kích thước lớn hoặc bộ lông có hai lớp. Tuy nhiên, nếu thú cưng sợ tiếng nước chảy, bạn nên dùng cốc hoặc xô để giội nước trong bồn tắm lên cơ thể của chúng. KHÔNG làm văng nước vào tai chó để tránh gây viêm nhiễm. Bạn chỉ nên xịt nước đến ngang phần cổ của chúng. Còn đầu chó sẽ được làm sạch riêng.
	
	Thoa dầu gội tắm lên cơ thể của chó. Bắt đầu từ phần cổ, di chuyển xuống hai bên thân người và bốn chân, dùng ngón tay thoa đều dầu gội xuống tận lớp da chó. Phần đầu có thể chừa lại để vệ sinh sau, và không thoa xà phòng quanh tai và mắt (trừ khi dùng dầu gội khô dành cho chó). Thay vào đó, bạn có thể dùng khăn ẩm để lau đầu cho chó. Sau khi thoa dầu tắm, bạn hãy cào nhẹ lên phần lông hai lớp của chú cún để dầu tắm phân tán đều và lưu ý không cào một chỗ quá lâu. Bạn nên thử tập trước để xem cảm nhận của mình như thế nào.
	
	Pha loãng dầu tắm để dễ thoa đều và xả sạch hơn.
	
	Xả sạch dầu tắm thật kỹ. Nếu vẫn còn thấy nước bẩn hay bong bóng xà phòng chảy ra ngoài, bạn cần tiếp tục xả nước như khi làm ẩm lông trước khi thoa dầu. Tuy nhiên, bạn cần lưu ý rằng không dùng nước chảy trực tiếp nếu chú cún sợ âm thanh này. Thay vào đó, bạn chỉ cần dùng cốc giội nhẹ nước để rửa sạch dầu.
	
	Thấm khô chú cún. Dùng nùi cao su hoặc tay để vuốt nước ra khỏi lông và cơ thể chó. Dùng khăn lau khô hết mức có thể trong lúc thú cưng còn ở trong bồn tắm để không bị văng nước lên người. Trải khăn lên lưng chó, hoặc cầm khăn đặt bên cạnh chúng để cho phép chú cún tự giũ nước ra khỏi cơ thể. Nhiều chú chó sẽ học được “quy định tắm rửa” và chỉ lắc mình khi bạn trải khăn lên người chúng để thấm khô nước. Nếu thú cưng có bộ lông ngắn hoặc bạn thích để khô tự nhiên thì có thể bỏ qua bước này.
	
	*Nếu chú cún có hai lớp lông hoặc lông dài, bạn cần dùng máy sấy để sấy khô hoàn toàn.
	
	Sấy khô nếu cần thiết. Trong trường hợp khăn không thể lau khô nước, bạn có thể sấy khô mà không làm chú cún cảm thấy quá nóng hoặc khô ráp. Nếu chú chó có bộ lông dài, bạn cần sấy khô kết hợp dùng lược chải.
	
	*Đặt máy sấy ở chế độ mát! Bước này khiến cho việc sấy khô lâu hơn bình thường, nhưng bù lại lông và da chó sẽ không bị khô cứng.
	
	*Nếu chú cún sợ âm thanh hoặc cảm giác khi tiếp xúc với máy sấy, bạn không nên ép buộc chúng. Thay vào đó, hãy dùng khăn lau và dắt chó vào nơi phù hợp để lông chó khô tự nhiên, chẳng hạn như trong phòng giặt.', 'https://youtube.com/embed/456', 25, 2, 1),
(7, N'Bài 3: Tỉa lông chó', N'
1. Cân nhắc tỉa lông cho thú cưng. Nhiều giống chó có lông ngắn và không cần phải cắt tỉa thường xuyên. Tuy nhiên, nếu chú cún có bộ lông dày, bạn cần tỉa thường xuyên để chúng luôn khỏe mạnh. Những giống chó cần tỉa lông thường xuyên bao gồm cocker spaniel, chó chăn cừu, chó xù, collie, chó sư tử, chó Bắc Kinh, và Đường Khuyển.

	Tỉa lông cho chó sau khi khô ráo. Nếu có ý định cắt tỉa lông thú cưng, bạn nên đọc kỹ hướng dẫn đi kèm dụng cụ cắt. Đọc sách hoặc xem video chỉ dẫn, hoặc tham khảo ý kiến người vệ sinh chuyên nghiệp về cách dùng dụng cụ cắt tỉa phù hợp. Lưỡi cắt phải sắc và dụng cụ xén cần được bôi trơn. Lưỡi cùn có thể kéo giật lông của thú cưng.

	Trước khi tỉa lông cho chó, bạn cần đưa ra ý tưởng tạo hình trước. Đọc, đưa ra câu hỏi và xem video để tham khảo ý kiến rồi tiến hành công việc.

	Nhẹ nhàng cố định chú cún. Dùng dây xích buộc lại để chúng không chạy quanh. Trong lúc tỉa lông, bạn có thể đặt một tay dưới bụng của thú cưng để khuyến khích chúng ở yên vị trí thay vì cựa quậy liên tục.
	
	Dùng tông đơ đặc biệt dành cho chó. Bạn nên đầu tư cho một chiếc tông đơ chất lượng cao. Số tiền ban đầu có thể khá đắt, nhưng về sau lại có tác dụng tiết kiệm, vì bạn sẽ không phải tốn tiền cho dịch vụ chăm sóc thú cưng chuyên nghiệp.
	
	Dùng lưỡi tông đơ tạo độ dài của lông theo ý muốn.
	
	Kéo không có tác dụng tỉa lông thành hình và đẹp mà lại có nguy cơ làm tổn thương chú cún nếu bạn di chuyển đột ngột. Bạn nên dùng tông đơ thay cho kéo.
	
	Bạn có thể yên tâm di chuyển lưỡi cắt trên cơ thể của thú cưng, chỉ cần không ấn mạnh vào da. Chải lông ngược theo chiều mọc trước khi chạy tông đơ theo hướng kia, tức là hướng theo chiều mọc của lông. Di chuyển tông đơ ngược theo chiều mọc của lông có tác dụng giống như chải lông theo chiều ngược, nhưng sẽ có độ dài ngắn hơn so với khi dùng lưỡi tông đơ. Nếu muốn cạo ngược theo chiều mọc của lông, bạn nên thử lên phần bụng để xem độ dài như vậy đã phù hợp hay chưa. Di chuyển tông đơ cố định, nhưng phải từ từ dọc theo cơ thể của chú cún để loại bỏ phần lông thừa. Di chuyển quá nhanh sẽ làm cho đường cắt không đều. Luôn di chuyển lưỡi cắt theo hướng mọc của lông trừ khi muốn cắt ngắn hơn chiều dài tiêu chuẩn của lưỡi tông đơ. Bắt đầu với phần cổ, sau đó di chuyển xuống vai, dưới tai, và hướng về phía cằm, cổ họng, và vùng ngực. KHÔNG tỉa phần lông ở khu vực cổ họng hoặc bất kỳ vị trí trên cơ thể có khoảng cách hẹp, chẳng hạn như dây chằng trên gót chân, vùng da dưới cánh tay, bộ phận sinh dục, phần chóp đuôi, hoặc hậu môn. Sau đó, bạn sẽ tỉa phần lông ở lưng và hai bên thân mình chó và cuối cùng là bốn chân.

	Cẩn trọng khi tỉa lông xung quanh hậu môn. Bộ phận này có thể bật ra, giống như nút bấm, bất ngờ và bạn sẽ vô tình cắt phải. Do đó bạn nên lường trước vấn đề này.

	Cẩn thận khi tỉa lông ở chân, đuôi và mặt chó. Đây là những bộ phận rất nhạy cảm.

	Kiểm tra tông đơ thường xuyên để đảm bảo nhiệt độ không quá nóng làm tổn thương da của chú cún.
	
	Nếu lưỡi cắt nóng lên, bạn nên ngừng lại và để nguội và/hoặc dùng sản phẩm xịt làm mát và có tác dụng loại bỏ lớp dầu ra khỏi lưỡi cắt khiến nhiệt độ nóng lên nhanh hơn, vì thế bạn nên chuẩn bị thêm lưỡi cắt hoặc chờ cho đến khi nhiệt độ hạ thấp.

Kiên nhẫn. Bạn cần phải rà nhiều đường trên lông chó mới có được đường cắt mềm mịn và thẳng tắp. Không nên vội vàng! Cho phép thú cưng nghỉ ngơi càng nhiều càng tốt, và phải di chuyển tông đơ nhẹ nhàng.', 'https://youtube.com/embed/456', 20, 3, 1);

-- 14. Tài liệu đính kèm (đã thêm status)
INSERT INTO lesson_attachments (lesson_id, file_name, file_url, file_size, status)
VALUES
(3, N'Hướng dẫn dinh dưỡng.pdf', '/uploads/guides/nutrition.pdf', 1024, 1),
(5, N'Cẩm nang sơ cứu.pdf', '/uploads/guides/first_aid.pdf', 2048, 1);

-- 15. Blog (đã thêm status)
INSERT INTO Blogs (title, content, short_description, image_url, category_id, is_featured, status)
VALUES
(N'10 cách chăm sóc mèo đúng cách', N'Nội dung chi tiết...', N'Hướng dẫn chăm sóc mèo đúng cách', 'images/Blog/blog1.jpg', 1, 1, 1),
(N'Thức ăn tốt nhất cho chó con', N'Nội dung chi tiết...', N'Chọn thức ăn phù hợp cho chó con', 'images/Blog/blog2.jpg', 2, 1, 1),
(N'Dấu hiệu bệnh thường gặp ở mèo', N'Nội dung chi tiết...', N'Nhận biết các dấu hiệu bệnh ở mèo', 'images/Blog/blog3.jpg', 3, 0, 1);

-- 16. Đơn hàng (đã có status)
INSERT INTO orders (user_id, total_amount, commission, status)
VALUES 
(1, 350000, 10500, N'completed'),
(2, 120000, 3600, N'completed'),
(3, 500000, 15000, N'processing');

-- 17. Chi tiết đơn hàng (đã thêm status)
INSERT INTO order_items (order_id, product_id, quantity, price, status)
VALUES 
(1, 1, 1, 350000, 1),
(2, 2, 1, 120000, 1),
(3, 1, 1, 350000, 1),
(3, 3, 2, 89000, 1);

-- 18. Thanh toán (đã có status)
INSERT INTO payments (user_id, order_id, payment_method, amount, status, transaction_id)
VALUES 
(1, 1, 'VNPAY', 350000, 'completed', 'VNPAY123456'),
(2, 2, 'MOMO_QR', 120000, 'completed', 'MOMO654321');

-- 19. User Service Packages (đã có status)
INSERT INTO User_Service (user_id, package_id, start_date, end_date, status)
VALUES
(1, 1, '2023-01-01', '2023-12-31', 'active'),
(2, 2, '2023-02-01', '2023-08-01', 'active'),
(3, 3, '2023-03-01', '2023-09-01', 'active'),
(4, 2, '2023-04-01', '2023-10-01', 'active'),
(5, 3, '2023-05-01', '2023-11-01', 'active');

-- 20. User Packages History (đã thêm status)
INSERT INTO user_packages (user_id, service_package_id, start_date, end_date, status)
VALUES
(1, 1, '2023-01-01', '2023-12-31', 1),
(2, 2, '2023-02-01', '2023-08-01', 1),
(3, 3, '2023-03-01', '2023-09-01', 1),
(4, 2, '2023-04-01', '2023-10-01', 1),
(5, 3, '2023-05-01', '2023-11-01', 1);

-- 21. Course Access (đã thêm status)
INSERT INTO course_access (course_id, service_package_id, status)
VALUES
(1, 2, 1), (1, 3, 1), -- Chăm sóc chó con cho gói standard và pro
(2, 2, 1), (2, 3, 1), -- Dinh dưỡng mèo
(3, 3, 1),         -- Sơ cứu chỉ cho pro
(4, 3, 1),         -- Huấn luyện chó
(5, 2, 1), (5, 3, 1); -- Chăm sóc mèo

-- 22. Tiến độ học tập (đã thêm status)
INSERT INTO user_progress (user_id, lesson_id, completed, completed_at, status)
VALUES
(1, 1, 1, GETDATE(), 1),
(1, 2, 1, GETDATE(), 1),
(1, 3, 0, NULL, 1),
(2, 1, 1, GETDATE(), 1),
(2, 2, 0, NULL, 1),
(3, 5, 1, GETDATE(), 1),
(3, 6, 1, GETDATE(), 1),
(4, 7, 1, GETDATE(), 1),
(5, 8, 1, GETDATE(), 1);

-- 23. Đánh giá khóa học (đã thêm status)
INSERT INTO course_reviews (course_id, user_id, rating, comment, status)
VALUES
(1, 1, 5, N'Khóa học rất hữu ích cho người mới nuôi chó', 1),
(1, 2, 4, N'Nội dung chi tiết, dễ hiểu', 1),
(2, 3, 5, N'Giúp tôi chăm sóc mèo tốt hơn', 1),
(3, 4, 4, N'Kiến thức thực tế, áp dụng được ngay', 1),
(5, 5, 5, N'Rất đáng đồng tiền', 1);

-- 24. Blog Comments (đã thêm status)
INSERT INTO BlogComments (blog_id, user_id, content, status)
VALUES
(1, 1, N'Bài viết rất hữu ích, cảm ơn tác giả!', 1),
(1, 2, N'Tôi đã áp dụng và thấy hiệu quả', 1),
(2, 3, N'Thông tin chi tiết, dễ hiểu', 1),
(3, 4, N'Rất hữu ích cho người nuôi mèo như tôi', 1);

-- 25. Audit Log (đã thêm status)
INSERT INTO audit_log (table_name, record_id, action, old_values, new_values, changed_by, status)
VALUES
('users', 1, 'UPDATE', '{"status":0}', '{"status":1}', 4, 1),
('products', 1, 'CREATE', NULL, '{"name":"Thức ăn cho chó vị gà 5kg","price":350000}', 3, 1),
('orders', 1, 'UPDATE', '{"status":"processing"}', '{"status":"completed"}', 2, 1);