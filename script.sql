﻿---- SCRIPT TAO DATABASE QUẢN LÝ CHO THUÊ/BÁN NHÀ
--- NHÓM 12
--- MÔN: HỆ QUẢN TRỊ CSDL

--===================================================================================================
-- TẠO DATABASE

CREATE DATABASE QuanLyNha
GO

USE QuanLyNha
GO

-- Bảng chi nhánh
CREATE TABLE ChiNhanh
(
	MaChiNhanh CHAR(10) PRIMARY KEY,
	DiaChi_ChiNhah NVARCHAR(50),
	SDT_ChiNhanh CHAR(10),
	SoFax CHAR(10)
)
GO

-- Bảng Nhân viên
CREATE TABLE NhanVien
(
	MaNhanVien CHAR(10) PRIMARY KEY,
	Ten_NhanVien NVARCHAR(50),
	DiaChi_NhanVien NVARCHAR(50),
	SDT_NhanVien CHAR(11),
	GioiTinh NVARCHAR(3),
	NgaySinh DATETIME,
	Luong Money,
	TinhTrangNhanVien bit default 1, 
	ChiNhanh CHAR(10),
	NVQuanLy CHAR(10)
)
GO

-- Bảng Khách hàng
CREATE TABLE KhachHang
(
	MaKhachHang CHAR(10) PRIMARY KEY,
	Ten_KhachHang NVARCHAR(50),
	DiaChi_KhachHang NVARCHAR(50),
	SDT_KhachHang CHAR(10),
	ChiNhanh CHAR(10)
)
GO

-- Bảng Chủ nhà
CREATE TABLE ChuNha
(
	MaChuNha CHAR(10) PRIMARY KEY,
	Ten_ChuNha NVARCHAR(50),
	DiaChi_ChuNha NVARCHAR(50),
	SDT_ChuNha CHAR(10)
)
GO

-- Bảng Loại nhà
CREATE TABLE LoaiNha
(
	MaLoaiNha CHAR(10) PRIMARY KEY,
	Ten_LoaiNha NVARCHAR(50)
)
GO

-- Bảng Nhà
CREATE TABLE Nha
(
	MaNha CHAR(10) PRIMARY KEY,
	SoNha NVARCHAR(50),
	Quan NVARCHAR(20),
	TP NVARCHAR(20),
	KhuVuc NVARCHAR(20),
	SoLuongPhong INT DEFAULT 1,
	TinhTrangNha NVARCHAR(20) DEFAULT N'Còn Trống',
	LoaiNha CHAR(10),
	NVQL CHAR(10),
	ChiNhanh CHAR(10),
	ChuNhaHienTai CHAR(10)
)
GO

-- Bảng Nhu cầu khách hàng
CREATE TABLE NhuCau_KH
(
	MaKhachHang CHAR(10),
	MaLoaiNha CHAR(10),
	TieuChiNha NVARCHAR(50),
	NhuCau bit DEFAULT 0 -- Thuê: 0, mua: 1

	PRIMARY KEY (MaKhachHang, MaLoaiNha)
)
GO

-- Bảng Nhà đăng lên cho thuê
CREATE TABLE NhaDangLen_Thue
(
	MaNha CHAR(10),
	MaChuNha CHAR(10),
	NgayDang DATETIME,
	NgayHetHan DATETIME,
	SoLuotXem INT DEFAULT 0,
	GiaThue MONEY

	PRIMARY KEY (MaNha, MaChuNha, NgayDang)
)
GO

-- Bảng Nhà đăng lên bán
CREATE TABLE NhaDangLen_Ban
(
	MaNha CHAR(10),
	MaChuNha CHAR(10),
	NgayDang DATETIME,
	NgayHetHan DATETIME,
	SoLuotXem INT DEFAULT 0,
	GiaBan MONEY,
	DieuKien NVARCHAR(50)

	PRIMARY KEY (MaNha, MaChuNha, NgayDang)
)
GO

-- Bảng Họp đồng thuê nhà
CREATE TABLE HopDongThueNha
(
	MaHopDong CHAR(10) PRIMARY KEY,
	NgayLap DATETIME,
	NgayNhan DATETIME,
	GiaThue_Thang MONEY,
	TienCoc MONEY,
	NgayTra DATETIME DEFAULT NULL,
	Nha CHAR(10),
	ChuNha CHAR(10),
	NgayDang DATETIME,
	KhachHang CHAR(10)
)
GO

-- Bảng Họp đồng bán nhà
CREATE TABLE HopDongBanNha
(
	MaHopDong CHAR(10) PRIMARY KEY,
	NgayLap DATETIME,
	NgayNhan DATETIME,
	GiaBan MONEY,
	Nha CHAR(10),
	ChuNha CHAR(10),
	NgayDang DATETIME,
	KhachHang CHAR(10)
)
GO

-- Bảng Lịch sử xem nhà cho thuê
CREATE TABLE LichSuXemNha_Thue
(
	MaKhachHang CHAR(10),
	MaNha CHAR(10),
	MaChuNha CHAR(10),
	NgayDang DATETIME,
	NgayXem DATETIME,
	DanhGia NVARCHAR(50)

	PRIMARY KEY (MaKhachHang, MaNha, MaChuNha, NgayDang, NgayXem)
)
GO

-- Bảng Lịch sử xem nhà bán
CREATE TABLE LichSuXemNha_Ban
(
	MaKhachHang CHAR(10),
	MaNha CHAR(10),
	MaChuNha CHAR(10),
	NgayDang DATETIME,
	NgayXem DATETIME,
	DanhGia NVARCHAR(50)

	PRIMARY KEY (MaKhachHang, MaNha, MaChuNha, NgayDang, NgayXem)
)
GO

--==========================================================================================================
-- CÁC KHÓA NGOẠI

ALTER TABLE NhanVien ADD 
CONSTRAINT FK_NhanVien_NhanVien FOREIGN KEY (NVQuanLy) REFERENCES NhanVien(MaNhanVien)

ALTER TABLE NhanVien ADD 
CONSTRAINT FK_NhanVien_ChiNhanh FOREIGN KEY (ChiNhanh) REFERENCES ChiNhanh(MaChiNhanh)

ALTER TABLE KhachHang ADD
CONSTRAINT FK_KhachHang_ChiNhanh FOREIGN KEY (ChiNhanh) REFERENCES ChiNhanh(MaChiNhanh)

ALTER TABLE Nha ADD
CONSTRAINT FK_Nha_LoaiNha FOREIGN KEY (LoaiNha) REFERENCES LoaiNha(MaLoaiNha)

ALTER TABLE Nha ADD
CONSTRAINT FK_Nha_NhanVien FOREIGN KEY (NVQL) REFERENCES NhanVien(MaNhanVien)

ALTER TABLE Nha ADD
CONSTRAINT FK_Nha_ChiNhanh FOREIGN KEY (ChiNhanh) REFERENCES ChiNhanh(MaChiNhanh)

ALTER TABLE Nha ADD
CONSTRAINT FK_Nha_ChuNha FOREIGN KEY (ChuNhaHienTai) REFERENCES ChuNha(MaChuNha)

ALTER TABLE NhuCau_KH ADD
CONSTRAINT FK_NhuCau_KH_KhachHang FOREIGN KEY (MaKhachHang) REFERENCES KhachHang(MaKhachHang)

ALTER TABLE NhuCau_KH ADD
CONSTRAINT FK_NhuCau_KH_LoaiNha FOREIGN KEY (MaLoaiNha) REFERENCES LoaiNha(MaLoaiNha)

ALTER TABLE NhaDangLen_Thue ADD
CONSTRAINT FK_NhaDangLen_Thue_Nha FOREIGN KEY (MaNha) REFERENCES Nha(MaNha)

ALTER TABLE NhaDangLen_Thue ADD
CONSTRAINT FK_NhaDangLen_Thue_ChuNha FOREIGN KEY (MaChuNha) REFERENCES ChuNha(MaChuNha)

ALTER TABLE NhaDangLen_Ban ADD
CONSTRAINT FK_NhaDangLen_Ban_Nha FOREIGN KEY (MaNha) REFERENCES Nha(MaNha)

ALTER TABLE NhaDangLen_Ban ADD
CONSTRAINT FK_NhaDangLen_Ban_ChuNha FOREIGN KEY (MaChuNha) REFERENCES ChuNha(MaChuNha)

ALTER TABLE HopDongThueNha ADD
CONSTRAINT FK_HopDongThueNha_NhaDangLen_Thue 
	FOREIGN KEY (Nha, ChuNha, NgayDang) REFERENCES NhaDangLen_Thue(MaNha, MaChuNha, NgayDang)

ALTER TABLE HopDongThueNha ADD
CONSTRAINT FK_HopDongThueNha_KhachHang FOREIGN KEY (KhachHang) REFERENCES KhachHang(MaKhachHang)

ALTER TABLE HopDongBanNha ADD
CONSTRAINT FK_HopDongBanNha_NhaDangLen_Ban 
	FOREIGN KEY (Nha, ChuNha, NgayDang) REFERENCES NhaDangLen_Ban(MaNha, MaChuNha, NgayDang)

ALTER TABLE HopDongBanNha ADD
CONSTRAINT FK_HopDongBanNha_KhachHang FOREIGN KEY (KhachHang) REFERENCES KhachHang(MaKhachHang)

ALTER TABLE LichSuXemNha_Thue ADD
CONSTRAINT FK_LichSuXemNha_Thue_KhachHang FOREIGN KEY (MaKhachHang) REFERENCES KhachHang(MaKhachHang)

ALTER TABLE LichSuXemNha_Thue ADD
CONSTRAINT FK_LichSuXemNha_Thue_NhaDangLen_Thue FOREIGN KEY (MaNha, MaChuNha, NgayDang)
	REFERENCES NhaDangLen_Thue(MaNha, MaChuNha, NgayDang)

ALTER TABLE LichSuXemNha_Ban ADD
CONSTRAINT FK_LichSuXemNha_Ban_KhachHang FOREIGN KEY (MaKhachHang) REFERENCES KhachHang(MaKhachHang)

ALTER TABLE LichSuXemNha_Ban ADD
CONSTRAINT FK_LichSuXemNha_Ban_NhaDangLen_Ban FOREIGN KEY (MaNha, MaChuNha, NgayDang)
	REFERENCES NhaDangLen_Ban(MaNha, MaChuNha, NgayDang)


--==========================================================================================================
-- CÁC RBTV

-- 1. 
----- RBTV CHINHANH -----
-- khong the xoa chi nhanh

go
create trigger not_deleteChiNhanh
on ChiNhanh
for delete
as
begin
	raiserror (N'Lỗi: Khong the xoa Chi Nhanh', 16, 1)  
	rollback 
end

-- 2.
----- RBTV NHANVIEN -----
-- khong the xoa nhan vien
go
create trigger not_deleteNhanVien
on NhanVien
for delete
as
begin
	raiserror (N'Lỗi: Khong the xoa Nhan Vien', 16, 1)  
	rollback 
end
go

-- giới tính nhan vien la nam hoac nữ
alter table NhanVien add constraint C_GioiTinh Check(GioiTinh in('Nam',N'Nữ'))

-- tuổi nhân phải trong khoảng 18 - 60
alter table NhanVien add constraint C_Tuoi check(datediff(YYYY,NgaySinh,Getdate()) >=18 and datediff(YYYY,NgaySinh,Getdate()) <= 60)
﻿
-- 3. khong duoc xoa chu nha
go
create trigger not_deleteCN
on ChuNha
for delete
as
begin
	raiserror (N'Lỗi: Khong the xoa chu nha', 16, 1)  
	rollback 
end

go

-- 4.1 khong duoc xoa nha
create trigger not_deleteNha
on Nha
for delete
as
begin
	raiserror (N'Lỗi: Khong duoc xoa nha', 16, 1)  
	rollback 
end


--4.1 Gia tri tinh trang nha
go 
create trigger  gia_tri_TT
on Nha
for insert, update 
as 
if update(TinhTrangNha)
begin
	if not exists(select * from inserted where TinhTrangNha = N'Đã thuê' or TinhTrangNha = N'Đã bán' or TinhTrangNha = N'Còn trống')
	begin
		raiserror (N'Lỗi: Gia tri tinh trang nha khong phu hop', 16, 1)  
		rollback 
	end
end

--4.2 ngay het han nha dang len ban
go 
create trigger ngay_het_han
on NhaDangLen_Ban
for insert, update
as
if update(NgayHetHan)
begin
	if exists(select * from inserted where NgayHetHan < NgayDang)
	begin
		raiserror (N'Lỗi: Ngay het han phai sau ngay dang', 16, 1)  
		rollback 
	end
end
--nha dang len thue
go 
create trigger ngay_het_han_thue
on NhaDangLen_Thue
for insert, update
as
if update(NgayHetHan)
begin
	if exists(select * from inserted where NgayHetHan < NgayDang)
	begin
		raiserror (N'Lỗi: Ngay het han phai sau ngay dang', 16, 1)  
		rollback 
	end
end

go 
create trigger hop_dong
on Nha
for update
as
if update(TinhTrangNha)
begin
	if exists(select * from inserted i, HopDongBanNha hdb where i.MaNha = hdb.Nha)
	begin
		update Nha set TinhTrangNha = N'Đã bán'
	end
	if exists(select * from inserted i, HopDongThueNha hdt where i.MaNha = hdt.Nha)
	begin
	if(getdate() != (select hdt.NgayTra from inserted i, HopDongThueNha hdt where i.MaNha = hdt.Nha))
		begin
		update Nha set TinhTrangNha = N'Đã thuê'
		end
		else update Nha set TinhTrangNha = N'Còn trống'
	end
end

go 
create trigger capNhatNhaDLBan
on NhaDangLen_Ban
for update
as
if update(TinhTrangNha)
begin
	if exists(select * from inserted i, HopDongBanNha hdb where i.MaNha = hdb.Nha)
	begin
		update Nha set TinhTrangNha = N'Đã bán'
	end
	if exists(select * from inserted i, HopDongThueNha hdt where i.MaNha = hdt.Nha)
	begin
	if(getdate() != (select hdt.NgayTra from inserted i, HopDongThueNha hdt where i.MaNha = hdt.Nha))
		begin
		update Nha set TinhTrangNha = N'Đã thuê'
		end
	else update Nha set TinhTrangNha = N'Còn trống'
	end
end

	
-- 5. Khong xoa loai nha
create trigger no_delete_LoaiNha
on LoaiNha
for delete as
begin
	if exists (select * from deleted)
	begin
		raiserror(N'Không thể xóa loại nhà', 16, 1)
		rollback
	end
end

-- 6. Khong xoa khach hang
create trigger no_delete_KhachHang
on KhachHang
for delete as
begin
	if exists (select * from deleted)
	begin
		raiserror(N'Không thể xóa khách hàng', 16, 1)
		rollback
	end
end


-- 7. Lịch sử xem nhà thuê/bán
-- Chỉ được xem nhà trong khoảng thời gian có đăng bán hoặc thuê nhà.
-- Xem nhà trong khoảng thời gian bán nha.
create trigger trg_xem_nha_ban
on LichSuXemNha_Ban
for insert, update
as
if update(NgayXem)
begin
	declare @bat_dau datetime, @ket_thuc datetime, @ngay_xem datetime
	set @ngay_xem = (select NgayXem from inserted)
	set @bat_dau = (select NgayDang from inserted)
	set @ket_thuc = (select ndlb.NgayHetHan from NhaDangLen_Ban ndlb join inserted ist
						on ndlb.MaChuNha = ist.MaChuNha and ndlb.MaNha = ist.MaNha
						and ndlb.NgayDang = ist.NgayDang)

	if @ngay_xem < @bat_dau or @ngay_xem > @ket_thuc
	begin
		raiserror(N'Chỉ có thể xem nhà trong thời gian cho phép', 16, 1)
		rollback
	end
end

-- Xem nhà trong khoảng thời gian thuê nhà.
create trigger trg_xem_nha_thue
on LichSuXemNha_Thue
for insert, update
as
if update(NgayXem)
begin
	declare @bat_dau datetime, @ket_thuc datetime, @ngay_xem datetime
	set @ngay_xem = (select NgayXem from inserted)
	set @bat_dau = (select NgayDang from inserted)
	set @ket_thuc = (select ndlt.NgayHetHan from NhaDangLen_Thue ndlt join inserted ist
						on ndlt.MaChuNha = ist.MaChuNha and ndlt.MaNha = ist.MaNha
						and ndlt.NgayDang = ist.NgayDang)

	if @ngay_xem < @bat_dau or @ngay_xem > @ket_thuc
	begin
		raiserror(N'Chỉ có thể xem nhà trong thời gian cho phép', 16, 1)
		rollback
	end
end


-- 8. Hợp đồng thuê/bán
-- 8.1. Ngày nhận nhà sau ngày lập hợp đồng.
--Hợp đồng bán nhà
create trigger nhan_nha_sau_hop_dong1
on HopDongBanNha
for insert, update
as
if update(NgayNhan)
begin
	if exists (select * from HopDongBanNha where NgayNhan <= NgayLap)
	begin
		raiserror(N'Không thể nhận nhà trước khi lập hợp đồng', 16, 1)
		rollback
	end
end

--Hợp đồng thuê nhà
create trigger nhan_nha_sau_hop_dong2
on HopDongThueNha
for insert, update
as
if update(NgayNhan)
begin
	if exists (select * from HopDongThueNha where NgayNhan <= NgayLap)
	begin
		raiserror(N'Không thể nhận nhà trước khi lập hợp đồng', 16, 1)
		rollback
	end
end

-- 8.2. Khi trả nhà thì cập nhật lại tình trạng nhà là trống
create trigger trg_tra_nha
on HopDongThueNha
for insert, update
as
if update(NgayTra)
begin
	declare @ma_nha char(10), @ngay_tra datetime
	set @ma_nha = (select Nha from inserted)
	set @ngay_tra = (select NgayTra from inserted)

	if getdate() = @ngay_tra
	begin
		update Nha set TinhTrangNha = N'Còn Trống'
		where MaNha = @ma_nha
	end
end

-- 8.3. Khi lập hợp đồng mua nhà, kiểm tra Khách mua có là chủ nhà chưa,
--nếu chưa thì insert một chủ nhà mới với thông tin là thông tin của khách mua nhà
--và cập nhật lại Chủ nhà hiện tại của căn nhà là khách hàng vừa mua nhà.
create trigger trg_chu_nha_moi
on HopDongBanNha
for insert
as
begin
	declare @chu_moi char(10), @ma_nha char(10)
	set @chu_moi = (select KhachHang from inserted)
	set @ma_nha = (select Nha from inserted)
	if not exists (select * from ChuNha cn where MaChuNha = @chu_moi)
	begin
		insert into ChuNha
		select MaKhachHang, Ten_KhachHang, DiaChi_KhachHang, SDT_KhachHang
		from KhachHang where MaKhachHang = @chu_moi
	end
	update Nha set ChuNhaHienTai = @chu_moi, TinhTrangNha = N'Đã bán'
	where MaNha = @ma_nha
end

-- 9. Nhà đăng lên bán/thuê
-- 9.1. Khi đăng nhà bán/thuê thì cập nhật lại nhà là còn trống và cập nhật lại chủ nhà hiện tại.
--Đăng nhà bán
create trigger trg_cap_nhat_nha_khi_ban
on NhaDangLen_Ban
for insert
as
begin
	declare @ma_nha char(10), @chu_moi char(10)
	set @ma_nha = (select MaNha from inserted)
	set @chu_moi = (select MaChuNha from inserted)
	update Nha set TinhTrangNha = N'Còn trống', ChuNhaHienTai = @chu_moi
	where MaNha = @ma_nha
end

--Đăng nhà thuê
create trigger trg_cap_nhat_nha_khi_thue
on NhaDangLen_Thue
for insert
as
begin
	declare @ma_nha char(10), @chu_moi char(10)
	set @ma_nha = (select MaNha from inserted)
	set @chu_moi = (select MaChuNha from inserted)
	update Nha set TinhTrangNha = N'Còn trống', ChuNhaHienTai = @chu_moi
	where MaNha = @ma_nha
end

-- 9.2. Tại một thời điểm, một ngôi nhà chỉ có thể đăng một bài đăng cho thuê/ bán.
--> Phải đợi lần đăng bài trước đó hết hạn mới được đăng tiếp
--Đăng bán
create trigger trg_trung_bai_dang_ban
on NhaDangLen_Ban
for insert
as
begin
	declare @ngay_ket_thuc_dang datetime
	declare @ngay_het_han table(het_han datetime)
	declare @ngay_dang_moi datetime

	insert into @ngay_het_han
	select NgayHetHan from NhaDangLen_Ban where MaNha = (select MaNha from inserted)

	insert into @ngay_het_han
	select NgayHetHan from NhaDangLen_Thue where MaNha = (select MaNha from inserted)

	delete @ngay_het_han where het_han = (select NgayHetHan from inserted)

	set @ngay_ket_thuc_dang = (select max(het_han) from @ngay_het_han)
	set @ngay_dang_moi = (select NgayDang from inserted)

	if exists (select * from @ngay_het_han)
	begin
		if @ngay_dang_moi <= @ngay_ket_thuc_dang
		begin
			raiserror(N'Không thể đăng bán nhà lúc này', 16, 1)
			rollback
		end
	end
end

--Đăng thuê
create trigger trg_trung_bai_dang_thue
on NhaDangLen_Thue
for insert
as
begin
	declare @ngay_ket_thuc_dang datetime
	declare @ngay_het_han table(het_han datetime)
	declare @ngay_dang_moi datetime

	insert into @ngay_het_han
	select NgayHetHan from NhaDangLen_Ban where MaNha = (select MaNha from inserted)

	insert into @ngay_het_han
	select NgayHetHan from NhaDangLen_Thue where MaNha = (select MaNha from inserted)

	delete @ngay_het_han where het_han = (select NgayHetHan from inserted)

	set @ngay_ket_thuc_dang = (select max(het_han) from @ngay_het_han)
	set @ngay_dang_moi = (select NgayDang from inserted)

	if exists (select * from @ngay_het_han)
	begin
		if @ngay_dang_moi <= @ngay_ket_thuc_dang
		begin
			raiserror(N'Không thể đăng thuê nhà lúc này', 16, 1)
			rollback
		end
	end
end

-- 10. Lịch sử xem nhà
-- Số lượt xem nhà phải bằng tổng số lịch sử xem nhà.
-->Khi có khách hàng xem nhà thì tăng lượt xem lên 1
--Bán nhà
create trigger trg_luot_xem_nha_ban
on LichSuXemNha_Ban
for insert
as
begin
	declare @ma_nha char(10) = (select MaNha from inserted)
	declare @ma_chu_nha char(10) = (select MaChuNha from inserted)
	declare @ngay_dang datetime = (select NgayDang from inserted)

	update NhaDangLen_Ban set SoLuotXem = SoLuotXem + 1
	where MaNha = @ma_nha and MaChuNha = @ma_chu_nha and NgayDang = @ngay_dang
end

--Thuê nhà
create trigger trg_luot_xem_nha_thue
on LichSuXemNha_Thue
for insert
as
begin
	declare @ma_nha char(10) = (select MaNha from inserted)
	declare @ma_chu_nha char(10) = (select MaChuNha from inserted)
	declare @ngay_dang datetime = (select NgayDang from inserted)

	update NhaDangLen_Thue set SoLuotXem = SoLuotXem + 1
	where MaNha = @ma_nha and MaChuNha = @ma_chu_nha and NgayDang = @ngay_dang
end


--=================================================================================================
-- THÊM DỮ LIỆU CHO DATABASE
insert into ChiNhanh
values 
('CN001', N'297 Trần Hưng Đạo, Bình Khánh, An Giang', '4563853459', '0996976155'),
('CN002', N'113 Hải Yến, Móng Cái, Quảng Ninh', '1223508737', '1125651284'),
('CN003', N'349 Nguyễn Trọng Tuyến, Tân Bình, TpHCM', '2838440885', '5759196702')

insert into NhanVien
values 
('NV001', N'Vũ Thị Cúc', N'110 Hoa Cúc, Phú Nhuận, TpHCM', '9883006434', N'Nữ', '3/3/1987', 100, 1, 'CN001', 'NV006'),
('NV002', N'Khưu Thị Hạnh', N'16/47 Nguyễn Thiện Thuật, Quận 3, TpHCM', '84903944056', N'Nữ', '1/19/1982', 122, 1, 'CN002', 'NV007'),
('NV003', N'Huỳnh Thị Anh', N'372/1 Phạm Văn Hải, Tân Bình, TpHCM', '0997135573', N'Nữ', '8/25/1980', 131, 1, 'CN001', 'NV006'),
('NV004', N'Lưu Trọng Hiền', N'232 Bạch Đằng, Hải Châu, Đà Nẵng', '4904224665', N'Nam', '2/22/1997', 140, 1, 'CN003', 'NV008'),
('NV005', N'Tôn Xuân Trung', N'124 Thành Thái, Quận 10, TpHCM', '0947546660', N'Nam', '8/19/1986', 95, 1, 'CN003', 'NV008'),
('NV006', N'Lâm Thị Trinh', N'20 Tân Ấp, Ba Đình, Hà Nội', '8408290775', N'Nữ', '6/10/1967', 200, 1, 'CN001', NULL),
('NV007', N'Dâu Kim Kiều', N'17 Lê Lợi, Ngô Quyền, Hải Phòng', '3138442771', N'Nữ', '6/15/1969', 232, 1, 'CN002', NULL),
('NV008', N'Thái Hữu Chính', N'45/1 Bình Tiến, Quận 6, TpHCM', '8442517303', N'Nam', '2/1/1982', 210, 1, 'CN002', NULL),
('NV009', N'Viên Thị Kiều', N'223/6C Xô Viết Nghệ Tĩnh, Bình Thạnh, TpHCM', '8448751659', N'Nữ', '3/10/1990', 121, 1, 'CN001', 'NV006'),
('NV0010', N'Mạc Công Huy', N'99 Phú Thọ Hoa, Tân Phú, TpHCM', '9882906434', N'Nam', '3/7/1998', 160, 1, 'CN001', 'NV006'),
('NV0011', N'Thăng Thị Thi', N'423/48 Hoàng Văn Thụ, Tân Bình, TpHCM', '9183036434', N'Nữ', '5/15/1994', 108, 1, 'CN003', 'NV008'),
('NV0012', N'Tuấn Thị Loan', N'22 Phạm Văn Chương, Quận 7, TpHCM', '9843006434', N'Nữ', '9/28/1973', 70, 1, 'CN002', 'NV007'),
('NV0013', N'Lưu Văn Hưng', N'6E Tú Xương, Quận 3, TpHCM', '9883006523', N'Nam', '5/2/1972', 82, 1, 'CN002', 'NV007'),
('NV0014', N'Hà Đinh Huy', N'90/101 Nguyễn Huệ, Quận 1, TpHCM', '2344006111', N'Nam', '4/17/1995', 89, 1, 'CN003', 'NV008'),
('NV0015', N'Lê Thị Như', N'78 Bạch Đằng, Hai Châu, Đà Nẵng', '9223006434', N'Nữ', '2/11/1978', 109, 1, 'CN003', 'NV008'),
('NV0016', N'Giang Thị Mai', N'65/24 Tăng Nhơn Phú, Quận 9, TpHCM', '8100325434', N'Nữ', '11/21/1992', 125, 1, 'CN002', 'NV007'),
('NV0017', N'Kiến Xuân Hào', N'179 Nguyễn Văn Cừ, Ninh Kiều, Cần Thơ', '9853042232', N'Nam', '9/14/1969', 160, 0, 'CN001', 'NV006'),
('NV0018', N'Nguyễn Phú Quí', N'24 Tân Viên, Hồng Bàng, Hải Phòng', '3243532917', N'Nam', '2/2/1991', 140, 0, 'CN001', 'NV006'),
('NV0019', N'Mách Thị Như', N'1D Lý Tự Trọng, Hồng Bàng, Hải Phòng', '9343006324', N'Nữ', '6/13/1972', 89, 1, 'CN003', 'NV008'),
('NV0020', N'Ngụy Trọng Thảo', N'25/1 Lê Hồng Phong, Hai Châu, Đà Nẵng', '0123012634', N'Nam', '4/16/1969', 123, 1, 'CN003', 'NV008')

insert into KhachHang
values
('KH001', N'Quyện Đình Thanh', N'15 Đinh Bộ Lĩnh, Thủ Dầu Một, Bình Dương', '0653859418', 'CN001'),
('KH002', N'Trần Đình Phước', N'84 Hàng Mã, Hoàn Kiếm, Ha Nội', '0539021923', 'CN002'),
('KH003', N'Nghiêm Hữu Thảo', N'15 Tân Thuận, Quận 7, TpHCM', '0837701912', 'CN002'),
('KH004', N'Quách Thị Tâm', N'Phố Mới, Đông Nguyên, Bắc Ninh', '2413744710', 'CN002'),
('KH005', N'Trần Thị Hà', N'34 Nguyễn Du, Đà Lạt, Lâm Đồng', '8438115595', 'CN003'),
('KH006', N'Nguyễn Văn Trị', N'8/154 Lê Duẩn, Quảng Trị', '0827819373', 'CN003'),
('KH007', N'Dần Thị Linh', N'47 Nguyễn Văn Bá, Thủ Đức, TpHCM', '0837221817', 'CN003'),
('KH008', N'Chu Thị Việt', N'Đường số 8, Biên Hòa, Đồng Nai', '8461336413', 'CN001'),
('KH009', N'Thông Quang Đạt', N'87 Nguyễn Huệ, Quận 1, TpHCM', '8438218161', 'CN003'),
('KH0010', N'Dương Thị Thi', N'54 Vương Thừa Vụ, Thanh Xuân, Hà Nội', '8448586021', 'CN002'),
('KH0011', N'Phùng Hữu Cảnh', N'130/C12 Phạm Văn Hải, Tân BÌnh, TpHCM', '0838461272', 'CN002'),
('KH0012', N'Thanh Thị Mỹ', N'289 Hồng Bàng, Quận 5, TpHCM', '0938593589', 'CN001'),
('KH0013', N'Tiến Hồng Ước', N'12/75E 3 Tháng 2, Quận 11, TpHCM', '0839695954', 'CN001'),
('KH0014', N'Trạch Đinh Danh', N'412 Nguyễn Văn Cừ, Long Biên, Hà Nội', '3874222242', 'CN001'),
('KH0015', N'Trí Quang Quang', N'17 Tạ Uyên, Quận 5, TpHCM', '0838555942', 'CN003'),
('KH0016', N'Hàng Ngọc Viên', N'152/36/24 Lạc Long Quân, Quận 11, TpHCM', '0839630497', 'CN003'),
('KH0017', N'Lạc Thị Liêu', N'19D Trần Hưng Đạo, Long Xuyên , An Giang', '0333629251', 'CN002'),
('KH0018', N'Nhân Mạnh Huỳnh', N'703 Lê Thánh Tông, Hạ Long, Quảng Ninh', '0903834069', 'CN002'),
('KH0019', N'Nguyễn Nguyễn', N'61/2 Lạc Trung, Hai Bà Trưng, Hà Nội', '0438211898', 'CN001'),
('KH0020', N'Cân Đình Nhất', N'220 Cách Mạng Tháng Tám, Tân Bình, TpHCM', '8488460245', 'CN003')

insert into ChuNha
values 
('CH001', N'Ksor Đạt', N'41 Nguyễn Tri Phương, Thanh Khê, Đà Nẵng', '0728267243'),
('CH002', N'Nguyễn Hoàng Minh Tú', N'51 Trần Hưng Đạo, Hoàn Kiếm, Hà Nội', '0838457468'),
('CH003', N'Nguyễn Lê Ngọc Hải', N'67/6C Thanh Hoa, Trảng Bom, Đồng Nai', '0862921534'),
('CH004', N'Nguyễn Văn Long', N'78 Nguyễn Văn Cừ, Tân Lập, Dăk Lăk', '0138581870'),
('CH005', N'Hoàng Công Vinh', N'210 Trần Bình Trọng, Quận 5, TpHCM', '0991591088'),
('CH006', N'Tạ Hoài Nam', N'45D/25 Đường D5, Bình Thạnh, TpHCM', '8438311475'),
('CH007', N'Uông Bích Trâm', N'167/10 Nguyễn Chí Thanh, Quận 5, TpHCM', '0845735897'),
('CH008', N'Nguyễn Hạ Du', N'170 quốc lộ 1, Tân An, Long An', '0013891423'),
('CH009', N'Trần Công Nam', N'268 Trần Hưng Đạo, Nghĩa Lò, Quảng Ngãi', '8436281334'),
('CH010', N'Lê Đại Hải', N'129 Huỳnh Văn Bảnh, Phú Nhuận, TpHCM', '0603864124')

insert into LoaiNha
values 
('NCC', N'Nhà chung cư'),
('NTM', N'Nhà thương mai'),
('NRL', N'Nhà ở riêng lẻ')

insert into Nha(MaNha, SoNha, Quan, TP, KhuVuc, SoLuongPhong, LoaiNha, NVQL, ChiNhanh, ChuNhaHienTai)
values('NA001', N'714 Hoàng Hoa Thám', N'Tây Hồ', N'Hà Nội', N'Bắc Bộ', 4, 'NTM', 'NV001', 'CN001', 'CH001'),
('NA002', N'503 Lê Quang Định', N'Gò Vấp', N'Hồ Chí Minh', N'Nam Bộ', 3, 'NRL', 'NV002', 'CN002', 'CH002'),
('NA003', N'Số 7 Ngô Xuân Quang', N'Gia Lâm', N'Hà Nội', N'Bắc Bộ', 4, 'NRL', 'NV001', 'CN001', 'CH004'),
('NA004', N'81A/36 Thoại Ngọc Hầu', N'Tân Phú', N'Hồ Chí Minh', N'Nam Bộ', 2, 'NRL', 'NV003', 'CN001', 'CH005'),
('NA005', N'123 Hoàng Văn Thụ', N'Phú Nhuận', N'Hồ Chí Minh', N'Nam Bộ', 5, 'NTM', 'NV004', 'CN003', 'CH006'),
('NA006', N'36 Lê Thánh Tôn', N'Tân Lập', N'Khánh Hòa', N'Bắc Bộ', 6, 'NCC', 'NV005', 'CN003', 'CH005'),
('NA007', N'389 Trương Định', N'Hai Bà Trưng', N'Hà Nội', N'Bắc Bộ', 6, 'NCC', 'NV009', 'CN001', 'CH003'),
('NA008', N'414 Lê Văn Sỹ', N'Tân Bình', N'Hồ Chí Minh', N'Nam Bộ', 3, 'NTM', 'NV0010', 'CN001', 'CH007'),
('NA009', N'66 Trần Hưng Đạo', N'Hoàn Kiếm', N'Hà Nội', N'Bắc Bộ', 2, 'NRL', 'NV0011', 'CN003', 'CH003'),
('NA010', N'467 Linh Nam', N'Hoàng Mai', N'Hà Nội', N'Bắc Bộ', 4, 'NTM', 'NV0011', 'CN003', 'CH009'),
('NA011', N'69/11 Phạm Văn Chiểu', N'Gò Vấp', N'Hồ Chí Minh', N'Nam Bộ', 4, 'NTM', 'NV0012', 'CN002', 'CH002'),
('NA012', N'259 Trần Hưng Đạo', N'Văn Giang', N'Ninh Bình', N'Trung Bộ', 4, 'NCC', 'NV0012', 'CN002', 'CH008'),
('NA013', N'149 Văn Cao', N'Ngô Quyền', N'Hải Phòng', N'Bắc Bộ', 5, 'NCC', 'NV0012', 'CN002', 'CH010'),
('NA014', N'24 Hàng Bè', N'Hoàn Kiếm', N'Hà Nội', N'Bắc Bộ', 3, 'NRL', 'NV0017', 'CN001', 'CH003')

insert into NhuCau_KH
values('KH001', 'NCC', N'Vị trí thuận lợi', 0),
('KH002', 'NCC', N'Giá hợp lý', 0),
('KH003', 'NRL', N'Nội thất đầy đủ', 1),
('KH004', 'NRL', N'An ninh tốt', 1),
('KH005', 'NTM', N'Diện tích rộng', 0),
('KH006', 'NRL', N'Đảm bảo pháp lý', 1),
('KH007', 'NCC', N'Môi trường sạch', 1),
('KH008', 'NTM', N'Gần trường học', 1),
('KH009', 'NTM', N'Hàng xóm thân thiện', 0),
('KH0010', 'NTM', N'Trung tâm thành phố', 0),
('KH0011', 'NCC', N'Nội thất đầy đủ', 0),
('KH0012', 'NCC', N'Đảm bảo pháp lý', 0),
('KH0013', 'NCC', N'Hàng xóm thân thiện', 0),
('KH0014', 'NRL', N'Vị trí thuận lợi', 1),
('KH0015', 'NCC', N'An ninh tốt', 0),
('KH0016', 'NRL', N'Giá hợp lý', 1),
('KH0017', 'NTM', N'Môi trường sạch', 0),
('KH0018', 'NTM', N'Diện tích rộng', 0),
('KH0019', 'NTM', N'Gần trường học', 0),
('KH0020', 'NCC', N'Trung tâm thành phố', 1)

insert into NhaDangLen_Thue(MaNha, MaChuNha, NgayDang, NgayHetHan, GiaThue)
values('NA001', 'CH001', '1-1-2017', '2-1-2017', 30)
insert into NhaDangLen_Thue(MaNha, MaChuNha, NgayDang, NgayHetHan, GiaThue)
values('NA004', 'CH005', '6/5/2017', '7/5/2017', 15)
insert into NhaDangLen_Thue(MaNha, MaChuNha, NgayDang, NgayHetHan, GiaThue)
values('NA001', 'CH001', '7/18/2017', '8/18/2017', 30)
insert into NhaDangLen_Thue(MaNha, MaChuNha, NgayDang, NgayHetHan, GiaThue)
values('NA004', 'CH005', '7/10/2017', '8/10/2017', 15)
insert into NhaDangLen_Thue(MaNha, MaChuNha, NgayDang, NgayHetHan, GiaThue)
values('NA001', 'CH001', '10/10/2019', '11/10/2019', 35)
insert into NhaDangLen_Thue(MaNha, MaChuNha, NgayDang, NgayHetHan, GiaThue)
values('NA002', 'CH002', '3/24/2018', '4/24/2018', 22)
insert into NhaDangLen_Thue(MaNha, MaChuNha, NgayDang, NgayHetHan, GiaThue)
values('NA005', 'CH006', '3/15/2018', '4/15/2018', 40)
insert into NhaDangLen_Thue(MaNha, MaChuNha, NgayDang, NgayHetHan, GiaThue)
values('NA005', 'CH006', '4/28/2018', '5/28/2018', 37)
insert into NhaDangLen_Thue(MaNha, MaChuNha, NgayDang, NgayHetHan, GiaThue)
values('NA008', 'CH007', '10/12/2019', '11/12/2019', 22)
insert into NhaDangLen_Thue(MaNha, MaChuNha, NgayDang, NgayHetHan, GiaThue)
values('NA010', 'CH009', '5/5/2019', '6/5/2019', 32)
insert into NhaDangLen_Thue(MaNha, MaChuNha, NgayDang, NgayHetHan, GiaThue)
values('NA011', 'CH002', '11/8/2020', '12/8/2020', 35)
insert into NhaDangLen_Thue(MaNha, MaChuNha, NgayDang, NgayHetHan, GiaThue)
values('NA012', 'CH008', '6/6/2020', '7/6/2020', 45)
insert into NhaDangLen_Thue(MaNha, MaChuNha, NgayDang, NgayHetHan, GiaThue)
values('NA012', 'CH008', '7/7/2020', '8/7/2020', 40)


insert into NhaDangLen_Ban 
values('NA003', 'CH004', '2/13/2019', '3/13/2019', NULL, 1700, NULL)
insert into NhaDangLen_Ban 
values('NA003', 'CH004', '8/21/2019', '9/21/2019', NULL, 1500, NULL)
insert into NhaDangLen_Ban 
values('NA006', 'CH005', '4/15/2018', '5/15/2018', NULL, 2500, NULL)
insert into NhaDangLen_Ban 
values('NA007', 'CH003', '12/30/2019', '1/30/2020', NULL, 2700, NULL)
insert into NhaDangLen_Ban 
values('NA009', 'CH003', '12/12/2019', '1/12/2020', NULL, 750, NULL)
insert into NhaDangLen_Ban 
values('NA009', 'CH003', '11/1/2020', '12/1/2020', NULL, 720, NULL)
insert into NhaDangLen_Ban 
values('NA013', 'CH010', '3/16/2020', '4/16/2020', NULL, 2200, NULL)
insert into NhaDangLen_Ban
values('NA014', 'CH003', '2/1/2020', '3/1/2020', NULL, 1800, NULL)
insert into NhaDangLen_Ban 
values('NA014', 'CH003', '5/22/2020', '6/22/2020', NULL, 1800, NULL)
insert into NhaDangLen_Ban 
values('NA014', 'CH003', '10/29/2020', '11/29/2020', NULL, 1700, NULL)

insert into LichSuXemNha_Ban
values('KH006', 'NA003', 'CH004', '8/21/2019', '8/27/2019', 'Good')
insert into LichSuXemNha_Ban
values('KH0020', 'NA006', 'CH005', '4/15/2018', '4/23/2018', N'không gian nhỏ hơn tôi nghĩ')
insert into LichSuXemNha_Ban
values('KH007', 'NA006', 'CH005', '4/15/2018', '5/11/2018', N'hài lòng')
insert into LichSuXemNha_Ban
values('KH007', 'NA007', 'CH003', '12/30/2019', '12/31/2019', N'rất hài lòng')
insert into LichSuXemNha_Ban
values('KH0020', 'NA013', 'CH010', '3/16/2020', '3/17/2020', N'không gian nhỏ hơn tôi nghĩ')
insert into LichSuXemNha_Ban
values('KH006', 'NA014', 'CH003', '2/1/2020', '2/12/2020', N'nhà này thiếu cái gì đó')
insert into LichSuXemNha_Ban
values('KH006', 'NA014', 'CH003', '2/1/2020', '2/13/2020', N'mặt tiền cần cải thiện')
insert into LichSuXemNha_Ban
values('KH006', 'NA014', 'CH003', '2/1/2020', '2/28/2020', NULL)

insert into LichSuXemNha_Thue
values('KH0017', 'NA010', 'CH009', '5/5/2019', '5/25/2019', N'nhà rất thích hợp với yêu cầu của tôi')
insert into LichSuXemNha_Thue
values('KH0012', 'NA012', 'CH008', '7/7/2020', '7/10/2020', N'đầy đủ tiện nghi')
insert into LichSuXemNha_Thue
values('KH009', 'NA001', 'CH001', '1/1/2017', '1/10/2017', NULL)
insert into LichSuXemNha_Thue
values('KH0010', 'NA001', 'CH001', '7/18/2017', '7/20/2017', N'kiến trúc căn nhà không phù hợp với tôi')
insert into LichSuXemNha_Thue
values('KH0018', 'NA001', 'CH001', '7/18/2017', '7/28/2017', N'tôi rất thích phong cách cổ điển của ngôi nhà')
insert into LichSuXemNha_Thue
values('KH005', 'NA005', 'CH006', '3/15/2018', '3/27/2018', N'bad')
insert into LichSuXemNha_Thue
values('KH0019', 'NA005', 'CH006', '3/15/2018', '4/11/2018', N'so bad')
insert into LichSuXemNha_Thue
values('KH005', 'NA008', 'CH007', '10/12/2019', '10/29/2019', N'không gian rất tuyệt')

insert into HopDongThueNha 
values('HD001', '1/12/2017', '1/14/2017', 30, 15, '7/14/2017', 'NA001', 'CH001', '1/1/2017', 'KH009')
insert into HopDongThueNha 
values('HD003', '10/29/2019', '10/31/2019', 22, 11, '10/31/2020', 'NA008', 'CH007', '10/12/2019', 'KH005')

insert into HopDongBanNha
values ('HD001', '8/30/2019', '8/31/2019', 1500, 'NA003', 'CH004', '8/21/2019', 'KH006')
insert into HopDongBanNha
values ('HD002', '5/12/2018', '5/13/2018', 2500, 'NA006', 'CH005', '4/15/2018', 'KH007')
insert into HopDongBanNha
values ('HD003', '1/1/2020', '1/3/2020', 2700, 'NA007', 'CH003', '12/30/2019', 'KH007')