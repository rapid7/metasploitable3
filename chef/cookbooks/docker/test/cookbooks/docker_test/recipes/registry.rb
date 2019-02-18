# We're going to need some SSL certificates for testing.

caroot = '/tmp/registry/tls'

directory caroot.to_s do
  recursive true
  action :create
end

# Self signed CA
bash 'generating CA private and public key' do
  cmd = 'openssl req'
  cmd += ' -x509'
  cmd += ' -nodes'
  cmd += ' -days 365'
  cmd += ' -sha256'
  cmd += " -subj '/CN=kitchen2docker/'"
  cmd += ' -newkey rsa:4096'
  cmd += " -keyout #{caroot}/ca-key.pem"
  cmd += " -out #{caroot}/ca.pem"
  cmd += ' 2>&1>/dev/null'
  code cmd
  not_if "/usr/bin/test -f #{caroot}/ca-key.pem"
  not_if "/usr/bin/test -f #{caroot}/ca.pem"
  action :run
end

# server certs
bash 'creating private key for docker server' do
  code "openssl genrsa -out #{caroot}/server-key.pem 4096"
  not_if "/usr/bin/test -f #{caroot}/server-key.pem"
  action :run
end

bash 'generating certificate request for server' do
  cmd = 'openssl req'
  cmd += ' -new'
  cmd += ' -sha256'
  cmd += " -subj '/CN=#{node['hostname']}/'"
  cmd += " -key #{caroot}/server-key.pem"
  cmd += " -out #{caroot}/server.csr"
  code cmd
  not_if "/usr/bin/test -f #{caroot}/server.csr"
  action :run
end

file "#{caroot}/server-extfile.cnf" do
  content "subjectAltName = IP:#{node['ipaddress']},IP:127.0.0.1\n"
  action :create
end

bash 'signing request for server' do
  cmd = 'openssl x509'
  cmd += ' -req'
  cmd += ' -days 365'
  cmd += ' -sha256'
  cmd += " -CA #{caroot}/ca.pem"
  cmd += " -CAkey #{caroot}/ca-key.pem"
  cmd += ' -CAcreateserial'
  cmd += " -in #{caroot}/server.csr"
  cmd += " -out #{caroot}/server.pem"
  cmd += " -extfile #{caroot}/server-extfile.cnf"
  not_if "/usr/bin/test -f #{caroot}/server.pem"
  code cmd
  action :run
end

# client certs
bash 'creating private key for docker client' do
  code "openssl genrsa -out #{caroot}/key.pem 4096"
  not_if "/usr/bin/test -f #{caroot}/key.pem"
  action :run
end

bash 'generating certificate request for client' do
  cmd = 'openssl req'
  cmd += ' -new'
  cmd += " -subj '/CN=client/'"
  cmd += " -key #{caroot}/key.pem"
  cmd += " -out #{caroot}/client.csr"
  code cmd
  not_if "/usr/bin/test -f #{caroot}/client.csr"
  action :run
end

file "#{caroot}/client-extfile.cnf" do
  content "extendedKeyUsage = clientAuth\n"
  action :create
end

bash 'signing request for client' do
  cmd = 'openssl x509'
  cmd += ' -req'
  cmd += ' -days 365'
  cmd += ' -sha256'
  cmd += " -CA #{caroot}/ca.pem"
  cmd += " -CAkey #{caroot}/ca-key.pem"
  cmd += ' -CAcreateserial'
  cmd += " -in #{caroot}/client.csr"
  cmd += " -out #{caroot}/cert.pem"
  cmd += " -extfile #{caroot}/client-extfile.cnf"
  code cmd
  not_if "/usr/bin/test -f #{caroot}/cert.pem"
  action :run
end

# Set up a test registry to test :push
# https://github.com/docker/distribution/blob/master/docs/authentication.md
#

docker_image 'nginx' do
  tag '1.9'
end

docker_image 'registry' do
  tag '2.6.1'
end

directory '/tmp/registry/auth' do
  recursive true
  owner 'root'
  mode '0755'
  action :create
end

template '/tmp/registry/auth/registry.conf' do
  source 'registry/auth/registry.conf.erb'
  owner 'root'
  mode '0755'
  action :create
end

# install certificates
execute 'copy server cert for registry' do
  command "cp #{caroot}/server.pem /tmp/registry/auth/server.crt"
  creates '/tmp/registry/auth/server.crt'
  action :run
end

execute 'copy server key for registry' do
  command "cp #{caroot}/server-key.pem /tmp/registry/auth/server.key"
  creates '/tmp/registry/auth/server.key'
  action :run
end

# testuser / testpassword
template '/tmp/registry/auth/registry.password' do
  source 'registry/auth/registry.password.erb'
  owner 'root'
  mode '0755'
  action :create
end

bash 'start docker registry' do
  code <<-EOF
  docker run \
  -d \
  -p 5000:5000 \
  --name registry_service \
  --restart=always \
  registry:2
  EOF
  not_if "[ ! -z `docker ps -qaf 'name=registry_service$'` ]"
end

bash 'start docker registry proxy' do
  code <<-EOF
  docker run \
  -d \
  -p 5043:443 \
  --name registry_proxy \
  --restart=always \
  -v /tmp/registry/auth/:/etc/nginx/conf.d \
  nginx:1.9
  EOF
  not_if "[ ! -z `docker ps -qaf 'name=registry_proxy$'` ]"
end

bash 'wait for docker registry and proxy' do
  code <<-EOF
  i=0
  tries=20
  while true; do
    ((i++))
    netstat -plnt | grep ":5000" && netstat -plnt | grep ":5043"
    [ $? -eq 0 ] && break
    [ $i -eq $tries ] && break
    sleep 1
  done
  EOF
  not_if 'netstat -plnt | grep ":5000" && netstat -plnt | grep ":5043"'
end
