$ip=get-WmiObject Win32_NetworkAdapterConfiguration|Where {$_.IPAddress -gt 1}

if ($ip.count -gt 0) {
  $ip = $ip[0]
}

if ($ip.IPAddress.count -gt 0) {
  $ipaddr = $ip.IPAddress[0]
} else {
  $ipaddr = $ip[0].ipaddress[0]
}

Write-Host "Updating Wordpress IP to $ipaddr"

$cmd = 'C:\wamp\bin\mysql\mysql5.5.20\bin\mysql.exe -u root --password="" -e "use wordpress; update wp_options set option_value=''http://'+$ipaddr+':8585/wordpress'' where option_name=''siteurl'';"'
iex $cmd

$cmd = 'C:\wamp\bin\mysql\mysql5.5.20\bin\mysql.exe -u root --password="" -e "use wordpress; update wp_options set option_value=''http://'+$ipaddr+':8585/wordpress'' where option_name=''home'';"'
iex $cmd


$fsdata = 'a:4:{s:11:""""plugin_data"""";a:1:{s:11:""""ninja-forms"""";a:12:{s:16:""""plugin_main_file"""";O:8:""""stdClass"""":1:{s:4:""""path"""";s:68:""""C:/wamp/www/wordpress/wp-content/plugins/ninja-forms/ninja-forms.php"""";}s:17:""""install_timestamp"""";i:1474928961;s:16:""""sdk_last_version"""";N;s:11:""""sdk_version"""";s:7:""""1.1.7.4"""";s:16:""""sdk_upgrade_mode"""";b:1;s:18:""""sdk_downgrade_mode"""";b:0;s:19:""""plugin_last_version"""";s:3:""""2.9"""";s:14:""""plugin_version"""";s:3:""""3.0"""";s:19:""""plugin_upgrade_mode"""";b:1;s:21:""""plugin_downgrade_mode"""";b:0;s:17:""""connectivity_test"""";a:6:{s:12:""""is_connected"""";b:0;s:4:""""host"""";s:15:""""'+$ipaddr+':8585"""";s:9:""""server_ip"""";s:10:""""'+$ipaddr+'"""";s:9:""""is_active"""";b:0;s:9:""""timestamp"""";i:1474929068;s:7:""""version"""";s:3:""""3.0"""";}s:21:""""is_plugin_new_install"""";b:0;}}s:13:""""file_slug_map"""";a:1:{s:27:""""ninja-forms/ninja-forms.php"""";s:11:""""ninja-forms"""";}s:7:""""plugins"""";a:1:{s:11:""""ninja-forms"""";O:9:""""FS_Plugin"""":15:{s:16:""""parent_plugin_id"""";N;s:5:""""title"""";s:11:""""Ninja Forms"""";s:4:""""slug"""";s:11:""""ninja-forms"""";s:4:""""file"""";s:27:""""ninja-forms/ninja-forms.php"""";s:7:""""version"""";s:3:""""3.0"""";s:11:""""auto_update"""";N;s:4:""""info"""";N;s:10:""""is_premium"""";b:0;s:7:""""is_live"""";b:1;s:10:""""public_key"""";s:32:""""pk_f2f84038951d45fc8e4ff9747da6d"""";s:10:""""secret_key"""";N;s:2:""""id"""";s:3:""""209"""";s:7:""""updated"""";N;s:7:""""created"""";N;s:22:""""\0FS_Entity\0_is_updated"""";b:1;}}s:9:""""unique_id"""";s:32:""""4e1a08c6c12be350ecd6a3e75930716c"""";}'


$cmd = 'C:\wamp\bin\mysql\mysql5.5.20\bin\mysql.exe -u root --password="" -e "use wordpress; update wp_options set option_value='''+$fsdata+''' where option_name=''fs_accounts'';"'
iex $cmd
