control "ruby" do
  title "Ruby"
  desc "Check if ruby is installed. Installation script found at /scripts/installs/install_ruby.bat"

  describe file('C:\\tools\\ruby23') do
   it { should exist }
  end

  describe command('ruby -v') do
   its(:exit_status) { should eq 0 }
  end
end
