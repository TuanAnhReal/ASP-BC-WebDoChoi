USE [master]
GO
/****** Object:  Database [DB_WEB_DO_CHOI]    Script Date: 03/03/2026 8:32:56 AM ******/
CREATE DATABASE [DB_WEB_DO_CHOI]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'DB_WEB_DO_CHOI', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\DB_WEB_DO_CHOI.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'DB_WEB_DO_CHOI_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\DB_WEB_DO_CHOI_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [DB_WEB_DO_CHOI] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [DB_WEB_DO_CHOI].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [DB_WEB_DO_CHOI] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [DB_WEB_DO_CHOI] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [DB_WEB_DO_CHOI] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [DB_WEB_DO_CHOI] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [DB_WEB_DO_CHOI] SET ARITHABORT OFF 
GO
ALTER DATABASE [DB_WEB_DO_CHOI] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [DB_WEB_DO_CHOI] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [DB_WEB_DO_CHOI] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [DB_WEB_DO_CHOI] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [DB_WEB_DO_CHOI] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [DB_WEB_DO_CHOI] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [DB_WEB_DO_CHOI] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [DB_WEB_DO_CHOI] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [DB_WEB_DO_CHOI] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [DB_WEB_DO_CHOI] SET  ENABLE_BROKER 
GO
ALTER DATABASE [DB_WEB_DO_CHOI] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [DB_WEB_DO_CHOI] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [DB_WEB_DO_CHOI] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [DB_WEB_DO_CHOI] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [DB_WEB_DO_CHOI] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [DB_WEB_DO_CHOI] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [DB_WEB_DO_CHOI] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [DB_WEB_DO_CHOI] SET RECOVERY FULL 
GO
ALTER DATABASE [DB_WEB_DO_CHOI] SET  MULTI_USER 
GO
ALTER DATABASE [DB_WEB_DO_CHOI] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [DB_WEB_DO_CHOI] SET DB_CHAINING OFF 
GO
ALTER DATABASE [DB_WEB_DO_CHOI] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [DB_WEB_DO_CHOI] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [DB_WEB_DO_CHOI] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [DB_WEB_DO_CHOI] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'DB_WEB_DO_CHOI', N'ON'
GO
ALTER DATABASE [DB_WEB_DO_CHOI] SET QUERY_STORE = ON
GO
ALTER DATABASE [DB_WEB_DO_CHOI] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [DB_WEB_DO_CHOI]
GO
/****** Object:  Table [dbo].[AnhSanPham]    Script Date: 03/03/2026 8:32:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AnhSanPham](
	[MaAnh] [int] IDENTITY(1,1) NOT NULL,
	[MaSanPham] [int] NULL,
	[DuongDanAnh] [nvarchar](500) NOT NULL,
	[LaAnhChinh] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[MaAnh] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BienTheSanPham]    Script Date: 03/03/2026 8:32:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BienTheSanPham](
	[MaBienThe] [int] IDENTITY(1,1) NOT NULL,
	[MaSanPham] [int] NULL,
	[TenBienThe] [nvarchar](100) NULL,
	[GiaBan] [decimal](18, 2) NOT NULL,
	[SoLuongTon] [int] NOT NULL,
	[SKU] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[MaBienThe] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ChiTietDonHang]    Script Date: 03/03/2026 8:32:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChiTietDonHang](
	[MaDonHang] [int] NOT NULL,
	[MaBienThe] [int] NOT NULL,
	[SoLuong] [int] NOT NULL,
	[GiaTaiThoiDiemBan] [decimal](18, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MaDonHang] ASC,
	[MaBienThe] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DanhGia]    Script Date: 03/03/2026 8:32:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DanhGia](
	[MaDanhGia] [int] IDENTITY(1,1) NOT NULL,
	[MaSanPham] [int] NOT NULL,
	[MaKhachHang] [int] NOT NULL,
	[SoSao] [int] NULL,
	[NoiDung] [nvarchar](max) NULL,
	[NgayGui] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[MaDanhGia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DonHang]    Script Date: 03/03/2026 8:32:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DonHang](
	[MaDonHang] [int] IDENTITY(1,1) NOT NULL,
	[MaKhachHang] [int] NULL,
	[NgayDat] [datetime] NULL,
	[TongTien] [decimal](18, 2) NULL,
	[TrangThaiDonHang] [nvarchar](50) NULL,
	[DiaChiGiaoHang] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[MaDonHang] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DoTuoi]    Script Date: 03/03/2026 8:32:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DoTuoi](
	[MaDoTuoi] [int] IDENTITY(1,1) NOT NULL,
	[KhoangDoTuoi] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MaDoTuoi] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[KhachHang]    Script Date: 03/03/2026 8:32:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KhachHang](
	[MaKhachHang] [int] IDENTITY(1,1) NOT NULL,
	[HoTen] [nvarchar](100) NOT NULL,
	[Email] [varchar](100) NULL,
	[SoDienThoai] [varchar](15) NULL,
	[DiaChi] [nvarchar](255) NULL,
	[MatKhau] [nvarchar](500) NOT NULL,
	[NgayDangKy] [datetime] NULL,
	[VaiTro] [nvarchar](20) NULL,
	[TrangThai] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[MaKhachHang] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NhomSanPham]    Script Date: 03/03/2026 8:32:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NhomSanPham](
	[MaNhom] [int] IDENTITY(1,1) NOT NULL,
	[TenNhom] [nvarchar](100) NOT NULL,
	[MoTa] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[MaNhom] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QuangCao]    Script Date: 03/03/2026 8:32:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QuangCao](
	[MaQC] [int] IDENTITY(1,1) NOT NULL,
	[TieuDe] [nvarchar](200) NULL,
	[HinhAnh] [nvarchar](500) NOT NULL,
	[LienKet] [nvarchar](500) NULL,
	[ThuTu] [int] NULL,
	[HienThi] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[MaQC] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SanPham]    Script Date: 03/03/2026 8:32:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SanPham](
	[MaSanPham] [int] IDENTITY(1,1) NOT NULL,
	[TenSanPham] [nvarchar](200) NOT NULL,
	[MaNhom] [int] NULL,
	[MaThuongHieu] [int] NULL,
	[MaDoTuoi] [int] NULL,
	[MoTaChiTiet] [nvarchar](max) NULL,
	[NgayTao] [datetime] NULL,
	[TrangThai] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[MaSanPham] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ThuongHieu]    Script Date: 03/03/2026 8:32:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ThuongHieu](
	[MaThuongHieu] [int] IDENTITY(1,1) NOT NULL,
	[TenThuongHieu] [nvarchar](100) NOT NULL,
	[QuocGia] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[MaThuongHieu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[AnhSanPham] ON 
GO
INSERT [dbo].[AnhSanPham] ([MaAnh], [MaSanPham], [DuongDanAnh], [LaAnhChinh]) VALUES (1, 1, N'prod_639081214203990562.jpg', 1)
GO
INSERT [dbo].[AnhSanPham] ([MaAnh], [MaSanPham], [DuongDanAnh], [LaAnhChinh]) VALUES (3, 2, N'prod_639044916509137964.jpg', 1)
GO
INSERT [dbo].[AnhSanPham] ([MaAnh], [MaSanPham], [DuongDanAnh], [LaAnhChinh]) VALUES (4, 3, N'prod_639081213781652809.jpg', 1)
GO
INSERT [dbo].[AnhSanPham] ([MaAnh], [MaSanPham], [DuongDanAnh], [LaAnhChinh]) VALUES (5, 4, N'prod_639081213415056320.jpg', 1)
GO
INSERT [dbo].[AnhSanPham] ([MaAnh], [MaSanPham], [DuongDanAnh], [LaAnhChinh]) VALUES (6, 1, N'lego-classic-side.jpg', 0)
GO
INSERT [dbo].[AnhSanPham] ([MaAnh], [MaSanPham], [DuongDanAnh], [LaAnhChinh]) VALUES (7, 1, N'lego-classic-pieces.jpg', 0)
GO
INSERT [dbo].[AnhSanPham] ([MaAnh], [MaSanPham], [DuongDanAnh], [LaAnhChinh]) VALUES (8, 1, N'lego-classic-box-back.jpg', 0)
GO
INSERT [dbo].[AnhSanPham] ([MaAnh], [MaSanPham], [DuongDanAnh], [LaAnhChinh]) VALUES (11, 3, N'hotwheels-red-side.jpg', 0)
GO
INSERT [dbo].[AnhSanPham] ([MaAnh], [MaSanPham], [DuongDanAnh], [LaAnhChinh]) VALUES (12, 3, N'hotwheels-red-back.jpg', 0)
GO
INSERT [dbo].[AnhSanPham] ([MaAnh], [MaSanPham], [DuongDanAnh], [LaAnhChinh]) VALUES (13, 4, N'lego-city-police-car.jpg', 0)
GO
INSERT [dbo].[AnhSanPham] ([MaAnh], [MaSanPham], [DuongDanAnh], [LaAnhChinh]) VALUES (14, 4, N'lego-city-police-minifig.jpg', 0)
GO
INSERT [dbo].[AnhSanPham] ([MaAnh], [MaSanPham], [DuongDanAnh], [LaAnhChinh]) VALUES (15, 5, N'prod_639042877773802549.jpg', 1)
GO
INSERT [dbo].[AnhSanPham] ([MaAnh], [MaSanPham], [DuongDanAnh], [LaAnhChinh]) VALUES (16, 5, N'album_639042884893940309_b0efc.jpg', 0)
GO
INSERT [dbo].[AnhSanPham] ([MaAnh], [MaSanPham], [DuongDanAnh], [LaAnhChinh]) VALUES (17, 5, N'album_639042884893959831_47128.jpg', 0)
GO
INSERT [dbo].[AnhSanPham] ([MaAnh], [MaSanPham], [DuongDanAnh], [LaAnhChinh]) VALUES (18, 5, N'album_639042886804670553_2b4c9.jpg', 0)
GO
INSERT [dbo].[AnhSanPham] ([MaAnh], [MaSanPham], [DuongDanAnh], [LaAnhChinh]) VALUES (19, 5, N'album_639042886804680097_6f873.jpg', 0)
GO
INSERT [dbo].[AnhSanPham] ([MaAnh], [MaSanPham], [DuongDanAnh], [LaAnhChinh]) VALUES (20, 5, N'album_639042886804680097_82729.jpg', 0)
GO
INSERT [dbo].[AnhSanPham] ([MaAnh], [MaSanPham], [DuongDanAnh], [LaAnhChinh]) VALUES (21, 4, N'album_639042888849715874_bf1e2.jpg', 0)
GO
INSERT [dbo].[AnhSanPham] ([MaAnh], [MaSanPham], [DuongDanAnh], [LaAnhChinh]) VALUES (22, 4, N'album_639042888849722842_57b18.jpg', 0)
GO
INSERT [dbo].[AnhSanPham] ([MaAnh], [MaSanPham], [DuongDanAnh], [LaAnhChinh]) VALUES (23, 4, N'album_639042888849730586_4639c.jpg', 0)
GO
INSERT [dbo].[AnhSanPham] ([MaAnh], [MaSanPham], [DuongDanAnh], [LaAnhChinh]) VALUES (24, 4, N'album_639042888849740600_f3d6e.jpg', 0)
GO
INSERT [dbo].[AnhSanPham] ([MaAnh], [MaSanPham], [DuongDanAnh], [LaAnhChinh]) VALUES (25, 4, N'album_639042888849751191_f9079.jpg', 0)
GO
INSERT [dbo].[AnhSanPham] ([MaAnh], [MaSanPham], [DuongDanAnh], [LaAnhChinh]) VALUES (29, 12, N'prod_639042905426219407.jpg', 1)
GO
INSERT [dbo].[AnhSanPham] ([MaAnh], [MaSanPham], [DuongDanAnh], [LaAnhChinh]) VALUES (30, 12, N'album_639042905426283114_9281c.jpg', 0)
GO
INSERT [dbo].[AnhSanPham] ([MaAnh], [MaSanPham], [DuongDanAnh], [LaAnhChinh]) VALUES (31, 12, N'album_639042905426283114_43d13.jpg', 0)
GO
INSERT [dbo].[AnhSanPham] ([MaAnh], [MaSanPham], [DuongDanAnh], [LaAnhChinh]) VALUES (32, 13, N'prod_639044908703670252.jpg', 1)
GO
INSERT [dbo].[AnhSanPham] ([MaAnh], [MaSanPham], [DuongDanAnh], [LaAnhChinh]) VALUES (33, 13, N'album_639044908703814107_48c77.jpg', 0)
GO
INSERT [dbo].[AnhSanPham] ([MaAnh], [MaSanPham], [DuongDanAnh], [LaAnhChinh]) VALUES (34, 14, N'prod_639044910020353635.jpg', 1)
GO
INSERT [dbo].[AnhSanPham] ([MaAnh], [MaSanPham], [DuongDanAnh], [LaAnhChinh]) VALUES (35, 14, N'album_639044910020386637_ccd6d.jpg', 0)
GO
INSERT [dbo].[AnhSanPham] ([MaAnh], [MaSanPham], [DuongDanAnh], [LaAnhChinh]) VALUES (36, 15, N'prod_639044914108900330.jpg', 1)
GO
INSERT [dbo].[AnhSanPham] ([MaAnh], [MaSanPham], [DuongDanAnh], [LaAnhChinh]) VALUES (37, 15, N'album_639044914108963174_43294.jpg', 0)
GO
INSERT [dbo].[AnhSanPham] ([MaAnh], [MaSanPham], [DuongDanAnh], [LaAnhChinh]) VALUES (38, 2, N'album_639044916173407321_2ec4b.jpg', 0)
GO
INSERT [dbo].[AnhSanPham] ([MaAnh], [MaSanPham], [DuongDanAnh], [LaAnhChinh]) VALUES (40, 2, N'album_639044916509177893_e72c4.jpg', 0)
GO
INSERT [dbo].[AnhSanPham] ([MaAnh], [MaSanPham], [DuongDanAnh], [LaAnhChinh]) VALUES (41, 16, N'prod_639044920495262930.jpg', 1)
GO
INSERT [dbo].[AnhSanPham] ([MaAnh], [MaSanPham], [DuongDanAnh], [LaAnhChinh]) VALUES (42, 16, N'album_639044920495302916_949f3.jpg', 0)
GO
INSERT [dbo].[AnhSanPham] ([MaAnh], [MaSanPham], [DuongDanAnh], [LaAnhChinh]) VALUES (43, 16, N'album_639044920495312941_3bb1a.jpg', 0)
GO
INSERT [dbo].[AnhSanPham] ([MaAnh], [MaSanPham], [DuongDanAnh], [LaAnhChinh]) VALUES (44, 17, N'prod_639044935174747466.jpg', 1)
GO
INSERT [dbo].[AnhSanPham] ([MaAnh], [MaSanPham], [DuongDanAnh], [LaAnhChinh]) VALUES (45, 17, N'album_639044935174799495_5aa3f.jpg', 0)
GO
INSERT [dbo].[AnhSanPham] ([MaAnh], [MaSanPham], [DuongDanAnh], [LaAnhChinh]) VALUES (46, 18, N'prod_639046377994620557.jpg', 1)
GO
INSERT [dbo].[AnhSanPham] ([MaAnh], [MaSanPham], [DuongDanAnh], [LaAnhChinh]) VALUES (47, 18, N'album_639046377994689223_06e56.jpg', 0)
GO
INSERT [dbo].[AnhSanPham] ([MaAnh], [MaSanPham], [DuongDanAnh], [LaAnhChinh]) VALUES (48, 18, N'album_639046377994700598_91cc6.jpg', 0)
GO
INSERT [dbo].[AnhSanPham] ([MaAnh], [MaSanPham], [DuongDanAnh], [LaAnhChinh]) VALUES (49, 19, N'prod_639048616519721768.jpg', 1)
GO
INSERT [dbo].[AnhSanPham] ([MaAnh], [MaSanPham], [DuongDanAnh], [LaAnhChinh]) VALUES (50, 19, N'album_639048618011386292_2ba9b.jpg', 0)
GO
INSERT [dbo].[AnhSanPham] ([MaAnh], [MaSanPham], [DuongDanAnh], [LaAnhChinh]) VALUES (51, 19, N'album_639048618011408980_acfff.jpg', 0)
GO
SET IDENTITY_INSERT [dbo].[AnhSanPham] OFF
GO
SET IDENTITY_INSERT [dbo].[BienTheSanPham] ON 
GO
INSERT [dbo].[BienTheSanPham] ([MaBienThe], [MaSanPham], [TenBienThe], [GiaBan], [SoLuongTon], [SKU]) VALUES (1, 1, N'Tiêu chuẩn', CAST(899000.00 AS Decimal(18, 2)), 0, N'LEGO-CLA-01')
GO
INSERT [dbo].[BienTheSanPham] ([MaBienThe], [MaSanPham], [TenBienThe], [GiaBan], [SoLuongTon], [SKU]) VALUES (2, 2, N'Bác sĩ', CAST(439000.00 AS Decimal(18, 2)), 29, N'BARB-DOC-02')
GO
INSERT [dbo].[BienTheSanPham] ([MaBienThe], [MaSanPham], [TenBienThe], [GiaBan], [SoLuongTon], [SKU]) VALUES (3, 2, N'Đầu bếp', CAST(439000.00 AS Decimal(18, 2)), 29, N'BARB-CHEF-03')
GO
INSERT [dbo].[BienTheSanPham] ([MaBienThe], [MaSanPham], [TenBienThe], [GiaBan], [SoLuongTon], [SKU]) VALUES (4, 3, N'Màu Đỏ', CAST(250000.00 AS Decimal(18, 2)), 12, N'HW-RED-04')
GO
INSERT [dbo].[BienTheSanPham] ([MaBienThe], [MaSanPham], [TenBienThe], [GiaBan], [SoLuongTon], [SKU]) VALUES (5, 4, N'Tiêu chuẩn', CAST(590000.00 AS Decimal(18, 2)), 12, N'LEGO-CIT-05')
GO
INSERT [dbo].[BienTheSanPham] ([MaBienThe], [MaSanPham], [TenBienThe], [GiaBan], [SoLuongTon], [SKU]) VALUES (6, 5, N'Tiêu chuẩn', CAST(419000.00 AS Decimal(18, 2)), 989, NULL)
GO
INSERT [dbo].[BienTheSanPham] ([MaBienThe], [MaSanPham], [TenBienThe], [GiaBan], [SoLuongTon], [SKU]) VALUES (13, 12, N'Tiêu chuẩn', CAST(469555.00 AS Decimal(18, 2)), 63, NULL)
GO
INSERT [dbo].[BienTheSanPham] ([MaBienThe], [MaSanPham], [TenBienThe], [GiaBan], [SoLuongTon], [SKU]) VALUES (14, 13, N'Tiêu chuẩn', CAST(118000.00 AS Decimal(18, 2)), 337, NULL)
GO
INSERT [dbo].[BienTheSanPham] ([MaBienThe], [MaSanPham], [TenBienThe], [GiaBan], [SoLuongTon], [SKU]) VALUES (15, 14, N'Tiêu chuẩn', CAST(279000.00 AS Decimal(18, 2)), 212, NULL)
GO
INSERT [dbo].[BienTheSanPham] ([MaBienThe], [MaSanPham], [TenBienThe], [GiaBan], [SoLuongTon], [SKU]) VALUES (16, 15, N'Tiêu chuẩn', CAST(1149000.00 AS Decimal(18, 2)), 198, NULL)
GO
INSERT [dbo].[BienTheSanPham] ([MaBienThe], [MaSanPham], [TenBienThe], [GiaBan], [SoLuongTon], [SKU]) VALUES (17, 16, N'Tiêu chuẩn', CAST(7099000.00 AS Decimal(18, 2)), 78, NULL)
GO
INSERT [dbo].[BienTheSanPham] ([MaBienThe], [MaSanPham], [TenBienThe], [GiaBan], [SoLuongTon], [SKU]) VALUES (18, 17, N'Tiêu chuẩn', CAST(44000.00 AS Decimal(18, 2)), 165, NULL)
GO
INSERT [dbo].[BienTheSanPham] ([MaBienThe], [MaSanPham], [TenBienThe], [GiaBan], [SoLuongTon], [SKU]) VALUES (19, 18, N'Tiêu chuẩn', CAST(3005000.00 AS Decimal(18, 2)), 83, NULL)
GO
INSERT [dbo].[BienTheSanPham] ([MaBienThe], [MaSanPham], [TenBienThe], [GiaBan], [SoLuongTon], [SKU]) VALUES (20, 19, N'Tiêu chuẩn', CAST(639000.00 AS Decimal(18, 2)), 54, NULL)
GO
SET IDENTITY_INSERT [dbo].[BienTheSanPham] OFF
GO
INSERT [dbo].[ChiTietDonHang] ([MaDonHang], [MaBienThe], [SoLuong], [GiaTaiThoiDiemBan]) VALUES (1, 4, 100, CAST(250000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[ChiTietDonHang] ([MaDonHang], [MaBienThe], [SoLuong], [GiaTaiThoiDiemBan]) VALUES (2, 1, 49, CAST(899000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[ChiTietDonHang] ([MaDonHang], [MaBienThe], [SoLuong], [GiaTaiThoiDiemBan]) VALUES (2, 2, 23, CAST(450000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[ChiTietDonHang] ([MaDonHang], [MaBienThe], [SoLuong], [GiaTaiThoiDiemBan]) VALUES (3, 13, 1, CAST(469555.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[ChiTietDonHang] ([MaDonHang], [MaBienThe], [SoLuong], [GiaTaiThoiDiemBan]) VALUES (4, 1, 1, CAST(899000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[ChiTietDonHang] ([MaDonHang], [MaBienThe], [SoLuong], [GiaTaiThoiDiemBan]) VALUES (4, 2, 1, CAST(450000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[ChiTietDonHang] ([MaDonHang], [MaBienThe], [SoLuong], [GiaTaiThoiDiemBan]) VALUES (5, 20, 1, CAST(639000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[ChiTietDonHang] ([MaDonHang], [MaBienThe], [SoLuong], [GiaTaiThoiDiemBan]) VALUES (6, 19, 2, CAST(3005000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[ChiTietDonHang] ([MaDonHang], [MaBienThe], [SoLuong], [GiaTaiThoiDiemBan]) VALUES (7, 5, 2, CAST(590000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[ChiTietDonHang] ([MaDonHang], [MaBienThe], [SoLuong], [GiaTaiThoiDiemBan]) VALUES (8, 19, 3, CAST(3005000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[ChiTietDonHang] ([MaDonHang], [MaBienThe], [SoLuong], [GiaTaiThoiDiemBan]) VALUES (9, 14, 3, CAST(118000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[ChiTietDonHang] ([MaDonHang], [MaBienThe], [SoLuong], [GiaTaiThoiDiemBan]) VALUES (10, 18, 1, CAST(44000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[ChiTietDonHang] ([MaDonHang], [MaBienThe], [SoLuong], [GiaTaiThoiDiemBan]) VALUES (11, 18, 1, CAST(44000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[ChiTietDonHang] ([MaDonHang], [MaBienThe], [SoLuong], [GiaTaiThoiDiemBan]) VALUES (12, 20, 1, CAST(639000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[ChiTietDonHang] ([MaDonHang], [MaBienThe], [SoLuong], [GiaTaiThoiDiemBan]) VALUES (13, 18, 1, CAST(44000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[ChiTietDonHang] ([MaDonHang], [MaBienThe], [SoLuong], [GiaTaiThoiDiemBan]) VALUES (14, 18, 1, CAST(44000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[ChiTietDonHang] ([MaDonHang], [MaBienThe], [SoLuong], [GiaTaiThoiDiemBan]) VALUES (15, 18, 1, CAST(44000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[ChiTietDonHang] ([MaDonHang], [MaBienThe], [SoLuong], [GiaTaiThoiDiemBan]) VALUES (16, 17, 1, CAST(7099000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[ChiTietDonHang] ([MaDonHang], [MaBienThe], [SoLuong], [GiaTaiThoiDiemBan]) VALUES (17, 19, 1, CAST(3005000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[ChiTietDonHang] ([MaDonHang], [MaBienThe], [SoLuong], [GiaTaiThoiDiemBan]) VALUES (18, 13, 1, CAST(469555.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[ChiTietDonHang] ([MaDonHang], [MaBienThe], [SoLuong], [GiaTaiThoiDiemBan]) VALUES (19, 18, 2, CAST(44000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[ChiTietDonHang] ([MaDonHang], [MaBienThe], [SoLuong], [GiaTaiThoiDiemBan]) VALUES (20, 18, 2, CAST(44000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[ChiTietDonHang] ([MaDonHang], [MaBienThe], [SoLuong], [GiaTaiThoiDiemBan]) VALUES (21, 20, 1, CAST(639000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[ChiTietDonHang] ([MaDonHang], [MaBienThe], [SoLuong], [GiaTaiThoiDiemBan]) VALUES (22, 5, 1, CAST(590000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[ChiTietDonHang] ([MaDonHang], [MaBienThe], [SoLuong], [GiaTaiThoiDiemBan]) VALUES (23, 18, 1, CAST(44000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[ChiTietDonHang] ([MaDonHang], [MaBienThe], [SoLuong], [GiaTaiThoiDiemBan]) VALUES (24, 18, 1, CAST(44000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[ChiTietDonHang] ([MaDonHang], [MaBienThe], [SoLuong], [GiaTaiThoiDiemBan]) VALUES (25, 18, 1, CAST(44000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[ChiTietDonHang] ([MaDonHang], [MaBienThe], [SoLuong], [GiaTaiThoiDiemBan]) VALUES (26, 20, 1, CAST(639000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[ChiTietDonHang] ([MaDonHang], [MaBienThe], [SoLuong], [GiaTaiThoiDiemBan]) VALUES (27, 20, 1, CAST(639000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[ChiTietDonHang] ([MaDonHang], [MaBienThe], [SoLuong], [GiaTaiThoiDiemBan]) VALUES (28, 19, 1, CAST(3005000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[ChiTietDonHang] ([MaDonHang], [MaBienThe], [SoLuong], [GiaTaiThoiDiemBan]) VALUES (29, 20, 1, CAST(639000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[ChiTietDonHang] ([MaDonHang], [MaBienThe], [SoLuong], [GiaTaiThoiDiemBan]) VALUES (30, 20, 1, CAST(639000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[ChiTietDonHang] ([MaDonHang], [MaBienThe], [SoLuong], [GiaTaiThoiDiemBan]) VALUES (31, 18, 1, CAST(44000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[ChiTietDonHang] ([MaDonHang], [MaBienThe], [SoLuong], [GiaTaiThoiDiemBan]) VALUES (32, 20, 1, CAST(639000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[ChiTietDonHang] ([MaDonHang], [MaBienThe], [SoLuong], [GiaTaiThoiDiemBan]) VALUES (33, 20, 1, CAST(639000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[ChiTietDonHang] ([MaDonHang], [MaBienThe], [SoLuong], [GiaTaiThoiDiemBan]) VALUES (34, 20, 1, CAST(639000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[ChiTietDonHang] ([MaDonHang], [MaBienThe], [SoLuong], [GiaTaiThoiDiemBan]) VALUES (35, 19, 1, CAST(3005000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[ChiTietDonHang] ([MaDonHang], [MaBienThe], [SoLuong], [GiaTaiThoiDiemBan]) VALUES (36, 19, 1, CAST(3005000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[ChiTietDonHang] ([MaDonHang], [MaBienThe], [SoLuong], [GiaTaiThoiDiemBan]) VALUES (37, 20, 1, CAST(639000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[ChiTietDonHang] ([MaDonHang], [MaBienThe], [SoLuong], [GiaTaiThoiDiemBan]) VALUES (40, 19, 2, CAST(3005000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[ChiTietDonHang] ([MaDonHang], [MaBienThe], [SoLuong], [GiaTaiThoiDiemBan]) VALUES (41, 19, 1, CAST(3005000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[ChiTietDonHang] ([MaDonHang], [MaBienThe], [SoLuong], [GiaTaiThoiDiemBan]) VALUES (42, 19, 1, CAST(3005000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[ChiTietDonHang] ([MaDonHang], [MaBienThe], [SoLuong], [GiaTaiThoiDiemBan]) VALUES (43, 20, 1, CAST(639000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[ChiTietDonHang] ([MaDonHang], [MaBienThe], [SoLuong], [GiaTaiThoiDiemBan]) VALUES (44, 19, 2, CAST(3005000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[ChiTietDonHang] ([MaDonHang], [MaBienThe], [SoLuong], [GiaTaiThoiDiemBan]) VALUES (45, 20, 3, CAST(639000.00 AS Decimal(18, 2)))
GO
SET IDENTITY_INSERT [dbo].[DanhGia] ON 
GO
INSERT [dbo].[DanhGia] ([MaDanhGia], [MaSanPham], [MaKhachHang], [SoSao], [NoiDung], [NgayGui]) VALUES (1, 19, 2, 5, N'good!!!', CAST(N'2026-01-24T16:26:17.370' AS DateTime))
GO
INSERT [dbo].[DanhGia] ([MaDanhGia], [MaSanPham], [MaKhachHang], [SoSao], [NoiDung], [NgayGui]) VALUES (2, 19, 2, 3, N'hi', CAST(N'2026-01-24T16:30:30.533' AS DateTime))
GO
INSERT [dbo].[DanhGia] ([MaDanhGia], [MaSanPham], [MaKhachHang], [SoSao], [NoiDung], [NgayGui]) VALUES (3, 19, 2, 4, N'hay đấy', CAST(N'2026-01-24T16:43:19.520' AS DateTime))
GO
INSERT [dbo].[DanhGia] ([MaDanhGia], [MaSanPham], [MaKhachHang], [SoSao], [NoiDung], [NgayGui]) VALUES (4, 18, 8, 4, N'Good!', CAST(N'2026-01-24T22:34:01.780' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[DanhGia] OFF
GO
SET IDENTITY_INSERT [dbo].[DonHang] ON 
GO
INSERT [dbo].[DonHang] ([MaDonHang], [MaKhachHang], [NgayDat], [TongTien], [TrangThaiDonHang], [DiaChiGiaoHang]) VALUES (1, 2, CAST(N'2026-01-17T16:27:27.097' AS DateTime), CAST(25000000.00 AS Decimal(18, 2)), N'Mới', N'135 đường số 11')
GO
INSERT [dbo].[DonHang] ([MaDonHang], [MaKhachHang], [NgayDat], [TongTien], [TrangThaiDonHang], [DiaChiGiaoHang]) VALUES (2, 3, CAST(N'2026-01-17T16:37:56.850' AS DateTime), CAST(54401000.00 AS Decimal(18, 2)), N'Mới', N'456 LÝ THƯỜNG KIỆT')
GO
INSERT [dbo].[DonHang] ([MaDonHang], [MaKhachHang], [NgayDat], [TongTien], [TrangThaiDonHang], [DiaChiGiaoHang]) VALUES (3, 5, CAST(N'2026-01-19T00:25:11.483' AS DateTime), CAST(469555.00 AS Decimal(18, 2)), N'Mới', N'333 phố Lưu Giang')
GO
INSERT [dbo].[DonHang] ([MaDonHang], [MaKhachHang], [NgayDat], [TongTien], [TrangThaiDonHang], [DiaChiGiaoHang]) VALUES (4, 2, CAST(N'2026-01-19T00:34:37.427' AS DateTime), CAST(1349000.00 AS Decimal(18, 2)), N'Hoàn tất', N'135 đường số 11')
GO
INSERT [dbo].[DonHang] ([MaDonHang], [MaKhachHang], [NgayDat], [TongTien], [TrangThaiDonHang], [DiaChiGiaoHang]) VALUES (5, 2, CAST(N'2026-01-24T16:25:47.413' AS DateTime), CAST(639000.00 AS Decimal(18, 2)), N'Hoàn tất', N'135 đường số 11')
GO
INSERT [dbo].[DonHang] ([MaDonHang], [MaKhachHang], [NgayDat], [TongTien], [TrangThaiDonHang], [DiaChiGiaoHang]) VALUES (6, 6, CAST(N'2026-01-24T17:12:36.730' AS DateTime), CAST(6010000.00 AS Decimal(18, 2)), N'Mới', N'135 đường số 11')
GO
INSERT [dbo].[DonHang] ([MaDonHang], [MaKhachHang], [NgayDat], [TongTien], [TrangThaiDonHang], [DiaChiGiaoHang]) VALUES (7, 7, CAST(N'2026-01-24T21:22:39.810' AS DateTime), CAST(1180000.00 AS Decimal(18, 2)), N'Hoàn tất', N'323 Lý Thường Kiệt')
GO
INSERT [dbo].[DonHang] ([MaDonHang], [MaKhachHang], [NgayDat], [TongTien], [TrangThaiDonHang], [DiaChiGiaoHang]) VALUES (8, 8, CAST(N'2026-01-24T21:30:30.073' AS DateTime), CAST(9015000.00 AS Decimal(18, 2)), N'Hoàn tất', N'252 Lý Chính Thắng')
GO
INSERT [dbo].[DonHang] ([MaDonHang], [MaKhachHang], [NgayDat], [TongTien], [TrangThaiDonHang], [DiaChiGiaoHang]) VALUES (9, 6, CAST(N'2026-01-24T21:44:19.110' AS DateTime), CAST(354000.00 AS Decimal(18, 2)), N'Hoàn tất', N'135 đường số 11')
GO
INSERT [dbo].[DonHang] ([MaDonHang], [MaKhachHang], [NgayDat], [TongTien], [TrangThaiDonHang], [DiaChiGiaoHang]) VALUES (10, 6, CAST(N'2026-01-24T23:16:40.400' AS DateTime), CAST(44000.00 AS Decimal(18, 2)), N'Chờ thanh toán', N'135 đường số 11')
GO
INSERT [dbo].[DonHang] ([MaDonHang], [MaKhachHang], [NgayDat], [TongTien], [TrangThaiDonHang], [DiaChiGiaoHang]) VALUES (11, 6, CAST(N'2026-01-24T23:17:15.837' AS DateTime), CAST(44000.00 AS Decimal(18, 2)), N'Chờ thanh toán', N'135 đường số 11')
GO
INSERT [dbo].[DonHang] ([MaDonHang], [MaKhachHang], [NgayDat], [TongTien], [TrangThaiDonHang], [DiaChiGiaoHang]) VALUES (12, 6, CAST(N'2026-01-24T23:23:52.567' AS DateTime), CAST(639000.00 AS Decimal(18, 2)), N'Chờ thanh toán', N'135 đường số 11')
GO
INSERT [dbo].[DonHang] ([MaDonHang], [MaKhachHang], [NgayDat], [TongTien], [TrangThaiDonHang], [DiaChiGiaoHang]) VALUES (13, 6, CAST(N'2026-01-24T23:32:34.953' AS DateTime), CAST(44000.00 AS Decimal(18, 2)), N'Chờ thanh toán', N'135 đường số 11')
GO
INSERT [dbo].[DonHang] ([MaDonHang], [MaKhachHang], [NgayDat], [TongTien], [TrangThaiDonHang], [DiaChiGiaoHang]) VALUES (14, 6, CAST(N'2026-01-24T23:34:39.760' AS DateTime), CAST(44000.00 AS Decimal(18, 2)), N'Chờ thanh toán', N'135 đường số 11')
GO
INSERT [dbo].[DonHang] ([MaDonHang], [MaKhachHang], [NgayDat], [TongTien], [TrangThaiDonHang], [DiaChiGiaoHang]) VALUES (15, 6, CAST(N'2026-01-24T23:37:30.433' AS DateTime), CAST(44000.00 AS Decimal(18, 2)), N'Chờ thanh toán', N'135 đường số 11')
GO
INSERT [dbo].[DonHang] ([MaDonHang], [MaKhachHang], [NgayDat], [TongTien], [TrangThaiDonHang], [DiaChiGiaoHang]) VALUES (16, 6, CAST(N'2026-01-25T00:09:52.230' AS DateTime), CAST(7099000.00 AS Decimal(18, 2)), N'Chờ thanh toán', N'135 đường số 11')
GO
INSERT [dbo].[DonHang] ([MaDonHang], [MaKhachHang], [NgayDat], [TongTien], [TrangThaiDonHang], [DiaChiGiaoHang]) VALUES (17, 6, CAST(N'2026-01-25T00:14:38.850' AS DateTime), CAST(3005000.00 AS Decimal(18, 2)), N'Mới', N'135 đường số 11')
GO
INSERT [dbo].[DonHang] ([MaDonHang], [MaKhachHang], [NgayDat], [TongTien], [TrangThaiDonHang], [DiaChiGiaoHang]) VALUES (18, 6, CAST(N'2026-01-25T00:14:56.277' AS DateTime), CAST(469555.00 AS Decimal(18, 2)), N'Chờ thanh toán', N'135 đường số 11')
GO
INSERT [dbo].[DonHang] ([MaDonHang], [MaKhachHang], [NgayDat], [TongTien], [TrangThaiDonHang], [DiaChiGiaoHang]) VALUES (19, 6, CAST(N'2026-01-25T00:20:17.960' AS DateTime), CAST(88000.00 AS Decimal(18, 2)), N'Chờ thanh toán', N'135 đường số 11')
GO
INSERT [dbo].[DonHang] ([MaDonHang], [MaKhachHang], [NgayDat], [TongTien], [TrangThaiDonHang], [DiaChiGiaoHang]) VALUES (20, 6, CAST(N'2026-01-25T00:20:41.510' AS DateTime), CAST(88000.00 AS Decimal(18, 2)), N'Chờ thanh toán', N'135 đường số 11')
GO
INSERT [dbo].[DonHang] ([MaDonHang], [MaKhachHang], [NgayDat], [TongTien], [TrangThaiDonHang], [DiaChiGiaoHang]) VALUES (21, 6, CAST(N'2026-01-25T00:24:15.630' AS DateTime), CAST(639000.00 AS Decimal(18, 2)), N'Chờ thanh toán', N'135 đường số 11')
GO
INSERT [dbo].[DonHang] ([MaDonHang], [MaKhachHang], [NgayDat], [TongTien], [TrangThaiDonHang], [DiaChiGiaoHang]) VALUES (22, 6, CAST(N'2026-01-25T00:38:34.123' AS DateTime), CAST(590000.00 AS Decimal(18, 2)), N'Chờ thanh toán', N'135 đường số 11')
GO
INSERT [dbo].[DonHang] ([MaDonHang], [MaKhachHang], [NgayDat], [TongTien], [TrangThaiDonHang], [DiaChiGiaoHang]) VALUES (23, 6, CAST(N'2026-01-25T00:41:23.433' AS DateTime), CAST(44000.00 AS Decimal(18, 2)), N'Chờ thanh toán', N'135 đường số 11')
GO
INSERT [dbo].[DonHang] ([MaDonHang], [MaKhachHang], [NgayDat], [TongTien], [TrangThaiDonHang], [DiaChiGiaoHang]) VALUES (24, 6, CAST(N'2026-01-25T00:43:21.900' AS DateTime), CAST(44000.00 AS Decimal(18, 2)), N'Chờ thanh toán', N'135 đường số 11')
GO
INSERT [dbo].[DonHang] ([MaDonHang], [MaKhachHang], [NgayDat], [TongTien], [TrangThaiDonHang], [DiaChiGiaoHang]) VALUES (25, 6, CAST(N'2026-01-25T00:44:28.760' AS DateTime), CAST(44000.00 AS Decimal(18, 2)), N'Chờ thanh toán', N'135 đường số 11')
GO
INSERT [dbo].[DonHang] ([MaDonHang], [MaKhachHang], [NgayDat], [TongTien], [TrangThaiDonHang], [DiaChiGiaoHang]) VALUES (26, 6, CAST(N'2026-01-25T01:00:19.537' AS DateTime), CAST(639000.00 AS Decimal(18, 2)), N'Chờ thanh toán', N'135 đường số 11')
GO
INSERT [dbo].[DonHang] ([MaDonHang], [MaKhachHang], [NgayDat], [TongTien], [TrangThaiDonHang], [DiaChiGiaoHang]) VALUES (27, 6, CAST(N'2026-01-25T01:00:46.100' AS DateTime), CAST(639000.00 AS Decimal(18, 2)), N'Chờ thanh toán', N'135 đường số 11')
GO
INSERT [dbo].[DonHang] ([MaDonHang], [MaKhachHang], [NgayDat], [TongTien], [TrangThaiDonHang], [DiaChiGiaoHang]) VALUES (28, 6, CAST(N'2026-01-25T01:02:34.593' AS DateTime), CAST(3005000.00 AS Decimal(18, 2)), N'Chờ thanh toán', N'135 đường số 11')
GO
INSERT [dbo].[DonHang] ([MaDonHang], [MaKhachHang], [NgayDat], [TongTien], [TrangThaiDonHang], [DiaChiGiaoHang]) VALUES (29, 6, CAST(N'2026-01-25T01:10:21.333' AS DateTime), CAST(639000.00 AS Decimal(18, 2)), N'Chờ thanh toán', N'135 đường số 11')
GO
INSERT [dbo].[DonHang] ([MaDonHang], [MaKhachHang], [NgayDat], [TongTien], [TrangThaiDonHang], [DiaChiGiaoHang]) VALUES (30, 6, CAST(N'2026-01-25T01:12:50.250' AS DateTime), CAST(639000.00 AS Decimal(18, 2)), N'Chờ thanh toán', N'135 đường số 11')
GO
INSERT [dbo].[DonHang] ([MaDonHang], [MaKhachHang], [NgayDat], [TongTien], [TrangThaiDonHang], [DiaChiGiaoHang]) VALUES (31, 6, CAST(N'2026-01-25T01:14:49.563' AS DateTime), CAST(44000.00 AS Decimal(18, 2)), N'Chờ thanh toán', N'135 đường số 11')
GO
INSERT [dbo].[DonHang] ([MaDonHang], [MaKhachHang], [NgayDat], [TongTien], [TrangThaiDonHang], [DiaChiGiaoHang]) VALUES (32, 6, CAST(N'2026-01-25T01:15:25.360' AS DateTime), CAST(639000.00 AS Decimal(18, 2)), N'Chờ thanh toán', N'135 đường số 11')
GO
INSERT [dbo].[DonHang] ([MaDonHang], [MaKhachHang], [NgayDat], [TongTien], [TrangThaiDonHang], [DiaChiGiaoHang]) VALUES (33, 6, CAST(N'2026-01-25T01:23:19.983' AS DateTime), CAST(639000.00 AS Decimal(18, 2)), N'Chờ thanh toán', N'135 đường số 11')
GO
INSERT [dbo].[DonHang] ([MaDonHang], [MaKhachHang], [NgayDat], [TongTien], [TrangThaiDonHang], [DiaChiGiaoHang]) VALUES (34, 6, CAST(N'2026-01-25T01:31:13.097' AS DateTime), CAST(639000.00 AS Decimal(18, 2)), N'Chờ thanh toán', N'135 đường số 11')
GO
INSERT [dbo].[DonHang] ([MaDonHang], [MaKhachHang], [NgayDat], [TongTien], [TrangThaiDonHang], [DiaChiGiaoHang]) VALUES (35, 6, CAST(N'2026-01-25T01:32:54.547' AS DateTime), CAST(3005000.00 AS Decimal(18, 2)), N'Chờ thanh toán', N'135 đường số 11')
GO
INSERT [dbo].[DonHang] ([MaDonHang], [MaKhachHang], [NgayDat], [TongTien], [TrangThaiDonHang], [DiaChiGiaoHang]) VALUES (36, 6, CAST(N'2026-02-08T20:30:12.940' AS DateTime), CAST(3005000.00 AS Decimal(18, 2)), N'Chờ thanh toán', N'135 đường số 11')
GO
INSERT [dbo].[DonHang] ([MaDonHang], [MaKhachHang], [NgayDat], [TongTien], [TrangThaiDonHang], [DiaChiGiaoHang]) VALUES (37, 6, CAST(N'2026-02-08T20:41:15.507' AS DateTime), CAST(639000.00 AS Decimal(18, 2)), N'Chờ thanh toán', N'135 đường số 11')
GO
INSERT [dbo].[DonHang] ([MaDonHang], [MaKhachHang], [NgayDat], [TongTien], [TrangThaiDonHang], [DiaChiGiaoHang]) VALUES (40, 6, CAST(N'2026-02-08T21:20:51.610' AS DateTime), CAST(6010000.00 AS Decimal(18, 2)), N'Chờ thanh toán', N'135 đường số 11')
GO
INSERT [dbo].[DonHang] ([MaDonHang], [MaKhachHang], [NgayDat], [TongTien], [TrangThaiDonHang], [DiaChiGiaoHang]) VALUES (41, 6, CAST(N'2026-02-08T21:36:05.390' AS DateTime), CAST(3005000.00 AS Decimal(18, 2)), N'Chờ thanh toán', N'135 đường số 11')
GO
INSERT [dbo].[DonHang] ([MaDonHang], [MaKhachHang], [NgayDat], [TongTien], [TrangThaiDonHang], [DiaChiGiaoHang]) VALUES (42, 6, CAST(N'2026-02-08T22:02:17.707' AS DateTime), CAST(3005000.00 AS Decimal(18, 2)), N'Chờ thanh toán', N'135 đường số 11')
GO
INSERT [dbo].[DonHang] ([MaDonHang], [MaKhachHang], [NgayDat], [TongTien], [TrangThaiDonHang], [DiaChiGiaoHang]) VALUES (43, 6, CAST(N'2026-02-26T16:33:11.860' AS DateTime), CAST(639000.00 AS Decimal(18, 2)), N'Hoàn tất', N'135 đường số 11')
GO
INSERT [dbo].[DonHang] ([MaDonHang], [MaKhachHang], [NgayDat], [TongTien], [TrangThaiDonHang], [DiaChiGiaoHang]) VALUES (44, 2, CAST(N'2026-03-03T07:32:28.550' AS DateTime), CAST(6010000.00 AS Decimal(18, 2)), N'Mới', N'135 đường số 11')
GO
INSERT [dbo].[DonHang] ([MaDonHang], [MaKhachHang], [NgayDat], [TongTien], [TrangThaiDonHang], [DiaChiGiaoHang]) VALUES (45, 6, CAST(N'2026-03-03T07:32:57.927' AS DateTime), CAST(1917000.00 AS Decimal(18, 2)), N'Hoàn tất', N'135 đường số 11')
GO
SET IDENTITY_INSERT [dbo].[DonHang] OFF
GO
SET IDENTITY_INSERT [dbo].[DoTuoi] ON 
GO
INSERT [dbo].[DoTuoi] ([MaDoTuoi], [KhoangDoTuoi]) VALUES (1, N'0 - 12 tháng')
GO
INSERT [dbo].[DoTuoi] ([MaDoTuoi], [KhoangDoTuoi]) VALUES (2, N'1 - 3 tuổi')
GO
INSERT [dbo].[DoTuoi] ([MaDoTuoi], [KhoangDoTuoi]) VALUES (3, N'3 - 6 tuổi')
GO
INSERT [dbo].[DoTuoi] ([MaDoTuoi], [KhoangDoTuoi]) VALUES (4, N'6 - 12 tuổi')
GO
INSERT [dbo].[DoTuoi] ([MaDoTuoi], [KhoangDoTuoi]) VALUES (5, N'Trên 12 tuổi')
GO
SET IDENTITY_INSERT [dbo].[DoTuoi] OFF
GO
SET IDENTITY_INSERT [dbo].[KhachHang] ON 
GO
INSERT [dbo].[KhachHang] ([MaKhachHang], [HoTen], [Email], [SoDienThoai], [DiaChi], [MatKhau], [NgayDangKy], [VaiTro], [TrangThai]) VALUES (1, N'Nguyễn Văn A', N'customer1@gmail.com', N'0901234567', N'123 Lê Lợi, TP.HCM', N'123456', CAST(N'2026-01-12T17:10:50.363' AS DateTime), N'KhachHang', 0)
GO
INSERT [dbo].[KhachHang] ([MaKhachHang], [HoTen], [Email], [SoDienThoai], [DiaChi], [MatKhau], [NgayDangKy], [VaiTro], [TrangThai]) VALUES (2, N'Tuấn Anh Đẹp Troai', N'anh@gmail.com', N'0864631563', N'135 đường số 11', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', CAST(N'2026-01-13T00:26:18.950' AS DateTime), N'KhachHang', 1)
GO
INSERT [dbo].[KhachHang] ([MaKhachHang], [HoTen], [Email], [SoDienThoai], [DiaChi], [MatKhau], [NgayDangKy], [VaiTro], [TrangThai]) VALUES (3, N'Minh Quân', N'quan@gmail.com', N'0111111111', N'456 LÝ THƯỜNG KIỆT', N'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', CAST(N'2026-01-17T16:13:27.247' AS DateTime), N'KhachHang', 1)
GO
INSERT [dbo].[KhachHang] ([MaKhachHang], [HoTen], [Email], [SoDienThoai], [DiaChi], [MatKhau], [NgayDangKy], [VaiTro], [TrangThai]) VALUES (4, N'Admin', N'admin@gmail.com', N'0999999999', N'999 DC', N'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', CAST(N'2026-01-17T16:47:33.170' AS DateTime), N'Admin', 1)
GO
INSERT [dbo].[KhachHang] ([MaKhachHang], [HoTen], [Email], [SoDienThoai], [DiaChi], [MatKhau], [NgayDangKy], [VaiTro], [TrangThai]) VALUES (5, N'Hỏa Vân Tà Thần', N'hoavan@gmail.com', N'05487648', N'333 phố Lưu Giang', N'GuestOrder', CAST(N'2026-01-19T00:25:11.480' AS DateTime), N'KhachHang', 1)
GO
INSERT [dbo].[KhachHang] ([MaKhachHang], [HoTen], [Email], [SoDienThoai], [DiaChi], [MatKhau], [NgayDangKy], [VaiTro], [TrangThai]) VALUES (6, N'Trần Tuấn Anh', N'tuananhtranshjn@gmail.com', N'0975213557', N'135 đường số 11', N'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', CAST(N'2026-01-24T17:12:18.737' AS DateTime), N'KhachHang', 1)
GO
INSERT [dbo].[KhachHang] ([MaKhachHang], [HoTen], [Email], [SoDienThoai], [DiaChi], [MatKhau], [NgayDangKy], [VaiTro], [TrangThai]) VALUES (7, N'Trần Tuấn Anh', N'anhboyazx5@gmail.com', N'0975213557', N'323 Lý Thường Kiệt', N'GuestOrder', CAST(N'2026-01-24T21:22:39.807' AS DateTime), N'KhachHang', 1)
GO
INSERT [dbo].[KhachHang] ([MaKhachHang], [HoTen], [Email], [SoDienThoai], [DiaChi], [MatKhau], [NgayDangKy], [VaiTro], [TrangThai]) VALUES (8, N'Tuấn Anh Đẹp Troai', N'anhboyazx54@gmail.com', N'0975213557', N'252 Lý Chính Thắng', N'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', CAST(N'2026-01-24T21:30:12.340' AS DateTime), N'KhachHang', 1)
GO
SET IDENTITY_INSERT [dbo].[KhachHang] OFF
GO
SET IDENTITY_INSERT [dbo].[NhomSanPham] ON 
GO
INSERT [dbo].[NhomSanPham] ([MaNhom], [TenNhom], [MoTa]) VALUES (1, N'Đồ chơi lắp ráp', N'Phát triển tư duy logic và sáng tạo')
GO
INSERT [dbo].[NhomSanPham] ([MaNhom], [TenNhom], [MoTa]) VALUES (2, N'Búp bê & Đồ chơi nhập vai', N'Dành cho các bé thích khám phá thế giới xung quanh')
GO
INSERT [dbo].[NhomSanPham] ([MaNhom], [TenNhom], [MoTa]) VALUES (3, N'Xe mô hình & Điều khiển', N'Các loại xe đua, xe công trình siêu ngầu')
GO
INSERT [dbo].[NhomSanPham] ([MaNhom], [TenNhom], [MoTa]) VALUES (4, N'Đồ chơi giáo dục', N'Học mà chơi, chơi mà học')
GO
SET IDENTITY_INSERT [dbo].[NhomSanPham] OFF
GO
SET IDENTITY_INSERT [dbo].[QuangCao] ON 
GO
INSERT [dbo].[QuangCao] ([MaQC], [TieuDe], [HinhAnh], [LienKet], [ThuTu], [HienThi]) VALUES (1, N'Back to School', N'banner1.jpg', N'ProductDetails.aspx?id=19', 1, 1)
GO
INSERT [dbo].[QuangCao] ([MaQC], [TieuDe], [HinhAnh], [LienKet], [ThuTu], [HienThi]) VALUES (2, N'Đồ chơi NinjaGo mới về', N'banner_639048609949074784.jpg', N'ProductDetails.aspx?id=10', 2, 1)
GO
INSERT [dbo].[QuangCao] ([MaQC], [TieuDe], [HinhAnh], [LienKet], [ThuTu], [HienThi]) VALUES (3, N' Tứ Bình Khai Lộc', N'banner_639046379434520077.jpg', N'ProductDetails.aspx?id=18', 3, 1)
GO
INSERT [dbo].[QuangCao] ([MaQC], [TieuDe], [HinhAnh], [LienKet], [ThuTu], [HienThi]) VALUES (4, N'Lego-city', N'banner_639048609593417633.jpg', N'ProductDetails.aspx?id=18', 4, 1)
GO
SET IDENTITY_INSERT [dbo].[QuangCao] OFF
GO
SET IDENTITY_INSERT [dbo].[SanPham] ON 
GO
INSERT [dbo].[SanPham] ([MaSanPham], [TenSanPham], [MaNhom], [MaThuongHieu], [MaDoTuoi], [MoTaChiTiet], [NgayTao], [TrangThai]) VALUES (1, N'LEGO Classic Thùng Gạch Trung Tâm', 1, 1, 3, N'<p>Bộ lắp r&aacute;p với 484 chi tiết nhiều m&agrave;u sắc gi&uacute;p b&eacute; thỏa sức s&aacute;ng tạo.</p>
', CAST(N'2026-01-12T17:10:50.360' AS DateTime), 1)
GO
INSERT [dbo].[SanPham] ([MaSanPham], [TenSanPham], [MaNhom], [MaThuongHieu], [MaDoTuoi], [MoTaChiTiet], [NgayTao], [TrangThai]) VALUES (2, N'ORI tập làm họa sĩ ORI 36347B-ORI', 2, 2, 3, N'Búp bê ORI tập làm họa sĩ 36347B-ORI là dòng búp bê cao cấp, mô phỏng nhân vật ORI trong phim hoạt hình Công Chúa Ori được nhiều bạn nhỏ yêu mến. Cùng ORI hóa thân thành một họa sĩ khéo léo và khám phá thêm nhiều điều thú vị của công việc này nhé. 

Búp bê Ori tập làm họa sĩ được yêu thích bởi những đặc điểm nổi bật sau:


Đồ chơi được làm từ chất liệu nhựa, không chứa BPA, an toàn sức khỏe của bé.
Trang phục đầu bếp đáng yêu, màu sắc các vật dụng bắt bắt, kích thích thị giác của trẻ.
Bộ đồ chơi còn đi kèm với nhiều phụ kiện khác nhau để bé thỏa sức tưởng tượng, chơi đùa với cô nàng búp bê Ori xinh đẹp. 
Các bé có thể sưu tập nhiều búp bê Ori để làm phong phú cho bộ sưu tập của mình.
Phụ kiện đi kèm mô phỏng các vật dụng trong nhà bếp, giúp bé nhận biết công dụng của từng loại.

Sản phẩm thích hợp cho các bé gái trên 1 tuổi.

Đồ chơi Ori tập làm họa sĩ 36347B-ORI gồm:


01 công chúa Ori cùng các phụ kiện đi kèm.


Vài nét về thương hiệu:


Ori Princess là thương hiệu đồ chơi búp bê nổi tiếng đang được các bé gái cực kì yêu thích. Lấy hình mẫu từ cô công chúa Ori xinh xắn, đáng yêu trong loạt phim hoạt hình ăn khách. Bộ sưu tập “Công chúa Ori” với đôi mắt tròn, khuôn mặt bầu bĩnh, có đủ kiểu trang phục từ đời thường cho đến phong cách sang trọng đã trở thành người bạn quen thuộc với các em nhỏ, cùng các em vui chơi và sẻ chia mọi cảm xúc.', CAST(N'2026-01-12T17:10:50.360' AS DateTime), 1)
GO
INSERT [dbo].[SanPham] ([MaSanPham], [TenSanPham], [MaNhom], [MaThuongHieu], [MaDoTuoi], [MoTaChiTiet], [NgayTao], [TrangThai]) VALUES (3, N'Siêu xe Hot Wheels Monster Trucks', 3, 3, 3, N'<p>Xe địa h&igrave;nh b&aacute;nh lớn, khung gầm cực chắc chắn cho những trận đấu nảy lửa.</p>
', CAST(N'2026-01-12T17:10:50.360' AS DateTime), 1)
GO
INSERT [dbo].[SanPham] ([MaSanPham], [TenSanPham], [MaNhom], [MaThuongHieu], [MaDoTuoi], [MoTaChiTiet], [NgayTao], [TrangThai]) VALUES (4, N'LEGO City Cảnh Sát Bắt Cướp', 1, 1, 4, N'<p>Đồ Chơi Lắp R&aacute;p M&aacute;y Bay Chở H&agrave;nh Kh&aacute;ch LEGO CITY 60367 (913 chi tiết) M&aacute;y bay chở h&agrave;nh kh&aacute;ch LEGO&reg; City chuẩn bị khởi h&agrave;nh. Xe bu&yacute;t đang tr&ecirc;n đường đến v&agrave; đ&atilde; đến l&uacute;c khởi động cầu thang m&aacute;y bay để đưa h&agrave;nh kh&aacute;ch l&ecirc;n. Một chiếc xe tải phục vụ đang chất đồ ăn v&agrave; thức uống l&ecirc;n m&aacute;y bay, những người so&aacute;t h&agrave;nh l&yacute; đ&atilde; đến v&agrave; xe đẩy m&aacute;y bay đ&atilde; sẵn s&agrave;ng để đưa m&aacute;y bay ra ngo&agrave;i. Lối đi tr&ecirc;n t&agrave;u đ&atilde; th&ocirc;ng tho&aacute;ng, chỗ ngồi v&agrave; nh&agrave; vệ sinh sạch sẽ v&agrave; sẵn s&agrave;ng. Chuẩn bị cất c&aacute;nh! &bull; Đồ chơi lắp r&aacute;p M&aacute;y bay chở h&agrave;nh kh&aacute;ch &ndash; LEGO&reg; City Passenger Airplane (60367) với c&aacute;c chức năng v&agrave; chi tiết ch&acirc;n thực &bull; Điều bất ngờ g&igrave; đang chờ bạn trong hộp vậy? - Bộ đồ chơi n&agrave;y c&oacute; mọi thứ b&eacute; y&ecirc;u cần để chế tạo một chiếc M&aacute;y bay chở kh&aacute;ch si&ecirc;u đỉnh, cầu thang m&aacute;y bay, xe bu&yacute;t chở h&agrave;nh kh&aacute;ch, xe đẩy m&aacute;y bay, xe phục vụ dồ ăn v&agrave; xe chở h&agrave;nh l&yacute;, c&ugrave;ng với 7 nh&acirc;n vật Lego. &bull; C&aacute;c t&iacute;nh năng của bộ tr&ograve; chơi &ndash; B&eacute; c&oacute; thể vận h&agrave;nh xe chở đồ ăn để tiếp tế cho h&agrave;nh kh&aacute;ch v&agrave; th&aacute;o mui m&aacute;y bay để đưa nh&acirc;n vật v&agrave;o buồng l&aacute;i. Chỗ ngồi, lối đi, nh&agrave; vệ sinh v&agrave; khu vực ăn uống. &bull; M&oacute;n qu&agrave; d&agrave;nh cho những bạn nhỏ c&oacute; sựu y&ecirc;u th&iacute;ch với m&aacute;y bay &ndash; L&agrave; một m&oacute;n qu&agrave; th&uacute; vị cho ng&agrave;y lễ hoặc sinh nhật cho trẻ em từ 7 tuổi trở l&ecirc;n</p>
', CAST(N'2026-01-12T17:10:50.360' AS DateTime), 1)
GO
INSERT [dbo].[SanPham] ([MaSanPham], [TenSanPham], [MaNhom], [MaThuongHieu], [MaDoTuoi], [MoTaChiTiet], [NgayTao], [TrangThai]) VALUES (5, N'Đồ Chơi Lắp Ráp Trạm Đua Xe LEGO CITY F1 60464', 1, 1, 4, N'Đồ Chơi Lắp Ráp Trạm Đua Xe F1 (92 Chi Tiết)
Hòa mình vào đường đua F1® với Lego® City F1® Williams Racing & Haas F1® Race Cars!

Bắt đầu hành trình tốc độ ngay khi bạn nhảy vào buồng lái và chuẩn bị cho cuộc đua kịch tính trong Lego® City! Lái xe Williams Racing và Haas F1® trên đường đua, cảm nhận sức mạnh của động cơ và tạo nên những cuộc thi gay cấn. Ai sẽ là người chiến thắng? Thử thách đã sẵn sàng!

Điểm nổi bật:

- Nhập vai đua xe: Cho bé cơ hội trở thành tay đua F1® thực thụ, ngồi vào buồng lái xe Williams và Haas, và sẵn sàng đua trên đường đua.

- Phụ kiện chi tiết: Mỗi chiếc xe đua F1® đi kèm với một nhân vật nhỏ từ Williams và Haas, sẵn sàng cho những pha vào cua mạo hiểm.

- Tính năng thú vị: Bộ đồ chơi đi kèm với viên gạch khởi đầu LEGO® và hướng dẫn kỹ thuật số 3D qua ứng dụng Lego Builder giúp bé dễ dàng xây dựng và tham gia vào cuộc đua.

- Món quà tuyệt vời cho đam mê đua xe: Thích hợp cho các bé từ 4 tuổi trở lên yêu thích tốc độ và thể thao.

- Khám phá thêm: Bộ đồ chơi F1® có thể kết hợp với các bộ Lego® F1® khác (bán riêng) để tạo nên một trường đua tuyệt vời cho cả gia đình.

- Kỹ năng phát triển: Giúp bé phát triển các kỹ năng sống, tư duy logic và khả năng sáng tạo khi tham gia vào các trò chơi nhập vai và xây dựng.

- Kích thước hoàn hảo: Mỗi chiếc xe đua F1® dài hơn 11 cm (4,5 inch), dễ dàng để bé cầm nắm và chơi.', CAST(N'2026-01-17T22:59:28.210' AS DateTime), 1)
GO
INSERT [dbo].[SanPham] ([MaSanPham], [TenSanPham], [MaNhom], [MaThuongHieu], [MaDoTuoi], [MoTaChiTiet], [NgayTao], [TrangThai]) VALUES (12, N'Đồ Chơi Búp Bê Thời Trang Fashionista - Sparkly Silver Dress BARBIE', 2, 2, 3, N'Đồ Chơi Búp Bê Thời Trang Fashionista - Sparkly Silver Dress BARBIE HYT95/FBR37 
Búp bê thời trang Fashionista Barbie - Sparkly Silver Dress cho bé tự do thể hiện phong cách qua thời trang. 

Với mái tóc xoăn đen, Barbie diện váy bạc phối cùng mũ cao bồi và bốt trắng, tạo nên vẻ ngoài rạng rỡ, sẵn sàng toả sáng trong mọi bữa tiệc

Phụ kiện nổi bật tôn lên cá tính riêng của Barbie. Là món quà lý tưởng cho các bé yêu thích thời trang.

Hãy mở ra câu chuyện tưởng tượng đầy thú vị cùng với Búp bê thời trang Fashionista Barbie. Sưu tập ngay các bé nhé.', CAST(N'2026-01-17T23:49:02.627' AS DateTime), 1)
GO
INSERT [dbo].[SanPham] ([MaSanPham], [TenSanPham], [MaNhom], [MaThuongHieu], [MaDoTuoi], [MoTaChiTiet], [NgayTao], [TrangThai]) VALUES (13, N'Trứng Slime sưu tập khủng long Jurassic World Dominion W2 TOY MONSTER TM-JW-DSE12', 4, 4, 3, N'Sẵn sàng để bước vào Cuộc chiến tối thượng cùng phiên bản Jurassic World Captivz Dominion!

+ Tháo trứng, khám phá Slime chất nhờn ma quái bên trong

+ Tìm và lắp Khủng long Pop N'' Lock của bạn

+ Với hơn 15 loài để thu thập Đặc biệt, phiên bản khủng long Metallic cực giới hạn! Liệu bạn sẽ sở hữu được chúng để tham gia cuộc chiến?

Mỗi trứng bao gồm:

01 x Khủng long Pop N Lock
01 x 50 gram Slime từ Biosyn lab
01 x Thẻ tích điểm chiến đấu
01 x Hướng dẫn sưu tập Sản phẩm dành cho bé trên 3 tuổi.
Nhà sản xuất: TOY MONSTER Xuất xứ thương hiệu: ÚC', CAST(N'2026-01-20T07:27:50.373' AS DateTime), 1)
GO
INSERT [dbo].[SanPham] ([MaSanPham], [TenSanPham], [MaNhom], [MaThuongHieu], [MaDoTuoi], [MoTaChiTiet], [NgayTao], [TrangThai]) VALUES (14, N'Đồ Chơi Siêu Xe Boulevard - Ford RS200 HOT WHEELS JBL29/GJT68', 3, 3, 4, N'- Bộ sưu tập Hot Wheels Boulevard™ là sự kết hợp hoàn hảo giữa hiệu suất cao cấp và thiết kế đẳng cấp, đảm bảo tạo ấn tượng trong bất kỳ bộ sưu tập nào.
- Siêu xe Hot Wheels Boulevard - Ford RS200 có tỷ lệ 1:64 được chế tác tỉ mỉ với thân xe và khung gầm Metal/Metal™, cùng lốp xe Real Riders™ chính hãng, mang lại cảm giác chân thực và hiệu năng vượt trội.
- Bạn có thể lựa chọn từng mẫu xe Hot Wheels Boulevard riêng lẻ hoặc thu thập tất cả để tạo nên một bộ sưu tập độc đáo, tinh hoa hội tụ từ những mẫu xe cổ điển đến hiện đại. Dòng xe này không chỉ chinh phục các nhà sưu tập Hot Wheels lâu năm mà còn khiến những người mới bắt đầu đam mê.
- Với thiết kế tinh xảo và giá trị vượt thời gian, Siêu xe Hot Wheels Boulevard - Ford RS200 RS200 là món quà hoàn hảo dành cho những người yêu xe hơi, lý tưởng cho mọi dịp đặc biệt hoặc đơn giản là để làm phong phú thêm bộ sưu tập của bạn.', CAST(N'2026-01-20T07:30:02.037' AS DateTime), 1)
GO
INSERT [dbo].[SanPham] ([MaSanPham], [TenSanPham], [MaNhom], [MaThuongHieu], [MaDoTuoi], [MoTaChiTiet], [NgayTao], [TrangThai]) VALUES (15, N'Đồ Chơi Búp Bê Barbie Cutie Reveal - Gấu Xanh Hoan Ca BARBIE JFV62/JFV59', 2, 2, 1, N'- Búp bê Barbie Cutie Reveal - Gấu xanh hoan ca mang đến những khoảnh khắc “cực wow” với 10 bất ngờ thú vị đang chờ được khám phá! Trong bộ sưu tậo, bé sẽ gặp một trong ba nhân vật Care Bears quen thuộc – Gấu xanh hoan ca, Gấu hồng kiêu sa hoặc Gấu tím mơ màng. Khi tháo bỏ bộ trang phục thú bông đáng yêu, búp bê Barbie thời trang với khớp cử động linh hoạt sẽ hiện ra. Liệu bé sẽ mở ra nàng Barbie nào?
- Bên trong còn nhiều điều bất ngờ hơn: một chiếc váy xinh xắn, băng đô, khuyên tai, giày boots hoặc giày cao gót, lược bọt biển và một bé Care Bear tí hon đi kèm! Phần áo lông thú có thể lộn ngược thành áo khoác nỉ mềm mại, còn phần đầu trang phục lại biến thành chiếc giường nhỏ cho thú cưng Care Bear đáng yêu. Đặc biệt, chỉ với nước lạnh hoặc ấm, gương mặt Barbie sẽ thay đổi với chi tiết lấp lánh kỳ diệu – và bé có thể lặp lại phép màu này nhiều lần!
- Với những trang phục ngọt ngào, thú bông dễ thương và trải nghiệm biến đổi bất ngờ, Búp bê Barbie Cutie Reveal - Gấu xanh hoan ca chắc chắn sẽ là món quà tuyệt vời cho trẻ từ 3 đến 7 tuổi, đặc biệt là những fan của Care Bears.', CAST(N'2026-01-20T07:36:50.890' AS DateTime), 1)
GO
INSERT [dbo].[SanPham] ([MaSanPham], [TenSanPham], [MaNhom], [MaThuongHieu], [MaDoTuoi], [MoTaChiTiet], [NgayTao], [TrangThai]) VALUES (16, N'Đồ Chơi Lắp Ráp Xe Ferrari SF-24 F1 LEGO TECHNIC 42207', 1, 1, 5, N'Cảm nhận sự phấn khích của đường đua khi bạn lắp ráp mô hình xe đua Ferrari SF-24 F1 tỷ lệ 1:8 Lego® Technic™ dành cho người lớn. Khám phá những tính năng thực tế như hệ thống lái, hộp số 2 cấp và bánh xe in họa tiết. Tái hiện việc kích hoạt DRS bằng cách điều chỉnh cánh gió. Sau đó, tháo nắp động cơ để ngắm nhìn động cơ V6. Dự án đầy hấp dẫn này cho phép những người yêu thích F1 thể hiện niềm đam mê của mình với một món đồ trưng bày đầy tự hào.

Bộ mô hình Lego® Technic™ Ferrari SF-24 F1 dành cho người lớn

Mô hình xe F1 với hệ thống treo, lái và cánh gió điều chỉnh

Khám phá hộp số 2 cấp và động cơ V6 của xe LEGO® Technic™

Một món đồ trưng bày tuyệt vời cho bất kỳ căn phòng hoặc văn phòng nào

Quà tặng Lego® Technic™ dành cho fan hâm mộ F1

Khám phá cách lắp ráp tương tác qua ứng dụng Lego® Builder

Thưởng thức dự án lắp ráp thư giãn với bộ xe Lego® Technic™ dành cho người lớn

Bộ 1,361 mảnh với chiếc xe F1 Lego® dài hơn 61 cm (24 inch)', CAST(N'2026-01-20T07:47:29.527' AS DateTime), 1)
GO
INSERT [dbo].[SanPham] ([MaSanPham], [TenSanPham], [MaNhom], [MaThuongHieu], [MaDoTuoi], [MoTaChiTiet], [NgayTao], [TrangThai]) VALUES (17, N'Xe trớn tốc độ cao của chú chim nóng tính RED ANGRY BIRDS AB23031', 3, 5, 2, N'Angry Birds Crashers là những chiếc xe trớn siêu nhanh với thiết kế cool ngầu.
Mô phỏng các nhân vật trong phim hoạt hình Angry Birds. Có 6 nhân vật: Red, Leonard, Hog, Bomb, Terence, Chuck.
Bố mẹ hãy sưu tập đủ các nhân vật để giúp các bé có thể viết lên những câu truyện như trong phim nhé!

Thông tin sản phẩm:
Thương hiệu: ANGRY BIRDS
Xuất xứ thương hiệu: HONGKONG
Kích thước khoảng 6.5 cm
Độ tuổi: 3+
Chất liệu: Nhựa
Dùng để chơi và trưng bày.', CAST(N'2026-01-20T08:11:57.477' AS DateTime), 1)
GO
INSERT [dbo].[SanPham] ([MaSanPham], [TenSanPham], [MaNhom], [MaThuongHieu], [MaDoTuoi], [MoTaChiTiet], [NgayTao], [TrangThai]) VALUES (18, N'Đồ Chơi Lắp Ráp Combo Đào Lan Cúc Thần Tài LEGO BOTANICALS CBTET', 1, 1, 5, N'Đồ Chơi Lắp Ráp Combo Đào Lan Cúc Thần Tài LEGO BOTANICALS CBTET
Combo gồm 4 cây hoa Đào, Lan Cúc, Thần Tài', CAST(N'2026-01-22T00:16:39.463' AS DateTime), 1)
GO
INSERT [dbo].[SanPham] ([MaSanPham], [TenSanPham], [MaNhom], [MaThuongHieu], [MaDoTuoi], [MoTaChiTiet], [NgayTao], [TrangThai]) VALUES (19, N'Ba Lô Đi Học Fancy Size S Kitty Pinky', 4, 2, 4, N'<h2><strong>Ba L&ocirc;&nbsp;Đi Học Fancy Size S Kitty Pinky CLEVERHIPPO BK1108/PINK</strong></h2>

<p>Một m&oacute;n qu&agrave; ngọt ng&agrave;o v&agrave; &yacute; nghĩa d&agrave;nh cho c&ocirc;ng ch&uacute;a nhỏ! Balo đi học Fancy Kitty Pinky kh&ocirc;ng chỉ &quot;đốn tim&quot; b&eacute; g&aacute;i với t&ocirc;ng hồng ngọt ng&agrave;o, h&igrave;nh ảnh dễ thương từ bạn m&egrave;o xinh &ldquo;iu&rdquo;, mẫu balo c&ograve;n được điểm xuyến th&ecirc;m c&aacute;c yếu tố lấp l&aacute;nh, bắt mắt.&lt;p&gt;&lt;b&gt;Đẹp&lt;/b&gt; qu&aacute;&lt;/p&gt;</p>

<p>Đặc biệt, d&ograve;ng sản phẩm balo đi học Fancy m&agrave; c&ograve;n thuyết phục ba mẹ bằng hệ thống trợ lực th&ocirc;ng minh, bảo vệ v&oacute;c d&aacute;ng của b&eacute;.</p>

<p><strong>Đặc điểm nổi bật:</strong></p>

<p>1. Thiết kế bảo vệ v&oacute;c d&aacute;ng với đai ngực trợ lực (d&acirc;y c&agrave;i ngang ngực) - đ&acirc;y l&agrave; điểm vượt trội của d&ograve;ng Fancy, gi&uacute;p cố định balo, giảm x&ocirc; lệch v&agrave; ph&acirc;n t&aacute;n trọng lượng hiệu quả. Balo được trang bị hệ thống đệm vai v&agrave; lưng &ecirc;m &aacute;i, tho&aacute;ng kh&iacute;, gi&uacute;p trợ lực tốt hơn.</p>

<p>2. Thiết kế &quot;Kitty Pinky&quot; lấp l&aacute;nh với vũ trụ Kitty ngọt ng&agrave;o. Điểm nhấn độc đ&aacute;o l&agrave; ngăn t&uacute;i ph&iacute;a trước với c&aacute;c hạt kim tuyến lấp l&aacute;nh, c&ugrave;ng h&igrave;nh ảnh m&egrave;o con si&ecirc;u đ&aacute;ng y&ecirc;u. Ba l&ocirc; c&ograve;n đi k&egrave;m một m&oacute;c kh&oacute;a tr&aacute;i tim sequin ấn tượng, ngộ nghĩnh b&ecirc;n trong, tạo n&ecirc;n một m&oacute;n phụ kiện m&agrave; b&eacute; sẽ tự h&agrave;o khoe với bạn b&egrave;.</p>

<p>3. K&iacute;ch thước size S d&agrave;nh ri&ecirc;ng cho v&oacute;c d&aacute;ng nhỏ nhắn của c&aacute;c b&eacute; Lớp 1, Lớp 2 Việt Nam. Ba l&ocirc; vừa vặn với lưng, kh&ocirc;ng g&acirc;y cảm gi&aacute;c qu&aacute; khổ hay x&ocirc; lệch khi b&eacute; di chuyển, gi&uacute;p b&eacute; thoải m&aacute;i v&agrave; tự tin hơn.</p>

<p>4. Sản phẩm gồm 1 ngăn ch&iacute;nh, th&ecirc;m phần đai thun gi&uacute;p cố định s&aacute;ch vở v&agrave; ngăn lưới nhỏ b&ecirc;n trong, gi&uacute;p b&eacute; sắp xếp, ph&acirc;n bổ đồ d&ugrave;ng cực k&igrave; dễ d&agrave;ng, gọn g&agrave;ng. Sản phẩm c&oacute; th&ecirc;m ngăn phụ nhỏ ph&iacute;a trước v&agrave; 2 ngăn h&ocirc;ng với thiết kế kh&oacute;a k&eacute;o gi&uacute;p b&eacute; linh hoạt đựng b&igrave;nh nước v&agrave; c&aacute;c vật dụng nhỏ kh&aacute;c</p>

<p>5. Bảo h&agrave;nh 12 th&aacute;ng*, khẳng định chất lượng v&agrave; độ bền vượt trội của d&ograve;ng sản phẩm balo đi học Fancy cao cấp.</p>

<p><strong>Th&ocirc;ng số kỹ thuật</strong></p>

<p>- Độ tuổi sử dụng: Ph&ugrave; hợp nhất cho b&eacute; Lớp 1, Lớp 2 (hoặc b&eacute; c&oacute; v&oacute;c d&aacute;ng nhỏ)</p>

<p>- Trọng lượng: 800g - K&iacute;ch thước: Size S, 16 x 29 x 35 (cm)</p>

<p>- Chất liệu: Vải Polyester 600D</p>

<p>- Bảo h&agrave;nh: 12 th&aacute;ng (Lỗi sản xuất như d&acirc;y k&eacute;o, đầu k&eacute;o. Th&ocirc;ng tin chi tiết tr&ecirc;n tag bảo h&agrave;nh)</p>

<p>Mẫu balo đi học Fancy size S l&agrave; qu&agrave; tặng th&iacute;ch hợp d&agrave;nh cho c&aacute;c b&eacute; lớp 1, lớp 2 cho học k&igrave; mới v&agrave; cả những dịp đặc biệt.</p>

<p>Lưu &yacute; quan trọng: M&agrave;u sắc thực tế của sản phẩm c&oacute; thể ch&ecirc;nh lệch một &iacute;t so với ảnh bạn thấy tr&ecirc;n m&agrave;n h&igrave;nh, tuỳ thuộc v&agrave;o điều kiện &aacute;nh s&aacute;ng khi chụp v&agrave; thiết bị bạn đang sử dụng.</p>
', CAST(N'2026-01-24T14:27:31.973' AS DateTime), 1)
GO
SET IDENTITY_INSERT [dbo].[SanPham] OFF
GO
SET IDENTITY_INSERT [dbo].[ThuongHieu] ON 
GO
INSERT [dbo].[ThuongHieu] ([MaThuongHieu], [TenThuongHieu], [QuocGia]) VALUES (1, N'LEGO', N'Đan Mạch')
GO
INSERT [dbo].[ThuongHieu] ([MaThuongHieu], [TenThuongHieu], [QuocGia]) VALUES (2, N'Barbie', N'Mỹ')
GO
INSERT [dbo].[ThuongHieu] ([MaThuongHieu], [TenThuongHieu], [QuocGia]) VALUES (3, N'Hot Wheels', N'Mỹ')
GO
INSERT [dbo].[ThuongHieu] ([MaThuongHieu], [TenThuongHieu], [QuocGia]) VALUES (4, N'Fisher-Price', N'Mỹ')
GO
INSERT [dbo].[ThuongHieu] ([MaThuongHieu], [TenThuongHieu], [QuocGia]) VALUES (5, N'ANGRY BIRDS', NULL)
GO
SET IDENTITY_INSERT [dbo].[ThuongHieu] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__KhachHan__A9D10534C328A613]    Script Date: 03/03/2026 8:32:56 AM ******/
ALTER TABLE [dbo].[KhachHang] ADD UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AnhSanPham] ADD  DEFAULT ((0)) FOR [LaAnhChinh]
GO
ALTER TABLE [dbo].[BienTheSanPham] ADD  DEFAULT ((0)) FOR [SoLuongTon]
GO
ALTER TABLE [dbo].[DanhGia] ADD  DEFAULT (getdate()) FOR [NgayGui]
GO
ALTER TABLE [dbo].[DonHang] ADD  DEFAULT (getdate()) FOR [NgayDat]
GO
ALTER TABLE [dbo].[KhachHang] ADD  DEFAULT (getdate()) FOR [NgayDangKy]
GO
ALTER TABLE [dbo].[KhachHang] ADD  DEFAULT ('KhachHang') FOR [VaiTro]
GO
ALTER TABLE [dbo].[KhachHang] ADD  DEFAULT ((1)) FOR [TrangThai]
GO
ALTER TABLE [dbo].[QuangCao] ADD  DEFAULT ((0)) FOR [ThuTu]
GO
ALTER TABLE [dbo].[QuangCao] ADD  DEFAULT ((1)) FOR [HienThi]
GO
ALTER TABLE [dbo].[SanPham] ADD  DEFAULT (getdate()) FOR [NgayTao]
GO
ALTER TABLE [dbo].[SanPham] ADD  DEFAULT ((1)) FOR [TrangThai]
GO
ALTER TABLE [dbo].[AnhSanPham]  WITH CHECK ADD  CONSTRAINT [FK_Anh_SanPham] FOREIGN KEY([MaSanPham])
REFERENCES [dbo].[SanPham] ([MaSanPham])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AnhSanPham] CHECK CONSTRAINT [FK_Anh_SanPham]
GO
ALTER TABLE [dbo].[BienTheSanPham]  WITH CHECK ADD  CONSTRAINT [FK_BienThe_SanPham] FOREIGN KEY([MaSanPham])
REFERENCES [dbo].[SanPham] ([MaSanPham])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[BienTheSanPham] CHECK CONSTRAINT [FK_BienThe_SanPham]
GO
ALTER TABLE [dbo].[ChiTietDonHang]  WITH CHECK ADD  CONSTRAINT [FK_CTDH_BienThe] FOREIGN KEY([MaBienThe])
REFERENCES [dbo].[BienTheSanPham] ([MaBienThe])
GO
ALTER TABLE [dbo].[ChiTietDonHang] CHECK CONSTRAINT [FK_CTDH_BienThe]
GO
ALTER TABLE [dbo].[ChiTietDonHang]  WITH CHECK ADD  CONSTRAINT [FK_CTDH_DonHang] FOREIGN KEY([MaDonHang])
REFERENCES [dbo].[DonHang] ([MaDonHang])
GO
ALTER TABLE [dbo].[ChiTietDonHang] CHECK CONSTRAINT [FK_CTDH_DonHang]
GO
ALTER TABLE [dbo].[DanhGia]  WITH CHECK ADD  CONSTRAINT [FK_DanhGia_KhachHang] FOREIGN KEY([MaKhachHang])
REFERENCES [dbo].[KhachHang] ([MaKhachHang])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[DanhGia] CHECK CONSTRAINT [FK_DanhGia_KhachHang]
GO
ALTER TABLE [dbo].[DanhGia]  WITH CHECK ADD  CONSTRAINT [FK_DanhGia_SanPham] FOREIGN KEY([MaSanPham])
REFERENCES [dbo].[SanPham] ([MaSanPham])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[DanhGia] CHECK CONSTRAINT [FK_DanhGia_SanPham]
GO
ALTER TABLE [dbo].[DonHang]  WITH CHECK ADD  CONSTRAINT [FK_DonHang_KhachHang] FOREIGN KEY([MaKhachHang])
REFERENCES [dbo].[KhachHang] ([MaKhachHang])
GO
ALTER TABLE [dbo].[DonHang] CHECK CONSTRAINT [FK_DonHang_KhachHang]
GO
ALTER TABLE [dbo].[SanPham]  WITH CHECK ADD  CONSTRAINT [FK_SanPham_DoTuoi] FOREIGN KEY([MaDoTuoi])
REFERENCES [dbo].[DoTuoi] ([MaDoTuoi])
GO
ALTER TABLE [dbo].[SanPham] CHECK CONSTRAINT [FK_SanPham_DoTuoi]
GO
ALTER TABLE [dbo].[SanPham]  WITH CHECK ADD  CONSTRAINT [FK_SanPham_Nhom] FOREIGN KEY([MaNhom])
REFERENCES [dbo].[NhomSanPham] ([MaNhom])
GO
ALTER TABLE [dbo].[SanPham] CHECK CONSTRAINT [FK_SanPham_Nhom]
GO
ALTER TABLE [dbo].[SanPham]  WITH CHECK ADD  CONSTRAINT [FK_SanPham_ThuongHieu] FOREIGN KEY([MaThuongHieu])
REFERENCES [dbo].[ThuongHieu] ([MaThuongHieu])
GO
ALTER TABLE [dbo].[SanPham] CHECK CONSTRAINT [FK_SanPham_ThuongHieu]
GO
ALTER TABLE [dbo].[BienTheSanPham]  WITH CHECK ADD CHECK  (([GiaBan]>=(0)))
GO
ALTER TABLE [dbo].[BienTheSanPham]  WITH CHECK ADD CHECK  (([SoLuongTon]>=(0)))
GO
ALTER TABLE [dbo].[ChiTietDonHang]  WITH CHECK ADD CHECK  (([SoLuong]>(0)))
GO
ALTER TABLE [dbo].[DanhGia]  WITH CHECK ADD CHECK  (([SoSao]>=(1) AND [SoSao]<=(5)))
GO
USE [master]
GO
ALTER DATABASE [DB_WEB_DO_CHOI] SET  READ_WRITE 
GO
