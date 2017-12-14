#
# Cookbook:: metasploitable
# Recipe:: users
#
# Copyright:: 2017, Rapid7, All Rights Reserved.

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

administrator_members = node[:users].keys.find_all { |user| node[:users][user][:admin] == true }

group 'sudo' do
  action :modify
  members administrator_members.map { |u| node[:users][u][:username] }
  append true
end


