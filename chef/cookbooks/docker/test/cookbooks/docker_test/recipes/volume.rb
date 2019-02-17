###########
# remove_me
###########

execute 'docker volume create --name remove_me' do
  not_if { ::File.exist?('/marker_remove_me') }
  action :run
end

file '/marker_remove_me' do
  action :create
end

docker_volume 'remove_me' do
  action :remove
end

#######
# hello
#######

docker_volume 'hello' do
  action :create
end

docker_volume 'hello again' do
  volume_name 'hello_again'
  action :create
end

##################
# hello containers
##################

docker_image 'alpine' do
  tag '3.1'
  action :pull_if_missing
end

docker_container 'file_writer' do
  repo 'alpine'
  tag '3.1'
  volumes ['hello:/hello']
  command 'touch /hello/sean_was_here'
  action :run_if_missing
end

docker_container 'file_reader' do
  repo 'alpine'
  tag '3.1'
  volumes ['hello:/hello']
  command 'ls /hello/sean_was_here'
  action :run_if_missing
end
