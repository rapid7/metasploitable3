# Tests for the custom chatbot

describe service('chatbot') do
  it { should be_running }
  it { should be_enabled }
end

# Make sure the landing page comes up
describe command('curl http://localhost/chat/') do
  its('stdout') { should match /Please enter your name to continue/ }
end

#TODO: Add tests that make sure the chatbot responds to chat messages
