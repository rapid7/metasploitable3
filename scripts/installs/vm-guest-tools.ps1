function Invoke-CLR4PowerShellCommand {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ScriptBlock]
        $ScriptBlock,
        
        [Parameter(ValueFromRemainingArguments=$true)]
        [Alias('Args')]
        [object[]]
        $ArgumentList
    )
    
    if ($PSVersionTable.CLRVersion.Major -eq 4) {
        Invoke-Command -ScriptBlock $ScriptBlock -ArgumentList $ArgumentList
        return
    }

    $RunActivationConfigPath = $Env:TEMP | Join-Path -ChildPath ([Guid]::NewGuid())
    New-Item -Path $RunActivationConfigPath -ItemType Container | Out-Null
@"
<?xml version="1.0" encoding="utf-8" ?>
<configuration>
  <startup useLegacyV2RuntimeActivationPolicy="true">
    <supportedRuntime version="v4.0"/>
  </startup>
</configuration>
"@ | Set-Content -Path $RunActivationConfigPath\powershell.exe.activation_config -Encoding UTF8

    $EnvVarName = 'COMPLUS_ApplicationMigrationRuntimeActivationConfigPath'
    $EnvVarOld = [Environment]::GetEnvironmentVariable($EnvVarName)
    [Environment]::SetEnvironmentVariable($EnvVarName, $RunActivationConfigPath)

    try {
        & powershell.exe -inputformat text -command $ScriptBlock -args $ArgumentList
    } finally {
        [Environment]::SetEnvironmentVariable($EnvVarName, $EnvVarOld)
        $RunActivationConfigPath | Remove-Item -Recurse
    }
}

Invoke-CLR4PowerShellCommand -ScriptBlock {
    # Force TLS 1.2
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    $sevenZipExe = 'C:\Program Files\7-Zip\7z.exe'
    $msiInstaller = 'C:\Windows\Temp\7zInstaller-x64.msi'

    # 1. Install 7-Zip if not present
    if (-not (Test-Path $sevenZipExe)) {
        (New-Object System.Net.WebClient).DownloadFile('https://www.7-zip.org/a/7z1604-x64.msi', $msiInstaller)
        Start-Process -FilePath 'msiexec.exe' -ArgumentList "/qb /i `"$msiInstaller`"" -Wait
    }

    # 2. Hypervisor specific setup based on PACKER_BUILDER_TYPE
    $builderType = $env:PACKER_BUILDER_TYPE

    switch ($builderType) {
        "vmware-iso" {
            $vmwareIso = 'C:\Windows\Temp\windows.iso'
            $vmwareTar = 'C:\Windows\Temp\vmware-tools.tar'

            if (-not (Test-Path $vmwareIso)) {
                (New-Object System.Net.WebClient).DownloadFile('http://softwareupdate.vmware.com/cds/vmw-desktop/ws/12.0.0/2985596/windows/packages/tools-windows.tar', $vmwareTar)
                & $sevenZipExe x $vmwareTar "-oC:\Windows\Temp" -y | Out-Null
                
                # Locate extracted ISO and rename to windows.iso
                Get-ChildItem -Path 'C:\Windows\Temp' -Filter 'VMware-tools-windows-*.iso' -Recurse | ForEach-Object {
                    Move-Item -Path $_.FullName -Destination $vmwareIso -Force
                }

                if (Test-Path 'C:\Program Files (x86)\VMWare') {
                    Remove-Item -Path 'C:\Program Files (x86)\VMWare' -Recurse -Force
                }
            }

            & $sevenZipExe x $vmwareIso "-oC:\Windows\Temp\VMWare" -y | Out-Null
            Start-Process -FilePath 'C:\Windows\Temp\VMWare\setup.exe' -ArgumentList '/S /v"/qn REBOOT=R"' -Wait
        }

        "virtualbox-iso" {
            $vboxIsoUser = 'C:\Users\vagrant\VBoxGuestAdditions.iso'
            $vboxIsoTemp = 'C:\Windows\Temp\VBoxGuestAdditions.iso'

            if (Test-Path $vboxIsoUser) {
                Move-Item -Path $vboxIsoUser -Destination $vboxIsoTemp -Force
            }

            & $sevenZipExe x $vboxIsoTemp "-oC:\Windows\Temp\virtualbox" -y | Out-Null

            # Import Oracle CA certificate to prevent driver installation prompts
            $vboxCert = 'C:\Windows\Temp\virtualbox\cert\vbox-sha1.cer'
            if (Test-Path $vboxCert) {
                Start-Process -FilePath 'certutil.exe' -ArgumentList "-addstore -f `"TrustedPublisher`" `"$vboxCert`"" -Wait
            }

            Start-Process -FilePath 'C:\Windows\Temp\virtualbox\VBoxWindowsAdditions.exe' -ArgumentList '/S' -Wait
        }

        "parallels-iso" {
            $prlIsoUser = 'C:\Users\vagrant\prl-tools-win.iso'
            $prlIsoTemp = 'C:\Windows\Temp\prl-tools-win.iso'
            $prlExtractDir = 'C:\Windows\Temp\parallels'

            if (Test-Path $prlIsoUser) {
                Move-Item -Path $prlIsoUser -Destination $prlIsoTemp -Force
                & $sevenZipExe x $prlIsoTemp "-o$prlExtractDir" -y | Out-Null
                Start-Process -FilePath "$prlExtractDir\PTAgent.exe" -ArgumentList '/install_silent' -Wait

                if (Test-Path $prlExtractDir) {
                    Remove-Item -Path $prlExtractDir -Recurse -Force
                }
            }
        }
    }

    # 3. Uninstall temporary 7-Zip MSI if installed earlier
    if (Test-Path $msiInstaller) {
        Start-Process -FilePath 'msiexec.exe' -ArgumentList "/qb /x `"$msiInstaller`"" -Wait
        Remove-Item -Path $msiInstaller -Force -ErrorAction SilentlyContinue
    }
}