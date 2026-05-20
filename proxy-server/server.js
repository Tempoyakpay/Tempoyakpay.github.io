const express = require('express');
const cors = require('cors');
const multer = require('multer');
const FormData = require('form-data');
const path = require('path');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// ==========================================
// MIDDLEWARE
// ==========================================

// CORS Configuration
app.use(cors({
    origin: process.env.ALLOWED_ORIGINS?.split(',') || ['http://localhost:3000', 'http://localhost:5000'],
    methods: ['GET', 'POST', 'OPTIONS'],
    credentials: true
}));

// JSON Parser
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Multer untuk file upload
const upload = multer({
    storage: multer.memoryStorage(),
    limits: { fileSize: 5 * 1024 * 1024 }, // 5MB max
    fileFilter: (req, file, cb) => {
        const allowedMimes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];
        if (allowedMimes.includes(file.mimetype)) {
            cb(null, true);
        } else {
            cb(new Error('File type not supported'));
        }
    }
});

// ==========================================
// ENVIRONMENT VARIABLES VALIDATION
// ==========================================

const BOT_TOKEN = process.env.BOT_TOKEN;
const CHAT_ID = process.env.CHAT_ID;

if (!BOT_TOKEN || !CHAT_ID) {
    console.error('❌ ERROR: Konfigurasi .env tidak lengkap!');
    console.error('Required: BOT_TOKEN, CHAT_ID');
    process.exit(1);
}

// ==========================================
// ROUTES
// ==========================================

// Health Check
app.get('/health', (req, res) => {
    res.json({ status: 'ok', message: 'Server berjalan dengan baik' });
});

// Serve Static Files (HTML) - dari parent directory
app.use(express.static(path.join(__dirname, '..')));

// ==========================================
// API ENDPOINT: Send Payment Proof
// ==========================================
app.post('/api/send-payment-proof', upload.single('photo'), async (req, res) => {
    try {
        // Validasi request
        const { name, telegram } = req.body;
        const file = req.file;

        // Validasi field
        if (!name || !telegram || !file) {
            return res.status(400).json({
                success: false,
                error: 'Nama, Telegram, dan foto bukti pembayaran harus diisi'
            });
        }

        // Validasi panjang field
        if (name.length > 100) {
            return res.status(400).json({
                success: false,
                error: 'Nama terlalu panjang (max 100 karakter)'
            });
        }

        if (telegram.length > 100) {
            return res.status(400).json({
                success: false,
                error: 'Username Telegram terlalu panjang (max 100 karakter)'
            });
        }

        // Buat caption dengan data customer
        const caption = `🚀 *PESANAN VIP PROPS MASUK!*\n\n*Nama:* ${name}\n*Telegram:* ${telegram}\n*Status:* ✓ Bukti Transfer Diterima`;

        // Prepare FormData untuk Telegram API
        const form = new FormData();
        form.append('chat_id', CHAT_ID);
        form.append('photo', file.buffer, { filename: file.originalname });
        form.append('caption', caption);
        form.append('parse_mode', 'Markdown');

        // Send ke Telegram Bot API
        const response = await fetch(`https://api.telegram.org/bot${BOT_TOKEN}/sendPhoto`, {
            method: 'POST',
            body: form,
            headers: form.getHeaders()
        });

        const result = await response.json();

        if (result.ok) {
            console.log(`✅ Bukti pembayaran berhasil dikirim dari: ${name}`);
            return res.json({
                success: true,
                message: 'Bukti pembayaran berhasil dikirim! Silakan tunggu, admin akan segera menghubungi Anda.'
            });
        } else {
            console.error('❌ Telegram API Error:', result);
            return res.status(500).json({
                success: false,
                error: `Gagal mengirim ke Telegram: ${result.description || 'Unknown error'}`
            });
        }

    } catch (error) {
        console.error('❌ Server Error:', error);
        return res.status(500).json({
            success: false,
            error: 'Terjadi kesalahan di server. Silakan coba lagi.'
        });
    }
});

// ==========================================
// ERROR HANDLING
// ==========================================

app.use((err, req, res, next) => {
    console.error('❌ Error:', err);
    
    if (err instanceof multer.MulterError) {
        if (err.code === 'FILE_TOO_LARGE') {
            return res.status(413).json({
                success: false,
                error: 'File terlalu besar (max 5MB)'
            });
        }
    }

    if (err.message === 'File type not supported') {
        return res.status(400).json({
            success: false,
            error: 'Tipe file tidak didukung. Gunakan: JPG, PNG, GIF, atau WebP'
        });
    }

    res.status(500).json({
        success: false,
        error: err.message || 'Terjadi kesalahan di server'
    });
});

// ==========================================
// START SERVER
// ==========================================

app.listen(PORT, () => {
    console.log(`🚀 Server berjalan di http://localhost:${PORT}`);
    console.log(`✅ Proxy endpoint tersedia di http://localhost:${PORT}/api/send-payment-proof`);
    console.log(`📁 Static files serving dari: ../ (parent directory)`);
});

// Graceful Shutdown
process.on('SIGTERM', () => {
    console.log('SIGTERM received, shutting down gracefully...');
    process.exit(0);
});
