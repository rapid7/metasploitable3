#
# Cookbook:: metasploitable
# Recipe:: backdoors
#
# Copyright:: 2017, The Authors, All Rights Reserved.

file 'C:\inetpub\wwwroot\caidao.asp' do
  content IO.read('C:\vagrant\resources\backdoors\caidao.asp')
  action :create
end

file 'C:\wamp\www\mma.php' do
  content IO.read('C:\vagrant\resources\backdoors\mma.php')
  action :create
end

file 'C:\wamp\www\meterpreter.php' do
  content IO.read('C:\vagrant\resources\backdoors\meterpreter.php')
  action :create
end
