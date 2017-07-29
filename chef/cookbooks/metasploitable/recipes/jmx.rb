#
# Cookbook:: metasploitable
# Recipe:: jmx
#
# Copyright:: 2017, The Authors, All Rights Reserved.

directory 'C:\Program Files\jmx' do
  action :create
end

batch 'Copy required files' do
  code <<-EOH
    copy C:\\vagrant\\resources\\jmx\\Hello.class "%ProgramFiles%\\jmx"
    copy C:\\vagrant\\resources\\jmx\\HelloMBean.class "%ProgramFiles%\\jmx"
    copy C:\\vagrant\\resources\\jmx\\SimpleAgent.class "%ProgramFiles%\\jmx"
    copy C:\\vagrant\\resources\\jmx\\jmx.exe "%ProgramFiles%\\jmx"
    copy C:\\vagrant\\resources\\jmx\\start_jmx.bat "%ProgramFiles%\\jmx"
  EOH
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
