<?php
// ============================================================
// EduSmart API — jembatan antara aplikasi (JS) dan MySQL (Laragon)
// ============================================================
// Endpoint:
//   GET  api.php?action=load   -> kembalikan seluruh data (bentuk sama seperti
//                                  objek DB {} di JS: {settings, users, siswa, ...})
//   POST api.php?action=save   -> body = JSON seluruh objek DB, akan disimpan
//                                  (replace total, per tabel) ke MySQL
//
// Catatan keamanan: hanya nama tabel di whitelist ini yang boleh diakses,
// untuk mencegah SQL Injection lewat nama tabel.

header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') { http_response_code(204); exit; }

require __DIR__ . '/config.php';

// Daftar entitas array (harus PERSIS sama dengan key di buildDefaultDB() pada index.html)
const ENTITY_TABLES = [
    'users', 'siswa', 'guru', 'kelas', 'mapel', 'tugas', 'pengumpulan', 'nilai',
    'absensi', 'keuangan', 'fasilitas', 'surat', 'soal', 'absenGuru', 'absensiKelas',
    'pengumuman', 'forum', 'tagihanSpp', 'notifPribadi', 'jadwalGuru',
    'absenScanGuru', 'absenScanSiswa', 'rfidTemplates', 'karirSiswa',
    'karirBerita', 'bimbinganBK', 'jadwalPiket', 'pelanggaranSiswa',
    'hambatanMengajar', 'rppModul', 'notifikasiWaLog'
];

$action = $_GET['action'] ?? '';

function respond($data, $code = 200) {
    http_response_code($code);
    echo json_encode($data, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    exit;
}

if ($action === 'load') {
    $result = [];

    // settings (satu baris, id='main')
    $stmt = $pdo->prepare('SELECT payload FROM settings WHERE id = :id LIMIT 1');
    $stmt->execute(['id' => 'main']);
    $row = $stmt->fetch();
    $result['settings'] = $row ? json_decode($row['payload'], true) : new stdClass();

    // setiap entitas array
    foreach (ENTITY_TABLES as $table) {
        $stmt = $pdo->query("SELECT payload FROM `{$table}`");
        $items = [];
        foreach ($stmt->fetchAll() as $r) {
            $items[] = json_decode($r['payload'], true);
        }
        $result[$table] = $items;
    }

    respond($result);
}

if ($action === 'save') {
    $raw = file_get_contents('php://input');
    $data = json_decode($raw, true);
    if (!is_array($data)) {
        respond(['error' => 'Body JSON tidak valid'], 400);
    }

    try {
        $pdo->beginTransaction();

        // settings
        if (isset($data['settings'])) {
            $stmt = $pdo->prepare(
                'INSERT INTO settings (id, payload) VALUES (:id, :payload)
                 ON DUPLICATE KEY UPDATE payload = VALUES(payload)'
            );
            $stmt->execute([
                'id' => 'main',
                'payload' => json_encode($data['settings'], JSON_UNESCAPED_UNICODE)
            ]);
        }

        // setiap entitas array: replace total isi tabel supaya selalu sinkron
        // dengan state terbaru di aplikasi (mirror perilaku localStorage lama).
        foreach (ENTITY_TABLES as $table) {
            $items = $data[$table] ?? [];
            if (!is_array($items)) continue;

            $pdo->exec("DELETE FROM `{$table}`");

            $ins = $pdo->prepare(
                "INSERT INTO `{$table}` (id, payload) VALUES (:id, :payload)"
            );
            foreach ($items as $item) {
                $id = $item['id'] ?? (uniqid('', true));
                $ins->execute([
                    'id' => $id,
                    'payload' => json_encode($item, JSON_UNESCAPED_UNICODE)
                ]);
            }
        }

        $pdo->commit();
        respond(['ok' => true]);
    } catch (Exception $e) {
        $pdo->rollBack();
        respond(['error' => 'Gagal menyimpan ke database', 'detail' => $e->getMessage()], 500);
    }
}

respond(['error' => 'action tidak dikenal. Gunakan ?action=load atau ?action=save'], 400);
