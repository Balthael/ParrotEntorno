
# Entorno de S4vitar en Parrot 100% Funcional

![Entorno S4vitar](images/01.png)

Bienvenidos a la guía de personalización del entorno de S4vitar en Parrot. Aquí encontrarás todos los pasos necesarios para una instalación completa y funcional.

## Video Tutorial

Puedes seguir el video tutorial paso a paso en mi [canal de YouTube](https://youtu.be/rY6S9CS6KDc). Si el contenido es de tu agrado, considera suscribirte y seguirme en [LinkedIn](https://www.linkedin.com/in/johnosoriob/).

Recuerda que este script esta diseñado para un sistema operavito Parrot en Español, si lo quieres en Ingles, cambia en el install.sh Descargas por Downloads.
## Instalación

Clona el repositorio y prepara la instalación con los siguientes comandos:

```bash
git clone https://github.com/Balthael/ParrotEntorno
cd ParrotEntorno
chmod +x install.sh
sudo ./install.sh
```

Después de la instalación, asegúrate de seleccionar BSPWM e instalar `fzf` y `nvim`, ya que no están incluidos en el script inicial.

 ![bspwm](images/02.png)

### Problemas comunes

Si encuentras un error al cambiar al usuario root, sigue estos pasos para corregirlo:

![Error root](images/03.png)

Solución:

```bash
Ctrl + C
compaudit
chown root:root /usr/local/share/zsh/site-functions/_bspc
exit
```

![Solución error](images/04.png)

### Instalación de fzf

Instalación para usuarios root y no privilegiados:

**Root:**

```bash
sudo su
```

```bash
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

**Usuario no privilegiado:**

```bash
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

### Ejecute este comando para evitar problemas en la zsh
- user=$(getent passwd $SUDO_USER | cut -d: -f6 | grep -oE '[^/]+$')
- sudo chsh -s $(which zsh) $user


### Instalación de Neovim

#### Para Usuario No Privilegiado:
Cada linea de comando por separado.

```bash
- Nos clonamos el NvChad como usuario no privilegiado `git clone https://github.com/NvChad/starter ~/.config/nvim`
- `sudo su` --->Nos convertimos en root 
- `cd` --->Para ir a la raíz
- `mkdir /opt/nvim`
- `cd /opt/nvim`
- `mv /home/balthael/ParrotEntorno/neovim/nvim-linux64 .` Movemos la carpeta nvim-linux64 que esta en el repositorio del entorno que clonamos  a la ruta creada.
- Nos cambiamos a usuario no privilegiado
- `cd /opt/nvim/nvim-linux64/bin `
- `sudo apt remove neovim`
- `./nvim` 
- `nvim`

```

#### Para Usuario Root:

```bash

- `sudo su` ---> Para volvernos root
- `cd /root/.config/` ---> Ir a la carpeta raíz de root
- `cp -r /home/balthael/.config/nvim .` ---> Copiamos de forma recursiva la carpeta nvim 
- `cd /root/.config/nvim` ---> vamos a la ruta nvim 
- `nvim` ---> Ejecutamos nvim 

```
 Para quitar el $ de nvim ver el video y agregar estas dos lineas en options.lua

```bash
Como root vamos a la ruta /root/.config/nvim/lua
y agregamos estas dons lineas en el archivo:
local o = vim.o
o.list =false

De igual manera para el usuario no privilegiado: 

Como usuario no privilegiado vamos /home/<su_usuario>/.config/nvim/lua
y agregamos estas dons lineas en el archivo:
local o = vim.o
o.list =false
```

## Contacto

Si tienes preguntas o necesitas ayuda, no dudes en escribirme a mi [LinkedIn](https://www.linkedin.com/in/johnosoriob/).

Gracias

