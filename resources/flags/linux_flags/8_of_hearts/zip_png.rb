#!/usr/bin/env ruby

# gem install rubyzip
require 'zip'

SOURCEPNG = 'source.png'
CARDNAME  = '8_of_hearts.png'
ZIP_NAME  = '8_of_hearts.zip'
password = ARGV.shift

if password.nil? || password.empty?
  puts "[x] Please set a password for the zip file you're trying to create"
  exit
end

data = File.read(SOURCEPNG)
zip = Zip::OutputStream.write_buffer(::StringIO.new(''), Zip::TraditionalEncrypter.new(password)) do |o|
  o.put_next_entry(CARDNAME)
  o.write data
end

File.open(ZIP_NAME, 'wb') do |f|
  f.write(zip.string)
end

puts "[*] #{ZIP_NAME} created with password: #{password}"
