-- ===========================================
--          PETTECH DATABASE INIT SCRIPT
-- ===========================================

-- Dùng đúng database
USE PetTech;
GO

-- ===========================================
--          DROP ALL TABLES IF EXISTS
-- ===========================================

-- Xóa toàn bộ bảng nếu đã tồn tại (ngắt FK trước)
BEGIN TRY
    ALTER TABLE user_progress DROP CONSTRAINT FK__user_progress__lesson_id;
    ALTER TABLE user_progress DROP CONSTRAINT FK__user_progress__user_id;
    ALTER TABLE lesson_attachments DROP CONSTRAINT FK__lesson_attachments__lesson_id;
    ALTER TABLE course_lessons DROP CONSTRAINT FK__course_lessons__module_id;
    ALTER TABLE course_modules DROP CONSTRAINT FK__course_modules__course_id;
    ALTER TABLE product_category_items DROP CONSTRAINT FK__product_category_items__product_id;
    ALTER TABLE product_category_items DROP CONSTRAINT FK__product_category_items__category_id;
    ALTER TABLE payments DROP CONSTRAINT FK__payments__order_id;
    ALTER TABLE order_items DROP CONSTRAINT FK__order_items__order_id;
    ALTER TABLE order_items DROP CONSTRAINT FK__order_items__product_id;
    ALTER TABLE orders DROP CONSTRAINT FK__orders__user_id;
    ALTER TABLE products DROP CONSTRAINT FK__products__partner_id;
    ALTER TABLE course_access DROP CONSTRAINT FK__course_access__course_id;
    ALTER TABLE course_access DROP CONSTRAINT FK__course_access__service_package_id;
    ALTER TABLE course_category_course DROP CONSTRAINT FK__course_category_course__course_id;
    ALTER TABLE course_category_course DROP CONSTRAINT FK__course_category_course__category_item_id;
    ALTER TABLE course_category_items DROP CONSTRAINT FK__course_category_items__category_id;
    ALTER TABLE course_images DROP CONSTRAINT FK_CourseImage_Course;
    ALTER TABLE user_packages DROP CONSTRAINT FK__user_packages__user_id;
    ALTER TABLE user_packages DROP CONSTRAINT FK__user_packages__service_package_id;
    ALTER TABLE users DROP CONSTRAINT FK__users__service_package_id;
END TRY
BEGIN CATCH
END CATCH

-- Xóa bảng nếu tồn tại (lần lượt từ bảng phụ đến bảng chính)
DROP TABLE IF EXISTS user_progress, lesson_attachments, course_lessons, course_modules,
                     product_category_items, product_categories, payments, order_items, orders,
                     products, course_access, course_category_course, course_category_items,
                     course_categories, course_images, user_packages, users, courses, service_packages;

DROP TABLE IF EXISTS users;
-- ===========================================
--          TẠO CÁC BẢNG
-- ===========================================

-- 1. Gói dịch vụ
CREATE TABLE service_packages (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(50),
    description NVARCHAR(MAX),
    price DECIMAL(10, 0),
    type NVARCHAR(20) UNIQUE CHECK (type IN (N'free', N'standard', N'pro'))
);

-- 2. Người dùng
CREATE TABLE users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    email NVARCHAR(100) NOT NULL UNIQUE,
    password NVARCHAR(100) NOT NULL,
    fullname NVARCHAR(100) NOT NULL,
    phone NVARCHAR(20) NOT NULL,
    address NVARCHAR(255) NOT NULL,
    role_id INT DEFAULT 1, -- 1: user, 2: staff, 3: admin
    status BIT DEFAULT 1,  -- 1: active, 0: inactive
    created_at DATETIME DEFAULT GETDATE(),
    verification_token NVARCHAR(255),
    service_package_id INT, -- Bổ sung cột này để làm khóa ngoại
	is_active BIT DEFAULT 0,
    activation_token VARCHAR(100),
    token_expiry DATETIME,
    CONSTRAINT chk_email CHECK (email LIKE '%@%.%'),
    FOREIGN KEY (service_package_id) REFERENCES service_packages(id)
);

CREATE TABLE User_Service (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    package_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status NVARCHAR(50) NOT NULL, -- Ví dụ: 'Đang sử dụng', 'Đã hết hạn', 'Đã nâng cấp'

    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (package_id) REFERENCES service_packages(id)
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

-- 4. Khóa học
CREATE TABLE courses (
    id INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(255),
    content NVARCHAR(MAX),
    post_date DATE,
    researcher NVARCHAR(100),
    video_url NVARCHAR(MAX),
    status INT DEFAULT 1,
    time NVARCHAR(50)
);

-- 5. Hình ảnh khóa học
CREATE TABLE course_images (
    id INT IDENTITY(1,1) PRIMARY KEY,
    course_id INT NOT NULL,
    image_url NVARCHAR(255) NOT NULL,
    is_primary BIT DEFAULT 0,
    created_at DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_CourseImage_Course FOREIGN KEY (course_id) REFERENCES courses(id)
);

-- 6. Phân loại khóa học
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

-- 7. Quyền truy cập khóa học
CREATE TABLE course_access (
    id INT IDENTITY(1,1) PRIMARY KEY,
    course_id INT,
    service_package_id INT,
    FOREIGN KEY (course_id) REFERENCES courses(id),
    FOREIGN KEY (service_package_id) REFERENCES service_packages(id)
);

-- 8. Bảng đối tác (partners)
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


-- 9. Sản phẩm
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
-- 10. Danh mục sản phẩm
CREATE TABLE product_categories (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL
);

CREATE TABLE product_category_items (
    id INT IDENTITY(1,1) PRIMARY KEY,
    product_id INT NOT NULL,
    category_id INT NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (category_id) REFERENCES product_categories(id)
);


-- 11. Đầu tiên tạo bảng orders (di chuyển lên trước payments)
CREATE TABLE orders (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT,
    order_date DATETIME DEFAULT GETDATE(),
    total_amount DECIMAL(12, 0),
    commission DECIMAL(12, 0),
    status NVARCHAR(20) CHECK (status IN (N'pending', N'processing', N'completed', N'cancelled')),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 12. Xóa bảng payments thứ hai (nếu đã tạo nhầm)
-- (Không cần thực thi nếu bạn đang tạo mới toàn bộ database)

CREATE TABLE order_items (
    id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(12, 0),
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);


-- 13. Sau đó mới tạo bảng payments (chỉ định nghĩa 1 lần)
-- Sửa lại bảng payments để hỗ trợ các phương thức thanh toán
CREATE TABLE payments (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    service_package_id INT NULL, -- Có thể NULL nếu là thanh toán sản phẩm
    order_id INT NULL,           -- Có thể NULL nếu là thanh toán gói dịch vụ
    payment_method VARCHAR(50) NOT NULL CHECK (payment_method IN ('MOMO_QR', 'BANK_QR', 'VNPAY', 'CASH')),
    amount DECIMAL(10,2) NOT NULL,
    payment_date DATETIME DEFAULT GETDATE(),
    status VARCHAR(20) NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'failed', 'refunded')),
    transaction_id VARCHAR(100),
    qr_code_url NVARCHAR(500) NULL, -- URL hình ảnh QR code
    bank_account_number VARCHAR(20) NULL, -- Số tài khoản ngân hàng (nếu có)
    bank_name NVARCHAR(100) NULL,    -- Tên ngân hàng
    notes NVARCHAR(500) NULL,
	is_confirmed BIT DEFAULT 0,
    confirmation_code VARCHAR(50),
    confirmation_expiry DATETIME,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (service_package_id) REFERENCES service_packages(id),
    FOREIGN KEY (order_id) REFERENCES orders(id)
);


-- 14. Chương học & bài học
CREATE TABLE course_modules (
    id INT IDENTITY(1,1) PRIMARY KEY,
    course_id INT NOT NULL,
    title NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX),
    order_index INT NOT NULL,
    FOREIGN KEY (course_id) REFERENCES courses(id)
);

CREATE TABLE course_lessons (
    id INT IDENTITY(1,1) PRIMARY KEY,
    module_id INT NOT NULL,
    title NVARCHAR(255) NOT NULL,
    content NVARCHAR(MAX),
    video_url NVARCHAR(255),
    duration INT,
    order_index INT NOT NULL,
    FOREIGN KEY (module_id) REFERENCES course_modules(id)
);

CREATE TABLE lesson_attachments (
    id INT IDENTITY(1,1) PRIMARY KEY,
    lesson_id INT NOT NULL,
    file_name NVARCHAR(255) NOT NULL,
    file_url NVARCHAR(255) NOT NULL,
    file_size INT,
    FOREIGN KEY (lesson_id) REFERENCES course_lessons(id)
);

-- 15. Tiến độ học tập
CREATE TABLE user_progress (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    lesson_id INT NOT NULL,
    completed BIT DEFAULT 0,
    completed_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (lesson_id) REFERENCES course_lessons(id)
);


-- 16. Bảng loại tin tức
CREATE TABLE BlogCategories (
    category_id INT PRIMARY KEY IDENTITY(1,1),
    category_name NVARCHAR(100) NOT NULL,
    description NVARCHAR(255),
    created_at DATETIME DEFAULT GETDATE()
);

-- 17. Bảng tin tức
CREATE TABLE Blogs (
    blog_id INT PRIMARY KEY IDENTITY(1,1),
    title NVARCHAR(255) NOT NULL,
    content NVARCHAR(MAX) NOT NULL,
    short_description NVARCHAR(500),
    image_url NVARCHAR(255),
    category_id INT FOREIGN KEY REFERENCES BlogCategories(category_id),
    author_id INT, -- Có thể tham chiếu đến bảng Users nếu cần
    author_name NVARCHAR(100) DEFAULT 'Admin',
    view_count INT DEFAULT 0,
    is_featured BIT DEFAULT 0,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE()
);

-- 18. Bảng bình luận (nếu cần)
CREATE TABLE BlogComments (
    comment_id INT PRIMARY KEY IDENTITY(1,1),
    blog_id INT FOREIGN KEY REFERENCES Blogs(blog_id),
    user_id INT, -- Tham chiếu đến bảng Users
    content NVARCHAR(1000) NOT NULL,
    created_at DATETIME DEFAULT GETDATE()
);

-- Bảng đánh giá khóa học
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
-- ===========================================
--          HOÀN TẤT TẠO CẤU TRÚC
-- ===========================================
-- ===========================================
--          THÊM DỮ LIỆU MẪU
-- ===========================================

-- 1. Gói dịch vụ
-- Insert dữ liệu các gói dịch vụ
INSERT INTO service_packages (name, description, price, type)
VALUES 
(N'GÓI MIỄN PHÍ', 
N'Phù hợp với người mới bắt đầu nuôi thú cưng hoặc đang tìm hiểu.
Lợi ích:
- Truy cập miễn phí vào các bài viết cơ bản về chăm sóc thú cưng có giới hạn thông tin nội dung.
- Tham gia diễn đàn cộng đồng để thảo luận với người nuôi thú cưng khác.', 
0, N'free'),

(N'GÓI TIÊU CHUẨN', 
N'Dành cho người nuôi thú cưng có nhu cầu chăm sóc tốt hơn và học hỏi thêm.
Lợi ích:
- Truy cập miễn phí vào các bài viết cơ bản về chăm sóc thú cưng.
- Tham gia diễn đàn cộng đồng để thảo luận với người nuôi thú cưng khác.
- Truy cập không giới hạn tất cả video hướng dẫn chất lượng cao.
- Truy cập vào thư viện bài viết nâng cao theo loại thú cưng (chó, mèo, hamster…).
- Tham gia các khóa học cơ bản (chăm sóc, dinh dưỡng, vệ sinh…).
- Tư vấn trực tuyến với chuyên gia định kỳ 1 lần/tháng.', 
99000, N'standard'),

(N'GÓI CHUYÊN NGHIỆP', 
N'Phù hợp với người yêu thú cưng nghiêm túc hoặc kinh doanh nhỏ (pet shop, grooming).
Lợi ích:
- Truy cập miễn phí vào các bài viết cơ bản về chăm sóc thú cưng.
- Tham gia diễn đàn cộng đồng để thảo luận với người nuôi thú cưng khác.
- Truy cập không giới hạn tất cả video hướng dẫn chất lượng cao.
- Truy cập vào thư viện bài viết nâng cao theo loại thú cưng (chó, mèo, hamster...).
- Tham gia các khóa học cơ bản (chăm sóc, dinh dưỡng, vệ sinh…).
- Truy cập vào khóa học chuyên sâu (phòng bệnh, huấn luyện hành vi, sơ cứu…).
- Tư vấn 1-1 không giới hạn với bác sĩ thú y / chuyên gia huấn luyện.
- Nhận tài liệu độc quyền (PDF, infographic…).
- Ưu đãi giảm giá 10% khi mua khóa học nâng cao hoặc sản phẩm từ đối tác.', 
199000, N'pro');

-- 2. Người dùng

-- Chèn người dùng thường dùng gói Free (service_package_id = 1)
INSERT INTO users (
    email, password, fullname, phone, address, role_id, status, service_package_id, is_active, verification_token
) VALUES
('user1@example.com', '123456Aa', N'Nguyễn Văn A', '0912345678', N'123 Đường ABC, Quận 1', 1, 1, 1, 1, NEWID()),

-- Chèn người dùng dùng gói trả phí chưa được kích hoạt

('user2@example.com', '123456Aa', N'Trần Thị B', '0987654321', N'456 Đường XYZ, Quận 2', 1, 1, 2, 0, NEWID()),

-- Chèn nhân viên

('staff1@pettech.com', '123456Aa', N'Nhân viên C', '0909999999', N'789 Đường DEF, Quận 3', 2, 1, 2, 1, NEWID()),

-- Chèn admin

('admin@pettech.com', '123456Aa', N'Quản trị viên D', '0938888888', N'321 Đường GHI, Quận 4', 3, 1, 3, 1, NEWID());


-- 6. Sản phẩm và danh mục
INSERT INTO products (name, description, price, stock, partner_id, image_url)
VALUES 
(N'Thức ăn cho chó vị gà 5kg', N'Dành cho chó từ 2 tháng tuổi trở lên', 350000, 100, 4, '/img/products/dog_food.jpg'),
(N'Cát vệ sinh hữu cơ cho mèo', N'Hấp thụ nhanh và khử mùi tốt', 120000, 150, 4, '/img/products/cat_litter.jpg'),
(N'Sữa tắm thảo dược thú cưng', N'Làm sạch và chống rụng lông', 89000, 200, 5, '/img/products/pet_shampoo.jpg');

INSERT INTO product_categories (name)
VALUES 
(N'Thức ăn'),
(N'Vệ sinh'),
(N'Phụ kiện');

INSERT INTO product_category_items (product_id, category_id)
VALUES 
(1, 1),
(2, 2),
(3, 2);

-- 7. Đơn hàng & thanh toán

-- Đầu tiên, tạo đơn hàng
INSERT INTO orders (user_id, total_amount, commission, status)
VALUES 
(1, 350000, 10500, N'completed'),
(1, 120000, 3600, N'completed');

-- Thêm sản phẩm vào đơn hàng
INSERT INTO order_items (order_id, product_id, quantity, price)
VALUES 
(1, 1, 1, 350000),
(2, 2, 1, 120000);

-- Sau đó mới thêm thanh toán
-- Thanh toán bằng QR Momo (cho đơn hàng 1)
INSERT INTO payments (
    user_id,
    order_id,
    payment_method,
    amount,
    status,
    transaction_id,
    qr_code_url
)
VALUES (
    1,
    1,
    'MOMO_QR',
    350000,
    'completed',
    'MOMO' + CAST(FLOOR(RAND() * 1000000) AS VARCHAR),
    'https://example.com/qr/momo/123456'
);

-- Thanh toán bằng QR Ngân hàng (cho đơn hàng 2)
INSERT INTO payments (
    user_id,
    order_id,
    payment_method,
    amount,
    status,
    transaction_id,
    qr_code_url,
    bank_account_number,
    bank_name
)
VALUES (
    1,
    2,
    'BANK_QR',
    120000,
    'completed',
    'BANK' + CAST(FLOOR(RAND() * 1000000) AS VARCHAR),
    'https://example.com/qr/bank/789012',
    '1234567890',
    N'Ngân hàng TMCP Ngoại thương Việt Nam (Vietcombank)'
);


-- ===========================================
--        HOÀN TẤT TẠO DỮ LIỆU MẪU
-- ===========================================



-- 3. Khóa học
INSERT INTO courses (title, content, post_date, researcher, video_url, status, time)
VALUES 
(N'Chăm sóc chó con', N'Hướng dẫn nuôi dạy chó con toàn diện', GETDATE(), N'Dr. Trí Nguyễn', NULL, 1, N'4 tuần'),
(N'Dinh dưỡng cho mèo trưởng thành', N'Phân tích chế độ ăn và thực phẩm phù hợp cho mèo', GETDATE(), N'Dr. Lệ Hằng', NULL, 1, N'6 tuần'),
(N'Sơ cứu thú cưng tại nhà', N'Hướng dẫn các bước sơ cứu cơ bản cho thú cưng', GETDATE(), N'Dr. Dũng Phạm', NULL, 1, N'3 tháng');

-- 4. Hình ảnh khóa học
INSERT INTO course_images (course_id, image_url, is_primary)
VALUES 
(1, '/images/course/course_dog.jpg', 1),
(2, '/images/course/course_cat.jpg', 1),
(3, '/images/course/course_pet_first_aid.jpg', 1);

-- === KHÓA HỌC 1: Chăm sóc chó con ===
INSERT INTO course_modules (course_id, title, description, order_index) VALUES
(1, N'Giới thiệu về chó con', N'Thông tin cơ bản và tổng quan khi quyết định nuôi chó con', 1),
(1, N'Dinh dưỡng hợp lý', N'Hướng dẫn lựa chọn chế độ ăn phù hợp theo độ tuổi', 2);

INSERT INTO course_lessons (module_id, title, content, video_url, duration, order_index) VALUES
(1, N'Bài 1: Tại sao chọn nuôi chó con',
N'I. Lý do nên chọn nuôi chó con

1. Gắn bó cảm xúc: Nuôi chó từ nhỏ giúp bạn xây dựng mối quan hệ gắn bó lâu dài với thú cưng, từ đó dễ dàng huấn luyện và chăm sóc hơn.

2. Dễ thích nghi: Chó con có khả năng thích nghi nhanh với môi trường sống mới, dễ hòa hợp với các thành viên trong gia đình.

3. Dễ huấn luyện: Chó con có khả năng học hỏi nhanh, tạo điều kiện thuận lợi trong việc dạy các kỹ năng cơ bản.

![Chó con và trẻ em](https://th.bing.com/th/id/OIP.lD3Rxt-7VEi0UR03q_2OTAHaEK?w=333&h=187&c=7&r=0&o=7&cb=iwp2&dpr=1.3&pid=1.7&rm=3)

II. Những lưu ý khi quyết định nuôi chó con

1. Thời gian chăm sóc: Bạn cần đảm bảo có đủ thời gian trong ngày để chăm sóc và chơi với chó.
2. Chi phí: Dự trù chi phí hàng tháng cho ăn uống, khám bệnh, tiêm phòng, đồ dùng,...
3. Không gian sống: Cân nhắc nuôi chó ở chung cư hay nhà đất, có sân vườn hay không.

III. Kết luận

Chọn nuôi chó con là một quyết định ý nghĩa và mang lại nhiều giá trị tinh thần, nhưng cũng cần đi kèm với trách nhiệm lâu dài.',
NULL, 10, 1);

-- === KHÓA HỌC 2: Dinh dưỡng cho mèo trưởng thành ===
INSERT INTO course_modules (course_id, title, description, order_index) VALUES
(2, N'Hiểu về nhu cầu dinh dưỡng', N'Tổng quan về chế độ dinh dưỡng cho mèo', 1),
(2, N'Lựa chọn thực phẩm', N'Thực phẩm khô, ướt và các bổ sung cần thiết', 2);

INSERT INTO course_lessons (module_id, title, content, video_url, duration, order_index) VALUES
(3, N'Bài 1: Dinh dưỡng theo độ tuổi',
N'I. Giới thiệu

Chế độ dinh dưỡng của mèo thay đổi đáng kể theo từng giai đoạn phát triển. Việc hiểu rõ nhu cầu theo độ tuổi giúp đảm bảo sức khỏe lâu dài và phòng tránh các bệnh lý dinh dưỡng.

II. Giai đoạn mèo con (0–6 tháng)
- Tăng trưởng nhanh, nhu cầu năng lượng cao.
- Ưu tiên sữa mẹ, sau đó là thức ăn giàu protein và chất béo.
- Chia khẩu phần nhỏ trong ngày.

![Mèo con bú sữa](https://vuipet.com/wp-content/uploads/2021/11/sua-cho-meo-con-2-1391x800.jpg)

III. Mèo trưởng thành (6 tháng – 7 tuổi)
- Duy trì cân nặng, sức đề kháng.
- Giảm lượng béo so với giai đoạn trước.
- Nên dùng thức ăn thương mại cân đối, giàu đạm động vật.

IV. Mèo già (trên 7 tuổi)
- Nhu cầu calo giảm, cần thức ăn dễ tiêu hóa.
- Ưu tiên thực phẩm hỗ trợ thận, khớp và giảm viêm.

V. Kết luận

Chọn thức ăn theo độ tuổi không chỉ giúp mèo khỏe mạnh mà còn kéo dài tuổi thọ và giảm thiểu chi phí y tế trong tương lai.',
NULL, 12, 1),
(3, N'Bài 2: Thành phần cần có trong thức ăn',
N'I. Tầm quan trọng của thành phần dinh dưỡng

Một chế độ ăn cân bằng không chỉ giúp mèo phát triển khỏe mạnh mà còn phòng tránh nhiều bệnh lý liên quan đến thận, gan, béo phì hoặc thiếu khoáng.

II. Thành phần cần thiết
1. Protein
- Nguồn chính: thịt gà, cá, gan động vật.
- Vai trò: phát triển cơ bắp, lông mượt, tăng sức đề kháng.

2. Chất béo
- Nguồn gốc: dầu cá, dầu thực vật.
- Cung cấp năng lượng, hấp thụ vitamin.

3. Vitamin
- Vitamin A: tốt cho thị lực và hệ miễn dịch.
- Vitamin B: hỗ trợ trao đổi chất, da và lông.
- Vitamin D: phát triển xương khớp.

4. Khoáng chất
- Canxi và phốt pho: phát triển hệ xương.
- Sắt và kẽm: tạo máu và miễn dịch.

![Thành phần trong thức ăn mèo](https://th.bing.com/th/id/OIP.lawNlNx4LZtC3RnQ0gvyewHaEV?w=319&h=187&c=7&r=0&o=7&cb=iwp2&dpr=1.3&pid=1.7&rm=3)

III. Cách đọc bảng thành phần
- Luôn ưu tiên thức ăn có protein động vật đứng đầu.
- Tránh sản phẩm có ngũ cốc làm thành phần chính.
- Tránh chất bảo quản độc hại như BHA, BHT.

IV. Kết luận

Đọc kỹ thành phần trước khi chọn thực phẩm cho mèo là cách đơn giản nhất để duy trì sức khỏe lâu dài và tránh các bệnh mãn tính.',
'https://www.youtube.com/embed/meo001', 15, 2),
(4, N'Bài 1: Ưu nhược điểm của thức ăn khô/ướt',
N'I. Giới thiệu

Thức ăn khô và thức ăn ướt là hai hình thức phổ biến trên thị trường hiện nay. Việc hiểu rõ điểm mạnh và hạn chế của mỗi loại giúp bạn lựa chọn phù hợp với thói quen ăn uống và tình trạng sức khỏe của mèo.

II. Thức ăn khô (dry food)
Ưu điểm:
- Bảo quản lâu, tiện lợi khi cho ăn.
- Giúp làm sạch răng nhờ cấu trúc cứng.
- Kinh tế, giá thành thấp.

Nhược điểm:
- Độ ẩm thấp (7–10%), dễ gây thiếu nước nếu mèo không uống nhiều.
- Khó nhai đối với mèo già hoặc răng yếu.

III. Thức ăn ướt (wet food)
Ưu điểm:
- Độ ẩm cao (75–85%) giúp bổ sung nước, phù hợp với mèo có vấn đề thận.
- Mùi vị hấp dẫn, dễ ăn.

Nhược điểm:
- Giá thành cao hơn.
- Dễ hư nếu không bảo quản đúng cách.
- Có thể gây tích mảng thức ăn ở răng nếu không vệ sinh kỹ.

![So sánh thức ăn khô và ướt](https://th.bing.com/th/id/OIP.g42pozVIgXVcsONXcfQYyQHaHa?w=171&h=180&c=7&r=0&o=7&cb=iwp2&dpr=1.3&pid=1.7&rm=3)

IV. Gợi ý sử dụng
- Kết hợp cả hai loại để cân bằng dinh dưỡng và giữ thói quen ăn đa dạng.
- Thức ăn khô vào ban ngày, ướt vào buổi tối hoặc dùng làm món thưởng.

V. Kết luận

Không có loại thức ăn nào là tuyệt đối tốt hơn. Quan trọng nhất là phù hợp với từng cá thể mèo về sức khỏe, sở thích và điều kiện tài chính của chủ nuôi.',
NULL, 10, 1);

INSERT INTO lesson_attachments (lesson_id, file_name, file_url, file_size) VALUES
(4, N'Bảng nhu cầu dinh dưỡng theo độ tuổi.pdf', '/uploads/documents/cat_nutrition_age.pdf', 512);

-- === KHÓA HỌC 3: Sơ cứu thú cưng tại nhà ===
INSERT INTO course_modules (course_id, title, description, order_index) VALUES
(3, N'Những tình huống phổ biến', N'Xử lý nhanh các tai nạn thường gặp', 1),
(3, N'Dụng cụ sơ cứu & kỹ năng cơ bản', N'Chuẩn bị bộ sơ cứu và thao tác an toàn', 2);

INSERT INTO course_lessons (module_id, title, content, video_url, duration, order_index) VALUES
(5, N'Bài 1: Bị thương ngoài da',
N'I. Nhận diện các loại thương tổn
- Vết cắt nông do va quẹt.
- Trầy xước trong lúc chơi đùa.
- Chảy máu nhẹ ở chân, đuôi.

II. Quy trình sơ cứu
1. Rửa tay hoặc đeo găng.
2. Làm sạch vùng vết thương bằng nước muối sinh lý.
3. Lau khô nhẹ nhàng, dùng bông băng hoặc gạc sạch ép nhẹ lên vết thương để cầm máu.
4. Sát trùng bằng Betadine hoặc dung dịch tương tự.
5. Theo dõi 1–2 ngày đầu xem có sưng, mưng mủ.

![Vệ sinh vết thương](https://example.com/images/pet_wound_cleaning.jpg)

III. Khi nào cần đưa đến bác sĩ?
- Vết thương sâu, chảy máu không cầm.
- Có dị vật bên trong (gai, thủy tinh).
- Vết thương không lành sau 48h.

IV. Lưu ý
- Tránh dùng oxy già hoặc cồn 90 độ vì gây xót và hỏng mô.
- Luôn nhẹ nhàng, trấn an thú cưng.',
'https://www.youtube.com/embed/pet_aid1', 12, 1),
(5, N'Bài 2: Ngộ độc thức ăn',
N'I. Nguyên nhân phổ biến gây ngộ độc
- Thức ăn ôi thiu, mốc hoặc nhiễm khuẩn.
- Thực phẩm có độc với chó/mèo: sôcôla, nho, hành tỏi, xương gà nhỏ,...
- Ăn phải hóa chất tẩy rửa, thuốc trừ sâu, thuốc chuột.

II. Dấu hiệu nhận biết sớm
1. Nôn mửa liên tục, có thể kèm bọt trắng.
2. Tiêu chảy đột ngột, phân có mùi hôi bất thường.
3. Run rẩy, mất thăng bằng, mệt mỏi.
4. Tiết nước dãi quá mức, thở gấp.

![Triệu chứng ngộ độc ở thú cưng](https://example.com/images/pet_poison_symptoms.jpg)

III. Cách sơ cứu tạm thời tại nhà
1. Ngưng cho ăn, lập tức tách khỏi nguồn gây độc.
2. Gọi bác sĩ thú y và cung cấp thông tin về loại chất/đồ ăn đã ăn phải.
3. Không cố gắng gây nôn nếu chưa có chỉ định bác sĩ.
4. Có thể cho uống than hoạt tính nếu được chỉ định để hấp phụ độc tố.

IV. Trường hợp khẩn cấp cần đến cơ sở thú y
- Mất ý thức, co giật.
- Máu trong phân hoặc chất nôn.
- Không ăn uống và mệt li bì sau 6–12 giờ.

V. Phòng ngừa
- Luôn bảo quản thức ăn đúng cách, kiểm tra hạn sử dụng.
- Cất xa các chất tẩy rửa và thuốc khỏi tầm với.
- Tuyệt đối không cho ăn đồ ăn của người không rõ thành phần.

VI. Kết luận

Ngộ độc thức ăn là tình huống nguy hiểm nhưng có thể phòng ngừa và xử lý hiệu quả nếu phát hiện kịp thời và có kiến thức sơ cứu cơ bản.', NULL, 14, 2),
(6, N'Bài 1: Chuẩn bị túi sơ cứu tại nhà',
N'I. Vì sao cần có túi sơ cứu riêng cho thú cưng?
Thú cưng có thể gặp tai nạn bất cứ lúc nào: bị thương nhẹ, dị vật, hoặc các vấn đề cấp cứu cần xử lý tức thì trước khi đến bác sĩ.

II. Danh sách vật dụng cơ bản nên có
1. Dung dịch sát trùng: Betadine hoặc nước muối sinh lý.
2. Gạc vô trùng, bông gòn, băng cuốn.
3. Kéo nhỏ, nhíp gắp dị vật.
4. Nhiệt kế đo hậu môn.
5. Găng tay y tế dùng một lần.
6. Thuốc tiêu hóa, than hoạt tính (theo chỉ định bác sĩ).
7. Danh bạ liên hệ bác sĩ thú y gần nhất.

![Túi sơ cứu cho thú cưng](https://example.com/images/pet_firstaid_kit.jpg)

III. Cách sắp xếp và bảo quản
- Sử dụng túi zip/nhựa có nhiều ngăn để phân loại.
- Ghi chú hướng dẫn sử dụng cơ bản cho từng vật dụng.
- Kiểm tra định kỳ hạn sử dụng của các loại thuốc.

IV. Gợi ý mở rộng
- Máy đo nhịp tim/máy xịt lạnh tạm thời cho ngày nắng.
- Bản hướng dẫn sơ cứu in ra giấy để người khác trong nhà cũng biết cách dùng.

V. Kết luận

Một túi sơ cứu đúng chuẩn là công cụ không thể thiếu giúp bạn chủ động xử lý khi thú cưng gặp sự cố bất ngờ tại nhà.', NULL, 8, 1);

INSERT INTO lesson_attachments (lesson_id, file_name, file_url, file_size) VALUES
(5, N'Hướng dẫn xử lý vết thương thú cưng.docx', '/uploads/documents/pet_firstaid_wound.docx', 300),
(6, N'Danh sách dụng cụ sơ cứu bắt buộc.pdf', '/uploads/documents/pet_firstaid_kit.pdf', 480);

-- ===========================================
--   KẾT THÚC BỔ SUNG MODULE/LESSON CHI TIẾT CHO 3 KHÓA
-- ===========================================

-- Khóa học 4: Huấn luyện chó căn bản
INSERT INTO courses (title, content, post_date, researcher, video_url, status, time)
VALUES
(N'Huấn luyện chó căn bản', N'Hướng dẫn chi tiết các kỹ thuật huấn luyện chó cơ bản, giúp thú cưng ngoan ngoãn và hiểu lời chủ.', GETDATE(), N'Dr. Thanh Phạm', NULL, 1, N'5 tuần');

-- Hình ảnh khóa học
INSERT INTO course_images (course_id, image_url, is_primary)
VALUES
(4, '/images/course/course_training_dog.jpg', 1);

-- Modules cho khóa học 4
INSERT INTO course_modules (course_id, title, description, order_index) VALUES
(4, N'Giới thiệu về huấn luyện chó', N'Tổng quan về tâm lý và các bước chuẩn bị khi huấn luyện chó.', 1),
(4, N'Kỹ thuật huấn luyện cơ bản', N'Chi tiết các bài tập và kỹ thuật giúp chó nghe lời.', 2);

-- Bài học cho module 1
INSERT INTO course_lessons (module_id, title, content, video_url, duration, order_index) VALUES
(7, N'Bài 1: Tâm lý chó khi huấn luyện',
N'I. Tầm quan trọng của tâm lý trong huấn luyện

Việc hiểu rõ tâm lý của chó sẽ giúp bạn áp dụng phương pháp huấn luyện hiệu quả, tránh làm thú cưng sợ hãi hoặc phản kháng.

II. Đặc điểm tâm lý chó

1. Chó là loài xã hội, thích gắn kết với chủ nhân.
2. Chó thích lặp lại và phản hồi nhanh với phần thưởng.
3. Chó sợ bị phạt quá mức, dễ bị stress nếu huấn luyện sai cách.

III. Các bước chuẩn bị tâm lý cho huấn luyện

1. Tạo môi trường yên tĩnh, không bị làm phiền.
2. Chuẩn bị đồ ăn thưởng cho chó.
3. Dành thời gian làm quen và chơi với chó trước khi bắt đầu huấn luyện.

![Chó vui khi được huấn luyện](https://example.com/images/happy_dog_training.jpg)

IV. Kết luận

Huấn luyện thành công bắt đầu từ việc hiểu và tôn trọng tâm lý của thú cưng.', NULL, 15, 1);

-- Bài học cho module 2
INSERT INTO course_lessons (module_id, title, content, video_url, duration, order_index) VALUES
(8, N'Bài 1: Huấn luyện chó nghe lệnh "Ngồi"',
N'I. Mục tiêu

Huấn luyện chó biết ngồi khi được ra lệnh là bài học cơ bản giúp kiểm soát hành vi và tạo nền tảng cho các bài huấn luyện nâng cao.

II. Hướng dẫn chi tiết

1. Chuẩn bị thức ăn thưởng yêu thích của chó.
2. Giữ thức ăn trước mũi chó, từ từ di chuyển tay lên trên và ra sau đầu chó.
3. Khi chó ngồi xuống theo tay bạn, ngay lập tức nói lệnh "Ngồi" và thưởng thức ăn.
4. Lặp lại nhiều lần trong ngày, mỗi lần huấn luyện không quá 10 phút để tránh chó mệt.

III. Lưu ý

- Kiên nhẫn và tránh la mắng khi chó chưa hiểu.
- Không huấn luyện ngay sau khi chó ăn no.

IV. Video minh họa

Bạn có thể xem video hướng dẫn tại đây:

<iframe width="560" height="315" src="https://www.youtube.com/embed/dog_sit_training" title="Huấn luyện chó ngồi" frameborder="0" allowfullscreen></iframe>

![Huấn luyện chó ngồi](https://example.com/images/dog_sit_command.jpg)

V. Kết luận

Bài huấn luyện "Ngồi" là bước đầu tiên quan trọng giúp xây dựng kỷ luật và sự hợp tác giữa chó và chủ.', NULL, 20, 1);

-- Tài liệu đính kèm bài học
INSERT INTO lesson_attachments (lesson_id, file_name, file_url, file_size) VALUES
(7, N'Hướng dẫn chi tiết bài huấn luyện Ngồi.pdf', '/uploads/documents/dog_sit_training.pdf', 2048);

-- Khóa học 5: Chăm sóc mèo cơ bản
INSERT INTO courses (title, content, post_date, researcher, video_url, status, time)
VALUES
(N'Chăm sóc mèo cơ bản', N'Hướng dẫn chi tiết chăm sóc mèo từ thức ăn, vệ sinh, đến sức khỏe.', GETDATE(), N'Dr. Mai Phương', NULL, 1, N'4 tuần');

-- Hình ảnh khóa học
INSERT INTO course_images (course_id, image_url, is_primary)
VALUES
(5, '/images/course/course_cat_care.jpg', 1);

-- Modules
INSERT INTO course_modules (course_id, title, description, order_index) VALUES
(5, N'Chế độ dinh dưỡng', N'Hướng dẫn lựa chọn thức ăn và chế độ dinh dưỡng phù hợp cho mèo.', 1),
(5, N'Vệ sinh và phòng bệnh', N'Cách vệ sinh cơ bản và phòng tránh các bệnh thường gặp ở mèo.', 2);

-- Bài học module 1
INSERT INTO course_lessons (module_id, title, content, video_url, duration, order_index) VALUES
(9, N'Bài 1: Dinh dưỡng cho mèo',
N'I. Tổng quan về dinh dưỡng

Mèo là loài ăn thịt, cần chế độ giàu protein và chất béo từ động vật để phát triển khỏe mạnh.

II. Các loại thức ăn phổ biến

1. Thức ăn khô (dry food)
- Tiện lợi, dễ bảo quản.
- Cần bổ sung nước đầy đủ khi cho mèo ăn thức ăn khô.

2. Thức ăn ướt (wet food)
- Độ ẩm cao, hỗ trợ tiêu hóa.
- Giá thành cao hơn và bảo quản khó hơn.

III. Lời khuyên chọn thức ăn

- Ưu tiên các loại có protein động vật đứng đầu thành phần.
- Tránh thức ăn nhiều ngũ cốc và phụ gia nhân tạo.
- Chia khẩu phần ăn hợp lý, tránh cho mèo ăn quá nhiều gây béo phì.

![Dinh dưỡng cho mèo](https://example.com/images/cat_food_nutrition.jpg)

IV. Kết luận

Chế độ dinh dưỡng đúng sẽ giúp mèo tăng sức đề kháng và giảm nguy cơ bệnh tật.',
NULL, 18, 1);

-- Bài học module 2
INSERT INTO course_lessons (module_id, title, content, video_url, duration, order_index) VALUES
(10, N'Bài 1: Vệ sinh và phòng bệnh cho mèo',
N'I. Vệ sinh cơ bản

- Tắm cho mèo: dùng dầu gội chuyên dụng, tắm định kỳ 2-3 tuần/lần.
- Chải lông: giúp loại bỏ lông rụng và phòng ngừa rối lông.

II. Phòng bệnh

- Tiêm phòng đầy đủ: bệnh dại, bạch cầu, viêm đường hô hấp.
- Vệ sinh khu vực ăn uống và vệ sinh vệ sinh môi trường sống.

III. Phát hiện sớm dấu hiệu bệnh

- Mèo bị bỏ ăn, lười vận động, rụng lông bất thường.
- Tiêu chảy hoặc nôn mửa kéo dài.
- Tham khảo ý kiến bác sĩ thú y ngay khi nghi ngờ.

![Vệ sinh mèo](https://example.com/images/cat_hygiene.jpg)

IV. Kết luận

Vệ sinh tốt kết hợp phòng bệnh chủ động giúp mèo khỏe mạnh và sống lâu hơn.',
'https://www.youtube.com/embed/cat_care_basics', 20, 1);

-- Tài liệu đính kèm
INSERT INTO lesson_attachments (lesson_id, file_name, file_url, file_size) VALUES
(8, N'Hướng dẫn vệ sinh mèo cơ bản.pdf', '/uploads/documents/cat_hygiene_guide.pdf', 1536);

-- Khóa học 6: Tập luyện và vận động cho thú cưng
INSERT INTO courses (title, content, post_date, researcher, video_url, status, time)
VALUES
(N'Tập luyện và vận động cho thú cưng', N'Chương trình hướng dẫn các bài tập thể dục phù hợp với từng loại thú cưng để nâng cao sức khỏe.', GETDATE(), N'Dr. Hải Vương', NULL, 1, N'5 tuần');

-- Hình ảnh khóa học
INSERT INTO course_images (course_id, image_url, is_primary)
VALUES
(6, '/images/course/course_pet_exercise.jpg', 1);

-- Modules
INSERT INTO course_modules (course_id, title, description, order_index) VALUES
(6, N'Chuẩn bị trước khi tập luyện', N'Những lưu ý cần biết trước khi bắt đầu tập luyện cho thú cưng.', 1),
(6, N'Các bài tập cơ bản', N'Hướng dẫn các bài tập thể dục phù hợp cho thú cưng.', 2);

-- Bài học module 1
INSERT INTO course_lessons (module_id, title, content, video_url, duration, order_index) VALUES
(11, N'Bài 1: Lưu ý khi tập luyện cho thú cưng',
N'I. Tầm quan trọng của vận động

Tập luyện giúp thú cưng duy trì cân nặng hợp lý, tăng cường sức khỏe tim mạch và tinh thần vui vẻ.

II. Các bước chuẩn bị

- Kiểm tra sức khỏe thú cưng trước khi bắt đầu.
- Chọn không gian tập luyện rộng rãi và an toàn.
- Chuẩn bị dụng cụ tập luyện phù hợp.

III. Những lưu ý quan trọng

- Không tập quá sức, theo dõi phản ứng của thú cưng.
- Uống nước đầy đủ trước và sau khi tập.
- Tăng dần cường độ và thời gian tập luyện theo khả năng.

![Thú cưng tập thể dục](https://example.com/images/pet_exercise_preparation.jpg)

IV. Kết luận

Chuẩn bị kỹ lưỡng giúp buổi tập hiệu quả và an toàn cho thú cưng.',
NULL, 15, 1);

-- Bài học module 2
INSERT INTO course_lessons (module_id, title, content, video_url, duration, order_index) VALUES
(12, N'Bài 1: Các bài tập vận động cơ bản',
N'I. Bài tập đi dạo

- Đi bộ hằng ngày 20-30 phút giúp tăng sức bền và giảm stress.
- Chọn đường đi an toàn, tránh nắng gắt hoặc khu vực đông xe.

II. Bài tập chơi kéo co

- Kích thích sự nhanh nhẹn và rèn luyện cơ bắp.
- Dùng dây kéo hoặc đồ chơi chuyên dụng.

III. Bài tập tìm kiếm

- Giúp thú cưng phát triển trí tuệ và tăng tương tác với chủ.
- Ẩn đồ chơi hoặc thức ăn để thú cưng tìm kiếm.

![Thú cưng tập kéo co](https://example.com/images/pet_tug_game.jpg)

IV. Video hướng dẫn

<iframe width="560" height="315" src="https://www.youtube.com/embed/pet_exercise_basic" title="Tập luyện cho thú cưng" frameborder="0" allowfullscreen></iframe>

V. Kết luận

Các bài tập đa dạng giúp thú cưng khỏe mạnh và vui vẻ hơn.',
NULL, 20, 1);

-- Tài liệu đính kèm
INSERT INTO lesson_attachments (lesson_id, file_name, file_url, file_size) VALUES
(9, N'Hướng dẫn các bài tập thể dục cho thú cưng.pdf', '/uploads/documents/pet_exercise_guide.pdf', 2300);

-- Khóa học 7: Phòng bệnh và tiêm phòng cho thú cưng
INSERT INTO courses (title, content, post_date, researcher, video_url, status, time)
VALUES
(N'Phòng bệnh và tiêm phòng cho thú cưng', N'Hướng dẫn chi tiết các loại vaccine cần thiết và biện pháp phòng bệnh phổ biến cho chó mèo.', GETDATE(), N'Dr. Hương Lan', NULL, 1, N'3 tuần');

-- Hình ảnh khóa học
INSERT INTO course_images (course_id, image_url, is_primary)
VALUES
(7, '/images/course/course_vaccination.jpg', 1);

-- Modules
INSERT INTO course_modules (course_id, title, description, order_index) VALUES
(7, N'Các bệnh thường gặp', N'Tìm hiểu các bệnh phổ biến ở thú cưng.', 1),
(7, N'Chương trình tiêm phòng', N'Lịch tiêm chủng và hướng dẫn theo dõi sau tiêm.', 2);

-- Bài học module 1
INSERT INTO course_lessons (module_id, title, content, video_url, duration, order_index) VALUES
(13, N'Bài 1: Các bệnh thường gặp ở chó mèo',
N'I. Bệnh dại

- Lây truyền qua vết cắn, gây tử vong gần như 100% nếu không điều trị.
- Triệu chứng: thay đổi hành vi, sợ nước, co giật.

II. Bệnh parvovirus

- Gây tiêu chảy nặng, suy dinh dưỡng, đặc biệt nguy hiểm với chó con.
- Lây truyền qua phân.

III. Bệnh viêm đường hô hấp

- Gây ho, sổ mũi, khó thở.
- Lây qua tiếp xúc và không khí.

IV. Lời khuyên

- Tiêm phòng đầy đủ và định kỳ.
- Giữ vệ sinh nơi ở sạch sẽ, tránh tiếp xúc với thú cưng lạ.

![Phòng bệnh thú cưng](https://example.com/images/pet_disease_prevention.jpg)

V. Kết luận

Hiểu rõ bệnh để phòng tránh là cách tốt nhất bảo vệ thú cưng của bạn.',
NULL, 25, 1);

-- Bài học module 2
INSERT INTO course_lessons (module_id, title, content, video_url, duration, order_index) VALUES
(14, N'Bài 1: Chương trình tiêm phòng cho thú cưng',
N'I. Lịch tiêm phòng cơ bản

- Mũi đầu tiên: từ 6-8 tuần tuổi.
- Tiêm nhắc lại: mỗi 3-4 tuần cho đến khi đủ 16 tuần tuổi.
- Tiêm nhắc lại hàng năm.

II. Các loại vaccine phổ biến

- Vaccine dại.
- Vaccine parvovirus, distemper, adenovirus.
- Vaccine phòng bệnh hô hấp.

III. Chăm sóc sau tiêm

- Theo dõi phản ứng dị ứng, sốt nhẹ.
- Tránh tắm rửa và vận động mạnh trong 24 giờ sau tiêm.

IV. Video hướng dẫn tiêm phòng

<iframe width="560" height="315" src="https://www.youtube.com/embed/pet_vaccination_guide" title="Hướng dẫn tiêm phòng cho thú cưng" frameborder="0" allowfullscreen></iframe>

V. Kết luận

Thực hiện đúng lịch tiêm giúp thú cưng khỏe mạnh, hạn chế nguy cơ dịch bệnh.',
NULL, 22, 1);

-- Tài liệu đính kèm
INSERT INTO lesson_attachments (lesson_id, file_name, file_url, file_size) VALUES
(10, N'Lịch tiêm phòng chuẩn cho thú cưng.pdf', '/uploads/documents/pet_vaccination_schedule.pdf', 2048);

-- Khóa học 8: Dạy thú cưng các lệnh cơ bản
INSERT INTO courses (title, content, post_date, researcher, video_url, status, time)
VALUES
(N'Dạy thú cưng các lệnh cơ bản', N'Hướng dẫn phương pháp dạy thú cưng các lệnh như ngồi, nằm, gọi về, giữ đồ.', GETDATE(), N'Trần Minh Quân', NULL, 1, N'6 tuần');

-- Hình ảnh khóa học
INSERT INTO course_images (course_id, image_url, is_primary)
VALUES
(8, '/images/course/course_basic_commands.jpg', 1);

-- Modules
INSERT INTO course_modules (course_id, title, description, order_index) VALUES
(8, N'Làm quen với thú cưng', N'Thời gian và môi trường phù hợp để bắt đầu huấn luyện.', 1),
(8, N'Các lệnh cơ bản', N'Hướng dẫn từng lệnh chi tiết.', 2);

-- Bài học module 1
INSERT INTO course_lessons (module_id, title, content, video_url, duration, order_index) VALUES
(15, N'Bài 1: Chuẩn bị cho việc huấn luyện',
N'I. Chọn thời điểm

- Thú cưng cần tỉnh táo, không quá đói hay quá no.
- Môi trường yên tĩnh, ít tác động bên ngoài.

II. Chuẩn bị vật dụng

- Đồ ăn thưởng (treats).
- Dây dắt, vòng cổ phù hợp.
- Đồ chơi làm phần thưởng.

III. Thiết lập mục tiêu

- Huấn luyện từng lệnh riêng biệt.
- Giữ kiên nhẫn và khích lệ tích cực.

![Huấn luyện thú cưng](https://example.com/images/pet_training_preparation.jpg)

IV. Kết luận

Chuẩn bị kỹ càng giúp quá trình dạy dễ dàng và hiệu quả hơn.',
NULL, 17, 1);

-- Bài học module 2
INSERT INTO course_lessons (module_id, title, content, video_url, duration, order_index) VALUES
(16, N'Bài 1: Dạy lệnh "Ngồi"',
N'I. Bước 1: Gọi sự chú ý

- Giữ treat trên mũi thú cưng.
- Từ từ nâng treat lên cao khiến thú cưng ngẩng đầu.

II. Bước 2: Ra lệnh và thưởng

- Khi thú cưng ngồi xuống, nói rõ ràng "Ngồi".
- Ngay lập tức thưởng treat và khen ngợi.

III. Lặp lại nhiều lần

- Mỗi buổi 10-15 phút, tập 2-3 lần/ngày.
- Dần dần giảm treat, thay bằng lời khen.

![Dạy lệnh ngồi](https://example.com/images/pet_command_sit.jpg)

IV. Video hướng dẫn

<iframe width="560" height="315" src="https://www.youtube.com/embed/pet_command_sit_tutorial" title="Dạy lệnh Ngồi cho thú cưng" frameborder="0" allowfullscreen></iframe>

V. Kết luận

Luyện tập kiên trì giúp thú cưng nhanh nhớ và phản ứng chính xác.',
NULL, 20, 1);

-- Tài liệu đính kèm
INSERT INTO lesson_attachments (lesson_id, file_name, file_url, file_size) VALUES
(11, N'Hướng dẫn dạy thú cưng các lệnh cơ bản.pdf', '/uploads/documents/pet_basic_commands_guide.pdf', 2700);

-- Khóa học 9: Chăm sóc sức khỏe và dinh dưỡng cho chó con
INSERT INTO courses (title, content, post_date, researcher, video_url, status, time)
VALUES
(N'Chăm sóc sức khỏe và dinh dưỡng cho chó con', N'Kiến thức và kỹ năng chăm sóc chó con từ lúc mới sinh đến 6 tháng tuổi.', GETDATE(), N'Dr. Phạm Thanh', NULL, 1, N'5 tuần');

-- Hình ảnh khóa học
INSERT INTO course_images (course_id, image_url, is_primary)
VALUES
(9, '/images/course/course_puppy_care.jpg', 1);

-- Modules
INSERT INTO course_modules (course_id, title, description, order_index) VALUES
(9, N'Chăm sóc sức khỏe', N'Hướng dẫn theo dõi và chăm sóc chó con.', 1),
(9, N'Dinh dưỡng phù hợp', N'Cách lựa chọn thức ăn và chế độ dinh dưỡng.', 2);

-- Bài học module 1
INSERT INTO course_lessons (module_id, title, content, video_url, duration, order_index) VALUES
(17, N'Bài 1: Theo dõi sức khỏe chó con',
N'I. Các dấu hiệu khỏe mạnh

- Chó con hoạt bát, ăn uống đều.
- Lông mượt, không có vết thương ngoài da.

II. Các dấu hiệu cần chú ý

- Sốt cao, tiêu chảy, nôn mửa.
- Lười ăn, bỏ ăn kéo dài.

III. Cách chăm sóc thường nhật

- Giữ nơi ở sạch sẽ, ấm áp.
- Tiêm phòng đầy đủ và đúng lịch.

![Chó con khỏe mạnh](https://example.com/images/puppy_health_check.jpg)

IV. Kết luận

Chăm sóc sớm giúp chó con phát triển khỏe mạnh và giảm nguy cơ bệnh tật.',
NULL, 18, 1);

-- Bài học module 2
INSERT INTO course_lessons (module_id, title, content, video_url, duration, order_index) VALUES
(18, N'Bài 1: Chế độ dinh dưỡng cho chó con',
N'I. Thức ăn phù hợp

- Sữa mẹ là tốt nhất trong 4 tuần đầu.
- Sau 4 tuần chuyển sang thức ăn dạng mềm hoặc bột dinh dưỡng.

II. Tăng dần thức ăn rắn

- Tập cho chó con ăn dần thức ăn hạt nhỏ.
- Chia khẩu phần nhỏ ăn nhiều lần/ngày.

III. Các loại thức ăn bổ sung

- Vitamin và khoáng chất theo hướng dẫn thú y.
- Tránh thức ăn nhiều muối và chất bảo quản.

![Dinh dưỡng cho chó con](https://example.com/images/puppy_nutrition.jpg)

IV. Video minh họa

<iframe width="560" height="315" src="https://www.youtube.com/embed/puppy_nutrition_guide" title="Chế độ dinh dưỡng cho chó con" frameborder="0" allowfullscreen></iframe>

V. Kết luận

Dinh dưỡng hợp lý giúp chó con phát triển toàn diện và phòng bệnh tốt.',
NULL, 20, 1);

-- Tài liệu đính kèm
INSERT INTO lesson_attachments (lesson_id, file_name, file_url, file_size) VALUES
(12, N'Hướng dẫn dinh dưỡng cho chó con.pdf', '/uploads/documents/puppy_nutrition_guide.pdf', 2400);

-- Khóa học 10: Kỹ thuật cắt tỉa lông và vệ sinh cho thú cưng
INSERT INTO courses (title, content, post_date, researcher, video_url, status, time)
VALUES
(N'Kỹ thuật cắt tỉa lông và vệ sinh cho thú cưng', N'Hướng dẫn các kỹ thuật chăm sóc ngoại hình, cắt tỉa lông và vệ sinh cho thú cưng.', GETDATE(), N'Nguyễn Minh Tú', NULL, 1, N'4 tuần');

-- Hình ảnh khóa học
INSERT INTO course_images (course_id, image_url, is_primary)
VALUES
(10, '/images/course/course_grooming.jpg', 1);

-- Modules
INSERT INTO course_modules (course_id, title, description, order_index) VALUES
(10, N'Chuẩn bị dụng cụ', N'Tổng quan dụng cụ cắt tỉa, chải lông và vệ sinh.', 1),
(10, N'Kỹ thuật cắt tỉa và chăm sóc lông', N'Hướng dẫn từng bước cắt tỉa và chăm sóc lông.', 2);

-- Bài học module 1
INSERT INTO course_lessons (module_id, title, content, video_url, duration, order_index) VALUES
(19, N'Bài 1: Dụng cụ cần thiết',
N'I. Dụng cụ cắt tỉa

- Kéo cắt lông chuyên dụng.
- Tông đơ với nhiều đầu cắt.

II. Dụng cụ vệ sinh

- Bàn chải lông, lược.
- Dầu gội chuyên dụng cho thú cưng.

III. Chuẩn bị môi trường

- Nơi thoáng mát, đủ ánh sáng.
- Bề mặt chắc chắn, chống trơn trượt.

![Dụng cụ cắt tỉa lông](https://example.com/images/grooming_tools.jpg)

IV. Kết luận

Chuẩn bị đầy đủ giúp việc cắt tỉa hiệu quả, an toàn cho thú cưng.',
NULL, 15, 1);

-- Bài học module 2
INSERT INTO course_lessons (module_id, title, content, video_url, duration, order_index) VALUES
(20, N'Bài 1: Kỹ thuật cắt tỉa lông cơ bản',
N'I. Các bước thực hiện

1. Chải lông kỹ để loại bỏ lông rối.
2. Dùng tông đơ cắt tỉa phần lông quá dài.
3. Dùng kéo tạo kiểu lông theo ý muốn.
4. Tắm cho thú cưng với dầu gội phù hợp.
5. Sấy khô và chải lại lần cuối.

II. Lưu ý an toàn

- Không cắt sát da gây tổn thương.
- Giữ thú cưng yên tâm bằng lời nói nhẹ nhàng.
- Nghỉ giải lao nếu thú cưng căng thẳng.

III. Video hướng dẫn

<iframe width="560" height="315" src="https://www.youtube.com/embed/pet_grooming_basics" title="Kỹ thuật cắt tỉa lông" frameborder="0" allowfullscreen></iframe>

IV. Kết luận

Thường xuyên chăm sóc giúp thú cưng sạch sẽ, thoải mái và đẹp hơn.',
NULL, 22, 1);

-- Tài liệu đính kèm
INSERT INTO lesson_attachments (lesson_id, file_name, file_url, file_size) VALUES
(13, N'Hướng dẫn cắt tỉa lông cho thú cưng.pdf', '/uploads/documents/pet_grooming_guide.pdf', 2800);



-- Xóa tài liệu đính kèm trước
DELETE FROM lesson_attachments;
DBCC CHECKIDENT ('lesson_attachments', RESEED, 0);
-- Xóa tất cả bài học
DELETE FROM course_lessons;
DBCC CHECKIDENT ('course_lessons', RESEED, 0);
-- Xóa tất cả chương học (modules)
DELETE FROM course_modules;
DBCC CHECKIDENT ('course_modules', RESEED, 0);




-- Thêm dữ liệu loại tin tức
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
(N'Tin tức PetTech', N'Các bệnh về da thường gặp ở chó');

-- Thêm dữ liệu tin tức (20 bài để test phân trang)
-- Lưu ý: Đoạn này chỉ là ví dụ, bạn có thể thêm nhiều hơn
INSERT INTO Blogs (title, content, short_description, image_url, category_id, is_featured) VALUES
(N'10 cách chăm sóc mèo đúng cách', N'Mèo là loài thú cưng phổ biến tại Việt Nam nhờ vào sự thân thiện và dễ nuôi. Tuy nhiên, để mèo luôn khỏe mạnh và vui vẻ, bạn cần tuân thủ một số nguyên tắc chăm sóc cơ bản. Bài viết này giới thiệu 10 cách đơn giản nhưng hiệu quả để chăm sóc mèo đúng cách như: duy trì chế độ ăn uống hợp lý, lịch tẩy giun định kỳ, giữ vệ sinh khay cát, dành thời gian chơi cùng mèo để tránh stress... Ngoài ra, bạn cũng nên chú ý đến các biểu hiện bất thường để kịp thời đưa mèo đến bác sĩ thú y. Những mẹo nhỏ này sẽ giúp thú cưng của bạn luôn khỏe mạnh và gắn bó hơn với bạn.', N'Hướng dẫn chăm sóc mèo đúng cách', 'images/Blog/blog1.jpg', 1, 1),

(N'Thức ăn tốt nhất cho chó con', N'Chó con trong giai đoạn phát triển cần một chế độ dinh dưỡng đặc biệt, giàu protein và các vi chất thiết yếu để hình thành xương chắc khỏe và hệ miễn dịch vững mạnh. Trong bài viết này, PetTech sẽ giới thiệu những loại thức ăn được các chuyên gia khuyên dùng, bao gồm cả thức ăn khô và ướt phù hợp với từng giống chó. Bên cạnh đó là các lưu ý khi lựa chọn thức ăn: đọc kỹ thành phần, tránh chất bảo quản, không dùng thực phẩm của người. Đảm bảo dinh dưỡng đúng cách từ nhỏ giúp chó con phát triển khỏe mạnh và thông minh.', N'Chọn thức ăn phù hợp cho chó con', 'images/Blog/blog2.jpg', 2, 1),

(N'Dấu hiệu bệnh thường gặp ở mèo', N'Mèo là loài thường che giấu bệnh tật rất khéo, do đó người nuôi cần tinh ý quan sát những thay đổi nhỏ như: mèo ăn ít đi, nôn mửa, tiêu chảy, hay trốn tránh, lười vận động... Bài viết cung cấp danh sách các triệu chứng thường gặp và gợi ý bước đầu để xử lý tại nhà cũng như khi nào nên đưa mèo đến bác sĩ thú y. Sự chủ động phát hiện bệnh sớm không chỉ giúp tiết kiệm chi phí điều trị mà còn bảo vệ sức khỏe lâu dài cho thú cưng của bạn.', N'Nhận biết các dấu hiệu bệnh ở mèo', 'images/Blog/blog3.jpg', 3, 0),

(N'Cách huấn luyện chó đi vệ sinh đúng chỗ', N'Huấn luyện chó đi vệ sinh đúng nơi quy định là một trong những bước quan trọng đầu tiên khi nhận nuôi chó. Bài viết hướng dẫn các bước thực hiện từ cơ bản đến nâng cao: xác định vị trí cố định, tạo thói quen vào khung giờ cố định, dùng tín hiệu lệnh, thưởng thức ăn để khuyến khích... Bên cạnh đó, cũng chia sẻ cách xử lý khi chó đi sai chỗ, giúp chủ nuôi kiên nhẫn và hiệu quả hơn trong quá trình huấn luyện.', N'Hướng dẫn huấn luyện chó cơ bản', 'images/Blog/blog4.jpg', 4, 0),

(N'Giống mèo Anh lông ngắn - Đặc điểm và cách chăm sóc', N'Mèo Anh lông ngắn (British Shorthair) nổi bật với vẻ ngoài mũm mĩm, bộ lông dày mượt và tính cách hiền lành, thân thiện. Đây là giống mèo lý tưởng cho gia đình có trẻ nhỏ hoặc sống trong căn hộ. Bài viết cung cấp cái nhìn toàn diện về đặc điểm giống, nhu cầu vận động, chế độ ăn phù hợp, cũng như lưu ý khi chăm sóc bộ lông và phòng bệnh di truyền. Nếu bạn đang tìm một người bạn bốn chân đáng yêu, mèo Anh lông ngắn chắc chắn là lựa chọn sáng giá.', N'Tìm hiểu về giống mèo Anh lông ngắn', 'images/Blog/blog5.jpg', 5, 1),

(N'Đánh giá 5 loại dây dắt chó tốt nhất 2025', N'Việc chọn dây dắt phù hợp cho chó không chỉ đảm bảo an toàn cho thú cưng mà còn tạo cảm giác thoải mái cho cả người nuôi lẫn vật nuôi trong quá trình dạo chơi. Trong năm 2025, thị trường dây dắt chứng kiến nhiều cải tiến về chất liệu, thiết kế và tính năng. Bài viết này tổng hợp và đánh giá 5 mẫu dây dắt được cộng đồng nuôi thú cưng đánh giá cao nhất, từ loại dây rút tự động, dây chống sốc cho đến dây tích hợp đèn LED dành cho đi bộ buổi tối. Mỗi sản phẩm đều được phân tích về ưu điểm, nhược điểm, giá cả và độ bền, giúp bạn lựa chọn sản phẩm phù hợp với giống chó và nhu cầu sử dụng hàng ngày.', N'Top 5 dây dắt chó chất lượng', 'images/Blog/blog6.jpg', 6, 0),

(N'Chú chó cứu em bé thoát khỏi đám cháy', N'Một câu chuyện cảm động đã xảy ra tại TP. Hồ Chí Minh khi một chú chó giống Labrador đã dũng cảm cứu sống một em bé 2 tuổi mắc kẹt trong đám cháy lớn xảy ra vào rạng sáng. Theo lời kể của người dân, chú chó sủa dữ dội để báo động, sau đó lao vào căn phòng đầy khói và kéo em bé ra ngoài an toàn. Hành động dũng cảm này đã khiến nhiều người xúc động và càng khẳng định vai trò đặc biệt của thú cưng trong đời sống gia đình. Câu chuyện không chỉ lan truyền mạnh mẽ trên mạng xã hội mà còn truyền đi thông điệp đầy nhân văn về tình cảm giữa con người và động vật.', N'Câu chuyện cảm động về chú chó anh hùng', 'images/Blog/blog7.jpg', 7, 1),

(N'Hội chợ thú cưng Hà Nội 2025', N'Hội chợ thú cưng Hà Nội 2025 sẽ chính thức diễn ra từ ngày 15–17/08 tại Trung tâm Triển lãm Giảng Võ, quy tụ hàng trăm gian hàng đến từ các thương hiệu nổi tiếng trong ngành thú cưng. Sự kiện năm nay hứa hẹn mang đến nhiều hoạt động sôi nổi như trình diễn thời trang thú cưng, thi ảnh đẹp thú cưng, khu vực tư vấn sức khỏe miễn phí từ bác sĩ thú y, và đặc biệt là khu vực nhận nuôi miễn phí cho những thú cưng đang cần mái ấm mới. Đây là dịp để cộng đồng yêu thú cưng gặp gỡ, giao lưu và cập nhật xu hướng chăm sóc thú cưng mới nhất năm 2025.', N'Thông tin về hội chợ thú cưng sắp tới', 'images/Blog/blog8.jpg', 8, 0),

(N'10 điều thú vị về loài mèo có thể bạn chưa biết', N'Mèo không chỉ dễ thương mà còn sở hữu rất nhiều đặc điểm độc đáo mà không phải ai cũng biết. Bạn có biết rằng mèo có thể nhảy cao gấp 5 lần chiều dài cơ thể mình? Hay tiếng kêu “meo” mà bạn nghe mỗi ngày thực ra là công cụ giao tiếp chủ yếu dành riêng cho con người, chứ không phải giữa các con mèo với nhau? Bài viết này tổng hợp 10 sự thật thú vị và khoa học về mèo mà chắc chắn sẽ khiến bạn ngạc nhiên và thêm yêu loài động vật đáng yêu này.', N'Khám phá những điều thú vị về loài mèo', 'images/Blog/blog9.jpg', 9, 0),

(N'Các bệnh về da thường gặp ở chó', N'Da là cơ quan nhạy cảm và dễ bị tổn thương ở chó, đặc biệt khi điều kiện thời tiết thay đổi hoặc khi môi trường sống không đảm bảo vệ sinh. Trong thực tế, bệnh da chiếm tỉ lệ cao trong số các ca bệnh thú y. Một số bệnh phổ biến bao gồm: viêm da dị ứng, nấm da, ghẻ, viêm da do ký sinh trùng như ve, bọ chét, và rụng lông từng mảng.

Biểu hiện thường thấy là chó gãi nhiều, liếm liên tục ở một vị trí, da mẩn đỏ, có vảy hoặc nổi mụn nước, lông rụng không đều. Nguyên nhân có thể do môi trường bẩn, dị ứng với thực phẩm, tiếp xúc hóa chất, hoặc do ký sinh trùng ngoài da.

Việc phát hiện sớm và điều trị kịp thời là yếu tố then chốt. Chủ nuôi nên đưa thú cưng đến bác sĩ thú y khi thấy dấu hiệu bất thường, đồng thời giữ gìn vệ sinh chỗ ở, thường xuyên tắm rửa bằng sữa tắm chuyên dụng và sử dụng thuốc chống ký sinh trùng định kỳ.

Ngoài ra, chế độ ăn uống đủ dinh dưỡng, giàu Omega-3 và kẽm sẽ hỗ trợ sức khỏe làn da và bộ lông của chó. Nếu được chăm sóc đúng cách, chó sẽ ít bị bệnh da và luôn có một bộ lông mượt mà, khỏe mạnh.', N'Nhận biết và điều trị bệnh da ở chó', 'images/Blog/blog10.jpg', 3, 0);

