#
# Cookbook:: metasploitable
# Recipe:: users
#
# Copyright:: 2017, Rapid7, All Rights Reserved.

# See scripts/configs/create_users.bat for passwords

uid = 1111

node[:users].each do |u, attributes|
  user attributes[:username] do
    manage_home true
    password attributes[:password_hash]
    uid uid
    gid '100'
    home "/home/#{attributes[:username]}"
    shell '/bin/bash'
  end
  uid += 1
end
