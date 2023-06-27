#!/bin/bash
# Disable all Notofication Messages
# VBoxManage setextradata global GUI/SuppressMessages "all"
# This will restore Machine from a snapshot
# In windows, VBoxManage 
# Show list VM
#VBoxManage list vms
# Show list snapshot VM
#VBoxManage snapshot "W10-Home" list
# Shutdown and restore to "snapshot 1"
# Graceful shutdown with ACPI 
#VBoxManage controlvm "W10-Home" acpipowerbutton
# Shut the VM down with force
VBoxManage controlvm "W10-Home" poweroff
sleep 3s
#VBoxManage snapshot "W10-Home" restore "Snapshot 1"
VBoxManage snapshot "W10-Home" restore "Snapshot 2"
#Turn on W10-Home
# VBoxManage startvm "W10-Home" --type headless
VBoxManage startvm "W10-Home"
# Show infor state
#VBoxManage showvminfo "W10-Home" | grep State
