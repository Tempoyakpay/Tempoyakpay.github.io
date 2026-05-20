#!/bin/bash
# Script untuk quick setup proxy server

echo "=========================================="
echo "🚀 TEMPOYAK PROXY SERVER - QUICK SETUP"
echo "=========================================="
echo ""

# Cek apakah Node.js sudah terinstall
if ! command -v node &> /dev/null; then
    echo "❌ Node.js tidak terinstall!"
    echo "📥 Download dari: https://nodejs.org/"
    exit 1
fi

echo "✅ Node.js terdeteksi:"
node --version
npm --version
echo ""

# Install dependencies
echo "📦 Menginstall dependencies..."
npm install

if [ $? -ne 0 ]; then
    echo "❌ Gagal menginstall dependencies"
    exit 1
fi

echo ""
echo "✅ Dependencies berhasil diinstall!"
echo ""

# Check .env file
if [ ! -f ".env" ]; then
    echo "⚠️  File .env tidak ditemukan!"
    echo "📝 Pastikan file .env sudah dibuat dengan BOT_TOKEN dan CHAT_ID"
    echo ""
fi

echo "=========================================="
echo "✨ Setup selesai! Jalankan:"
echo "   npm start"
echo ""
echo "🌐 Server akan berjalan di:"
echo "   http://localhost:3000"
echo "=========================================="
