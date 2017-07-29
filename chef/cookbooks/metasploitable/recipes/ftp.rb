#
# Cookbook:: metasploitable
# Recipe:: ftp
#
# Copyright:: 2017, The Authors, All Rights Reserved.

batch 'Copy FTP Configuration' do
  code 'xcopy /I /Y C:\vagrant\resources\iis\applicationHost.config %SystemRoot%\System32\inetsrv\config\'
end
