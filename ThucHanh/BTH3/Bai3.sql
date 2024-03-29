use QUANLYGIAOVU;

-------------------------Bai tap phan III------------------------------

--6
SELECT DISTINCT TENMH
FROM MONHOC JOIN GIANGDAY 
ON MONHOC.MAMH = GIANGDAY.MAMH
JOIN GIAOVIEN 
ON GIAOVIEN.MAGV = GIANGDAY.MAGV
WHERE GIAOVIEN.HOTEN = 'Tran Tam Thanh'
	AND GIANGDAY.HOCKY = 1 
	AND GIANGDAY.NAM = 2006;

--7
SELECT DISTINCT MONHOC.MAMH, TENMH
FROM MONHOC JOIN GIANGDAY
ON MONHOC.MAMH = GIANGDAY.MAMH
JOIN LOP 
ON LOP.MAGVCN = GIANGDAY.MAGV
WHERE LOP.MALOP = 'K11'
	AND GIANGDAY.HOCKY = 1 
	AND GIANGDAY.NAM = 2006;

--8
SELECT DISTINCT HO, TEN 
FROM HOCVIEN JOIN LOP
ON HOCVIEN.MAHV = LOP.TRGLOP
JOIN GIANGDAY
ON GIANGDAY.MAGV = LOP.MAGVCN
JOIN GIAOVIEN
ON GIAOVIEN.MAGV = GIANGDAY.MAGV
JOIN MONHOC
ON MONHOC.MAMH = GIANGDAY.MAMH
WHERE HOTEN = 'Nguyen To Lan'
	AND TENMH = 'Co So Du Lieu';

--9
SELECT MAMH, TENMH
FROM MONHOC
WHERE MAMH IN (
SELECT MAMH_TRUOC
FROM DIEUKIEN
WHERE MAMH = (
SELECT MAMH
FROM MONHOC
WHERE TENMH = 'Co So Du Lieu'));

--10
SELECT MAMH, TENMH
FROM MONHOC
WHERE MAMH IN (
    SELECT MAMH
    FROM DIEUKIEN
    WHERE MAMH_TRUOC = (
        SELECT MAMH
        FROM MONHOC
        WHERE TENMH = 'Cau Truc Roi Rac'
    )
);
