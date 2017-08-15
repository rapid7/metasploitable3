describe package('ruby2.3') do
  it { should be_installed }
end

describe package('ruby2.3-dev') do
  it { should be_installed }
end

describe package('bundler') do
  it { should be_installed }
end