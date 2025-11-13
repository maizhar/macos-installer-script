#!/bin/bash
# =========================================
# macOS SONOMA USB INSTALLER MAKER (Recovery Mode)
# by Maizhar
# =========================================

echo "======================================="
echo "   macOS SONOMA USB INSTALLER MAKER"
echo "======================================="
echo

# 1️⃣ Cek koneksi internet
echo "🌐 Mengecek koneksi internet..."
ping -c 1 apple.com &> /dev/null
if [ $? -ne 0 ]; then
    echo "❌ Tidak ada koneksi internet!"
    echo "➡️  Sambungkan Wi-Fi di kanan atas dulu, lalu jalankan lagi."
    exit 1
fi
echo "✅ Internet aktif."
echo

# 2️⃣ Tampilkan drive eksternal
echo "🔍 Mendeteksi drive eksternal..."
diskutil list external
echo
read -p "Masukkan identifier disk USB kamu (contoh: disk2): " usb
if [ -z "$usb" ]; then
    echo "❌ Tidak ada disk dipilih."
    exit 1
fi

# 3️⃣ Konfirmasi format
echo
read -p "⚠️ Semua data di /dev/$usb akan dihapus. Lanjut? (y/n): " confirm
if [[ "$confirm" != [yY] ]]; then
    echo "❌ Dibatalkan oleh pengguna."
    exit 0
fi

# 4️⃣ Format USB
echo
echo "🧹 Memformat USB..."
diskutil eraseDisk APFS "SonomaUSB" GPT /dev/$usb
if [ $? -ne 0 ]; then
    echo "❌ Gagal memformat USB. Coba ulangi."
    exit 1
fi
echo "✅ USB berhasil diformat sebagai /Volumes/SonomaUSB"
echo

# 5️⃣ Download installer macOS Sonoma
echo "⬇️ Mengunduh macOS Sonoma (butuh waktu lama, tergantung koneksi)..."
softwareupdate --fetch-full-installer --full-installer-version 14.0
if [ $? -ne 0 ]; then
    echo "❌ Gagal mengunduh installer macOS Sonoma."
    exit 1
fi
echo "✅ Installer berhasil diunduh ke /Applications."
echo

# 6️⃣ Cek installer
if [ ! -d "/Applications/Install macOS Sonoma.app" ]; then
    echo "❌ Installer tidak ditemukan setelah diunduh."
    exit 1
fi

# 7️⃣ Buat USB installer
echo "⚙️ Membuat USB installer di /Volumes/SonomaUSB ..."
echo "Proses ini bisa memakan waktu 10–30 menit, harap tunggu."
echo

sudo /Applications/Install\ macOS\ Sonoma.app/Contents/Resources/createinstallmedia --volume /Volumes/SonomaUSB | while read -r line; do
    echo "$line"
    if [[ "$line" =~ ([0-9]+)% ]]; then
        progress=${BASH_REMATCH[1]}
        bar=$(printf "%0.s#" $(seq 1 $((progress / 2))))
        spaces=$(printf "%0.s " $(seq 1 $((50 - progress / 2))))
        echo -ne "\r[$bar$spaces] $progress%"
    fi
done

echo
echo
echo "✅ Selesai!"
echo "💽 USB kamu sekarang sudah menjadi installer macOS Sonoma."
echo "➡️ Colokkan ke Mac lain, lalu tekan OPTION saat boot untuk memulai instalasi."
