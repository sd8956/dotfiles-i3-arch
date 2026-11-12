#!/usr/bin/env bash
# Copies the live configuration of this machine into the repository.
# Run it from anywhere: it always writes next to itself.

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Limpiando respaldo anterior..."
rm -rf "$DIR/.config"
rm -rf "$DIR/system"
rm -rf "$DIR/.local"
mkdir -p "$DIR/.config"
mkdir -p "$DIR/system/etc/lightdm"

echo "Copiando directorios de usuario..."
cp -r ~/.config/i3 "$DIR/.config/" 2>/dev/null || echo "⚠️  No se encontró i3"
cp -r ~/.config/polybar "$DIR/.config/" 2>/dev/null || echo "⚠️  No se encontró polybar"
cp -r ~/.config/rofi "$DIR/.config/" 2>/dev/null || echo "⚠️  No se encontró rofi"
cp -r ~/.config/betterlockscreen "$DIR/.config/" 2>/dev/null || echo "⚠️  No se encontró betterlockscreen"
cp -r ~/.config/dunst "$DIR/.config/" 2>/dev/null || echo "⚠️  No se encontró dunst"
cp -r ~/.config/picom "$DIR/.config/" 2>/dev/null || echo "⚠️  No se encontró picom"
cp -r ~/.config/plank "$DIR/.config/" 2>/dev/null && dconf dump /net/launchpad/plank/docks/ > "$DIR/.config/plank/docks.dconf" || echo "⚠️  No se encontró plank"
mkdir -p "$DIR/.local/share/plank/themes" && cp -r ~/.local/share/plank/themes/TokyoNight "$DIR/.local/share/plank/themes/" 2>/dev/null
cp -r ~/.config/gtk-3.0 "$DIR/.config/" 2>/dev/null
cp -r ~/.config/ghostty "$DIR/.config/" 2>/dev/null
cp -r ~/.config/autorandr "$DIR/.config/" 2>/dev/null || echo "⚠️  No se encontró autorandr"
cp -r ~/.config/skippy-xd "$DIR/.config/" 2>/dev/null || echo "⚠️  No se encontró skippy-xd"
cp ~/.config/greenclip.toml "$DIR/.config/" 2>/dev/null || echo "⚠️  No se encontró greenclip.toml"
cp ~/.p10k.zsh "$DIR/" 2>/dev/null || echo "⚠️  No se encontró .p10k.zsh"

# Only the wallpapers the configs use (~/Wallpapers holds much more)
mkdir -p "$DIR/Wallpapers"
for wp in gargantua-black-3840x2160-9621.jpg silver-surfer-cosmic-void.3840x2160.mp4; do
    cp ~/Wallpapers/"$wp" "$DIR/Wallpapers/" 2>/dev/null || echo "⚠️  No se encontró ~/Wallpapers/$wp"
done

# The repository is public: never copy a .zshrc that holds secrets.
# Keep tokens and keys in ~/.zshrc.local, which is sourced but never backed up.
if grep -qE '^\s*export\s+[A-Za-z_]*(TOKEN|SECRET|PASSWORD|API_KEY|APIKEY)[A-Za-z_]*=' ~/.zshrc 2>/dev/null; then
    echo "❌ ~/.zshrc contiene secretos (TOKEN/SECRET/API_KEY...). Muévelos a ~/.zshrc.local; .zshrc NO se copió."
else
    cp ~/.zshrc "$DIR/" 2>/dev/null || echo "⚠️  No se encontró .zshrc"
fi

echo "Copiando configuraciones del sistema (LightDM)..."
cp /etc/lightdm/lightdm.conf "$DIR/system/etc/lightdm/" 2>/dev/null || echo "⚠️  No se encontró lightdm.conf"
cp /etc/lightdm/slick-greeter.conf "$DIR/system/etc/lightdm/" 2>/dev/null || echo "⚠️  No se encontró slick-greeter.conf"

echo "¡Respaldo completado! Revisa la carpeta con 'ls -la $DIR'"
