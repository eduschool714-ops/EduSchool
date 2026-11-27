<?php
// ============================================================
// KONFIGURASI DATABASE — EduSmart (Laragon)
// ============================================================
// Default Laragon: host=localhost, user=root, password=kosong.
// Sesuaikan jika konfigurasi MySQL Anda berbeda.

$DB_HOST = 'localhost';
$DB_NAME = 'edusmart_db';
$DB_USER = 'root';
$DB_PASS = '';
$DB_CHARSET = 'utf8mb4';

try {
    $pdo = new PDO(
        "mysql:host={$DB_HOST};dbname={$DB_NAME};charset={$DB_CHARSET}",
        $DB_USER,
        $DB_PASS,
        [
            PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES   => false,
        ]
    );
} catch (PDOException $e) {
    http_response_code(500);
    header('Content-Type: application/json');
    echo json_encode([
        'error' => 'Koneksi database gagal. Pastikan MySQL Laragon sudah running dan database "edusmart_db" sudah dibuat (import schema.sql).',
        'detail' => $e->getMessage()
    ]);
    exit;
}
