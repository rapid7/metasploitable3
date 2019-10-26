if os.name == 'debian' || os.name == 'ubuntu'

  describe file('/etc/apt/apt.conf.d/50unattended-upgrades') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 0644 }
    its(:content) { should match(/"--force-confold";/) }
  end
end
