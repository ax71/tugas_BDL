-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Apr 13, 2025 at 10:46 AM
-- Server version: 8.0.30
-- PHP Version: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `uts_bdl`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `LihatAbsensiByNIM` (IN `p_NIM` VARCHAR(15))   BEGIN
    SELECT * FROM Absensi WHERE NIM = p_NIM;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `TambahAbsensi` (IN `p_Tanggal` DATE, IN `p_Status` ENUM('Hadir','Izin','Sakit','Alpha'), IN `p_Keterangan` TEXT, IN `p_Waktu` TIME, IN `p_NIM` VARCHAR(15), IN `p_Kode_Kelas` VARCHAR(10))   BEGIN
    INSERT INTO Absensi (Tanggal, Status, Keterangan, Waktu, NIM, Kode_Kelas)
    VALUES (p_Tanggal, p_Status, p_Keterangan, p_Waktu, p_NIM, p_Kode_Kelas);
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `AbsensiStatus` (`p_NIM` VARCHAR(15), `p_Status` ENUM('Hadir','Izin','Sakit','Alpha')) RETURNS INT DETERMINISTIC BEGIN
    DECLARE jumlah INT;

    SELECT COUNT(*) INTO jumlah
    FROM Absensi
    WHERE NIM = p_NIM AND Status = p_Status;

    RETURN jumlah;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `Alpha` (`p_NIM` VARCHAR(15)) RETURNS TINYINT DETERMINISTIC BEGIN
    DECLARE jumlah INT;

    SELECT COUNT(*) INTO jumlah
    FROM Absensi
    WHERE NIM = p_NIM AND Status = 'Alpha';

    IF jumlah > 0 THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `absensi`
--

CREATE TABLE `absensi` (
  `ID_Absensi` int NOT NULL,
  `Tanggal` date DEFAULT NULL,
  `Status` enum('Hadir','Izin','Sakit','Alpha') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Keterangan` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `Waktu` time DEFAULT NULL,
  `NIM` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Kode_Kelas` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `absensi`
--

INSERT INTO `absensi` (`ID_Absensi`, `Tanggal`, `Status`, `Keterangan`, `Waktu`, `NIM`, `Kode_Kelas`) VALUES
(1, '2025-04-10', 'Hadir', '-', '08:05:00', '220001', 'KLS01'),
(2, '2025-04-10', 'Izin', 'Sakit', '08:00:00', '220002', 'KLS01'),
(3, '2025-04-10', 'Hadir', '-', '10:01:00', '220001', 'KLS02'),
(4, '2025-04-10', 'Alpha', '-', '13:00:00', '220003', 'KLS03'),
(5, '2025-04-10', 'Hadir', '-', '09:01:00', '220004', 'KLS04'),
(6, '2025-04-10', 'Hadir', '-', '08:05:00', '230001', 'KLS01'),
(7, '2025-04-10', 'Hadir', '-', '08:06:00', '230002', 'KLS01'),
(8, '2025-04-10', 'Izin', 'Sakit', '10:01:00', '230003', 'KLS02'),
(9, '2025-04-10', 'Alpha', '-', '10:00:00', '230004', 'KLS02'),
(10, '2025-04-10', 'Hadir', '-', '13:05:00', '230005', 'KLS03'),
(11, '2025-04-10', 'Hadir', '-', '09:01:00', '230006', 'KLS04'),
(12, '2025-04-10', 'Hadir', '-', '11:00:00', '230007', 'KLS05'),
(13, '2025-04-10', 'Hadir', '-', '14:10:00', '230008', 'KLS06'),
(14, '2025-04-10', 'Hadir', '-', '08:00:00', '230009', 'KLS07'),
(15, '2025-04-10', 'Alpha', '-', '10:00:00', '230010', 'KLS08'),
(16, '2025-04-10', 'Hadir', '-', '13:00:00', '230011', 'KLS09'),
(17, '2025-04-10', 'Izin', 'Acara keluarga', '09:00:00', '230012', 'KLS10'),
(18, '2025-04-10', 'Hadir', '-', '08:00:00', '230013', 'KLS11'),
(19, '2025-04-10', 'Hadir', '-', '10:15:00', '230014', 'KLS12'),
(20, '2025-04-10', 'Hadir', '-', '13:10:00', '230015', 'KLS13'),
(23, '2025-04-13', 'Hadir', NULL, NULL, '220001', 'KLS01'),
(24, '2025-04-13', 'Hadir', NULL, NULL, '220001', 'KLS01'),
(25, '2025-04-13', 'Hadir', NULL, NULL, '220001', 'KLS01'),
(26, '2025-04-13', 'Sakit', NULL, NULL, '220002', 'KLS02');

--
-- Triggers `absensi`
--
DELIMITER $$
CREATE TRIGGER `trg_validasi_status_absensi` BEFORE INSERT ON `absensi` FOR EACH ROW BEGIN
    -- Ensure attendance status is one of the allowed values
    IF NEW.Status NOT IN ('Hadir', 'Sakit', 'Izin', 'Alpha', 'Belum') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Status absensi tidak valid. Nilai yang diperbolehkan: Hadir, Sakit, Izin, Alpha, Belum';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `dosen`
--

CREATE TABLE `dosen` (
  `ID_Dosen` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `Nama` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `NIDN` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Departement` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `No_HP` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `dosen`
--

INSERT INTO `dosen` (`ID_Dosen`, `Nama`, `NIDN`, `Departement`, `Email`, `No_HP`) VALUES
('D001', 'Dr. I Gede Surya', '000101', 'Informatika', 'surya@univ.ac.id', '0811111111'),
('D002', 'Putu Ayu', '000102', 'Sistem Informasi', 'ayu@univ.ac.id', '0822222222'),
('D003', 'Dr. Dwi Santoso', '000103', 'Desain', 'dwi@univ.ac.id', '0833333333'),
('D004', 'Luh Putri', '000104', 'Informatika', 'luh@univ.ac.id', '0844444444'),
('D005', 'Dr. Komang Arta', '000105', 'Manajemen', 'komang@univ.ac.id', '0855555555'),
('D006', 'Dr. Agus Santosa', '000106', 'Bisnis Digital', 'agus@univ.ac.id', '081222333444'),
('D007', 'Dr. Made Wibawa', '000107', 'Sistem Informasi', 'made@univ.ac.id', '081333444555'),
('D008', 'Dr. Sari Dewi', '000108', 'Informatika', 'sari@univ.ac.id', '081444555666'),
('D009', 'Dr. Gede Mahendra', '000109', 'Desain Komunikasi Visual', 'gede@univ.ac.id', '081555666777'),
('D010', 'Dr. Wayan Sukma', '000110', 'Sistem Informasi', 'wayan@univ.ac.id', '081666777888');

-- --------------------------------------------------------

--
-- Table structure for table `kelas`
--

CREATE TABLE `kelas` (
  `Kode_Kelas` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `Hari` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Ruangan` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ID_MK` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ID_Dosen` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Waktu_Mulai` time DEFAULT NULL,
  `Waktu_Selesai` time DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `kelas`
--

INSERT INTO `kelas` (`Kode_Kelas`, `Hari`, `Ruangan`, `ID_MK`, `ID_Dosen`, `Waktu_Mulai`, `Waktu_Selesai`) VALUES
('KLS01', 'Senin', 'Lab A', 'MK001', 'D001', '08:00:00', '10:30:00'),
('KLS02', 'Selasa', 'Lab B', 'MK002', 'D002', '08:00:00', '09:30:00'),
('KLS03', 'Rabu', 'Ruang 5', 'MK003', 'D003', '10:30:00', '13:00:00'),
('KLS04', 'Kamis', 'Studio 1', 'MK004', 'D004', '08:00:00', '10:00:00'),
('KLS05', 'Jumat', 'Lab C', 'MK005', 'D005', '13:00:00', '16:30:00'),
('KLS06', 'Senin', 'Lab a', 'MK001', 'D001', '08:00:00', '10:30:00'),
('KLS07', 'Selasa', 'Lab B', 'MK002', 'D002', '10:00:00', '13:00:00'),
('KLS08', 'Rabu', 'Lab C', 'MK003', 'D003', '13:00:00', '16:30:00'),
('KLS09', 'Kamis', 'Ruang 5', 'MK004', 'D004', '09:00:00', '11:30:00'),
('KLS10', 'Jumat', 'Ruang 2', 'MK005', 'D005', '11:00:00', '13:00:00'),
('KLS11', 'Senin', 'Lab A', 'MK006', 'D006', '14:00:00', '17:30:00'),
('KLS12', 'Selasa', 'Lab B', 'MK007', 'D007', '08:00:00', '10:30:00'),
('KLS13', 'Rabu', 'Lab C', 'MK008', 'D008', '10:00:00', '13:00:00'),
('KLS14', 'Kamis', 'Ruang 3', 'MK009', 'D009', '13:00:00', '16:30:00'),
('KLS15', 'Jumat', 'Ruang 1', 'MK010', 'D010', '09:00:00', '11:30:00'),
('KLS16', 'Senin', 'Studio 1', 'MK011', 'D001', '08:00:00', '10:30:00'),
('KLS17', 'Selasa', 'Lab D', 'MK012', 'D002', '10:00:00', '13:00:00'),
('KLS18', 'Rabu', 'Ruang 4', 'MK013', 'D003', '13:00:00', '16:30:00'),
('KLS19', 'Kamis', 'Lab F', 'MK014', 'D004', '11:00:00', NULL),
('KLS20', 'Jumat', 'Lab G', 'MK015', 'D005', '08:00:00', '10:30:00');

-- --------------------------------------------------------

--
-- Table structure for table `kelas_mahasiswa`
--

CREATE TABLE `kelas_mahasiswa` (
  `Kode_Kelas` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `NIM` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `kelas_mahasiswa`
--

INSERT INTO `kelas_mahasiswa` (`Kode_Kelas`, `NIM`) VALUES
('KLS01', '220001'),
('KLS02', '220001'),
('KLS01', '220002'),
('KLS03', '220003'),
('KLS01', '220004'),
('KLS04', '220004'),
('KLS01', '230001'),
('KLS01', '230002'),
('KLS02', '230003'),
('KLS02', '230004'),
('KLS03', '230005'),
('KLS04', '230006'),
('KLS05', '230007'),
('KLS06', '230008'),
('KLS07', '230009'),
('KLS08', '230010'),
('KLS09', '230011'),
('KLS10', '230012'),
('KLS11', '230013'),
('KLS12', '230014'),
('KLS13', '230015'),
('KLS01', '230016'),
('KLS14', '230016'),
('KLS15', '230017');

--
-- Triggers `kelas_mahasiswa`
--
DELIMITER $$
CREATE TRIGGER `trg_auto_generate_absensi` AFTER INSERT ON `kelas_mahasiswa` FOR EACH ROW BEGIN
    -- Get class schedule information
    DECLARE v_hari VARCHAR(20);
    DECLARE v_current_date DATE;
    DECLARE v_end_date DATE;
    
    -- Get the day of the class
    SELECT Hari INTO v_hari FROM kelas WHERE Kode_Kelas = NEW.Kode_Kelas;
    
    -- Set current date as starting point
    SET v_current_date = CURDATE();
    
    -- Set end date (e.g., end of semester - 4 months from now)
    SET v_end_date = DATE_ADD(CURDATE(), INTERVAL 4 MONTH);
    
    -- Loop through dates and create attendance records for class days
    WHILE v_current_date <= v_end_date DO
        -- Check if current date day matches class day
        IF DAYNAME(v_current_date) = v_hari THEN
            -- Insert attendance record with default status
            INSERT INTO absensi (NIM, Kode_Kelas, Tanggal, Status)
            VALUES (NEW.NIM, NEW.Kode_Kelas, v_current_date, 'Belum');
        END IF;
        
        -- Move to next day
        SET v_current_date = DATE_ADD(v_current_date, INTERVAL 1 DAY);
    END WHILE;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_cek_jadwal_bentrok` BEFORE INSERT ON `kelas_mahasiswa` FOR EACH ROW BEGIN
    DECLARE bentrok INT;
    
    -- Check if the student already has a class at the same time
    SELECT COUNT(*) INTO bentrok
    FROM kelas_mahasiswa km
    JOIN kelas k1 ON km.Kode_Kelas = k1.Kode_Kelas
    JOIN kelas k2 ON k2.Kode_Kelas = NEW.Kode_Kelas
    WHERE 
        km.NIM = NEW.NIM
        AND k1.Hari = k2.Hari
        AND (
            (k1.Waktu_Mulai < k2.Waktu_Selesai AND k1.Waktu_Selesai > k2.Waktu_Mulai)
            OR 
            (k1.Waktu_Mulai = k2.Waktu_Mulai AND k1.Waktu_Selesai = k2.Waktu_Selesai)
        );
    
    IF bentrok > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Jadwal bentrok dengan kelas lain yang telah diambil';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_validasi_kelas_mahasiswa` BEFORE INSERT ON `kelas_mahasiswa` FOR EACH ROW BEGIN
    DECLARE jumlah_terdaftar INT;
    
    -- Check if student is already enrolled in this class
    SELECT COUNT(*) INTO jumlah_terdaftar
    FROM kelas_mahasiswa
    WHERE NIM = NEW.NIM AND Kode_Kelas = NEW.Kode_Kelas;
    
    IF jumlah_terdaftar > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Mahasiswa sudah terdaftar di kelas ini';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `mahasiswa`
--

CREATE TABLE `mahasiswa` (
  `NIM` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `Nama` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Semester` int DEFAULT NULL,
  `Email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `No_HP` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Kode_Prodi` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `mahasiswa`
--

INSERT INTO `mahasiswa` (`NIM`, `Nama`, `Semester`, `Email`, `No_HP`, `Kode_Prodi`) VALUES
('220001', 'Kadek adi jaya', 4, 'kadek@univ.ac.id', '081234567890', 'IF'),
('220002', 'Ani Wulandari', 2, 'ani@univ.ac.id', '082233445566', 'SI'),
('220003', 'Maliq Hidayat', 6, 'maliq@univ.ac.id', '083344556677', 'IF'),
('220004', 'Sinta Lestari', 4, 'sinta@univ.ac.id', '081122334455', 'DKV'),
('220005', 'Bagus Arya', 2, 'bagus@univ.ac.id', '089876543210', 'MJ'),
('230001', 'Kadek Ari', 2, 'ari@gmail.com', '089777723953', 'IF'),
('230002', 'Made Wira', 4, 'wira@gmail.com', '084930102030', 'IF'),
('230003', 'Komang Ayu', 2, 'ayu@gmail.com', '082347123040', 'SI'),
('230004', 'Ni Luh Putu', 6, 'luh@gmail.com', '087345999342', 'SIA'),
('230005', 'Kadek Yoga', 6, 'yoga@gmail.com', '081020489567', 'MJ'),
('230006', 'Putu Ayu', 6, 'ayu2@gmail.com', '089934292965', 'BD'),
('230007', 'Wayan Budi', 2, 'budi@gmail.com', '085020344757', 'IF'),
('230008', 'Made Lestari', 4, 'lestari@gmail.ac.id', '089838357443', 'SI'),
('230009', 'Komang Dewi', 4, 'dewi@gmail.com', '081342576994', 'MJ'),
('230010', 'Ni Komang Sari', 4, 'sari@gmail.ac.id\r\n', '089374829210', 'BD'),
('230011', 'Gede Hendra', 2, 'Hendra@gmail.com', '082375923102', 'SIA'),
('230012', 'Kadek Raka', 4, 'raka@gmail.com', '089574390475', 'IF'),
('230013', 'Made Aris', 2, 'aris@gmail.ac.id\r\n', '085934855623', 'SI'),
('230014', 'Wayan Dewantara', 4, 'dewatara@gmail.ac.id', '083023055073', 'MJ'),
('230015', 'Putu Luh', 2, 'putu@gmail.com', '082375233010', 'BD'),
('230016', 'Kadek Budi', 2, 'budi@univ.ac.id', '081234567891', 'IF'),
('230017', 'Putri Ayu', 4, 'ayu@univ.ac.id', '081234567892', 'SI'),
('230018', 'Made Gita', 6, 'gita@univ.ac.id', '081234567893', 'DKV'),
('230019', 'Agus Wira', 2, 'wira@univ.ac.id', '081234567894', 'MJ'),
('230020', 'Luh Sari', 8, 'sari@univ.ac.id', '081234567895', 'SIA'),
('230021', 'Raka Bintang', 4, 'raka@univ.ac.id', '081234567896', 'BD'),
('230022', 'Dewi Murni', 6, 'murni@univ.ac.id', '081234567897', 'DKV'),
('230023', 'Wayan Jaya', 2, 'jaya@univ.ac.id', '081234567898', 'IF'),
('230024', 'Candra Surya', 4, 'candra@univ.ac.id', '081234567899', 'MJ'),
('230025', 'Nyoman Eka', 6, 'eka@univ.ac.id', '081234567900', 'SI'),
('230026', 'Gung Krisna', 2, 'krisna@univ.ac.id', '081234567901', 'SIA'),
('230027', 'Komang Adi', 4, 'komang@univ.ac.id', '081234567902', 'BD'),
('230028', 'Ayu Widi', 6, 'widi@univ.ac.id', '081234567903', 'DKV'),
('230029', 'Gita Permata', 8, 'permata@univ.ac.id', '081234567904', 'IF'),
('230030', 'Bayu Dana', 2, 'dana@univ.ac.id', '081234567905', 'MJ');

-- --------------------------------------------------------

--
-- Table structure for table `mata_kuliah`
--

CREATE TABLE `mata_kuliah` (
  `ID_MK` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `Kode_MK` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Nama_MK` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `SKS` int DEFAULT NULL,
  `Semester` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `mata_kuliah`
--

INSERT INTO `mata_kuliah` (`ID_MK`, `Kode_MK`, `Nama_MK`, `SKS`, `Semester`) VALUES
('MK001', 'IF003', 'Pemrograman Dasar', 3, 1),
('MK002', 'IF004', 'Basis Data', 3, 3),
('MK003', 'SI003', 'Manajemen Sistem Informasi', 2, 5),
('MK004', 'DKV003', 'Desain Digital', 2, 2),
('MK005', 'IF005', 'Jaringan Komputer', 3, 4),
('MK006', 'BD001', 'Struktur Data', 3, 2),
('MK007', 'IF001', 'Pemrograman Web', 3, 4),
('MK008', 'DKV001', 'Kecerdasan Buatan', 3, 6),
('MK009', 'MJ001', 'Proyek Perangkat Lunak', 3, 6),
('MK010', 'SI001', 'Etika Profesi', 2, 8),
('MK011', 'SI002', 'Sistem Informasi Manajemen', 3, 2),
('MK012', 'SI003', 'ERP System', 3, 4),
('MK013', 'DKV002', 'Desain Grafis', 2, 2),
('MK014', 'BD002', 'Manajemen Proyek IT', 3, 6),
('MK015', 'IF002', 'Logika Informatika', 3, 2),
('MK016', 'DKV02', 'Animasi 2D', 2, 4),
('MK017', 'MJ002', 'Teknologi Embedded System', 3, 6);

-- --------------------------------------------------------

--
-- Table structure for table `program_studi`
--

CREATE TABLE `program_studi` (
  `Kode_Prodi` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `Nama_Prodi` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Jenjang` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Akreditasi` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `program_studi`
--

INSERT INTO `program_studi` (`Kode_Prodi`, `Nama_Prodi`, `Jenjang`, `Akreditasi`) VALUES
('BD', 'Bisnis Digital', 'S1', 'A'),
('DKV', 'Desain Komunikasi Visual', 'S1', 'A'),
('IF', 'Informatika', 'S1', 'A'),
('MJ', 'Manajemen', 'S1', 'B'),
('SI', 'Sistem Informasi', 'S1', 'B'),
('SIA', 'Sistem Informasi Akutansi', 'S1', 'B');

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_absensi_detail`
-- (See below for the actual view)
--
CREATE TABLE `vw_absensi_detail` (
`ID_Absensi` int
,`NIM` varchar(15)
,`nama_mahasiswa` varchar(100)
,`Kode_Kelas` varchar(10)
,`ruang_kelas` varchar(50)
,`nama_mata_kuliah` varchar(100)
,`nama_dosen` varchar(100)
,`Tanggal` date
,`Waktu` time
,`Status` enum('Hadir','Izin','Sakit','Alpha')
,`Keterangan` text
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_dosen_pengajaran`
-- (See below for the actual view)
--
CREATE TABLE `vw_dosen_pengajaran` (
`ID_Dosen` varchar(10)
,`nama_dosen` varchar(100)
,`NIDN` varchar(20)
,`Departement` varchar(100)
,`Kode_Kelas` varchar(10)
,`Hari` varchar(20)
,`Waktu_Mulai` time
,`Waktu_Selesai` time
,`Ruangan` varchar(50)
,`nama_mata_kuliah` varchar(100)
,`SKS` int
,`jumlah_mahasiswa` bigint
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_kelas_detail`
-- (See below for the actual view)
--
CREATE TABLE `vw_kelas_detail` (
`Kode_Kelas` varchar(10)
,`ID_MK` varchar(10)
,`Nama_MK` varchar(100)
,`Kode_MK` varchar(10)
,`ID_Dosen` varchar(10)
,`nama_dosen` varchar(100)
,`NIDN` varchar(20)
,`Ruangan` varchar(50)
,`Hari` varchar(20)
,`Waktu_Mulai` time
,`Waktu_Selesai` time
,`SKS` int
,`Semester` int
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_kelas_mahasiswa_detail`
-- (See below for the actual view)
--
CREATE TABLE `vw_kelas_mahasiswa_detail` (
`Kode_Kelas` varchar(10)
,`NIM` varchar(15)
,`nama_mahasiswa` varchar(100)
,`email_mahasiswa` varchar(100)
,`hp_mahasiswa` varchar(20)
,`hari_kuliah` varchar(20)
,`Waktu_Mulai` time
,`Waktu_Selesai` time
,`Ruangan` varchar(50)
,`nama_mata_kuliah` varchar(100)
,`SKS` int
,`nama_dosen` varchar(100)
,`program_studi` varchar(100)
,`Jenjang` varchar(10)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_statistik_absensi`
-- (See below for the actual view)
--
CREATE TABLE `vw_statistik_absensi` (
`NIM` varchar(15)
,`nama_mahasiswa` varchar(100)
,`Kode_Kelas` varchar(10)
,`nama_mata_kuliah` varchar(100)
,`total_pertemuan` bigint
,`jumlah_hadir` decimal(23,0)
,`jumlah_sakit` decimal(23,0)
,`jumlah_izin` decimal(23,0)
,`jumlah_alpha` decimal(23,0)
,`persentase_kehadiran` decimal(29,2)
);

-- --------------------------------------------------------

--
-- Structure for view `vw_absensi_detail`
--
DROP TABLE IF EXISTS `vw_absensi_detail`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_absensi_detail`  AS SELECT `a`.`ID_Absensi` AS `ID_Absensi`, `a`.`NIM` AS `NIM`, `m`.`Nama` AS `nama_mahasiswa`, `a`.`Kode_Kelas` AS `Kode_Kelas`, `k`.`Ruangan` AS `ruang_kelas`, `mk`.`Nama_MK` AS `nama_mata_kuliah`, `d`.`Nama` AS `nama_dosen`, `a`.`Tanggal` AS `Tanggal`, `a`.`Waktu` AS `Waktu`, `a`.`Status` AS `Status`, `a`.`Keterangan` AS `Keterangan` FROM ((((`absensi` `a` join `mahasiswa` `m` on((`a`.`NIM` = `m`.`NIM`))) join `kelas` `k` on((`a`.`Kode_Kelas` = `k`.`Kode_Kelas`))) join `mata_kuliah` `mk` on((`k`.`ID_MK` = `mk`.`ID_MK`))) join `dosen` `d` on((`k`.`ID_Dosen` = `d`.`ID_Dosen`))) ;

-- --------------------------------------------------------

--
-- Structure for view `vw_dosen_pengajaran`
--
DROP TABLE IF EXISTS `vw_dosen_pengajaran`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_dosen_pengajaran`  AS SELECT `d`.`ID_Dosen` AS `ID_Dosen`, `d`.`Nama` AS `nama_dosen`, `d`.`NIDN` AS `NIDN`, `d`.`Departement` AS `Departement`, `k`.`Kode_Kelas` AS `Kode_Kelas`, `k`.`Hari` AS `Hari`, `k`.`Waktu_Mulai` AS `Waktu_Mulai`, `k`.`Waktu_Selesai` AS `Waktu_Selesai`, `k`.`Ruangan` AS `Ruangan`, `mk`.`Nama_MK` AS `nama_mata_kuliah`, `mk`.`SKS` AS `SKS`, count(`km`.`NIM`) AS `jumlah_mahasiswa` FROM (((`dosen` `d` join `kelas` `k` on((`d`.`ID_Dosen` = `k`.`ID_Dosen`))) join `mata_kuliah` `mk` on((`k`.`ID_MK` = `mk`.`ID_MK`))) left join `kelas_mahasiswa` `km` on((`k`.`Kode_Kelas` = `km`.`Kode_Kelas`))) GROUP BY `d`.`ID_Dosen`, `d`.`Nama`, `d`.`NIDN`, `d`.`Departement`, `k`.`Kode_Kelas`, `k`.`Hari`, `k`.`Waktu_Mulai`, `k`.`Waktu_Selesai`, `k`.`Ruangan`, `mk`.`Nama_MK`, `mk`.`SKS` ;

-- --------------------------------------------------------

--
-- Structure for view `vw_kelas_detail`
--
DROP TABLE IF EXISTS `vw_kelas_detail`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_kelas_detail`  AS SELECT `k`.`Kode_Kelas` AS `Kode_Kelas`, `mk`.`ID_MK` AS `ID_MK`, `mk`.`Nama_MK` AS `Nama_MK`, `mk`.`Kode_MK` AS `Kode_MK`, `d`.`ID_Dosen` AS `ID_Dosen`, `d`.`Nama` AS `nama_dosen`, `d`.`NIDN` AS `NIDN`, `k`.`Ruangan` AS `Ruangan`, `k`.`Hari` AS `Hari`, `k`.`Waktu_Mulai` AS `Waktu_Mulai`, `k`.`Waktu_Selesai` AS `Waktu_Selesai`, `mk`.`SKS` AS `SKS`, `mk`.`Semester` AS `Semester` FROM ((`kelas` `k` join `mata_kuliah` `mk` on((`k`.`ID_MK` = `mk`.`ID_MK`))) join `dosen` `d` on((`k`.`ID_Dosen` = `d`.`ID_Dosen`))) ;

-- --------------------------------------------------------

--
-- Structure for view `vw_kelas_mahasiswa_detail`
--
DROP TABLE IF EXISTS `vw_kelas_mahasiswa_detail`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_kelas_mahasiswa_detail`  AS SELECT `km`.`Kode_Kelas` AS `Kode_Kelas`, `km`.`NIM` AS `NIM`, `m`.`Nama` AS `nama_mahasiswa`, `m`.`Email` AS `email_mahasiswa`, `m`.`No_HP` AS `hp_mahasiswa`, `k`.`Hari` AS `hari_kuliah`, `k`.`Waktu_Mulai` AS `Waktu_Mulai`, `k`.`Waktu_Selesai` AS `Waktu_Selesai`, `k`.`Ruangan` AS `Ruangan`, `mk`.`Nama_MK` AS `nama_mata_kuliah`, `mk`.`SKS` AS `SKS`, `d`.`Nama` AS `nama_dosen`, `ps`.`Nama_Prodi` AS `program_studi`, `ps`.`Jenjang` AS `Jenjang` FROM (((((`kelas_mahasiswa` `km` join `mahasiswa` `m` on((`km`.`NIM` = `m`.`NIM`))) join `kelas` `k` on((`km`.`Kode_Kelas` = `k`.`Kode_Kelas`))) join `mata_kuliah` `mk` on((`k`.`ID_MK` = `mk`.`ID_MK`))) join `dosen` `d` on((`k`.`ID_Dosen` = `d`.`ID_Dosen`))) join `program_studi` `ps` on((`m`.`Kode_Prodi` = `ps`.`Kode_Prodi`))) ;

-- --------------------------------------------------------

--
-- Structure for view `vw_statistik_absensi`
--
DROP TABLE IF EXISTS `vw_statistik_absensi`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_statistik_absensi`  AS SELECT `a`.`NIM` AS `NIM`, `m`.`Nama` AS `nama_mahasiswa`, `a`.`Kode_Kelas` AS `Kode_Kelas`, `mk`.`Nama_MK` AS `nama_mata_kuliah`, count(`a`.`ID_Absensi`) AS `total_pertemuan`, sum((case when (`a`.`Status` = 'Hadir') then 1 else 0 end)) AS `jumlah_hadir`, sum((case when (`a`.`Status` = 'Sakit') then 1 else 0 end)) AS `jumlah_sakit`, sum((case when (`a`.`Status` = 'Izin') then 1 else 0 end)) AS `jumlah_izin`, sum((case when (`a`.`Status` = 'Alpha') then 1 else 0 end)) AS `jumlah_alpha`, round(((sum((case when (`a`.`Status` = 'Hadir') then 1 else 0 end)) * 100.0) / count(`a`.`ID_Absensi`)),2) AS `persentase_kehadiran` FROM (((`absensi` `a` join `mahasiswa` `m` on((`a`.`NIM` = `m`.`NIM`))) join `kelas` `k` on((`a`.`Kode_Kelas` = `k`.`Kode_Kelas`))) join `mata_kuliah` `mk` on((`k`.`ID_MK` = `mk`.`ID_MK`))) GROUP BY `a`.`NIM`, `m`.`Nama`, `a`.`Kode_Kelas`, `mk`.`Nama_MK` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `absensi`
--
ALTER TABLE `absensi`
  ADD PRIMARY KEY (`ID_Absensi`),
  ADD KEY `NIM` (`NIM`),
  ADD KEY `Kode_Kelas` (`Kode_Kelas`);

--
-- Indexes for table `dosen`
--
ALTER TABLE `dosen`
  ADD PRIMARY KEY (`ID_Dosen`);

--
-- Indexes for table `kelas`
--
ALTER TABLE `kelas`
  ADD PRIMARY KEY (`Kode_Kelas`),
  ADD KEY `ID_MK` (`ID_MK`),
  ADD KEY `ID_Dosen` (`ID_Dosen`);

--
-- Indexes for table `kelas_mahasiswa`
--
ALTER TABLE `kelas_mahasiswa`
  ADD PRIMARY KEY (`Kode_Kelas`,`NIM`),
  ADD KEY `NIM` (`NIM`);

--
-- Indexes for table `mahasiswa`
--
ALTER TABLE `mahasiswa`
  ADD PRIMARY KEY (`NIM`),
  ADD KEY `Kode_Prodi` (`Kode_Prodi`);

--
-- Indexes for table `mata_kuliah`
--
ALTER TABLE `mata_kuliah`
  ADD PRIMARY KEY (`ID_MK`);

--
-- Indexes for table `program_studi`
--
ALTER TABLE `program_studi`
  ADD PRIMARY KEY (`Kode_Prodi`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `absensi`
--
ALTER TABLE `absensi`
  MODIFY `ID_Absensi` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `absensi`
--
ALTER TABLE `absensi`
  ADD CONSTRAINT `absensi_ibfk_1` FOREIGN KEY (`NIM`) REFERENCES `mahasiswa` (`NIM`),
  ADD CONSTRAINT `absensi_ibfk_2` FOREIGN KEY (`Kode_Kelas`) REFERENCES `kelas` (`Kode_Kelas`);

--
-- Constraints for table `kelas`
--
ALTER TABLE `kelas`
  ADD CONSTRAINT `kelas_ibfk_1` FOREIGN KEY (`ID_MK`) REFERENCES `mata_kuliah` (`ID_MK`),
  ADD CONSTRAINT `kelas_ibfk_2` FOREIGN KEY (`ID_Dosen`) REFERENCES `dosen` (`ID_Dosen`);

--
-- Constraints for table `kelas_mahasiswa`
--
ALTER TABLE `kelas_mahasiswa`
  ADD CONSTRAINT `kelas_mahasiswa_ibfk_1` FOREIGN KEY (`Kode_Kelas`) REFERENCES `kelas` (`Kode_Kelas`),
  ADD CONSTRAINT `kelas_mahasiswa_ibfk_2` FOREIGN KEY (`NIM`) REFERENCES `mahasiswa` (`NIM`);

--
-- Constraints for table `mahasiswa`
--
ALTER TABLE `mahasiswa`
  ADD CONSTRAINT `mahasiswa_ibfk_1` FOREIGN KEY (`Kode_Prodi`) REFERENCES `program_studi` (`Kode_Prodi`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
