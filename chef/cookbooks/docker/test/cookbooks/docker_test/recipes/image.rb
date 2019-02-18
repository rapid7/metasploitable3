# Two variables, one recipe.
caname = 'docker_service_default'
caroot = "/ca/#{caname}"

#########################
# :pull_if_missing, :pull
#########################

# default action, default properties
docker_image 'hello-world'

# non-default name attribute, containing a single quote
docker_image "Tom's container" do
  repo 'tduffield/testcontainerd'
end

# :pull action specified
docker_image 'busybox' do
  action :pull
end

# :pull_if_missing
docker_image 'debian' do
  action :pull_if_missing
end

# specify a tag and read/write timeouts
docker_image 'alpine' do
  tag '3.1'
  read_timeout 60
  write_timeout 60
end

# host override
docker_image 'alpine-localhost' do
  repo 'alpine'
  tag '2.7'
  host 'tcp://127.0.0.1:2376'
  tls_verify true
  tls_ca_cert "#{caroot}/ca.pem"
  tls_client_cert "#{caroot}/cert.pem"
  tls_client_key "#{caroot}/key.pem"
end

#########
# :remove
#########

# install something so it can be used to test the :remove action
execute 'pull vbatts/slackware' do
  command 'docker pull vbatts/slackware ; touch /marker_image_slackware'
  creates '/marker_image_slackware'
  action :run
end

docker_image 'vbatts/slackware' do
  action :remove
end

########
# :save
########

docker_image 'save hello-world' do
  repo 'hello-world'
  destination '/hello-world.tar'
  not_if { ::File.exist?('/hello-world.tar') }
  action :save
end

########
# :load
########

docker_image 'cirros' do
  action :pull
  not_if { ::File.exist?('/marker_load_cirros-1') }
end

docker_image 'save cirros' do
  repo 'cirros'
  destination '/cirros.tar'
  not_if { ::File.exist?('/cirros.tar') }
  action :save
end

docker_image 'remove cirros' do
  repo 'cirros'
  not_if { ::File.exist?('/marker_load_cirros-1') }
  action :remove
end

docker_image 'load cirros' do
  source '/cirros.tar'
  not_if { ::File.exist?('/marker_load_cirros-1') }
  action :load
end

file '/marker_load_cirros-1' do
  action :create
end

###########################
# :build
###########################

# Build from a Dockerfile
directory '/usr/local/src/container1' do
  action :create
end

cookbook_file '/usr/local/src/container1/Dockerfile' do
  source 'Dockerfile_1'
  action :create
end

docker_image 'someara/image-1' do
  tag 'v0.1.0'
  source '/usr/local/src/container1/Dockerfile'
  force true
  not_if { ::File.exist?('/marker_image_image-1') }
  action :build
end

file '/marker_image_image-1' do
  action :create
end

# Build from a directory
directory '/usr/local/src/container2' do
  action :create
end

file '/usr/local/src/container2/foo.txt' do
  content 'Dockerfile_2 contains ADD for this file'
  action :create
end

cookbook_file '/usr/local/src/container2/Dockerfile' do
  source 'Dockerfile_2'
  action :create
end

docker_image 'someara/image.2' do
  tag 'v0.1.0'
  source '/usr/local/src/container2'
  action :build_if_missing
end

# Build from a tarball
cookbook_file '/usr/local/src/image_3.tar' do
  source 'image_3.tar'
  action :create
end

docker_image 'image_3' do
  tag 'v0.1.0'
  source '/usr/local/src/image_3.tar'
  action :build_if_missing
end

#########
# :import
#########

docker_image 'hello-again' do
  tag 'v0.1.0'
  source '/hello-world.tar'
  action :import
end

################
# :tag and :push
################

######################
# This commented out section was manually tested by replacing the
# authentication creds with real live Dockerhub creds.
#####################

# docker_registry 'https://index.docker.io/v1/' do
#   username 'youthere'
#   password 'p4sswh1rr3d'
#   email 'youthere@computers.biz'
# end

# # name-w-dashes
# docker_tag 'public dockerhub someara/name-w-dashes:v1.0.1' do
#   target_repo 'hello-again'
#   target_tag 'v0.1.0'
#   to_repo 'someara/name-w-dashes'
#   to_tag 'latest'
#   action :tag
# end

# docker_image 'push someara/name-w-dashes' do
#   repo 'someara/name-w-dashes'
#   not_if { ::File.exist?('/marker_image_public_name-w-dashes') }
#   action :push
# end

# file '/marker_image_public_name-w-dashes' do
#   action :create
# end

# # name.w.dots
# docker_tag 'public dockerhub someara/name.w.dots:latest' do
#   target_repo 'busybox'
#   target_tag 'latest'
#   to_repo 'someara/name.w.dots'
#   to_tag 'latest'
#   action :tag
# end

# docker_image 'push someara/name.w.dots' do
#   repo 'someara/name.w.dots'
#   not_if { ::File.exist?('/marker_image_public_name.w.dots') }
#   action :push
# end

# file '/marker_image_public_name.w.dots' do
#   action :create
# end

# # private-repo-test
# docker_tag 'public dockerhub someara/private-repo-test:v1.0.1' do
#   target_repo 'hello-world'
#   target_tag 'latest'
#   to_repo 'someara/private-repo-test'
#   to_tag 'latest'
#   action :tag
# end

# docker_image 'push someara/private-repo-test' do
#   repo 'someara/private-repo-test'
#   not_if { ::File.exist?('/marker_image_public_private-repo-test') }
#   action :push
# end

# file '/marker_image_public_private-repo-test' do
#   action :create
# end

# docker_image 'someara/private-repo-test'

# public images
docker_image 'someara/name-w-dashes'
docker_image 'someara/name.w.dots'

##################
# Private registry
##################

include_recipe 'docker_test::registry'

# for pushing to private repo
docker_tag 'private repo tag for name-w-dashes:v1.0.1' do
  target_repo 'hello-again'
  target_tag 'v0.1.0'
  to_repo 'localhost:5043/someara/name-w-dashes'
  to_tag 'latest'
  action :tag
end

# for pushing to private repo
docker_tag 'private repo tag for name.w.dots' do
  target_repo 'busybox'
  target_tag 'latest'
  to_repo 'localhost:5043/someara/name.w.dots'
  to_tag 'latest'
  action :tag
end

docker_tag 'private repo tag for name.w.dots v0.1.0' do
  target_repo 'busybox'
  target_tag 'latest'
  to_repo 'localhost:5043/someara/name.w.dots'
  to_tag 'v0.1.0'
  action :tag
end

docker_registry 'localhost:5043' do
  username 'testuser'
  password 'testpassword'
  email 'alice@computers.biz'
end

docker_image 'localhost:5043/someara/name-w-dashes' do
  not_if { ::File.exist?('/marker_image_private_name-w-dashes') }
  action :push
end

file '/marker_image_private_name-w-dashes' do
  action :create
end

docker_image 'localhost:5043/someara/name.w.dots' do
  not_if { ::File.exist?('/marker_image_private_name.w.dots') }
  action :push
end

docker_image 'localhost:5043/someara/name.w.dots' do
  not_if { ::File.exist?('/marker_image_private_name.w.dots') }
  tag 'v0.1.0'
  action :push
end

file '/marker_image_private_name.w.dots' do
  action :create
end

# Pull from the public Dockerhub after being authenticated to a
# private one

docker_image 'fedora' do
  action :pull
end
