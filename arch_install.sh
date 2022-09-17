#!/bin/bash

echo "[*] Starting Arch Linux Speed Run..."

echo "[*] Verifying boot mode..."
ls /sys/firmware/efi/efivars 2> /dev/null

if [[ $? -ne 0 ]]
then 
    echo "[-] UEFI not enabled"
fi

echo "[*] Exiting..."