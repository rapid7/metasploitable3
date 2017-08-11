describe package('ruby23') do
  it { should be_installed }
end

describe package('ruby23-dev') do
  it { should be_installed }
end

describe package('bundler') do
  it { should be_installed }
end