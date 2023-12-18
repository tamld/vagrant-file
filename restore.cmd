@echo off
set local
set vbm="C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"
set vm="W10"
::vm10
::pc
::123
%vbm% controlvm %vm% poweroff >nul
timeout /t 5 /nobreak >nul
%vbm% snapshot %vm% restore snap1
%vbm% startvm %vm%
endlocal