#
# Cookbook:: metasploitable
# Recipe:: users
#
# Copyright:: 2017, Rapid7, All Rights Reserved.

# See scripts/configs/create_users.bat for passwords

users = {'leah_organa' => { password: '$1$2ny4/xaH$tAFV5fbEqHx2OkOPIQhpx0' },
         'luke_skywalker' => { password: '$1$n8tgrGRs$8xaS40CFS1J5iIAEmbnx50' },
         'han_solo' => { password: '$1$L/2/AWAh$ZMUulbFhP2IesZ6xwBmaV0' },
         'artoo_detoo' => { password: '$1$DlEuqBUm$u71bKO9I603kDCqEphmon1' },
         'c_three_pio' => { password: '$1$4JMoAFqs$b5MwsiCfOASdUKktx6wQ7/' },
         'ben_kenobi' => { password: '$1$vmHrrI9b$OyLulJjgi18GxgREG5V5c1' },
         'darth_vader' => { password: '$1$c7AfQJ86$zvcdz7pPate7GdCQ.yfTf0' },
         'anakin_skywalker' => { password: '$1$AvIldIHu$o1s2OCU4n/qSCGQMKMgkH/' },
         'jarjar_binks' => { password: '$1$SNokFi0c$F.SvjZQjYRSuoBuobRWMh1' },
         'lando_calrissian' => { password: '$1$8aWC7zHq$bz6K2rZVD7XlMNqBIIMGX.' },
         'boba_fett' => { password: '$1$TjxlmV4j$k/rG1vb4.pj.z0yFWJ.ZD0' },
         'jabba_hutt' => { password: '$1$1q5jRHYC$LIp/8O/g9qg3NaeGOxGSl/' },
         'greedo' => { password: '$1$1lmZ0rOJ$GITT5.sX0tvOQeC2/wWQF1' },
         'chewbacca' => { password: '$1$AjU5ZLh9$WjO.j9fYh3yms3HSDBKya1' },
         'kylo_ren' => { password: '$1$Zcw3AKDA$1Mjgzmr/HpmFXuxUjj2Vv1' }
        }
uid = 1111

users.each do |username, opts|
  user username do
    manage_home true
    password opts[:password]
    uid uid
    gid '100'
    home "/home/#{username}"
    shell '/bin/bash'
  end
  uid += 1
end
