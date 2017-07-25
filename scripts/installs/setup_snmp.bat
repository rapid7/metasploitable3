start /w PKGMGR.EXE /quiet /norestart /iu:SNMP
reg delete HKLM\SYSTEM\ControlSet001\services\SNMP\Parameters\PermittedManagers /va /f
reg add HKLM\SYSTEM\ControlSet001\services\SNMP\Parameters /v EnableAuthenticationTraps /t REG_DWORD /d 0 /f
reg add HKLM\SYSTEM\ControlSet001\services\SNMP\Parameters\ValidCommunities /v public /t REG_DWORD /d 4 /f
