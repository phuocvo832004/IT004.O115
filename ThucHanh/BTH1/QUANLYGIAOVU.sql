﻿-- Tao DATABASE QUANLYGIAOVU
CREATE DATABASE QUANLYGIAOVU

--Chuyen den DATABASE
use QUANLYGIAOVU

-- Tạo bảng KHOA
CREATE TABLE KHOA (
    MAKHOA varchar(4) PRIMARY KEY,
    TENKHOA varchar(40),
    NGTLAP smalldatetime,
    TRGKHOA char(4)
);

-- Tạo bảng MONHOC
CREATE TABLE MONHOC (
    MAMH varchar(10) PRIMARY KEY,
    TENMH varchar(40),
    TCLT tinyint,
    TCTH tinyint,
    MAKHOA varchar(4),
    FOREIGN KEY (MAKHOA) REFERENCES KHOA(MAKHOA)
);

-- Tạo bảng DIEUKIEN
CREATE TABLE DIEUKIEN (
    MAMH varchar(10),
    MAMH_TRUOC varchar(10),
    PRIMARY KEY (MAMH, MAMH_TRUOC),
    FOREIGN KEY (MAMH) REFERENCES MONHOC(MAMH),
    FOREIGN KEY (MAMH_TRUOC) REFERENCES MONHOC(MAMH)
);

-- Tạo bảng GIAOVIEN
CREATE TABLE GIAOVIEN (
    MAGV char(4) PRIMARY KEY,
    HOTEN varchar(40),
    HOCVI varchar(10),
    HOCHAM varchar(10),
    GIOITINH varchar(3),
    NGSINH smalldatetime,
    NGVL smalldatetime,
    HESO numeric(4,2),
    MUCLUONG money,
    MAKHOA varchar(4),
    FOREIGN KEY (MAKHOA) REFERENCES KHOA(MAKHOA)
);

-- Tạo bảng LOP
CREATE TABLE LOP (
    MALOP char(3) PRIMARY KEY,
    TENLOP varchar(40),
    TRGLOP char(5),
    SISO tinyint,
    MAGVCN char(4),
    FOREIGN KEY (MAGVCN) REFERENCES GIAOVIEN(MAGV)
);

-- Tạo bảng HOCVIEN
CREATE TABLE HOCVIEN (
    MAHV char(5) PRIMARY KEY,
    HO varchar(40),
    TEN varchar(10),
    NGSINH smalldatetime,
    GIOITINH varchar(3),
    NOISINH varchar(40),
    MALOP char(3),
    FOREIGN KEY (MALOP) REFERENCES LOP(MALOP)
);

-- Tạo bảng GIANGDAY
CREATE TABLE GIANGDAY (
    MALOP char(3),
    MAMH varchar(10),
    MAGV char(4),
    HOCKY tinyint,
    NAM smallint,
    TUNGAY smalldatetime,
    DENNGAY smalldatetime,
    PRIMARY KEY (MALOP, MAMH, MAGV, HOCKY, NAM),
    FOREIGN KEY (MALOP) REFERENCES LOP(MALOP),
    FOREIGN KEY (MAMH) REFERENCES MONHOC(MAMH),
    FOREIGN KEY (MAGV) REFERENCES GIAOVIEN(MAGV)
);

-- Tạo bảng KETQUATHI
CREATE TABLE KETQUATHI (
    MAHV char(5),
    MAMH varchar(10),
    LANTHI tinyint,
    NGTHI smalldatetime,
    DIEM numeric(4,2),
    KQUA varchar(10),
    PRIMARY KEY (MAHV, MAMH, LANTHI, NGTHI),
    FOREIGN KEY (MAHV) REFERENCES HOCVIEN(MAHV),
    FOREIGN KEY (MAMH) REFERENCES MONHOC(MAMH)
);

-------------------------Bai tap phan I------------------------------

-- 1.
-- Thêm các cat mai vào bang HOCVIEN
ALTER TABLE HOCVIEN
ADD GHICHU NVARCHAR(255),
DIEMTB DECIMAL(2, 2),
XEPLOAI NVARCHAR(20);

-- Ðat cac rang buoc cho cac khoa chinh va khoa ngoai
ALTER TABLE HOCVIEN
ADD CONSTRAINT PK_HOCVIEN PRIMARY KEY (MAHV),
CONSTRAINT FK_HOCVIEN_LOP FOREIGN KEY (MALOP) REFERENCES LOP(MALOP);

-- 2
-- Tạo thuộc tính MAHV theo quy tắc
UPDATE HOCVIEN
SET MAHV = CONCAT(MALOP, RIGHT('00' + CAST(ROW_NUMBER() OVER (PARTITION BY MALOP ORDER BY MAHV) AS VARCHAR(2)), 2));



-- 3
ALTER TABLE HOCVIEN
ADD CONSTRAINT CHK_GIOITINH CHECK (GIOITINH IN ('Nam', 'Nu'));

-- 4
ALTER TABLE KETQUATHI
ADD CONSTRAINT CHK_DIEM CHECK (DIEM >= 0 AND DIEM <= 10);

-- 5
UPDATE KETQUATHI
SET KQUA = CASE
    WHEN DIEM >= 5 THEN 'Dat'
    ELSE 'Khong dat'
END;

-- 6
ALTER TABLE KETQUATHI
ADD CONSTRAINT CHK_LANTHI CHECK (LANTHI >= 1 AND LANTHI <= 3);

-- 7
ALTER TABLE GIANGDAY
ADD CONSTRAINT CHK_HOCKY CHECK (HOCKY >= 1 AND HOCKY <= 3);

-- 8
ALTER TABLE GIAOVIEN
ADD CONSTRAINT CHK_HOCVI CHECK (HOCVI IN ('CN', 'KS', 'Ths', 'TS', 'PTS'));