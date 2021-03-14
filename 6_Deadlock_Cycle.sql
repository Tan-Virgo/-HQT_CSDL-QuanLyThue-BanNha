--- =================================================================
--- ====             XỬ LÝ LỖI TRANH CHẤP                       ====
--- ====            	DEADLOCK (CYCLE)                         ====
--- =================================================================
-- NHÓM 12





--Ten người làm: Ksor Âu

--trương hợp 1: 
---Them HD ban nha
go
CREATE PROC themHDBanNha_Fix @MaHD char(10), @NgayLap DATETIME, @NgayNhan DATETIME, @GiaBan MONEY,  @Nha CHAR(10), @ChuNha CHAR(10), @NgayDang DATETIME, @KhachHang CHAR(10)
AS 
BEGIN
	BEGIN TRAN
	BEGIN TRY
	SET	TRANSACTION ISOLATION LEVEL SERIALIZABLE
	if exists( select * from HopDongThueNha where Nha = @Nha)
	begin
		print N'Nhà này đã được thuê, hiện tại không thể bán'
		rollback
	end
	WAITFOR DELAY '00:00:05'
	insert into HopDongBanNha(MaHopDong, NgayLap, NgayNhan, GiaBan, Nha, ChuNha, NgayDang, KhachHang)
	values(@MaHD, @NgayLap, @NgayNhan, @GiaBan,  @Nha, @ChuNha, @NgayDang, @KhachHang)
	UPDATE Nha SET TinhTrangNha = N'Đã bán' where MaNha = @Nha;

	COMMIT
	END TRY
	BEGIN CATCH
		IF(ERROR_NUMBER() = 1205)
		BEGIN
		SELECT 'Giao tác bị deadlock! Vui lòng thử lại'
		END
		ROLLBACK
	END CATCH
END
-----------


------------------------Them HD ban thue nha- ------------------
go
CREATE PROC themHDThueNha_Fix @MaHD char(10), @NgayLap DATETIME, @NgayNhan DATETIME, @GiaThue_Thang MONEY, @TienCoc money, @NgayTra datetime,  @Nha CHAR(10), @ChuNha CHAR(10), @NgayDang DATETIME, @KhachHang CHAR(10)
AS 
BEGIN
	BEGIN TRAN
	BEGIN TRY
	SET	TRANSACTION ISOLATION LEVEL SERIALIZABLE
	if exists( select * from HopDongBanNha where Nha = @Nha)
	begin
		print N'Nhà này đã được bán, không thể thuê'
		rollback
	end
	WAITFOR DELAY '00:00:05'
	insert into HopDongThueNha(MaHopDong, NgayLap, NgayNhan, GiaThue_Thang, TienCoc, NgayTra, Nha, ChuNha, NgayDang, KhachHang)
	values(@MaHD, @NgayLap, @NgayNhan, @GiaThue_Thang, @TienCoc, @NgayTra, @Nha, @ChuNha, @NgayDang, @KhachHang)
	UPDATE Nha SET TinhTrangNha = N'Ðã cho thuê' where MaNha = @Nha;
	COMMIT
	END TRY
	BEGIN CATCH
		IF(ERROR_NUMBER() = 1205)
		BEGIN
		SELECT 'Giao tác bị deadlock! Vui lòng thử lại'
		END
		ROLLBACK
	END CATCH
END



---trường hợp 2:
---xem hết tất cả các hợp đồng

go
create PROC xemhetTatCaHopDong_Fix 
AS 
BEGIN
	BEGIN TRAN 

	SET	TRANSACTION ISOLATION LEVEL SERIALIZABLE
		SELECT * FROM dbo.HopDongThueNha
		WAITFOR DELAY '00:00:05'
		SELECT * FROM dbo.HopDongBanNha
	COMMIT
end

--cập nhật giảm giá cho khách hàng
GO 
create PROCEDURE capNhatHD_Fix @MAKH CHAR(10), @tileGiam FLOAT
AS
BEGIN
	BEGIN TRAN

	SET	TRANSACTION ISOLATION LEVEL SERIALIZABLE
		UPDATE dbo.HopDongThueNha SET GiaThue_Thang = GiaThue_Thang -  GiaThue_Thang* @tileGiam WHERE KhachHang = @MAKH;
		WAITFOR DELAY '00:00:05'
		UPDATE dbo.HopDongBanNha SET GiaBan = GiaBan - GiaBan * @tileGiam WHERE KhachHang = @MAKH;
	COMMIT
END
EXEC dbo.xemhetTatCaHopDong













--========================================= HẾT ========================================================