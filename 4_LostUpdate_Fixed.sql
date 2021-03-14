--- =================================================================
--- ====             CÀI ĐẶT TRANH CHẤP                          ====
--- ====             FIX LỖI LOST UPDATE                         ====
--- =================================================================
-- NHÓM 12


-- 1.  TÌNH HUỐNG 1
-- NGUYỄN LÊ NGỌC TẦN (18120553)

-- Giao tác T1: ADMIN cập nhật lương của nhân viên
CREATE PROC sp_CapNhat_TangLuong_Fixed @MaNV CHAR(10), @MucTang MONEY
AS
BEGIN TRAN
	SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
	
	DECLARE @Luong MONEY

	IF (EXISTS (SELECT * FROM NhanVien WHERE MaNhanVien = @MaNV))
		BEGIN
			SET @Luong = (SELECT Luong FROM NhanVien WHERE MaNhanVien = @MaNV)
			WAITFOR DELAY '00:00:5'

			SET @Luong = @Luong + @MucTang
			UPDATE NhanVien SET Luong = @Luong WHERE MaNhanVien = @MaNV
		END
	ELSE
		BEGIN
			PRINT N'Không tồn tại nhân viên này!'
			ROLLBACK TRAN;
		END
COMMIT TRAN
GO
 
EXEC sp_CapNhat_TangLuong_Fixed  'NV001', 20

select * from NhanVien where MaNhanVien = 'NV001'


-- Giao tác T2: Nhân viên quản lý cập nhật lương của nhân viên
-- Dùng chung chức năng cập nhật lương
CREATE PROC sp_CapNhat_GiamLuong_Fixed @MaNV CHAR(10), @MucGiam MONEY
AS
BEGIN TRAN
	SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
	
	DECLARE @Luong MONEY

	IF (EXISTS (SELECT * FROM NhanVien WHERE MaNhanVien = @MaNV))
		BEGIN
			SET @Luong = (SELECT Luong FROM NhanVien WHERE MaNhanVien = @MaNV)
			WAITFOR DELAY '00:00:5'
			
			SET @Luong = @Luong - @MucGiam
			UPDATE NhanVien SET Luong = @Luong WHERE MaNhanVien = @MaNV
		END
	ELSE
		BEGIN
			PRINT N'Không tồn tại nhân viên này!'
			ROLLBACK TRAN;
		END
COMMIT TRAN
GO


EXEC sp_CapNhat_GiamLuong_Fixed 'NV001', 10


--========================================= HẾT ========================================================



