#!/bin/bash
#adds wired ps4 controller to win10 virtual guest
#added myself into sudoers file so I don't need to type in my password 
#everytime for virsh command

sudo virsh attach-device win10 ps4controller.xml

