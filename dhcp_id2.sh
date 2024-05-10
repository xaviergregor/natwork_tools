#!/bin/bash

# Fonction pour obtenir l'IP du serveur DHCP ou signaler une configuration IP fixe sur macOS
get_dhcp_mac() {
    if ipconfig getpacket en0 | grep -q 'op = BOOTREPLY'; then
        local ip=$(ipconfig getpacket en0 | awk '/server_identifier/ {print $3}')
        echo "Votre système est 🦖 macOS"
        echo "Le serveur DHCP est $ip"
    else
        echo "Votre système est 🦖 macOS"
        echo "Aucun serveur DHCP utilisé, configuration IP fixe."
    fi
}

# Fonction pour obtenir l'IP du serveur DHCP ou signaler une configuration IP fixe sur Linux
get_dhcp_linux() {
    local lease_file=$(ls /var/lib/dhcp/dhclient.*.leases | tail -n 1)
    if [ -f "$lease_file" ] && grep -q 'dhcp-server-identifier' "$lease_file"; then
        local ip=$(grep 'dhcp-server-identifier' "$lease_file" | tail -1 | awk '{print $3}' | sed 's/;//')
        echo "Votre système est 🦕 Linux"
        echo "Le serveur DHCP est $ip"
    else
        echo "Votre système est 🦕 Linux"
        echo "Aucun serveur DHCP utilisé, configuration IP fixe."
    fi
}

# Détecter le système d'exploitation
OS=$(uname -s)
case "$OS" in
    "Darwin") # macOS
        get_dhcp_mac
        ;;
    "Linux") # Linux
        get_dhcp_linux
        ;;
    *)
        echo "Système non pris en charge."
        exit 1
        ;;
esac

