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
    # 1. SSL/TLS Configurations
    [System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12

    # Paths
    $exeUrl  = 'https://metasploitable-binaries.s3.amazonaws.com/metasploitable3/ManageEngine_DesktopCentral.exe'
    $exePath = 'C:\Windows\Temp\ManageEngine_DesktopCentral.exe'
    $issPath = 'C:\Vagrant\resources\manageengine\setup.iss'

    # 2. Download ManageEngine Executable
    (New-Object System.Net.WebClient).DownloadFile($exeUrl, $exePath)

    # 3. Silent Installation (Waits for process completion)
    $setupArgs = "/w /s /f1`"$issPath`""
    Start-Process -FilePath $exePath -ArgumentList $setupArgs -Wait -NoNewWindow

    # 4. Stop ManageEngine Services
    Stop-Service -Name "ManageEngine Desktop Central Server" -Force -ErrorAction SilentlyContinue
    Stop-Service -Name "MEDC Server Component - Apache" -Force -ErrorAction SilentlyContinue
    Stop-Service -Name "MEDC Server Component - Notification Server" -Force -ErrorAction SilentlyContinue

    # 5. Grant Permissions to LOCAL SERVICE
    icacls "C:\ManageEngine" /grant "NT Authority\LOCAL SERVICE:(OI)(CI)F" /T

    # 6. Reconfigure Services to run as LOCAL SERVICE
    sc.exe config "DesktopCentralServer" obj= "NT Authority\LOCAL SERVICE" type= own start= auto
    sc.exe config "MEDC Server Component - Notification Server" obj= "NT Authority\LOCAL SERVICE" type= own start= auto
    sc.exe config "MEDCServerComponent-Apache" obj= "NT Authority\LOCAL SERVICE" type= own start= auto

    # 7. Start Services
    Start-Service -Name "MEDC Server Component - Apache"
    Start-Service -Name "MEDC Server Component - Notification Server"
    Start-Service -Name "ManageEngine Desktop Central Server"

    # Cleanup Installer
    if (Test-Path $exePath) {
        Remove-Item -Path $exePath -Force
    }
}