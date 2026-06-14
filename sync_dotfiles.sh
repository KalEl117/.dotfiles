#!/usr/bin/env bash

# --- KONFIGURATION ---
# Das Verzeichnis, in dem dieses Git-Repository liegt
REPO_DIR="$HOME/.dotfiles"

# Liste der Ordner aus ~/.config, die du sichern möchtest
# Hier einfach die Ordnernamen eintragen, getrennt durch ein Leerzeichen
CONFIG_FOLDERS=(btop fastfetch hypr kitty mako nvim nwg-look rofi swappy Thunar waybar yazi)
# ---------------------

echo "🔄 Starte Dotfiles-Synchronisation..."
cd "$REPO_DIR" || exit 1

# Schleife durch alle definierten Ordner
for folder in "${CONFIG_FOLDERS[@]}"; do
  SOURCE="$HOME/.config/$folder"
  TARGET="$REPO_DIR/$folder"

  # Prüfen, ob der Quellordner überhaupt existiert
  if [ -d "$SOURCE" ]; then
    echo "Prüfe Ordner: $folder..."

    # rsync Optionen:
    # -a: Archiv-Modus (behält Rechte, Zeiten etc.)
    # -v: Zeigt an, was kopiert wird (verbose)
    # --delete: Löscht Dateien im Ziel, die im Quellordner nicht mehr existieren
    rsync -av --delete "$SOURCE/" "$TARGET/"
  else
    echo "⚠️ Warnung: $SOURCE existiert nicht. Überspringe..."
  fi
done

echo "---------------------------------------"
echo "🔍 Prüfe Git-Status..."

# Prüfen, ob es Änderungen im Git-Repository gibt
if [ -n "$(git status --porcelain)" ]; then
  echo "✨ Änderungen erkannt! Starte Git-Push..."

  # Änderungen hinzufügen
  git add .

  # Aktuellen Zeitstempel für die Commit-Nachricht generieren
  TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
  git commit -m "Auto-Update Dotfiles: $TIMESTAMP"

  # Zu GitHub pushen (Passe 'main' an, falls dein Branch anders heißt)
  git push origin main

  echo "✅ Dotfiles erfolgreich auf GitHub aktualisiert!"
else
  echo "😎 Keine Änderungen in den Configs gefunden. Alles up to date!"
fi
