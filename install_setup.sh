#!/usr/bin/env bash

echo "Iniciando instalación del entorno..."

# 1. Habilitar multilib para Steam (Juegos/Proton)
echo "Habilitando repositorio Multilib..."
sudo sed -i '/^#\[multilib\]/,/^#Include = \/etc\/pacman.d\/mirrorlist/ s/^#//' /etc/pacman.conf
sudo pacman -Sy

# 2. Instalar paquetes oficiales (Desarrollo, Sistema, Gaming y OSD)
echo "Instalando paquetes oficiales con pacman..."
sudo pacman -S --needed neovim zed git ttf-jetbrains-mono-nerd steam ttf-liberation gamemode lib32-gamemode mangohud lib32-mangohud sdl2 evtest xss-lock imlib2 libev libxinerama libxrandr rofi polybar i3-wm picom python-gobject dunst libnotify

# 3. Instalar paquetes de la comunidad (AUR)
echo "Instalando paquetes de AUR con yay..."
yay -S --needed jstest-gtk-git boxflat betterlockscreen

# 4. Restaurar configuraciones
echo "Restaurando dotfiles..."
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cp -r "$DIR/.config/"* ~/.config/
cp "$DIR/.zshrc" ~/

# Dar permisos de ejecución a los scripts copiados
chmod +x ~/.config/rofi/powermenu.sh
chmod +x ~/.config/i3/sleep_lock.sh
chmod +x ~/.config/i3/lock_osd.sh
chmod +x ~/.config/i3/osd_ui.py

# 5. Configurar el Hook de sistema para la suspensión
echo "Configurando el bloqueo por suspensión..."
sudo bash -c 'cat > /usr/lib/systemd/system-sleep/betterlockscreen <<EOF
#!/bin/sh
if [ "\$1" = "pre" ]; then
    DISPLAY=:0 /usr/bin/betterlockscreen -l blur
    sleep 1
fi
EOF'
sudo chmod +x /usr/lib/systemd/system-sleep/betterlockscreen

# 6. Instalar Neovim (LazyVim)
echo "Configurando Neovim (LazyVim)..."
rm -rf ~/.config/nvim
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git

echo "=========================================================="
echo "¡Instalación completada con éxito!"
echo "Pasos finales manuales:"
echo "1. Ejecuta: betterlockscreen -u /ruta/a/tu/fondo.jpg --blur 0.5 --display 1"
echo "2. Abre 'nvim' una vez para que descargue los plugins."
echo "3. Reinicia i3 (\$mod + Shift + r)."
echo "=========================================================="
