powershell -Command "(New-Object System.Net.WebClient).DownloadFile('http://repo1.maven.org/maven2/org/elasticsearch/elasticsearch/1.1.1/elasticsearch-1.1.1.zip', 'C:\Windows\Temp\elasticsearch-1.1.1.zip')" <NUL
cmd /c ""C:\Program Files\7-Zip\7z.exe" x "C:\Windows\Temp\elasticsearch-1.1.1.zip" -o"C:\Program Files\""
cmd /c ""C:\Program Files\elasticsearch-1.1.1\bin\service.bat" install"
sc config "elasticsearch-service-x64" start= auto
cmd /c ""C:\Program Files\elasticsearch-1.1.1\bin\service.bat" start"
powershell -Command "Start-Sleep -s 30"
powershell -Command "$req = [System.Net.HttpWebRequest]::Create('http://localhost:9200/metasploitable3/'); $req.method = 'PUT'; $req.GetResponse()"
powershell -Command "$body = [System.Text.Encoding]::ASCII.GetBytes('{\"user\":\"kimchy\", \"post_date\": \"2009-11-15T14:12:12\", \"message\": \"Elasticsearch\" }'); $req = [System.Net.HttpWebRequest]::Create('http://localhost:9200/metasploitable3/message/1'); $req.method = 'PUT'; $req.ContentType = 'application/x-www-form-urlencoded'; $stream = $req.GetRequestStream(); $stream.Write($body, 0, $body.Length); $stream.close(); $req.GetResponse()"

