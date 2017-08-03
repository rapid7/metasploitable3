#
# Cookbook:: metasploitable
# Recipe:: jmx
#
# Copyright:: 2017, The Authors, All Rights Reserved.

directory 'C:\Program Files\jmx' do
  action :create
end

cookbook_file 'C:\Program Files\jmx\Hello.class' do
  source 'jmx\Hello.class'
  action :create
end

cookbook_file 'C:\Program Files\jmx\HelloMBean.class' do
  source 'jmx\HelloMBean.class'
  action :create
end

cookbook_file 'C:\Program Files\jmx\SimpleAgent.class' do
  source 'jmx\SimpleAgent.class'
  action :create
end

cookbook_file 'C:\Program Files\jmx\jmx.exe' do
  source 'jmx\jmx.exe'
  action :create
end

cookbook_file 'C:\Program Files\jmx\start_jmx.bat' do
  source 'jmx\start_jmx.bat'
  action :create
end

execute 'Install JMX' do
  command '"%ProgramFiles%\jmx\jmx.exe" -Service Install'
end

windows_service 'jmx' do
  action [:enable, :start]
  startup_type :automatic
end

execute 'Configure permissions' do
  command 'cacls "C:\Program Files\jmx" /t /e /g Everyone:f'
end
