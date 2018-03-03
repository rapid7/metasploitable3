#
# Cookbook:: metasploitable
# Recipe:: root_certs
#
# Copyright:: 2017, The Authors, All Rights Reserved.

execute 'addtrust_external_ca' do
  command 'certutil -addstore -f "Root" A:\addtrust_external_ca.cer'
end

execute 'baltimore_ca' do
  command 'certutil -addstore -f "Root" A:\baltimore_ca.cer'
end

execute 'digicert' do
  command 'certutil -addstore -f "Root" A:\digicert.cer'
end

execute 'equifax' do
  command 'certutil -addstore -f "Root" A:\equifax.cer'
end

execute 'globalsign' do
  command 'certutil -addstore -f "Root" A:\globalsign.cer'
end

execute 'gte_cybertrust' do
  command 'certutil -addstore -f "Root" A:\gte_cybertrust.cer'
end

execute 'microsoft_root_2011' do
  command 'certutil -addstore -f "Root" A:\microsoft_root_2011.cer'
end

execute 'thawte_primary_root' do
  command 'certutil -addstore -f "Root" A:\thawte_primary_root.cer'
end

execute 'utn-userfirst' do
  command 'certutil -addstore -f "Root" A:\utn-userfirst.cer'
end
