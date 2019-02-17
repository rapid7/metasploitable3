######################
# :install and :update
######################

sshfs_caps = [
  {
    'Name' => 'network',
    'Value' => ['host'],
  },
  {
    'Name' => 'mount',
    'Value' => ['/var/lib/docker/plugins/'],
  },
  {
    'Name' => 'mount',
    'Value' => [''],
  },
  {
    'Name' => 'device',
    'Value' => ['/dev/fuse'],
  },
  {
    'Name' => 'capabilities',
    'Value' => ['CAP_SYS_ADMIN'],
  },
]

docker_plugin 'vieux/sshfs' do
  grant_privileges sshfs_caps
end

docker_plugin 'configure vieux/sshfs' do
  action :update
  local_alias 'vieux/sshfs'
  options(
    'DEBUG' => '1'
  )
end

docker_plugin 'remove vieux/sshfs' do
  local_alias 'vieux/sshfs'
  action :remove
end

#######################
# :install with options
#######################

docker_plugin 'rbd' do
  remote 'wetopi/rbd'
  remote_tag '1.0.1'
  grant_privileges true
  options(
    'LOG_LEVEL' => '4'
  )
end

docker_plugin 'remove rbd' do
  local_alias 'rbd'
  action :remove
end

#######################################
# :install twice (should be idempotent)
#######################################

docker_plugin 'sshfs 2.1' do
  local_alias 'sshfs'
  remote 'vieux/sshfs'
  remote_tag 'latest'
  grant_privileges true
end

docker_plugin 'sshfs 2.2' do
  local_alias 'sshfs'
  remote 'vieux/sshfs'
  remote_tag 'latest'
  grant_privileges true
end

docker_plugin 'enable sshfs' do
  local_alias 'sshfs'
  action :enable
end

docker_plugin 'disable sshfs' do
  local_alias 'sshfs'
  action :disable
end

docker_plugin 'remove sshfs again' do
  local_alias 'sshfs'
  action :remove
end
