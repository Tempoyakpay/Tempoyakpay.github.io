# Proxy Server Setup Guide

## 📋 Daftar File yang Dibuat

1. **server.js** - Express proxy backend untuk Telegram Bot
2. **package.json** - Daftar dependencies Node.js
3. **.env** - Konfigurasi lingkungan (sensitive data)
4. **index.html** - Updated untuk menggunakan proxy

---

## 🔒 Keamanan - Token di Server-Side

Sebelumnya, token Telegram disimpan langsung di **index.html** (client-side), yang berarti siapa saja bisa melihatnya di Network tab browser atau source code.

Sekarang:
- ✅ Token disimpan di **server** (.env file, tidak ter-expose ke client)
- ✅ Client hanya berkomunikasi dengan proxy endpoint
- ✅ Semua validasi dan komunikasi Telegram dilakukan di backend
- ✅ Endpoint dilindungi CORS

---

## 📥 Instalasi & Setup

### 1. Install Node.js
Pastikan Node.js v14+ sudah terinstall. Download dari: https://nodejs.org/

### 2. Install Dependencies
Buka terminal di folder `Materi_Channel_Telegram/` dan jalankan:

```bash
npm install
```

### 3. Setup .env File
File `.env` sudah dibuat dengan nilai default. Update dengan data Anda:

```
BOT_TOKEN=YOUR_BOT_TOKEN_HERE
CHAT_ID=YOUR_CHAT_ID_HERE
PORT=3000
ALLOWED_ORIGINS=http://localhost:3000,http://localhost:5000
```

**Bagaimana mendapatkan BOT_TOKEN dan CHAT_ID?**

- **BOT_TOKEN**: Hubungi @BotFather di Telegram → `/newbot` → copy token
- **CHAT_ID**: Hubungi @userinfobot di Telegram → lihat ID Anda

### 4. Jalankan Server

```bash
npm start
```

Output:
```
🚀 Server berjalan di http://localhost:3000
✅ Proxy endpoint tersedia di http://localhost:3000/api/send-payment-proof
📁 Static files serving dari: ./
```

### 5. Test Server
Buka browser: http://localhost:3000

Atau jalankan:
```bash
curl http://localhost:3000/health
```

---

## 🔄 Request/Response Flow

### Client → Server → Telegram

```
┌─────────────────┐
│   index.html    │
│   (Browser)     │
└────────┬────────┘
         │ POST /api/send-payment-proof
         │ (name, telegram, photo)
         ↓
┌─────────────────────────────────────┐
│        server.js (Proxy)            │
│  - Validasi input                   │
│  - Buat caption                     │
│  - Gunakan BOT_TOKEN (.env)         │
└────────┬────────────────────────────┘
         │ POST /sendPhoto
         │ (Gunakan BOT_TOKEN dari .env)
         ↓
┌──────────────────────┐
│   Telegram Bot API   │
│   api.telegram.org   │
└──────────────────────┘
```

---

## 📝 Contoh Request (cURL)

```bash
curl -X POST http://localhost:3000/api/send-payment-proof \
  -F "name=John Doe" \
  -F "telegram=@johndoe" \
  -F "photo=@/path/to/photo.jpg"
```

Response Success:
```json
{
  "success": true,
  "message": "Bukti pembayaran berhasil dikirim! Silakan tunggu, admin akan segera menghubungi Anda."
}
```

Response Error:
```json
{
  "success": false,
  "error": "Nama, Telegram, dan foto bukti pembayaran harus diisi"
}
```

---

## 🔧 Environment Variables (.env)

```env
# Telegram Bot Configuration
BOT_TOKEN=<bot_token_dari_botfather>
CHAT_ID=<chat_id_admin>

# Server Configuration
PORT=3000
ALLOWED_ORIGINS=http://localhost:3000,http://localhost:5000

# Environment
NODE_ENV=development
```

---

## ⚠️ JANGAN LUPA!

- ❌ **JANGAN** share file `.env` ke publik/GitHub
- ❌ **JANGAN** commit `.env` ke repository
- ✅ **DO** gunakan `.gitignore` untuk `.env`
- ✅ **DO** simpan `.env` di server production saja

---

## 🚀 Deployment (Production)

### Opsi 1: Render.com (Gratis + $7/bulan untuk uptime)
1. Push code ke GitHub
2. Connect repository ke Render
3. Set environment variables di dashboard Render
4. Deploy!

### Opsi 2: Railway.app
1. Connect GitHub repository
2. Set PORT=3000
3. Add environment variables
4. Deploy!

### Opsi 3: Self-hosted (VPS)
1. Install Node.js di server
2. Upload code
3. Jalankan `npm install` && `npm start`
4. Gunakan PM2 untuk keep server running:
   ```bash
   npm install -g pm2
   pm2 start server.js --name "tempoyak-proxy"
   pm2 startup
   pm2 save
   ```

---

## 🔗 Update index.html untuk Production

Jika deploy di domain lain, update ini di `index.html`:

```javascript
// Development
const PROXY_ENDPOINT = "http://localhost:3000/api/send-payment-proof";

// Production
const PROXY_ENDPOINT = "https://your-domain.com/api/send-payment-proof";
```

---

## 🐛 Troubleshooting

### Error: "Cannot find module 'express'"
```bash
npm install
```

### Error: ".env file not found"
Pastikan `.env` file ada di folder yang sama dengan `server.js`

### CORS Error di Browser
Update `ALLOWED_ORIGINS` di `.env`:
```env
ALLOWED_ORIGINS=http://localhost:3000,https://your-domain.com
```

### File tidak ter-upload
- Pastikan file < 5MB
- Format: JPG, PNG, GIF, atau WebP

---

## 📞 Support

Jika ada error, cek:
1. Console server (`npm start` output)
2. Browser DevTools (F12 → Network tab)
3. File `.env` sudah dikonfigurasi dengan benar

---

## ✨ Fitur Keamanan yang Sudah Diterapkan

- ✅ Token Telegram di server (hidden dari client)
- ✅ Input validation (nama, telegram, file)
- ✅ File size limit (5MB max)
- ✅ MIME type validation (hanya image)
- ✅ CORS protection
- ✅ Error handling yang proper
- ✅ Graceful shutdown
- ✅ Environment variable untuk config

---

**Setup selesai! 🎉 Server proxy Anda sudah aman dan siap digunakan.**
