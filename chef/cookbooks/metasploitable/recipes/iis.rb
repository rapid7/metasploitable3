#
# Cookbook:: metasploitable
# Recipe:: iis
#
# Copyright:: 2017, The Authors, All Rights Reserved.

batch 'Install_IIS' do
  code 'start /w PKGMGR.EXE /quiet /norestart /iu:IIS-WebServerRole;IIS-WebServer;IIS-CommonHttpFeatures;IIS-ApplicationDevelopment;IIS-ASPNET;IIS-NetFxExtensibility;IIS-ASP;IIS-CGI;IIS-ISAPIExtensions;IIS-ISAPIFilter;IIS-ServerSideIncludes;IIS-FTPServer;IIS-FTPSvc;IIS-FTPExtensibility;'
end

execute 'Update firewall rule' do
  command 'netsh advfirewall firewall add rule name="Open Port 80 for IIS" dir=in action=allow protocol=TCP localport=80'
  action :run
end