# 📦 STRUKTUR FOLDER - PROXY SERVER SETUP

## 🎯 Folder Organization

```
Materi_Channel_Telegram/
│
├── proxy-server/                    ← 📁 BACKEND SERVER (BARU!)
│   ├── server.js                    ← Express app
│   ├── package.json                 ← Dependencies
│   ├── .env                         ← Config (BOT_TOKEN, CHAT_ID) ⚠️
│   ├── .gitignore                   ← Agar .env tidak ter-commit
│   ├── setup.sh                     ← Setup otomatis (Linux/Mac)
│   ├── setup.bat                    ← Setup otomatis (Windows)
│   ├── README.md                    ← Dokumentasi
│   └── node_modules/                ← Auto-generated (jangan commit)
│
├── index.html                       ← ✅ UPDATED (client-side)
├── pay.html
├── checkout_vip.html
├── STRUKTUR_FOLDER.md               ← File ini
└── ... file lainnya
```

---

## 🚀 QUICK START

### 1️⃣ Install & Setup

```bash
# Buka folder proxy-server
cd proxy-server

# Opsi A: Manual install
npm install

# Opsi B: Auto setup (Recommended)
# Windows: Klik setup.bat
# Linux/Mac: bash setup.sh
```

### 2️⃣ Jalankan Server

```bash
npm start
```

**Output:**
```
🚀 Server berjalan di http://localhost:3000
✅ Proxy endpoint tersedia di http://localhost:3000/api/send-payment-proof
```

### 3️⃣ Test di Browser

```
http://localhost:3000
```

---

## 📝 File-File Penting

| File | Lokasi | Fungsi |
|------|--------|--------|
| **server.js** | `proxy-server/` | Express backend (proxy) |
| **.env** | `proxy-server/` | Token Telegram (JANGAN SHARE!) |
| **package.json** | `proxy-server/` | Dependencies Node.js |
| **index.html** | `Materi_Channel_Telegram/` | Frontend form (UPDATED) |

---

## ⚙️ Konfigurasi .env

Buka `proxy-server/.env` dan isi:

```env
BOT_TOKEN=<dari_botfather>
CHAT_ID=<dari_userinfobot>
PORT=3000
ALLOWED_ORIGINS=http://localhost:3000,http://localhost:5000
```

---

## 🔄 Request Flow

```
1. User akses http://localhost:3000 (server.js serve index.html)
2. User isi form & upload bukti
3. Form submit → POST /api/send-payment-proof
4. Server validasi & kirim ke Telegram
5. Admin terima di Telegram
```

---

## ✅ Keamanan

- ✅ Token Telegram disimpan di **server** (`.env`)
- ✅ Client tidak tahu token
- ✅ Validasi dilakukan di backend
- ✅ CORS protection

---

## 🎯 Perbedaan Sebelum & Sesudah

### ❌ SEBELUM (Tidak Aman):
```
index.html
├── const BOT_TOKEN = "xxx" ← VISIBLE di DevTools!
├── const CHAT_ID = "xxx"   ← VISIBLE di DevTools!
└── fetch("telegram.org...") ← Direct ke API
```

### ✅ SESUDAH (Aman):
```
proxy-server/
├── .env
│   ├── BOT_TOKEN = "xxx"   ← HIDDEN dari client!
│   └── CHAT_ID = "xxx"     ← HIDDEN dari client!
└── server.js
    └── Gunakan token dari .env untuk API calls

index.html
└── fetch("localhost:3000/api/send-payment-proof")
    └── Server handle token securely
```

---

## 📞 Troubleshooting

### Port sudah terpakai?
Edit `.env`:
```env
PORT=3001
```

### Module tidak ketemu?
```bash
cd proxy-server
npm install
```

### .env tidak terdeteksi?
Pastikan file berada di: `proxy-server/.env`

---

## 🎉 Selesai!

Semua file backend sudah terorganisir dalam folder `proxy-server/`. 
Frontend (index.html) sudah update untuk menggunakan proxy endpoint.

**Siap dijalankan! 🚀**

---

**Next Steps:**
1. Konfigurasi `.env` dengan token Anda
2. Jalankan `npm start` di folder `proxy-server/`
3. Buka `http://localhost:3000` di browser
4. Test form
5. Done!

Dokumentasi lengkap: Baca `proxy-server/README.md`
