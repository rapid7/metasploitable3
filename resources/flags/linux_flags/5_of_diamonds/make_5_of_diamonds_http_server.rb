#!/usr/bin/env ruby

require 'base64'

# source should be PNG file
source_path = ARGV.shift

if source_path.nil? || source_path.empty? || !File.exists?(source_path)
  source_path = 'source.png'
  puts "* No argument provided. Using #{source_path} as the flag."
end

str = Base64.strict_encode64(File.read(source_path))
# Because Crystal crashes when concatenating the long Base64 string one byte at a time,
# we need to make the operation small. We do this by preserving the first 99.9% of the string,
# and then we obfuscate the rest, which should be enough of a pain to reverse for
# most people.
max_size = (str.length * 0.999).to_i
puts "* First portion of the Base64 string size is: #{max_size}"
str1 = str[0, max_size]
str2 = str[max_size..-1]
puts "* The last #{str2.length} will be obfuscated"
obfuscated_str = str2.split('').map { |c| %Q|"#{c}"| } * " + "

crystal_code = %Q|
# This file needs to be compiled into a binary using 'crystal build flag.rb' on a
# x86/64 Ubuntu machine.
#
# The resulting binary will be what is added to the system.
# It is intended to be accessed after initiating the correct port knocking sequence.
#
# To run: ./flag1 -p <port>
# Defaults to 8989 if no port specified.

require "http/server"
require "option_parser"
require "base64"

flag = "#{str1}" + #{obfuscated_str}
port = 8989

OptionParser.parse! do \|parser\|
  parser.banner = "Usage: flag_server [arguments]"
  parser.on("-p", "--port=PORT", "Use a custom port. Default is 8989.") { \|p\| port = p.to_i }
  parser.on("-h", "--help", "Show this help.") { puts parser }
end

server = HTTP::Server.new("0.0.0.0", port) do \|context\|
  context.response.content_type = "image/png"
  context.response.print Base64.decode_string("\#{flag}")
end

puts "Listening on http://0.0.0.0:\#{port}"
server.listen|

puts "* This is the Crystal code you are about to compile:"
puts
puts crystal_code
puts

CRYSTALFNAME = '/tmp/five_of_diamonds.cr'
CRYSTALOUTPUT = 'five_of_diamonds'

File.open(CRYSTALFNAME, 'wb') { |f| f.write(crystal_code) }

puts "* Compiling code, please wait..."
`crystal build --no-debug #{CRYSTALFNAME}`

unless File.exists?(CRYSTALOUTPUT)
  puts "[x] Crystal failed to build our code"
  exit
end

puts "* Crystal built: #{CRYSTALOUTPUT}"
print '* '
puts `file #{CRYSTALOUTPUT}`
