# an config

mysql_config 'hello' do
  instance 'default'
  source 'hello.conf.erb'
  version node['mysql']['version']
  action :create
end

mysql_config 'hello_again' do
  instance 'foo'
  source 'hello.conf.erb'
  version node['mysql']['version']
  action :create
end
