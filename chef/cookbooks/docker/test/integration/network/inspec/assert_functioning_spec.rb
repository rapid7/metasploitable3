###########
# reference
###########

# https://docs.docker.com/engine/reference/commandline/network_create/

###########
# network_a
###########

describe command("docker network ls -qf 'name=network_a$'") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should_not be_empty }
end

describe command('docker network inspect -f "{{ .Driver }}" network_a') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should eq "bridge\n" }
end

describe command('docker network inspect -f "{{ .Containers }}" network_a') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match 'echo-station-network_a' }
end

describe command('docker network inspect -f "{{ .Containers }}" network_a') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match 'echo-base-network_a' }
end

###########
# network_b
###########

describe command("docker network ls -qf 'name=network_b$'") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should be_empty }
end

###########
# network_c
###########

describe command("docker network ls -qf 'name=network_c$'") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should_not be_empty }
end

describe command('docker network inspect -f "{{ .Driver }}" network_c') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should eq "bridge\n" }
end

describe command('docker network inspect network_c') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(%r{192\.168\.88\.0/24}) }
  its(:stdout) { should match(/192\.168\.88\.1/) }
end

describe command('docker network inspect -f "{{ .Containers }}" network_c') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match 'echo-station-network_c' }
end

describe command('docker network inspect -f "{{ .Containers }}" network_c') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match 'echo-base-network_c' }
end

###########
# network_d
###########

describe command("docker network ls -qf 'name=network_d$'") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should_not be_empty }
end

describe command('docker network inspect -f "{{ .Driver }}" network_d') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should eq "bridge\n" }
end

describe command('docker network inspect network_d') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/a.*192\.168\.89\.2/) }
  its(:stdout) { should match(/b.*192\.168\.89\.3/) }
end

###########
# network_e
###########

describe command("docker network ls -qf 'name=network_e$'") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should_not be_empty }
end

describe command('docker network inspect -f "{{ .Driver }}" network_e') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should eq "overlay\n" }
end

###########
# network_f
###########

describe command("docker network ls -qf 'name=network_f$'") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should_not be_empty }
end

describe command('docker network inspect -f "{{ .Driver }}" network_f') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should eq "bridge\n" }
end

describe command('docker network inspect network_f') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(%r{Subnet.*172\.28\.0\.0/16}) }
  its(:stdout) { should match(%r{IPRange.*172\.28\.5\.0/24}) }
  its(:stdout) { should match(/Gateway.*172\.28\.5\.254/) }
end

describe command('docker network inspect -f "{{ .Containers }}" network_f') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match 'echo-station-network_f' }
end

describe command('docker network inspect -f "{{ .Containers }}" network_f') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match 'echo-base-network_f' }
end

describe command('docker inspect -f "{{ .NetworkSettings.Networks.network_f.IPAddress }}" echo-base-network_f') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match '172.28.5.5' }
end

###########
# network_g
###########

describe command("docker network ls -qf 'name=network_g$'") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should_not be_empty }
end

describe command('docker network inspect -f "{{ .Driver }}" network_g') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should eq "overlay\n" }
end

describe command('docker network inspect network_g') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(%r{Subnet.*192\.168\.0\.0/16}) }
  its(:stdout) { should match(%r{IPRange.*192\.168\.1\.0/24}) }
  its(:stdout) { should match(/Gateway.*192\.168\.0\.100/) }
  its(:stdout) { should match(/a.*192\.168\.1\.5/) }
  its(:stdout) { should match(/a.*192\.168\.1\.5/) }
  its(:stdout) { should match(%r{Subnet.*192\.170\.0\.0/16}) }
  its(:stdout) { should match(/Gateway.*192\.170\.0\.100/) }
  its(:stdout) { should match(/a.*192\.170\.1\.5/) }
  its(:stdout) { should match(/a.*192\.170\.1\.5/) }
end

describe command('docker network inspect -f "{{ .Containers }}" network_g') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match 'echo-station-network_g' }
end

describe command('docker network inspect -f "{{ .Containers }}" network_g') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match 'echo-base-network_g' }
end

###########
# network_h
###########

describe command("docker network ls -qf 'name=network_h1$'") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should_not be_empty }
end

describe command("docker network inspect -f '{{ range $c:=.Containers }}{{ $c.Name }}{{ end }}' network_h1") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should_not match 'container1-network_h' }
end

describe command("docker network inspect -f '{{ range $c:=.Containers }}{{ $c.Name }}{{ end }}' network_h2") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match 'container1-network_h' }
end

##############
# network_ipv4
##############

describe command("docker network ls -qf 'name=network_ipv4$'") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should_not be_empty }
end

describe command("docker network inspect -f '{{ .EnableIPv6 }}' network_ipv4") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match 'false' }
end

describe command("docker network inspect -f '{{ .Internal }}' network_ipv4") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match 'false' }
end

##############
# network_ipv6
##############

describe command("docker network ls -qf 'name=network_ipv6$'") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should_not be_empty }
end

describe command("docker network inspect -f '{{ .EnableIPv6 }}' network_ipv6") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match 'true' }
end

describe command("docker network inspect -f '{{ range $i:=.IPAM.Config }}{{ .Subnet | printf \"%s\\n\" }}{{ end }}' network_ipv6") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should include 'fd00:dead:beef::/48' }
end

##################
# network_internal
##################

describe command("docker network ls -qf 'name=network_internal'") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should_not be_empty }
end

describe command("docker network inspect -f '{{ .Internal }}' network_internal") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match 'true' }
end

# describe command('docker network inspect test-network') do
#   its(:exit_status) { should eq 0 }
# end

# describe command('docker network inspect test-network-overlay') do
#   its(:exit_status) { should eq 0 }
#   its(:stdout) { should match(/Driver.*overlay/) }
# end

# describe command('docker network inspect test-network-ip') do
#   its(:exit_status) { should eq 0 }
#   its(:stdout) { should match(%r{Subnet.*192\.168\.88\.0/24}) }
#   its(:stdout) { should match(/Gateway.*192\.168\.88\.3/) }
# end

# describe command('docker network inspect test-network-aux') do
#   its(:exit_status) { should eq 0 }
#   its(:stdout) { should match(/a.*192\.168\.89\.4/) }
#   its(:stdout) { should match(/b.*192\.168\.89\.5/) }
# end

# describe command('docker network inspect test-network-ip-range') do
#   its(:exit_status) { should eq 0 }
#   its(:stdout) { should match('asdf') }
# end

# describe command('docker network inspect test-network-connect') do
#   its(:exit_status) { should eq 0 }
#   its(:stdout) { should include(network_container['Id']) }
# end
