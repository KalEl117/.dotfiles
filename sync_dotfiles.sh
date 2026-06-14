#!/usr/bin/env bash

# --- KONFIGURATION ---
# Das Verzeichnis, in dem dieses Git-Repository liegt
REPO_DIR="$HOME/.dotfiles"

# Liste der Ordner aus ~/.config, die du sichern möchtest
CONFIG_FOLDERS=("hypr" "waybar" "kitty")
# ---------------------

echo "🔄 Starte Dotfiles-Synchronisation..."
cd "$REPO_DIR" || exit 1

# --- SSH AGENT STARTEN ---
echo "🔑 SSH-Agent wird gestartet..."
eval "$(ssh-agent -s)"

# Schlüssel hinzufügen (fordert dich einmalig zur Passphrase auf)
ssh-add ~/.ssh/id_ed25519

if [ $? -ne 0 ]; then
    echo "❌ SSH-Schlüssel konnte nicht geladen werden. Abbruch."
    exit 1
fi
echo "---------------------------------------"

# --- 1. CONFIG-ORDNER SYNCHRONISIEREN ---
for folder in "${CONFIG_FOLDERS[@]}"; do
    SOURCE="$HOME/.config/$folder"
    TARGET="$REPO_DIR/$folder"

    if [ -d "$SOURCE" ]; then
        echo "Prüfe Ordner: $folder..."
        rsync -av --delete "$SOURCE/" "$TARGET/"
    else
        echo "⚠️ Warnung: $SOURCE existiert nicht. Überspringe..."
    fi
done

# --- 2. EINZELDATEIEN (BASHRC) SYNCHRONISIEREN ---
echo "Prüfe Datei: .bashrc..."
if [ -f "$HOME/.bashrc" ]; then
    # Kopiert die aktuelle .bashrc aus deinem Home-Verzeichnis direkt in den Repo-Ordner
    rsync -av "$HOME/.bashrc" "$REPO_DIR/.bashrc"
else
    echo "⚠️ Warnung: $HOME/.bashrc existiert nicht."
fi

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
    
    # Zu GitHub pushen
    git push origin main
    
    echo "✅ Dotfiles erfolgreich auf GitHub aktualisiert!"
else
    echo "😎 Keine Änderungen in den Configs gefunden. Alles up to date!"
fi

# --- SSH AGENT BEENDEN ---
ssh-agent -k > /dev/null
echo "🔒 SSH-Agent erfolgreich beendet."
