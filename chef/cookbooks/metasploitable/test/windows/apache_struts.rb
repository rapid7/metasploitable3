control "apache-struts" do
  title "Check if apache struts is running"
  desc "Check if the service is running. Installation script available at /scripts/installs/setup_apache_struts.bat"

  describe file('C:\\Program Files\\Apache Software Foundation\\tomcat\\apache-tomcat-8.5.12\\conf\\tomcat-users.xml') do
   it { should exist }
  end

  describe file('C:\\Program Files\\Apache Software Foundation\\tomcat\\apache-tomcat-8.5.12\\conf\\server.xml') do
   it { should exist }
  end

  describe file('C:\\Program Files\\Apache Software Foundation\\tomcat\\apache-tomcat-8.5.12\\webapps\\struts2-rest-showcase.war') do
   it { should exist }
  end
end
