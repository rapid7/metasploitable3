#
# Cookbook:: metasploitable
# Recipe:: create_users
#
# Copyright:: 2017, The Authors, All Rights Reserved.

user 'leia_organa' do
  password 'help_me_obiw@n'
  action :create
end

user 'luke_skywalker' do
  password 'use_the_f0rce'
  action :create
end

user 'han_solo' do
  password 'sh00t-first'
  action :create
end

user 'artoo_detoo' do
  password 'beep_b00p'
  action :create
end

user 'c_three_pio' do
  password 'pr0t0c0l'
  action :create
end

user 'ben_kenobi' do
  password 'thats_no_moon'
  action :create
end

user 'darth_vader' do
  password 'd@rk_sid3'
  action :create
end

user 'anakin_skywalker' do
  password 'yipp33'
  action :create
end

user 'jarjar_binks' do
  password 'mesah_p@ssw0rd'
  action :create
end

user 'lando_calrissian' do
  password 'b@ckstab'
  action :create
end

user 'boba_fett' do
  password 'mandalorian1'
  action :create
end

user 'jabba_hutt' do
  password 'not-a-slug12'
  action :create
end

user 'greedo' do
  password 'hanShotFirst!'
  action :create
end

user 'chewbacca' do
  password 'rwaaaaawr5'
  action :create
end

user 'kylo_ren' do
  password 'daddy_issues1'
  action :create
end

group 'Backup Operators' do
  action :modify
  members 'leia_organa'
  append true
end

group 'Certificate Service DCOM Access' do
  action :modify
  members 'luke_skywalker'
  append true
end

group 'Cryptographic Operators' do
  action :modify
  members 'han_solo'
  append true
end

group 'Distributed COM Users' do
  action :modify
  members 'artoo_detoo'
  append true
end

group 'Event Log Readers' do
  action :modify
  members 'c_three_pio'
  append true
end

group 'Guests' do
  action :modify
  members 'ben_kenobi'
  append true
end

group 'IIS_IUSRS' do
  action :modify
  members 'darth_vader'
  append true
end

group 'Network Configuration Operators' do
  action :modify
  members 'anakin_skywalker'
  append true
end

group 'Performance Log Users' do
  action :modify
  members 'jarjar_binks'
  append true
end

group 'Performance Monitor Users' do
  action :modify
  members 'lando_calrissian'
  append true
end

group 'Power Users' do
  action :modify
  members 'boba_fett'
  append true
end

group 'Print Operators' do
  action :modify
  members 'jabba_hutt'
  append true
end

group 'Remote Desktop Users' do
  action :modify
  members 'greedo'
  append true
end

group 'Replicator' do
  action :modify
  members 'chewbacca'
  append true
end

registry_key 'HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList' do
  values [{:name => 'leia_organa', :type => :dword, :data => 0},
          {:name => 'luke_skywalker', :type => :dword, :data => 0},
          {:name => 'han_solo', :type => :dword, :data => 0},
          {:name => 'artoo_detoo', :type => :dword, :data => 0},
          {:name => 'c_three_pio', :type => :dword, :data => 0},
          {:name => 'ben_kenobi', :type => :dword, :data => 0},
          {:name => 'darth_vader', :type => :dword, :data => 0},
          {:name => 'anakin_skywalker', :type => :dword, :data => 0},
          {:name => 'jarjar_binks', :type => :dword, :data => 0},
          {:name => 'lando_calrissian', :type => :dword, :data => 0},
          {:name => 'boba_fett', :type => :dword, :data => 0},
          {:name => 'jabba_hutt', :type => :dword, :data => 0},
          {:name => 'greedo', :type => :dword, :data => 0},
          {:name => 'chewbacca', :type => :dword, :data => 0},
          {:name => 'kylo_ren', :type => :dword, :data => 0}
         ]
  recursive true
  action :create
end
