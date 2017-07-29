#
# Cookbook:: metasploitable
# Recipe:: iis
#
# Copyright:: 2017, The Authors, All Rights Reserved.

batch 'Install_IIS' do
  code 'start /w PKGMGR.EXE /quiet /norestart /iu:IIS-WebServerRole;IIS-WebServer;IIS-CommonHttpFeatures;IIS-ApplicationDevelopment;IIS-ASPNET;IIS-NetFxExtensibility;IIS-ASP;IIS-CGI;IIS-ISAPIExtensions;IIS-ISAPIFilter;IIS-ServerSideIncludes;IIS-FTPServer;IIS-FTPSvc;IIS-FTPExtensibility;'
end