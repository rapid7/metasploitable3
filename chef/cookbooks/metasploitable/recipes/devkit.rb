#
# Cookbook:: metasploitable
# Recipe:: devkit
#
# Copyright:: 2017, The Authors, All Rights Reserved.

directory 'C:\Program Files\Rails_Server' do
  action :create
end

directory 'C:\Program Files\Rails_Server\devkit' do
  action :create
end

powershell_script "Download DevKit" do
  code "(New-Object System.Net.WebClient).DownloadFile('http://dl.bintray.com/oneclick/rubyinstaller/DevKit-mingw64-64-4.7.2-20130224-1432-sfx.exe', 'C:\\Program Files\\Rails_Server\\devkit\\devkit.exe')"
end

batch 'Extract DevKit' do
  code '"C:\Program Files\7-Zip\7z.exe" x "C:\Program Files\Rails_Server\devkit\devkit.exe" -o"C:\Program Files\Rails_Server\devkit\"'
end

cookbook_file 'C:\Program Files\Rails_Server\devkit\dk.rb' do
  source 'rails_server/devkit/dk.rb'
  action :create
end

batch 'Install DevKit' do
  code <<-EOH    
    C:\\tools\\ruby23\\bin\\ruby.exe "C:\\Program Files\\Rails_Server\\devkit\\dk.rb" init
    C:\\tools\\ruby23\\bin\\ruby.exe "C:\\Program Files\\Rails_Server\\devkit\\dk.rb" install
    "C:\\Program Files\\Rails_Server\\devkit\\devkitvars.bat"
  EOH
end
