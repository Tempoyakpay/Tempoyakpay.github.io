# 🔐 PANDUAN SETUP PROXY SERVER - KEAMANAN TOKEN

## ⚠️ Masalah Keamanan (Sebelumnya)

Sebelumnya, token Telegram disimpan langsung di **index.html**:
```javascript
const BOT_TOKEN = "8767094720:AAHFansr3UTn-GSHbDfYt6iYfZH60sUDamI"; // ❌ VISIBLE!
const CHAT_ID = "6166201024"; // ❌ VISIBLE!
```

**Risiko:**
- 🚨 Siapa pun bisa membuka DevTools (F12) dan lihat token
- 🚨 Siapa pun bisa melihat token di source code (Ctrl+U)
- 🚨 Bot bisa di-abuse oleh orang lain
- 🚨 Attacker bisa mengirim spam atau pesan berbahaya

---

## ✅ Solusi (Sekarang)

Token sekarang disimpan di **server-side** (.env file):
```env
BOT_TOKEN=8767094720:AAHFansr3UTn-GSHbDfYt6iYfZH60sUDamI  # ✅ HIDDEN dari client!
CHAT_ID=6166201024                                          # ✅ HIDDEN dari client!
```

**Keuntungan:**
- ✅ Token tersembunyi dari browser/public
- ✅ Hanya server yang mengetahui token
- ✅ Client hanya bisa kirim data ke proxy endpoint
- ✅ Semua validasi dilakukan di backend
- ✅ Lebih aman dan professional

---

## 📋 FILE YANG DIBUAT

1. **server.js** → Express backend (proxy)
2. **package.json** → Node.js dependencies
3. **.env** → Konfigurasi (jangan share!)
4. **.gitignore** → Agar .env tidak ter-commit
5. **index.html** → Updated (client tidak lagi tahu token)
6. **README_PROXY_SERVER.md** → Dokumentasi lengkap
7. **QUICK_START.md** → Panduan ini
8. **setup.sh** → Script setup otomatis (Linux/Mac)

---

## 🚀 QUICK START (3 LANGKAH)

### Langkah 1: Buka Terminal di Folder `Materi_Channel_Telegram/`

```bash
# Windows PowerShell:
cd "c:\Users\LANDAIPROJECT\Documents\SCRIPT TERBARU\Materi_Channel_Telegram"

# atau Linux/Mac:
cd ~/path/to/Materi_Channel_Telegram
```

### Langkah 2: Install Dependencies

```bash
npm install
```

**Output yang diharapkan:**
```
added 50 packages in 5s
```

### Langkah 3: Jalankan Server

```bash
npm start
```

**Output yang diharapkan:**
```
🚀 Server berjalan di http://localhost:3000
✅ Proxy endpoint tersedia di http://localhost:3000/api/send-payment-proof
📁 Static files serving dari: ./
```

---

## 🧪 TEST SERVER

### Metode 1: Buka di Browser

```
http://localhost:3000
```

Anda harus melihat halaman VIP Props Injector. Jika berhasil, form siap digunakan!

### Metode 2: Health Check di Terminal

Buka terminal baru dan jalankan:

```bash
curl http://localhost:3000/health
```

**Response yang diharapkan:**
```json
{"status":"ok","message":"Server berjalan dengan baik"}
```

---

## ⚙️ KONFIGURASI .env

File `.env` sudah otomatis dibuat. Isi dengan data Anda:

```env
# Dapatkan dari @BotFather di Telegram
BOT_TOKEN=<PASTE_TOKEN_DARI_BOTFATHER_DI_SINI>

# Chat ID Admin - Dapatkan dari @userinfobot
CHAT_ID=<PASTE_CHAT_ID_DI_SINI>

# Port server
PORT=3000

# Origin yang diizinkan (untuk CORS)
ALLOWED_ORIGINS=http://localhost:3000,http://localhost:5000
```

### Cara Mendapatkan BOT_TOKEN:

1. Buka Telegram
2. Chat dengan **@BotFather**
3. Kirim perintah: `/newbot`
4. Ikuti instruksi (beri nama, username)
5. Copy token yang diberikan

### Cara Mendapatkan CHAT_ID:

1. Chat dengan **@userinfobot**
2. Bot akan mengirim informasi, termasuk User ID
3. Copy User ID tersebut ke CHAT_ID

---

## 🔄 FLOW APLIKASI

### Sebelumnya (Tidak Aman):
```
Browser (Client)
    ↓
[Token terlihat di sini!]
    ↓
Telegram API
```

### Sekarang (Aman):
```
Browser (Client)
    ↓
index.html mengirim:
{name, telegram, photo}
    ↓
Server Proxy (server.js)
[Token tersimpan di .env]
    ↓
Telegram API
```

---

## 📲 TESTING DENGAN FORM

1. Buka: http://localhost:3000
2. Isi form:
   - **Nama Lengkap**: Masukkan nama Anda
   - **Username/ID Telegram**: @username_anda atau chat ID
   - **Bukti Transfer**: Upload screenshot bukti transfer
3. Klik **"Kirim Konfirmasi"**
4. Jika berhasil, pesan akan dikirim ke Telegram Admin

---

## 🆘 TROUBLESHOOTING

### ❌ Error: "Cannot find module 'express'"

**Solusi:**
```bash
npm install
```

### ❌ Error: "Port 3000 already in use"

**Solusi:**
Ganti port di `.env`:
```env
PORT=3001
```

Lalu jalankan ulang:
```bash
npm start
```

### ❌ Error: ".env tidak ditemukan"

**Solusi:**
Pastikan file `.env` ada di folder yang sama dengan `server.js`. Jika belum ada, copy dari `.env` yang sudah dibuat.

### ❌ Error: "CORS error" di browser

**Solusi:**
Update `ALLOWED_ORIGINS` di `.env`:
```env
ALLOWED_ORIGINS=http://localhost:3000,http://localhost:5000,https://your-domain.com
```

### ❌ Error: "BOT_TOKEN atau CHAT_ID belum dikonfigurasi"

**Solusi:**
Buka `.env` dan isi kedua field:
```env
BOT_TOKEN=isi_dengan_token_dari_botfather
CHAT_ID=isi_dengan_chat_id
```

---

## 🌐 DEPLOY KE INTERNET (Optional)

Untuk membuat server bisa diakses dari internet (bukan hanya localhost):

### Opsi 1: Render.com (Recommended - Gratis)

1. Push code ke GitHub (tanpa .env!)
2. Daftar di https://render.com
3. Create New → Web Service
4. Connect GitHub repository
5. Set Build Command: `npm install`
6. Set Start Command: `npm start`
7. Add Environment Variables:
   - BOT_TOKEN
   - CHAT_ID
8. Deploy!

URL server akan seperti: `https://tempoyak-proxy.onrender.com`

### Opsi 2: Railway.app

1. Daftar di https://railway.app
2. Import GitHub repository
3. Set PORT=3000
4. Add environment variables
5. Deploy!

---

## 🔒 SECURITY BEST PRACTICES

- ✅ **Jangan** commit `.env` ke Git
- ✅ **Jangan** share file `.env` ke siapa pun
- ✅ **Jangan** paste BOT_TOKEN di public forum
- ✅ **DO** gunakan `.gitignore` untuk `.env`
- ✅ **DO** simpan `.env` hanya di server
- ✅ **DO** regenerate BOT_TOKEN jika terlalu banyak orang tahu

---

## 📝 NOTES

- Server proxy menangani semua komunikasi dengan Telegram
- Client (browser) tidak perlu tahu tentang token
- Validasi dilakukan di server (lebih aman)
- File upload divalidasi (tipe, ukuran)
- Error handling yang baik

---

## ✨ Selesai!

Proxy server Anda sudah siap digunakan! 🎉

**Pertanyaan?**
- Baca `README_PROXY_SERVER.md` untuk dokumentasi lengkap
- Cek console server untuk debugging
- Gunakan DevTools browser (F12) untuk debugging client-side

Semoga sukses! 🚀
