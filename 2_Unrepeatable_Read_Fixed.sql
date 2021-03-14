--- =================================================================
--- ====             CÀI ĐẶT TRANH CHẤP                          ====
--- ====             FIX LỖI UNREPEATABLE READ                   ====
--- =================================================================
-- NHÓM 12



-- 1.  TÌNH HUỐNG 1
-- HOÀNG CÔNG SƠN - 18120534

-- Giao tác T1: Nhân viên đăng nhập vào hệ thống
CREATE PROC sp_DangNhap_fixed @Username CHAR(10), @Password CHAR(10)
AS
BEGIN TRAN
	SET TRANSACTION ISOLATION LEVEL SERIALIZABLE

	IF (NOT EXISTS(SELECT  * FROM TaiKhoan WHERE @Username = Username))
		BEGIN
			PRINT N'Tên đăng nhập không tồn tại'
			RETURN;
		END
	
	WAITFOR DELAY ‘00:00:10’

	IF (Not Exists (SELECT  * FROM TaiKhoan WHERE @Username = Username and @Password = Password))
		BEGIN
			PRINT N'Sai tên đăng nhập hoặc mật khẩu'
			RETURN;
		END
	
	SELECT * FROM TaiKhoan WHERE Username = @Username AND Password = @Password
	PRINT N’Đăng nhập thành công’

COMMIT
GO

-- Giao tác T2: Hệ thống đổi mật khẩu của nhân viên về mặc định
CREATE PROC sp_ResetPw_fixed @Username CHAR(10)
AS
BEGIN TRAN
	UPDATE TaiKhoan 
SET Password = '123456' 
WHERE @Username = Username
COMMIT
GO





-- ========================================================================================




-- 2.  TÌNH HUỐNG 2
-- HOÀNG CÔNG SƠN - 18120534 

-- Giao tác T1: Xem nhân viên có lương lớn nhất đang làm việc tại chi nhánh
CREATE PROC max_salary_fixed @MaChiNhanh CHAR (10)
AS 
BEGIN TRAN
	SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
	SELECT *
	FROM NhanVien
	where (MaChiNhanh = @MaChiNhanh) and (Luong = max(select Luong from NhanVien))
	
	WAITFOR DELAY ‘00:00:10’
	IF @@ERROR != 0 ROLLBACK
COMMIT
GO

-- Giao tác T2: Cập nhật lương một nhân viên 
CREATE PROC update_salary_fixed @MaNV CHAR(10), @gia_moi money
AS
	SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
	UPDATE NhanVien
	SET Luong = @gia_moi
	WHERE @MaNV = MaNV
COMMIT 
GO
	


--========================================= HẾT ========================================================