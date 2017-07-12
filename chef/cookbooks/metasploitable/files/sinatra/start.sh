#!/bin/sh

cd /opt/sinatra
bundle install
ruby -e "require 'obfuscate'; Obfuscate.setup { |c| c.salt = 'sinatra'; c.mode = :string}; code = Obfuscate.clarify(File.read('server')); eval(code)"
