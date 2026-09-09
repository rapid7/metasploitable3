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

    $devkitDir = 'C:\RubyDevKit'
    $exePath   = 'C:\RubyDevKit\devkit.exe'
    $downloadUrl = 'https://github.com/rapid7/metasploit-omnibus-cache/raw/7cad45e5886d0a9b3d587c86a65d66234986223a/DevKit-mingw64-64-4.7.2-20130224-1432-sfx.exe'
    $sevenZip  = 'C:\Program Files\7-Zip\7z.exe'

    # 1. Create Directory
    if (-not (Test-Path $devkitDir)) {
        New-Item -ItemType Directory -Path $devkitDir -Force | Out-Null
    }

    # 2. Download DevKit Archive
    (New-Object System.Net.WebClient).DownloadFile($downloadUrl, $exePath)

    # 3. Extract Archive
    if (Test-Path $sevenZip) {
        & $sevenZip x $exePath "-o$devkitDir" -y | Out-Null
    } else {
        # Fallback if 7z isn't installed (self-extracting EXE can unpack itself directly)
        Start-Process -FilePath $exePath -ArgumentList "-o`"$devkitDir`" -y" -Wait -NoNewWindow
    }

    # 4. Copy custom dk.rb configuration script
    Copy-Item -Path 'C:\Vagrant\resources\Rails_Server\devkit\dk.rb' -Destination $devkitDir -Force

    # 5. Initialize & Install DevKit via Ruby
    $rubyExe = 'C:\tools\ruby23\bin\ruby.exe'
    & $rubyExe "$devkitDir\dk.rb" init
    & $rubyExe "$devkitDir\dk.rb" install

    # 6. Call devkitvars.bat to load environment variables into the process session
    cmd /c "$devkitDir\devkitvars.bat"
}