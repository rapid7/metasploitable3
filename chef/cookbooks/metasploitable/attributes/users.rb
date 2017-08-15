#
# Cookbook:: metasploitable
# Attributes:: users
#

default[:users][:leia_organa] = { username: 'leia_organa',
                                  password: 'help_me_obiwan',
                                  password_hash: '$1$N6DIbGGZ$LpERCRfi8IXlNebhQuYLK/',
                                  first_name: 'Leia',
                                  last_name: 'Organa',
                                  admin: true,
                                  salary: '9560' }

default[:users][:luke_skywalker] = { username: 'luke_skywalker',
                                     password: 'like_my_father_beforeme',
                                     password_hash: '$1$/7D55Ozb$Y/aKb.UNrDS2w7nZVq.Ll/',
                                     first_name: 'Luke',
                                     last_name: 'Skywalker',
                                     admin: true,
                                     salary: '1080'}

default[:users][:han_solo] = { username: 'han_solo',
                               password: 'nerf_herder',
                               password_hash: '$1$6jIF3qTC$7jEXfQsNENuWYeO6cK7m1.',
                               first_name: 'Han',
                               last_name: 'Solo',
                               admin: true,
                               salary: '1200'}

default[:users][:artoo_detoo] = { username: 'artoo_detoo',
                                  password: 'b00p_b33p',
                                  password_hash: '$1$tfvzyRnv$mawnXAR4GgABt8rtn7Dfv.',
                                  first_name: 'Artoo',
                                  last_name: 'Detoo',
                                  admin: false,
                                  salary: '22222'}

default[:users][:c_three_pio] = { username: 'c_three_pio',
                                  password: 'Pr0t0c07',
                                  password_hash: '$1$lXx7tKuo$xuM4AxkByTUD78BaJdYdG.',
                                  first_name: 'C',
                                  last_name: 'Threepio',
                                  admin: false,
                                  salary: '3200'}

default[:users][:ben_kenobi] = { username: 'ben_kenobi',
                                 password: 'thats_no_m00n',
                                 password_hash: '$1$5nfRD/bA$y7ZZD0NimJTbX9FtvhHJX1',
                                 first_name: 'Ben',
                                 last_name: 'Kenobi',
                                 admin: false,
                                 salary: '10000'}

default[:users][:darth_vader] = { username: 'darth_vader',
                                  password: 'Dark_syD3',
                                  password_hash: '$1$rLuMkR1R$YHumHRxhswnfO7eTUUfHJ.',
                                  first_name: 'Darth',
                                  last_name: 'Vader',
                                  admin: false,
                                  salary: '6666'}

default[:users][:anakin_skywalker] = { username: 'anakin_skywalker',
                                       password: 'but_master:(',
                                       password_hash: '$1$jlpeszLc$PW4IPiuLTwiSH5YaTlRaB0',
                                       first_name: 'Anakin',
                                       last_name: 'Skywalker',
                                       admin: false,
                                       salary: '1025'}

default[:users][:jarjar_binks] = { username: 'jarjar_binks',
                                   password: 'mesah_p@ssw0rd',
                                   password_hash: '$1$SNokFi0c$F.SvjZQjYRSuoBuobRWMh1',
                                   first_name: 'Jar-Jar',
                                   last_name: 'Binks',
                                   admin: false,
                                   salary: '2048'}

default[:users][:lando_calrissian] = { username: 'lando_calrissian',
                                       password: '@dm1n1str8r',
                                       password_hash: '$1$Af1ek3xT$nKc8jkJ30gMQWeW/6.ono0',
                                       first_name: 'Lando',
                                       last_name: 'Calrissian',
                                       admin: false,
                                       salary: '40000'}

default[:users][:boba_fett] = { username: 'boba_fett',
                                password: 'mandalorian1',
                                password_hash: '$1$TjxlmV4j$k/rG1vb4.pj.z0yFWJ.ZD0',
                                first_name: 'Boba',
                                last_name: 'Fett',
                                admin: false,
                                salary: '20000'}

default[:users][:jabba_hutt] = { username: 'jabba_hutt',
                                 password: 'my_kinda_skum',
                                 password_hash: '$1$9rpNcs3v$//v2ltj5MYhfUOHYVAzjD/',
                                 first_name: 'Jaba',
                                 last_name: 'Hutt',
                                 admin: false,
                                 salary: '65000'}

default[:users][:greedo] = { username: 'greedo',
                             password: 'hanSh0tF1rst',
                             password_hash: '$1$vOU.f3Tj$tsgBZJbBS4JwtchsRUW0a1',
                             first_name: 'Greedo',
                             last_name: 'Rodian',
                             admin: false,
                             salary: '50000'}

default[:users][:chewbacca] = { username: 'chewbacca',
                                password: 'rwaaaaawr8',
                                password_hash: '$1$.qt4t8zH$RdKbdafuqc7rYiDXSoQCI.',
                                first_name: 'Chewbacca',
                                last_name: '',
                                admin: false,
                                salary: '4500'}

default[:users][:kylo_ren] = { username: 'kylo_ren',
                               password: 'Daddy_Issues2',
                               password_hash: '$1$rpvxsssI$hOBC/qL92d0GgmD/uSELx.',
                               first_name: 'Kylo',
                               last_name: 'Ren',
                               admin: false,
                               salary: '6667'}
