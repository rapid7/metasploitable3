#
# Cookbook:: metasploitable
# Recipe:: openjdk6
#
# Copyright:: 2017, The Authors, All Rights Reserved.

include_recipe 'metasploitable::7zip'

powershell_script 'Download OpenJDK' do
  code '(New-Object System.Net.WebClient).DownloadFile(\'https://github.com/downloads/alexkasko/openjdk-unofficial-builds/openjdk-1.6.0-unofficial-b27-windows-amd64.zip\', \'C:\Windows\Temp\openjdk-1.6.0-unofficial-b27-windows-amd64.zip\')'
end

batch 'Install OpenJDK' do
  code '"C:\Program Files\7-Zip\7z.exe" x "C:\Windows\Temp\openjdk-1.6.0-unofficial-b27-windows-amd64.zip" -oC:\openjdk6"'
end

