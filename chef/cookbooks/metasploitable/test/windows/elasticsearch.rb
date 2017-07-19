control "elasticsearch" do
  title "ElasticSearch"
  desc "Check if ElasticSearch was installed correctly. Installation script available at /scripts/installs/install_elasticsearch.bat"

  describe file('C:\\Program Files\\elasticsearch-1.1.1') do
   it { should exist }
  end

  describe service('elasticsearch-service-x64') do
   it { should be_installed }  
   it { should be_enabled }  
   it { should be_running }  
  end  


  describe port('9200') do
   it { should be_listening }
  end
end
