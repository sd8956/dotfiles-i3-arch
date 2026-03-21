#!/usr/bin/env bash

DIR="$HOME/mis_dotfiles"

echo "Limpiando respaldo anterior..."
rm -rf "$DIR/.config"
rm -rf "$DIR/system"
mkdir -p "$DIR/.config"
mkdir -p "$DIR/system/etc/lightdm"

echo "Copiando directorios de usuario..."
cp -r ~/.config/i3 "$DIR/.config/" 2>/dev/null || echo "⚠️  No se encontró i3"
cp -r ~/.config/polybar "$DIR/.config/" 2>/dev/null || echo "⚠️  No se encontró polybar"
cp -r ~/.config/rofi "$DIR/.config/" 2>/dev/null || echo "⚠️  No se encontró rofi"
cp -r ~/.config/betterlockscreen "$DIR/.config/" 2>/dev/null || echo "⚠️  No se encontró betterlockscreen"
cp -r ~/.config/dunst "$DIR/.config/" 2>/dev/null || echo "⚠️  No se encontró dunst"
cp ~/.zshrc "$DIR/" 2>/dev/null || echo "⚠️  No se encontró .zshrc"

echo "Copiando configuraciones del sistema (LightDM)..."
cp /etc/lightdm/lightdm.conf "$DIR/system/etc/lightdm/" 2>/dev/null || echo "⚠️  No se encontró lightdm.conf"
cp /etc/lightdm/slick-greeter.conf "$DIR/system/etc/lightdm/" 2>/dev/null || echo "⚠️  No se encontró slick-greeter.conf"

echo "¡Respaldo completado! Revisa la carpeta con 'ls -la $DIR'"
