control "elasticsearch" do
  title "ElasticSearch"
  desc "Check if ElasticSearch was installed correctly. Installation script available at /scripts/installs/install_elasticsearch.bat"

  describe file('C:\\Program Files\\elasticsearch-1.1.1') do
   it { should exist }
  end

  describe command('sc query elasticsearch-service-x64') do
   its('stdout') { should match ("STATE              : 4  RUNNING") }
  end

  describe command('netstat -aob | findstr :9200') do
   its('stdout') { should match "LISTENING" }
  end
end
