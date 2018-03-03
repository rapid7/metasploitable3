#
# Cookbook:: metasploitable
# Recipe:: devkit
#
# Copyright:: 2017, The Authors, All Rights Reserved.

include_recipe 'metasploitable::7zip'
include_recipe 'metasploitable::ruby'

directory 'C:\RubyDevKit' do
  action :create
end

remote_file 'C:\RubyDevKit\devkit.exe' do
  source 'http://dl.bintray.com/oneclick/rubyinstaller/DevKit-mingw64-64-4.7.2-20130224-1432-sfx.exe'
  action :create
end

batch 'Extract DevKit' do
  code '"C:\Program Files\7-Zip\7z.exe" x "C:\RubyDevKit\devkit.exe" -o"C:\RubyDevKit\"'
end

cookbook_file 'C:\RubyDevKit\dk.rb' do
  source 'rails_server/devkit/dk.rb'
  action :create
end

batch 'Install DevKit' do
  code <<-EOH    
    C:\\tools\\ruby23\\bin\\ruby.exe "C:\\RubyDevKit\\dk.rb" init
    C:\\tools\\ruby23\\bin\\ruby.exe "C:\\RubyDevKit\\dk.rb" install
    "C:\\RubyDevKit\\devkitvars.bat"
  EOH
end
