@echo off
REM Script untuk quick setup proxy server (Windows)

echo.
echo ==========================================
echo.
echo 🚀 TEMPOYAK PROXY SERVER - QUICK SETUP
echo.
echo ==========================================
echo.

REM Cek apakah Node.js sudah terinstall
where node >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Node.js tidak terinstall!
    echo 📥 Download dari: https://nodejs.org/
    pause
    exit /b 1
)

echo ✅ Node.js terdeteksi:
node --version
npm --version
echo.

REM Install dependencies
echo 📦 Menginstall dependencies...
call npm install

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ❌ Gagal menginstall dependencies
    pause
    exit /b 1
)

echo.
echo ✅ Dependencies berhasil diinstall!
echo.

REM Check .env file
if not exist ".env" (
    echo ⚠️  File .env tidak ditemukan!
    echo 📝 Pastikan file .env sudah dibuat dengan BOT_TOKEN dan CHAT_ID
    echo.
)

echo ==========================================
echo ✨ Setup selesai! Jalankan:
echo    npm start
echo.
echo 🌐 Server akan berjalan di:
echo    http://localhost:3000
echo ==========================================
echo.
pause
