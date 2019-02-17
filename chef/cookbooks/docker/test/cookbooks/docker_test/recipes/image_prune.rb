#########################
# :prune
#########################

docker_image_prune 'hello-world' do
  dangling true
end

docker_image_prune 'prune-old-images' do
  dangling true
  prune_until '1h30m'
  with_label 'com.example.vendor=ACME'
  without_label 'no_prune'
  action :prune
end
