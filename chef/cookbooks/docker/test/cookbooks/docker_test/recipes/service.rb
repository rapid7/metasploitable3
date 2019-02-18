docker_service 'default' do
  storage_driver 'overlay2'
  bip '10.10.10.0/24'
  default_ip_address_pool 'base=10.10.10.0/16,size=24'
  service_manager 'systemd'
  action [:create, :start]
end
