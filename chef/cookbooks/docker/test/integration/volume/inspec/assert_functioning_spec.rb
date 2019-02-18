###########
# reference
###########

# https://docs.docker.com/engine/reference/commandline/volume_create/

###########
# remove_me
###########

describe command('docker volume ls -q') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should_not match(/^remove_me$/) }
end

#######
# hello
#######

describe command('docker volume ls -q') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/^hello$/) }
  its(:stdout) { should match(/^hello_again$/) }
end

##################
# hello containers
##################

describe command("docker ps -qaf 'name=file_writer$'") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should_not be_empty }
end

describe command("docker ps -qaf 'name=file_reader$'") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should_not be_empty }
end

describe command('docker logs file_reader') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(%r{/hello/sean_was_here}) }
end
