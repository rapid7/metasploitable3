describe service('sinatra') do
  it { should be_enabled }
  it { should be_running }
end

describe port('8181') do
  it { should be_listening }
end