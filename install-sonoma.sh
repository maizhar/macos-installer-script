#!/bin/bash
# Script otomatis membuat USB installer macOS Sonoma

echo "=== Mengecek volume USB ==="
ls /Volumes
echo
read -p "Masukkan nama USB drive kamu (pastikan sesuai hasil di atas): " usbname

echo
echo "=== Membuat USB Installer macOS Sonoma ==="
sudo /Applications/Install\ macOS\ Sonoma.app/Contents/Resources/createinstallmedia --volume /Volumes/"$usbname"

echo
echo "=== Selesai! ==="
echo "USB kamu sekarang sudah menjadi installer macOS Sonoma."
