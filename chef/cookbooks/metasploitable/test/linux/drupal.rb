# InSpec Testing for Drupal

describe command('curl http://localhost/drupal/') do
  its('stdout') { should match /kali-metasploit-256\.png/ } # Make sure it has the icon
  its('stdout') { should match /Metasploitable FAQs/ } # Make sure it has the title
  its('stdout') { should match /What else is there to do here/ } # Make sure it has the content
end

describe command('mysql -h 127.0.0.1 --user="root" --password="sploitme" --execute="SHOW DATABASES LIKE \'drupal\'"') do
  its('stdout') { should match /drupal/ } # Make sure the database exists
end
