describe port('21') do
  it { should be_listening }
end

describe service('proftpd') do
  it { should be_enabled }
  it { should be_running }
end