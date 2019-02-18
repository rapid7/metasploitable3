describe command('/usr/bin/docker --version') do
  its(:exit_status) { should eq 0 }
end
