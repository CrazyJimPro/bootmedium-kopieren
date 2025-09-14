#!/bin/bash
set -euo pipefail

# ============================================
# Automatisches Klonen des Bootmediums
# ============================================

# Quelle = aktuelles Root-Device ermitteln
SOURCE_DEV=$(findmnt -n -o SOURCE / | sed 's/[0-9]*$//')

# Ziel = hier fest eintragen (z. B. USB oder SSD)
TARGET_DEV="/dev/sda"

# Mountpunkte für den Klon
MOUNT_BOOT="/mnt/klonboot"
MOUNT_ROOT="/mnt/klonfs"

# Logfile
LOGFILE="/var/log/auto-clone-bootmedium.log"

# ============================================
# Start Logging
# ============================================
exec > >(tee -a "$LOGFILE") 2>&1
echo "==== Klon gestartet: $(date) ===="

# Prüfen, ob Ziel existiert
if [ ! -b "$TARGET_DEV" ]; then
    echo "❌ Fehler: Zielgerät $TARGET_DEV nicht gefunden!"
    exit 1
fi

# Alle Partitionen auf Ziel unmounten
umount "${TARGET_DEV}"* 2>/dev/null || true

# Partitionierung (GPT: bootfs + rootfs)
sgdisk --zap-all "$TARGET_DEV"
sgdisk -n 1:0:+512M -t 1:0700 -c 1:"bootfs" "$TARGET_DEV"
sgdisk -n 2:0:0    -t 2:8300 -c 2:"rootfs" "$TARGET_DEV"

# Partitionen formatieren
mkfs.vfat "${TARGET_DEV}1" -n bootfs -v
mkfs.ext4 "${TARGET_DEV}2" -L rootfs -v

# Mountpunkte vorbereiten
mkdir -p "$MOUNT_BOOT" "$MOUNT_ROOT"
mount "${TARGET_DEV}1" "$MOUNT_BOOT"
mount "${TARGET_DEV}2" "$MOUNT_ROOT"

# Daten klonen
rsync -rltDv --numeric-ids --info=progress2 /boot/firmware/ "$MOUNT_BOOT"
rsync -axHAWXSv --numeric-ids --info=progress2 / "$MOUNT_ROOT"

# fstab anpassen
BOOTUUID=$(blkid -s PARTUUID -o value "${TARGET_DEV}1")
ROOTUUID=$(blkid -s PARTUUID -o value "${TARGET_DEV}2")

sed -i "s|^PARTUUID=.* /boot/firmware|PARTUUID=$BOOTUUID /boot/firmware|" "$MOUNT_ROOT/etc/fstab"
sed -i "s|^PARTUUID=.* / |PARTUUID=$ROOTUUID / |" "$MOUNT_ROOT/etc/fstab"

# cmdline.txt anpassen
sed -i "s|root=PARTUUID=[^ ]*|root=PARTUUID=$ROOTUUID|" "$MOUNT_BOOT/cmdline.txt"

# Aushängen
umount "$MOUNT_BOOT" "$MOUNT_ROOT"

echo "✅ Klon erfolgreich abgeschlossen: $(date)"
echo "=========================================="
