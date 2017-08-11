describe port('3306') do
  it { should be_listening }
end

describe service('mysql') do
  it { should be_enabled }
  it { should be_running }
end