#
# Cookbook:: metasploitable
# Attributes:: default
#
default[:metasploitable][:docker_users] = ['boba_fett',
                                           'jabba_hutt',
                                           'greedo',
                                           'chewbacca',]

default[:metasploitable][:files_path] = '/vagrant/chef/cookbooks/metasploitable/files/'