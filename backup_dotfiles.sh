#!/usr/bin/env bash

DIR="$HOME/mis_dotfiles"

echo "Limpiando respaldo anterior..."
rm -rf "$DIR/.config"
mkdir -p "$DIR/.config"

echo "Copiando directorios completos..."
cp -r ~/.config/i3 "$DIR/.config/" 2>/dev/null || echo "⚠️  No se encontró i3"
cp -r ~/.config/polybar "$DIR/.config/" 2>/dev/null || echo "⚠️  No se encontró polybar"
cp -r ~/.config/rofi "$DIR/.config/" 2>/dev/null || echo "⚠️  No se encontró rofi"
cp -r ~/.config/betterlockscreen "$DIR/.config/" 2>/dev/null || echo "⚠️  No se encontró betterlockscreen"
cp -r ~/.config/dunst "$DIR/.config/" 2>/dev/null || echo "⚠️  No se encontró dunst"
cp ~/.zshrc "$DIR/" 2>/dev/null || echo "⚠️  No se encontró .zshrc"

echo "¡Respaldo completado! Revisa la carpeta con 'ls -la $DIR'"
