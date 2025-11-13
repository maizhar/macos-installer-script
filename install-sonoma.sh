#!/bin/bash
echo "==============================="
echo "🚀 Menjalankan Instalasi macOS Sonoma"
echo "==============================="

# Deteksi disk internal utama
TARGET_DISK=$(diskutil list | grep -E "internal.*physical" | awk '{print $1}')

if [ -z "$TARGET_DISK" ]; then
  echo "❌ Tidak menemukan disk internal fisik. Pastikan kamu di Recovery Mode dan disk internal terdeteksi."
  exit 1
fi

echo "✅ Disk internal ditemukan: $TARGET_DISK"
echo "🔧 Melepas semua volume di disk internal..."
diskutil unmountDisk force $TARGET_DISK >/dev/null 2>&1

echo "💽 Menghapus dan memformat ulang menjadi APFS..."
diskutil eraseDisk APFS "Macintosh HD" $TARGET_DISK >/dev/null 2>&1

# Pastikan installer USB tersedia dan sesuai target kamu
if [ ! -d "/Volumes/Install macOS Sonoma" ]; then
  echo "❌ Tidak menemukan USB installer di /Volumes/Install macOS Sonoma"
  echo "🔎 Pastikan USB bernama tepat: Install macOS Sonoma"
  echo "💡 Cek dengan perintah: ls /Volumes"
  exit 1
fi

echo "📦 Menjalankan startosinstall dari USB..."
/Volumes/"Install macOS Sonoma"/Contents/Resources/startosinstall \
  --volume /Volumes/"Macintosh HD" \
  --eraseinstall \
  --agreetolicense \
  --nointeraction

echo "🕒 Proses instalasi sedang berjalan..."
echo "💡 Mac akan restart otomatis dan melanjutkan instalasi."
echo "✅ Jangan cabut USB sampai Mac restart untuk pertama kalinya!"
