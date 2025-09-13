Ah, sehr gute Idee 👍 – also ein **One-Liner**, den du direkt auf deinem Pi eingeben kannst. Der legt die `clone-bootmedium.sh` ins aktuelle Verzeichnis, macht sie ausführbar und startet sie sofort.

Beispiel (ersetze `<dein-user>` und `<dein-repo>` durch deine GitHub-Daten):

```bash
curl -sSL https://raw.githubusercontent.com/<dein-user>/<dein-repo>/main/clone-bootmedium.sh -o clone-bootmedium.sh && chmod +x clone-bootmedium.sh && sudo ./clone-bootmedium.sh
```

---

### Angepasste `README.md` mit One-Liner:

````markdown
# clone-bootmedium.sh

> 🛠️ Ein Bash-Skript zum Klonen des Raspberry-Pi-Bootmediums (SD ↔ USB ↔ M.2) – einfach, sicher, direkt bootfähig.

---

## 📖 Übersicht

Dieses Repository enthält das Skript **`clone-bootmedium.sh`**, mit dem man ein laufendes Raspberry-Pi-Bootmedium auf ein anderes Speichermedium klonen kann.  
Es eignet sich perfekt, um z. B. ein frisch installiertes System von einer SD-Karte auf einen USB-Stick oder eine M.2-SSD zu übertragen – oder auch umgekehrt.  

Das Zielmedium ist nach dem Klonvorgang **direkt bootfähig**.

---

## 🚀 Schnellstart (Einzeiler)

Einfach in den gewünschten Ordner wechseln und diesen Befehl ausführen:  

```bash
curl -sSL https://raw.githubusercontent.com/<dein-user>/<dein-repo>/main/clone-bootmedium.sh -o clone-bootmedium.sh && chmod +x clone-bootmedium.sh && sudo ./clone-bootmedium.sh
````

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

* Das Skript erkennt automatisch das **aktuelle Bootmedium** (Quelle).
* Alle angeschlossenen Speichergeräte werden angezeigt.
* Du wählst interaktiv das **Zielmedium** (SD, USB, M.2).
* Das Ziel wird automatisch:

  * mit GPT partitioniert (`bootfs`, `rootfs`)
  * formatiert (`vfat`, `ext4`)
  * per `rsync` mit den Systemdaten befüllt
  * in `fstab` und `cmdline.txt` angepasst (korrekte `PARTUUID`)
* Danach kannst du direkt vom Zielmedium booten.

---

## ⚠️ Hinweise & Sicherheit

* **Wichtig:** Das Zielmedium wird komplett gelöscht und neu partitioniert.
* Prüfe im Auswahlmenü genau, welches Device du auswählst (z. B. `/dev/mmcblk0`, `/dev/sda`, `/dev/nvme0n1`).
* Immer das Skript **vom aktiven Bootmedium starten** (z. B. von SD, wenn du auf USB klonen willst).
* Falls das Zielmedium größer ist, kannst du später die Root-Partition mit `gparted` oder

  ```bash
  sudo raspi-config --expand-rootfs
  ```

  vergrößern.

---

## 📷 Beispielablauf

1. Pi bootet von **SD**
2. `clone-bootmedium.sh` starten (z. B. mit dem Einzeiler oben)
3. Zielmedium auswählen → z. B. `/dev/sda` (USB)
4. Warten, bis Kopiervorgang abgeschlossen ist
5. Pi herunterfahren, SD entfernen, vom USB booten
6. (Optional) Vorgang wiederholen → USB → M.2 klonen

---

## 📝 Lizenz

Dieses Projekt steht unter der **MIT-Lizenz**.
Frei verwendbar, veränderbar und weitergebbar.

---

## ⭐ Tipp

Wenn dir das Skript gefällt, lass gerne ein ⭐ auf GitHub da 😊

```

---

👉 Soll ich dir die GitHub-URL in den One-Liner schon mit deinem Repo-Namen eintragen, sobald du mir sagst, wie es genau heißen soll?
```
