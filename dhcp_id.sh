#!/bin/bash
#Script pour detecter le serveur DHCP sur le réseau
#
# Author: Xavier Gregor
# Contact: Github issue
# Version 0.1
#
# Copyright (c) 2024 Xavier Gregor
#
# Fonction pour obtenir l'IP du serveur DHCP sur macOS

get_dhcp_mac() {
 ipconfig getpacket en0 | awk '/server_identifier/ {print $3}'
}

# Fonction pour obtenir l'IP du serveur DHCP sur Linux

get_dhcp_linux() {
    grep 'dhcp-server-identifier' /var/lib/dhcp/dhclient.*.leases | tail -1 | awk '{print $3}' | sed 's/;//'
}

# Détecter le système d'exploitation

OS=$(uname -s)
case "$OS" in
    "Darwin") # macOS
        echo "🦖 macOS"
        echo "Le serveur DHCP est:"
        get_dhcp_mac
        ;;
    "Linux") # Linux
        echo "🦕 Linux"
        echo "Le serveur DHCP est:"
        get_dhcp_linux
        ;;
    *)
        echo "Système non pris en charge."
        exit 1
        ;;
esac

