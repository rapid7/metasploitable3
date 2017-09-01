#
# Cookbook:: metasploitable
# Recipe:: elasticsearch
#
# Copyright:: 2017, The Authors, All Rights Reserved.

include_recipe 'metasploitable::7zip'
include_recipe 'metasploitable::jdk8'

remote_file 'C:\Windows\Temp\elasticsearch-1.1.1.zip' do
  source 'http://repo1.maven.org/maven2/org/elasticsearch/elasticsearch/1.1.1/elasticsearch-1.1.1.zip'
  action :create
end

execute 'Extracting files' do
  command '"C:\Program Files\7-Zip\7z.exe" x "C:\Windows\Temp\elasticsearch-1.1.1.zip" -o"C:\Program Files\"'
  action :run
end

execute 'Install ElasticSearch' do
  command '"C:\Program Files\elasticsearch-1.1.1\bin\service.bat" install'
  environment ({"JAVA_HOME" => "C:\\Program Files\\Java\\jdk1.8.0_144"})
  only_if { ::File.exist?('C:\Program Files\Java\jdk1.8.0_144\bin\java.exe') }
  action :run
end

windows_service 'elasticsearch-service-x64' do
  action :enable
  startup_type :automatic
end

execute 'Starting service' do
  command '"C:\Program Files\elasticsearch-1.1.1\bin\service.bat" start'
  action :run
end

ruby_block 'Sleep for 30 secs' do
  block do
    sleep(30)
  end
  action :run
end

windows_service 'elasticsearch-service-x64' do
  action :start
end

ruby_block 'Sleep for 15 secs' do
  block do
    sleep(15)
  end
  action :run
end

powershell_script 'Test response' do
  code "$req = [System.Net.HttpWebRequest]::Create('http://localhost:9200/metasploitable3/'); $req.method = 'PUT'; $req.GetResponse()"
end

ruby_block 'Sleep for 15 secs' do
  block do
    sleep(15)
  end
  action :run
end

powershell_script 'Test' do
  code "$body = [System.Text.Encoding]::ASCII.GetBytes('{\"user\":\"kimchy\", \"post_date\": \"2009-11-15T14:12:12\", \"message\": \"Elasticsearch\" }'); $req = [System.Net.HttpWebRequest]::Create('http://localhost:9200/metasploitable3/message/1'); $req.method = 'PUT'; $req.ContentType = 'application/x-www-form-urlencoded'; $stream = $req.GetRequestStream(); $stream.Write($body, 0, $body.Length); $stream.close(); $req.GetResponse()"
end
