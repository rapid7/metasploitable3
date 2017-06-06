# Inspec Tests for cups

# Tests for the service
describe service'cups' do
  it { should be_running }
  it { should be_enabled }
end

describe port('631') do
  it { should be_listening }
end
