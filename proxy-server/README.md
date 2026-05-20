# 🔒 Proxy Server Setup Guide

## 📋 Struktur Folder

```
Materi_Channel_Telegram/
├── proxy-server/              ← Folder server (BACKEND)
│   ├── server.js              ← Express app utama
│   ├── package.json           ← Dependencies
│   ├── .env                   ← Config (BOT_TOKEN, CHAT_ID) ⚠️ JANGAN SHARE!
│   ├── .gitignore             ← Agar .env tidak ter-commit
│   ├── setup.sh               ← Setup script (Linux/Mac)
│   ├── setup.bat              ← Setup script (Windows)
│   ├── README.md              ← Dokumentasi ini
│   └── node_modules/          ← Dependencies (otomatis dibuat)
│
├── index.html                 ← Frontend form (di-update)
├── pay.html
├── checkout_vip.html
└── ... file lainnya
```

---

## 🔒 Keamanan - Token di Server-Side

### Sebelum (❌ Tidak Aman):
Token tersimpan di **index.html** → Visible di DevTools browser

### Sekarang (✅ Aman):
Token tersimpan di **proxy-server/.env** → Hidden dari client-side

---

## 🚀 QUICK START (3 Langkah)

### Langkah 1: Buka Terminal di Folder `proxy-server/`

```bash
# Windows (PowerShell):
cd "c:\Users\LANDAIPROJECT\Documents\SCRIPT TERBARU\Materi_Channel_Telegram\proxy-server"

# Linux/Mac:
cd ~/path/to/Materi_Channel_Telegram/proxy-server
```

### Langkah 2: Install Dependencies

**Opsi A - Manual:**
```bash
npm install
```

**Opsi B - Auto Setup (Recommended):**
- **Windows:** Klik dua kali `setup.bat`
- **Linux/Mac:** `bash setup.sh`

### Langkah 3: Jalankan Server

```bash
npm start
```

**Output yang diharapkan:**
```
🚀 Server berjalan di http://localhost:3000
✅ Proxy endpoint tersedia di http://localhost:3000/api/send-payment-proof
📁 Static files serving dari: ../ (parent directory)
```

---

## 📝 Konfigurasi .env

File `.env` sudah dibuat. Update dengan data Anda:

```env
# Dapatkan dari @BotFather di Telegram
BOT_TOKEN=8767094720:AAHFansr3UTn-GSHbDfYt6iYfZH60sUDamI

# Chat ID Admin - Dapatkan dari @userinfobot
CHAT_ID=6166201024

# Port server
PORT=3000

# Origin yang diizinkan (CORS)
ALLOWED_ORIGINS=http://localhost:3000,http://localhost:5000,http://127.0.0.1:5000

# Environment
NODE_ENV=development
```

### Cara Mendapatkan BOT_TOKEN:
1. Buka Telegram → Chat **@BotFather**
2. Kirim: `/newbot`
3. Ikuti instruksi (beri nama, username)
4. Copy token yang diberikan → Paste ke .env

### Cara Mendapatkan CHAT_ID:
1. Chat dengan **@userinfobot**
2. Bot akan kirim User ID Anda
3. Copy → Paste ke .env

---

## 🧪 TEST SERVER

### Test 1: Health Check (Terminal Baru)

```bash
curl http://localhost:3000/health
```

**Response:**
```json
{"status":"ok","message":"Server berjalan dengan baik"}
```

### Test 2: Buka di Browser

```
http://localhost:3000
```

Anda harus melihat halaman **VIP Props Injector**. Jika berhasil, form siap digunakan!

---

## 🔄 Cara Kerja

```
User Upload Form (Browser)
    ↓
POST /api/send-payment-proof
{name, telegram, photo}
    ↓
Server (server.js)
- Validasi input
- Baca BOT_TOKEN dari .env (AMAN!)
- Kirim ke Telegram API
    ↓
Telegram Bot Terima
    ↓
Admin Chat (Telegram)
```

---

## 📝 Contoh Request (cURL)

```bash
curl -X POST http://localhost:3000/api/send-payment-proof \
  -F "name=John Doe" \
  -F "telegram=@johndoe" \
  -F "photo=@/path/to/photo.jpg"
```

**Response Success:**
```json
{
  "success": true,
  "message": "Bukti pembayaran berhasil dikirim!"
}
```

**Response Error:**
```json
{
  "success": false,
  "error": "Nama, Telegram, dan foto bukti pembayaran harus diisi"
}
```

---

## 🐛 Troubleshooting

### ❌ Error: "Cannot find module 'express'"
```bash
npm install
```

### ❌ Error: "Port 3000 already in use"
Ganti PORT di `.env`:
```env
PORT=3001
```
Jalankan ulang: `npm start`

### ❌ Error: ".env tidak ditemukan"
Pastikan file `.env` ada di folder `proxy-server/`

### ❌ CORS Error di Browser
Update `.env`:
```env
ALLOWED_ORIGINS=http://localhost:3000,http://localhost:5000
```

### ❌ Token tidak diterima
Pastikan `.env` sudah terisi:
```env
BOT_TOKEN=xxx
CHAT_ID=xxx
```

---

## 🚀 DEPLOYMENT (Production)

### Opsi 1: Render.com (Recommended)
1. Push ke GitHub (tanpa `.env`!)
2. Daftar di https://render.com
3. Create Web Service
4. Connect GitHub repository
5. Set environment variables di dashboard
6. Deploy!

### Opsi 2: Railway.app
1. Connect GitHub
2. Set PORT=3000
3. Add env variables
4. Deploy!

### Opsi 3: VPS (Self-hosted)
```bash
npm install -g pm2
pm2 start server.js --name "tempoyak-proxy"
pm2 startup
pm2 save
```

---

## 📌 Update index.html untuk Production

Jika deploy, update `PROXY_ENDPOINT` di **index.html**:

```javascript
// Development (localhost)
const PROXY_ENDPOINT = "http://localhost:3000/api/send-payment-proof";

// Production (domain)
const PROXY_ENDPOINT = "https://your-domain.com/api/send-payment-proof";
```

---

## ⚠️ SECURITY TIPS

- ❌ Jangan share file `.env`
- ❌ Jangan commit `.env` ke Git
- ✅ Gunakan `.gitignore` untuk `.env`
- ✅ Simpan `.env` hanya di server
- ✅ Regenerate BOT_TOKEN jika terekspos

---

## ✨ Fitur Keamanan

- ✅ Token di server (hidden dari client)
- ✅ Input validation (nama, telegram, file)
- ✅ File size limit (5MB max)
- ✅ MIME type validation (hanya image)
- ✅ CORS protection
- ✅ Error handling
- ✅ Graceful shutdown

---

## 📞 Need Help?

1. Cek console server (`npm start` output)
2. Cek DevTools browser (F12)
3. Pastikan `.env` terisi dengan benar
4. Pastikan Node.js versi 14+

**Done! ✨ Server proxy Anda siap digunakan!**
