control "firewall" do
  title "Configure Firewall"
  desc "Check if the firewall rules are applied. Configuration script available at /scripts/configs/configure_firewall.bat"

  describe command('netsh advfirewall firewall show rule name="Open Port 8484 for Jenkins"') do
   its('stdout') { should match "Enabled:                              Yes" }
  end

  describe command('netsh advfirewall firewall show rule name="Open Port 8282 for Apache Struts"') do
   its('stdout') { should match "Enabled:                              Yes" }
  end

  describe command('netsh advfirewall firewall show rule name="Open Port 80 for IIS"') do
   its('stdout') { should match "Enabled:                              Yes" }
  end

  describe command('netsh advfirewall firewall show rule name="Open Port 4848 for GlassFish"') do
   its('stdout') { should match "Enabled:                              Yes" }
  end

  describe command('netsh advfirewall firewall show rule name="Open Port 8080 for GlassFish"') do
   its('stdout') { should match "Enabled:                              Yes" }
  end

  describe command('netsh advfirewall firewall show rule name="Open Port 8585 for Wordpress and phpMyAdmin"') do
   its('stdout') { should match "Enabled:                              Yes" }
  end

  describe command('netsh advfirewall firewall show rule name="Java 1.6 java.exe"') do
   its('stdout') { should match "Enabled:                              Yes" }
  end

  describe command('netsh advfirewall firewall show rule name="Open Port 3000 for Rails Server"') do
   its('stdout') { should match "Enabled:                              Yes" }
  end

  describe command('netsh advfirewall firewall show rule name="Open Port 8020 for ManageEngine Desktop Central"') do
   its('stdout') { should match "Enabled:                              Yes" }
  end

  describe command('netsh advfirewall firewall show rule name="Open Port 8383 for ManageEngine Desktop Central"') do
   its('stdout') { should match "Enabled:                              Yes" }
  end

  describe command('netsh advfirewall firewall show rule name="Open Port 8022 for ManageEngine Desktop Central"') do
   its('stdout') { should match "Enabled:                              Yes" }
  end

  describe command('netsh advfirewall firewall show rule name="Open Port 9200 for ElasticSearch"') do
   its('stdout') { should match "Enabled:                              Yes" }
  end

  describe command('netsh advfirewall firewall show rule name="Open Port 161 for SNMP"') do
   its('stdout') { should match "Enabled:                              Yes" }
  end

  describe command('netsh advfirewall firewall show rule name="Closed port 445 for SMB"') do
   its('stdout') { should match "Enabled:                              Yes" }
  end

  describe command('netsh advfirewall firewall show rule name="Closed port 139 for NetBIOS"') do
   its('stdout') { should match "Enabled:                              Yes" }
  end

  describe command('netsh advfirewall firewall show rule name="Closed port 135 for NetBIOS"') do
   its('stdout') { should match "Enabled:                              Yes" }
  end

  describe command('netsh advfirewall firewall show rule name="Closed Port 3389 for Remote Desktop"') do
   its('stdout') { should match "Enabled:                              Yes" }
  end

  describe command('netsh advfirewall firewall show rule name="Closed Port 3306 for MySQL"') do
   its('stdout') { should match "Enabled:                              Yes" }
  end

end
