#!/usr/bin/env ruby

require 'sinatra'
require 'erubis'
require 'active_support'
require 'webrick'

MYSECRET = 'a7aebc287bba0ee4e64f947415a94e5f'

set :environment, :development
set :bind, '0.0.0.0'
set :port, 8181

# These settings are specific for Sinatra 2.0.0rc2
set :logging, false
set :quiet, true
dev_null = WEBrick::Log::new("/dev/null", 7)
set :server_settings, {:Logger => dev_null, :AccessLog => dev_null}

use Rack::Session::Cookie,
  :key          => "_metasploitable",
  :path         => "/",
  :expire_after => 1800,
  :secret       => MYSECRET

get '/' do
  val = "Shhhhh, don't tell anybody this cookie secret: #{MYSECRET}"
  session['_metasploitable'] = val unless session['_metasploitable']
  body =  "Welcome to Metasploitable3 - Linux edition.<br>"
  body << "If you exploit this application, you will be handsomely rewarded."
  [200, {}, body]
end

