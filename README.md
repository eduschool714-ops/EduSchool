# Setup EduSmart di Laragon

## 1. Salin folder project
Salin folder ini (berisi `index.html`, `api.php`, `config.php`, `schema.sql`) ke:

```
C:\laragon\www\edusmart
```

## 2. Buat database
1. Buka **Laragon** → klik **Start All** (Apache + MySQL harus hidup).
2. Klik kanan icon Laragon di tray → **Database** (akan membuka HeidiSQL), atau buka
   `http://localhost/phpmyadmin`.
3. Import file `schema.sql` (menu *Import* / drag file-nya). Ini otomatis:
   - Membuat database `edusmart_db`
   - Membuat semua tabel (settings, users, siswa, guru, kelas, nilai, dll)
   - Mengisi 1 akun admin default: **username `admin` / password `admin123`**

Kalau nama database/koneksi MySQL Anda beda dari default Laragon, sesuaikan
`$DB_HOST`, `$DB_NAME`, `$DB_USER`, `$DB_PASS` di `config.php`.

## 3. Jalankan aplikasi
Buka browser ke:

```
http://edusmart.test/
```
(Laragon otomatis membuat domain `.test` sesuai nama folder), atau:
```
http://localhost/edusmart/
```

Jangan buka `index.html` dengan cara double-click file (`file://...`) — itu
akan membuat aplikasi tidak bisa menghubungi `api.php` (browser blokir request
antar-protokol), dan otomatis balik memakai localStorage saja.

## 4. Cara kerja penyimpanan data
- Saat aplikasi dibuka, `index.html` memanggil `api.php?action=load` untuk
  mengambil seluruh data dari MySQL.
- Setiap kali aplikasi menyimpan perubahan (`saveDB()` dipanggil), data juga
  dikirim ke `api.php?action=save` dan disimpan ke MySQL.
- localStorage tetap dipakai sebagai cadangan/offline-cache, tapi sumber data
  utama sekarang adalah **MySQL**, sesuai permintaan.

## 5. Struktur tabel
Semua entitas (siswa, guru, nilai, absensi, keuangan, forum, dst — 30 tabel
total, lihat `schema.sql`) disimpan dengan pola:

| Kolom | Isi |
|---|---|
| `id` | id unik record (sama seperti `id` di JS) |
| `payload` | seluruh isi objek record dalam format JSON |
| `updated_at` | waktu terakhir diubah |

Pendekatan ini dipilih karena field tiap record di aplikasi ini banyak yang
opsional/berkembang seiring fitur baru — jadi aman dari error "kolom tidak
ada" setiap kali ada penambahan field baru di aplikasi.

## 6. File yang diedit dari versi asli
- `index.html`: dihapus 1 baris `<link>` icon CDN yang menyebabkan **icon
  dobel** (font-icon dari CDN tumpang tindih dengan SVG icon buatan sendiri).
  `initDB()` dan `saveDB()` diubah agar terhubung ke `api.php` (MySQL), dengan
  fallback otomatis ke localStorage jika server tidak terjangkau. Ditambahkan
  menu **Mode Kios RFID** dan **Notifikasi WhatsApp** (lihat poin 7c & 7d),
  serta field **No. HP/WA Wali** pada Data Siswa.
- `api.php` & `schema.sql`: ditambahkan tabel `notifikasiWaLog` untuk
  menyimpan riwayat pengiriman notifikasi WhatsApp.

## 7. Fitur baru (update ini)

### a. Desain Template RFID (Admin → menu "Template RFID")
- Admin bisa mengubah **warna utama & warna aksen**, **warna teks header**, **warna teks isi kartu**,
  **model/jenis huruf**, serta **ukuran tulisan nama & label** pada ID Card RFID.
- Pengaturan desain **terpisah untuk Guru dan Murid** (tab "Template Guru" / "Template Murid").
- Setiap perubahan bisa disimpan sebagai **template baru** (boleh banyak template), lalu dipilih
  sebagai template aktif untuk Guru dan/atau Murid secara independen.
- Ada live preview kartu di sisi kanan saat mengedit.
- Fitur upload file desain referensi (PNG/JPG/SVG/PDF) lama tetap tersedia (opsional).

### b. Absensi Radius Lokasi (Admin → menu "Absensi Radius Lokasi")
- Admin mengatur titik lokasi sekolah (latitude/longitude, bisa diambil otomatis dari GPS perangkat)
  dan radius toleransi (meter), lalu mengaktifkan validasi.
- Saat aktif, setiap proses **Absen Scan RFID** (guru maupun siswa) akan meminta izin lokasi (GPS)
  browser dan menghitung jarak ke titik lokasi sekolah (rumus Haversine). Jika di luar radius,
  absen otomatis ditolak.
- Jarak & koordinat saat absen ikut disimpan pada data absen untuk keperluan audit.

Catatan: fitur GPS browser umumnya memerlukan koneksi HTTPS atau akses dari `localhost`. Jika
diakses lewat domain `.test` Laragon (HTTP biasa) dan browser menolak permintaan lokasi, nonaktifkan
sementara validasi radius pada halaman "Absensi Radius Lokasi", atau akses aplikasi lewat `https`.

### c. Mode Kios RFID (Admin → menu "Mode Kios RFID")
- Menampilkan layar penuh (fullscreen) yang bisa ditempatkan di komputer/tablet dekat pintu masuk
  sekolah, dilengkapi alat pembaca kartu RFID USB (tipe *keyboard-emulation* — mengetik kode kartu
  lalu Enter secara otomatis, seperti scanner barcode biasa).
- Guru dan siswa cukup **menempelkan/scan kartu RFID** masing-masing pada alat pembaca. Sistem
  otomatis mendeteksi kode, mencocokkan ke data guru/siswa, mencatat absen datang/pulang, lalu
  **menampilkan data (foto, nama, kelas/jabatan, jam, status)** di layar selama beberapa detik
  sebelum kembali ke tampilan siap-scan berikutnya.
- Kartu yang tidak dikenali atau absen yang sudah lengkap akan menampilkan pesan penolakan di layar.
- Tekan tombol **Esc** atau tombol **Keluar** di pojok layar untuk kembali ke menu Admin biasa.
- Jika validasi radius lokasi (fitur b di atas) sedang aktif, perangkat kios wajib mengizinkan akses
  GPS browser dan berada dalam radius yang ditentukan, sama seperti halaman Absen Scan RFID biasa.

### d. Notifikasi WhatsApp Otomatis (Admin → menu "Notifikasi WhatsApp")
- Setiap kali guru atau siswa **Absen Scan RFID** — baik lewat halaman "Absen Kehadiran (Scan RFID)"
  maupun lewat **Mode Kios RFID** — sistem otomatis mengirim pesan WhatsApp ke:
  1. **Grup WA Guru** (selalu, untuk absen guru maupun siswa, agar guru piket/wali kelas ikut tahu).
  2. **Orang tua siswa** — bisa dipilih salah satu:
     - Dikirim ke **nomor WA pribadi** masing-masing wali murid (diisi di menu Data Siswa, field
       **"No. HP/WA Wali"**; jika kosong sistem memakai No. HP siswa), atau
     - Dikirim ke satu **Grup WA Orang Tua** bersama (aktifkan opsi *"Kirim ke satu Grup WA Orang
       Tua"* di menu Notifikasi WhatsApp).
- **Wajib disiapkan sendiri**: sebuah akun **WA Gateway pihak ketiga** yang mendukung format request
  sederhana `target` + `message` (contoh: [Fonnte](https://fonnte.com), Wablas, atau layanan
  sejenis). Aplikasi ini **tidak** menyertakan gateway WhatsApp sendiri — hanya menghubungkan ke
  gateway yang endpoint & token-nya diisi admin. Langkah setup umum (contoh Fonnte):
  1. Daftar & scan QR WhatsApp perangkat pengirim di dashboard Fonnte.
  2. Salin **Token API** dari dashboard.
  3. (Opsional, untuk kirim ke grup) catat **ID Grup WA** guru dan/atau orang tua dari dashboard
     gateway — biasanya berupa nomor unik grup, bukan link undangan.
  4. Buka menu **Notifikasi WhatsApp** di aplikasi ini → centang **Aktifkan** → isi **Endpoint**
     (default `https://api.fonnte.com/send`, sesuaikan jika pakai gateway lain) → isi **Token** →
     isi **Nomor/ID Grup WA Guru** → simpan.
  5. Gunakan tombol **"Uji Coba Kirim Pesan"** untuk memastikan token & endpoint sudah benar sebelum
     dipakai di lapangan.
  6. Riwayat pengiriman (berhasil/gagal) bisa dilihat di bagian bawah halaman yang sama.
- Template pesan bisa diubah bebas di menu yang sama, memakai variabel `{nama}`, `{kelas}`,
  `{jenis}` (Datang/Pulang/Masuk/dll), `{jam}`, `{tanggal}`, `{sekolah}`.
- Jika token/endpoint belum diisi atau fitur belum diaktifkan, absen tetap tercatat normal — hanya
  pengiriman WA yang dilewati (ditandai di riwayat & di popup hasil scan).
