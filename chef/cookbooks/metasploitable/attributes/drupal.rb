default[:drupal][:files_path] = File.join(default[:metasploitable][:files_path], 'drupal')
default[:drupal][:install_dir] = '/var/www/html/drupal'
default[:drupal][:sites_dir] = File.join(default[:drupal][:install_dir], 'sites')
default[:drupal][:all_site_dir] = File.join(default[:drupal][:sites_dir], 'all')
default[:drupal][:default_site_dir] = File.join(default[:drupal][:sites_dir], 'default')
default[:drupal][:version] = '7.5'
default[:drupal][:download_url] = 'https://ftp.drupal.org/files/projects'