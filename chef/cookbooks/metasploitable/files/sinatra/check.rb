#!/usr/bin/env ruby

#
# This will check our vulnerable app to see if it's vulnerable or not.
# It does so by predicting the hash in the cookie.
#

require 'openssl'
require 'cgi'
require 'net/http'

SECRET = "a7aebc287bba0ee4e64f947415a94e5f"

cli = Net::HTTP.new('127.0.0.1', 8080)
req = Net::HTTP::Get.new('/')
res = cli.request(req)
cookie = res['Set-Cookie'].scan(/_metasploitable=(.+); path/).flatten.first || ''
data, hash = cookie.split('--')
puts "[*] Found hash: #{hash}"
puts "[*] Attempting to recreate the same hash with secret: #{SECRET}"
expected_hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest::SHA1.new, SECRET, CGI.unescape(data))
puts "[*] Predicted hash: #{expected_hash}"

if expected_hash == hash
  puts "[*] Yay! we can predict the hash. The server is vulnerable."
end
