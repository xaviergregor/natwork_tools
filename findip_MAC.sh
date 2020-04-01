#! /bin/bash
#
echo " Entrer la MAC address a rechercher "
read mac
result=$(arp-scan -l | grep "$mac" | awk '{print $1}')
if [ $result ]; then
      echo "L'addresse IP pour ce perepherique $mac est $result"
    else
          echo "Pas de resultat, peripherique non sur le reseau"
fi
