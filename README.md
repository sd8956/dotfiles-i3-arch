# 🌙 Arch Linux Dotfiles - TokyoNight Edition

Un entorno de trabajo híbrido basado en **i3wm** y **Arch Linux**, diseñado con un enfoque minimalista y simétrico utilizando la paleta de colores **TokyoNight**. 

Este setup está optimizado para ofrecer el máximo rendimiento en un entorno multipropósito: desde flujos de trabajo de desarrollo (Data Science, Machine Learning, PHP/Laravel) hasta configuraciones de gaming y sim racing.

## 📸 Screenshots
*(Nota: Reemplaza este texto con imágenes de tu escritorio, el menú de Rofi y tu pantalla de bloqueo)*

## ✨ Características Destacadas

* **Gestor de Ventanas:** i3wm configurado para un flujo de trabajo rápido con atajos de teclado y reglas de ventanas flotantes específicas.
* **Barra de Estado:** Polybar con diseño limpio, reloj centrado al estilo macOS/GNOME e indicadores visuales en la paleta TokyoNight.
* **Lanzadores (Rofi):**
  * **App Launcher:** Cajón de aplicaciones centrado, con barra de búsqueda, soporte para iconos (Papirus-Dark) y fondo desenfocado.
  * **Power Menu:** Menú interactivo flotante para apagar, reiniciar o suspender.
* **OSD Personalizado (Python GTK):** Un motor gráfico hecho a medida para notificaciones de hardware. Al presionar *Caps Lock* o *Num Lock*, dibuja un popup flotante, redondeado y milimétricamente centrado en pantalla, sin interrumpir la escritura.
* **Pantalla de Bloqueo:** Betterlockscreen con efecto blur integrado mediante scripts para asegurar el bloqueo antes de la suspensión del sistema.
* **Notificaciones:** Dunst configurado para mantener la estética global del sistema y centrar alertas críticas.

## 🛠️ Ecosistema y Herramientas

La arquitectura de este sistema (automatizada en el script de instalación) prepara Arch Linux con todo lo necesario para:
* **Productividad & Datos:** Entornos listos para Neovim (LazyVim), terminales modernas, y compatibilidad fluida con entornos de ciencia de datos (Jupyter/Conda) y desarrollo web (Laravel).
* **Gaming & Simulación:** Repositorios multilib activos, Gamemode, Mangohud y librerías preparadas para Steam y hardware de sim racing (volantes Direct Drive).

## 🚀 Instalación Automática

El repositorio incluye un script maestro que instala todas las dependencias (oficiales y AUR), restaura los archivos de configuración y aplica los permisos necesarios en un solo paso.

1. Clona este repositorio:
```bash
git clone git@github.com:sd8956/dotfiles-i3-arch.git ~/mis_dotfiles
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

## 📂 Estructura del Repositorio

* `.config/i3/`: Configuración principal del gestor de ventanas y scripts de bloqueo (Bash) y OSD (Python).
* `.config/polybar/`: Configuración de la barra de estado superior.
* `.config/rofi/`: Temas `.rasi` estilo TokyoNight y scripts del menú de apagado y cajón de apps.
* `.config/dunst/`: Reglas de notificaciones y diseño visual.
* `.config/betterlockscreen/`: Variables de color para el anillo de bloqueo.
* `backup_dotfiles.sh`: Script personal para respaldar configuraciones actuales al repositorio local.
* `install_setup.sh`: Script de instalación y despliegue automatizado.

## 📝 Notas Adicionales
* Se requiere establecer el fondo de pantalla inicial para Betterlockscreen manualmente tras la instalación: `betterlockscreen -u /ruta/imagen.jpg --blur 0.5 --display 1`
* Requiere un compositor activo (como `picom`) para que las transparencias y esquinas redondeadas del OSD de Python funcionen correctamente.
