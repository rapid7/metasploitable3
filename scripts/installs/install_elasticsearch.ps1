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
    # 1. Ignore SSL errors & enable TLS 1.2
    [System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12

    # Paths
    $zipUrl      = 'https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-1.1.1.zip'
    $zipPath     = 'C:\Windows\Temp\elasticsearch-1.1.1.zip'
    $programFiles = 'C:\Program Files'
    $esBinPath   = 'C:\Program Files\elasticsearch-1.1.1\bin'
    $sevenZip    = 'C:\Program Files\7-Zip\7z.exe'

    # 2. Download Elasticsearch
    (New-Object System.Net.WebClient).DownloadFile($zipUrl, $zipPath)

    # 3. Extract Archive
    if (Test-Path $sevenZip) {
        & $sevenZip x $zipPath "-o$programFiles" -y | Out-Null
    } else {
        Expand-Archive -Path $zipPath -DestinationPath $programFiles -Force
    }

    # Clean up zip
    if (Test-Path $zipPath) {
        Remove-Item -Path $zipPath -Force
    }

    # 4. Install and Start Service
    cmd /c "`"$esBinPath\service.bat`" install"
    sc.exe config "elasticsearch-service-x64" start= auto
    cmd /c "`"$esBinPath\service.bat`" start"

    # 5. Wait for service boot
    Start-Sleep -Seconds 30

    # 6. Create index via PUT request
    $reqIndex = [System.Net.HttpWebRequest]::Create('http://localhost:9200/metasploitable3/')
    $reqIndex.Method = 'PUT'
    $responseIndex = $reqIndex.GetResponse()
    $responseIndex.Close()

    # 7. Insert test document via PUT request
    $jsonPayload = '{"user":"kimchy", "post_date": "2009-11-15T14:12:12", "message": "Elasticsearch" }'
    $body = [System.Text.Encoding]::ASCII.GetBytes($jsonPayload)

    $reqDoc = [System.Net.HttpWebRequest]::Create('http://localhost:9200/metasploitable3/message/1')
    $reqDoc.Method = 'PUT'
    $reqDoc.ContentType = 'application/x-www-form-urlencoded'
    $reqDoc.ContentLength = $body.Length

    $stream = $reqDoc.GetRequestStream()
    $stream.Write($body, 0, $body.Length)
    $stream.Close()

    $responseDoc = $reqDoc.GetResponse()
    $responseDoc.Close()
}