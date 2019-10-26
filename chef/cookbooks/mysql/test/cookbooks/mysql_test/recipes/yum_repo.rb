# Before that, we use "native" versions

unless node['mysql'].nil?
  case node['mysql']['version']
  when '5.5'
    include_recipe 'yum-mysql-community::mysql55'
  when '5.6'
    include_recipe 'yum-mysql-community::mysql56'
  when '5.7'
    include_recipe 'yum-mysql-community::mysql57'
  end
end
