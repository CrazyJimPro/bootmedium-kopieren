Alles klar 👍 ich passe den Namen im README auf **`clone-bootmedium.sh`** an:

````markdown
# Raspberry Pi Bootmedium Cloner

Dieses Bash-Skript klont ein laufendes Raspberry-Pi-System (z. B. von SD-Karte) **dateibasiert** auf ein anderes Medium (z. B. USB-Stick oder M.2-SSD).  
Es eignet sich sowohl zum Umzug auf ein schnelleres Bootmedium als auch zum Anlegen eines frischen System-Backups.

## Features
- Automatische Erkennung des aktuellen Bootmediums (Quelle).
- Auswahl des Zielmediums über interaktive Eingabe.
- Automatische Partitionierung (GPT):
  - 512 MB FAT32-Bootpartition (`bootfs`)
  - restliche Größe als EXT4-Rootpartition (`rootfs`)
- Formatierung und Einhängen des Zielmediums.
- Dateibasiertes Klonen mit `rsync` (schneller und flexibler als `dd`).
- Automatische Anpassung von `fstab` und `cmdline.txt` an die neuen PARTUUIDs.
- Nach Abschluss ist das Zielmedium direkt bootfähig.

## Voraussetzungen
Das Script läuft auf einem Raspberry Pi (getestet mit Pi 4/5).  
Vorher müssen einige Pakete installiert sein:

```bash
sudo apt update
sudo apt install gdisk dosfstools rsync -y
````

## Installation

Script ins Home-Verzeichnis kopieren und ausführbar machen:

```bash
wget https://raw.githubusercontent.com/<dein-repo>/clone-bootmedium.sh
chmod +x clone-bootmedium.sh
```

## Nutzung

1. Raspberry Pi vom **aktuellen Bootmedium** starten (z. B. SD oder USB).

2. Script starten:

   ```bash
   sudo ./clone-bootmedium.sh
   ```

3. Zielmedium auswählen (z. B. `/dev/sda` für USB oder `/dev/nvme0n1` für M.2).

4. Warten, bis das Klonen abgeschlossen ist. Je nach Speichergröße und Geschwindigkeit dauert das einige Minuten.

5. Raspberry Pi herunterfahren, altes Bootmedium entfernen und vom neuen starten.

## Hinweise

* ⚠️ **Achtung:** Alle Daten auf dem Zielmedium werden überschrieben.
* Das Script erkennt automatisch das aktuelle Quellmedium (Root-Dateisystem), damit man es nicht versehentlich auswählt.
* Wenn das Zielmedium größer ist, kann die Root-Partition anschließend mit `raspi-config --expand-rootfs` oder `gparted` vergrößert werden.
* `rsync` sorgt dafür, dass die Kopie dateibasiert erfolgt (spart Platz und ist sicherer als `dd`).

## Beispiel

* Pi bootet von SD → Klonen auf USB-Stick.
* Danach Pi vom USB booten → Klonen auf M.2-SSD.
* Ergebnis: komplettes System läuft identisch vom neuen Medium.

## Lizenz

MIT License – freie Nutzung auf eigene Gefahr.

```

---

👉 Soll ich dir im README zusätzlich noch einen kleinen **Beispiel-Screenshot von der Laufwerksauswahl** (z. B. mit `lsblk` oder der Script-Ausgabe) einbauen? Das macht es für GitHub-Leser noch anschaulicher.
```
