-- ============================================================
-- EduSmart — Skema Database MySQL (untuk Laragon)
-- ============================================================
-- Cara pakai (Laragon):
-- 1. Start Laragon (Apache + MySQL).
-- 2. Buka HeidiSQL / phpMyAdmin (klik kanan icon Laragon > Database).
-- 3. Buat database baru bernama: edusmart_db  (atau import file ini langsung,
--    nanti database-nya otomatis terbuat oleh baris CREATE DATABASE di bawah).
-- 4. Import file schema.sql ini.
--
-- Desain: setiap "tabel data" milik aplikasi (yang sebelumnya berupa array di
-- localStorage: DB.siswa, DB.guru, DB.nilai, dst) dibuatkan tabel MySQL sendiri
-- dengan kolom `id` (primary key) + `payload` (JSON, menyimpan seluruh field
-- objeknya apa adanya). Ini dipilih karena struktur field tiap record di
-- aplikasi ini cukup dinamis (banyak field opsional/berkembang), sehingga
-- pendekatan ini paling aman & tidak gampang error saat aplikasi berkembang,
-- sambil tetap 100% tersimpan sungguhan di MySQL (bukan localStorage lagi).

CREATE DATABASE IF NOT EXISTS edusmart_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE edusmart_db;

-- Pengaturan sekolah (hanya 1 baris, id='main')
CREATE TABLE IF NOT EXISTS settings (
  id VARCHAR(40) NOT NULL PRIMARY KEY,
  payload JSON NOT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Template generik dipakai untuk semua entitas berikut:
-- users, siswa, guru, kelas, mapel, tugas, pengumpulan, nilai, absensi,
-- keuangan, fasilitas, surat, soal, absenGuru, absensiKelas, pengumuman,
-- forum, tagihanSpp, notifPribadi, jadwalGuru, absenScanGuru, absenScanSiswa,
-- rfidTemplates, karirSiswa, karirBerita, bimbinganBK, jadwalPiket,
-- pelanggaranSiswa, hambatanMengajar, rppModul

CREATE TABLE IF NOT EXISTS users (
  id VARCHAR(40) NOT NULL PRIMARY KEY,
  payload JSON NOT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS siswa (
  id VARCHAR(40) NOT NULL PRIMARY KEY,
  payload JSON NOT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS guru (
  id VARCHAR(40) NOT NULL PRIMARY KEY,
  payload JSON NOT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS kelas (
  id VARCHAR(40) NOT NULL PRIMARY KEY,
  payload JSON NOT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS mapel (
  id VARCHAR(40) NOT NULL PRIMARY KEY,
  payload JSON NOT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS tugas (
  id VARCHAR(40) NOT NULL PRIMARY KEY,
  payload JSON NOT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS pengumpulan (
  id VARCHAR(40) NOT NULL PRIMARY KEY,
  payload JSON NOT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS nilai (
  id VARCHAR(40) NOT NULL PRIMARY KEY,
  payload JSON NOT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS absensi (
  id VARCHAR(40) NOT NULL PRIMARY KEY,
  payload JSON NOT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS keuangan (
  id VARCHAR(40) NOT NULL PRIMARY KEY,
  payload JSON NOT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS fasilitas (
  id VARCHAR(40) NOT NULL PRIMARY KEY,
  payload JSON NOT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS surat (
  id VARCHAR(40) NOT NULL PRIMARY KEY,
  payload JSON NOT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS soal (
  id VARCHAR(40) NOT NULL PRIMARY KEY,
  payload JSON NOT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS absenGuru (
  id VARCHAR(40) NOT NULL PRIMARY KEY,
  payload JSON NOT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS absensiKelas (
  id VARCHAR(40) NOT NULL PRIMARY KEY,
  payload JSON NOT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS pengumuman (
  id VARCHAR(40) NOT NULL PRIMARY KEY,
  payload JSON NOT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS forum (
  id VARCHAR(40) NOT NULL PRIMARY KEY,
  payload JSON NOT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS tagihanSpp (
  id VARCHAR(40) NOT NULL PRIMARY KEY,
  payload JSON NOT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS notifPribadi (
  id VARCHAR(40) NOT NULL PRIMARY KEY,
  payload JSON NOT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS jadwalGuru (
  id VARCHAR(40) NOT NULL PRIMARY KEY,
  payload JSON NOT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS absenScanGuru (
  id VARCHAR(40) NOT NULL PRIMARY KEY,
  payload JSON NOT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS absenScanSiswa (
  id VARCHAR(40) NOT NULL PRIMARY KEY,
  payload JSON NOT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS rfidTemplates (
  id VARCHAR(40) NOT NULL PRIMARY KEY,
  payload JSON NOT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS karirSiswa (
  id VARCHAR(40) NOT NULL PRIMARY KEY,
  payload JSON NOT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS karirBerita (
  id VARCHAR(40) NOT NULL PRIMARY KEY,
  payload JSON NOT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS bimbinganBK (
  id VARCHAR(40) NOT NULL PRIMARY KEY,
  payload JSON NOT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Kelasku (wali kelas): jadwal piket kelas
CREATE TABLE IF NOT EXISTS jadwalPiket (
  id VARCHAR(40) NOT NULL PRIMARY KEY,
  payload JSON NOT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Kelasku (wali kelas): catatan pelanggaran siswa
CREATE TABLE IF NOT EXISTS pelanggaranSiswa (
  id VARCHAR(40) NOT NULL PRIMARY KEY,
  payload JSON NOT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Hambatan Mengajar: laporan guru ke akun BK
CREATE TABLE IF NOT EXISTS hambatanMengajar (
  id VARCHAR(40) NOT NULL PRIMARY KEY,
  payload JSON NOT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Upload RPP/Modul: guru upload, masuk ke akun Admin
CREATE TABLE IF NOT EXISTS rppModul (
  id VARCHAR(40) NOT NULL PRIMARY KEY,
  payload JSON NOT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Riwayat pengiriman notifikasi WhatsApp otomatis (Absen Scan RFID / Mode Kios)
CREATE TABLE IF NOT EXISTS notifikasiWaLog (
  id VARCHAR(40) NOT NULL PRIMARY KEY,
  payload JSON NOT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Seed akun admin default (username: admin / password: admin123)
-- Sesuai default bawaan aplikasi (buildDefaultDB() di index.html)
INSERT INTO users (id, payload) VALUES (
  'admin-1',
  JSON_OBJECT(
    'id','admin-1','role','admin','username','admin',
    'password','admin123','nama','Administrator','email','admin@sekolah.id'
  )
) ON DUPLICATE KEY UPDATE id = id;

INSERT INTO settings (id, payload) VALUES (
  'main',
  JSON_OBJECT(
    'namaSekolah','EduSmart','npsn','','alamat','','tahunAjaran','2024/2025',
    'telp','','email','','jamMasuk','07:00','jamPulang','15:00','gajiPerJam',25000
  )
) ON DUPLICATE KEY UPDATE id = id;
