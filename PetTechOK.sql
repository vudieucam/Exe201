USE [master]
GO

IF EXISTS (SELECT * FROM sys.databases WHERE name = 'PetTech')
	DROP DATABASE PetTech
GO
/****** Object:  Database [PetTech]    Script Date: 10/06/2025 1:10:04 CH ******/
CREATE DATABASE [PetTech]
GO
USE [PetTech]
GO
/****** Object:  Table [dbo].[audit_log]    Script Date: 10/06/2025 1:10:04 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[audit_log](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[table_name] [nvarchar](50) NOT NULL,
	[record_id] [int] NOT NULL,
	[action] [nvarchar](20) NOT NULL,
	[old_values] [nvarchar](max) NULL,
	[new_values] [nvarchar](max) NULL,
	[changed_by] [int] NOT NULL,
	[changed_at] [datetime] NULL,
	[status] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BlogCategories]    Script Date: 10/06/2025 1:10:04 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BlogCategories](
	[category_id] [int] IDENTITY(1,1) NOT NULL,
	[category_name] [nvarchar](100) NOT NULL,
	[description] [nvarchar](255) NULL,
	[created_at] [datetime] NULL,
	[status] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[category_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BlogComments]    Script Date: 10/06/2025 1:10:04 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BlogComments](
	[comment_id] [int] IDENTITY(1,1) NOT NULL,
	[blog_id] [int] NOT NULL,
	[user_id] [int] NULL,
	[content] [nvarchar](1000) NOT NULL,
	[created_at] [datetime] NULL,
	[status] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[comment_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Blogs]    Script Date: 10/06/2025 1:10:04 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Blogs](
	[blog_id] [int] IDENTITY(1,1) NOT NULL,
	[title] [nvarchar](255) NOT NULL,
	[content] [nvarchar](max) NOT NULL,
	[short_description] [nvarchar](500) NULL,
	[image_url] [nvarchar](255) NULL,
	[category_id] [int] NOT NULL,
	[author_id] [int] NULL,
	[author_name] [nvarchar](100) NULL,
	[view_count] [int] NULL,
	[is_featured] [bit] NULL,
	[created_at] [datetime] NULL,
	[updated_at] [datetime] NULL,
	[status] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[blog_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[course_access]    Script Date: 10/06/2025 1:10:04 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[course_access](
	[course_id] [int] NOT NULL,
	[service_package_id] [int] NOT NULL,
	[status] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[course_id] ASC,
	[service_package_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[course_categories]    Script Date: 10/06/2025 1:10:04 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[course_categories](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[description] [nvarchar](255) NULL,
	[status] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[course_category_mapping]    Script Date: 10/06/2025 1:10:04 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[course_category_mapping](
	[course_id] [int] NOT NULL,
	[category_id] [int] NOT NULL,
	[status] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[course_id] ASC,
	[category_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[course_images]    Script Date: 10/06/2025 1:10:04 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[course_images](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[course_id] [int] NOT NULL,
	[image_url] [nvarchar](255) NOT NULL,
	[is_primary] [bit] NULL,
	[created_at] [datetime] NULL,
	[status] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[course_lessons]    Script Date: 10/06/2025 1:10:04 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[course_lessons](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[module_id] [int] NOT NULL,
	[title] [nvarchar](255) NOT NULL,
	[content] [nvarchar](max) NULL,
	[video_url] [nvarchar](255) NULL,
	[duration] [int] NULL,
	[order_index] [int] NOT NULL,
	[created_at] [datetime] NULL,
	[updated_at] [datetime] NULL,
	[status] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[course_modules]    Script Date: 10/06/2025 1:10:04 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[course_modules](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[course_id] [int] NOT NULL,
	[title] [nvarchar](255) NOT NULL,
	[description] [nvarchar](max) NULL,
	[order_index] [int] NOT NULL,
	[created_at] [datetime] NULL,
	[updated_at] [datetime] NULL,
	[status] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[course_reviews]    Script Date: 10/06/2025 1:10:04 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[course_reviews](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[course_id] [int] NOT NULL,
	[user_id] [int] NOT NULL,
	[rating] [int] NOT NULL,
	[comment] [nvarchar](max) NULL,
	[created_at] [datetime] NULL,
	[status] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[course_statistics]    Script Date: 10/06/2025 1:10:04 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[course_statistics](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[course_id] [int] NOT NULL,
	[date] [date] NOT NULL,
	[views] [int] NULL,
	[enrollments] [int] NULL,
	[avg_view_duration] [int] NULL,
	[completion_rate] [decimal](5, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[courses]    Script Date: 10/06/2025 1:10:04 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[courses](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[title] [nvarchar](255) NOT NULL,
	[content] [nvarchar](max) NOT NULL,
	[post_date] [date] NOT NULL,
	[researcher] [nvarchar](100) NOT NULL,
	[video_url] [nvarchar](max) NULL,
	[status] [int] NULL,
	[duration] [nvarchar](50) NOT NULL,
	[thumbnail_url] [nvarchar](255) NULL,
	[created_at] [datetime] NULL,
	[updated_at] [datetime] NULL,
	[is_paid] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[daily_statistics]    Script Date: 10/06/2025 1:10:04 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[daily_statistics](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[date] [date] NOT NULL,
	[total_visits] [int] NULL,
	[unique_visitors] [int] NULL,
	[new_users] [int] NULL,
	[avg_session_duration] [int] NULL,
	[page_views] [int] NULL,
	[total_users] [int] NULL,
	[active_users] [int] NULL,
	[new_registrations] [int] NULL,
	[premium_users] [int] NULL,
	[created_at] [datetime] NULL,
	[updated_at] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lesson_attachments]    Script Date: 10/06/2025 1:10:04 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lesson_attachments](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[lesson_id] [int] NOT NULL,
	[file_name] [nvarchar](255) NOT NULL,
	[file_url] [nvarchar](255) NOT NULL,
	[file_size] [int] NULL,
	[status] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[order_items]    Script Date: 10/06/2025 1:10:04 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[order_items](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[order_id] [int] NOT NULL,
	[product_id] [int] NOT NULL,
	[quantity] [int] NOT NULL,
	[price] [decimal](12, 0) NOT NULL,
	[status] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[orders]    Script Date: 10/06/2025 1:10:04 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[orders](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[order_date] [datetime] NULL,
	[total_amount] [decimal](12, 0) NOT NULL,
	[commission] [decimal](12, 0) NOT NULL,
	[status] [nvarchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[partners]    Script Date: 10/06/2025 1:10:04 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[partners](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[email] [nvarchar](100) NOT NULL,
	[phone] [nvarchar](20) NOT NULL,
	[address] [nvarchar](255) NOT NULL,
	[description] [nvarchar](max) NULL,
	[status] [bit] NULL,
	[created_at] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[payments]    Script Date: 10/06/2025 1:10:04 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[payments](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[service_package_id] [int] NULL,
	[order_id] [int] NULL,
	[payment_method] [varchar](50) NOT NULL,
	[amount] [decimal](10, 2) NOT NULL,
	[payment_date] [datetime] NULL,
	[status] [varchar](20) NOT NULL,
	[transaction_id] [varchar](100) NULL,
	[qr_code_url] [nvarchar](500) NULL,
	[bank_account_number] [varchar](20) NULL,
	[bank_name] [nvarchar](100) NULL,
	[notes] [nvarchar](500) NULL,
	[is_confirmed] [bit] NULL,
	[confirmation_code] [varchar](50) NULL,
	[confirmation_expiry] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[product_categories]    Script Date: 10/06/2025 1:10:04 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[product_categories](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[status] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[product_category_mapping]    Script Date: 10/06/2025 1:10:04 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[product_category_mapping](
	[product_id] [int] NOT NULL,
	[category_id] [int] NOT NULL,
	[status] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[product_id] ASC,
	[category_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[products]    Script Date: 10/06/2025 1:10:04 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[products](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](255) NOT NULL,
	[description] [nvarchar](max) NOT NULL,
	[price] [decimal](12, 0) NOT NULL,
	[stock] [int] NOT NULL,
	[partner_id] [int] NULL,
	[image_url] [nvarchar](max) NULL,
	[status] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[service_packages]    Script Date: 10/06/2025 1:10:04 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[service_packages](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](50) NOT NULL,
	[description] [nvarchar](max) NOT NULL,
	[price] [decimal](10, 0) NOT NULL,
	[type] [nvarchar](20) NOT NULL,
	[status] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[user_packages]    Script Date: 10/06/2025 1:10:04 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[user_packages](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[service_package_id] [int] NOT NULL,
	[start_date] [date] NOT NULL,
	[end_date] [date] NOT NULL,
	[status] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[user_progress]    Script Date: 10/06/2025 1:10:04 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[user_progress](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[lesson_id] [int] NOT NULL,
	[completed] [bit] NULL,
	[completed_at] [datetime] NULL,
	[status] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[user_reset_tokens]    Script Date: 10/06/2025 1:10:04 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[user_reset_tokens](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[reset_token] [nvarchar](255) NOT NULL,
	[expiry] [datetime] NOT NULL,
	[status] [bit] NULL,
	[created_at] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User_Service]    Script Date: 10/06/2025 1:10:04 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User_Service](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[package_id] [int] NOT NULL,
	[start_date] [date] NOT NULL,
	[end_date] [date] NOT NULL,
	[status] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[user_sessions]    Script Date: 10/06/2025 1:10:04 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[user_sessions](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NULL,
	[session_id] [nvarchar](255) NOT NULL,
	[ip_address] [nvarchar](50) NULL,
	[user_agent] [nvarchar](255) NULL,
	[login_time] [datetime] NOT NULL,
	[logout_time] [datetime] NULL,
	[duration] [int] NULL,
	[status] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[users]    Script Date: 10/06/2025 1:10:04 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[users](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[email] [nvarchar](100) NOT NULL,
	[password] [nvarchar](100) NOT NULL,
	[fullname] [nvarchar](100) NOT NULL,
	[phone] [nvarchar](20) NOT NULL,
	[address] [nvarchar](255) NOT NULL,
	[role_id] [int] NULL,
	[status] [bit] NULL,
	[created_at] [datetime] NULL,
	[verification_token] [nvarchar](255) NULL,
	[service_package_id] [int] NULL,
	[is_active] [bit] NULL,
	[activation_token] [varchar](100) NULL,
	[token_expiry] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[audit_log] ON 

INSERT [dbo].[audit_log] ([id], [table_name], [record_id], [action], [old_values], [new_values], [changed_by], [changed_at], [status]) VALUES (1, N'users', 1, N'UPDATE', N'{"status":0}', N'{"status":1}', 4, CAST(N'2025-06-03T19:06:35.050' AS DateTime), 1)
INSERT [dbo].[audit_log] ([id], [table_name], [record_id], [action], [old_values], [new_values], [changed_by], [changed_at], [status]) VALUES (2, N'products', 1, N'CREATE', NULL, N'{"name":"Th?c an cho chó v? gà 5kg","price":350000}', 3, CAST(N'2025-06-03T19:06:35.050' AS DateTime), 1)
INSERT [dbo].[audit_log] ([id], [table_name], [record_id], [action], [old_values], [new_values], [changed_by], [changed_at], [status]) VALUES (3, N'orders', 1, N'UPDATE', N'{"status":"processing"}', N'{"status":"completed"}', 2, CAST(N'2025-06-03T19:06:35.050' AS DateTime), 1)
INSERT [dbo].[audit_log] ([id], [table_name], [record_id], [action], [old_values], [new_values], [changed_by], [changed_at], [status]) VALUES (4, N'courses', 1, N'UPDATE', N'{"status":0}', N'{"status":1}', 3, CAST(N'2025-06-06T03:40:04.130' AS DateTime), 1)
INSERT [dbo].[audit_log] ([id], [table_name], [record_id], [action], [old_values], [new_values], [changed_by], [changed_at], [status]) VALUES (5, N'products', 2, N'UPDATE', N'{"price":120000}', N'{"price":125000}', 3, CAST(N'2025-06-06T03:40:04.130' AS DateTime), 1)
INSERT [dbo].[audit_log] ([id], [table_name], [record_id], [action], [old_values], [new_values], [changed_by], [changed_at], [status]) VALUES (6, N'users', 2, N'UPDATE', N'{"role_id":1}', N'{"role_id":2}', 4, CAST(N'2025-06-06T03:40:04.130' AS DateTime), 1)
INSERT [dbo].[audit_log] ([id], [table_name], [record_id], [action], [old_values], [new_values], [changed_by], [changed_at], [status]) VALUES (7, N'orders', 3, N'UPDATE', N'{"status":"pending"}', N'{"status":"processing"}', 2, CAST(N'2025-06-06T03:40:04.130' AS DateTime), 1)
INSERT [dbo].[audit_log] ([id], [table_name], [record_id], [action], [old_values], [new_values], [changed_by], [changed_at], [status]) VALUES (8, N'Blogs', 1, N'CREATE', NULL, N'{"title":"10 cách cham sóc mèo dúng cách"}', 3, CAST(N'2025-06-06T03:40:04.130' AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[audit_log] OFF
GO
SET IDENTITY_INSERT [dbo].[BlogCategories] ON 

INSERT [dbo].[BlogCategories] ([category_id], [category_name], [description], [created_at], [status]) VALUES (1, N'Chăm sóc thú cưng', N'Các bài viết hướng dẫn chăm sóc thú cưng hàng ngày', CAST(N'2025-06-03T19:06:35.020' AS DateTime), 1)
INSERT [dbo].[BlogCategories] ([category_id], [category_name], [description], [created_at], [status]) VALUES (2, N'Dinh dưỡng', N'Chế độ ăn uống và dinh dưỡng cho thú cưng', CAST(N'2025-06-03T19:06:35.020' AS DateTime), 1)
INSERT [dbo].[BlogCategories] ([category_id], [category_name], [description], [created_at], [status]) VALUES (3, N'Y tế - Sức khỏe', N'Các vấn đề về sức khỏe và y tế thú cưng', CAST(N'2025-06-03T19:06:35.020' AS DateTime), 1)
INSERT [dbo].[BlogCategories] ([category_id], [category_name], [description], [created_at], [status]) VALUES (4, N'Đào tạo', N'Cách huấn luyện và đào tạo thú cưng', CAST(N'2025-06-03T19:06:35.020' AS DateTime), 1)
INSERT [dbo].[BlogCategories] ([category_id], [category_name], [description], [created_at], [status]) VALUES (5, N'Giống loài', N'Thông tin về các giống thú cưng phổ biến', CAST(N'2025-06-03T19:06:35.020' AS DateTime), 1)
INSERT [dbo].[BlogCategories] ([category_id], [category_name], [description], [created_at], [status]) VALUES (6, N'Phụ kiện', N'Đánh giá và giới thiệu phụ kiện cho thú cưng', CAST(N'2025-06-03T19:06:35.020' AS DateTime), 1)
INSERT [dbo].[BlogCategories] ([category_id], [category_name], [description], [created_at], [status]) VALUES (7, N'Câu chuyện', N'Những câu chuyện cảm động về thú cưng', CAST(N'2025-06-03T19:06:35.020' AS DateTime), 1)
INSERT [dbo].[BlogCategories] ([category_id], [category_name], [description], [created_at], [status]) VALUES (8, N'Sự kiện', N'Các sự kiện liên quan đến thú cưng', CAST(N'2025-06-03T19:06:35.020' AS DateTime), 1)
INSERT [dbo].[BlogCategories] ([category_id], [category_name], [description], [created_at], [status]) VALUES (9, N'Kiến thức chung', N'Kiến thức tổng hợp về thú cưng', CAST(N'2025-06-03T19:06:35.020' AS DateTime), 1)
INSERT [dbo].[BlogCategories] ([category_id], [category_name], [description], [created_at], [status]) VALUES (10, N'Tin tức PetTech', N'Tin tức và cập nhật từ PetTech', CAST(N'2025-06-03T19:06:35.020' AS DateTime), 1)
INSERT [dbo].[BlogCategories] ([category_id], [category_name], [description], [created_at], [status]) VALUES (11, N'Chó Corgi', N'Chuyên mục về chăm sóc dinh dưỡng, huấn luyện, nuôi dưỡng giống chó Corgi', CAST(N'2025-06-10T04:56:32.053' AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[BlogCategories] OFF
GO
SET IDENTITY_INSERT [dbo].[BlogComments] ON 

INSERT [dbo].[BlogComments] ([comment_id], [blog_id], [user_id], [content], [created_at], [status]) VALUES (1, 1, 1, N'Bài viết rất hữu ích, cảm ơn tác giả!', CAST(N'2025-06-03T19:06:35.050' AS DateTime), 1)
INSERT [dbo].[BlogComments] ([comment_id], [blog_id], [user_id], [content], [created_at], [status]) VALUES (2, 1, 2, N'Tôi đã áp dụng và thấy hiệu quả', CAST(N'2025-06-03T19:06:35.050' AS DateTime), 1)
INSERT [dbo].[BlogComments] ([comment_id], [blog_id], [user_id], [content], [created_at], [status]) VALUES (3, 2, 3, N'Thông tin chi tiết, dễ hiểu', CAST(N'2025-06-03T19:06:35.050' AS DateTime), 1)
INSERT [dbo].[BlogComments] ([comment_id], [blog_id], [user_id], [content], [created_at], [status]) VALUES (4, 3, 4, N'Rất hữu ích cho người nuôi mèo như tôi', CAST(N'2025-06-03T19:06:35.050' AS DateTime), 1)
INSERT [dbo].[BlogComments] ([comment_id], [blog_id], [user_id], [content], [created_at], [status]) VALUES (5, 2, 1, N'Cảm ơn bài viết hữu ích!', CAST(N'2025-06-03T03:40:04.133' AS DateTime), 1)
INSERT [dbo].[BlogComments] ([comment_id], [blog_id], [user_id], [content], [created_at], [status]) VALUES (6, 2, 3, N'Tôi đã thử và thấy hiệu quả', CAST(N'2025-06-04T03:40:04.133' AS DateTime), 1)
INSERT [dbo].[BlogComments] ([comment_id], [blog_id], [user_id], [content], [created_at], [status]) VALUES (7, 3, 2, N'Thông tin rất chi tiết', CAST(N'2025-06-05T03:40:04.133' AS DateTime), 1)
INSERT [dbo].[BlogComments] ([comment_id], [blog_id], [user_id], [content], [created_at], [status]) VALUES (8, 1, 4, N'Bài viết tuyệt vời!', CAST(N'2025-06-06T03:40:04.133' AS DateTime), 1)
INSERT [dbo].[BlogComments] ([comment_id], [blog_id], [user_id], [content], [created_at], [status]) VALUES (9, 3, 5, N'Tôi sẽ áp dụng ngay', CAST(N'2025-06-06T03:40:04.133' AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[BlogComments] OFF
GO
SET IDENTITY_INSERT [dbo].[Blogs] ON 

INSERT [dbo].[Blogs] ([blog_id], [title], [content], [short_description], [image_url], [category_id], [author_id], [author_name], [view_count], [is_featured], [created_at], [updated_at], [status]) VALUES (1, N'10 cách chăm sóc mèo đúng cách', N'

  <div style="background-color: #fff0f5; padding: 20px; border-radius: 12px; box-shadow: 0 2px 8px rgba(255, 192, 203, 0.2);">
    <h1 style="color: #f57ca2; text-align: center; font-size: 24px; margin-bottom: 20px;">10 Cách Chăm Sóc Mèo Đúng Cách</h1>
    
    <p style="color: #777;"><em>Chăm sóc mèo không chỉ là cho ăn và ngủ. Mèo cần sự yêu thương, vệ sinh và môi trường phù hợp để sống khỏe mạnh và hạnh phúc.</em></p>

    <h2 style="color: #e06b95; font-size: 16px;">1. Cung cấp chế độ ăn uống hợp lý</h2>
    <p>Chọn thức ăn phù hợp với độ tuổi, giống loài và sức khỏe của mèo. Tránh đồ ăn của người như sữa bò, xương, thức ăn mặn.</p>

    <h2 style="color: #e06b95; font-size: 16px;">2. Luôn có nước sạch</h2>
    <p>Đặt nhiều bát nước sạch trong nhà để mèo uống đủ mỗi ngày, đặc biệt vào mùa nóng.</p>

    <h2 style="color: #e06b95; font-size: 16px;">3. Vệ sinh khay vệ sinh thường xuyên</h2>
    <p>Khay cát nên được dọn hàng ngày để mèo luôn cảm thấy thoải mái và không nhiễm khuẩn.</p>

    <h2 style="color: #e06b95; font-size: 16px;">4. Chải lông định kỳ</h2>
    <p>Giúp loại bỏ lông rụng và giảm nguy cơ búi lông trong dạ dày, đồng thời là cách thể hiện tình cảm với mèo.</p>

    <h2 style="color: #e06b95; font-size: 16px;">5. Khám sức khỏe định kỳ</h2>
    <p>Tiêm phòng, tẩy giun và kiểm tra sức khỏe định kỳ ít nhất mỗi năm một lần.</p>

    <h2 style="color: #e06b95; font-size: 16px;">6. Tạo không gian vui chơi an toàn</h2>
    <p>Có đồ chơi, nơi leo trèo, trụ cào móng giúp mèo hoạt động, không buồn chán.</p>

    <h2 style="color: #e06b95; font-size: 16px;">7. Triệt sản đúng thời điểm</h2>
    <p>Giúp hạn chế sinh sản ngoài ý muốn và giảm nguy cơ mắc các bệnh sinh sản.</p>

    <h2 style="color: #e06b95; font-size: 16px;">8. Không đánh mèo khi huấn luyện</h2>
    <p>Hãy dùng cách thưởng để khuyến khích hành vi tốt, không nên la mắng hay đánh đập.</p>

    <h2 style="color: #e06b95; font-size: 16px;">9. Giữ môi trường sạch sẽ, yên tĩnh</h2>
    <p>Mèo thích sự yên tĩnh và không gian sạch. Tránh tiếng ồn lớn khiến mèo stress.</p>

    <h2 style="color: #e06b95; font-size: 16px;">10. Giao tiếp và yêu thương mỗi ngày</h2>
    <p>Dành thời gian vuốt ve, nói chuyện hoặc chơi cùng mèo để tăng sự gắn kết.</p>

    <p style="margin-top: 20px;"><strong style="color: #d44f8c;">Ghi nhớ:</strong> Mèo không chỉ cần ăn ngon mà còn cần tình cảm và sự quan tâm từ bạn mỗi ngày!</p>
  </div>

', N'Hướng dẫn chăm sóc mèo đúng cách', N'images/Blog/bog1.jpg', 1, NULL, N'Admin', 0, 1, CAST(N'2025-06-03T19:06:35.047' AS DateTime), CAST(N'2025-06-10T08:29:29.180' AS DateTime), 1)
INSERT [dbo].[Blogs] ([blog_id], [title], [content], [short_description], [image_url], [category_id], [author_id], [author_name], [view_count], [is_featured], [created_at], [updated_at], [status]) VALUES (2, N'Thức ăn tốt nhất cho chó con', N'Nội dung chi tiết...', N'Chọn thức ăn phù hợp cho chó con', N'images/Blog/blog2.jpg', 2, NULL, N'Admin', 0, 1, CAST(N'2025-06-03T19:06:35.047' AS DateTime), CAST(N'2025-06-03T19:06:35.047' AS DateTime), 1)
INSERT [dbo].[Blogs] ([blog_id], [title], [content], [short_description], [image_url], [category_id], [author_id], [author_name], [view_count], [is_featured], [created_at], [updated_at], [status]) VALUES (3, N'Dấu hiệu bệnh thường gặp ở mèo', N'Để nhận biết mèo bị bệnh, bạn có thể quan sát các dấu hiệu sau: phân loãng, có giun hoặc màu đỏ kèm mùi tanh; mèo nôn mửa hoặc co thắt bụng. Ngoài ra, mèo có thể chán ăn, yếu ớt, mệt mỏi hoặc không tăng cân dù ăn uống đầy đủ. Thay đổi trong hành vi, tương tác với người cũng là dấu hiệu cần lưu ý. Những dấu hiệu này có thể chỉ ra các vấn đề sức khỏe khác nhau và cần đưa mèo đến bác sĩ thú y để được chẩn đoán và điều trị kịp thời.', N'Nhận biết các dấu hiệu bệnh ở mèo', N'images/Blog/blog10.jpg', 1, NULL, N'Admin', 0, 1, CAST(N'2025-06-03T19:06:35.047' AS DateTime), CAST(N'2025-06-10T07:37:49.823' AS DateTime), 1)
INSERT [dbo].[Blogs] ([blog_id], [title], [content], [short_description], [image_url], [category_id], [author_id], [author_name], [view_count], [is_featured], [created_at], [updated_at], [status]) VALUES (4, N'Huấn luyện thú cưng', N'<h1 style="color: #d2691e; font-size: 22px;">Chó Corgi: "Quốc khuyển" nhỏ nhưng có võ, đốn tim giới trẻ toàn cầu</h1>
  <p style="font-style: italic; color: #888888; margin-bottom: 20px;">Ngày 10/6/2025</p>

  <p><strong>Corgi</strong>, giống chó chân ngắn đáng yêu với ngoại hình "một mẩu" cùng tính cách hài hước, tiếp tục giữ vững ngôi vị "quốc khuyển" được yêu thích nhất trên mạng xã hội và trong làng thú cưng toàn cầu.</p>

  <h2 style="color: #2c7bbf; font-size: 18px;">Nguồn gốc hoàng gia</h2>
  <p>Corgi (gồm hai loại phổ biến là <strong>Pembroke</strong> và <strong>Cardigan</strong>) xuất thân từ xứ Wales (Anh Quốc), nổi tiếng nhờ mối liên hệ với Hoàng gia Anh. Nữ hoàng Elizabeth II từng nuôi hơn 30 chú Corgi trong suốt cuộc đời, biến chúng thành biểu tượng của sự quý tộc.</p>

  <h2 style="color: #2c7bbf; font-size: 18px;">Ngoại hình "cực phẩm"</h2>
  <ul style="padding-left: 20px; margin-bottom: 16px;">
    <li><strong>Chân ngắn, mông to:</strong> Đôi chân ngắn củn đũn cùng vòng mông tròn trịa là "đặc sản" khiến Corgi gây bão mạng.</li>
    <li><strong>Gương mặt "cười":</strong> Mõm nhỏ, tai dựng, đôi mắt lấp lánh tạo nên biểu cảm "siêu hài" khiến ai cũng phải tan chảy.</li>
    <li><strong>Lông đa dạng:</strong> Màu phổ biến nhất là vàng-trắng, nâu-đen, hoặc tam thể.</li>
  </ul>

  <h2 style="color: #2c7bbf; font-size: 18px;">Tính cách "nhỏ nhưng có võ"</h2>
  <ul style="padding-left: 20px; margin-bottom: 16px;">
    <li><strong>Thông minh, dễ huấn luyện:</strong> Corgi xếp thứ 11 trong danh sách chó thông minh nhất thế giới (theo Stanley Coren).</li>
    <li><strong>Năng động, hài hước:</strong> Chúng thích chạy nhảy, chơi đùa và có khả năng "biểu diễn" những hành động khiến chủ nhân cười nghiêng ngả.</li>
    <li><strong>Trung thành:</strong> Dù nhỏ con, Corgi có bản năng bảo vệ gia đình rất cao.</li>
  </ul>

  <h2 style="color: #2c7bbf; font-size: 18px;">Lưu ý khi nuôi Corgi</h2>
  <ul style="padding-left: 20px; margin-bottom: 16px;">
    <li><strong>Dễ béo phì:</strong> Do yêu thích ăn uống, chủ nuôi cần kiểm soát khẩu phần để tránh bệnh xương khớp.</li>
    <li><strong>Chải lông thường xuyên:</strong> Lớp lông kép dày rụng nhiều vào mùa thay lông.</li>
    <li><strong>Tuổi thọ:</strong> Trung bình 12-15 năm nếu được chăm sóc tốt.</li>
  </ul>

  <h2 style="color: #2c7bbf; font-size: 18px;">Corgi trong văn hóa đại chúng</h2>
  <p>Từ meme "Corgi bơi" đến loạt phim như <em>"The Queen’s Corgi"</em>, những chú chó này liên tục "đại náo" mạng xã hội. Tại Việt Nam, giá một bé Corgi thuần chủng dao động từ <strong>15-50 triệu đồng</strong> tùy nguồn gốc.</p>
', N'Chó corgi cute', N'images/Blog/Cho_Corgi_1.jpeg', 11, NULL, N'Cẩm', 0, 1, CAST(N'2025-06-10T06:50:35.477' AS DateTime), CAST(N'2025-06-10T08:35:48.400' AS DateTime), 1)
INSERT [dbo].[Blogs] ([blog_id], [title], [content], [short_description], [image_url], [category_id], [author_id], [author_name], [view_count], [is_featured], [created_at], [updated_at], [status]) VALUES (5, N'Huấn luyện thú cưng', N'<div style="max-width: 800px; margin: auto; font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
  <h1 style="text-align: center; color: #2c3e50;">Top Các Loại Dây Xích Chó Được Ưa Chuộng Hiện Nay</h1>
  <p style="text-align: center;"><em>Cập nhật ngày 10/06/2025 - PetTech Blog</em></p>
  
  <p>
    Dây xích là một trong những phụ kiện quan trọng không thể thiếu khi nuôi chó. Không chỉ giúp kiểm soát thú cưng, dây xích còn thể hiện phong cách và cá tính riêng biệt. Dưới đây là tổng hợp một số loại dây xích phổ biến được nhiều người yêu thích:
  </p>

  <h2 style="color: #2980b9;">1. Dây Xích Da Cao Cấp</h2>

  <p>
    Dây xích bằng da thật thường có độ bền cao, mềm mại và không gây đau cho thú cưng. Phù hợp với chó có kích thước vừa và lớn, đồng thời mang lại vẻ ngoài sang trọng.
  </p>

  <h2 style="color: #2980b9;">2. Dây Xích Rút Tự Động</h2>
 
  <p>
    Loại dây này cho phép chó cưng di chuyển trong phạm vi nhất định mà vẫn được kiểm soát tốt. Dây rút rất phù hợp cho việc dạo chơi ngoài công viên hoặc các khu vực rộng.
  </p>

  <h2 style="color: #2980b9;">3. Dây Xích Vải Nylon Mềm</h2>
 
  <p>
    Dây nylon có nhiều màu sắc và mẫu mã đa dạng, phù hợp với các giống chó nhỏ và vừa. Chất liệu nhẹ, dễ giặt và giá thành phải chăng là ưu điểm lớn.
  </p>

  <h2 style="color: #2980b9;">4. Dây Xích Xích Yếm</h2>
  
  <p>
    Dây yếm giúp giảm áp lực lên cổ chó, phù hợp với các giống chó nhỏ hoặc dễ bị tổn thương. Kiểu dáng hiện đại và giúp kiểm soát hành vi tốt hơn trong quá trình huấn luyện.
  </p>

  <div style="background: #f1f1f1; padding: 20px; border-radius: 10px; margin-top: 30px;">
    <h3 style="color: #16a085;">Lưu ý khi chọn dây xích cho chó:</h3>
    <ul>
      <li>Chọn chiều dài phù hợp với môi trường sử dụng</li>
      <li>Chất liệu mềm, không gây tổn thương da thú cưng</li>
      <li>Đảm bảo móc khóa chắc chắn và dễ sử dụng</li>
      <li>Ưu tiên dây có khả năng điều chỉnh chiều dài hoặc kích thước</li>
    </ul>
  </div>

  <p style="margin-top: 30px;">Hy vọng bài viết giúp bạn lựa chọn được loại dây xích phù hợp cho bé cưng của mình. Đừng quên ghé thăm <strong>PetTech</strong> để khám phá thêm nhiều sản phẩm thú cưng chất lượng khác nhé!</p>
</div>
', N'Dây xích chó', N'images/Blog/blog6.jpg', 6, NULL, N'Cẩm', 0, 1, CAST(N'2025-06-10T06:52:02.770' AS DateTime), CAST(N'2025-06-10T08:34:24.020' AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[Blogs] OFF
GO
INSERT [dbo].[course_access] ([course_id], [service_package_id], [status]) VALUES (1, 2, 1)
INSERT [dbo].[course_access] ([course_id], [service_package_id], [status]) VALUES (1, 3, 1)
INSERT [dbo].[course_access] ([course_id], [service_package_id], [status]) VALUES (2, 2, 1)
INSERT [dbo].[course_access] ([course_id], [service_package_id], [status]) VALUES (2, 3, 1)
INSERT [dbo].[course_access] ([course_id], [service_package_id], [status]) VALUES (3, 3, 1)
INSERT [dbo].[course_access] ([course_id], [service_package_id], [status]) VALUES (4, 3, 1)
INSERT [dbo].[course_access] ([course_id], [service_package_id], [status]) VALUES (5, 2, 1)
INSERT [dbo].[course_access] ([course_id], [service_package_id], [status]) VALUES (5, 3, 1)
GO
SET IDENTITY_INSERT [dbo].[course_categories] ON 

INSERT [dbo].[course_categories] ([id], [name], [description], [status]) VALUES (1, N'Chăm sóc cơ bản', NULL, 1)
INSERT [dbo].[course_categories] ([id], [name], [description], [status]) VALUES (2, N'Dinh dưỡng', NULL, 1)
INSERT [dbo].[course_categories] ([id], [name], [description], [status]) VALUES (3, N'Sức khỏe', NULL, 1)
INSERT [dbo].[course_categories] ([id], [name], [description], [status]) VALUES (4, N'Huấn luyện', NULL, 1)
SET IDENTITY_INSERT [dbo].[course_categories] OFF
GO
INSERT [dbo].[course_category_mapping] ([course_id], [category_id], [status]) VALUES (1, 1, 1)
INSERT [dbo].[course_category_mapping] ([course_id], [category_id], [status]) VALUES (2, 2, 1)
INSERT [dbo].[course_category_mapping] ([course_id], [category_id], [status]) VALUES (3, 3, 1)
INSERT [dbo].[course_category_mapping] ([course_id], [category_id], [status]) VALUES (4, 4, 1)
INSERT [dbo].[course_category_mapping] ([course_id], [category_id], [status]) VALUES (5, 1, 1)
INSERT [dbo].[course_category_mapping] ([course_id], [category_id], [status]) VALUES (5, 2, 1)
GO
SET IDENTITY_INSERT [dbo].[course_images] ON 

INSERT [dbo].[course_images] ([id], [course_id], [image_url], [is_primary], [created_at], [status]) VALUES (1, 1, N'/images/course/course_dog_2.jpg', 0, CAST(N'2025-06-03T19:06:35.023' AS DateTime), 1)
INSERT [dbo].[course_images] ([id], [course_id], [image_url], [is_primary], [created_at], [status]) VALUES (2, 1, N'/images/course/course_dog_3.jpg', 0, CAST(N'2025-06-03T19:06:35.023' AS DateTime), 1)
INSERT [dbo].[course_images] ([id], [course_id], [image_url], [is_primary], [created_at], [status]) VALUES (3, 2, N'/images/course/course_cat_2.jpg', 0, CAST(N'2025-06-03T19:06:35.023' AS DateTime), 1)
INSERT [dbo].[course_images] ([id], [course_id], [image_url], [is_primary], [created_at], [status]) VALUES (4, 3, N'/images/course/course_pet_first_aid_2.jpg', 0, CAST(N'2025-06-03T19:06:35.023' AS DateTime), 1)
INSERT [dbo].[course_images] ([id], [course_id], [image_url], [is_primary], [created_at], [status]) VALUES (5, 4, N'/images/course/course_training_dog_2.jpg', 0, CAST(N'2025-06-03T19:06:35.023' AS DateTime), 1)
INSERT [dbo].[course_images] ([id], [course_id], [image_url], [is_primary], [created_at], [status]) VALUES (6, 5, N'/images/course/course_cat_care_2.jpg', 0, CAST(N'2025-06-03T19:06:35.023' AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[course_images] OFF
GO
SET IDENTITY_INSERT [dbo].[course_lessons] ON 

INSERT [dbo].[course_lessons] ([id], [module_id], [title], [content], [video_url], [duration], [order_index], [created_at], [updated_at], [status]) VALUES (1, 1, N'Bài 1. Vệ sinh ổ đẻ cho các chú cún con đảm bảo sạch sẽ', N'Sau khi trải qua quá trình sinh, chó mẹ thường dành phần lớn thời gian để nghỉ ngơi bên cạnh đàn con của mình, chỉ rời khỏi để đi vệ sinh hoặc ăn uống. 
Chúng ta có thể tận dụng thời gian này để làm vệ sinh, quét dọn và thay khăn lót ổ đẻ. 
Đảm bảo môi trường ổ đẻ khô ráo và thoáng mát là cách giúp ngăn ngừa sự phát triển của vi khuẩn và bảo vệ sức khỏe cho chó con non nớt.
Tuy nhiên, các bạn cần lưu ý không nên lót quá nhiều lớp vải trong ổ đẻ. 
Điều này giúp tránh tình trạng chó con chưa mở mắt gặp khó khăn trong việc tìm hiểu phương hướng và không thể tìm đến chó mẹ để bú.', NULL, 10, 1, CAST(N'2025-06-03T19:06:35.040' AS DateTime), CAST(N'2025-06-03T19:06:35.040' AS DateTime), 1)
INSERT [dbo].[course_lessons] ([id], [module_id], [title], [content], [video_url], [duration], [order_index], [created_at], [updated_at], [status]) VALUES (2, 1, N'Bài 2. Chú ý làm sạch cơ thể cho cún con mới sinh', N'Hầu hết chó con khi mới sinh ra sẽ có lớp nhầy nhớt hoặc vết bẩn từ nước ối. 
Để làm sạch, bạn nên sử dụng một khăn mềm thấm nước ấm và nhẹ nhàng lau cho đến khi sạch. 
Đây là một bước quan trọng trong quá trình chăm sóc chó con mới sinh.
Chó con sau khi sinh ra rất nhỏ bé và yếu đuối, tương tự như một đứa trẻ. 
Nếu bạn không có kinh nghiệm trong việc nuôi chó con mới sinh, hãy tìm hiểu kỹ càng và thực hiện nhẹ nhàng từng bước chăm sóc.
Trong những ngày đầu, chó con sẽ có cuống rốn còn dính trên bụng. 
Bạn không nên cắt nó quá sớm vì điều này có thể gây ra xuất huyết và chảy máu cho chó con. 
Hãy để cuống rốn tự teo dần theo thời gian và không cần lo lắng về điều này.', NULL, 15, 2, CAST(N'2025-06-03T19:06:35.040' AS DateTime), CAST(N'2025-06-03T19:06:35.040' AS DateTime), 1)
INSERT [dbo].[course_lessons] ([id], [module_id], [title], [content], [video_url], [duration], [order_index], [created_at], [updated_at], [status]) VALUES (3, 1, N'Bài 3. Hỗ trợ giúp chó con tập bú mẹ nếu cần', N'Chó con khi mới sinh ra thường rất yếu đuối, không thể đi lại và chưa mở mắt. Thời gian mà chó con mới mở mắt thường là ít nhất 11 ngày (tùy thuộc vào số lượng con sinh ra trong một lứa).
Chó con cần phải dò dẫm và chui rúc xung quanh để tìm vú mẹ và sau đó mới có thể bú sữa. Để hỗ trợ chó con trong việc tìm và bú vú mẹ, bạn có thể áp dụng phương pháp nuôi chó con mới sinh dưới đây:

Bước 1: Nhẹ nhàng bế chó con lên và đặt miệng của chúng gần núm vú của chó mẹ.
Bước 2: Sử dụng một ngón tay nhỏ và cắt móng sạch sẽ, sau đó đặt nhẹ nhàng ngón tay trong miệng của chó con và đặt miệng chúng vào núm vú của chó mẹ. Cuối cùng, từ từ rút ngón tay ra khỏi miệng chó con.
Bước 3: Vắt ra vài giọt sữa từ vú của chó mẹ, sau đó bôi nhẹ nhàng lên mũi của chó con. Chó con sẽ theo mùi sữa và tìm đường đến vú của chó mẹ.

Bằng cách sử dụng phương pháp trên, bạn có thể nuôi chó con mới sinh một cách tốt nhất, giúp chúng phát triển khỏe mạnh và tăng trưởng nhanh chóng.', NULL, 20, 3, CAST(N'2025-06-03T19:06:35.040' AS DateTime), CAST(N'2025-06-03T19:06:35.040' AS DateTime), 1)
INSERT [dbo].[course_lessons] ([id], [module_id], [title], [content], [video_url], [duration], [order_index], [created_at], [updated_at], [status]) VALUES (4, 1, N'Bài 4. Điều chỉnh nhiệt độ ổ nằm', N'Trong quá trình tìm hiểu về cách chăm sóc chó con mới sinh, quan trọng là bạn hiểu rằng chó con cần được nuôi ở một môi trường có nhiệt độ ấm áp. Do đó, khi chuẩn bị ổ đẻ, chó mẹ thường chọn những nơi kín đáo và ấm áp.
Nếu chó mẹ sinh con vào mùa lạnh, bạn cần hỗ trợ bằng cách sử dụng các thiết bị sưởi ấm, máy điều hòa và che chắn khỏi gió. Nhiệt độ lý tưởng cho khu vực ổ đẻ là khoảng 27 độ C và độ ẩm dưới 80%.

Ngoài ra, bạn cũng cần lưu ý về việc kiểm tra nhu cầu về nhiệt độ của chó con. Nếu nhiệt độ phù hợp, chó con sẽ ngủ ngon, không kêu nhiều và khoảng cách giữa chúng sẽ đều nhau.

Nếu ổ đẻ quá nóng, chó con sẽ nằm xa nhau, kêu và quậy nhiều. Nếu ổ đẻ quá lạnh, chó con sẽ rúc vào nhau. Vì vậy, dựa vào những dấu hiệu này, chúng ta cần tạo một môi trường sống thích hợp nhất để giúp chó con mới sinh phát triển.', NULL, 15, 4, CAST(N'2025-06-03T19:06:35.040' AS DateTime), CAST(N'2025-06-03T19:06:35.040' AS DateTime), 1)
INSERT [dbo].[course_lessons] ([id], [module_id], [title], [content], [video_url], [duration], [order_index], [created_at], [updated_at], [status]) VALUES (5, 1, N'Bài 5. Phòng bệnh, thăm khám cho chó con mới đẻ định kỳ', N'Cùng chúng mình tìm hiểu các cách phòng chống hiệu quả và an toàn để chó con mới đẻ không mắc những loại bệnh nguy hiểm nhé.

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

Hãy thực hiện tốt các bước trên nếu không muốn thú cưng bị mắc bệnh và không muốn mầm bệnh này lây lan nhanh chóng ra các chú chó khác trong đàn nhé!', NULL, 10, 5, CAST(N'2025-06-03T19:06:35.040' AS DateTime), CAST(N'2025-06-03T19:06:35.040' AS DateTime), 1)
INSERT [dbo].[course_lessons] ([id], [module_id], [title], [content], [video_url], [duration], [order_index], [created_at], [updated_at], [status]) VALUES (6, 1, N'Bài 6. Chó con mới đẻ cần được tiêm phòng', N'Dù trong sữa mẹ có nhiều kháng thể có lợi cho sức khỏe nhưng bạn vẫn nên đưa thú cưng đi tiêm phòng bởi đây chính là phương pháp an toàn và hiệu quả nhất để phòng bệnh và tăng sức đề kháng cho chó con.

Trước khi tiêm phòng, bạn nên hỏi cặn kẽ bác sĩ về kế hoạch tiêm để có thể thực hiện đầy đủ, đúng thời gian. Mũi tiêm đúng thời điểm sẽ phát huy hết công dụng và có thể bảo vệ tốt sức khỏe cho chó con.', NULL, 5, 6, CAST(N'2025-06-03T19:06:35.040' AS DateTime), CAST(N'2025-06-03T19:06:35.040' AS DateTime), 1)
INSERT [dbo].[course_lessons] ([id], [module_id], [title], [content], [video_url], [duration], [order_index], [created_at], [updated_at], [status]) VALUES (7, 1, N'Bài 7. Hướng dẫn cách chăm sóc chó con mới đẻ tập ăn dặm', N'Sau một thời gian cho con bú, sữa của chó mẹ sẽ dần cạn kiệt và không đủ cung cấp dinh dưỡng cho chó con. Đồng thời, chó con cũng đang phát triển và cần nạp nhiều năng lượng hơn.
Khi chó con mở mắt được vài ngày, bạn có thể bắt đầu cho chúng làm quen với việc ăn dặm bằng món cháo nấu loãng với thịt. Sau khi chó con đã quen tiêu hóa các thức ăn ngoài, hãy bổ sung thêm rau, củ trong khẩu phần ăn của chúng hàng ngày.', NULL, 5, 7, CAST(N'2025-06-03T19:06:35.040' AS DateTime), CAST(N'2025-06-03T19:06:35.040' AS DateTime), 1)
INSERT [dbo].[course_lessons] ([id], [module_id], [title], [content], [video_url], [duration], [order_index], [created_at], [updated_at], [status]) VALUES (8, 2, N'Bài 1: Chế độ dinh dưỡng cho chó con mới đẻ', N'Để chăm sóc chó con mới đẻ và đảm bảo sự phát triển tốt, các bạn cần chú ý cung cấp cho chúng nguồn dinh dưỡng đa dạng. Dưới đây là những gợi ý để chăm sóc chó con mới đẻ:

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

Trên đây là chia sẻ cách chăm sóc chó con mới đẻ của PetTech. Nếu bạn có nhu cầu mua sữa hay các sản phẩm thức ăn cho vật nuôi của mình, hãy liên hệ PetTech để được tư vấn.', N'https://youtube.com/embed/123', 20, 1, CAST(N'2025-06-03T19:06:35.040' AS DateTime), CAST(N'2025-06-03T19:06:35.040' AS DateTime), 1)
INSERT [dbo].[course_lessons] ([id], [module_id], [title], [content], [video_url], [duration], [order_index], [created_at], [updated_at], [status]) VALUES (9, 3, N'Bài 1: Khi mèo mẹ sinh nở', N'Khi mèo mẹ gần chuyển dạ bạn nên chuẩn bị cho chúng một ổ để êm ái và gần gũi, nói chuyện với chúng để mèo nhà bạn yên tâm chuyển dạ.
Nhưng đặc biệt khi lúc sinh, bạn nên đứng quan sát từ xa, hạn chế việc lại gần gây mất tập trung cho mèo mẹ. Song, bạn nên chuẩn bị một tô cháo loãng để mèo mẹ lấy lại sức sau khi sinh.', NULL, 3, 1, CAST(N'2025-06-03T19:06:35.040' AS DateTime), CAST(N'2025-06-03T19:06:35.040' AS DateTime), 1)
INSERT [dbo].[course_lessons] ([id], [module_id], [title], [content], [video_url], [duration], [order_index], [created_at], [updated_at], [status]) VALUES (10, 3, N'Bài 2: Dinh dưỡng cho mèo mẹ', N'Sau khi sinh xong là thời điểm bạn nên quan tâm đến chế độ dinh dưỡng của chúng bởi mèo mẹ đang cần nhiều sữa để cho mèo con, Thế nên, bạn nên cung cấp những loại thức ăn cho mèo hoặc thực phẩm mềm, dễ tiêu hóa có chứa hàm lượng tinh bột, protein và các dưỡng chất cần thiết khác.', N'https://youtube.com/embed/456', 2, 2, CAST(N'2025-06-03T19:06:35.040' AS DateTime), CAST(N'2025-06-03T19:06:35.040' AS DateTime), 1)
INSERT [dbo].[course_lessons] ([id], [module_id], [title], [content], [video_url], [duration], [order_index], [created_at], [updated_at], [status]) VALUES (11, 3, N'Bài 3: Dinh dưỡng cho mèo con', N'Với mèo con sau dinh thì chất dinh dưỡng tốt nhất đó chính là sữa mẹ, vì thế ở giai đoạn này bạn không cần can thiệp quá nhiều về chế độ dinh dưỡng của chúng. Nhưng bạn cũng phải quan sát nếu mèo mẹ không đủ sữa cung cấp thì bạn có thể hỗ trợ nguồn sữa ngoài cho chúng.', N'https://youtube.com/embed/456', 2, 3, CAST(N'2025-06-03T19:06:35.040' AS DateTime), CAST(N'2025-06-03T19:06:35.040' AS DateTime), 1)
INSERT [dbo].[course_lessons] ([id], [module_id], [title], [content], [video_url], [duration], [order_index], [created_at], [updated_at], [status]) VALUES (12, 3, N'Bài 4: Tập cho mèo con đi vệ sinh', N'Việc tập cho mèo con đi vệ sinh thường là thiên chức của mèo mẹ, nhưng bạn cũng có thể hỗ trợ chúng bằng việc đặt mèo con vào khay cát chuyên dụng để mèo nhận biết được vị trí và để mèo tập cào cát và lấp chất thải.
Bạn hãy kiên nhẫn lập lại việc này khoảng 3 - 4 lần thì mèo con sẽ tự nhận biết và trở thành thói quen, giúp việc chăm sóc mèo trở nên dễ dàng hơn.', N'https://youtube.com/embed/456', 2, 4, CAST(N'2025-06-03T19:06:35.040' AS DateTime), CAST(N'2025-06-03T19:06:35.040' AS DateTime), 1)
INSERT [dbo].[course_lessons] ([id], [module_id], [title], [content], [video_url], [duration], [order_index], [created_at], [updated_at], [status]) VALUES (13, 4, N'Bài 1: Làm ổ cho mèo', N'Với mèo con mất mẹ bạn cần chú ý và cẩn thận nhiều hơn, bạn nên làm tổ cho mèo con phải thật sự đủ ấm và an toàn, tránh các tác động của tự nhiên hay các vật nuôi khác.
Tốt nhất bạn nên sử dụng các hộp giấy có thành cao để làm ổ cho mèo, bên trong có lót chăn hay vải mềm để tạo sự thoải mái cho mèo và phải đảm bảo mức nhiệt độ khoảng 37 độ C để giữ ấm cho mèo.', N'https://youtube.com/embed/456', 2, 1, CAST(N'2025-06-03T19:06:35.040' AS DateTime), CAST(N'2025-06-03T19:06:35.040' AS DateTime), 1)
INSERT [dbo].[course_lessons] ([id], [module_id], [title], [content], [video_url], [duration], [order_index], [created_at], [updated_at], [status]) VALUES (14, 4, N'Bài 2: Cho mèo con uống sữa', N'Với giai đoạn này thì sữa là nguồn dinh dưỡng thiết yếu dành cho chúng. Nếu không có nguồn sữa mẹ thì bạn có thể cung cấp từ nguồn sữa ngoài theo chế độ sau:
- Mèo con dưới 2 tuần tuổi: Bạn nên cho mèo con dùng sữa 3 lần/ngày và lượng sữa là 2-5ml/lần.
- Mèo con dưới 4 tuần tuổi: Cho mèo dùng 4-5 lần mỗi ngày và khoảng 7ml/lần.
- Mèo 2-3 tháng tuổi: Ngoài sữa bạn có thể tập cho chúng các loại thức ăn mềm, tần suất dùng sữa giảm lại (2 lần/ngày).', N'https://youtube.com/embed/456', 5, 2, CAST(N'2025-06-03T19:06:35.040' AS DateTime), CAST(N'2025-06-03T19:06:35.040' AS DateTime), 1)
INSERT [dbo].[course_lessons] ([id], [module_id], [title], [content], [video_url], [duration], [order_index], [created_at], [updated_at], [status]) VALUES (15, 5, N'Sữa Bột Bio Milk For Pet cho mèo sơ sinh', N'Sữa bột Bio Milk For Pet là loại sữa được sử dụng phổ biến cho mèo sơ sinh, mèo dưới 2 tháng tuổi, đây là một loại sữa thay thế của Bio Pharmachemie Việt Nam. Loại sữa này được sản xuất với quy trình khép kín và được nhiều chuyên gia đánh giá cao.

Thành phần của sữa bột Bio Milk For Pet bao gồm các chất dinh dưỡng như Protein, chất béo, chất xơ, canxi, vitamin (A, E, B1, B12,...),..

Với thành phần có các chất dinh dưỡng thiết yếu như vậy, có tác dụng giúp cho các bé có được một hệ tiêu hóa ổn định, bổ sung đầy đủ các chất dinh dưỡng cần thiết.

Hướng dẫn sử dụng:
- Cho mèo con dưới 1 tháng tuổi: Hoàn tan 1 muỗng cafe (5g) sữa với 20ml nước ấm, cho mèo bú ngày 4-5 lần.
- Mèo con từ 1 - 2 tháng tuổi: 1 muỗng cafe (5g) sữa với 15ml nước ấm, bạn có thể đúc hoặc cho mèo tự uống ngày 3-4 lần.

Giá bán: 35.000 đồng/100gr', N'https://youtube.com/embed/456', 5, 1, CAST(N'2025-06-03T19:06:35.040' AS DateTime), CAST(N'2025-06-03T19:06:35.040' AS DateTime), 1)
INSERT [dbo].[course_lessons] ([id], [module_id], [title], [content], [video_url], [duration], [order_index], [created_at], [updated_at], [status]) VALUES (16, 5, N'Sữa bột cho mèo con Petlac', N'Sữa bột cho mèo con Petlac có nguồn gốc đến từ nước Mỹ, thích hợp cho mèo sơ sinh, mèo con. Nó đóng vai trò như một lại sữa mẹ giúp cho mèo con có đầy đủ chất dinh dưỡng cần thiết và dòng sữa được các chuyên gia khuyên dùng cho mèo con khi mèo mẹ mất sữa hoặc mèo con mất mẹ.

Thành phần của sữa bột cho mèo con Petlac cũng đầy đủ các chất dinh dưỡng như bột sữa sấy khô, dầu thực vật, bột kem béo, khoáng chất, vitamin (A, B12, E, D3,...) và một số thành phần dưỡng chất khác.

Sữa bột này có hương vị thơm ngon, mèo con dễ uống, cung cấp các chất dinh dưỡng đầy đủ, đảm bảo cho mèo con mau lớn, phát triển toàn diện.

Hướng dẫn sử dụng:
- Cho mèo sơ sinh: Pha sữa theo tỉ lệ 1 sữa, 2 nước, mỗi ngày cho mèo bú 15ml – 25ml sữa PetLac 5 – 6 lần, cho bú lại sau mỗi 2 – 3 giờ.
- Cho mèo con, lớn hơn 2 tháng: Pha theo tỉ lệ 1 - 4 tùy theo khẩu vị và nhu cầu dinh dưỡng của mèo.

Giá bán: 250.000 đồng/300gr', N'https://youtube.com/embed/456', 7, 2, CAST(N'2025-06-03T19:06:35.040' AS DateTime), CAST(N'2025-06-03T19:06:35.040' AS DateTime), 1)
INSERT [dbo].[course_lessons] ([id], [module_id], [title], [content], [video_url], [duration], [order_index], [created_at], [updated_at], [status]) VALUES (17, 5, N'Sữa Royal Canin Babycat Milk', N'Sữa Royal Canin Babycat Milk là dòng sản phẩm sữa được sử dụng riêng cho mèo con từ 0 đến 2 tháng tuổi với công thức sản xuất mới từ nhà máy sản xuất của nước Pháp xinh đẹp. Hiện nay dòng sản phẩm sữa này đang phổ biến trên thị trường và nhiều khách hàng tin dùng về chất lượng của sữa này.

Thành phần chính của sữa này bao gồm các thành phần: Protein sữa, chất béo sữa, dầu thực vật, dầu cá và khoáng chất. Ngoài ra còn có các chất phụ gia dinh dưỡng như vitamin (A, D3, E1, E2, E4, E5, E6, E8) và chất chống oxy hóa.

Với thành phần đầy đủ các chất dinh dưỡng cho mèo con nhằm giúp cho mèo phát triển cơ thể hài hòa, cân đối và khỏe mạnh, có một hệ tiêu hóa ổn định, giúp cho mèo hấp thụ các chất dinh dưỡng nhanh hơn và trong dầu cá bổ sung DHA giúp cho mèo có một hệ thần kinh phát triển.

Hướng dẫn sử dụng: Pha 10ml bột kèm với 20ml nước ấm

Giá bán: 561.000 đồng/300gr', N'https://youtube.com/embed/456', 8, 3, CAST(N'2025-06-03T19:06:35.040' AS DateTime), CAST(N'2025-06-03T19:06:35.040' AS DateTime), 1)
INSERT [dbo].[course_lessons] ([id], [module_id], [title], [content], [video_url], [duration], [order_index], [created_at], [updated_at], [status]) VALUES (18, 5, N'Sữa bột cho mèo Dr.Kyan Precaten', N'Khi nhắc đến thương hiệu Dr.Kyan Penaten là một thương hiệu nổi tiếng về các sản phẩm của thú cưng và sữa bột cho mèo của thương hiệu này được sản xuất từ công nghệ của Wonder Life Pharma, một trong số những công ty phát triển hàng đầu của Mỹ với công thức riêng biệt.
Thích hợp cho mèo sơ sính đến mèo con 1 - 2  tháng tuổi.

Thành phần của sữa bột cho mèo Dr.Kyan Precaten đầy đủ các chất dinh dưỡng thiết yếu cho mèo như sữa bột nguyên kem, sữa bột gầy, chất xơ, protein, vitamin (C, K1, B6, B1, B2, D3, A, B12, Axit Pantothenic),...

Công dụng của dòng sữa này giúp cho mèo kích thích thèm ăn, xương chắc khỏe, bộ lông mềm mượt hơn, chất xơ tự nhiên giúp hệ tiêu hóa khỏe mạnh.

Hướng dẫn sử dụng:
- Cho mèo dưới 1 tháng tuổi: Pha 3 muỗng sữa bột vào 30ml nước ấm, chia thành 4-6 lần, cho bú hoặc để mèo tự ăn hết trong ngày.
- Cho mèo từ 1 - 2 tháng tuổi: Pha 6 muỗng sữa bột với 60ml nước ấm, chia thành 3-3 lần ăn trong ngày .

Giá bán: 180.000 đồng/400gr', N'https://youtube.com/embed/456', 7, 4, CAST(N'2025-06-03T19:06:35.040' AS DateTime), CAST(N'2025-06-03T19:06:35.040' AS DateTime), 1)
INSERT [dbo].[course_lessons] ([id], [module_id], [title], [content], [video_url], [duration], [order_index], [created_at], [updated_at], [status]) VALUES (19, 5, N'Sữa bột Birthright cho mèo con', N'Đây là sản phẩm sữa bột đến từ nhãn hàng Ralco Nutrition của Mỹ, được xem là một sản phẩm sữa bột thay thế sữa mẹ cho mèo con sơ sính đến 2 tháng tuổi. Dòng sữa này sản xuất bổ sung các chất dinh dưỡng hoàn chỉnh cho mèo con.

Thành phần chính của sữa: Whey sấy khô, sữa tách béo sấy khô, chất béo, dầu dừa, các loại axit amin, vitamin (B12, A, D3, E, K), khoáng chất và các loại tinh dầu tự nhiên với hàm lượng như dòng sữa mẹ.

Birthright có tác dụng bổ sung các chất dinh dưỡng cho mèo con khi mèo con bị bỏ rơi hoắc mất mẹ, mèo mẹ bị mất sữa do đàn con quá đông, hạn chế mèo con bị thấp còi, chậm lớn và biếng ăn.

Hướng dẫn sử dụng:
- Cho mèo con dưới 1 tháng tuổi: hòa 1 muỗng cafe sữa với 20ml nước ấm, cho bú ngày 4-5 lần.
- Cho mèo từ 1-2 tháng tuổi: hòa 1 muỗng cafe (5g) sữa với 15ml nước ấm, cho ăn ngày 3-4 lần.

Giá bán: 35.000 đồng/100gr', N'https://youtube.com/embed/456', 2, 5, CAST(N'2025-06-03T19:06:35.040' AS DateTime), CAST(N'2025-06-03T19:06:35.040' AS DateTime), 1)
INSERT [dbo].[course_lessons] ([id], [module_id], [title], [content], [video_url], [duration], [order_index], [created_at], [updated_at], [status]) VALUES (20, 5, N'Sữa bột CocoKat Milk Replacer', N'Sữa bột CocoKat Milk Replacer khá nổi tiếng và có nguồn gốc từ Thái Lan được sản xuất với 95% là sữa bột nguyên chất nên được nhiều bạn nuôi thú cưng ưa chuộng.

Thành phần chính: 95% sữa bột nguyên chất và 5% chất bổ sung đường huyết có hàm lượng protein đạt trên 20% có trong sữa.

Công dụng chính của dòng sữa này giúp cho mèo cân đối và dễ tiêu hóa, thay thế cho sữa mẹ trong trường hợp sữa mẹ không đủ do đàn con quá đông.


* Hỗ trợ mèo con đi vệ sinh
Bạn cũng nên đặt mèo con vào khay cát vệ sinh để mèo tập cào và lấp chất thải sau khi vệ sinh. Việc này sẽ giúp mèo nhận biết được nơi vệ sinh và những việc cần làm trước và sau đi vệ sinh. Việc này sẽ giúp bạn nhẹ nhàng hơn trong việc vệ sinh của mèo.

* Nên tránh âu yếm vuốt ve khi mèo còn quá nhỏ
Việc âu yếm chúng thường xuyên là điều không nên vì cơ thể chúng còn nhỏ, đề kháng còn yếu nên việc làm này có thể khiến chúng khó thích nghi và chậm phát triển so với bình thường.', N'https://youtube.com/embed/456', 2, 6, CAST(N'2025-06-03T19:06:35.040' AS DateTime), CAST(N'2025-06-03T19:06:35.040' AS DateTime), 1)
INSERT [dbo].[course_lessons] ([id], [module_id], [title], [content], [video_url], [duration], [order_index], [created_at], [updated_at], [status]) VALUES (21, 6, N'Bài 1: Tiêm phòng cho mèo con', N'Tiêm phòng cho mèo con từ nhỏ là cách chúng ta bảo vệ sức khỏe cho mèo con, giúp chúng có hệ miễn dịch tốt nhất.

Trước khi đưa mèo về, bạn hãy kiểm tra kỹ càng tình trạng sức khỏe và tìm hiểu cẩn thận những mũi tiêm mà mèo đã được tiêm như: vacxin phòng bệnh care, parvo, dại…
Nếu mèo con chưa được tiêm phòng, bạn hãy nhanh chóng mang chúng đến những cơ sở thú ý để được bác sĩ thực hiện tiêm phòng.
Những mũi tiêm phòng không chỉ giúp chúng có sức đề kháng tốt mà còn hạn chế tỷ lệ mắc bệnh nguy hiểm cho đàn mèo con sau này.
Bạn không nên thực hiện tiêm phòng cho mèo trong giai đoạn làm quen và tiếp xúc với môi trường mới vì nó sẽ không đem lại hiệu quả cao.', N'https://youtube.com/embed/456', 2, 1, CAST(N'2025-06-03T19:06:35.040' AS DateTime), CAST(N'2025-06-03T19:06:35.040' AS DateTime), 1)
INSERT [dbo].[course_lessons] ([id], [module_id], [title], [content], [video_url], [duration], [order_index], [created_at], [updated_at], [status]) VALUES (22, 6, N'Bài 2: Tẩy giun và diệt bọ chét cho mèo con', N'Tẩy giun cho mèo từ sớm để loại bỏ giun từ mèo mẹ sang mèo con. Mỗi cách tẩy giun phụ thuộc vào độ tuổi sẽ có quy trình cùng sản phẩm hỗ trợ khác nhau.

Vì vậy, hãy đưa ra những lựa chọn đúng đắn để chú mèo được khỏe mạnh.

Ví dụ, phương pháp để diệt bọ chét và sâu là sử dụng sản phẩm như: Stronghold của Anh, Revolution của Mỹ…để thoa lên phần da ở sau gáy, tối đa 2 lần một tháng.', N'https://youtube.com/embed/456', 2, 2, CAST(N'2025-06-03T19:06:35.040' AS DateTime), CAST(N'2025-06-03T19:06:35.040' AS DateTime), 1)
INSERT [dbo].[course_lessons] ([id], [module_id], [title], [content], [video_url], [duration], [order_index], [created_at], [updated_at], [status]) VALUES (23, 6, N'Bài 3: Huấn luyện và các bệnh thường gặp ở mèo con', N'Huấn luyện mèo con đi vệ sinh đúng chỗ:

Bước 1: Cho mèo ngồi vào bên trong, ngửi và kiểm tra khay vệ sinh của mèo.

Bước 2: Ngay sau khi ăn và ngủ dậy, hãy cho mèo vào một trong các nhà vệ sinh. Nếu bạn nhận thấy mèo có dấu hiệu cần rời đi, hoặc nếu bạn đang đánh hơi hoặc ngồi xổm ở một vị trí cụ thể, hãy nhấc nó lên và cho vào bồn cầu.

Bước 3:Thưởng cho mèo nếu bạn nhận thấy mèo đi vệ sinh trong khay.

Bước 4: Nếu mèo gặp khó khăn khi đi vệ sinh, đừng trừng phạt hay la mắng mèo. Làm như vậy sẽ chỉ dẫn đến căng thẳng và lo lắng, điều này sẽ làm trầm trọng thêm vấn đề và khiến việc sử dụng cát để huấn luyện mèo trở nên khó khăn hơn.', N'https://youtube.com/embed/456', 10, 3, CAST(N'2025-06-03T19:06:35.040' AS DateTime), CAST(N'2025-06-03T19:06:35.040' AS DateTime), 1)
INSERT [dbo].[course_lessons] ([id], [module_id], [title], [content], [video_url], [duration], [order_index], [created_at], [updated_at], [status]) VALUES (24, 6, N'Bài 4: Các bệnh thường gặp ở mèo con', N'
- Sán dây: Bác sĩ thú y thường điều trị sán dây ở mèo con bị bọ chét truyền bệnh. Tuy nhiên, bạn có thể được yêu cầu lấy mẫu phân mèo con vì bạn dễ bị nhiễm các loại ký sinh trùng khác như nấm ngoài da.

- Nhiễm trùng đường hô hấp trên: Nhiễm trùng đường hô hấp trên bao gồm vi-rút viêm ống thở ở mèo và vi-rút calicivirus ở mèo. Cả hai loại vi-rút đều có vắc-xin cốt lõi. Vi rút này gây ra hắt hơi, sổ mũi và viêm kết mạc (thường được gọi là đau mắt đỏ).

- Bệnh viêm phúc mạc ở mèo (FIP): Đây là bệnh phổ biến ở những khu vực nhiều mèo, nhưng cũng xảy ra ở mèo con có khuynh hướng di truyền. Tiếp xúc với coronavirus có thể gây ra nhiều loại bệnh, nhưng một số con mèo bị nhiễm thực sự có thể phát triển FIP vì virus cần phải đột biến để gây bệnh. Khuyết điểm là khi đã nhiễm bệnh sẽ chết.

PetTech đã gửi đến bạn thông tin về cách nuôi và chăm sóc mèo con mới đẻ đơn giản nhất. Nếu bạn đang chuẩn bị nuôi một chú mèo thì lượng kiến thức này là vô cùng cần thiết nhé!', N'https://youtube.com/embed/456', 2, 4, CAST(N'2025-06-03T19:06:35.040' AS DateTime), CAST(N'2025-06-03T19:06:35.040' AS DateTime), 1)
INSERT [dbo].[course_lessons] ([id], [module_id], [title], [content], [video_url], [duration], [order_index], [created_at], [updated_at], [status]) VALUES (25, 7, N'Bài 1: Các bước vệ sinh cho chó', N'
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

Nếu cắt quá sâu và đụng phải mạch máu, bạn có thể dùng bột cầm máu, bột bắp, hoặc bột mì dặm lên vết thương để ngăn máu không tiếp tục chảy.', N'https://youtube.com/embed/456', 45, 1, CAST(N'2025-06-03T19:06:35.040' AS DateTime), CAST(N'2025-06-03T19:06:35.040' AS DateTime), 1)
INSERT [dbo].[course_lessons] ([id], [module_id], [title], [content], [video_url], [duration], [order_index], [created_at], [updated_at], [status]) VALUES (26, 7, N'Bài 2: Tắm cho chó', N'
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
	
	*Nếu chú cún sợ âm thanh hoặc cảm giác khi tiếp xúc với máy sấy, bạn không nên ép buộc chúng. Thay vào đó, hãy dùng khăn lau và dắt chó vào nơi phù hợp để lông chó khô tự nhiên, chẳng hạn như trong phòng giặt.', N'https://youtube.com/embed/456', 25, 2, CAST(N'2025-06-03T19:06:35.040' AS DateTime), CAST(N'2025-06-03T19:06:35.040' AS DateTime), 1)
INSERT [dbo].[course_lessons] ([id], [module_id], [title], [content], [video_url], [duration], [order_index], [created_at], [updated_at], [status]) VALUES (27, 7, N'Bài 3: Tỉa lông chó', N'
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

Kiên nhẫn. Bạn cần phải rà nhiều đường trên lông chó mới có được đường cắt mềm mịn và thẳng tắp. Không nên vội vàng! Cho phép thú cưng nghỉ ngơi càng nhiều càng tốt, và phải di chuyển tông đơ nhẹ nhàng.', N'https://youtube.com/embed/456', 20, 3, CAST(N'2025-06-03T19:06:35.040' AS DateTime), CAST(N'2025-06-03T19:06:35.040' AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[course_lessons] OFF
GO
SET IDENTITY_INSERT [dbo].[course_modules] ON 

INSERT [dbo].[course_modules] ([id], [course_id], [title], [description], [order_index], [created_at], [updated_at], [status]) VALUES (1, 1, N'Module 1: Những cách chăm sóc chó con mới đẻ cần ghi nhớ', N'Như các bạn đã biết, chó con mới đẻ thường có sức khỏe khá yếu...', 1, CAST(N'2025-06-03T19:06:35.027' AS DateTime), CAST(N'2025-06-03T19:06:35.027' AS DateTime), 1)
INSERT [dbo].[course_modules] ([id], [course_id], [title], [description], [order_index], [created_at], [updated_at], [status]) VALUES (2, 1, N'Module 2: Một số lưu ý về chế độ dinh dưỡng cho chó con mới đẻ', N'Hướng dẫn lựa chọn chế độ ăn phù hợp theo độ tuổi', 2, CAST(N'2025-06-03T19:06:35.027' AS DateTime), CAST(N'2025-06-03T19:06:35.027' AS DateTime), 1)
INSERT [dbo].[course_modules] ([id], [course_id], [title], [description], [order_index], [created_at], [updated_at], [status]) VALUES (3, 2, N'Module 1: Cách chăm sóc mèo con mới đẻ vẫn còn mẹ', N'Hiểu về cách chăm sóc cho mèo con mới đẻ', 1, CAST(N'2025-06-03T19:06:35.027' AS DateTime), CAST(N'2025-06-03T19:06:35.027' AS DateTime), 1)
INSERT [dbo].[course_modules] ([id], [course_id], [title], [description], [order_index], [created_at], [updated_at], [status]) VALUES (4, 2, N'Module 2: Cách chăm sóc mèo con mới đẻ mất mẹ', N'Để chăm sóc mèo con mới đẻ mất mẹ...', 2, CAST(N'2025-06-03T19:06:35.027' AS DateTime), CAST(N'2025-06-03T19:06:35.027' AS DateTime), 1)
INSERT [dbo].[course_modules] ([id], [course_id], [title], [description], [order_index], [created_at], [updated_at], [status]) VALUES (5, 2, N'Module 3: Các loại sữa bột tốt cho mèo con', N'Các loại sữa công thức phù hợp cho mèo con...', 3, CAST(N'2025-06-03T19:06:35.027' AS DateTime), CAST(N'2025-06-03T19:06:35.027' AS DateTime), 1)
INSERT [dbo].[course_modules] ([id], [course_id], [title], [description], [order_index], [created_at], [updated_at], [status]) VALUES (6, 2, N'Module 4: Lưu ý khi chăm sóc mèo con mới đẻ', N'- Không nên để mèo nằm khi ăn...', 4, CAST(N'2025-06-03T19:06:35.027' AS DateTime), CAST(N'2025-06-03T19:06:35.027' AS DateTime), 1)
INSERT [dbo].[course_modules] ([id], [course_id], [title], [description], [order_index], [created_at], [updated_at], [status]) VALUES (7, 3, N'Module 1: Vệ sinh cho chó trước khi tắm', N'Xem bài học bên dưới...', 1, CAST(N'2025-06-03T19:06:35.027' AS DateTime), CAST(N'2025-06-03T19:06:35.027' AS DateTime), 1)
INSERT [dbo].[course_modules] ([id], [course_id], [title], [description], [order_index], [created_at], [updated_at], [status]) VALUES (8, 4, N'Module 1: Lưu ý khi chăm sóc mèo con mới đẻ', N'- Không nên để mèo nằm khi ăn...', 1, CAST(N'2025-06-03T19:06:35.027' AS DateTime), CAST(N'2025-06-03T19:06:35.027' AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[course_modules] OFF
GO
SET IDENTITY_INSERT [dbo].[course_reviews] ON 

INSERT [dbo].[course_reviews] ([id], [course_id], [user_id], [rating], [comment], [created_at], [status]) VALUES (1, 1, 1, 5, N'Khóa học rất hữu ích cho người mới nuôi chó', CAST(N'2025-06-03T19:06:35.050' AS DateTime), 1)
INSERT [dbo].[course_reviews] ([id], [course_id], [user_id], [rating], [comment], [created_at], [status]) VALUES (2, 1, 2, 4, N'Nội dung chi tiết, dễ hiểu', CAST(N'2025-06-03T19:06:35.050' AS DateTime), 1)
INSERT [dbo].[course_reviews] ([id], [course_id], [user_id], [rating], [comment], [created_at], [status]) VALUES (3, 2, 3, 5, N'Giúp tôi chăm sóc mèo tốt hơn', CAST(N'2025-06-03T19:06:35.050' AS DateTime), 1)
INSERT [dbo].[course_reviews] ([id], [course_id], [user_id], [rating], [comment], [created_at], [status]) VALUES (4, 3, 4, 4, N'Kiến thức thực tế, áp dụng được ngay', CAST(N'2025-06-03T19:06:35.050' AS DateTime), 1)
INSERT [dbo].[course_reviews] ([id], [course_id], [user_id], [rating], [comment], [created_at], [status]) VALUES (5, 5, 5, 5, N'Rất đáng đồng tiền', CAST(N'2025-06-03T19:06:35.050' AS DateTime), 1)
INSERT [dbo].[course_reviews] ([id], [course_id], [user_id], [rating], [comment], [created_at], [status]) VALUES (6, 4, 2, 4, N'Khóa học huấn luyện rất bài bản', CAST(N'2025-06-01T03:40:04.133' AS DateTime), 1)
INSERT [dbo].[course_reviews] ([id], [course_id], [user_id], [rating], [comment], [created_at], [status]) VALUES (7, 5, 3, 5, N'Nội dung chi tiết, dễ hiểu', CAST(N'2025-06-02T03:40:04.133' AS DateTime), 1)
INSERT [dbo].[course_reviews] ([id], [course_id], [user_id], [rating], [comment], [created_at], [status]) VALUES (8, 3, 4, 4, N'Kiến thức thực tế, áp dụng được ngay', CAST(N'2025-06-03T03:40:04.133' AS DateTime), 1)
INSERT [dbo].[course_reviews] ([id], [course_id], [user_id], [rating], [comment], [created_at], [status]) VALUES (9, 2, 5, 5, N'Rất hữu ích cho người nuôi mèo', CAST(N'2025-06-04T03:40:04.133' AS DateTime), 1)
INSERT [dbo].[course_reviews] ([id], [course_id], [user_id], [rating], [comment], [created_at], [status]) VALUES (10, 1, 3, 4, N'Giúp tôi chăm sóc chó tốt hơn', CAST(N'2025-06-05T03:40:04.133' AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[course_reviews] OFF
GO
SET IDENTITY_INSERT [dbo].[course_statistics] ON 

INSERT [dbo].[course_statistics] ([id], [course_id], [date], [views], [enrollments], [avg_view_duration], [completion_rate]) VALUES (1, 1, CAST(N'2025-05-30' AS Date), 150, 50, 1800, CAST(65.50 AS Decimal(5, 2)))
INSERT [dbo].[course_statistics] ([id], [course_id], [date], [views], [enrollments], [avg_view_duration], [completion_rate]) VALUES (2, 1, CAST(N'2025-05-31' AS Date), 120, 45, 1750, CAST(68.20 AS Decimal(5, 2)))
INSERT [dbo].[course_statistics] ([id], [course_id], [date], [views], [enrollments], [avg_view_duration], [completion_rate]) VALUES (3, 1, CAST(N'2025-06-01' AS Date), 180, 60, 1900, CAST(70.10 AS Decimal(5, 2)))
INSERT [dbo].[course_statistics] ([id], [course_id], [date], [views], [enrollments], [avg_view_duration], [completion_rate]) VALUES (4, 2, CAST(N'2025-05-30' AS Date), 200, 70, 2100, CAST(72.30 AS Decimal(5, 2)))
INSERT [dbo].[course_statistics] ([id], [course_id], [date], [views], [enrollments], [avg_view_duration], [completion_rate]) VALUES (5, 2, CAST(N'2025-05-31' AS Date), 170, 65, 2050, CAST(71.50 AS Decimal(5, 2)))
INSERT [dbo].[course_statistics] ([id], [course_id], [date], [views], [enrollments], [avg_view_duration], [completion_rate]) VALUES (6, 3, CAST(N'2025-06-01' AS Date), 90, 30, 1600, CAST(60.80 AS Decimal(5, 2)))
INSERT [dbo].[course_statistics] ([id], [course_id], [date], [views], [enrollments], [avg_view_duration], [completion_rate]) VALUES (7, 4, CAST(N'2025-06-02' AS Date), 130, 40, 1850, CAST(67.50 AS Decimal(5, 2)))
INSERT [dbo].[course_statistics] ([id], [course_id], [date], [views], [enrollments], [avg_view_duration], [completion_rate]) VALUES (8, 5, CAST(N'2025-06-03' AS Date), 160, 55, 1950, CAST(69.80 AS Decimal(5, 2)))
SET IDENTITY_INSERT [dbo].[course_statistics] OFF
GO
SET IDENTITY_INSERT [dbo].[courses] ON 

INSERT [dbo].[courses] ([id], [title], [content], [post_date], [researcher], [video_url], [status], [duration], [thumbnail_url], [created_at], [updated_at], [is_paid]) VALUES (1, N'Cách chăm sóc chó con 3 tháng tuổi đầu tiên', N'Sau khi sinh, chó con cũng cần được chăm sóc đặc biệt', CAST(N'2025-06-03' AS Date), N'Dr. Nam Nguyễn', NULL, 1, N'4 tuần', N'/images/course/course1.jpg', CAST(N'2025-06-03T19:06:35.023' AS DateTime), CAST(N'2025-06-10T10:51:03.297' AS DateTime), 0)
INSERT [dbo].[courses] ([id], [title], [content], [post_date], [researcher], [video_url], [status], [duration], [thumbnail_url], [created_at], [updated_at], [is_paid]) VALUES (2, N'Cách chăm sóc mèo con', N'Để có được một chú mèo khỏe mạnh và đáng yêu...', CAST(N'2025-06-03' AS Date), N'Dr. Hiền Nguyễn', NULL, 1, N'6 tuần', N'/images/course/course2.jpg', CAST(N'2025-06-03T19:06:35.023' AS DateTime), CAST(N'2025-06-03T19:06:35.023' AS DateTime), 0)
INSERT [dbo].[courses] ([id], [title], [content], [post_date], [researcher], [video_url], [status], [duration], [thumbnail_url], [created_at], [updated_at], [is_paid]) VALUES (3, N'Cách vệ sinh cho chó', N'Thú cưng được chăm sóc thường xuyên sẽ luôn sạch sẽ...', CAST(N'2025-06-03' AS Date), N'Dr. Chi Nguyễn', NULL, 1, N'3 tháng', N'/images/course/course3.jpg', CAST(N'2025-06-03T19:06:35.023' AS DateTime), CAST(N'2025-06-03T19:06:35.023' AS DateTime), 0)
INSERT [dbo].[courses] ([id], [title], [content], [post_date], [researcher], [video_url], [status], [duration], [thumbnail_url], [created_at], [updated_at], [is_paid]) VALUES (4, N'Huấn luyện chó căn bản', N'Hướng dẫn chi tiết các kỹ thuật huấn luyện chó cơ bản', CAST(N'2025-06-03' AS Date), N'Dr. Thanh Phạm', NULL, 1, N'5 tuần', N'/images/course/course4.jpg', CAST(N'2025-06-03T19:06:35.023' AS DateTime), CAST(N'2025-06-03T19:06:35.023' AS DateTime), 1)
INSERT [dbo].[courses] ([id], [title], [content], [post_date], [researcher], [video_url], [status], [duration], [thumbnail_url], [created_at], [updated_at], [is_paid]) VALUES (5, N'Chăm sóc mèo cơ bản', N'Hướng dẫn chi tiết chăm sóc mèo từ thức ăn, vệ sinh, đến sức khỏe.', CAST(N'2025-06-03' AS Date), N'Dr. Mai Phương', NULL, 1, N'4 tuần', N'/images/course/course5.jpg', CAST(N'2025-06-03T19:06:35.023' AS DateTime), CAST(N'2025-06-03T19:06:35.023' AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[courses] OFF
GO
SET IDENTITY_INSERT [dbo].[daily_statistics] ON 

INSERT [dbo].[daily_statistics] ([id], [date], [total_visits], [unique_visitors], [new_users], [avg_session_duration], [page_views], [total_users], [active_users], [new_registrations], [premium_users], [created_at], [updated_at]) VALUES (1, CAST(N'2025-05-30' AS Date), 450, 320, 15, 420, 1200, 500, 280, 5, 120, CAST(N'2025-06-06T03:40:04.130' AS DateTime), CAST(N'2025-06-06T03:40:04.130' AS DateTime))
INSERT [dbo].[daily_statistics] ([id], [date], [total_visits], [unique_visitors], [new_users], [avg_session_duration], [page_views], [total_users], [active_users], [new_registrations], [premium_users], [created_at], [updated_at]) VALUES (2, CAST(N'2025-05-31' AS Date), 480, 340, 18, 430, 1250, 510, 290, 6, 125, CAST(N'2025-06-06T03:40:04.130' AS DateTime), CAST(N'2025-06-06T03:40:04.130' AS DateTime))
INSERT [dbo].[daily_statistics] ([id], [date], [total_visits], [unique_visitors], [new_users], [avg_session_duration], [page_views], [total_users], [active_users], [new_registrations], [premium_users], [created_at], [updated_at]) VALUES (3, CAST(N'2025-06-01' AS Date), 520, 380, 20, 450, 1350, 520, 310, 7, 130, CAST(N'2025-06-06T03:40:04.130' AS DateTime), CAST(N'2025-06-06T03:40:04.130' AS DateTime))
INSERT [dbo].[daily_statistics] ([id], [date], [total_visits], [unique_visitors], [new_users], [avg_session_duration], [page_views], [total_users], [active_users], [new_registrations], [premium_users], [created_at], [updated_at]) VALUES (4, CAST(N'2025-06-02' AS Date), 500, 360, 17, 440, 1300, 530, 300, 6, 132, CAST(N'2025-06-06T03:40:04.130' AS DateTime), CAST(N'2025-06-06T03:40:04.130' AS DateTime))
INSERT [dbo].[daily_statistics] ([id], [date], [total_visits], [unique_visitors], [new_users], [avg_session_duration], [page_views], [total_users], [active_users], [new_registrations], [premium_users], [created_at], [updated_at]) VALUES (5, CAST(N'2025-06-03' AS Date), 550, 400, 22, 460, 1400, 540, 330, 8, 135, CAST(N'2025-06-06T03:40:04.130' AS DateTime), CAST(N'2025-06-06T03:40:04.130' AS DateTime))
INSERT [dbo].[daily_statistics] ([id], [date], [total_visits], [unique_visitors], [new_users], [avg_session_duration], [page_views], [total_users], [active_users], [new_registrations], [premium_users], [created_at], [updated_at]) VALUES (6, CAST(N'2025-06-04' AS Date), 580, 420, 25, 470, 1450, 550, 350, 9, 140, CAST(N'2025-06-06T03:40:04.130' AS DateTime), CAST(N'2025-06-06T03:40:04.130' AS DateTime))
INSERT [dbo].[daily_statistics] ([id], [date], [total_visits], [unique_visitors], [new_users], [avg_session_duration], [page_views], [total_users], [active_users], [new_registrations], [premium_users], [created_at], [updated_at]) VALUES (7, CAST(N'2025-06-05' AS Date), 600, 450, 28, 480, 1500, 560, 370, 10, 145, CAST(N'2025-06-06T03:40:04.130' AS DateTime), CAST(N'2025-06-06T03:40:04.130' AS DateTime))
INSERT [dbo].[daily_statistics] ([id], [date], [total_visits], [unique_visitors], [new_users], [avg_session_duration], [page_views], [total_users], [active_users], [new_registrations], [premium_users], [created_at], [updated_at]) VALUES (8, CAST(N'2025-06-06' AS Date), 620, 470, 30, 490, 1550, 570, 390, 12, 150, CAST(N'2025-06-06T03:40:04.130' AS DateTime), CAST(N'2025-06-06T03:40:04.130' AS DateTime))
SET IDENTITY_INSERT [dbo].[daily_statistics] OFF
GO
SET IDENTITY_INSERT [dbo].[lesson_attachments] ON 

INSERT [dbo].[lesson_attachments] ([id], [lesson_id], [file_name], [file_url], [file_size], [status]) VALUES (1, 3, N'Hướng dẫn dinh dưỡng.pdf', N'/uploads/guides/nutrition.pdf', 1024, 1)
INSERT [dbo].[lesson_attachments] ([id], [lesson_id], [file_name], [file_url], [file_size], [status]) VALUES (2, 5, N'Cẩm nang sơ cứu.pdf', N'/uploads/guides/first_aid.pdf', 2048, 1)
SET IDENTITY_INSERT [dbo].[lesson_attachments] OFF
GO
SET IDENTITY_INSERT [dbo].[order_items] ON 

INSERT [dbo].[order_items] ([id], [order_id], [product_id], [quantity], [price], [status]) VALUES (1, 1, 1, 1, CAST(350000 AS Decimal(12, 0)), 1)
INSERT [dbo].[order_items] ([id], [order_id], [product_id], [quantity], [price], [status]) VALUES (2, 2, 2, 1, CAST(120000 AS Decimal(12, 0)), 1)
INSERT [dbo].[order_items] ([id], [order_id], [product_id], [quantity], [price], [status]) VALUES (3, 3, 1, 1, CAST(350000 AS Decimal(12, 0)), 1)
INSERT [dbo].[order_items] ([id], [order_id], [product_id], [quantity], [price], [status]) VALUES (4, 3, 3, 2, CAST(89000 AS Decimal(12, 0)), 1)
SET IDENTITY_INSERT [dbo].[order_items] OFF
GO
SET IDENTITY_INSERT [dbo].[orders] ON 

INSERT [dbo].[orders] ([id], [user_id], [order_date], [total_amount], [commission], [status]) VALUES (1, 1, CAST(N'2025-06-03T19:06:35.047' AS DateTime), CAST(350000 AS Decimal(12, 0)), CAST(10500 AS Decimal(12, 0)), N'completed')
INSERT [dbo].[orders] ([id], [user_id], [order_date], [total_amount], [commission], [status]) VALUES (2, 2, CAST(N'2025-06-03T19:06:35.047' AS DateTime), CAST(120000 AS Decimal(12, 0)), CAST(3600 AS Decimal(12, 0)), N'completed')
INSERT [dbo].[orders] ([id], [user_id], [order_date], [total_amount], [commission], [status]) VALUES (3, 3, CAST(N'2025-06-03T19:06:35.047' AS DateTime), CAST(500000 AS Decimal(12, 0)), CAST(15000 AS Decimal(12, 0)), N'processing')
SET IDENTITY_INSERT [dbo].[orders] OFF
GO
SET IDENTITY_INSERT [dbo].[partners] ON 

INSERT [dbo].[partners] ([id], [name], [email], [phone], [address], [description], [status], [created_at]) VALUES (1, N'PetFood Việt Nam', N'petfood@example.com', N'0987123456', N'123 Đường Lê Lợi, Hà Nội', N'Nhà cung cấp thức ăn thú cưng hàng đầu', 1, CAST(N'2025-06-03T19:06:35.020' AS DateTime))
INSERT [dbo].[partners] ([id], [name], [email], [phone], [address], [description], [status], [created_at]) VALUES (2, N'PetCare Solutions', N'petcare@example.com', N'0987765432', N'456 Đường Nguyễn Huệ, TP.HCM', N'Chuyên cung cấp dịch vụ chăm sóc thú cưng', 1, CAST(N'2025-06-03T19:06:35.020' AS DateTime))
SET IDENTITY_INSERT [dbo].[partners] OFF
GO
SET IDENTITY_INSERT [dbo].[payments] ON 

INSERT [dbo].[payments] ([id], [user_id], [service_package_id], [order_id], [payment_method], [amount], [payment_date], [status], [transaction_id], [qr_code_url], [bank_account_number], [bank_name], [notes], [is_confirmed], [confirmation_code], [confirmation_expiry]) VALUES (1, 1, NULL, 1, N'VNPAY', CAST(350000.00 AS Decimal(10, 2)), CAST(N'2025-06-03T19:06:35.047' AS DateTime), N'completed', N'VNPAY123456', NULL, NULL, NULL, NULL, 0, NULL, NULL)
INSERT [dbo].[payments] ([id], [user_id], [service_package_id], [order_id], [payment_method], [amount], [payment_date], [status], [transaction_id], [qr_code_url], [bank_account_number], [bank_name], [notes], [is_confirmed], [confirmation_code], [confirmation_expiry]) VALUES (2, 2, NULL, 2, N'MOMO_QR', CAST(120000.00 AS Decimal(10, 2)), CAST(N'2025-06-03T19:06:35.047' AS DateTime), N'completed', N'MOMO654321', NULL, NULL, NULL, NULL, 0, NULL, NULL)
INSERT [dbo].[payments] ([id], [user_id], [service_package_id], [order_id], [payment_method], [amount], [payment_date], [status], [transaction_id], [qr_code_url], [bank_account_number], [bank_name], [notes], [is_confirmed], [confirmation_code], [confirmation_expiry]) VALUES (3, 3, 3, NULL, N'BANK_QR', CAST(199000.00 AS Decimal(10, 2)), CAST(N'2025-05-27T03:40:04.133' AS DateTime), N'completed', N'BANK123456', N'/qr_codes/bank123.png', N'123456789', N'Vietcombank', NULL, 1, NULL, NULL)
INSERT [dbo].[payments] ([id], [user_id], [service_package_id], [order_id], [payment_method], [amount], [payment_date], [status], [transaction_id], [qr_code_url], [bank_account_number], [bank_name], [notes], [is_confirmed], [confirmation_code], [confirmation_expiry]) VALUES (4, 4, 2, NULL, N'VNPAY', CAST(99000.00 AS Decimal(10, 2)), CAST(N'2025-06-01T03:40:04.133' AS DateTime), N'completed', N'VNPAY654321', N'/qr_codes/vnpay654.png', NULL, NULL, NULL, 1, NULL, NULL)
INSERT [dbo].[payments] ([id], [user_id], [service_package_id], [order_id], [payment_method], [amount], [payment_date], [status], [transaction_id], [qr_code_url], [bank_account_number], [bank_name], [notes], [is_confirmed], [confirmation_code], [confirmation_expiry]) VALUES (5, 5, 3, NULL, N'MOMO_QR', CAST(199000.00 AS Decimal(10, 2)), CAST(N'2025-06-03T03:40:04.133' AS DateTime), N'completed', N'MOMO987654', N'/qr_codes/momo987.png', NULL, NULL, NULL, 1, NULL, NULL)
SET IDENTITY_INSERT [dbo].[payments] OFF
GO
SET IDENTITY_INSERT [dbo].[product_categories] ON 

INSERT [dbo].[product_categories] ([id], [name], [status]) VALUES (1, N'Thức ăn', 1)
INSERT [dbo].[product_categories] ([id], [name], [status]) VALUES (2, N'Vệ sinh', 1)
INSERT [dbo].[product_categories] ([id], [name], [status]) VALUES (3, N'Phụ kiện', 1)
SET IDENTITY_INSERT [dbo].[product_categories] OFF
GO
INSERT [dbo].[product_category_mapping] ([product_id], [category_id], [status]) VALUES (1, 1, 1)
INSERT [dbo].[product_category_mapping] ([product_id], [category_id], [status]) VALUES (2, 2, 1)
INSERT [dbo].[product_category_mapping] ([product_id], [category_id], [status]) VALUES (3, 2, 1)
INSERT [dbo].[product_category_mapping] ([product_id], [category_id], [status]) VALUES (3, 3, 1)
GO
SET IDENTITY_INSERT [dbo].[products] ON 

INSERT [dbo].[products] ([id], [name], [description], [price], [stock], [partner_id], [image_url], [status]) VALUES (1, N'Thức ăn cho chó vị gà 5kg', N'Dành cho chó từ 2 tháng tuổi trở lên', CAST(350000 AS Decimal(12, 0)), 100, 1, N'/img/products/dog_food.jpg', 1)
INSERT [dbo].[products] ([id], [name], [description], [price], [stock], [partner_id], [image_url], [status]) VALUES (2, N'Cát vệ sinh hữu cơ cho mèo', N'Hấp thụ nhanh và khử mùi tốt', CAST(120000 AS Decimal(12, 0)), 150, 1, N'/img/products/cat_litter.jpg', 1)
INSERT [dbo].[products] ([id], [name], [description], [price], [stock], [partner_id], [image_url], [status]) VALUES (3, N'Sữa tắm thảo dược thú cưng', N'Làm sạch và chống rụng lông', CAST(89000 AS Decimal(12, 0)), 200, 2, N'/img/products/pet_shampoo.jpg', 1)
SET IDENTITY_INSERT [dbo].[products] OFF
GO
SET IDENTITY_INSERT [dbo].[service_packages] ON 

INSERT [dbo].[service_packages] ([id], [name], [description], [price], [type], [status]) VALUES (1, N'GÓI MIỄN PHÍ', N'Phù hợp với người mới bắt đầu nuôi thú cưng hoặc đang tìm hiểu.', CAST(0 AS Decimal(10, 0)), N'free', 1)
INSERT [dbo].[service_packages] ([id], [name], [description], [price], [type], [status]) VALUES (2, N'GÓI TIÊU CHUẨN', N'Dành cho người nuôi thú cưng có nhu cầu chăm sóc tốt hơn và học hỏi thêm.', CAST(99000 AS Decimal(10, 0)), N'standard', 0)
INSERT [dbo].[service_packages] ([id], [name], [description], [price], [type], [status]) VALUES (3, N'GÓI CHUYÊN NGHIỆP', N'Phù hợp với người yêu thú cưng nghiêm túc hoặc kinh doanh nhỏ (pet shop, grooming).', CAST(199000 AS Decimal(10, 0)), N'pro', 0)
SET IDENTITY_INSERT [dbo].[service_packages] OFF
GO
SET IDENTITY_INSERT [dbo].[user_packages] ON 

INSERT [dbo].[user_packages] ([id], [user_id], [service_package_id], [start_date], [end_date], [status]) VALUES (1, 1, 1, CAST(N'2023-01-01' AS Date), CAST(N'2023-12-31' AS Date), 1)
INSERT [dbo].[user_packages] ([id], [user_id], [service_package_id], [start_date], [end_date], [status]) VALUES (2, 2, 2, CAST(N'2023-02-01' AS Date), CAST(N'2023-08-01' AS Date), 1)
INSERT [dbo].[user_packages] ([id], [user_id], [service_package_id], [start_date], [end_date], [status]) VALUES (3, 3, 3, CAST(N'2023-03-01' AS Date), CAST(N'2023-09-01' AS Date), 1)
INSERT [dbo].[user_packages] ([id], [user_id], [service_package_id], [start_date], [end_date], [status]) VALUES (4, 4, 2, CAST(N'2023-04-01' AS Date), CAST(N'2023-10-01' AS Date), 1)
INSERT [dbo].[user_packages] ([id], [user_id], [service_package_id], [start_date], [end_date], [status]) VALUES (5, 5, 3, CAST(N'2023-05-01' AS Date), CAST(N'2023-11-01' AS Date), 1)
SET IDENTITY_INSERT [dbo].[user_packages] OFF
GO
SET IDENTITY_INSERT [dbo].[user_progress] ON 

INSERT [dbo].[user_progress] ([id], [user_id], [lesson_id], [completed], [completed_at], [status]) VALUES (1, 1, 1, 1, CAST(N'2025-06-03T19:06:35.047' AS DateTime), 1)
INSERT [dbo].[user_progress] ([id], [user_id], [lesson_id], [completed], [completed_at], [status]) VALUES (2, 1, 2, 1, CAST(N'2025-06-03T19:06:35.047' AS DateTime), 1)
INSERT [dbo].[user_progress] ([id], [user_id], [lesson_id], [completed], [completed_at], [status]) VALUES (3, 1, 3, 0, NULL, 1)
INSERT [dbo].[user_progress] ([id], [user_id], [lesson_id], [completed], [completed_at], [status]) VALUES (4, 2, 1, 1, CAST(N'2025-06-03T19:06:35.047' AS DateTime), 1)
INSERT [dbo].[user_progress] ([id], [user_id], [lesson_id], [completed], [completed_at], [status]) VALUES (5, 2, 2, 0, NULL, 1)
INSERT [dbo].[user_progress] ([id], [user_id], [lesson_id], [completed], [completed_at], [status]) VALUES (6, 3, 5, 1, CAST(N'2025-06-03T19:06:35.047' AS DateTime), 1)
INSERT [dbo].[user_progress] ([id], [user_id], [lesson_id], [completed], [completed_at], [status]) VALUES (7, 3, 6, 1, CAST(N'2025-06-03T19:06:35.047' AS DateTime), 1)
INSERT [dbo].[user_progress] ([id], [user_id], [lesson_id], [completed], [completed_at], [status]) VALUES (8, 4, 7, 1, CAST(N'2025-06-03T19:06:35.047' AS DateTime), 1)
INSERT [dbo].[user_progress] ([id], [user_id], [lesson_id], [completed], [completed_at], [status]) VALUES (9, 5, 8, 1, CAST(N'2025-06-03T19:06:35.047' AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[user_progress] OFF
GO
SET IDENTITY_INSERT [dbo].[user_reset_tokens] ON 

INSERT [dbo].[user_reset_tokens] ([id], [user_id], [reset_token], [expiry], [status], [created_at]) VALUES (1, 9, N'961ac3d2-83e6-4ec6-91e4-e64a8b9868e3', CAST(N'2025-06-07T00:30:08.567' AS DateTime), 1, CAST(N'2025-06-06T00:30:08.567' AS DateTime))
INSERT [dbo].[user_reset_tokens] ([id], [user_id], [reset_token], [expiry], [status], [created_at]) VALUES (2, 9, N'80081fd4-06a2-407e-93e6-ec6d2536c931', CAST(N'2025-06-07T00:31:51.333' AS DateTime), 1, CAST(N'2025-06-06T00:31:51.333' AS DateTime))
INSERT [dbo].[user_reset_tokens] ([id], [user_id], [reset_token], [expiry], [status], [created_at]) VALUES (3, 9, N'2e445dd4-e37c-42f0-9819-835abbef15f0', CAST(N'2025-06-07T00:32:23.040' AS DateTime), 1, CAST(N'2025-06-06T00:32:23.040' AS DateTime))
INSERT [dbo].[user_reset_tokens] ([id], [user_id], [reset_token], [expiry], [status], [created_at]) VALUES (4, 9, N'8e316ecc-e51d-4716-b4c3-5370159d9989', CAST(N'2025-06-07T00:33:14.900' AS DateTime), 1, CAST(N'2025-06-06T00:33:14.900' AS DateTime))
INSERT [dbo].[user_reset_tokens] ([id], [user_id], [reset_token], [expiry], [status], [created_at]) VALUES (5, 9, N'36a66f59-26e1-46cb-80ff-4e5679b1a2fa', CAST(N'2025-06-07T00:34:15.280' AS DateTime), 1, CAST(N'2025-06-06T00:34:15.280' AS DateTime))
INSERT [dbo].[user_reset_tokens] ([id], [user_id], [reset_token], [expiry], [status], [created_at]) VALUES (6, 9, N'd3e9535d-9b43-41c8-993b-277dd226a8e9', CAST(N'2025-06-07T00:36:10.210' AS DateTime), 1, CAST(N'2025-06-06T00:36:10.210' AS DateTime))
INSERT [dbo].[user_reset_tokens] ([id], [user_id], [reset_token], [expiry], [status], [created_at]) VALUES (7, 1, N'token123456789', CAST(N'2025-06-06T04:40:04.130' AS DateTime), 1, CAST(N'2025-06-06T03:40:04.130' AS DateTime))
INSERT [dbo].[user_reset_tokens] ([id], [user_id], [reset_token], [expiry], [status], [created_at]) VALUES (8, 2, N'token987654321', CAST(N'2025-06-06T04:40:04.130' AS DateTime), 1, CAST(N'2025-06-06T03:40:04.130' AS DateTime))
INSERT [dbo].[user_reset_tokens] ([id], [user_id], [reset_token], [expiry], [status], [created_at]) VALUES (9, 3, N'token456789123', CAST(N'2025-06-06T04:40:04.130' AS DateTime), 1, CAST(N'2025-06-06T03:40:04.130' AS DateTime))
SET IDENTITY_INSERT [dbo].[user_reset_tokens] OFF
GO
SET IDENTITY_INSERT [dbo].[User_Service] ON 

INSERT [dbo].[User_Service] ([id], [user_id], [package_id], [start_date], [end_date], [status]) VALUES (1, 1, 1, CAST(N'2023-01-01' AS Date), CAST(N'2023-12-31' AS Date), N'active')
INSERT [dbo].[User_Service] ([id], [user_id], [package_id], [start_date], [end_date], [status]) VALUES (2, 2, 2, CAST(N'2023-02-01' AS Date), CAST(N'2023-08-01' AS Date), N'active')
INSERT [dbo].[User_Service] ([id], [user_id], [package_id], [start_date], [end_date], [status]) VALUES (3, 3, 3, CAST(N'2023-03-01' AS Date), CAST(N'2023-09-01' AS Date), N'active')
INSERT [dbo].[User_Service] ([id], [user_id], [package_id], [start_date], [end_date], [status]) VALUES (4, 4, 2, CAST(N'2023-04-01' AS Date), CAST(N'2023-10-01' AS Date), N'active')
INSERT [dbo].[User_Service] ([id], [user_id], [package_id], [start_date], [end_date], [status]) VALUES (5, 5, 3, CAST(N'2023-05-01' AS Date), CAST(N'2023-11-01' AS Date), N'active')
INSERT [dbo].[User_Service] ([id], [user_id], [package_id], [start_date], [end_date], [status]) VALUES (7, 9, 1, CAST(N'2025-06-05' AS Date), CAST(N'2025-06-12' AS Date), N'Đang sử dụng')
SET IDENTITY_INSERT [dbo].[User_Service] OFF
GO
SET IDENTITY_INSERT [dbo].[user_sessions] ON 

INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (1, 1, N'session123456789', N'192.168.1.100', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', CAST(N'2025-06-06T01:40:04.130' AS DateTime), CAST(N'2025-06-06T02:40:04.130' AS DateTime), 3600, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (2, 2, N'session987654321', N'192.168.1.101', N'Mozilla/5.0 (Macintosh; Intel Mac OS X)', CAST(N'2025-06-06T00:40:04.130' AS DateTime), CAST(N'2025-06-06T02:40:04.130' AS DateTime), 7200, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (3, 3, N'session456789123', N'192.168.1.102', N'Mozilla/5.0 (iPhone; CPU iPhone OS)', CAST(N'2025-06-06T02:40:04.130' AS DateTime), CAST(N'2025-06-06T03:40:04.130' AS DateTime), 3600, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (4, 4, N'session789123456', N'192.168.1.103', N'Mozilla/5.0 (Android 10; Mobile)', CAST(N'2025-06-05T23:40:04.130' AS DateTime), CAST(N'2025-06-06T01:40:04.130' AS DateTime), 7200, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (5, 5, N'session321654987', N'192.168.1.104', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', CAST(N'2025-06-06T03:10:04.130' AS DateTime), NULL, 1800, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (6, 1, N'session654987321', N'192.168.1.105', N'Mozilla/5.0 (Macintosh; Intel Mac OS X)', CAST(N'2025-06-05T22:40:04.130' AS DateTime), CAST(N'2025-06-06T00:40:04.130' AS DateTime), 7200, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (7, 2, N'session159753486', N'192.168.1.106', N'Mozilla/5.0 (iPhone; CPU iPhone OS)', CAST(N'2025-06-06T01:40:04.130' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (8, 1, N'test_session_1749156930643', N'192.168.1.1', N'Mozilla/5.0 (Test)', CAST(N'2025-06-06T02:55:30.643' AS DateTime), CAST(N'2025-06-06T03:55:30.643' AS DateTime), 3600, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (9, NULL, N'77813989D3A6B7231F04A25FDE43D580', N'unknown', N'unknown', CAST(N'2025-06-06T16:26:01.387' AS DateTime), CAST(N'2025-06-06T16:30:23.890' AS DateTime), 262, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (10, NULL, N'2074D24F4EF44A87E8C481861AAE4431', N'unknown', N'unknown', CAST(N'2025-06-06T16:30:24.890' AS DateTime), CAST(N'2025-06-06T16:32:27.347' AS DateTime), 122, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (11, NULL, N'301228F0D1DD72582707C764605B88F2', N'unknown', N'unknown', CAST(N'2025-06-06T16:34:13.357' AS DateTime), CAST(N'2025-06-06T16:54:52.357' AS DateTime), 1238, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (12, NULL, N'8B2EC8C06A4EAE8CF827B14FFBB4D42D', N'unknown', N'unknown', CAST(N'2025-06-06T21:09:43.657' AS DateTime), CAST(N'2025-06-06T21:10:42.457' AS DateTime), 58, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (13, NULL, N'5B3794E69CFB94CAD4B2D0CC4591767D', N'unknown', N'unknown', CAST(N'2025-06-06T21:10:45.237' AS DateTime), CAST(N'2025-06-06T21:16:08.457' AS DateTime), 323, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (14, NULL, N'04A0BE8FDA269001A835368CD35941B5', N'unknown', N'unknown', CAST(N'2025-06-06T21:16:11.257' AS DateTime), CAST(N'2025-06-06T21:24:23.680' AS DateTime), 492, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (15, NULL, N'99017B4C34D9555678B5A9E1FFAFA32F', N'unknown', N'unknown', CAST(N'2025-06-06T21:24:44.357' AS DateTime), CAST(N'2025-06-06T21:30:00.630' AS DateTime), 316, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (16, NULL, N'03118984A47D32780CAABC28A3828E18', N'unknown', N'unknown', CAST(N'2025-06-06T21:30:06.640' AS DateTime), CAST(N'2025-06-06T21:31:51.620' AS DateTime), 104, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (17, NULL, N'DD0C8440871901512399D8CE3E2EA77B', N'unknown', N'unknown', CAST(N'2025-06-06T21:31:53.610' AS DateTime), CAST(N'2025-06-06T21:32:35.227' AS DateTime), 41, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (18, NULL, N'4E711116E1F40E694702CC3597002CEB', N'unknown', N'unknown', CAST(N'2025-06-06T21:32:58.760' AS DateTime), CAST(N'2025-06-06T21:34:29.593' AS DateTime), 90, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (19, NULL, N'BDDDD91E925D9CD328A3F16A0DEF8A9D', N'unknown', N'unknown', CAST(N'2025-06-06T21:34:45.477' AS DateTime), CAST(N'2025-06-06T21:35:11.657' AS DateTime), 26, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (20, NULL, N'9B2444873318FCFAC3203F7BDEE7CEC4', N'unknown', N'unknown', CAST(N'2025-06-06T21:35:50.710' AS DateTime), CAST(N'2025-06-06T21:36:14.103' AS DateTime), 23, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (21, NULL, N'39A5F361534744DDE913182FF7ACA260', N'unknown', N'unknown', CAST(N'2025-06-06T21:37:06.867' AS DateTime), CAST(N'2025-06-06T21:37:34.117' AS DateTime), 27, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (22, NULL, N'9284B6756B20525D43A58233D8056C20', N'unknown', N'unknown', CAST(N'2025-06-06T21:37:55.900' AS DateTime), CAST(N'2025-06-06T21:38:14.370' AS DateTime), 18, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (23, NULL, N'985188AE482CA63F35F1D1EC08C8B382', N'unknown', N'unknown', CAST(N'2025-06-06T21:38:41.397' AS DateTime), CAST(N'2025-06-06T21:49:40.657' AS DateTime), 659, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (24, NULL, N'090AAE74D8289A9A55BC9A14A94A3A4F', N'unknown', N'unknown', CAST(N'2025-06-06T21:56:38.753' AS DateTime), CAST(N'2025-06-06T22:31:46.407' AS DateTime), 2107, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (25, NULL, N'5BC48A78F7C65A604724489B069A5FD1', N'unknown', N'unknown', CAST(N'2025-06-06T23:29:53.980' AS DateTime), CAST(N'2025-06-06T23:34:58.990' AS DateTime), 304, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (26, NULL, N'40B329AC53B49DC86F385357363D8E13', N'unknown', N'unknown', CAST(N'2025-06-06T23:36:16.677' AS DateTime), CAST(N'2025-06-06T23:36:50.457' AS DateTime), 33, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (27, NULL, N'D271FDF65275D153DEBDED3CFBFC0E7A', N'unknown', N'unknown', CAST(N'2025-06-06T23:37:19.410' AS DateTime), CAST(N'2025-06-07T00:24:34.127' AS DateTime), 2834, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (28, NULL, N'BAEADCD4F9D8279FEFEA755C71AA4944', N'unknown', N'unknown', CAST(N'2025-06-07T00:25:26.557' AS DateTime), CAST(N'2025-06-07T00:27:40.867' AS DateTime), 134, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (29, NULL, N'4CC18F13DBEB353F7891385E9CAFF074', N'unknown', N'unknown', CAST(N'2025-06-08T21:18:27.557' AS DateTime), CAST(N'2025-06-08T21:21:18.010' AS DateTime), 170, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (30, NULL, N'B7D8AB656423FC6D672F1CFD83DA0036', N'unknown', N'unknown', CAST(N'2025-06-08T21:21:18.037' AS DateTime), CAST(N'2025-06-08T21:52:37.347' AS DateTime), 1879, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (31, NULL, N'821DEA1FB8B6B6A65165656D7384FF4F', N'unknown', N'unknown', CAST(N'2025-06-10T02:58:47.423' AS DateTime), CAST(N'2025-06-10T03:03:46.017' AS DateTime), 298, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (32, NULL, N'754605069AD8D8666AE9C7C95C036366', N'unknown', N'unknown', CAST(N'2025-06-10T03:07:38.810' AS DateTime), CAST(N'2025-06-10T03:13:11.710' AS DateTime), 332, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (33, NULL, N'6CD36EFCCE8F0B9B28EAAF3EC5D8C705', N'unknown', N'unknown', CAST(N'2025-06-10T03:13:14.757' AS DateTime), CAST(N'2025-06-10T03:16:18.263' AS DateTime), 183, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (34, NULL, N'A4B90AC63C4C2581984DA0C54EBC723B', N'unknown', N'unknown', CAST(N'2025-06-10T03:16:40.710' AS DateTime), CAST(N'2025-06-10T03:17:09.477' AS DateTime), 28, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (35, NULL, N'2855AA51A138ABEEBF97E914F2FA7EF3', N'unknown', N'unknown', CAST(N'2025-06-10T03:17:10.427' AS DateTime), CAST(N'2025-06-10T03:22:48.997' AS DateTime), 338, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (36, NULL, N'4C46EA33FF44A9BE53F6801CFD617351', N'unknown', N'unknown', CAST(N'2025-06-10T03:23:23.290' AS DateTime), CAST(N'2025-06-10T03:28:50.247' AS DateTime), 326, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (37, NULL, N'1052E39D82D4B070D9A563C3C3BA42FA', N'unknown', N'unknown', CAST(N'2025-06-10T03:32:04.413' AS DateTime), CAST(N'2025-06-10T03:39:56.947' AS DateTime), 472, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (38, NULL, N'835C066BE905FA7AAFF95988E6E8E02C', N'unknown', N'unknown', CAST(N'2025-06-10T04:43:15.533' AS DateTime), CAST(N'2025-06-10T04:43:42.950' AS DateTime), 27, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (39, NULL, N'D5E2C0577C3A0E98B37F88C38CC0EE73', N'unknown', N'unknown', CAST(N'2025-06-10T04:43:48.863' AS DateTime), CAST(N'2025-06-10T04:52:52.773' AS DateTime), 543, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (40, NULL, N'B0A8438FDA8B6D2BD6152D74B7A9F5D4', N'unknown', N'unknown', CAST(N'2025-06-10T04:54:20.403' AS DateTime), CAST(N'2025-06-10T04:54:37.663' AS DateTime), 17, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (41, NULL, N'B5E175746014FF78FE1B9C6034D286BA', N'unknown', N'unknown', CAST(N'2025-06-10T04:54:53.667' AS DateTime), CAST(N'2025-06-10T05:02:40.417' AS DateTime), 466, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (42, NULL, N'795AA6DE601FD5F0F0F8F55501AE5EC8', N'unknown', N'unknown', CAST(N'2025-06-10T05:03:36.027' AS DateTime), CAST(N'2025-06-10T05:04:15.823' AS DateTime), 39, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (43, NULL, N'8F7350BB2119A4EC56773B3E9626560B', N'unknown', N'unknown', CAST(N'2025-06-10T05:04:16.820' AS DateTime), CAST(N'2025-06-10T05:09:39.967' AS DateTime), 323, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (44, NULL, N'11FD81D4E600976E57497116BBE877A7', N'unknown', N'unknown', CAST(N'2025-06-10T05:14:25.183' AS DateTime), CAST(N'2025-06-10T05:16:52.143' AS DateTime), 146, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (45, NULL, N'D9DCE04FAA61D248389866F2A7E6B56F', N'unknown', N'unknown', CAST(N'2025-06-10T05:21:20.827' AS DateTime), CAST(N'2025-06-10T05:22:36.317' AS DateTime), 75, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (46, NULL, N'227644FF59731BD424C5189D586582FF', N'unknown', N'unknown', CAST(N'2025-06-10T05:32:39.543' AS DateTime), CAST(N'2025-06-10T05:39:48.723' AS DateTime), 429, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (47, NULL, N'0AF7F4E31E30348E8A3594924CE428EE', N'unknown', N'unknown', CAST(N'2025-06-10T05:40:35.477' AS DateTime), CAST(N'2025-06-10T05:46:25.970' AS DateTime), 350, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (48, NULL, N'406B2152EF10EBFC9B92E9B73C3D5979', N'unknown', N'unknown', CAST(N'2025-06-10T05:49:45.580' AS DateTime), CAST(N'2025-06-10T05:53:35.143' AS DateTime), 229, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (49, NULL, N'B0B11ED2636D028755C71102085B2DED', N'unknown', N'unknown', CAST(N'2025-06-10T05:54:38.577' AS DateTime), CAST(N'2025-06-10T05:56:27.097' AS DateTime), 108, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (50, NULL, N'52B73889CE84F5D0EC30CE64F01D22C6', N'unknown', N'unknown', CAST(N'2025-06-10T05:56:43.943' AS DateTime), CAST(N'2025-06-10T05:58:01.997' AS DateTime), 78, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (51, NULL, N'B002F1E787252F9B94A7D094DD2CC89C', N'unknown', N'unknown', CAST(N'2025-06-10T05:58:52.587' AS DateTime), CAST(N'2025-06-10T06:00:12.050' AS DateTime), 79, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (52, NULL, N'BFC3BD12B090AA98F1AAD863CF433DB7', N'unknown', N'unknown', CAST(N'2025-06-10T06:01:20.267' AS DateTime), CAST(N'2025-06-10T06:01:51.977' AS DateTime), 31, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (53, NULL, N'FE1C0BE5304C2B3CBD6BDCB39A0CF7FF', N'unknown', N'unknown', CAST(N'2025-06-10T06:03:48.717' AS DateTime), CAST(N'2025-06-10T06:09:05.387' AS DateTime), 316, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (54, NULL, N'4D1ED84AA4007DC07232032E990FC8D3', N'unknown', N'unknown', CAST(N'2025-06-10T06:18:15.400' AS DateTime), CAST(N'2025-06-10T06:51:31.497' AS DateTime), 1996, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (55, NULL, N'E5297114DD03F4701C38FA50A851648F', N'unknown', N'unknown', CAST(N'2025-06-10T06:52:02.827' AS DateTime), CAST(N'2025-06-10T06:54:29.887' AS DateTime), 147, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (56, NULL, N'99AA731CB91D7BEA5651E12A11073568', N'unknown', N'unknown', CAST(N'2025-06-10T06:55:57.073' AS DateTime), CAST(N'2025-06-10T06:56:43.747' AS DateTime), 46, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (57, NULL, N'02E945D63C7B0209852A677302F8CFF3', N'unknown', N'unknown', CAST(N'2025-06-10T06:58:45.893' AS DateTime), CAST(N'2025-06-10T07:01:55.860' AS DateTime), 189, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (58, NULL, N'A3121E68128918E3C5CCE8D99C356D04', N'unknown', N'unknown', CAST(N'2025-06-10T07:02:13.707' AS DateTime), CAST(N'2025-06-10T07:12:51.603' AS DateTime), 637, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (59, NULL, N'2ACC65E40437F120D9488D824147E2C0', N'unknown', N'unknown', CAST(N'2025-06-10T07:12:58.980' AS DateTime), CAST(N'2025-06-10T07:13:36.597' AS DateTime), 37, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (60, NULL, N'2852FD294B3AF6920F7F77876B20EAF1', N'unknown', N'unknown', CAST(N'2025-06-10T07:13:40.047' AS DateTime), CAST(N'2025-06-10T07:25:39.927' AS DateTime), 719, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (61, NULL, N'9B5C846633CE0735F96991AC07A80BA3', N'unknown', N'unknown', CAST(N'2025-06-10T07:26:49.653' AS DateTime), CAST(N'2025-06-10T07:35:11.867' AS DateTime), 502, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (62, NULL, N'EE5AA1FFED5E10E7111B1F927A28996D', N'unknown', N'unknown', CAST(N'2025-06-10T07:36:48.690' AS DateTime), CAST(N'2025-06-10T08:01:46.887' AS DateTime), 1498, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (63, NULL, N'01191B9ADB0CD1EDACCF9BAA4C9D4913', N'unknown', N'unknown', CAST(N'2025-06-10T08:01:48.460' AS DateTime), CAST(N'2025-06-10T08:39:57.343' AS DateTime), 2288, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (64, NULL, N'ACAC65A8CBA0923506E2EC74AC76D278', N'unknown', N'unknown', CAST(N'2025-06-10T09:03:48.930' AS DateTime), CAST(N'2025-06-10T09:07:11.767' AS DateTime), 202, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (65, NULL, N'84E285D028A852FFD6CAF0EA51F77AB4', N'unknown', N'unknown', CAST(N'2025-06-10T09:24:13.230' AS DateTime), CAST(N'2025-06-10T09:24:24.643' AS DateTime), 11, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (66, NULL, N'58FA19CA9894DA09450FDF39242D8E45', N'unknown', N'unknown', CAST(N'2025-06-10T09:38:48.407' AS DateTime), CAST(N'2025-06-10T09:38:56.477' AS DateTime), 8, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (67, NULL, N'471D6AC268AF262FAC2A227CFC75B950', N'unknown', N'unknown', CAST(N'2025-06-10T09:38:57.457' AS DateTime), CAST(N'2025-06-10T09:41:22.753' AS DateTime), 145, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (68, NULL, N'4F4CF7B78C38D206E5E440CA246B70E0', N'unknown', N'unknown', CAST(N'2025-06-10T09:41:34.870' AS DateTime), CAST(N'2025-06-10T09:56:25.820' AS DateTime), 890, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (69, NULL, N'5154E0C610F38EFE7EDA73100510FA3A', N'unknown', N'unknown', CAST(N'2025-06-10T10:18:32.837' AS DateTime), CAST(N'2025-06-10T10:26:49.337' AS DateTime), 496, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (70, NULL, N'1FAB285793FA2CDBBC53F221D3F92CCE', N'unknown', N'unknown', CAST(N'2025-06-10T10:28:10.243' AS DateTime), CAST(N'2025-06-10T10:31:42.877' AS DateTime), 212, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (71, NULL, N'CCEBEA38D87A870D1ABD3553E498D825', N'unknown', N'unknown', CAST(N'2025-06-10T10:31:48.337' AS DateTime), CAST(N'2025-06-10T10:36:08.553' AS DateTime), 260, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (72, NULL, N'93F27EB049EA45CB75F53DBF3532676C', N'unknown', N'unknown', CAST(N'2025-06-10T10:50:19.467' AS DateTime), CAST(N'2025-06-10T10:55:45.123' AS DateTime), 325, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (73, NULL, N'0F72200DA7560958AAA245C6473B2C5B', N'unknown', N'unknown', CAST(N'2025-06-10T11:00:00.033' AS DateTime), CAST(N'2025-06-10T11:10:52.030' AS DateTime), 651, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (74, NULL, N'0B3FED57A9BDE3017747C497D4D12CBA', N'unknown', N'unknown', CAST(N'2025-06-10T11:12:04.583' AS DateTime), CAST(N'2025-06-10T11:18:00.210' AS DateTime), 355, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (75, NULL, N'010CBFC1853D143ED000E3AFEF005FA3', N'unknown', N'unknown', CAST(N'2025-06-10T11:18:19.263' AS DateTime), CAST(N'2025-06-10T11:27:31.307' AS DateTime), 552, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (76, NULL, N'44C1C957AF3D5A4DA32D44557F3F0343', N'unknown', N'unknown', CAST(N'2025-06-10T11:28:31.260' AS DateTime), CAST(N'2025-06-10T11:32:03.453' AS DateTime), 212, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (77, NULL, N'9A5171A8AFCAAADB5D9669576092A315', N'unknown', N'unknown', CAST(N'2025-06-10T11:37:46.627' AS DateTime), CAST(N'2025-06-10T11:37:55.750' AS DateTime), 9, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (78, NULL, N'61CF81BAC13C4A3CFE459C968FCECEA8', N'unknown', N'unknown', CAST(N'2025-06-10T11:38:27.617' AS DateTime), CAST(N'2025-06-10T12:09:18.037' AS DateTime), 1850, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (79, NULL, N'B2CE724BC75470C38BB22170E1CD5A2A', N'unknown', N'unknown', CAST(N'2025-06-10T12:36:08.460' AS DateTime), CAST(N'2025-06-10T12:36:55.690' AS DateTime), 47, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (80, NULL, N'5D71433AB88F39C5242108B19C1FB35B', N'unknown', N'unknown', CAST(N'2025-06-10T12:40:14.597' AS DateTime), CAST(N'2025-06-10T12:45:25.707' AS DateTime), 311, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (81, NULL, N'D89A816096EB5361F4352B33FC64B837', N'unknown', N'unknown', CAST(N'2025-06-10T12:45:41.567' AS DateTime), CAST(N'2025-06-10T12:48:59.167' AS DateTime), 197, 1)
INSERT [dbo].[user_sessions] ([id], [user_id], [session_id], [ip_address], [user_agent], [login_time], [logout_time], [duration], [status]) VALUES (82, NULL, N'013CEB7FD1D1D0FA994A6491C5C87EE7', N'unknown', N'unknown', CAST(N'2025-06-10T12:50:11.677' AS DateTime), CAST(N'2025-06-10T12:54:49.920' AS DateTime), 278, 1)
SET IDENTITY_INSERT [dbo].[user_sessions] OFF
GO
SET IDENTITY_INSERT [dbo].[users] ON 

INSERT [dbo].[users] ([id], [email], [password], [fullname], [phone], [address], [role_id], [status], [created_at], [verification_token], [service_package_id], [is_active], [activation_token], [token_expiry]) VALUES (1, N'user1@example.com', N'123456Aa', N'Nguyễn Văn A', N'0912345678', N'123 Đường ABC, Quận 1', 1, 1, CAST(N'2025-06-03T19:06:35.020' AS DateTime), NULL, 1, 1, NULL, NULL)
INSERT [dbo].[users] ([id], [email], [password], [fullname], [phone], [address], [role_id], [status], [created_at], [verification_token], [service_package_id], [is_active], [activation_token], [token_expiry]) VALUES (2, N'user2@example.com', N'123456Aa', N'Trần Thị B', N'0987654321', N'456 Đường XYZ, Quận 2', 1, 1, CAST(N'2025-06-03T19:06:35.020' AS DateTime), NULL, 2, 0, NULL, NULL)
INSERT [dbo].[users] ([id], [email], [password], [fullname], [phone], [address], [role_id], [status], [created_at], [verification_token], [service_package_id], [is_active], [activation_token], [token_expiry]) VALUES (3, N'staff1@pettech.com', N'123456Aa', N'Nhân viên C', N'0909999999', N'789 Đường DEF, Quận 3', 2, 1, CAST(N'2025-06-03T19:06:35.020' AS DateTime), NULL, 2, 1, NULL, NULL)
INSERT [dbo].[users] ([id], [email], [password], [fullname], [phone], [address], [role_id], [status], [created_at], [verification_token], [service_package_id], [is_active], [activation_token], [token_expiry]) VALUES (4, N'admin@pettech.com', N'123456Aa', N'Quản trị viên D', N'0938888888', N'321 Đường GHI, Quận 4', 3, 1, CAST(N'2025-06-03T19:06:35.020' AS DateTime), NULL, 3, 1, NULL, NULL)
INSERT [dbo].[users] ([id], [email], [password], [fullname], [phone], [address], [role_id], [status], [created_at], [verification_token], [service_package_id], [is_active], [activation_token], [token_expiry]) VALUES (5, N'user3@example.com', N'123456Aa', N'Lê Văn C', N'0987654322', N'789 Đường XYZ, Quận 3', 1, 1, CAST(N'2025-06-03T19:06:35.020' AS DateTime), NULL, 1, 1, NULL, NULL)
INSERT [dbo].[users] ([id], [email], [password], [fullname], [phone], [address], [role_id], [status], [created_at], [verification_token], [service_package_id], [is_active], [activation_token], [token_expiry]) VALUES (7, N'user5@example.com', N'123456Aa', N'Trần Văn E', N'0987654324', N'123 Đường DEF, Quận 5', 1, 1, CAST(N'2025-06-03T19:06:35.020' AS DateTime), NULL, 3, 1, NULL, NULL)
INSERT [dbo].[users] ([id], [email], [password], [fullname], [phone], [address], [role_id], [status], [created_at], [verification_token], [service_package_id], [is_active], [activation_token], [token_expiry]) VALUES (9, N'camvdhs176256@fpt.edu.vn', N'Cam@123456', N'cam vu', N'0377728031', N'tức tranh, phú lương, thái nguyên', 1, 1, CAST(N'2025-06-05T23:10:13.477' AS DateTime), NULL, 1, 1, NULL, NULL)
INSERT [dbo].[users] ([id], [email], [password], [fullname], [phone], [address], [role_id], [status], [created_at], [verification_token], [service_package_id], [is_active], [activation_token], [token_expiry]) VALUES (10, N'user4@gmail.com', N'User4@123456', N'Cẩm Vũ', N'0333418809', N'TN', 2, 1, CAST(N'2025-06-10T03:30:22.390' AS DateTime), NULL, NULL, 0, NULL, NULL)
INSERT [dbo].[users] ([id], [email], [password], [fullname], [phone], [address], [role_id], [status], [created_at], [verification_token], [service_package_id], [is_active], [activation_token], [token_expiry]) VALUES (12, N'user6@gmail.com', N'User6@123456', N'Vũ Cẩm', N'0377728031', N'Thái Nguyên', 3, 1, CAST(N'2025-06-10T03:38:17.843' AS DateTime), NULL, NULL, 0, NULL, NULL)
SET IDENTITY_INSERT [dbo].[users] OFF
GO
/****** Object:  Index [uc_course_date]    Script Date: 10/06/2025 1:10:04 CH ******/
ALTER TABLE [dbo].[course_statistics] ADD  CONSTRAINT [uc_course_date] UNIQUE NONCLUSTERED 
(
	[course_id] ASC,
	[date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ__daily_st__D9DE21FD16D0A8E5]    Script Date: 10/06/2025 1:10:04 CH ******/
ALTER TABLE [dbo].[daily_statistics] ADD UNIQUE NONCLUSTERED 
(
	[date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__partners__AB6E6164359319A3]    Script Date: 10/06/2025 1:10:04 CH ******/
ALTER TABLE [dbo].[partners] ADD UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__service___E3F852489EB07D90]    Script Date: 10/06/2025 1:10:04 CH ******/
ALTER TABLE [dbo].[service_packages] ADD UNIQUE NONCLUSTERED 
(
	[type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__users__AB6E6164F5A007C1]    Script Date: 10/06/2025 1:10:04 CH ******/
ALTER TABLE [dbo].[users] ADD UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[audit_log] ADD  DEFAULT (getdate()) FOR [changed_at]
GO
ALTER TABLE [dbo].[audit_log] ADD  DEFAULT ((1)) FOR [status]
GO
ALTER TABLE [dbo].[BlogCategories] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[BlogCategories] ADD  DEFAULT ((1)) FOR [status]
GO
ALTER TABLE [dbo].[BlogComments] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[BlogComments] ADD  DEFAULT ((1)) FOR [status]
GO
ALTER TABLE [dbo].[Blogs] ADD  DEFAULT ('Admin') FOR [author_name]
GO
ALTER TABLE [dbo].[Blogs] ADD  DEFAULT ((0)) FOR [view_count]
GO
ALTER TABLE [dbo].[Blogs] ADD  DEFAULT ((0)) FOR [is_featured]
GO
ALTER TABLE [dbo].[Blogs] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[Blogs] ADD  DEFAULT (getdate()) FOR [updated_at]
GO
ALTER TABLE [dbo].[Blogs] ADD  DEFAULT ((1)) FOR [status]
GO
ALTER TABLE [dbo].[course_access] ADD  DEFAULT ((1)) FOR [status]
GO
ALTER TABLE [dbo].[course_categories] ADD  DEFAULT ((1)) FOR [status]
GO
ALTER TABLE [dbo].[course_category_mapping] ADD  DEFAULT ((1)) FOR [status]
GO
ALTER TABLE [dbo].[course_images] ADD  DEFAULT ((0)) FOR [is_primary]
GO
ALTER TABLE [dbo].[course_images] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[course_images] ADD  DEFAULT ((1)) FOR [status]
GO
ALTER TABLE [dbo].[course_lessons] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[course_lessons] ADD  DEFAULT (getdate()) FOR [updated_at]
GO
ALTER TABLE [dbo].[course_lessons] ADD  DEFAULT ((1)) FOR [status]
GO
ALTER TABLE [dbo].[course_modules] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[course_modules] ADD  DEFAULT (getdate()) FOR [updated_at]
GO
ALTER TABLE [dbo].[course_modules] ADD  DEFAULT ((1)) FOR [status]
GO
ALTER TABLE [dbo].[course_reviews] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[course_reviews] ADD  DEFAULT ((1)) FOR [status]
GO
ALTER TABLE [dbo].[course_statistics] ADD  DEFAULT ((0)) FOR [views]
GO
ALTER TABLE [dbo].[course_statistics] ADD  DEFAULT ((0)) FOR [enrollments]
GO
ALTER TABLE [dbo].[course_statistics] ADD  DEFAULT ((0)) FOR [avg_view_duration]
GO
ALTER TABLE [dbo].[course_statistics] ADD  DEFAULT ((0)) FOR [completion_rate]
GO
ALTER TABLE [dbo].[courses] ADD  DEFAULT ((1)) FOR [status]
GO
ALTER TABLE [dbo].[courses] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[courses] ADD  DEFAULT (getdate()) FOR [updated_at]
GO
ALTER TABLE [dbo].[courses] ADD  DEFAULT ((0)) FOR [is_paid]
GO
ALTER TABLE [dbo].[daily_statistics] ADD  DEFAULT ((0)) FOR [total_visits]
GO
ALTER TABLE [dbo].[daily_statistics] ADD  DEFAULT ((0)) FOR [unique_visitors]
GO
ALTER TABLE [dbo].[daily_statistics] ADD  DEFAULT ((0)) FOR [new_users]
GO
ALTER TABLE [dbo].[daily_statistics] ADD  DEFAULT ((0)) FOR [avg_session_duration]
GO
ALTER TABLE [dbo].[daily_statistics] ADD  DEFAULT ((0)) FOR [page_views]
GO
ALTER TABLE [dbo].[daily_statistics] ADD  DEFAULT ((0)) FOR [total_users]
GO
ALTER TABLE [dbo].[daily_statistics] ADD  DEFAULT ((0)) FOR [active_users]
GO
ALTER TABLE [dbo].[daily_statistics] ADD  DEFAULT ((0)) FOR [new_registrations]
GO
ALTER TABLE [dbo].[daily_statistics] ADD  DEFAULT ((0)) FOR [premium_users]
GO
ALTER TABLE [dbo].[daily_statistics] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[daily_statistics] ADD  DEFAULT (getdate()) FOR [updated_at]
GO
ALTER TABLE [dbo].[lesson_attachments] ADD  DEFAULT ((1)) FOR [status]
GO
ALTER TABLE [dbo].[order_items] ADD  DEFAULT ((1)) FOR [status]
GO
ALTER TABLE [dbo].[orders] ADD  DEFAULT (getdate()) FOR [order_date]
GO
ALTER TABLE [dbo].[partners] ADD  DEFAULT ((1)) FOR [status]
GO
ALTER TABLE [dbo].[partners] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[payments] ADD  DEFAULT (getdate()) FOR [payment_date]
GO
ALTER TABLE [dbo].[payments] ADD  DEFAULT ('pending') FOR [status]
GO
ALTER TABLE [dbo].[payments] ADD  DEFAULT ((0)) FOR [is_confirmed]
GO
ALTER TABLE [dbo].[product_categories] ADD  DEFAULT ((1)) FOR [status]
GO
ALTER TABLE [dbo].[product_category_mapping] ADD  DEFAULT ((1)) FOR [status]
GO
ALTER TABLE [dbo].[products] ADD  DEFAULT ((1)) FOR [status]
GO
ALTER TABLE [dbo].[service_packages] ADD  DEFAULT ((1)) FOR [status]
GO
ALTER TABLE [dbo].[user_packages] ADD  DEFAULT ((1)) FOR [status]
GO
ALTER TABLE [dbo].[user_progress] ADD  DEFAULT ((0)) FOR [completed]
GO
ALTER TABLE [dbo].[user_progress] ADD  DEFAULT ((1)) FOR [status]
GO
ALTER TABLE [dbo].[user_reset_tokens] ADD  DEFAULT ((1)) FOR [status]
GO
ALTER TABLE [dbo].[user_reset_tokens] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[user_sessions] ADD  DEFAULT ((1)) FOR [status]
GO
ALTER TABLE [dbo].[users] ADD  DEFAULT ((1)) FOR [role_id]
GO
ALTER TABLE [dbo].[users] ADD  DEFAULT ((1)) FOR [status]
GO
ALTER TABLE [dbo].[users] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[users] ADD  DEFAULT ((0)) FOR [is_active]
GO
ALTER TABLE [dbo].[audit_log]  WITH CHECK ADD FOREIGN KEY([changed_by])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[BlogComments]  WITH CHECK ADD FOREIGN KEY([blog_id])
REFERENCES [dbo].[Blogs] ([blog_id])
GO
ALTER TABLE [dbo].[BlogComments]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[Blogs]  WITH CHECK ADD FOREIGN KEY([category_id])
REFERENCES [dbo].[BlogCategories] ([category_id])
GO
ALTER TABLE [dbo].[course_access]  WITH CHECK ADD FOREIGN KEY([course_id])
REFERENCES [dbo].[courses] ([id])
GO
ALTER TABLE [dbo].[course_access]  WITH CHECK ADD FOREIGN KEY([service_package_id])
REFERENCES [dbo].[service_packages] ([id])
GO
ALTER TABLE [dbo].[course_category_mapping]  WITH CHECK ADD FOREIGN KEY([category_id])
REFERENCES [dbo].[course_categories] ([id])
GO
ALTER TABLE [dbo].[course_category_mapping]  WITH CHECK ADD FOREIGN KEY([course_id])
REFERENCES [dbo].[courses] ([id])
GO
ALTER TABLE [dbo].[course_images]  WITH CHECK ADD FOREIGN KEY([course_id])
REFERENCES [dbo].[courses] ([id])
GO
ALTER TABLE [dbo].[course_lessons]  WITH CHECK ADD FOREIGN KEY([module_id])
REFERENCES [dbo].[course_modules] ([id])
GO
ALTER TABLE [dbo].[course_modules]  WITH CHECK ADD FOREIGN KEY([course_id])
REFERENCES [dbo].[courses] ([id])
GO
ALTER TABLE [dbo].[course_reviews]  WITH CHECK ADD FOREIGN KEY([course_id])
REFERENCES [dbo].[courses] ([id])
GO
ALTER TABLE [dbo].[course_reviews]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[course_statistics]  WITH CHECK ADD FOREIGN KEY([course_id])
REFERENCES [dbo].[courses] ([id])
GO
ALTER TABLE [dbo].[lesson_attachments]  WITH CHECK ADD FOREIGN KEY([lesson_id])
REFERENCES [dbo].[course_lessons] ([id])
GO
ALTER TABLE [dbo].[order_items]  WITH CHECK ADD FOREIGN KEY([order_id])
REFERENCES [dbo].[orders] ([id])
GO
ALTER TABLE [dbo].[order_items]  WITH CHECK ADD FOREIGN KEY([product_id])
REFERENCES [dbo].[products] ([id])
GO
ALTER TABLE [dbo].[orders]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[payments]  WITH CHECK ADD FOREIGN KEY([order_id])
REFERENCES [dbo].[orders] ([id])
GO
ALTER TABLE [dbo].[payments]  WITH CHECK ADD FOREIGN KEY([service_package_id])
REFERENCES [dbo].[service_packages] ([id])
GO
ALTER TABLE [dbo].[payments]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[product_category_mapping]  WITH CHECK ADD FOREIGN KEY([category_id])
REFERENCES [dbo].[product_categories] ([id])
GO
ALTER TABLE [dbo].[product_category_mapping]  WITH CHECK ADD FOREIGN KEY([product_id])
REFERENCES [dbo].[products] ([id])
GO
ALTER TABLE [dbo].[products]  WITH CHECK ADD FOREIGN KEY([partner_id])
REFERENCES [dbo].[partners] ([id])
GO
ALTER TABLE [dbo].[user_packages]  WITH CHECK ADD FOREIGN KEY([service_package_id])
REFERENCES [dbo].[service_packages] ([id])
GO
ALTER TABLE [dbo].[user_packages]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[user_progress]  WITH CHECK ADD FOREIGN KEY([lesson_id])
REFERENCES [dbo].[course_lessons] ([id])
GO
ALTER TABLE [dbo].[user_progress]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[user_reset_tokens]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[User_Service]  WITH CHECK ADD FOREIGN KEY([package_id])
REFERENCES [dbo].[service_packages] ([id])
GO
ALTER TABLE [dbo].[User_Service]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[user_sessions]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[users]  WITH CHECK ADD FOREIGN KEY([service_package_id])
REFERENCES [dbo].[service_packages] ([id])
GO
ALTER TABLE [dbo].[course_reviews]  WITH CHECK ADD CHECK  (([rating]>=(1) AND [rating]<=(5)))
GO
ALTER TABLE [dbo].[courses]  WITH CHECK ADD CHECK  (([status]=(1) OR [status]=(0)))
GO
ALTER TABLE [dbo].[order_items]  WITH CHECK ADD CHECK  (([price]>=(0)))
GO
ALTER TABLE [dbo].[order_items]  WITH CHECK ADD CHECK  (([quantity]>(0)))
GO
ALTER TABLE [dbo].[orders]  WITH CHECK ADD CHECK  (([commission]>=(0)))
GO
ALTER TABLE [dbo].[orders]  WITH CHECK ADD CHECK  (([status]=N'cancelled' OR [status]=N'completed' OR [status]=N'processing' OR [status]=N'pending'))
GO
ALTER TABLE [dbo].[orders]  WITH CHECK ADD CHECK  (([total_amount]>=(0)))
GO
ALTER TABLE [dbo].[payments]  WITH CHECK ADD CHECK  (([amount]>(0)))
GO
ALTER TABLE [dbo].[payments]  WITH CHECK ADD CHECK  (([payment_method]='CASH' OR [payment_method]='VNPAY' OR [payment_method]='BANK_QR' OR [payment_method]='MOMO_QR'))
GO
ALTER TABLE [dbo].[payments]  WITH CHECK ADD CHECK  (([status]='refunded' OR [status]='failed' OR [status]='completed' OR [status]='pending'))
GO
ALTER TABLE [dbo].[products]  WITH CHECK ADD CHECK  (([price]>=(0)))
GO
ALTER TABLE [dbo].[products]  WITH CHECK ADD CHECK  (([stock]>=(0)))
GO
ALTER TABLE [dbo].[service_packages]  WITH CHECK ADD CHECK  (([type]=N'pro' OR [type]=N'standard' OR [type]=N'free'))
GO
ALTER TABLE [dbo].[users]  WITH CHECK ADD CHECK  (([email] like '%@%.%'))
GO
ALTER TABLE [dbo].[users]  WITH CHECK ADD CHECK  (([role_id]=(3) OR [role_id]=(2) OR [role_id]=(1)))
GO
USE [master]
GO
ALTER DATABASE [PetTech] SET  READ_WRITE 
GO
