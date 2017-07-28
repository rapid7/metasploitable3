%w(unit lint syntax).each do |phase|
  # TODO: This works on Linux/Unix. Not Windows.
  execute "HOME=/home/vagrant delivery job verify #{phase} --server localhost --ent test --org kitchen" do
    cwd '/tmp/repo-data'
    user 'vagrant'
    environment('GIT_DISCOVERY_ACROSS_FILESYSTEM' => '1')
  end
end
