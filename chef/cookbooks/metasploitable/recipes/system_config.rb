# See https://www.openssl.org/blog/blog/2021/09/13/LetsEncryptRootCertExpire/ and https://github.com/chef/chef/issues/12126

bash 'disable expired DST Root CA X3 certificate' do
    code <<-EOS 
        sed -i 's:^mozilla/DST_Root_CA_X3.crt:!mozilla/DST_Root_CA_X3.crt:' /etc/ca-certificates.conf
        update-ca-certificates
    EOS
    not_if "grep -q '^!mozilla/DST_Root_CA_X3.crt' /etc/ca-certificates.conf"
end

ENV['SSL_CERT_FILE'] = '/etc/ssl/certs/ca-certificates.crt'
