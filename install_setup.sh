#!/usr/bin/env bash

echo "Iniciando instalación del entorno..."
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 1. Habilitar multilib para Steam (Juegos/Proton)
echo "Habilitando repositorio Multilib..."
sudo sed -i '/^#\[multilib\]/,/^#Include = \/etc\/pacman.d\/mirrorlist/ s/^#//' /etc/pacman.conf
sudo pacman -Sy

# 2. Instalar paquetes oficiales
echo "Instalando paquetes oficiales con pacman..."
PACMAN_PKGS=(
    # Base y herramientas
    base-devel git curl timeshift cronie neovim zed dconf jq
    # Escritorio: i3, barra, dock, lanzadores, compositor, notificaciones
    i3-wm polybar plank autorandr rofi picom dunst libnotify dex numlockx yad
    xss-lock imlib2 libev libxinerama libxrandr xorg-xrandr xorg-xprop
    feh mpv maim xclip xdotool python-gobject python-cairo lxqt-policykit playerctl
    # Apps del entorno
    ghostty thunar btop pavucontrol libpulse gparted baobab network-manager-applet
    obsidian discord
    # Shell
    zsh tmux
    # Fuentes e iconos
    ttf-jetbrains-mono-nerd ttf-liberation adwaita-fonts woff2-font-awesome papirus-icon-theme
    # Gaming y sim racing
    steam gamemode lib32-gamemode mangohud lib32-mangohud sdl2 evtest
    # Login
    lightdm lightdm-slick-greeter
)
sudo pacman -S --needed "${PACMAN_PKGS[@]}"

# 3. Instalar yay (si falta) y paquetes de la comunidad (AUR)
if ! command -v yay >/dev/null 2>&1; then
    echo "Instalando yay..."
    YAY_TMP="$(mktemp -d)"
    git clone https://aur.archlinux.org/yay-bin.git "$YAY_TMP/yay-bin"
    (cd "$YAY_TMP/yay-bin" && makepkg -si --noconfirm)
    rm -rf "$YAY_TMP"
fi

echo "Instalando paquetes de AUR con yay..."
yay -S --needed jstest-gtk-git boxflat betterlockscreen tokyonight-gtk-theme-git \
    xwinwrap-0.9-bin google-chrome visual-studio-code-bin spotify skippy-xd-git

# 4. Restaurar configuraciones de usuario
echo "Restaurando dotfiles de usuario..."
cp -r "$DIR/.config/"* ~/.config/
cp "$DIR/.zshrc" ~/
cp "$DIR/.p10k.zsh" ~/

# Fondos de pantalla (si están incluidos en el repo)
if [ -d "$DIR/Wallpapers" ]; then
    mkdir -p ~/Wallpapers
    cp -r "$DIR/Wallpapers/"* ~/Wallpapers/
fi

# Plank dock: TokyoNight theme + dconf settings (dock items, size, theme)
mkdir -p ~/.local/share/plank/themes
cp -r "$DIR/.local/share/plank/themes/"* ~/.local/share/plank/themes/
dconf load /net/launchpad/plank/docks/ < ~/.config/plank/docks.dconf

chmod +x ~/.config/rofi/powermenu.sh
chmod +x ~/.config/rofi/control-center.sh
chmod +x ~/.config/i3/sleep_lock.sh
chmod +x ~/.config/i3/lock_osd.sh
chmod +x ~/.config/i3/osd_ui.py
chmod +x ~/.config/i3/maximize.sh
chmod +x ~/.config/i3/wallpaper.sh
chmod +x ~/.config/autorandr/postswitch
chmod +x ~/.config/polybar/launch.sh
chmod +x ~/.config/polybar/scripts/active-app.sh
chmod +x ~/.config/polybar/scripts/media.sh

# 5. Shell: Oh My Zsh + Powerlevel10k + plugins
echo "Configurando zsh (Oh My Zsh, Powerlevel10k y plugins)..."
if [ ! -d ~/.oh-my-zsh ]; then
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
[ -d "$ZSH_CUSTOM/themes/powerlevel10k" ] || \
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
[ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] || \
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
[ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] || \
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
[ "$SHELL" = "$(command -v zsh)" ] || chsh -s "$(command -v zsh)"

# Secretos locales (tokens, API keys): nunca van al repo
touch ~/.zshrc.local && chmod 600 ~/.zshrc.local

# 6. Restaurar configuraciones del sistema (LightDM)
echo "Restaurando configuraciones del sistema..."
if [ -d "$DIR/system/etc/lightdm" ]; then
    sudo cp -r "$DIR/system/etc/lightdm/"* /etc/lightdm/
fi

# 7. Configurar el Hook de sistema para la suspensión y LightDM
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

# ACtivar el servicio de cronie
sudo systemctl enable cronie

# 8. Instalar Neovim (LazyVim)
echo "Configurando Neovim (LazyVim)..."
rm -rf ~/.config/nvim
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git

echo "=========================================================="
echo "¡Instalación completada con éxito!"
echo "Pasos finales manuales:"
echo "1. Ejecuta: betterlockscreen -u /ruta/a/tu/fondo.jpg --blur 0.5 --display 1"
echo "2. Copia tu fondo de login: sudo cp /ruta/fondo.jpg /usr/share/pixmaps/login_bg.jpg"
echo "3. Monitores: acomódalos (arandr o xrandr) y guarda el layout con: autorandr --save <nombre>"
echo "   Sin perfil propio, las pantallas se ponen una al lado de la otra."
echo "4. Pon tus tokens/API keys en ~/.zshrc.local (no se versiona)."
echo "5. Abre 'nvim' una vez para que descargue los plugins."
echo "6. Reinicia el equipo para ver todos los cambios."
echo "=========================================================="
