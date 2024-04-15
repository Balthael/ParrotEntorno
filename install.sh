#!/bin/bash

# Verificar si el script se ejecuta como superusuario
if [ "$(id -u)" -ne 0 ]; then
    echo "Este script debe ejecutarse como root."
    exit 1
fi

# Actualizando el sistema
echo "Actualizando el sistema..."
sudo apt update && apt upgrade -y
if [ $? -ne 0 ]; then
    echo "Error durante la actualización del sistema. Abortando."
    exit 1
fi

sleep 5
# Intentar instalar dependencias
echo "Instalando depetendencias..."
sleep 2
deps=("build-essential" "git" "vim" "libxcb-util0-dev" "libxcb-ewmh-dev" "libxcb-randr0-dev" "libxcb-icccm4-dev" "libxcb-keysyms1-dev" "libxcb-xinerama0-dev" "libasound2-dev" "libxcb-xtest0-dev" "libxcb-shape0-dev")
for dep in "${deps[@]}"; do
    if ! sudo apt install -y "$dep"; then
        echo "Advertencia: No se pudo instalar el paquete $dep. Intentando continuar..."
    fi
done

sleep 5
# Definir el directorio home del usuario
echo "Definir el directorio home del usuario..."
sleep 2
user_home=$(getent passwd $SUDO_USER | cut -d: -f6)

sleep 5

# Clonar y compilar bspwm y sxhkd en el home del usuario
echo "Clonar y compilar bspwm y sxhkd en el home del usuario..."
sleep 2
cd "$user_home"
sudo -u $SUDO_USER git clone https://github.com/baskerville/bspwm.git
sudo -u $SUDO_USER git clone https://github.com/baskerville/sxhkd.git

sleep 5
# Compilar e instalar bspwm
cd "$user_home/bspwm"
sudo -u $SUDO_USER make
sudo make install
if [ $? -ne 0 ]; then
    echo "Error al instalar bspwm. Abortando."
    exit 1
fi
sleep 5
# Compilar e instalar sxhkd
cd "$user_home/sxhkd"
sudo -u $SUDO_USER make
sudo make install
if [ $? -ne 0 ]; then
    echo "Error al instalar sxhkd. Abortando."
    exit 1
fi
sleep 5
# Instalar libxinerama1 y libxinerama-dev
sudo apt install libxinerama1 libxinerama-dev -y
if [ $? -ne 0 ]; then
    echo "Error al instalar libxinerama1 y libxinerama-dev. Abortando."
    exit 1
fi

sleep 5

# Instalar kitty 
echo "Instalando kitty..." 
sudo apt install kitty -y 
if [ $? -ne 0 ]; then 
	echo "Error al instalar kitty. Abortando." 
	exit 1 
fi

sleep 5
# Crear directorios de configuración
sudo -u $SUDO_USER mkdir -p "$user_home/.config/bspwm" "$user_home/.config/sxhkd" "$user_home/.config/bspwm/scripts" "$user_home/fondos"
sudo -u $SUDO_USER cp "$user_home/KaliEntorno/fondos/fondo1.jpg" "$user_home/fondos/fondo1.jpg"

sleep 5
# Copiar los archivos de configuración a las carpetas de configuración 
# Asegúrese de que estos pasos se ejecuten después de que el repositorio KaliEntorno se haya clonado manualmente 
sudo -u $SUDO_USER cp "$user_home/KaliEntorno/Config/bspwm/bspwmrc" "$user_home/.config/bspwm/" 
sudo -u $SUDO_USER cp "$user_home/KaliEntorno/Config/sxhkd/sxhkdrc" "$user_home/.config/sxhkd/" 

sleep 5
# Copiar el script bspwm_resize al directorio de scripts 
sudo -u $SUDO_USER cp "$user_home/KaliEntorno/Config/bspwm/scripts/bspwm_resize" "$user_home/.config/bspwm/scripts/" 
# Hacer ejecutable el script bspwmrc y bspwm_resize 
chmod +x "$user_home/.config/bspwm/bspwmrc" 
chmod +x "$user_home/.config/bspwm/scripts/bspwm_resize"

sleep 5
# Instalar paquetes adicionales necesarios
sudo apt install cmake cmake-data pkg-config python3-sphinx libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python3-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libasound2-dev libpulse-dev libjsoncpp-dev libmpdclient-dev libuv1-dev libnl-genl-3-dev -y


sleep 5
# Descargar e instalar Polybar como usuario no privilegiado
echo "Instalando Polybar..."
cd "$user_home/Downloads"
sudo -u $SUDO_USER git clone --recursive https://github.com/polybar/polybar
cd polybar
sudo -u $SUDO_USER mkdir build
cd build
sudo -u $SUDO_USER cmake ..
sudo -u $SUDO_USER make -j$(nproc)
sudo make install
if [ $? -ne 0 ]; then
    echo "Error al instalar Polybar. Abortando."
    exit 1
fi
 
sleep 5
sudo apt install meson libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev libevdev-dev uthash-dev libev-dev libx11-xcb-dev libxcb-glx0-dev -y

sleep 5
# Instalar libpcre3 y libpcre3-dev
echo "Instalando libpcre3 y libpcre3-dev..."
sudo apt install libpcre3 libpcre3-dev -y
if [ $? -ne 0 ]; then
    echo "Error al instalar libpcre3 y libpcre3-dev. Abortando."
    exit 1
fi
sleep 5
# Descargar e instalar Picom como usuario no privilegiado
echo "Instalando Picom..."
cd "$user_home/Downloads"
sudo -u $SUDO_USER git clone https://github.com/ibhagwan/picom.git
cd picom
sudo -u $SUDO_USER git submodule update --init --recursive
sudo -u $SUDO_USER meson --buildtype=release . build
if [ $? -ne 0 ]; then
    echo "Error durante la configuración de meson para Picom. Abortando."
    exit 1
fi

sleep 5
# Compilar Picom con ninja
cd "$user_home/Downloads/picom"
sudo -u $SUDO_USER ninja -C build
if [ $? -ne 0 ]; then
    echo "Error al compilar Picom con ninja. Abortando."
    exit 1
fi
sleep 5
# Instalar Picom
cd "$user_home/Downloads/picom"
sudo ninja -C build install
if [ $? -ne 0 ]; then
    echo "Error al instalar Picom. Abortando."
    exit 1
fi

sleep 5

# Instalar Rofi
echo "Instalando Rofi..."
sudo apt install rofi -y
if [ $? -ne 0 ]; then
    echo "Error al instalar Rofi. Abortando."
    exit 1
fi
sleep 5
# Instalar bspwm desde los repositorios
echo "Instalando bspwm desde el repositorio..."
sudo apt install bspwm -y
if [ $? -ne 0 ]; then
    echo "Error al instalar bspwm desde el repositorio. Abortando."
    exit 1
fi
sleep 5

# Copiar todos los archivos de fuentes de KaliEntorno a /usr/local/share/fonts 
echo "Copiando fuentes personalizadas..." 
sudo cp "$user_home/KaliEntorno/fonts/"* /usr/local/share/fonts/

sleep 5

echo "Copiando la configuración de Kitty..." 
mkdir -p "$user_home/.config/kitty" 
# Asegúrate de que el directorio exista 
cp -r "$user_home/KaliEntorno/Config/kitty/." "$user_home/.config/kitty/"

sleep 5

# Instalar Zsh
echo "Instalando Zsh..."
sudo apt install zsh -y
if [ $? -ne 0 ]; then
    echo "Error al instalar Zsh. Abortando."
    exit 1
fi

sleep 5

# Instalar complementos de Zsh
echo "Instalando complementos de Zsh: zsh-autosuggestions y zsh-syntax-highlighting..."
sudo apt install zsh-autosuggestions zsh-syntax-highlighting -y
if [ $? -ne 0 ]; then
    echo "Error al instalar los complementos de Zsh. Abortando."
    exit 1
fi

echo "Complementos de Zsh instalados con éxito."

sleep 5


# Asegurarse de que existe el directorio de configuración de kitty para root
sudo mkdir -p /root/.config/kitty
# Copiar los archivos de configuración de kitty al directorio root
echo "Copiando configuración de kitty al directorio de root..."
sudo cp -r $user_home/.config/kitty/* /root/.config/kitty/
echo "Instalación completada."

sleepa 5
# Instalar feh
echo "Instalando feh..."
sudo apt install feh -y
if [ $? -ne 0 ]; then
    echo "Error al instalar feh. Abortando."
    exit 1
fi

echo "feh instalado correctamente."

sleep 5
# Instalar ImageMagick
echo "Instalando ImageMagick..."
sudo apt install imagemagick -y
if [ $? -ne 0 ]; then
    echo "Error al instalar ImageMagick. Abortando."
    exit 1
fi
echo "ImageMagick instalado correctamente."

sleep 5

# Instalar Scrub
echo "Instalando Scrub..."
sudo apt install scrub -y
if [ $? -ne 0 ]; then
    echo "Error al instalar Scrub. Abortando."
    exit 1
fi
echo "Scrub instalado correctamente."

sleep 5

# Clonar el recurso blue-sky en el directorio Downloads del usuario no privilegiado
echo "Clonando el repositorio blue-sky en el directorio Downloads..."
sudo -u $SUDO_USER git -C "$user_home/Downloads" clone https://github.com/VaughnValle/blue-sky
if [ $? -ne 0 ]; then
    echo "Error al clonar el repositorio blue-sky. Abortando."
    exit 1
fi

echo "Repositorio blue-sky clonado con éxito en la carpeta Downloads."

sleep 5

# Crear el directorio para la configuración de Polybar
echo "Creando directorio de configuración de Polybar para el usuario no privilegiado..."
sudo -u $SUDO_USER mkdir -p "$user_home/.config/polybar"

echo "Directorio de configuración de Polybar creado."

sleep 5

# Copiar los archivos de configuración de Polybar
echo "Copiando archivos de configuración de Polybar..."
sudo -u $SUDO_USER cp -a $user_home/KaliEntorno/Config/polybar/. "$user_home/.config/polybar/"

echo "Archivos de configuración de Polybar copiados."
sleep 5

echo "Copiando fuentes de Polybar al directorio del sistema..."
sudo cp -r "$user_home/KaliEntorno/Config/polybar/fonts/"* /usr/share/fonts/truetype/



sleep 5
# Actualizar la caché de fuentes
sudo fc-cache -f -v

echo "Fuentes de Polybar copiadas al directorio de fuentes del sistema y caché actualizada."

sleep 5

# Crear la carpeta de configuración para picom como usuario no privilegiado
echo "Creando carpeta picom en .config..."
sudo -u $SUDO_USER mkdir -p "$user_home/.config/picom"
if [ $? -ne 0 ]; then
    echo "Error al crear la carpeta picom. Abortando."
    exit 1
fi
echo "Carpeta picom creada exitosamente en .config."

sleep 5

# Copiar el archivo de configuración de picom al directorio de configuración de picom del usuario no privilegiado
echo "Copiando archivo de configuración picom.conf a la carpeta de configuración de picom..."
sudo -u $SUDO_USER cp "$user_home/KaliEntorno/Config/picom/picom.conf" "$user_home/.config/picom/picom.conf"
if [ $? -ne 0 ]; then
    echo "Error al copiar el archivo picom.conf. Abortando."
    exit 1
fi
echo "Archivo picom.conf copiado exitosamente a .config/picom."

sleep 5


# Instalar Neofetch
echo "Instalando Neofetch..."
sudo apt install neofetch -y
if [ $? -ne 0 ]; then
    echo "Error al instalar Neofetch. Abortando."
    exit 1
fi
echo "Neofetch instalado correctamente."

sleep 5

# Crear un enlace simbólico para que root use la configuración .zshrc del usuario no privilegiado
echo "Configurando root para usar la configuración .zshrc del usuario no privilegiado..."
ln -sf "$user_home/.zshrc" /root/.zshrc
if [ $? -ne 0 ]; then
    echo "Error al crear el enlace simbólico para .zshrc de root. Abortando."
    exit 1
fi
echo "Root ahora usará la configuración .zshrc del usuario no privilegiado."




sleep 5
# Reiniciar la sesión de usuario
echo "Reiniciando la sesión de usuario..."
kill -9 -1

# Continuar con la instalación de otras dependencias y configuraciones... 
# ... 
echo "Instalación completada."
