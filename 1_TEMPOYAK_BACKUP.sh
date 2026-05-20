#!/system/bin/sh
# =================================================================
# Script          : TEMPOYAK BACKUP-RESTORE (Tanpa Aplikasi Titanium)
# Fungsi          : Mem-backup & Restore data aplikasi (Shopee/WA) murni via Shell
# Membutuhkan     : Akses Root
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
BACKUP_DIR="/sdcard/Tempoyak_Backups"
mkdir -p "$BACKUP_DIR"

clear
echo -e "${C}╔══════════════════════════════════════════╗${NC}"
echo -e "${C}║${G}       📦 TEMPOYAK BACKUP ENGINE 📦       ${C}║${NC}"
echo -e "${C}╚══════════════════════════════════════════╝${NC}\n"

echo -e "1. Backup Data Aplikasi"
echo -e "2. Restore Data Aplikasi"
printf "${Y}Pilih mode (1/2): ${NC}"
read MODE

printf "${Y}Masukkan Package Name (contoh: com.shopee.id / com.whatsapp): ${NC}"
read PKG_NAME

if [ "$MODE" = "1" ]; then
    echo -e "\n${C}▸ Memulai proses Backup...${NC}"
    am force-stop "$PKG_NAME" 2>/dev/null
    
    if [ ! -d "/data/data/$PKG_NAME" ]; then
        echo -e "${R}❌ Aplikasi $PKG_NAME belum terinstal atau tidak ada data!${NC}"
        exit 1
    fi
    
    FILE_NAME="${PKG_NAME}_$(date +%Y%m%d_%H%M%S).tar.gz"
    cd /data/data/
    tar -czf "$BACKUP_DIR/$FILE_NAME" "$PKG_NAME" 2>/dev/null
    
    echo -e "${G}✔ Backup Selesai!${NC}"
    echo -e "File tersimpan di: ${Y}$BACKUP_DIR/$FILE_NAME${NC}"

elif [ "$MODE" = "2" ]; then
    echo -e "\n${C}▸ Daftar Backup yang tersedia:${NC}"
    ls -1 "$BACKUP_DIR" | grep "$PKG_NAME" | nl
    
    printf "\n${Y}Ketik nomor file yang ingin di-restore: ${NC}"
    read FILE_NUM
    
    TARGET_FILE=$(ls -1 "$BACKUP_DIR" | grep "$PKG_NAME" | sed -n "${FILE_NUM}p")
    
    if [ -z "$TARGET_FILE" ]; then
        echo -e "${R}❌ Pilihan tidak valid!${NC}"
        exit 1
    fi
    
    echo -e "${C}▸ Merestore $TARGET_FILE ...${NC}"
    am force-stop "$PKG_NAME" >/dev/null 2>&1
    pm clear "$PKG_NAME" >/dev/null 2>&1
    
    cd /data/data/
    tar -xzf "$BACKUP_DIR/$TARGET_FILE" 2>/dev/null
    
    # Restore permissions
    APP_UID=$(dumpsys package "$PKG_NAME" 2>/dev/null | grep -m1 "userId=" | cut -d'=' -f2 | tr -d ' ')
    if [ -n "$APP_UID" ]; then
        chown -R $APP_UID:$APP_UID "/data/data/$PKG_NAME" 2>/dev/null
        restorecon -R "/data/data/$PKG_NAME" >/dev/null 2>&1
    fi
    
    echo -e "${G}✔ Restore Berhasil! Aplikasi siap digunakan.${NC}"
fi

echo -e "\n${C}═════════════════════════════════════════════════════${NC}"
echo -e "${G}📌 Biar gak ketinggalan amunisi baru, PASTIKAN pantau${NC}"
echo -e "${G}terus channel ini! Modul VIP, script sakti, dan racikan${NC}"
echo -e "${G}settingan gacor bakal terus di-share ke depannya. Stay tuned! 🔥${NC}"
echo -e "${Y}💡 Bisa request script dan settingan sesuai kebutuhan!${NC}"
echo -e "${C}👉 Join: https://t.me/TempoyakID_root${NC}"
echo -e "${C}═════════════════════════════════════════════════════${NC}\n"
