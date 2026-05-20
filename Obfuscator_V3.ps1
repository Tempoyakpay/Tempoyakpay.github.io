Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "  TEMPOYAKID ADVANCED OBFUSCATOR v3.0" -ForegroundColor Yellow
Write-Host "=============================================" -ForegroundColor Cyan

$InputFile = Read-Host "Masukkan nama script yang ingin diproteksi (contoh: Bersih.sh)"
if ([string]::IsNullOrWhiteSpace($InputFile)) { exit }

$OutputFile = $InputFile.Replace(".sh", "") + "_Encrypted.sh"

if (-Not (Test-Path $InputFile)) {
    Write-Host "[X] Error: File '$InputFile' tidak ditemukan di folder ini!" -ForegroundColor Red
    Start-Sleep -Seconds 3
    exit
}

Write-Host "[*] Membaca dan mengompres '$InputFile'..." -ForegroundColor Green
$content = [System.IO.File]::ReadAllText((Resolve-Path $InputFile).Path)

# Gzip compress to make it unreadable
$ms = New-Object System.IO.MemoryStream
$gz = New-Object System.IO.Compression.GZipStream($ms, [System.IO.Compression.CompressionMode]::Compress)
$sw = New-Object System.IO.StreamWriter($gz)
$sw.Write($content)
$sw.Close()
$bytes = $ms.ToArray()

$b64 = [System.Convert]::ToBase64String($bytes)

# Split into random chunks to confuse simple decoders
$chunkSize = 60
$chunks = [regex]::Matches($b64, ".{1,$chunkSize}") | ForEach-Object { $_.Value }

Write-Host "[*] Membangun layer enkripsi ganda..." -ForegroundColor Green

# Generate random variable names
function Get-RandomString {
    $chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    $rand = ""
    1..8 | ForEach-Object { $rand += $chars[(Get-Random -Maximum $chars.Length)] }
    return $rand
}

$varPayload = Get-RandomString
$varEval1 = Get-RandomString
$varEval2 = Get-RandomString
$varCmd = Get-RandomString

$header = @"
#!/system/bin/sh
# =============================================
# PROTEKSI COPYRIGHT - JANGAN DIUBAH/DIHAPUS
# (c) 2025 Powered by TEMPOYAKID
# Telegram: @TempoyakID_root
# ---------------------------------------------
# 🔥 Dapatkan script & modul terbaik lainnya!
# 👉 Gabung Sekarang → t.me/TempoyakID_root
# =============================================
WATERMARK="Powered by TEMPOYAKID"
SCRIPT_SELF="`$(realpath "`$0" 2>/dev/null || readlink -f "`$0" 2>/dev/null || echo "`$0")"

if ! grep -q "Powered by TEMPOYAKID" "`$SCRIPT_SELF" 2>/dev/null; then exit 1; fi
if [ "`$(id -u 2>/dev/null)" != "0" ]; then exec su -c 'sh "$0" "$@"' -- "`$0" "`$@"; fi

$varPayload=""
"@

foreach ($chunk in $chunks) {
    $header += "`n$varPayload=`$$varPayload`"$chunk`""
}

$header += @"

$varEval1="e"
$varEval2="val"
$varCmd="`$$varEval1`$$varEval2"

`$$varCmd "`$(echo "`$$varPayload" | base64 -d | gzip -cd)"
"@

# Save with UNIX format
$utf8NoBom = New-Object System.Text.UTF8Encoding $false
$outPath = Join-Path (Get-Location) $OutputFile
[System.IO.File]::WriteAllText($outPath, $header, $utf8NoBom)

$finalContent = [System.IO.File]::ReadAllText($outPath)
$finalContent = $finalContent -replace "`r`n", "`n"
[System.IO.File]::WriteAllText($outPath, $finalContent, $utf8NoBom)

Write-Host "[*] Berhasil! File '$OutputFile' telah dibuat." -ForegroundColor Green
Write-Host "[*] Keamanan ditingkatkan: Gzip Compression + Chunking + Anti-Grep Eval." -ForegroundColor Yellow
Write-Host "=============================================" -ForegroundColor Cyan
Start-Sleep -Seconds 3
