#! /bin/bash

# quick script to detach mouse+keyboard before shutting down the vm
# allows me to continue working in host without waiting for
# win10 to release peripherals
sudo virsh detach-device win10 mouse.xml
sudo virsh detach-device win10 keybd.xml
sudo virsh shutdown win10
