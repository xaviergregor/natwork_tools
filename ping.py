#ping in python

#Ping en Python

import os
hostname = "google.fr"
response = os.system("ping -c 10 " + hostname)
if response == 0:
       pingstatus = "Network Active"

else:
            pingstatus = "Network Error"
