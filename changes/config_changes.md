# Important folders for configs 

# Linux
- chef/cookbooks/metasploitable/recipes/
- chef/cookbooks/metasploitable/templates/
- chef/cookbooks/metasploitable/files/
# Windows 
- resources

---
## scripts\configs\ 
- [ ] -> Change firewall logs in disable_firewall.bat for PORTS
- [ ] -> RDP change port
- [ ] -> Change users accordingly based on services config 

## scripts\installs\ 
- [ ] -> in openssh.ps1 there is also a config the it gets from a thirdparty  "http://www.mls-software.com/files/setupssh-7.1p1-1.exe". And then it replaces the config in the same file

## packer\answer_files\2008_r2\Autounattend.xml
- [ ] -> auto logon turn off also under Autounattend.xml 
- [ ] -> !!!! Change admin pass 
    ```
        <AdministratorPassword>
            <Value>YOUR_NEW_PASSWORD</Value>
            <PlainText>false</PlainText> !!!! Check which format does it need BASE64???
        </AdministratorPassword>
    ```
- [ ] -> Windows users name and passoword ```<Name>vagrant</Name>```
- [ ] -> Windows admin user password ```<Value>vagrant</Value>```
    - [ ] -> One changing username and password it is also needed to change here in Vagrantfile
        ```
            win2k8.winrm.username = "vagrant"
            win2k8.winrm.password = "YOUR_NEW_PASSWORD"
        ```
- [ ] -> Remove local user vagrant from Administrator group
- [ ] -> Rename computer name ```<ComputerName>vagrant-2008R2</ComputerName>```


# Testing if vagrant not ADMIN group can change services

# My King announcment service
The service will not crash 