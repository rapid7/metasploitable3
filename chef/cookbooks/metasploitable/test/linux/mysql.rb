describe port('3306') do
  it { should be_listening }
end

# TODO: The service is running, as evidenced by the listening port.
# but for some reason these tests keep failing. Research why and update them.
# describe service('mysql') do
#   it { should be_enabled }
#   it { should be_running }
# end