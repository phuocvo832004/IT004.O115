use QUANLYGIAOVU;
go
-------------------------Bai tap phan I--------------------------------

--9
--trigger dam bao lop truong phai thuoc lop do khi insert, update thong tin lop
CREATE TRIGGER TRG_IU_LOP ON LOP
FOR INSERT, UPDATE 
AS 
BEGIN 
    IF NOT EXISTS (
        SELECT *
        FROM inserted, HOCVIEN
        WHERE inserted.MALOP = HOCVIEN.MALOP
        AND TRGLOP = MAHV
    ) 
    BEGIN 
        PRINT 'Lop truong cua 1 lop phai thuoc lop do.'
        ROLLBACK TRANSACTION 
    END 
END 
go

--trigger dam bao khong duoc xoa lop truong khi xoa mot hoc vien
CREATE TRIGGER TRG_DEL_MALOP ON HOCVIEN
FOR DELETE 
AS 
BEGIN 
    IF EXISTS (
        SELECT *
        FROM deleted, LOP
        WHERE deleted.MALOP = LOP.MALOP
        AND deleted.MAHV = TRGLOP
    ) 
    BEGIN 
        PRINT 'ERROR: Khong duoc xoa lop truong.'
        ROLLBACK TRANSACTION 
    END 
END 
go

--10
--trigger dam bao truong khoa phai la giao vien co hoc vi TS hoac PTS khi insert, update thong tin khoa
CREATE TRIGGER TRG_IU_KHOA ON KHOA
FOR INSERT, UPDATE 
AS 
BEGIN 
    IF NOT EXISTS (
        SELECT *
        FROM inserted, GIAOVIEN
        WHERE TRGKHOA = MAGV
        AND HOCVI IN ('TS', 'PTS')
        AND inserted.MAKHOA = GIAOVIEN.MAKHOA
    ) 
    BEGIN 
        PRINT 'ERROR: Thong tin khong hop le.'
        ROLLBACK TRANSACTION 
    END 
END 
go

--trigger dam bao thong tin truong khoa hop le khi insert, update thong tin giao vien
CREATE TRIGGER TRG_UPD_GV ON GIAOVIEN
FOR UPDATE 
AS 
BEGIN 
    IF (UPDATE(HOCVI) OR UPDATE(MAKHOA)) 
    BEGIN 
        IF EXISTS (
            SELECT *
            FROM inserted, KHOA
            WHERE TRGKHOA = MAGV
            AND (HOCVI NOT IN ('PTS', 'TS') OR inserted.MAKHOA <> KHOA.MAKHOA)
        ) 
        BEGIN 
            PRINT 'ERROR: Thong tin khong hop le.'
            ROLLBACK TRANSACTION 
        END 
    END 
END 
go

--15
--trigger dam bao hoc sinh phai hoan thanh mon hoc truoc khi thi
CREATE TRIGGER KETQUATHI_INSERT ON KETQUATHI
FOR INSERT 
AS 
BEGIN 
    IF NOT EXISTS (
        SELECT *
        FROM INSERTED, HOCVIEN, GIANGDAY, LOP
        WHERE HOCVIEN.MAHV = INSERTED.MAHV
        AND GIANGDAY.MAMH = inserted.MAMH
        AND GIANGDAY.MALOP = LOP.MALOP
        AND HOCVIEN.MALOP = LOP.MALOP
        AND DENNGAY < NGTHI
    ) 
    BEGIN 
        PRINT 'ERROR: Hoc vien chua hoc xong mon.'
        ROLLBACK TRANSACTION 
    END 
END 
go

--16
--trigger dam bao 1 hoc ki 1 lop chi duoc hoc toi da 3 mon khi insert, update thong tin giang day
CREATE TRIGGER TRG_GIANGDAY_COUNTMAMH_INS_UPD ON GIANGDAY
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @MALOP CHAR(3), @TongSoMH SMALLINT, @HOCKY TINYINT, @NAM SMALLINT
	SELECT @MALOP = MALOP, @HOCKY = HOCKY, @NAM = NAM
	FROM INSERTED

	SELECT @TongSoMH = COUNT(MAMH)
	FROM GIANGDAY
	WHERE MALOP = @MALOP AND HOCKY = @HOCKY AND NAM = @NAM

	IF(@TongSoMH > 3)
	BEGIN
		PRINT('ERROR: 1 hoc ki 1 lop chi duoc hoc toi da 3 mon.')
		ROLLBACK TRANSACTION
	END
END
gO

--17
--trigger dam bao si so bang so luong hoc vien khi insert, update thong tin lop
CREATE TRIGGER TRG_INS_SS ON LOP
FOR INSERT 
AS 
BEGIN
    UPDATE LOP
    SET SISO = 0
    WHERE MALOP IN (
        SELECT MALOP
        FROM inserted
    ) 
END
go

--trigger dam bao si so cua lop tuong ung phai duoc cap nhat khi insert, delete, update hoc vien
CREATE TRIGGER TRG_IUD_SS ON HOCVIEN
FOR INSERT, UPDATE, DELETE 
AS 
BEGIN
    UPDATE LOP
    SET SISO = (
        SELECT COUNT(MAHV)
        FROM HOCVIEN
        WHERE LOP.MALOP = HOCVIEN.MALOP
    ) + (
        SELECT COUNT(MAHV)
        FROM inserted
        WHERE inserted.MALOP = LOP.MALOP
    ) 
END 
go

--18
--trigger dam bao ma mon hoc va ma mon hoc truoc khong duoc giong nhau khi insert, update thong tin dieu kien
CREATE TRIGGER TRG_IU_MAMH ON DIEUKIEN
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @MAMH VARCHAR(10),
			@MAMH_TRUOC VARCHAR(10)
	SELECT @MAMH = MAMH, @MAMH_TRUOC = MAMH_TRUOC
	FROM INSERTED

	IF(@MAMH = @MAMH_TRUOC)
	BEGIN
		PRINT('ERROR: MAMH va MAMH_TRUOC khong hop le.')
		ROLLBACK TRANSACTION
	END
END
go

--trigger dam bao ma mon hoc va ma mon hoc truoc khong cung ton tai 2 bo (“A”,”B”) va (“B”,”A”) khi insert, update thong tin dieu kien
CREATE TRIGGER TRG_IU_MAMHB ON DIEUKIEN
FOR INSERT, UPDATE
AS
BEGIN
	IF EXISTS(
		SELECT *
		FROM DIEUKIEN DK, INSERTED I
		WHERE DK.MAMH = I.MAMH_TRUOC AND DK.MAMH_TRUOC = I.MAMH
	)
	BEGIN
		PRINT('ERROR: MAMH va MAMH_TRUOC khong hop le.')
		ROLLBACK TRANSACTION
	END
END
go

--19
--trigger dam bao cac giao vien co cung hoc vi, hoc ham, he so luong thi luong phai bang nhau
CREATE TRIGGER TRG_IU_GV ON GIAOVIEN
FOR INSERT, UPDATE
AS
BEGIN
	IF EXISTS(
		SELECT *
		FROM GIAOVIEN GV, INSERTED I
		WHERE I.HOCHAM = GV.HOCHAM
		AND I.HOCVI = GV.HOCVI
		AND I.HESO = GV.HESO
		AND I.MUCLUONG <> GV.MUCLUONG
	)
	BEGIN
		PRINT('ERROR: Giao vien co cung hoc vi, hoc ham, he so luong thi luong phai bang nhau.')
		ROLLBACK TRANSACTION
	END
END
go

--20
--trigger dam bao hoc sinh chi duoc thi lai khi diem cua lan thi truoc do duoi 5 khi insert, update ket qua thi
CREATE TRIGGER TRG_IU_KQT ON KETQUATHI
FOR UPDATE, INSERT 
AS 
BEGIN 
    IF EXISTS (
        SELECT *
        FROM INSERTED, KETQUATHI
        WHERE inserted.MAHV = KETQUATHI.MAHV
        AND inserted.MAMH = KETQUATHI.MAMH
        AND KETQUATHI.LANTHI = inserted.LANTHI - 1
        AND KETQUATHI.DIEM >= 5
    ) 
    BEGIN 
        PRINT 'ERROR: Hoc vien chi duoc thi lai khi diem cua lan thi truoc do duoi 5.'
        ROLLBACK TRANSACTION 
    END 
END 
go

--21
--trigger dam bao ngay thi cua lan thi sau phai lon hon ngay thi cua lan thi truoc
CREATE TRIGGER TRG_IU_NGTHI ON KETQUATHI
AFTER INSERT, UPDATE 
AS 
BEGIN 
    IF EXISTS (
        SELECT *
        FROM inserted AS i
        WHERE EXISTS (
            SELECT *
            FROM KETQUATHI AS kq
            WHERE kq.MAHV = i.MAHV
            AND kq.MAMH = i.MAMH
            AND kq.LANTHI = i.LANTHI - 1
            AND kq.NGTHI >= i.NGTHI 
        )
    ) 
    BEGIN 
        PRINT 'ERROR: Ngay thi cua lan thi sau phai lon hon ngay thi cua lan thi truoc.'
        ROLLBACK TRANSACTION 
        RETURN 
    END 
END 
go

--22
--trigger kiem tra khi insert ket qua thi, hoc sinh phai hoan thanh mon hoc truoc khi thi
CREATE TRIGGER TRG_INS_HTMON ON KETQUATHI
FOR INSERT 
AS 
BEGIN 
    IF NOT EXISTS (
        SELECT *
        FROM INSERTED, HOCVIEN, GIANGDAY, LOP
        WHERE HOCVIEN.MAHV = INSERTED.MAHV
        AND GIANGDAY.MAMH = inserted.MAMH
        AND GIANGDAY.MALOP = LOP.MALOP
        AND HOCVIEN.MALOP = LOP.MALOP
        AND DENNGAY < NGTHI
    ) 
    BEGIN 
        PRINT 'ERROR: Hoc vien chua hoan thanh mon hoc.'
        ROLLBACK TRANSACTION 
    END 
END 
go

--23
--trigger kiem tra thu tu truoc sau giua cac mon hoc
CREATE TRIGGER TRG_INS_THUTU ON GIANGDAY
FOR INSERT
AS
BEGIN
    DECLARE @MAMH varchar(10), @MALOP char(3), @MAGV char(4)
    SELECT @MAMH = MAMH, @MALOP = MALOP, @MAGV = MAGV
    FROM inserted
    IF EXISTS (
        SELECT *
        FROM DIEUKIEN D
        WHERE D.MAMH_TRUOC = (
            SELECT D2.MAMH_TRUOC
            FROM DIEUKIEN D2
            WHERE D2.MAMH = @MAMH
        )
        AND D.MAMH <> @MAMH
        AND NOT EXISTS (
            SELECT *
            FROM GIANGDAY GD
            WHERE GD.MAMH = D.MAMH AND GD.MALOP = @MALOP AND GD.MAGV = @MAGV
        )
    )
    BEGIN
        PRINT 'Error: Thu tu mon hoc duoc phan cong khong hop le.'
        ROLLBACK TRANSACTION
    END
END
go

--24
--trigger dam bao giao vien chi duoc phan cong day nhung mon dang phu trach
CREATE TRIGGER TRG_IU_GV ON GIANGDAY 
AFTER INSERT, UPDATE 
AS 
BEGIN 
    IF EXISTS (
        SELECT *
        FROM inserted AS i
        JOIN MONHOC mh ON mh.MAMH = i.MAMH
        WHERE EXISTS (
            SELECT *
            FROM GIAOVIEN gv
            JOIN KHOA k ON k.MAKHOA = gv.MAKHOA
            WHERE gv.MAGV = i.MAGV AND k.MAKHOA <> mh.MAKHOA
        )
    ) 
    BEGIN 
        PRINT 'ERROR: Giao vien chi duoc phan cong day nhung mon dang phu trach.'
        ROLLBACK TRANSACTION
        RETURN
    END 
END

 









