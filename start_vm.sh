#! /usr/bin/bash

# quick script to start our win10 gaming vm and disable the right
# monitor, then re-enable it after it shutsdown
# lets us use two monitors in linux and the vm easily

left_monitor="HDMI2"
right_monitor="HDMI1"

clear

echo "**************************************"
echo "*   David's win10 gaming VM script   *"
echo "**************************************"
echo ""
echo "This script will take the following steps:"
echo "* Start synergy if not running"
echo "* Switch off the right monitor from DVI input"
echo "* Start the win10 gaming VM"
echo "* Wait until the VM is shutdown"
echo "* Stop synergy from running"
echo "* Switch the right monitor back on"
echo ""
echo ""

# fire up the small python server that will wait for commands from the VM
python host_server.py &

# switch off the right monitor
echo "** Switching off the right monitor..."
xrandr --output $right_monitor --off

# check if synergy is running, if it's not, start it
echo "** Checking if synergy is running..."
if ps -e | grep -q synergy
then
    echo "** Synergy already running"
else
    echo "** Starting synergy..."
    synergy &
fi


# start the vm up
echo "** Starting the virtual machine..."
sudo virsh start win10

# ensure we give it time to startup, shouldn't need this, but
# just in case
sleep 2

echo ""
echo "*** Waiting on the virtual machine to shutdown before continuing..."
while true
do
    if sudo virsh list | grep -q win10
    then
        :
    else
        echo "VM finished running!"
	sleep 2
	xrandr --output $right_monitor --auto --right-of $left_monitor
	break
    fi
    sleep 1
done

killall synergy
killall synergyc
curl 127.0.0.1:8080/exit_http_server
