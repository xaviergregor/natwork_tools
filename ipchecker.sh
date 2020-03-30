#! /bin/bash

#création du fichier ip.txt
#vous pouvez changer le chemin (il faudra aussi changer "ancienne IP" "test IP" "mise à jour IP")
touch /tmp/ip.txt

#ancienne IP
adrip=$(grep [1-9] < /tmp/ip.txt)

#nouvelle IP
adrip2=$(curl ifconfig.co)

#test IP
if [ $adrip != $adrip2 ]
then
        echo $adrip2 > /tmp/ip.txt
fi
#mise a jour IP
echo $adrip2 > /tmp/ip.txt
