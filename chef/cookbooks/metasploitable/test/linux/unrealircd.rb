describe service('unrealircd') do
  it { should be_enabled }
  it { should be_running }
end

describe port('6697') do
  it { should be_listening }
end