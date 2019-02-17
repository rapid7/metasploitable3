volumes_filter = '{{ .Config.Volumes }}'
mounts_filter = '{{ .Mounts }}'
uber_options_network_mode = 'bridge'

##################################################
#  test/cookbooks/docker_test/recipes/default.rb
##################################################

# docker_service[default]

describe docker.version do
  its('Server.Version') { should eq '18.06.0-ce' }
end

describe command('docker info') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/environment=/) }
  its(:stdout) { should match(/foo=/) }
end

##############################################
#  test/cookbooks/docker_test/recipes/image.rb
##############################################

# test/cookbooks/docker_test/recipes/image.rb

# docker_image[hello-world]

describe docker_image('hello-world:latest') do
  it { should exist }
  its('repo') { should eq 'hello-world' }
  its('tag') { should eq 'latest' }
end

# docker_image[Tom's container]

describe docker_image('tduffield/testcontainerd:latest') do
  it { should exist }
  its('repo') { should eq 'tduffield/testcontainerd' }
  its('tag') { should eq 'latest' }
end

# docker_image[busybox]

describe docker_image('busybox:latest') do
  it { should exist }
  its('repo') { should eq 'busybox' }
  its('tag') { should eq 'latest' }
end

# docker_image[alpine]

describe docker_image('alpine:3.1') do
  it { should exist }
  its('repo') { should eq 'alpine' }
  its('tag') { should eq '3.1' }
end

describe docker_image('alpine:2.7') do
  it { should exist }
  its('repo') { should eq 'alpine' }
  its('tag') { should eq '2.7' }
end

# docker_image[vbatts/slackware]

describe docker_image('vbatts/slackware:latest') do
  it { should_not exist }
  its('repo') { should_not eq 'vbatts/slackware' }
  its('tag') { should_not eq 'latest' }
end
# docker_image[save cirros]

describe file('/cirros.tar') do
  it { should be_file }
  its('mode') { should cmp '0644' }
end

# docker_image[load cirros]

describe docker_image('cirros:latest') do
  it { should exist }
  its('repo') { should eq 'cirros' }
  its('tag') { should eq 'latest' }
end

# docker_image[someara/image-1]

describe docker_image('someara/image-1:v0.1.0') do
  it { should exist }
  its('repo') { should eq 'someara/image-1' }
  its('tag') { should eq 'v0.1.0' }
end

# docker_image[someara/image.2]

describe docker_image('someara/image.2:v0.1.0') do
  it { should exist }
  its('repo') { should eq 'someara/image.2' }
  its('tag') { should eq 'v0.1.0' }
end

# docker_image[image_3]

describe docker_image('image_3:v0.1.0') do
  it { should exist }
  its('repo') { should eq 'image_3' }
  its('tag') { should eq 'v0.1.0' }
end

# docker_image[name-w-dashes]

describe docker_image('localhost:5043/someara/name-w-dashes:latest') do
  it { should exist }
  its('repo') { should eq 'localhost:5043/someara/name-w-dashes' }
  its('tag') { should eq 'latest' }
end

# docker_tag[private repo tag for name.w.dots:latest / v0.1.0 / / v0.1.1 /]

describe docker_image('localhost:5043/someara/name.w.dots:latest') do
  it { should exist }
  its('repo') { should eq 'localhost:5043/someara/name.w.dots' }
  its('tag') { should eq 'latest' }
end

describe docker_image('localhost:5043/someara/name.w.dots:v0.1.0') do
  it { should exist }
  its('repo') { should eq 'localhost:5043/someara/name.w.dots' }
  its('tag') { should eq 'v0.1.0' }
end

# FIXME: We need to test the "docker_registry" stuff...
# I can't figure out how to search the local registry to see if the
# authentication and :push actions in the test recipe actually worked.
#
# Skipping for now.

##################################################
#  test/cookbooks/docker_test/recipes/container.rb
##################################################

# docker_container[hello-world]

describe docker_container('hello-world') do
  it { should exist }
  it { should_not be_running }
end

# docker_container[busybox_ls]

describe docker_container('busybox_ls') do
  it { should exist }
  it { should_not be_running }
end

# docker_container[alpine_ls]

describe docker_container('alpine_ls') do
  it { should exist }
  it { should_not be_running }
end

# docker_container[an_echo_server]

describe docker_container('an_echo_server') do
  it { should exist }
  it { should be_running }
  its('ports') { should eq '0.0.0.0:7->7/tcp' }
end

# docker_container[another_echo_server]

describe docker_container('another_echo_server') do
  it { should exist }
  it { should be_running }
  its('ports') { should eq '0.0.0.0:32768->7/tcp' }
end

# docker_container[an_udp_echo_server]

describe docker_container('an_udp_echo_server') do
  it { should exist }
  it { should be_running }
  its('ports') { should eq '0.0.0.0:5007->7/udp' }
end

# docker_container[multi_ip_port]

describe docker_container('multi_ip_port') do
  it { should exist }
  it { should be_running }
  its('ports') { should eq '0.0.0.0:8301->8301/udp, 127.0.0.1:8500->8500/tcp, 127.0.1.1:8500->8500/tcp, 0.0.0.0:32769->8301/tcp' }
end

# docker_container[port_range]

describe command("docker inspect -f '{{ .HostConfig.PortBindings }}' port_range") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should include('2000/tcp:[{ }]') }
  its(:stdout) { should include('2001/tcp:[{ }]') }
  its(:stdout) { should include('2000/udp:[{ }]') }
  its(:stdout) { should include('2001/udp:[{ }]') }
  its(:stdout) { should include('3000/tcp:[{ }]') }
  its(:stdout) { should include('3001/tcp:[{ }]') }
  its(:stdout) { should include('8000/tcp:[{0.0.0.0 7000}]') }
  its(:stdout) { should include('8001/tcp:[{0.0.0.0 7001}]') }
  its(:stdout) { should include('8002/tcp:[{0.0.0.0 7002}]') }
end

# docker_container[bill]

describe docker_container('bill') do
  it { should exist }
  it { should_not be_running }
end

# docker_container[hammer_time]

describe docker_container('hammer_time') do
  it { should exist }
  it { should_not be_running }
end

describe command("docker ps -af 'name=hammer_time$'") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/Exited/) }
end

# docker_container[red_light]

describe docker_container('red_light') do
  it { should exist }
  it { should be_running }
end

describe command("docker ps -af 'name=red_light$'") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/Paused/) }
end

# docker_container[green_light]

describe docker_container('green_light') do
  it { should exist }
  it { should be_running }
end

# docker_container[quitter]

describe docker_container('quitter') do
  it { should exist }
  it { should be_running }
end

# docker_container[restarter]

describe docker_container('restarter') do
  it { should exist }
  it { should be_running }
end

# docker_container[deleteme]

describe docker_container('deleteme') do
  it { should_not exist }
  it { should_not be_running }
end

# docker_container[redeployer]

describe docker_container('redeployer') do
  it { should exist }
  it { should be_running }
end

# docker_container[unstarted_redeployer]

describe docker_container('unstarted_redeployer') do
  it { should exist }
  it { should_not be_running }
end

# docker_container[bind_mounter]

describe docker_container('bind_mounter') do
  it { should exist }
  it { should_not be_running }
end

describe command('docker inspect -f "{{ .HostConfig.Binds }}" bind_mounter') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(%r{\/hostbits\:\/bits}) }
  its(:stdout) { should match(%r{\/more-hostbits\:\/more-bits}) }
  its(:stdout) { should match(%r{\/winter\:\/spring\:ro}) }
end

# docker_container[binds_alias]

describe docker_container('binds_alias') do
  it { should exist }
  it { should_not be_running }
end

describe command('docker inspect -f "{{ .HostConfig.Binds }}" binds_alias') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(%r{\/fall\:\/sun}) }
  its(:stdout) { should match(%r{\/winter\:\/spring\:ro}) }
end

describe command('docker inspect -f "{{ .Config.Volumes }}" binds_alias') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(%r{\/snow\:\{\}}) }
  its(:stdout) { should match(%r{\/summer\:\{\}}) }
end

# docker_container[chef_container]

describe docker_container('chef_container') do
  it { should exist }
  it { should_not be_running }
end

describe command("docker inspect -f \"#{volumes_filter}\" chef_container") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(%r{\/opt\/chef\:}) }
end

# docker_container[ohai_debian]
describe docker_container('ohai_debian') do
  it { should exist }
  it { should_not be_running }
end

describe command('docker logs ohai_debian') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/debian/) }
end

describe command("docker inspect -f \"#{mounts_filter}\" ohai_debian") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(%r{\/opt\/chef}) }
end

# docker_container[env]

describe docker_container('env') do
  it { should exist }
  it { should_not be_running }
end

describe command('docker inspect -f "{{ .Config.Env }}" env') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(%r{\[PATH=\/usr\/bin FOO=bar GOODBYE=TOMPETTY 1950=2017\]}) }
end

# docker_container[env_files]

describe docker_container('env_files') do
  it { should exist }
  it { should_not be_running }
end

describe command('docker inspect -f "{{ .Config.Env }}" env_files') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/\[GOODBYE=TOMPETTY 1950=2017 HELLO=WORLD /) }
end

# docker_container[ohai_again]
describe docker_container('ohai_again') do
  it { should exist }
  it { should_not be_running }
end

describe command('docker logs ohai_again') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/ohai_time/) }
end

# docker_container[cmd_test]

describe docker_container('cmd_test') do
  it { should exist }
  it { should_not be_running }
end

describe command('docker logs cmd_test') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/.dockerenv/) }
end

# docker_container[sean_was_here]
describe docker_container('sean_was_here') do
  it { should_not exist }
  it { should_not be_running }
end

describe command('docker run --rm --volumes-from chef_container debian ls -la /opt/chef/') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/sean_was_here-/) }
end

# docker_container[attached]
describe docker_container('attached') do
  it { should exist }
  it { should_not be_running }
end

describe command('docker run --rm --volumes-from chef_container debian ls -la /opt/chef/') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/attached-\d{12}/) }
end

# docker_container[attached_with_timeout]
describe docker_container('attached_with_timeout') do
  it { should exist }
  it { should_not be_running }
end

describe command('docker run --rm --volumes-from chef_container debian ls -la /opt/chef/') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should_not match(/attached_with_timeout-\d{12}/) }
end

# docker_container[cap_add_net_admin]

describe docker_container('cap_add_net_admin') do
  it { should exist }
  it { should_not be_running }
end

describe command('docker logs cap_add_net_admin') do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should_not match(/RTNETLINK answers: Operation not permitted/) }
end

# docker_container[cap_add_net_admin_error]

describe docker_container('cap_add_net_admin_error') do
  it { should exist }
  it { should_not be_running }
end

describe command('docker logs cap_add_net_admin_error') do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should match(/RTNETLINK answers: Operation not permitted/) }
end

# docker_container[cap_drop_mknod]

describe docker_container('cap_drop_mknod') do
  it { should exist }
  it { should_not be_running }
end

describe command('docker logs cap_drop_mknod') do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should match(%r{mknod: /dev/urandom2: Operation not permitted}) }
  its(:stderr) { should match(%r{ls: cannot access '/dev/urandom2': No such file or directory}) }
end

# docker_container[cap_drop_mknod_error]

describe docker_container('cap_drop_mknod_error') do
  it { should exist }
  it { should_not be_running }
end

describe command('docker logs cap_drop_mknod_error') do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should_not match(%r{mknod: '/dev/urandom2': Operation not permitted}) }
end

# docker_container[fqdn]

describe docker_container('fqdn') do
  it { should exist }
  it { should_not be_running }
end

describe command('docker logs fqdn') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/computers.biz/) }
end

# docker_container[dns]

describe docker_container('dns') do
  it { should exist }
  it { should_not be_running }
end

describe command('docker inspect -f "{{ .HostConfig.Dns }}" dns') do
  its(:stdout) { should match(/\[4.3.2.1 1.2.3.4\]/) }
end

# docker_container[extra_hosts]

describe docker_container('extra_hosts') do
  it { should exist }
  it { should_not be_running }
end

describe command('docker inspect -f "{{ .HostConfig.ExtraHosts }}" extra_hosts') do
  its(:stdout) { should match(/\[east:4.3.2.1 west:1.2.3.4\]/) }
end

# docker_container[devices_sans_cap_sys_admin]

# describe command("docker ps -af 'name=devices_sans_cap_sys_admin$'") do
#   its(:exit_status) { should eq 0 }
#   its(:stdout) { should match(/Exited/) }
# end

# FIXME: find a method to test this that works across all platforms in test-kitchen
# Is this test invalid?
# describe command("md5sum /root/disk1") do
#   its(:exit_status) { should eq 0 }
#   its(:stdout) { should match(/0f343b0931126a20f133d67c2b018a3b/) }
# end

# docker_container[devices_with_cap_sys_admin]

# describe command("docker ps -af 'name=devices_with_cap_sys_admin$'") do
#   its(:exit_status) { should eq 0 }
#   its(:stdout) { should match(/Exited/) }
# end

# describe command('md5sum /root/disk1') do
#   its(:exit_status) { should eq 0 }
#   its(:stdout) { should_not match(/0f343b0931126a20f133d67c2b018a3b/) }
# end

# docker_container[cpu_shares]

describe docker_container('cpu_shares') do
  it { should exist }
  it { should_not be_running }
end

describe command("docker inspect -f '{{ .HostConfig.CpuShares }}' cpu_shares") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/512/) }
end

# docker_container[cpuset_cpus]

describe docker_container('cpuset_cpus') do
  it { should exist }
  it { should_not be_running }
end

describe command("docker inspect -f '{{ .HostConfig.CpusetCpus }}' cpuset_cpus") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/0,1/) }
end

# docker_container[try_try_again]

# FIXME: Find better tests
describe docker_container('try_try_again') do
  it { should exist }
  it { should_not be_running }
end

# docker_container[reboot_survivor]

describe command("docker ps -af 'name=reboot_survivor$'") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should_not match(/Exited/) }
end

# docker_container[reboot_survivor_retry]

describe docker_container('reboot_survivor_retry') do
  it { should exist }
  it { should be_running }
end

# docker_container[link_source]

describe docker_container('link_source') do
  it { should exist }
  it { should be_running }
end

# docker_container[link_source_2]

describe docker_container('link_source_2') do
  it { should exist }
  it { should be_running }
end

# docker_container[link_target_1]

describe docker_container('link_target_1') do
  it { should exist }
  it { should_not be_running }
end

describe command('docker logs link_target_1') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should_not match(/ping: bad address 'hello'/) }
end

# docker_container[link_target_2]

describe docker_container('link_target_2') do
  it { should exist }
  it { should_not be_running }
end

describe command('docker logs link_target_2') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(%r{HELLO_NAME=/link_target_2/hello}) }
end

# docker_container[link_target_3]

describe docker_container('link_target_3') do
  it { should exist }
  it { should_not be_running }
end

describe command('docker logs link_target_3') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should_not match(/ping: bad address 'hello_again'/) }
end

describe command("docker inspect -f '{{ .HostConfig.Links }}' link_target_3") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(%r{[/link_source:/link_target_3/hello /link_source_2:/link_target_3/hello_again]}) }
end

# docker_container[link_target_4]

describe docker_container('link_target_4') do
  it { should exist }
  it { should_not be_running }
end

describe command('docker logs link_target_4') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(%r{HELLO_NAME=/link_target_4/hello}) }
  its(:stdout) { should match(%r{HELLO_AGAIN_NAME=/link_target_4/hello_again}) }
end

describe command("docker inspect -f '{{ .HostConfig.Links }}' link_target_4") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(%r{[/link_source:/link_target_4/hello /link_source_2:/link_target_4/hello_again]}) }
end

# docker_container[dangler]

# describe command('ls -la `cat /dangler_volpath`') do
#   its(:exit_status) { should_not eq 0 }
# end

# FIXME: this changed with 1.8.x. Find a way to sanely test across various platforms

# docker_container[mutator]

describe docker_container('mutator') do
  it { should exist }
  it { should_not be_running }
end

describe file('/mutator.tar') do
  it { should be_file }
  its('mode') { should cmp '0644' }
end

# docker_container[network_mode]

describe docker_container('network_mode') do
  it { should exist }
  it { should be_running }
end

describe command("docker inspect -f '{{ .HostConfig.NetworkMode }}' network_mode") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/host/) }
end

# docker_container[oom_kill_disable]

describe command("docker ps -af 'name=oom_kill_disable$'") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/Exited \(0\)/) }
end

describe command("docker inspect --format '{{ .HostConfig.OomKillDisable }}' oom_kill_disable") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { eq 'true' }
end

# docker_container[oom_score_adj]

describe command("docker ps -af 'name=oom_score_adj$'") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/Exited \(0\)/) }
end

describe command("docker inspect --format '{{ .HostConfig.OomScoreAdj }}' oom_score_adj") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/600/) }
end

# docker_container[ulimits]
describe docker_container('ulimits') do
  it { should exist }
  it { should be_running }
end

describe command("docker inspect -f '{{ .HostConfig.Ulimits }}' ulimits") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/nofile=40960:40960 core=100000000:100000000 memlock=100000000:100000000/) }
end

# docker_container[uber_options]
describe docker_container('uber_options') do
  it { should exist }
  it { should be_running }
end

describe command("docker inspect -f '{{ .Config.Domainname }}' uber_options") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/computers.biz/) }
end

describe command("docker inspect -f '{{ .Config.MacAddress }}' uber_options") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/00:00:DE:AD:BE:EF/) }
end

describe command("docker inspect -f '{{ .HostConfig.Ulimits }}' uber_options") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/nofile=40960:40960 core=100000000:100000000 memlock=100000000:100000000/) }
end

describe command("docker inspect -f '{{ .HostConfig.NetworkMode }}' uber_options") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/#{uber_options_network_mode}/) }
end

# docker inspect returns the labels unsorted
describe command("docker inspect -f '{{ .Config.Labels }}' uber_options") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/foo:bar/) }
  its(:stdout) { should match(/hello:world/) }
end

# docker_container[overrides-1]

describe docker_container('overrides-1') do
  it { should exist }
  it { should be_running }
end

describe command('docker inspect -f "{{ .Config.User }}" overrides-1') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/bob/) }
end

describe command('docker inspect -f "{{ .Config.Env }}" overrides-1') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(%r{[PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin FOO=foo BAR=bar BIZ=biz BAZ=baz]}) }
end

describe command('docker inspect -f "{{ .Config.Entrypoint }}" overrides-1') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/\[\]/) }
end

describe command('docker inspect -f "{{ .Config.Cmd }}" overrides-1') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(%r{[ls -la /]}) }
end

describe command('docker inspect -f "{{ .Config.WorkingDir }}" overrides-1') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(%r{/var}) }
end

describe command('docker inspect -f "{{ .Config.Volumes }}" overrides-1') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(%r{map\[/home:{}\]}) }
end

# docker_container[overrides-2]

describe docker_container('overrides-2') do
  it { should exist }
  it { should be_running }
end

describe command('docker inspect -f "{{ .Config.User }}" overrides-2') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/operator/) }
end

describe command('docker inspect -f "{{ .Config.Env }}" overrides-2') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(%r{[FOO=biz PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin BAR=bar BIZ=biz BAZ=baz]}) }
end

describe command('docker inspect -f "{{ .Config.Entrypoint }}" overrides-2') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(%r{[/bin/sh -c]}) }
end

describe command('docker inspect -f "{{ .Config.Cmd }}" overrides-2') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(%r{[ls -laR /]}) }
end

describe command('docker inspect -f "{{ .Config.WorkingDir }}" overrides-2') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(%r{/tmp}) }
end

# docker_container[syslogger]

describe docker_container('syslogger') do
  it { should exist }
  it { should be_running }
end

describe command("docker inspect -f '{{ .HostConfig.LogConfig.Type }}' syslogger") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/syslog/) }
end

describe command("docker inspect -f '{{ .HostConfig.LogConfig.Config }}' syslogger") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/tag:container-syslogger/) }
end

# docker_container[host_override]

describe docker_container('host_override') do
  it { should exist }
  it { should_not be_running }
end

# docker_container[kill_after]

describe docker_container('kill_after') do
  it { should exist }
  it { should_not be_running }
end

kill_after_start = command("docker inspect -f '{{.State.StartedAt}}' kill_after").stdout
kill_after_start = DateTime.parse(kill_after_start).to_time.to_i

kill_after_finish = command("docker inspect -f '{{.State.FinishedAt}}' kill_after").stdout
kill_after_finish = DateTime.parse(kill_after_finish).to_time.to_i

kill_after_run_time = kill_after_finish - kill_after_start

describe kill_after_run_time do
  it { should be_within(5).of(1) }
end

# docker_container[pid_mode]

describe command("docker ps -af 'name=pid_mode$'") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/Exited \(0\)/) }
end

describe command("docker inspect --format '{{ .HostConfig.PidMode }}' pid_mode") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { eq 'host' }
end

# docker_container[init]

describe command("docker ps -af 'name=init$'") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/Exited \(0\)/) }
end

describe command("docker inspect --format '{{ .HostConfig.Init }}' init") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { eq 'true' }
end

# docker_container[ipc_mode]

describe command("docker ps -af 'name=ipc_mode$'") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/Exited \(0\)/) }
end

describe command("docker inspect --format '{{ .HostConfig.IpcMode }}' ipc_mode") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { eq 'host' }
end

# docker_container[uts_mode]

describe command("docker ps -af 'name=uts_mode$'") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/Exited \(0\)/) }
end

describe command("docker inspect --format '{{ .HostConfig.UTSMode }}' uts_mode") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { eq 'host' }
end

describe command("docker inspect --format '{{ .HostConfig.ReadonlyRootfs }}' ro_rootfs") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { eq 'true' }
end

# sysctls
describe command("docker inspect --format '{{ .HostConfig.Sysctls }}' sysctls") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/net.core.somaxconn:65535/) }
  its(:stdout) { should match(/net.core.xfrm_acq_expires:42/) }
end

# cmd_change

describe command("docker inspect -f '{{ .Config.Cmd }}' cmd_change") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/nc -ll -p 9/) }
end

# docker_container[memory]

describe command("docker inspect -f '{{ .HostConfig.KernelMemory }}' memory") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/10485760/) }
end

describe command("docker inspect -f '{{ .HostConfig.Memory }}' memory") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/5242880/) }
end

describe command("docker inspect -f '{{ .HostConfig.MemorySwap }}' memory") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/5242880/) }
end

describe command("docker inspect -f '{{ .HostConfig.MemorySwappiness }}' memory") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/50/) }
end

describe command("docker inspect -f '{{ .HostConfig.MemoryReservation }}' memory") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/5242880/) }
end

describe command("docker inspect -f '{{ .HostConfig.ShmSize }}' memory") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/67108864/) }
end
