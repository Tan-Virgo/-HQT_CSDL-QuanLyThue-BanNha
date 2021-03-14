--- =================================================================
--- ====             CÀI ĐẶT TRANH CHẤP                          ====
--- ====             FIX LỖI DIRTY READ                          ====
--- =================================================================
-- NHÓM 12





-- 1.  TÌNH HUỐNG 1
-- Tên người làm Nguyễn Văn Trị

-- Giao tác T1: Chủ nhà thay đổi giá ngôi nhà đăng lên
create procedure pro_host_change_price_fixed
(@ma_cn varchar(10), @ma_nha varchar(10), @tien_tang money, @ngay_dang datetime)
as
begin
begin transaction
	set transaction isolation level read committed

	declare @gia_nha money
	set @gia_nha = (select GiaBan from NhaDangLen_Ban where MaNha = @ma_nha and MaChuNha = @ma_cn and NgayDang = @ngay_dang)
	set @gia_nha = @gia_nha + @tien_tang

	update NhaDangLen_Ban set GiaBan = @gia_nha where MaNha = @ma_nha and MaChuNha = @ma_cn and NgayDang = @ngay_dang

	waitfor delay '00:00:10'

	if @@error != 0
		rollback

	commit
end


-- Giao tác T2: Khách hàng xem danh sách nhà đăng lên
create procedure pro_guest_search_house_fixed
as
begin
begin transaction
	set transaction isolation level read committed

	select * from NhaDangLen_Ban
	commit
end



-- ========================================================================================




-- 2.  TÌNH HUỐNG 2
-- Tên người làm Nguyễn Văn Trị

-- Giao tác T1: Nhân viên thêm vào lịch sử xem nhà đăng lên
create procedure pro_employee_insert_view_history_fixed
(@ma_kh varchar(10), @ma_nha varchar(10), @ma_cn varchar(10), @ngay_dang datetime, @danh_gia nvarchar(50), @ngay_xem datetime)
as
begin
begin transaction
	insert into LichSuXemNha_Ban
	values(@ma_kh, @ma_nha, @ma_cn, @ngay_dang, @ngay_xem, @danh_gia)

	waitfor delay '00:00:10'

	if @@error != 0
		rollback

	commit
end


-- Giao tác T2: Chủ nhà xem số lượt xem của nhà đăng lên
create procedure pro_host_search_sell_house_fixed
as
begin
begin transaction
	set transaction isolation level read committed

	select SoLuotXem from NhaDangLen_Ban
	commit
end



--========================================= HẾT ========================================================