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
    # 1. Force TLS 1.2
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    # Paths
    $zipUrl    = 'https://archive.apache.org/dist/axis/axis2/java/core/1.6.0/axis2-1.6.0-war.zip'
    $zipPath   = 'C:\Windows\Temp\axis2-1.6.0-war.zip'
    $extractDir = 'C:\axis2'
    $sevenZip  = 'C:\Program Files\7-Zip\7z.exe'
    
    # Resolve %CATALINA_HOME%\webapps target directory
    $catalinaHome = $env:CATALINA_HOME
    $webappsDir   = "$catalinaHome\webapps"

    # 2. Download Axis2 Zip
    (New-Object System.Net.WebClient).DownloadFile($zipUrl, $zipPath)

    # 3. Extract Archive
    if (Test-Path $sevenZip) {
        & $sevenZip x $zipPath "-o$extractDir" -y | Out-Null
    } else {
        Expand-Archive -Path $zipPath -DestinationPath $extractDir -Force
    }

    # 4. Copy WAR file to Tomcat webapps directory
    if (Test-Path "$extractDir\axis2.war") {
        Copy-Item -Path "$extractDir\axis2.war" -Destination $webappsDir -Force
    }

    # 5. Cleanup Temporary Files and Extraction Folder
    if (Test-Path $zipPath) {
        Remove-Item -Path $zipPath -Force
    }
    if (Test-Path $extractDir) {
        Remove-Item -Path $extractDir -Recurse -Force
    }
}