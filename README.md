# 🌙 Arch Linux Dotfiles - TokyoNight Edition

Un entorno de trabajo híbrido basado en **i3wm** y **Arch Linux**, diseñado con un enfoque minimalista y simétrico utilizando la paleta de colores **TokyoNight**, con una capa visual inspirada en macOS (barra de menú, dock, sombras y animaciones) sin perder el tiling de i3.

Este setup está optimizado para ofrecer el máximo rendimiento en un entorno multipropósito: desde flujos de trabajo de desarrollo (Data Science, Machine Learning, PHP/Laravel) hasta configuraciones de gaming y sim racing.

## 📸 Screenshots

**Escritorio:** barra de menú estilo macOS, dock (Plank) y fondo animado.
![Escritorio](screenshots/desktop.jpg)

**Tiling:** ventanas lado a lado con gaps, sombras y esquinas redondeadas.
![Tiling](screenshots/tiling.jpg)

**Maximizar (`$mod+m`):** la ventana flota sobre las demás sin tapar la barra ni el dock.
![Maximizar](screenshots/maximize.jpg)

**Power Menu (Rofi).**
![Power Menu](screenshots/powermenu.jpg)

## ✨ Características Destacadas

* **Gestor de Ventanas:** i3wm configurado para un flujo de trabajo rápido con atajos de teclado y reglas de ventanas flotantes específicas.
* **Barra de Estado:** Polybar estilo barra de menú de macOS: logo de Arch (abre el launcher), nombre de la app enfocada y workspaces; al centro lo que suena (Spotify o cualquier reproductor MPRIS) con botones anterior / pausa / siguiente; a la derecha tray, stats, volumen, fecha y el ⚙ del Centro de Control. Fondo translúcido con blur de picom.
* **Compositor (picom):** esquinas redondeadas, blur, sombras suaves y animaciones de apertura/cierre/redimensionado. Las ventanas en pantalla completa (juegos) se saltan el compositor: sin costo ni latencia extra.
* **Centro de Control (⚙ en la barra):** Wi-Fi (redes, contraseña, encender/apagar), Bluetooth (dispositivos vinculados), sonido, No Molestar y apagado, con un solo clic.
* **Mission Control (skippy-xd):** `$mod+|` muestra las ventanas del monitor en miniatura; `$mod+Shift+|` muestra las de todos los monitores en una sola vista.
* **Cambio de apps estilo ⌘+Tab:** mantené Super, `Tab` / `Shift+Tab` recorren las ventanas de todos los monitores en miniatura y al soltar se elige.
* **Capturas estilo macOS:** `Print` (región), `Shift+Print` (monitor bajo el mouse), `Ctrl+Print` (ventana activa). Se guardan en `~/Pictures/Screenshots`, se copian al portapapeles y aparece una miniatura; clic para abrirla.
* **Maximizar estilo macOS (`$mod+m`):** la ventana flota sobre las demás ocupando el workspace sin tapar la barra ni el dock; repetir el atajo la restaura. `$mod+f` sigue siendo pantalla completa.
* **Dock (Plank):** dock inferior estilo macOS con tema TokyoNight propio y lanzadores fijos (Thunar, Ghostty, Chrome, Zed, Obsidian, Spotify, Discord, Steam).
* **Fondo animado:** video en loop (`xwinwrap` + `mpv`) en cada monitor conectado; si no hay video, usa una imagen estática con `feh`.
* **Monitores portables (autorandr):** el layout guardado solo se aplica cuando están conectados esos monitores exactos (por EDID); en otra PC las pantallas se ponen una al lado de la otra. El wallpaper y la barra se reacomodan solos al cambiar de monitores.
* **Lanzadores (Rofi):**
  * **Spotlight (`$mod+space`):** una barra de búsqueda grande en el tercio superior, resultados en una columna.
  * **App Launcher (`$mod+d`):** Cajón de aplicaciones centrado, con barra de búsqueda, soporte para iconos (Papirus-Dark) y fondo desenfocado.
  * **Power Menu:** Menú interactivo flotante para apagar, reiniciar o suspender.
* **OSD Personalizado (Python GTK + Cairo):** Al presionar *Caps Lock* o *Num Lock*, dibuja un popup redondeado en el centro del monitor activo, sin interrumpir la escritura. El icono se centra por su dibujo real (no por las métricas de la fuente), así queda exacto con cualquier glifo de Nerd Font.
* **Pantalla de Bloqueo estilo macOS:** reloj grande con la fecha, avatar circular con el anillo de escritura alrededor, nombre y campo "Enter Password" sobre el wallpaper atenuado (betterlockscreen + i3lock-color). `xss-lock` bloquea antes de suspender.
* **Login (LightDM + slick-greeter):** mismo wallpaper y avatar que el bloqueo, usuario centrado y reloj de 24 h.
* **Notificaciones:** Dunst con tarjetas estilo macOS arriba a la derecha: translúcidas, redondeadas, con icono de la app, barra de progreso y borde rojo para alertas críticas (que se quedan hasta cerrarlas).
* **Historial del portapapeles (`$mod+v`):** lo último que copiaste (texto e imágenes) con el estilo de Spotlight, vía greenclip. El historial queda en `~/.cache` (nunca en el repo) y no registra lo que copian KeePassXC, Bitwarden ni 1Password.
* **Terminal y Shell:** Ghostty + zsh con Oh My Zsh, Powerlevel10k, autosugerencias y resaltado de sintaxis.

## ⌨️ Atajos Principales

`$mod` es la tecla Super (Windows).

| Atajo | Acción |
|-------|--------|
| `$mod+Return` | Terminal (Ghostty) |
| `$mod+space` | Spotlight (buscar y abrir apps) |
| `$mod+d` | Lanzador de aplicaciones en grilla (Rofi) |
| `$mod+Tab` / `$mod+Shift+Tab` | Cambiar de ventana estilo ⌘+Tab (mantener Super) |
| `$mod+f` | Pantalla completa |
| `$mod+m` | Maximizar estilo macOS (repetir para restaurar) |
| `$mod+\|` / `$mod+Shift+\|` | Mission Control: monitor actual / todos los monitores (tecla a la izquierda del 1; abre al soltar) |
| `$mod+1` … `$mod+0` | Ir al workspace 1–10 (se crea solo si no existe) |
| `$mod+Shift+1` … `$mod+Shift+0` | Mover la ventana enfocada a ese workspace |
| `$mod+Shift+space` | Alternar ventana flotante / tiling |
| `$mod+Ctrl+space` | Mover el foco entre ventanas flotantes y tiling |
| `$mod+Shift+q` | Cerrar ventana |
| `$mod+r` | Modo redimensionar |
| `$mod+v` | Historial del portapapeles |
| `$mod+b` / `$mod+e` / `$mod+z` | Chrome / Thunar / Zed |
| `$mod+l` | Bloquear pantalla |
| `Print` / `Shift+Print` / `Ctrl+Print` | Captura de región / monitor / ventana (archivo + portapapeles) |
| `$mod+Shift+r` | Reiniciar i3 |

## 🛠️ Ecosistema y Herramientas

La arquitectura de este sistema (automatizada en el script de instalación) prepara Arch Linux con todo lo necesario para:
* **Productividad & Datos:** Entornos listos para Neovim (LazyVim), terminales modernas, y compatibilidad fluida con entornos de ciencia de datos (Jupyter/Conda) y desarrollo web (Laravel).
* **Gaming & Simulación:** Repositorios multilib activos, Gamemode, Mangohud y librerías preparadas para Steam y hardware de sim racing (volantes Direct Drive).

## 🚀 Instalación Automática

El repositorio incluye un script maestro que instala todas las dependencias (oficiales y AUR, e instala `yay` si falta), restaura los archivos de configuración, configura zsh y aplica los permisos necesarios en un solo paso.

**Requisitos:** Arch Linux base instalado, un usuario con `sudo` y `git` (`sudo pacman -S git`).

1. Clona este repositorio (por HTTPS, no requiere llaves SSH en una PC nueva):
```bash
git clone https://github.com/sd8956/dotfiles-i3-arch.git ~/mis_dotfiles
```

2. Entra al directorio y da permisos de ejecución al script:
```bash
cd ~/mis_dotfiles
chmod +x install_setup.sh
```

3. Ejecuta el instalador:
```bash
./install_setup.sh
```

4. Pasos manuales tras la instalación:
   * **Monitores:** acomódalos (con `arandr` o `xrandr`) y guarda el layout de esa PC: `autorandr --save <nombre>`.
   * **Bloqueo y login:** `~/.config/betterlockscreen/lockscreen-setup.sh` (genera el fondo con avatar; tu foto opcional en `~/.face`) y `~/.config/betterlockscreen/set-login-avatar.sh` (pide sudo, pone el mismo avatar en el login).
   * **Fondo de login:** `sudo cp ~/Wallpapers/gargantua-black-3840x2160-9621.jpg /usr/share/pixmaps/login_bg.jpg`
   * **Secretos:** pon tus tokens y API keys en `~/.zshrc.local` (se carga desde `.zshrc` y nunca se versiona).
   * Abre `nvim` una vez para que descargue los plugins y reinicia el equipo.

## 💾 Respaldar Cambios

Tras modificar tu configuración en el sistema, cópiala al repositorio con:
```bash
./backup_dotfiles.sh
```
El script escribe en la carpeta donde vive (sin importar dónde clonaste el repo) y **se niega a copiar `.zshrc` si contiene secretos** (`TOKEN`, `SECRET`, `API_KEY`...), porque el repositorio es público.

## 📂 Estructura del Repositorio

* `.config/i3/`: Configuración principal del gestor de ventanas, scripts de bloqueo (Bash), OSD (Python), maximizar (`maximize.sh`), fondo animado (`wallpaper.sh`) y capturas (`screenshot.sh`).
* `.config/polybar/`: Barra superior estilo macOS, su lanzador y los scripts de la app enfocada y del reproductor.
* `.config/picom/`: Compositor (blur, sombras, esquinas redondeadas y animaciones).
* `.config/plank/` y `.local/share/plank/themes/`: Lanzadores y ajustes del dock (`docks.dconf`) y su tema TokyoNight.
* `.config/autorandr/`: Perfil de monitores de cada PC y hook que reacomoda wallpaper y barra.
* `.config/rofi/`: Temas `.rasi` estilo TokyoNight (launcher, Spotlight, Centro de Control, apagado) y los scripts del Centro de Control, del historial del portapapeles (`clipboard.sh`) y del menú de apagado.
* `.config/skippy-xd/`: Mission Control (colores y esquinas TokyoNight).
* `.config/greenclip.toml`: Historial del portapapeles (tamaño, imágenes, apps excluidas).
* `.config/dunst/`: Reglas de notificaciones y diseño visual.
* `.config/betterlockscreen/`: Layout estilo macOS del bloqueo (`betterlockscreenrc`), el script que dibuja avatar y campo (`lockscreen-setup.sh`) y el que pone el avatar en el login (`set-login-avatar.sh`).
* `.config/ghostty/` y `.config/gtk-3.0/`: Terminal y tema GTK.
* `.zshrc` y `.p10k.zsh`: Shell (Oh My Zsh + Powerlevel10k).
* `Wallpapers/`: Fondos usados por el escritorio (video animado e imagen estática).
* `system/etc/lightdm/`: Configuración del gestor de login (LightDM + slick-greeter).
* `backup_dotfiles.sh`: Respalda la configuración actual del sistema al repositorio.
* `install_setup.sh`: Script de instalación y despliegue automatizado.

## 📝 Notas Adicionales
* Requiere un compositor activo (`picom`, incluido) para las transparencias, el blur y las esquinas redondeadas de la barra, el dock y el OSD de Python.
* Los iconos del tray (wifi, Steam) no pueden ser transparentes en Polybar; por eso la barra usa ~90% de opacidad y `launch.sh` fija un color de fondo que se funde con ella.
* Mission Control se abre al **soltar** las teclas: con la tecla mantenida, la repetición automática lo llamaría dos veces y la segunda llamada lo cierra.
* `backup_dotfiles.sh` copia la configuración del login **desde `/etc/lightdm`**. Si editás `system/etc/lightdm/` en el repo, aplicala con `sudo cp` antes de correr el backup o el cambio se pierde.
