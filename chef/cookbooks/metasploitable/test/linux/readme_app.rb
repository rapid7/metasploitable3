describe service('readme_app') do
  it { should be_enabled }
  it { should be_running }
end

describe port('3500') do
  it { should be_listening }
end
