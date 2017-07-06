#
# Cookbook:: metasploitable
# Attributes:: default
#
default[:metasploitable][:docker_users] = ['boba_fett',
                                             'jabba_hutt',
                                             'greedo',
                                             'chewbacca',]

default[:metasploitable][:files_path] = '/vagrant/chef/cookbooks/metasploitable/files/'

default[:metasploitable][:ports][:cups] = 631
default[:metasploitable][:ports][:apache] = 80
default[:metasploitable][:ports][:unrealircd] = 6697
default[:metasploitable][:ports][:proftpd] = 21
default[:metasploitable][:ports][:mysql] = 3306
default[:metasploitable][:ports][:chatbot][:ui] = default[:metasploitable][:ports][:apache]
default[:metasploitable][:ports][:chatbot][:nodejs] = 3000
default[:metasploitable][:ports][:chatbot][:ruby] = 8181
default[:metasploitable][:ports][:samba] = 445
