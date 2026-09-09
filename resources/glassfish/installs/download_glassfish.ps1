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
    (New-Object System.Net.WebClient).DownloadFile('http://download.java.net/glassfish/4.0/release/glassfish-4.0.zip', 'C:\Windows\Temp\glassfish4.zip')
}
