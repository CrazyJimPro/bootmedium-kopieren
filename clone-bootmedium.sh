#!/bin/bash
# clone-pi.sh
# Raspberry Pi: System von SD auf USB oder M.2 klonen
# ACHTUNG: Zielmedium wird vollständig überschrieben!

set -euo pipefail

echo "=== Raspberry Pi Disk Cloner ==="
echo "Dieses Skript klont dein aktuelles System (SD-Boot) auf ein neues Medium."
echo "Alle Daten auf dem Zielmedium werden gelöscht!"
echo

# --- Quelle automatisch ermitteln ---
ROOTSRC=$(findmnt / -o SOURCE -n)    # z. B. /dev/mmcblk0p2
SRCDEV=$(lsblk -no pkname "$ROOTSRC") # = mmcblk0
SRC="/dev/$SRCDEV"

echo ">>> Quelle (aktuelles Bootmedium): $SRC"
echo

# --- verfügbare Devices anzeigen ---
echo ">>> Angeschlossene Laufwerke:"
lsblk -d -o NAME,SIZE,MODEL,TRAN
echo
read -rp "Bitte gib das ZIEL-Device an (z. B. /dev/sda oder /dev/nvme0n1): " DST

if [[ "$SRC" == "$DST" ]]; then
  echo "Fehler: Quelle und Ziel dürfen nicht identisch sein!"
  exit 1
fi

echo
echo ">>> Quelle: $SRC"
echo ">>> Ziel:   $DST"
read -rp "Bist du sicher, dass du von $SRC auf $DST klonen willst? (yes/NO): " CONFIRM
[[ "$CONFIRM" == "yes" ]] || { echo "Abgebrochen."; exit 1; }

# --- Partitionierung Ziel ---
echo ">>> Partitioniere $DST neu (GPT, bootfs + rootfs)..."
sudo sgdisk --zap-all "$DST"
sudo sgdisk -n 1:0:+512M -t 1:0700 -c 1:"bootfs" "$DST"
sudo sgdisk -n 2:0:0     -t 2:8300 -c 2:"rootfs" "$DST"

# --- Partitionen bestimmen ---
if [[ "$DST" == *"mmcblk"* || "$DST" == *"nvme"* ]]; then
  BOOT="${DST}p1"
  ROOT="${DST}p2"
else
  BOOT="${DST}1"
  ROOT="${DST}2"
fi

# --- Formatierung ---
echo ">>> Formatiere Partitionen..."
sudo mkfs.vfat "$BOOT" -n bootfs
sudo mkfs.ext4 "$ROOT" -L rootfs

# --- Mountpoints ---
echo ">>> Mounten..."
sudo mkdir -p /klonboot /klonfs
sudo mount "$BOOT" /klonboot
sudo mount "$ROOT" /klonfs

# --- Kopieren ---
echo ">>> Klone Boot-Partition..."
sudo rsync -rltDv --numeric-ids --info=progress2 /boot/firmware/ /klonboot

echo ">>> Klone Root-Dateisystem..."
sudo rsync -axHAWXSv --numeric-ids --info=progress2 / /klonfs

# --- fstab & cmdline.txt anpassen ---
echo ">>> Passe fstab an..."
BOOTUUID=$(lsblk -no PARTUUID "$BOOT")
ROOTUUID=$(lsblk -no PARTUUID "$ROOT")

sudo sed -i "s|^PARTUUID=.* /boot/firmware|PARTUUID=$BOOTUUID  /boot/firmware vfat    defaults          0       2|" /klonfs/etc/fstab
sudo sed -i "s|^PARTUUID=.* / |PARTUUID=$ROOTUUID  /               ext4    defaults,noatime  0       1|" /klonfs/etc/fstab

echo ">>> Passe cmdline.txt an..."
sudo sed -i "s|root=PARTUUID=[a-zA-Z0-9-]*|root=PARTUUID=$ROOTUUID|" /klonboot/cmdline.txt

# --- Finalisierung ---
echo ">>> Sync & Unmount..."
sync
sudo umount /klonboot
sudo umount /klonfs

echo
echo ">>> Fertig! Dein neues Medium $DST ist bereit zum Booten."
echo "Du kannst den Pi jetzt herunterfahren, die SD entfernen und vom neuen Medium starten."
