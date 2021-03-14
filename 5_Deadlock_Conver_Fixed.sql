--- =================================================================
--- ====             CÀI ĐẶT TRANH CHẤP                          ====
--- ====            LỖI DEADLOCK (CONVER)                        ====
--- =================================================================
-- NHÓM 12





-- 1.  TÌNH HUỐNG 1
-- Tên người làm: Nguyễn Hoàng Minh Trí

-- Giao tác T1: Admin thực hiện cho nhân viên nghỉ việc (thay đổi tình trạng nhân viên)
DROP PROC sp_ThayDoiTinhTrangNV
go
CREATE PROC sp_ThayDoiTinhTrangNV @MaNV char(10)
AS 
BEGIN
BEGIN TRAN
BEGIN TRY
		SET	TRANSACTION ISOLATION LEVEL SERIALIZABLE
		IF (NOT EXISTS(SELECT * FROM NhanVien WHERE MaNhanVien = @MaNV))
				BEGIN
					PRINT N'Nhân viên không tồn tại'
					RETURN;
				END

		WAITFOR DELAY '00:00:10'

		UPDATE NhanVien SET TinhTrangNhanVien = 0 WHERE MaNhanVien = @MaNV
COMMIT
END TRY
BEGIN CATCH
	IF(ERROR_NUMBER() = 1205)
		BEGIN
		SELECT N'Giao tác bị deadlock! Vui lòng thử lại'
		END
		ROLLBACK
END CATCH
END 


-- Giao tác T2: Nhân viên thực hiện chỉnh sửa thông tin cá nhân
DROP PROC sp_SuaThongTinNV
go
CREATE PROC sp_SuaThongTinNV @MaNV char(10), @Ten nvarchar(50), @DiaChi nvarchar(50), @SDT char(11), @GioiTinh nvarchar(3), @NgaySinh datetime
AS 
BEGIN
BEGIN TRAN
BEGIN TRY
		SET	TRANSACTION ISOLATION LEVEL SERIALIZABLE
		IF (NOT EXISTS(SELECT * FROM NhanVien WHERE MaNhanVien = @MaNV))
				BEGIN
					PRINT N'Nhân viên không tồn tại'
					RETURN;
				END
		WAITFOR DELAY '00:00:10'

		UPDATE NhanVien SET Ten_NhanVien = @Ten WHERE MaNhanVien = @MaNV
		UPDATE NhanVien SET DiaChi_NhanVien = @DiaChi WHERE MaNhanVien = @MaNV
		UPDATE NhanVien SET SDT_NhanVien = @SDT WHERE MaNhanVien = @MaNV
		UPDATE NhanVien SET GioiTinh = @GioiTinh WHERE MaNhanVien = @MaNV
		UPDATE NhanVien SET NgaySinh = @NgaySinh WHERE MaNhanVien = @MaNV

COMMIT
END TRY
BEGIN CATCH
	IF(ERROR_NUMBER() = 1205)
		BEGIN
		SELECT N'Giao tác bị deadlock! Vui lòng thử lại'
		END
		ROLLBACK
END CATCH
END



-- ========================================================================================




-- 2.  TÌNH HUỐNG 2
-- Tên người làm: Nguyễn Hoàng Minh Trí

-- Giao tác T1: Khách trả nhà, Nhân viên cập nhật ngày trả cho hợp đồng thuê nhà
DROP PROC sp_CapNhapHDThueNha
go
CREATE PROC sp_CapNhapHDThueNha @MaHD char(10), @NgayTra datetime
AS 
BEGIN
BEGIN TRAN
BEGIN TRY
		SET	TRANSACTION ISOLATION LEVEL SERIALIZABLE
		IF (NOT EXISTS(SELECT * FROM HopDongThueNha WHERE MaHopDong = @MaHD))
				BEGIN
					PRINT N'Hợp đồng không tồn tại'
					RETURN;
				END

		WAITFOR DELAY '00:00:5'

		UPDATE HopDongThueNha SET NgayTra = @NgayTra WHERE MaHopDong = @MaHD

COMMIT
END TRY
BEGIN CATCH
	IF(ERROR_NUMBER() = 1205)
		BEGIN
		SELECT N'Giao tác bị deadlock! Vui lòng thử lại'
		END
		ROLLBACK
END CATCH
END

-- Giao tác T2: Khách trả nhà, Nhân viên cập nhật ngày trả cho hợp đồng thuê nhà (nhưng nhân viên này ở chi nhánh khác nhân viên trên)
CREATE PROC sp_CapNhapHDThueNha @MaHD char(10), @NgayTra datetime
AS 
BEGIN
BEGIN TRAN
BEGIN TRY
		SET	TRANSACTION ISOLATION LEVEL SERIALIZABLE
		IF (NOT EXISTS(SELECT * FROM HopDongThueNha WHERE MaHopDong = @MaHD))
				BEGIN
					PRINT N'Hợp đồng không tồn tại'
					RETURN;
				END

		WAITFOR DELAY '00:00:5'

		UPDATE HopDongThueNha SET NgayTra = @NgayTra WHERE MaHopDong = @MaHD

COMMIT
END TRY
BEGIN CATCH
	IF(ERROR_NUMBER() = 1205)
		BEGIN
		SELECT N'Giao tác bị deadlock! Vui lòng thử lại'
		END
		ROLLBACK
END CATCH
END

--========================================= HẾT ========================================================