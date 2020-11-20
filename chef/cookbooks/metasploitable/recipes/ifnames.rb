#
# Cookbook:: metasploitable
# Recipe:: ifnames
#

# block udev persistent net rules for consistent interface naming after cloning
link '/etc/udev/rules.d/75-persistent-net-generator.rules' do
  to '/dev/null'
end
