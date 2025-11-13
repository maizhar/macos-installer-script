#!/bin/bash
# Script untuk mengecek daftar USB drive yang terpasang

echo "=== Mengecek USB drive yang terhubung ==="
diskutil list external

echo
echo "Jika kamu mau lihat detail salah satu USB, ketik perintah ini:"
echo "diskutil info /dev/diskX"
echo "(Ganti X dengan nomor disk kamu, misalnya disk2)"
