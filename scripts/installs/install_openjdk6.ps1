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
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    
    $zipUrl = 'https://bitbucket.org/alexkasko/openjdk-unofficial-builds/downloads/openjdk-1.6.0-unofficial-b28-windows-amd64-installer.zip'
    $zipPath = 'C:\Windows\Temp\openjdk-1.6.0-unofficial-b28-windows-amd64-installer.zip'
    $extractPath = 'C:\openjdk6'
    $sevenZip = 'C:\Program Files\7-Zip\7z.exe'

    (New-Object System.Net.WebClient).DownloadFile($zipUrl, $zipPath)

    if (Test-Path $sevenZip) {
        & $sevenZip x $zipPath "-o$extractPath" -y | Out-Null
    } else {
        Expand-Archive -Path $zipPath -DestinationPath $extractPath -Force
    }

    if (Test-Path $zipPath) {
        Remove-Item -Path $zipPath -Force
    }
}