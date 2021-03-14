--- =================================================================
--- ====             CÀI ĐẶT TRANH CHẤP                          ====
--- ====             FIX LỖI PHANTOM READ                        ====
--- =================================================================
-- NHÓM 12



-- 1.  TÌNH HUỐNG 1
-- NGUYỄN LÊ NGỌC TẦN (18120553)
-- Giao tác 1: ADIMIN xem danh sách các căn nhà có n phòng
CREATE PROC sp_DS_Nha_fixed @n INT, @SoCanNha INT OUTPUT
AS
BEGIN TRAN
	SET TRANSACTION ISOLATION LEVEL SERIALIZABLE

	SELECT @SoCanNha = COUNT(*)
	FROM Nha
	WHERE SoLuongPhong = @n

	WAITFOR DELAY '00:00:7'

	SELECT * 
	FROM Nha
	WHERE SoLuongPhong = @n
COMMIT
GO

-- DECLARE @S INT
-- EXEC sp_DS_Nha_fixed 4, @S OUTPUT
-- SELECT @S


-- Giao tác 2: Chủ nhà thêm một căn nhà mới
CREATE PROC sp_Them_Nha_fixed @MaNha CHAR(10), @SoNha NVARCHAR(50), @Quan NVARCHAR(20),
@TP NVARCHAR(20), @KhuVuc NVARCHAR(20), @SoLuongPhong INT, @TinhTrangNha NVARCHAR(20),
@LoaiNha CHAR(10), @NVQL CHAR(10), @ChiNhanh CHAR(10), @ChuNha CHAR(10)
AS
BEGIN TRAN
	SET TRANSACTION ISOLATION LEVEL SERIALIZABLE

	IF (EXISTS (SELECT * FROM Nha WHERE MaNha = @MaNha))
		ROLLBACK TRAN;

	INSERT INTO Nha (MaNha, SoNha, Quan, TP, KhuVuc, SoLuongPhong, TinhTrangNha, LoaiNha, NVQL, ChiNhanh, ChuNhaHienTai)
	VALUES (@MaNha, @SoNha, @Quan, @TP, @KhuVuc, @SoLuongPhong, @TinhTrangNha, @LoaiNha,
	@NVQL, @ChiNhanh, @ChuNha)
COMMIT
GO

-- EXEC sp_Them_Nha_fixed 'NA020', '222', N'Quận 1', 'TPHCM',N'Nam Bộ', 4, N'Còn trống', 'NRL',
-- 'NV001', 'CN001', 'CN011'

-- DELETE Nha WHERE MaNha = N'NA020'









-- 2. TÌNH HUỐNG 2
-- NGUYỄN LÊ NGỌC TẦN (18120553)
-- Giao tác 1: ADMIN xem danh sách nhân viên của một chi nhánh
CREATE PROC sp_DanhSachNhanVien_fixed @MaChiNhanh CHAR(10), @SoNV INT OUTPUT
AS
BEGIN TRAN
	SET TRANSACTION ISOLATION LEVEL SERIALIZABLE

	SELECT @SoNV = COUNT(*)
	FROM NhanVien
	WHERE ChiNhanh = @MaChiNhanh
	AND TinhTrangNhanVien = 1

	WAITFOR DELAY '00:00:7'

	SELECT *
	FROM NhanVien
	WHERE ChiNhanh = @MaChiNhanh
	AND TinhTrangNhanVien = 1
COMMIT
GO

-- DECLARE @s INT
-- EXEC sp_DanhSachNhanVien_fixed 'CN002', @s OUTPUT
-- SELECT @s


-- Giao tác 2: Nhân viên quản lý thêm một nhân viên mới
CREATE PROC sp_ThemNV_fixed @MaNV CHAR(10), @TenNV NVARCHAR(50), @DiaChi NVARCHAR(50),
@SDT CHAR(10), @GioiTinh NVARCHAR(3), @NgaySinh DATETIME, @Luong MONEY,
@TinhTrangNhanVien BIT, @ChiNhanh CHAR(10), @NhanVienQL CHAR(10)
AS
BEGIN TRAN
	SET TRANSACTION ISOLATION LEVEL SERIALIZABLE

	IF (EXISTS (SELECT * FROM NhanVien WHERE MaNhanVien = @MaNV))
		ROLLBACK TRAN;

	INSERT INTO NhanVien
	VALUES (@MaNV, @TenNV, @DiaChi, @SDT, @GioiTinh, @NgaySinh, @Luong, @TinhTrangNhanVien, @ChiNhanh, @NhanVienQL)

COMMIT TRAN
GO

-- EXEC sp_ThemNV_fixed N'NV0021', N'Bành Thị Ngu Ngốc', N'Thủ Đức, TP HCM', '0123456789',
-- N'Nam', '2/20/2000', 70, 1, N'CN002', N'NV008'

-- DELETE NhanVien WHERE MaNhanVien = N'NV0021'



--  ==============================================================================