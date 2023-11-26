-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2023-11-04 01:47:56.244

#DDL
#1 
/*Pada modul pendahuluan 1, Anda telah menyusun CDM dan PDM dari Kedai Kopi Nuri. Kini Mbak Nuri memerlukan bantuanmu untuk menyusun database-nya. 
Buatlah sebuah database sesuai dengan PDM di atas. Definisikan nama tabel dan kolom, tipe data kolom, 
serta constraint yang sama dengan PDM. Buat PDM diatas pada perintah CREATE.*/

CREATE DATABASE kedaikopinuri;

-- tables
-- Table: Customer
CREATE TABLE Customer (
    ID_customer char(6)  NOT NULL,
    Nama_customer varchar(100)  NOT NULL,
    CONSTRAINT Customer_PK PRIMARY KEY (ID_customer)
);

-- Table: Menu_minuman
CREATE TABLE Menu_minuman (
    ID_minuman char(6)  NOT NULL,
    Nama_minuman varchar(50)  NOT NULL,
    Harga_minuman float(10,2)  NOT NULL,
    CONSTRAINT Menu_minuman_PK PRIMARY KEY (ID_minuman)
);

-- Table: Pegawai
CREATE TABLE Pegawai (
    NIK char(16)  NOT NULL,
    Nama_pegawai varchar(100)  NOT NULL,
    Jenis_kelamin char(1)  NULL,
    Email varchar(50)  NULL,
    Umur int  NOT NULL,
    CONSTRAINT Pegawai_PK PRIMARY KEY (NIK)
);

-- Table: Telepon
CREATE TABLE Telepon (
    No_telp_pegawai varchar(15)  NOT NULL,
    Pegawai_NIK char(16)  NOT NULL,
    CONSTRAINT Telepon_PK PRIMARY KEY (No_telp_pegawai)
);

-- Table: Transaksi
CREATE TABLE Transaksi (
    ID_transaksi char(10)  NOT NULL,
    Tanggal_transaksi date  NOT NULL,
    Metode_pembayaran varchar(15)  NOT NULL,
    Customer_ID_customer char(6)  NOT NULL,
    Pegawai_NIK char(16)  NOT NULL,
    CONSTRAINT Transaksi_PK PRIMARY KEY (ID_transaksi)
);

-- Table: Transaksi_Menu_minuman
CREATE TABLE Transaksi_Menu_minuman (
    TM_transaksi_ID char(10)  NOT NULL,
    TM_Menu_minuman_ID char(6)  NOT NULL,
    Jumlah_cup int  NOT NULL,
    CONSTRAINT Transaksi_minuman_PK PRIMARY KEY (TM_Menu_minuman_ID,TM_transaksi_ID)
);

-- foreign keys
-- Reference: Telepon_Pegawai (table: Telepon)
ALTER TABLE Telepon ADD CONSTRAINT Telepon_Pegawai_FK FOREIGN KEY (Pegawai_NIK)
    REFERENCES Pegawai (NIK);

-- Reference: Transaksi_Customer (table: Transaksi)
ALTER TABLE Transaksi ADD CONSTRAINT Transaksi_Customer_FK FOREIGN KEY (Customer_ID_customer)
    REFERENCES Customer (ID_customer);

-- Reference: Transaksi_Menu_minuman_Menu_minuman (table: Transaksi_Menu_minuman) 
ALTER TABLE Transaksi_Menu_minuman ADD CONSTRAINT TM_ID_Menu_minuman_FK FOREIGN KEY (TM_Menu_minuman_ID)
    REFERENCES Menu_minuman (ID_minuman);

-- Reference: Transaksi_Menu_minuman_Transaksi (table: Transaksi_Menu_minuman)
ALTER TABLE Transaksi_Menu_minuman ADD CONSTRAINT TM_ID_Transaksi_FK FOREIGN KEY (TM_transaksi_ID)
    REFERENCES Transaksi (ID_transaksi);

-- Reference: Transaksi_Pegawai (table: Transaksi)
ALTER TABLE Transaksi ADD CONSTRAINT Transaksi_Pegawai_FK FOREIGN KEY (Pegawai_NIK)
    REFERENCES Pegawai (NIK);

-- End of file.kedaikopinuri

#2
/*Mbak Nuri ingin membuat sistem membership dimana customer bisa mendaftar. Data yang disimpan beserta tipe datanya, yaitu:
- id_membership CHAR(6)
- no_telepon_customer VARCHAR(15)
- alamat_customer VARCHAR(100)
- tanggal_pembuatan_kartu_membership DATE
- tanggal_kedaluawarsa_kartu_membership DATE (NULLABLE)
- total_poin INT
- customer_id_customer CHAR(6)
*/

CREATE TABLE membership (
    ID_membership CHAR(6)  NOT NULL,
    no_telepon_customer VARCHAR(15)  NOT NULL,
    alamat_customer VARCHAR(100) NOT NULL,
    tanggal_pembuatan_kartu_membership DATE NOT NULL,
    tanggal_kedaluawarsa_kartu_membership DATE,
    total_poin INT NOT NULL, 
    customer_id_customer CHAR(6) NOT NULL
);

-- Dari tabel tersebut, dengan perintah ALTER TABLE:
#A.Jadikan id_membership sebagai PRIMARY KEY
ALTER TABLE membership
ADD PRIMARY KEY (ID_membership);

#B.Atur customer_id_customer sebagai FOREIGN KEY yang berasal dari relasi dengan tabel customer. Dengan pengaturan apabila 
-- id_customer di tabel customer diubah, maka data id di tabel membership ikut berubah. Selain itu, data customer tidak boleh dihapus apabila telah menjadi member.
ALTER TABLE membership
ADD CONSTRAINT Membership_Customer_FK FOREIGN KEY (customer_id_customer) 
	 REFERENCES Customer (ID_customer)
ON UPDATE CASCADE
ON DELETE RESTRICT;

#C.Atur customer_id_customer pada tabel transaksi sebagai FOREIGN KEY dengan kondisi ON DELETE CASCADE dan ON UPDATE CASCADE
ALTER TABLE transaksi DROP FOREIGN KEY Transaksi_Customer_FK

ALTER TABLE transaksi 
ADD CONSTRAINT Transaksi_Customer_FK FOREIGN KEY (customer_id_customer) 
	 REFERENCES customer (ID_customer)
ON DELETE CASCADE
ON UPDATE CASCADE;

#D.Atur nilai default tanggal_pembuatan_kartu_membership sebagai tanggal sekarang (terdapat fungsi build-IN)
ALTER TABLE membership
ALTER COLUMN tanggal_pembuatan_kartu_membership SET DEFAULT CURRENT_DATE;

#E.Berikan constraint untuk melakukan pengecekan bahwa total_poin harus lebih dari atau sama dengan 0
ALTER TABLE membership
ADD CONSTRAINT Check_Total_Poin
CHECK (total_poin >= 0);

#F.Dalam berjalannya bisnis, terdapat alamat pelanggan yang memiliki panjang hingga 140, Sehingga ubah ukuran maksimal-nya menjadi 150
ALTER TABLE membership
MODIFY COLUMN alamat_customer VARCHAR(150) NOT NULL;

#3
/* 3.
Seperti yang kamu ketahui, ketika menyusun PDM, pegawai dapat memiliki beberapa nomor telepon. Hanya saja Mbak Nuri kini berubah pikiran. 
Kini Mbak Nuri menentukan setiap pegawai hanya memiliki 1 nomor telepon saja. Sehingga, tabel telp tidak diperlukan dan bisa diganti 
dengan menambahkan atribut nomor telepon pada tabel pegawai. “Tolong ganti bagian ini, ya! ”, ucap Mbak Nuri.*/
DROP TABLE telepon

ALTER TABLE pegawai 
ADD No_telp VARCHAR(15);

#4 Selain itu, Mbak Nuri memiliki data yang perlu dimasukkan pada masing-masing tabel, yakni:
-- Tabel Customer
INSERT INTO Customer (ID_customer, Nama_customer)
VALUES ('CTR001', 'Budi Santoso'),
       ('CTR002', 'Sisil Triana'),
       ('CTR003', 'Davi Liam'),
       ('CTRo04', 'Sutris Ten An'),
       ('CTR005', 'Hendra Asto');
       
-- Tabel Membership
INSERT INTO membership (ID_membership, no_telepon_customer, alamat_customer, tanggal_pembuatan_kartu_membership, 
tanggal_kedaluawarsa_kartu_membership, total_poin, customer_id_customer)
VALUES ('MBR001', '08123456789', 'Jl. Imam Bonjol', '2023-10-24', '2023-11-30', 0, 'CTR001'),
		 ('MBR002', '0812345678', 'Jl. Kelinci', '2023-10-24', '2023-11-30', 3, 'CTR002'),
		 ('MBR003', '081234567890', 'Jl. Abah Ojak', '2023-10-25', '2023-12-01', 2, 'CTR003'),
		 ('MBR004', '08987654321', 'Jl. Kenangan', '2023-10-26', '2023-12-02', 6, 'CTR005');

-- Tabel Pegawai
INSERT INTO pegawai (NIK, Nama_pegawai, Jenis_kelamin, Email, Umur, No_telp)
VALUES ('1234567890123456', 'Naufal Raf', 'L', 'naufal@gmail.com', 19, '62123456789'),
		 ('2345678901234561', 'Surinala', 'P', 'surinala@gmail.com', 24, '621234567890'),
		 ('3456789012345612', 'Ben John', 'L', 'benjohn@gmail.com', 22, '6212345678');
		 
-- Tabel Transaksi
INSERT INTO transaksi (ID_transaksi, Tanggal_transaksi, Metode_pembayaran, Pegawai_NIK, Customer_ID_customer)
VALUES ('TRX0000001', '2023-10-01', 'Kartu kredit', '2345678901234561', 'CTR002'),
		 ('TRX0000002', '2023-10-03', 'Transfer bank', '3456789012345612', 'CTRo04'),
		 ('TRX0000003', '2023-10-05', 'Tunai', '3456789012345612', 'CTR001'),
		 ('TRX0000004', '2023-10-15', 'Kartu debit', '1234567890123456', 'CTR003'),
		 ('TRX0000005', '2023-10-15', 'E-wallet', '1234567890123456', 'CTRo04'),
		 ('TRX0000006', '2023-10-21', 'Tunai', '2345678901234561', 'CTR001');
		 
-- Tabel Transaksi Menu
INSERT INTO transaksi_menu_minuman (TM_transaksi_ID, TM_Menu_minuman_ID, Jumlah_cup)
VALUES 
('TRX0000005', 'MNM006', 2),
('TRX0000001', 'MNM010', 1),
('TRX0000002', 'MNM005', 1),
('TRX0000005', 'MNM009', 1),
('TRX0000003', 'MNM001', 3),
('TRX0000006', 'MNM003', 2),
('TRX0000004', 'MNM004', 2),
('TRX0000004', 'MNM010', 1),
('TRX0000002', 'MNM003', 2),
('TRX0000001', 'MNM007', 1),
('TRX0000005', 'MNM001', 1),
('TRX0000003', 'MNM003', 1);

-- Tabel Menu
INSERT INTO menu_minuman (ID_minuman, Nama_minuman, Harga_minuman)
VALUES
('MNM001', 'Expresso', 18000),
('MNM002', 'Cappuccino', 20000),
('MNM003', 'Latte', 21000),
('MNM004', 'Americano', 19000),
('MNM005', 'Mocha', 22000),
('MNM006', 'Macchiato', 23000),
('MNM007', 'Cold Brew', 21000),
('MNM008', 'Iced Coffee', 18000),
('MNM009', 'Affogato', 23000),
('MNM010', 'Coffee Frappe', 22000);

#DML
#5.
/*Lakukan penambahan data pada database dengan keterangan berikut:
Pada tanggal 3 Oktober 2023, seorang pelanggan dengan ID Pembeli 'CTRo04' memilih untuk membayar menggunakan 
metode transfer bank dan memesan 1 minuman jenis MNM005, pelanggan tersebut dilayani oleh pelayan bernama surinala.*/
INSERT INTO transaksi (ID_transaksi, Tanggal_transaksi, Metode_pembayaran, Pegawai_NIK, Customer_ID_customer)
VALUES ('TRX0000007', '2023-10-03', 'Transfer bank', '2345678901234561', 'CTRo04');

INSERT INTO transaksi_menu_minuman (TM_transaksi_ID, TM_Menu_minuman_ID, Jumlah_cup)
VALUES ('TRX0000007', 'MNM005', 1);

#6.
/*Tambahkan data pegawai dengan isian NIK 1111222233334444, nama pegawai Maimunah, dan umur 25 tahun.*/
INSERT INTO pegawai (NIK, Nama_pegawai, Umur)
VALUES ('1111222233334444', 'Maimunah', 25);

#7.
/*Lakukan update ID customer “CTRo04” menjadi “CTR004”*/
UPDATE `kedaikopinuri`.`customer` SET `ID_customer`='CTR004' WHERE  `ID_customer`='CTRo04';

#8.
/*Setelah bekerja, baru diketahui bahwa Maimunah adalah seorang perempuan, nomor telepon 621234567, 
dan memiliki email maimunah@gmail.com, lakukan update data dengan keterangan ini.*/
UPDATE Pegawai
SET Jenis_kelamin = 'P', Email = 'maimunah@gmail.com', No_telp = '621234567'
WHERE NIK = '1111222233334444';

#9.
/*Total_poin pada membership akan direset menjadi 0 ketika awal bulan, kini telah memasuki bulan Desember 2023, 
maka update semua total poin dari membership dengan tanggal kedaluwarsa sebelum bulan Desember.*/
UPDATE membership
SET total_poin = 0
WHERE tanggal_kedaluawarsa_kartu_membership < '2023-12-01';

#10.
/*Mbak Nuri ingin menghapus semua data membership, bantulah Mbak Nuri melakukannya*/
DELETE FROM membership

#11.
/*Hapus data pegawai dengan nama Maimunah*/
DELETE FROM pegawai WHERE Nama_pegawai = 'Maimunah'