# clone-bootmedium.sh & auto-clone-bootmedium.sh

> 🛠️ Bash-Skripte zum Klonen oder automatischen Backup des Raspberry-Pi-Bootmediums (SD ↔ USB ↔ M.2) – einfach, sicher, direkt bootfähig.

---

## 📖 Übersicht

Dieses Repository enthält zwei Skripte:

- **`clone-bootmedium.sh`**: interaktives Klonen des aktuellen Bootmediums auf ein anderes (SD, USB, M.2). Perfekt zum Umzug oder manuellen Backup.
- **`auto-clone-bootmedium.sh`**: automatisiertes, nicht-interaktives Klonen oder Backup, ideal für den Einsatz per Cronjob.

---

## 🚀 Schnellstart (Einzeiler für `clone-bootmedium.sh`)

Einfach in den gewünschten Ordner wechseln und diesen Befehl ausführen:  

```bash
curl -sSL https://github.com/CrazyJimPro/bootmedium-kopieren/main/clone-bootmedium.sh -o clone-bootmedium.sh && chmod +x clone-bootmedium.sh && sudo ./clone-bootmedium.sh
```

---

## ⚙️ Voraussetzungen

* Raspberry Pi (getestet mit Pi 4 und Pi 5)
* Debian/Raspberry Pi OS (Bookworm oder neuer empfohlen)
* Root-/Sudo-Rechte
* Internetzugang (zum Installieren der benötigten Tools)

Benötigte Tools werden automatisch installiert:

* `gparted`, `gdisk`, `dosfstools`, `mtools`, `iotop`, `rsync`

---

## 🖥️ Funktionsweise

### `clone-bootmedium.sh`

* Erkennt automatisch das **aktuelle Bootmedium** (Quelle).
* Zeigt alle angeschlossenen Speichergeräte an.
* Fragt interaktiv nach dem **Zielmedium** (SD, USB, M.2).
* Führt aus:
  * GPT-Partitionierung (`bootfs`, `rootfs`)
  * Formatierung (`vfat`, `ext4`)
  * Kopieren mit `rsync`
  * Anpassung von `fstab` und `cmdline.txt`
* Ergebnis: Zielmedium ist direkt bootfähig.

### `auto-clone-bootmedium.sh`

* Quelle = aktuelles Bootmedium wird automatisch erkannt.
* Zielmedium wird im Script festgelegt (z. B. `/dev/sda` oder `/dev/nvme0n1`).
* Kein interaktiver Modus → ideal für Cronjobs.
* Schreibt Logdateien (z. B. `/var/log/auto-clone-bootmedium.log`).
* Kann regelmäßig Backups auf ein bestimmtes Zielmedium erstellen.

---

## ⚠️ Hinweise & Sicherheit

* **Wichtig:** Zielmedium oder Backup-Datei wird überschrieben.
* Prüfe bei der interaktiven Variante genau, welches Device du auswählst.
* Immer das Skript **vom aktiven Bootmedium starten** (z. B. von SD, wenn du auf USB klonen willst).
* Falls das Zielmedium größer ist, kann die Root-Partition später mit `gparted` oder
  
  ```bash
  sudo raspi-config --expand-rootfs
  ```
  
  vergrößert werden.

---

## 📷 Beispielablauf

### `clone-bootmedium.sh`
1. Pi bootet von **SD**
2. `clone-bootmedium.sh` starten (z. B. mit dem Einzeiler oben)
3. Zielmedium auswählen → z. B. `/dev/sda` (USB)
4. Warten, bis Kopiervorgang abgeschlossen ist
5. Pi herunterfahren, SD entfernen, vom USB booten
6. (Optional) Vorgang wiederholen → USB → M.2 klonen

### `auto-clone-bootmedium.sh`
1. Script nach `/usr/local/bin` kopieren
2. Zielmedium im Script festlegen (z. B. `/dev/sda`)
3. Ausführbar machen:
   ```bash
   sudo chmod +x /usr/local/bin/auto-clone-bootmedium.sh
   ```
4. Cronjob anlegen (z. B. täglich 03:00 Uhr):
   ```cron
   0 3 * * * /usr/local/bin/auto-clone-bootmedium.sh
   ```

---

## 📝 Lizenz

Dieses Projekt steht unter der **MIT-Lizenz**.  
Frei verwendbar, veränderbar und weitergebbar.

---

## ⭐ Tipp

Wenn dir die Skripte gefallen, lass gerne ein ⭐ auf GitHub da 😊

