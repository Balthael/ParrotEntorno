#!/bin/sh

# Detectar interfaces activas con IP (exceptuando loopback)
ACTIVE_IFACES=$(ip -o -4 addr show up | awk '!/ lo / {print $2}')

# Inicializar IP vacía
IP="Sin conexión"

# Recorrer interfaces activas
for IFACE in $ACTIVE_IFACES; do
    CUR_IP=$(ip -o -4 addr show $IFACE | awk '{print $4}' | cut -d/ -f1)
    if echo "$IFACE" | grep -qE '^wl'; then
        ICON=""  # Wi-Fi
    else
        ICON=""  # Cable
    fi
    IP="$ICON $CUR_IP"
    break  # Solo mostramos la primera activa
done


# Icono y color en Polybar
echo "%{F#2495e7} %{F#ffffff}$IP%{u-}"
