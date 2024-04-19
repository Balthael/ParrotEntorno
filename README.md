
# Entorno de S4vitar en Kali Linux 100% Funcional

![Entorno S4vitar](images/01.png)

Bienvenidos a la guía de personalización del entorno de S4vitar en Kali Linux. Aquí encontrarás todos los pasos necesarios para una instalación completa y funcional.

## Video Tutorial

Puedes seguir el video tutorial paso a paso en mi [canal de YouTube](https://youtube.com). Si el contenido es de tu agrado, considera suscribirte y seguirme en [LinkedIn](https://www.linkedin.com/in/johnosoriob/).

## Instalación

Clona el repositorio y prepara la instalación con los siguientes comandos:

```bash
git clone https://github.com/Balthael/KaliEntorno
cd KaliEntorno
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
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

**Usuario no privilegiado:**

```bash
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

### Instalación de Neovim

#### Para Root:

```bash
sudo su
cd
git clone https://github.com/NvChad/starter ~/.config/nvim
mkdir /opt/nvim
cd /opt/nvim
mv /home/balthael/KaliEntorno/neovim/nvim-linux64 .
cd /opt/nvim/nvim-linux64/bin
./nvim
```

#### Para Usuario No Privilegiado:

```bash
cd
git clone https://github.com/NvChad/starter ~/.config/nvim
nvim
```

## Contacto

Si tienes preguntas o necesitas ayuda, no dudes en escribirme a mi [LinkedIn](https://www.linkedin.com/in/johnosoriob/).
```

