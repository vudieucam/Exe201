-- Tạo database PetTech
CREATE DATABASE PetTech
GO

USE PetTech
GO

-- Tạo bảng gói tài khoản (subscriptions)
CREATE TABLE GoiTaiKhoan (
    MaGoi INT IDENTITY(1,1) PRIMARY KEY,
    TenGoi NVARCHAR(50),
    GiaThang DECIMAL(10,2),
    LoiIch NVARCHAR(MAX)
)
GO

-- Tạo bảng người dùng (users)
CREATE TABLE NguoiDung (
    MaNguoiDung INT IDENTITY(1,1) PRIMARY KEY,
    HoTen NVARCHAR(100),
    Email NVARCHAR(100) UNIQUE,
    MatKhau NVARCHAR(255),
    VaiTro NVARCHAR(20) DEFAULT 'khachhang',
    MaGoi INT NULL,
    NgayDangKy DATE,
    CONSTRAINT FK_NguoiDung_GoiTaiKhoan FOREIGN KEY (MaGoi) REFERENCES GoiTaiKhoan(MaGoi)
)
GO

-- Tạo bảng quản trị viên (admins) tách riêng
CREATE TABLE QuanTriVien (
    MaAdmin INT IDENTITY(1,1) PRIMARY KEY,
    MaNguoiDung INT UNIQUE,
    ChucVu NVARCHAR(100),
    QuyenHan NVARCHAR(MAX),
    CONSTRAINT FK_QuanTriVien_NguoiDung FOREIGN KEY (MaNguoiDung) REFERENCES NguoiDung(MaNguoiDung)
)
GO

-- Tạo bảng đối tác (partners)
CREATE TABLE DoiTac (
    MaDoiTac INT IDENTITY(1,1) PRIMARY KEY,
    TenDoiTac NVARCHAR(100),
    LoaiSanPham NVARCHAR(255),
    EmailLienHe NVARCHAR(100)
)
GO

-- Tạo bảng sản phẩm (products)
CREATE TABLE SanPham (
    MaSanPham INT IDENTITY(1,1) PRIMARY KEY,
    TenSanPham NVARCHAR(255),
    MoTa NVARCHAR(MAX),
    Gia DECIMAL(10,2),
    LoaiThu NVARCHAR(20),
    MaDoiTac INT,
    CONSTRAINT FK_SanPham_DoiTac FOREIGN KEY (MaDoiTac) REFERENCES DoiTac(MaDoiTac)
)
GO

-- Tạo bảng khóa học (courses)
CREATE TABLE KhoaHoc (
    MaKhoaHoc INT IDENTITY(1,1) PRIMARY KEY,
    TieuDe NVARCHAR(255),
    MoTa NVARCHAR(MAX),
    LoaiThu NVARCHAR(20),
    MucDoTruyCap NVARCHAR(20)
)
GO

-- Tạo bảng đăng ký khóa học (enrollments)
CREATE TABLE DangKyKhoaHoc (
    MaDangKy INT IDENTITY(1,1) PRIMARY KEY,
    MaNguoiDung INT,
    MaKhoaHoc INT,
    NgayDangKy DATE,
    CONSTRAINT FK_DangKyKhoaHoc_NguoiDung FOREIGN KEY (MaNguoiDung) REFERENCES NguoiDung(MaNguoiDung),
    CONSTRAINT FK_DangKyKhoaHoc_KhoaHoc FOREIGN KEY (MaKhoaHoc) REFERENCES KhoaHoc(MaKhoaHoc)
)
GO

-- Tạo bảng đơn hàng (orders)
CREATE TABLE DonHang (
    MaDonHang INT IDENTITY(1,1) PRIMARY KEY,
    MaNguoiDung INT,
    NgayDatHang DATE,
    TongTien DECIMAL(10,2),
    TrangThai NVARCHAR(20),
    CONSTRAINT FK_DonHang_NguoiDung FOREIGN KEY (MaNguoiDung) REFERENCES NguoiDung(MaNguoiDung)
)
GO

-- Tạo bảng phản hồi (feedback)
CREATE TABLE PhanHoi (
    MaPhanHoi INT IDENTITY(1,1) PRIMARY KEY,
    MaNguoiDung INT,
    Loai NVARCHAR(20),
    MaDich INT,
    NoiDung NVARCHAR(MAX),
    DanhGia INT CHECK (DanhGia >= 1 AND DanhGia <= 5),
    CONSTRAINT FK_PhanHoi_NguoiDung FOREIGN KEY (MaNguoiDung) REFERENCES NguoiDung(MaNguoiDung)
)
GO

-- Thêm dữ liệu mẫu vào bảng GoiTaiKhoan
INSERT INTO GoiTaiKhoan (TenGoi, GiaThang, LoiIch) VALUES
(N'Free', 0, N'Truy cập bài viết cơ bản, một số khóa học miễn phí')
GO
INSERT INTO GoiTaiKhoan (TenGoi, GiaThang, LoiIch) VALUES
(N'Premium', 99000, N'Học không giới hạn, giảm giá sản phẩm 10%')
GO
INSERT INTO GoiTaiKhoan (TenGoi, GiaThang, LoiIch) VALUES
(N'Elite', 199000, N'Ưu đãi lớn, khóa học độc quyền, giảm giá 20%')
GO

-- Thêm dữ liệu mẫu vào bảng NguoiDung
INSERT INTO NguoiDung (HoTen, Email, MatKhau, VaiTro, MaGoi, NgayDangKy) VALUES
(N'Nguyễn Văn A', 'a.nguyen@gmail.com', 'hash1', N'khachhang', 2, '2025-05-01')
GO
INSERT INTO NguoiDung (HoTen, Email, MatKhau, VaiTro, MaGoi, NgayDangKy) VALUES
(N'Trần Thị B', 'b.tran@gmail.com', 'hash2', N'khachhang', 1, '2025-05-10')
GO
INSERT INTO NguoiDung (HoTen, Email, MatKhau, VaiTro, MaGoi, NgayDangKy) VALUES
(N'Admin User', 'admin@pettech.com', 'hashadmin', N'admin', NULL, '2025-04-15')
GO

-- Thêm dữ liệu mẫu vào bảng QuanTriVien
INSERT INTO QuanTriVien (MaNguoiDung, ChucVu, QuyenHan) VALUES
(3, N'Quản trị viên hệ thống', N'full_access')
GO

-- Thêm dữ liệu mẫu vào bảng DoiTac
INSERT INTO DoiTac (TenDoiTac, LoaiSanPham, EmailLienHe) VALUES
(N'PetFoodVN', N'Thức ăn cho chó, mèo', 'contact@petfoodvn.vn')
GO
INSERT INTO DoiTac (TenDoiTac, LoaiSanPham, EmailLienHe) VALUES
(N'HappyToys', N'Đồ chơi thú cưng', 'info@happytoys.com')
GO
INSERT INTO DoiTac (TenDoiTac, LoaiSanPham, EmailLienHe) VALUES
(N'Care4Pet', N'Vật dụng chăm sóc thú cưng', 'support@care4pet.vn')
GO

-- Thêm dữ liệu mẫu vào bảng SanPham
INSERT INTO SanPham (TenSanPham, MoTa, Gia, LoaiThu, MaDoiTac) VALUES
(N'Hạt dinh dưỡng cho chó', N'Hạt khô giúp chó phát triển', 250000, N'chó', 1)
GO
INSERT INTO SanPham (TenSanPham, MoTa, Gia, LoaiThu, MaDoiTac) VALUES
(N'Bóng đồ chơi cho mèo', N'Giúp mèo vận động vui vẻ', 80000, N'mèo', 2)
GO
INSERT INTO SanPham (TenSanPham, MoTa, Gia, LoaiThu, MaDoiTac) VALUES
(N'Bàn chải lông cho thú cưng', N'Loại bỏ lông rụng hiệu quả', 120000, N'chó,mèo', 3)
GO

-- Thêm dữ liệu mẫu vào bảng KhoaHoc
INSERT INTO KhoaHoc (TieuDe, MoTa, LoaiThu, MucDoTruyCap) VALUES
(N'Huấn luyện chó cơ bản', N'Hướng dẫn huấn luyện chó tại nhà', N'chó', N'premium')
GO
INSERT INTO KhoaHoc (TieuDe, MoTa, LoaiThu, MucDoTruyCap) VALUES
(N'Dinh dưỡng hợp lý cho mèo con', N'Cách chọn thức ăn phù hợp cho mèo con', N'mèo', N'free')
GO
INSERT INTO KhoaHoc (TieuDe, MoTa, LoaiThu, MucDoTruyCap) VALUES
(N'Kỹ năng sơ cứu thú cưng', N'Cách xử lý các tình huống khẩn cấp', N'chó,mèo', N'premium')
GO

-- Thêm dữ liệu mẫu vào bảng DangKyKhoaHoc
INSERT INTO DangKyKhoaHoc (MaNguoiDung, MaKhoaHoc, NgayDangKy) VALUES
(1, 1, '2025-05-02')
GO
INSERT INTO DangKyKhoaHoc (MaNguoiDung, MaKhoaHoc, NgayDangKy) VALUES
(2, 2, '2025-05-11')
GO

-- Thêm dữ liệu mẫu vào bảng DonHang
INSERT INTO DonHang (MaNguoiDung, NgayDatHang, TongTien, TrangThai) VALUES
(1, '2025-05-12', 337500, N'hoàn thành')
GO
INSERT INTO DonHang (MaNguoiDung, NgayDatHang, TongTien, TrangThai) VALUES
(2, '2025-05-20', 120000, N'đang xử lý')
GO

-- Thêm dữ liệu mẫu vào bảng PhanHoi
INSERT INTO PhanHoi (MaNguoiDung, Loai, MaDich, NoiDung, DanhGia) VALUES
(1, N'khóa học', 1, N'Khóa học rất hữu ích và dễ hiểu', 5)
GO
INSERT INTO PhanHoi (MaNguoiDung, Loai
