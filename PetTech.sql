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

-- 8. Sản phẩm
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

-- 9. Đơn hàng & thanh toán
CREATE TABLE orders (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT,
    order_date DATETIME DEFAULT GETDATE(),
    total_amount DECIMAL(12, 0),
    commission DECIMAL(12, 0),
    status NVARCHAR(20) CHECK (status IN (N'pending', N'processing', N'completed', N'cancelled')),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE order_items (
    id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(12, 0),
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

CREATE TABLE payments (
    id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT,
    payment_date DATETIME DEFAULT GETDATE(),
    method NVARCHAR(50),
    amount DECIMAL(12, 0),
    FOREIGN KEY (order_id) REFERENCES orders(id)
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

-- 11. Chương học & bài học
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

-- 12. Tiến độ học tập
CREATE TABLE user_progress (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    lesson_id INT NOT NULL,
    completed BIT DEFAULT 0,
    completed_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (lesson_id) REFERENCES course_lessons(id)
);
-- ===========================================
--          HOÀN TẤT TẠO CẤU TRÚC
-- ===========================================
-- ===========================================
--          THÊM DỮ LIỆU MẪU
-- ===========================================

-- 1. Gói dịch vụ
INSERT INTO service_packages (name, description, price, type)
VALUES 
(N'GÓI MIỄN PHÍ', N'Truy cập cơ bản vào diễn đàn cộng đồng', 0, N'free'),
(N'GÓI TIÊU CHUẨN', N'Truy cập video hướng dẫn & tư vấn định kỳ', 99000, N'standard'),
(N'GÓI CHUYÊN NGHIỆP', N'Toàn quyền truy cập nội dung + ưu đãi đối tác', 199000, N'pro');

-- 2. Người dùng
INSERT INTO users (email, password, phone, address, role, service_package_id)
VALUES 
('alice@gmail.com', 'hashed_pw_1', '0901234567', N'Hà Nội', 'customer', 1),
('bob@gmail.com', 'hashed_pw_2', '0934567890', N'TP HCM', 'customer', 2),
('charlie@gmail.com', 'hashed_pw_3', '0912345678', N'Đà Nẵng', 'customer', 3),
('partner1@shop.vn', 'hashed_pw_4', '0987654321', N'Hải Phòng', 'partner', NULL),
('partner2@shop.vn', 'hashed_pw_5', '0888888888', N'Cần Thơ', 'partner', NULL),
('admin@pettech.vn', 'hashed_admin_pw', NULL, NULL, 'admin', NULL);

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
INSERT INTO orders (user_id, total_amount, commission, status)
VALUES (1, 350000, 10500, 'pending');

INSERT INTO order_items (order_id, product_id, quantity, price)
VALUES (1, 1, 1, 350000);

INSERT INTO payments (order_id, payment_date, method, amount)
VALUES (1, GETDATE(), 'VNPay', 350000);



-- ===========================================
--        HOÀN TẤT TẠO DỮ LIỆU MẪU
-- ===========================================

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


-- Xóa tài liệu đính kèm trước
DELETE FROM lesson_attachments;
DBCC CHECKIDENT ('lesson_attachments', RESEED, 0);
-- Xóa tất cả bài học
DELETE FROM course_lessons;
DBCC CHECKIDENT ('course_lessons', RESEED, 0);
-- Xóa tất cả chương học (modules)
DELETE FROM course_modules;
DBCC CHECKIDENT ('course_modules', RESEED, 0);





