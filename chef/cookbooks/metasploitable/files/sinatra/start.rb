#!/usr/bin/env ruby

require 'sinatra'
require 'erubis'
require 'active_support'

MYSECRET = 'a7aebc287bba0ee4e64f947415a94e5f'

set :environment, :development
set :bind, '0.0.0.0'
set :port, 8080

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

