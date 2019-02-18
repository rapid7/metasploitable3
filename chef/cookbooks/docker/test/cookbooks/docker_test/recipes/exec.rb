docker_image 'busybox' do
  action :pull_if_missing
end

docker_container 'busybox_exec' do
  repo 'busybox'
  command 'sh -c "trap exit 0 SIGTERM; while :; do sleep 1; done"'
end

docker_exec 'touch_it' do
  container 'busybox_exec'
  command ['touch', '/tmp/onefile']
  timeout 120
  not_if { ::File.exist?('/marker_busybox_exec_onefile') }
end

file '/marker_busybox_exec_onefile'

docker_exec 'poke_it' do
  container 'busybox_exec'
  cmd ['touch', '/tmp/twofile']
  not_if { ::File.exist?('/marker_busybox_exec_twofile') }
end

file '/marker_busybox_exec_twofile'
