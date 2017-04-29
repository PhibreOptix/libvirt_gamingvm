Small collection of scripts I use to make working with my Windows 10 
gaming VM using PCI passthrough easier to manage.

start_vm.sh deals with switching off the right monitor, starting all the 
neccesary helper applications and starting the VM.

shutdown_vm.sh detaches the keyboard and mouse before sending a shutdown 
signal to the VM, as I pass these through then use Synergy to still 
perform work on the host. Doing this allows me to start using the host 
before the VM finishes shutting down.

host_server.py is a small http server in python that receives GET 
requests and runs commands on the host

vm_client_contact_host_server.ps1 is a powershell script that runs on 
startup in the VM, asking the host to passthrough the keyboard and mouse 
and setting the status to online in vm_status.txt
Other devices in the home read this file because I'm lazy eg. when I'm 
downstairs wanting to use the steam link and don't want to check the 
host PC.
