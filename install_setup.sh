#!/usr/bin/env bash

echo "Iniciando instalación del entorno..."

# 1. Habilitar multilib para Steam (Juegos/Proton)
echo "Habilitando repositorio Multilib..."
sudo sed -i '/^#\[multilib\]/,/^#Include = \/etc\/pacman.d\/mirrorlist/ s/^#//' /etc/pacman.conf
sudo pacman -Sy

# 2. Instalar paquetes oficiales
echo "Instalando paquetes oficiales con pacman..."
sudo pacman -S --needed neovim zed git ttf-jetbrains-mono-nerd steam ttf-liberation gamemode lib32-gamemode mangohud lib32-mangohud sdl2 evtest xss-lock imlib2 libev libxinerama libxrandr rofi polybar i3-wm picom python-gobject dunst libnotify lightdm lightdm-slick-greeter

# 3. Instalar paquetes de la comunidad (AUR)
echo "Instalando paquetes de AUR con yay..."
yay -S --needed jstest-gtk-git boxflat betterlockscreen tokyonight-gtk-theme-git

# 4. Restaurar configuraciones de usuario
echo "Restaurando dotfiles de usuario..."
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cp -r "$DIR/.config/"* ~/.config/
cp "$DIR/.zshrc" ~/

chmod +x ~/.config/rofi/powermenu.sh
chmod +x ~/.config/i3/sleep_lock.sh
chmod +x ~/.config/i3/lock_osd.sh
chmod +x ~/.config/i3/osd_ui.py

# 5. Restaurar configuraciones del sistema (LightDM)
echo "Restaurando configuraciones del sistema..."
if [ -d "$DIR/system/etc/lightdm" ]; then
    sudo cp -r "$DIR/system/etc/lightdm/"* /etc/lightdm/
fi

# 6. Configurar el Hook de sistema para la suspensión y LightDM
echo "Configurando servicios del sistema..."
sudo bash -c 'cat > /usr/lib/systemd/system-sleep/betterlockscreen <<EOF
#!/bin/sh
if [ "\$1" = "pre" ]; then
    DISPLAY=:0 /usr/bin/betterlockscreen -l blur
    sleep 1
fi
EOF'
sudo chmod +x /usr/lib/systemd/system-sleep/betterlockscreen

# Desactivar otros gestores y activar LightDM
sudo systemctl disable gdm sddm lxdm 2>/dev/null
sudo systemctl enable lightdm -f

# 7. Instalar Neovim (LazyVim)
echo "Configurando Neovim (LazyVim)..."
rm -rf ~/.config/nvim
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git

echo "=========================================================="
echo "¡Instalación completada con éxito!"
echo "Pasos finales manuales:"
echo "1. Ejecuta: betterlockscreen -u /ruta/a/tu/fondo.jpg --blur 0.5 --display 1"
echo "2. Copia tu fondo de login: sudo cp /ruta/fondo.jpg /usr/share/pixmaps/login_bg.jpg"
echo "3. Abre 'nvim' una vez para que descargue los plugins."
echo "4. Reinicia el equipo para ver todos los cambios."
echo "=========================================================="
