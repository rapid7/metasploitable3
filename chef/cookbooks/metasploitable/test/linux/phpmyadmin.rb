describe command('curl http://localhost/phpmyadmin/') do
  its('stdout') { should match /logo_right\.png/ } # Make sure it has the icon
end