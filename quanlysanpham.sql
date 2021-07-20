create database quanlysanpham;
use quanlysanpham;

create table khachhang (
makh int primary key,
tenkh nvarchar(50),
diachi nvarchar(50),
sdt int (10)
);

create table sanpham (
masp int primary key,
tensp nvarchar (50),
gia double
);

create table hoadon (
mahd int primary key,
ngaylap date,
tongtien double,
makh int,
foreign key (makh) references khachhang(makh)
);
drop table hoadon;
drop table chitiethoadon;
create table chitiethoadon (
id int primary key,
mahd int,
masp int,
soluong int,
giaban double,
foreign key (mahd) references hoadon(mahd),
foreign key (masp) references sanpham(masp)
);

insert into khachhang
values (1,'Tuan','Lang Son',0347183456),
 (2,'Toan','Ha Noi',0344583456),
 (3,'Hoang','Lang Son',034883456);
 
 insert into sanpham
 values (1,'Máy giặt',500),
  (2,'Ti vi',200),
  (3,'Tủ lạnh',400);
  
  insert into hoadon
  values (1,'2006-06-19',300,2),
   (2,'2006-06-20',500,3),
   (3,'2006-06-19',600,1);
   
   insert into chitiethoadon
   values (1,1,3,4,400),
		(2,2,2,5,200),
		(3,3,1,3,500);

-- 6. In ra các số hóa đơn, trị giá hóa đơn bán ra trong ngày 19/6/2006 và ngày 20/6/2006.
select mahd,ngaylap,tongtien
from hoadon inner join chitiethoadon on hoadon.mahd = chitiethoadon.mahd
where ngaylap between '2006-06-19' and '2006-06-21'
;

-- 7. In ra các số hóa đơn, trị giá hóa đơn trong tháng 6/2007, sắp xếp theo ngày (tăng dần) và trị giácủa hóa đơn (giảm dần).
select mahd, tongtien, ngaylap
from hoadon 
inner join chitiethoadon on  hoadon.mahd = chitiethoadon.mahd
where ngaylap between '2006-06-01' and '2006-07-01'
order by tongtien desc, ngaylap asc;

-- 8. In ra danh sách các khách hàng (MAKH, HOTEN) đã mua hàng trong ngày 19/06/2007
select khachhang.makh, khachhang.tenkh
from khachhang
inner join hoadon on khachhang.makh = hoadon.makh
where ngaylap = '2006-06-19';

-- 10. In ra danh sách các sản phẩm (MASP,TENSP) được khách hàng có tên “Nguyen Van A” mua trong tháng 10/2006.
select sanpham.masp, sanpham.tensp,khachhang.tenkh
from sanpham
inner join chitiethoadon on sanpham.masp = chitiethoadon.masp
inner join hoadon on chitiethoadon.mahd = hoadon.mahd
inner join khachhang on hoadon.makh = khachhang.makh
where (khachhang.tenkh like '%T%') and (ngaylap between '2006-06-19' and '2006-06-20');

-- 11. Tìm các số hóa đơn đã mua sản phẩm “Máy giặt” hoặc “Tủ lạnh”.
select hoadon.ngaylap, hoadon.mahd,sanpham.tensp,soluong
from hoadon
inner join chitiethoadon on hoadon.mahd = chitiethoadon.mahd
inner join sanpham on chitiethoadon.masp = sanpham.masp
where tensp like '%Tủ lạnh%' or tensp like '%Máy giặt%'
group by hoadon.mahd

-- 12. Tìm các số hóa đơn đã mua sản phẩm “Máy giặt” hoặc “Tủ lạnh”, mỗi sản phẩm mua với số lượng từ 10 đến 20.
select hoadon.ngaylap, hoadon.mahd,sanpham.tensp,soluong
from hoadon
inner join chitiethoadon on hoadon.mahd = chitiethoadon.mahd
inner join sanpham on chitiethoadon.masp = sanpham.masp
where tensp like '%Tủ lạnh%' or tensp like '%Máy giặt%'
group by hoadon.mahd
having soluong between 1 and 4;

-- Tìm các số hóa đơn mua cùng lúc 2 sản phẩm “Máy giặt” và “Tủ lạnh”, mỗi sản phẩm mua với số lượng từ 10 đến 20.
select hoadon.ngaylap, hoadon.mahd,sanpham.tensp,soluong
from hoadon
inner join chitiethoadon on hoadon.mahd = chitiethoadon.mahd
inner join sanpham on chitiethoadon.masp = sanpham.masp
where tensp like '%Tủ lạnh%' and tensp like '%Máy giặt%'
group by hoadon.mahd
having soluong between 1 and 4;

-- 15. In ra danh sách các sản phẩm (MASP,TENSP) không bán được.
select sanpham.masp, sanpham.tensp
from sanpham
left join chitiethoadon on sanpham.masp = chitiethoadon.masp
left join hoadon on chitiethoadon.mahd = hoadon.mahd
left join khachhang on hoadon.makh = khachhang.makh
where sanpham.masp not in (select sanpham.masp from chitiethoadon 
inner join sanpham on chitiethoadon.masp = sanpham.masp);

-- 16. In ra danh sách các sản phẩm (MASP,TENSP) không bán được trong năm 2006.
select sanpham.masp, sanpham.tensp
from sanpham
left join chitiethoadon on sanpham.masp = chitiethoadon.masp
left join hoadon on chitiethoadon.mahd = hoadon.mahd
left join khachhang on hoadon.makh = khachhang.makh
having sanpham.masp not in (select chitiethoadon.id from chitiethoadon 
inner join sanpham on chitiethoadon.masp = sanpham.masp
inner join hoadon on chitiethoadon.mahd = hoadon.mahd 
where year(ngaylap) = 2006);

-- 17. In ra danh sách các sản phẩm (MASP,TENSP) có giá >300 sản xuất bán được trong năm 2006.
select sanpham.masp, sanpham.tensp,sanpham.gia
from sanpham
left join chitiethoadon on sanpham.masp = chitiethoadon.masp
left join hoadon on chitiethoadon.mahd = hoadon.mahd
left join khachhang on hoadon.makh = khachhang.makh
where year(ngaylap) = 2006 and sanpham.gia > 300







