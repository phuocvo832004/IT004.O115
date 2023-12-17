-- Tao database QUANLYBANHANG
CREATE DATABASE QUANLYBANHANG;

-- Su dung database QUANLYBANHANG
USE QUANLYBANHANG;

-- Tao bang KHACHHANG
CREATE TABLE KHACHHANG (
    MAKH INT PRIMARY KEY,
    HOTEN NVARCHAR(255),
    DCHI NVARCHAR(255),
    SODT NVARCHAR(20),
    NGSINH DATE,
    DOANHSO DECIMAL(18, 2),
    NGDK DATE
);

-- Tao bang NHANVIEN
CREATE TABLE NHANVIEN (
    MANV INT PRIMARY KEY,
    HOTEN NVARCHAR(255),
    NGVL DATE,
    SODT NVARCHAR(20)
);

-- Tao bang SANPHAM
CREATE TABLE SANPHAM (
    MASP INT PRIMARY KEY,
    TENSP NVARCHAR(255),
    DVT NVARCHAR(20),
    NUOCSX NVARCHAR(50),
    GIA DECIMAL(18, 2)
);

-- Tao bang HOADON
CREATE TABLE HOADON (
    SOHD INT PRIMARY KEY,
    NGHD DATE,
    MAKH INT,
    MANV INT,
    TRIGIA DECIMAL(18, 2),
    FOREIGN KEY (MAKH) REFERENCES KHACHHANG(MAKH),
    FOREIGN KEY (MANV) REFERENCES NHANVIEN(MANV)
);

-- Tao bang CTHD
CREATE TABLE CTHD (
    SOHD INT,
    MASP INT,
    SL INT,
    PRIMARY KEY (SOHD, MASP),
    FOREIGN KEY (SOHD) REFERENCES HOADON(SOHD),
    FOREIGN KEY (MASP) REFERENCES SANPHAM(MASP)
);

-------------------------Bai tap phan I------------------------------

-- 2
ALTER TABLE SANPHAM
ADD GHICHU VARCHAR(20);

-- 3
ALTER TABLE KHACHHANG
ADD LOAIKH TINYINT;

-- 4
ALTER TABLE SANPHAM
ALTER COLUMN GHICHU VARCHAR(100);

-- 5
ALTER TABLE SANPHAM
DROP COLUMN GHICHU;

-- 6
ALTER TABLE KHACHHANG
ADD CONSTRAINT CHK_LOAIKH
CHECK (LOAIKH IN ('Vang lai', 'Thuong xuyen', 'Vip'));

-- 7
ALTER TABLE SANPHAM
ADD CONSTRAINT CHK_DONVITINH
CHECK (DVT IN ('cay', 'hop', 'cai', 'quyen', 'chuc'));

-- 8
ALTER TABLE SANPHAM
ADD CONSTRAINT CHK_GIABAN
CHECK (GIA >= 500);

-- 9 
ALTER TABLE CTHD
ADD CONSTRAINT CHK_SOLUONG CHECK ( SL >= 1 );

-- 10
ALTER TABLE KHACHHANG
ADD CONSTRAINT CHK_NGDK CHECK (NGDK >= NGSINH);