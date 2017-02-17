#
# Cookbook:: metasploitable
# Recipe:: apache_continuum
#
# Copyright:: 2017, Rapid7, All Rights Reserved.

execute "apt-get update" do
  command "apt-get update"
end
package 'openjdk-6-jre'
package 'openjdk-6-jdk'

bash 'Download and extract Apache Continuum 1.4.2' do
  code <<-EOH
    mkdir /opt/apache-continuum/
    cd /opt/apache-continuum/
    wget http://archive.apache.org/dist/continuum/binaries/apache-continuum-1.4.2-bin.tar.gz
    tar xvf apache-continuum-1.4.2-bin.tar.gz
    rm apache-continuum-1.4.2/bin/wrapper-linux-x86-32
    rm -rf apache-continuum-1.4.2/data
    tar -xvzf /vagrant/resources/apache_continuum/data.tar.gz -C /opt/apache-continuum/apache-continuum-1.4.2/
    ln -s /opt/apache-continuum/apache-continuum-1.4.2/bin/continuum /etc/init.d/continuum
    update-rc.d continuum defaults 80
    service continuum start
  EOH
end