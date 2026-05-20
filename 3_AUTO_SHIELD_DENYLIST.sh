#!/system/bin/sh
# =================================================================
# Script          : AUTO-SHIELD (DenyList Configurator)
# Fungsi          : Memasukkan aplikasi pelacak otomatis ke DenyList Magisk
# Membutuhkan     : Akses Root (Magisk + Zygisk)
# Author          : TEMPOYAKID | t.me/TempoyakID_root
# =================================================================

# =============================================
# PROTEKSI COPYRIGHT - JANGAN DIUBAH/DIHAPUS
# © 2026 Powered by TEMPOYAKID
# Telegram: @TempoyakID_root
# =============================================
WATERMARK="Powered by TEMPOYAKID"
SCRIPT_SELF="$(realpath "$0" 2>/dev/null || readlink -f "$0" 2>/dev/null || echo "$0")"
if ! grep -q "Powered by TEMPOYAKID" "$SCRIPT_SELF" 2>/dev/null; then
  echo -e "\033[1;31m🚫 Skrip telah dimodifikasi. Hak cipta dihapus. Diblokir.\033[0m"
  exit 1
fi
# =============================================

if [ "$(id -u 2>/dev/null)" != "0" ]; then exec su -c "sh \"$0\" \"$@\""; fi

C='\033[1;36m'; G='\033[1;32m'; Y='\033[1;33m'; R='\033[1;31m'; NC='\033[0m'

clear
echo -e "${C}╔══════════════════════════════════════════╗${NC}"
echo -e "${C}║${G}         🛡️ AUTO SHIELD ROOT 🛡️          ${C}║${NC}"
echo -e "${C}╚══════════════════════════════════════════╝${NC}\n"

echo -e "${Y}Mengonfigurasi Magisk DenyList secara otomatis...${NC}"

# Target List (Shopee, Gojek, Grab, Bank)
TARGETS="com.shopee.id com.gojek.app com.grabtaxi.passenger id.dana ovo.id com.tokopedia.tkpd"

# Cek command magisk
if ! command -v magisk >/dev/null; then
    echo -e "${R}❌ Magisk tidak terdeteksi! Skrip ini khusus pengguna Magisk.${NC}"
    exit 1
fi

magisk --sqlite "UPDATE settings SET value=1 WHERE key='zygisk';" >/dev/null 2>&1
echo -e "${C}▸ Zygisk diaktifkan${NC}"

for pkg in $TARGETS; do
    if pm path "$pkg" >/dev/null 2>&1; then
        echo -e "${C}▸ Menambahkan ${Y}$pkg${C} ke DenyList...${NC}"
        # Dapatkan UID dari package
        UID=$(dumpsys package "$pkg" | grep -m1 "userId=" | cut -d'=' -f2)
        if [ -n "$UID" ]; then
            magisk --denylist add "$pkg" "$pkg" >/dev/null 2>&1
            echo -e "${G}  ✔ Berhasil!${NC}"
        fi
    fi
done

echo -e "\n${G}🎉 Selesai! Aplikasi pelacak sudah buta terhadap Root Anda.${NC}"
echo -e "${Y}Jangan lupa gunakan Shamiko jika memakai Magisk!${NC}"
