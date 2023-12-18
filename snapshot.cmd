@echo off
set local
set vbm="C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"
set vm="W10"
::vm10
::pc
::123
:%vbm% modifyvm %vm% --clipboard-file-transfers bidirectional
:%vbm% controlvm %vm% draganddrop bidirectional

:: Snap 1, fresh install VM
%vbm% snapshot %vm% take snap1
endlocal