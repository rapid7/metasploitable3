#
# Cookbook:: metasploitable
# Recipe:: flags
#
# Copyright:: 2017, The Authors, All Rights Reserved.

cookbook_file 'C:\inetpub\wwwroot\six_of_diamonds.zip' do
  source 'flags/six_of_diamonds.zip'
  action :create
end

cookbook_file 'C:\WINDOWS\System32\jack_of_clubs.png' do
  source 'flags/jack_of_clubs.png'
  action :create
end

batch 'Jack of Clubs' do
  code <<-EOH
    attrib +h "C:\\WINDOWS\\System32\\jack_of_clubs.png"
    cacls "C:\\WINDOWS\\System32\\jack_of_clubs.png" /t /e /g SYSTEM:f
    cacls "C:\\WINDOWS\\System32\\jack_of_clubs.png" /R Administrators /E
    cacls "C:\\WINDOWS\\System32\\jack_of_clubs.png" /R Users /E
  EOH
end

cookbook_file 'C:\Windows\three_of_spades.png' do
  source 'flags/three_of_spades.png'
  action :create
end

batch 'Three of Spades' do
  code <<-EOH
    attrib +h "C:\\Windows\\three_of_spades.png"
    cacls "C:\\Windows\\three_of_spades.png" /t /e /g SYSTEM:f
    cacls "C:\\Windows\\three_of_spades.png" /R Administrators /E
    cacls "C:\\Windows\\three_of_spades.png" /R USERS /E
  EOH
end

cookbook_file 'C:\Windows\System32\kingofclubs.exe' do
  source 'flags/kingofclubs.exe'
  action :create
end

cookbook_file 'C:\Users\Public\Music\four_of_clubs.wav' do
  source 'flags/four_of_clubs.wav'
  action :create
end

cookbook_file 'C:\inetpub\wwwroot\index.html' do
  source 'flags/joker.html'
  action :create
end

cookbook_file 'C:\inetpub\wwwroot\hahaha.jpg' do
  source 'flags/hahaha.jpg'
  action :create
end

file 'C:\inetpub\wwwroot\iisstart.htm' do
  action :delete
end

cookbook_file 'C:\inetpub\wwwroot\seven_of_hearts.html' do
  source 'flags/seven_of_hearts.html'
  action :create
end

cookbook_file 'C:\Users\Public\Documents\jack_of_hearts.docx' do
  source 'flags/jack_of_hearts.docx'
  action :create
end

cookbook_file 'C:\Users\Public\Documents\seven_of_spades.pdf' do
  source 'flags/seven_of_spades.pdf'
  action :create
end

cookbook_file 'C:\Users\Public\Pictures\ace_of_hearts.jpg' do
  source 'flags/ace_of_hearts.jpg'
  action :create
end

cookbook_file 'C:\Users\Public\Pictures\ten_of_diamonds.png' do
  source 'flags/ten_of_diamonds.png'
  action :create
end

execute 'Creating database' do
  command '"C:\wamp\bin\mysql\mysql5.5.20\bin\mysql.exe" -u root --password=""  -e "create database cards;"'
  action :run
end

cookbook_file 'C:\Windows\Temp\queen_of_hearts.sql' do
  source 'flags/queen_of_hearts.sql'
  action :create
end

execute 'Initializing database' do
  command '"C:\wamp\bin\mysql\mysql5.5.20\bin\mysql.exe" -u root --password=""  cards < "C:\Windows\Temp\queen_of_hearts.sql"'
  action :run
end

