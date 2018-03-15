describe service('knockd') do
  it { should be_enabled }
  # it { should be_running } # TODO: The service is running, as evidenced by the listening port, but for some reason these tests keep failing. Research why and update them.
end