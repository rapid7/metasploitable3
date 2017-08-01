#
# Cookbook:: metasploitable
# Recipe:: elasticsearch
#
# Copyright:: 2017, The Authors, All Rights Reserved.

powershell_script 'Download ElasticSearch' do
  code '(New-Object System.Net.WebClient).DownloadFile(\'http://repo1.maven.org/maven2/org/elasticsearch/elasticsearch/1.1.1/elasticsearch-1.1.1.zip\', \'C:\Windows\Temp\elasticsearch-1.1.1.zip\')'
end

execute 'Extracting files' do
  command '"C:\Program Files\7-Zip\7z.exe" x "C:\Windows\Temp\elasticsearch-1.1.1.zip" -o"C:\Program Files\"'
  action :run
end

execute 'Install ElasticSearch' do
  command '"C:\Program Files\elasticsearch-1.1.1\bin\service.bat" install'
  action :run
end

windows_service 'elasticsearch-service-x86' do
  action :enable
  startup_type :automatic
end

execute 'Starting service' do
  command '"C:\Program Files\elasticsearch-1.1.1\bin\service.bat" start'
  action :run
end

powershell_script 'Sleep 30 secs' do
  code 'Start-Sleep -s 30'
end

windows_service 'elasticsearch-service-x86' do
  action :start
end

powershell_script 'Test response' do
  code '$req = [System.Net.HttpWebRequest]::Create(\'http://localhost:9200/metasploitable3/\'); $req.method = \'PUT\'; $req.GetResponse()'
end

powershell_script 'Test' do
  code 'powershell -Command "$body = [System.Text.Encoding]::ASCII.GetBytes(\'{\"user\":\"kimchy\", \"post_date\": \"2009-11-15T14:12:12\", \"message\": \"Elasticsearch\" }\'); $req = [System.Net.HttpWebRequest]::Create(\'http://localhost:9200/metasploitable3/message/1\'); $req.method = \'PUT\'; $req.ContentType = \'application/x-www-form-urlencoded\'; $stream = $req.GetRequestStream(); $stream.Write($body, 0, $body.Length); $stream.close(); $req.GetResponse()"'
end

