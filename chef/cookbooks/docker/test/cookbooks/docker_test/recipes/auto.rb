################
# Docker service
################

docker_service 'default' do
  host 'unix:///var/run/docker.sock'
  install_method 'auto'
  service_manager 'auto'
  action [:create, :start]
end

docker_image 'alpine' do
  action :pull
end

docker_container 'an_echo_server' do
  repo 'alpine'
  command 'nc -ll -p 7 -e /bin/cat'
  port '7:7'
  action :run
end
